# AGENTS.md

このリポジトリで Claude Code (claude.ai/code) が作業する際のガイドラインです。

## 言語

- 応答言語: プラン、説明、返答は常に日本語で行う。コードやコマンド、技術用語はそのまま使用してよい。
- PR 本文: プルリクエストの本文（body）は日本語で記述する。

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

- PR のマージは必ずユーザーが手動で行う。AI アシスタントが `gh pr merge` や GitHub API 経由でマージを実行してはならない。
- PR の作成・更新・push は許可するが、マージの最終判断は常にユーザーに委ねること。
- PR タイトルは英語 semantic 形式で、CI の semantic pull request チェックに従う。詳細は [.github/workflows/_pull-request.yaml](.github/workflows/_pull-request.yaml) を参照。

## アーキテクチャ概要

`renovate` は Renovate Bot の共有設定パッケージです。

- `default.json`: 主設定（`extends` や best practices を組み合わせている）
- `.github/workflows/`: CI（format / validate / actionlint / secretlint / PR title check 等）
- `bin/cli.sh`: npm/pnpm 経由で `npx -y @nozomiishii/renovate@latest` を実行するための CLI

## 重要なパターン

- 変更は基本的に `default.json` を中心に行い、更新後は `pnpm validate` で strict に検証する。
- JSON の編集後は `pnpm format` / `pnpm prettier` を必ず反映させる。

