---
status: accepted
date: 2026-08-12
---

# regex custom manager の docker 依存は digest pin しない

## 背景と課題

`1password/load-secrets-action` の `version:` を Renovate に追従させたら、nozomiishii/dev で update-failure が毎回出るようになった。

```
zizmor が version: にリテラル pin を要求する
  ↓
op CLI は npm にも GitHub releases にも無い
  ↓
clean semver タグを持つ Docker Hub の 1password/op を version oracle にする
  ↓
config:best-practices の docker:pinDigests が datasource で一致する
  ↓
この custom manager の依存にも pinDigests: true が付く
  ↓
version: にはハッシュを書き足す文法上の場所が無い
  ↓
Renovate は差分ゼロのまま自身の検証に落ちる
  ↓
Dependency Dashboard に Errored の pin 1password/op docker tag が毎回出る
```

zizmor の [unpinned-tools audit](https://docs.zizmor.sh/audits/#unpinned-tools) は、`1password/load-secrets-action` の `version:` 入力が未指定か `latest` だと検出する。[#679](https://github.com/nozomiishii/renovate/pull/679) で `# renovate:` コメント + regex custom manager による追従を追加した。extends している `config:best-practices` に [`docker:pinDigests`](https://docs.renovatebot.com/presets-docker/#dockerpindigests) が入っている。

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

## 検討した選択肢

- `version:` にハッシュを書き足す: digest pin を成立させるにはこう書くしかないが、action はこの文字列をバージョン番号として解釈できず壊れる

  ```yaml
  version: "2.38.1@sha256:9c1824a…"
  ```

  仮に digest を書けたとしても、pin されるのは Docker Hub のイメージのハッシュで、実行時にダウンロードされるのは 1Password CDN の CLI バイナリ。別物なので守れるものがない

- datasource を docker 以外にする: バージョン取得元として他に選択肢がない

- `custom.regex` manager × docker datasource の組だけ `pinDigests: false` にする: 成立しない digest pin だけを外せる

## 決定

- packageRules に `matchManagers: ["custom.regex"]` と `matchDatasources: ["docker"]` の組で `pinDigests: false` を追加する
- datasource は docker のまま維持する
- 無効化するのは digest pin だけ。バージョン文字列の追従は今までどおり動かす

## 結果

### 良くなったこと

- dev の Dependency Dashboard から Errored が消える
- Dockerfile など docker 系 manager の digest pin と、lefthook の bunx 追従 (custom.regex manager × npm datasource) には影響しない
- 同じ `# renovate:` 書式で docker datasource の依存を増やしても再発しない
- zizmor unpinned-tools が求めるリテラル pin は満たしたまま

### 引き受けたコスト

なし

### 保留した論点

なし
