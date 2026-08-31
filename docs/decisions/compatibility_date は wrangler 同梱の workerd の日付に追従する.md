---
status: accepted
date: 2026-08-31
---

# compatibility_date は wrangler 同梱の workerd の日付に追従する

## 背景と課題

compatibility_date を放置すると、新機能が date でゲートされたまま使えず、最新 date 前提で書かれる公式ドキュメントと実挙動がずれていく。Renovate に公式の manager が無く手動更新が前提だった。i18n-pilot への Cloudflare Workers 導入を機に、wrangler の更新と同じ PR で date も追従させる。date の一覧を返す API は無いので、何をバージョン情報源にするかが論点になった。

## 検討した選択肢

- 手動更新のまま changelog を購読: 月次まとめの刊行物が無く、日次の changelog を人が追うことになる。更新漏れが常態化する
- workerd packument の全リリース日: workerd は日次リリースで、PR が毎日更新される。提案 date が利用側 wrangler の同梱 workerd の日付を超え、wrangler dev / miniflare が拒否して CI が赤い期間が定常化する
- github-tags datasource で cloudflare/workerd: タグ `v1.20250801.0` から数字は取れるが、`2025-08-01` 形式へ変換する手段が datasource にも versioning にも無い。[この方式の唯一の公開 preset](https://github.com/nemolize/renovate-config/pull/6) も、ファイル側の値に extractVersion が効かず全スキップになることを実機で確認した
- workerd packument + schedule 月 1: 頻度は下がるが上限超えの構造問題は残る
- wrangler の latest manifest の dependencies.workerd: 最新 wrangler が確実にサポートする上限 date だけが提案される。更新は wrangler リリースに連動し、グループ PR で wrangler の bump と同時に来る

## 決定

- customDatasource で [wrangler の latest manifest](https://registry.npmjs.org/wrangler/latest) を取得し、JSONata で `dependencies.workerd` の `1.<YYYYMMDD>.<patch>` を `YYYY-MM-DD` 1 件の releases に変換する
- versioning は regex で年を major、月を minor、日を patch として比較する。automerge は default.json に従い、年替わりだけ major として手動レビューになる。compatibility flag の default-on は月 2〜3 個で大半は機能追加系なので、月内・月替わりの bump は CI に任せる
- この datasource は releaseTimestamp を返さないため、default.json の minimumReleaseAge 3 日が pending 永続として効いて PR が出なくなる。提案されるのは wrangler が対応済みの date だけで待つ意味も無いので、packageRules で minimumReleaseAge を解除する

## 結果

### 良くなったこと

- date の更新が wrangler の更新と同一 PR で来て、CI で一緒に検証される
- 最新 wrangler が対応していない date は提案されない

### 引き受けたコスト

- 保証されるのは最新 wrangler の上限だけ。利用側が古い wrangler のまま更新 PR を寝かせている間は、date が手元の wrangler の上限を超えて CI が赤くなりうる
- date の追従は最新 wrangler のリリースより先に進めない
- グループ化のマッチは、Renovate が lookup 前に `packageName ??= depName` で合成 dep を補完する内部挙動に依存する

### 保留した論点

- 公式 manager が出たときの剥がし。renovatebot/renovate に追跡できる issue が無いことを確認済み。剥がし方は README の Presets 節に記載
