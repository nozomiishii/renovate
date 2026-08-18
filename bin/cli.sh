#!/bin/bash

# エラー・未定義変数・パイプラインの失敗で終了し、リダイレクトによる上書きを防ぐ
set -Ceuo pipefail

echo -e "Creating .github/renovate.json"
mkdir -p .github
echo '{ "extends": ["github>nozomiishii/renovate"] }' > .github/renovate.json

echo -e "All set! Your Renovate configuration has been set up successfully🎉"
