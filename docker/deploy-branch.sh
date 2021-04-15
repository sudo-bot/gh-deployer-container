#!/bin/sh

set -ex

echo "Deploying ... Dir:$1 Branch:$2 Hash:$3"

cd "$1"

if [ -f composer.lock ]; then
    rm ./composer.lock
fi

rm -rf ./vendor
rm -rf ./node_modules
rm -rf ./tmp/*

composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader
yarn install --frozen-lockfile --production --cache-folder "$HOME/.yarn" --network-concurrency 1

if [ -f composer.lock ]; then
    rm ./composer.lock
fi

echo "Generating mo files..."
./scripts/generate-mo
INFOS=$(git show -s --format="%s%n%GS%n%H" "${2:-$3}")
echo "Deployed ! Dir:$1 Branch:$2 Infos:$3 $INFOS"

cd - > /dev/null
