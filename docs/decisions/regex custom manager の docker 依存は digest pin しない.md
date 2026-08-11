# regex custom manager の docker 依存は digest pin しない

Status: accepted
Date: 2026-08-12

## Context — 判断を迫られた状況

zizmor の [unpinned-tools audit](https://docs.zizmor.sh/audits/#unpinned-tools) は `1password/load-secrets-action` の `version:` 入力が未指定か `latest` だと検出する。リテラル pin が必要になり、[#679](https://github.com/nozomiishii/renovate/pull/679) で `# renovate:` コメント + regex custom manager による追従を追加した。op CLI は npm にも GitHub releases にも存在しないため、clean semver タグを持つ Docker Hub の `1password/op` イメージを version oracle として `datasource=docker` で追従している。

extends している `config:best-practices` は [`docker:pinDigests`](https://docs.renovatebot.com/presets-docker/#dockerpindigests) を含む。マッチ条件は manager ではなく datasource なので、この custom manager の依存にも `pinDigests: true` が付く。

digest pin は image 参照のタグの後ろにハッシュを書き足す更新。Dockerfile の image 参照には digest の置き場が文法として存在するので成立する。

```dockerfile
# before
FROM node:24.19.0
# after: タグの後ろに digest を書き足す
FROM node:24.19.0@sha256:8dca8a3b…
```

追従対象の workflow はこう書いている。`version:` は action の入力パラメータであって image 参照ではなく、action はこの文字列で 1Password CDN から CLI バイナリをダウンロードする。

```yaml
- uses: 1password/load-secrets-action@e544b780… # action 本体の digest pin は uses: 側で済んでいる
  with:
    # renovate: datasource=docker depName=1password/op versioning=semver
    version: "2.38.1" # 問題の依存はここ
```

digest pin を成立させるにはこう書くしかないが、action はこの文字列をバージョン番号として解釈できず壊れる。digest を書き足す文法上の場所がない。

```yaml
version: "2.38.1@sha256:9c1824a…"
```

Renovate は「version 据え置き + digest 追記」の差分を作れず、ファイルが 1 文字も変わらないまま自身の検証に落ちる。これが nozomiishii/dev の Dependency Dashboard に Errored の pin 1password/op docker tag として毎回現れていた update-failure の正体。

仮に digest を書けたとしても、pin されるのは Docker Hub のイメージのハッシュで、実行時にダウンロードされるのは 1Password CDN の CLI バイナリ。別物なので守れるものがない。

## Decision — 決めたこと

- packageRules に `matchManagers: ["custom.regex"]` と `matchDatasources: ["docker"]` の組で `pinDigests: false` を追加する
- datasource は docker のまま維持する。バージョン取得元として他に選択肢がない
- 無効化するのは digest pin だけ。バージョン文字列の追従は今までどおり動かす

## Consequences — 決定がもたらすもの

- dev の Dependency Dashboard から Errored が消える
- Dockerfile など docker 系 manager の digest pin と、lefthook の bunx 追従 (custom.regex × npm) には影響しない
- 同じ `# renovate:` 書式で docker datasource の依存を増やしても再発しない
- zizmor unpinned-tools が求めるリテラル pin は満たしたまま
