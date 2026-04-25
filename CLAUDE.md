# CLAUDE.md

このリポジトリで Claude Code (claude.ai/code) が作業する際のガイドラインです。

## よく使うコマンド

```sh
# Prettier check
pnpm format

# Prettier format
pnpm format:fix

# Prettier (write)
pnpm prettier

# Renovate config validation
pnpm validate
```

## Git・GitHub 運用ルール

- PR タイトルは英語 semantic 形式で、CI の semantic pull request チェックに従う。詳細は [.github/workflows/_pull-request.yaml](.github/workflows/_pull-request.yaml) を参照。

## アーキテクチャ概要

`renovate` は Renovate Bot の共有設定パッケージです。

- `default.json`: 主設定（`extends` や best practices を組み合わせている）
- `.github/workflows/`: CI（format / validate / actionlint / secretlint / PR title check 等）
- `bin/cli.sh`: npm/pnpm 経由で `npx -y @nozomiishii/renovate@latest` を実行するための CLI

## 重要なパターン

- 変更は基本的に `default.json` を中心に行い、更新後は `pnpm validate` で strict に検証する。
- JSON の編集後は `pnpm format` / `pnpm prettier` を必ず反映させる。

## リリース・Conventional Commits

- `BREAKING CHANGE:` フッターと `feat!:` / `fix!:` の `!` 修飾は、**リリースされるパッケージ・公開アセットの互換性を破る変更にのみ**使用する。CI / workflows / branch protection / リポジトリ運用上の変更には使わない。これらの注意事項は PR 本文に記述する（release-please など自動リリースツールが major / minor バンプを誤って行い、CHANGELOG に `⚠ BREAKING CHANGES` セクションを誤生成するのを防ぐため。実例: 2026-04-25 にこのリポジトリ群で `chore: migrate reusable workflows to v3.0.0` PR が誤って BREAKING CHANGE として記録された）。
