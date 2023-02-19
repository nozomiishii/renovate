#!/bin/bash
set -Ceu

PROJECT_NAME="nozomiishii/renovate"
username=$(whoami)

printf "\n"
echo "🎉Hey ${username}, Welcome to ${PROJECT_NAME:-our project}!!"

printf "\n\n⏳ Initialization in progress...\n\n"

# ----------------------------------------------------------------
# Node.js Corepack
# ----------------------------------------------------------------
if ! type node > /dev/null 2>&1; then
  echo "ERROR: Nodejs must be installed🥲"
  exit 1
fi

printf "🐉: Enable corepack...\n"
corepack enable
corepack enable npm
yarn -v
printf "Enable corepack completed\n\n"

printf "🐉: Install Node modules...\n"
yarn install
printf "Install Node modules completed\n\n"

# ----------------------------------------------------------------
# Lefthook
# ----------------------------------------------------------------
if [ ! -f lefthook-local.yaml ]; then
  printf "🥊: Setup lefthook...\n"
  npx -y lefthook install
  touch lefthook-local.yaml
  printf "Setup lefthook completed\n\n"
fi

# ----------------------------------------------------------------
# Git
# ----------------------------------------------------------------
printf "😼: Setup git config...\n"
git config core.ignorecase false
printf "Setup git config completed\n\n"

printf "\n🚀Awesome!! Initialization of the development environment is complete!\n\n"
