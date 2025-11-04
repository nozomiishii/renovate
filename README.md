# Renovate

Nozomi's Recommended [Renovate](https://docs.renovatebot.com/) Config.

<!-- Main Image -->
<br>
<div align="center">
  <img src="https://media.giphy.com/media/f7b9ltJ4FrhnsKjYx2/giphy.gif" alt="Coding" width="480" />
</div>
<div align="right">
  <small>via TLC Europe on GIPHY</small>
</div>
<br>
<!-- shields -->
<div align="center">
  <a target="_blank" href="https://badge.fury.io/js/@nozomiishii%2Frenovate">
    <img alt="npm version" src="https://badge.fury.io/js/@nozomiishii%2Frenovate.svg">
  </a>
  <a target="_blank" href="https://open.vscode.dev/nozomiishii/renovate">
    <img alt="Open in VSCode" src="https://img.shields.io/static/v1?logo=visualstudiocode&label=&message=Open%20in%20VSCode&labelColor=2c2c32&color=007acc&logoColor=007acc">
  </a>
  <a target="_blank" href="https://twitter.com/nozomiishii_dev">
    <img alt="twitter" src="https://img.shields.io/twitter/follow/nozomiishii_dev?style=social&label=Follow">
  </a>
</div>
<br>

## Gist

```bash
npx -y @nozomiishii/renovate@latest
```

## Manual

```bash
mkdir -p .github
```

```bash
echo '{ "extends": ["github>nozomiishii/renovate"] }' > .github/renovate.json
```

## Main

[default.json](./default.json)

## Preference

- `"$schema": "https://docs.renovatebot.com/renovate-schema.json"`
  - 補完出してくれる

- `extends`
  - デフォルトでついてくる`config:base`の必要部分を抽出

- `labels`
  - 自動で作られるPRにラベルがつく

- `"prConcurrentLimit": 0`
  - Limit系は0で設定すると無制限って意味になる

- `stabilityDays`
  - 安定猶予期間を設定。ここで指定した日数が経ってからオートマージされる

- `separateMultipleMajor`
  - メジャーバージョンのPRは個別に出す

- `rangeStrategy`
  - バージョンの上げ方。"pin"にすると^や~がつかない固定バージョンになる

## tips

### 関連するパッケージをグループ化して一緒に更新したい

```json
{
  "groupName": "storybook",
  "matchPackageNames": ["/storybook/"]
}
```

### 特定のバージョンで更新を止めたい

```json
{
  "matchPackageNames": ["eslint"],
  "description": "Not so many rules are supported with flat config",
  "allowedVersions": "8.57.0"
}
```

```json
{
  "matchPackageNames": ["node", "@types/node"],
  "description": "Vercel does not support v22 yet https://vercel.com/docs/functions/runtimes/node-js/node-js-versions",
  "allowedVersions": "22.x"
}
```

### renovateが未対応の場所のバージョン上げたい

```json
{
  "customManagers": [
    {
      "customType": "regex",
      "fileMatch": ["(^|/)package\\.json$"],
      "matchStrings": ["\"nodeVersion\":\\s*\"(?<currentValue>[^\"]+)\""],
      "depNameTemplate": "node",
      "datasourceTemplate": "node-version",
      "versioningTemplate": "node"
    }
  ]
}
```
