# Renovate

English | [日本語](./README.ja.md)

Nozomi's Recommended [Renovate](https://docs.renovatebot.com/) Config.

<!-- Main Image -->
<br>
<div align="center">
  <img src="https://media.giphy.com/media/FsSCH3UTQHIfnLHmBj/giphy.gif" alt="reborn" width="480" />
</div>
<div align="right">
  <small>via GIPHY</small>
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

Configure your GitHub repository to enable vulnerabilityAlerts.

- https://docs.renovatebot.com/configuration-options/#vulnerabilityalerts

```bash
gh repo list \
  --limit 1000 \
  --json name \
  --jq '.[].name' | while read -r repo; do
    echo "Configuring: $repo"
    gh api \
      --method PUT \
      -H "Accept: application/vnd.github+json" \
      "/repos/nozomiishii/$repo/vulnerability-alerts"
done
```

## Main

All settings are consolidated in [default.json](./default.json). See the inline comments for the intent behind each option.

## tips

### Group related packages and update them together

```json
{
  "groupName": "storybook",
  "matchPackageNames": ["/storybook/"]
}
```

### Pin a package to a specific version

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

### Bump versions in places Renovate does not support out of the box

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
