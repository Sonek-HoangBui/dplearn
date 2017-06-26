#!/usr/bin/env bash
set -e

if ! [[ "$0" =~ "./scripts/dep/frontend.sh" ]]; then
  echo "must be run from repository root"
  exit 255
fi

source ${NVM_DIR}/nvm.sh
nvm install v8.1.2

go install -v ./cmd/gen-package-json
gen-package-json --output package.json --logtostderr

echo "Updating frontend dependencies with 'yarn' and 'npm'..."
rm -f ./package-lock.json
yarn install
npm rebuild node-sass --force
yarn install
npm install
# npm install -g tslint

nvm install v8.1.2
nvm alias default 8.1.2
nvm alias default node
which node
node -v
