# @nozomiishii/renovate

Nozomi's Recommended [Renovate](https://docs.renovatebot.com/) Config.

<!-- Main Image -->
<br>
<div align="center">
  <img src="https://media.giphy.com/media/f7b9ltJ4FrhnsKjYx2/giphy.gif" alt="Coding" width="480" />
</div>
<br>

## Gist

```bash
echo '{ "extends": ["github>nozomiishii/renovate"] }' > .github/renovate.json
```

## Preference

- `"$schema": "https://docs.renovatebot.com/renovate-schema.json"`
  - 補完出してくれる

- `extends`
  - デフォルトでついてくる`config:base`の必要部分を抽出

- `labels`
  - 自動で作られるPRにラベルがつく

- `"prConcurrentLimit": 0`
  - Limit系は0で設定すると無制限って意味になる

- `separateMultipleMajor`
  - メジャーバージョンのPRは個別に出す

- `rangeStrategy`
  - バージョンの上げ方。"pin"にすると^や~がつかない固定バージョンになる
