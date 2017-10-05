#!/usr/bin/env bash
set -e

if ! [[ "$0" =~ "./scripts/dep/frontend.sh" ]]; then
  echo "must be run from repository root"
  exit 255
fi

<<COMMENT
SKIP_REBUILD=1 ./scripts/dep/frontend.sh
COMMENT

source ${NVM_DIR}/nvm.sh
nvm install v8.6.0

go install -v ./cmd/gen-frontend-dep
gen-frontend-dep \
  -output-package-json package.json \
  -output-angular-cli-json angular-cli.json \
  -logtostderr

echo "Updating frontend dependencies with 'yarn' and 'npm'..."
rm -f ./package-lock.json
yarn install
if [[ "${SKIP_REBUILD}" ]]; then
  echo "SKIP_REBUILD is defined; skipping..."
else
  echo "SKIP_REBUILD is not defined; rebuilding..."
  npm rebuild node-sass --force
  yarn install
fi
npm install

nvm install v8.6.0
nvm alias default 8.6.0
nvm alias default node
which node
node -v
