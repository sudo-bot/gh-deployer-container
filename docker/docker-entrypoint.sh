#!/bin/sh

set -e

echo 'Setup ENVs'

# Defined by the deployer
printf "env[RANDOM_STRING] = '%s';\nenv[DEPLOY_SHA] = '%s';\nenv[DEPLOY_BRANCH] = '%s';\n" \
    "$RANDOM_STRING" "${GIT_SHA:--}" "${GIT_BRANCH:--}" >> /etc/php7/php-fpm.d/www.conf

if [ -n "$REF_DIRECTORY" ]; then
    REF_DIR="--reference $REF_DIRECTORY"
else
    REF_DIR=""
fi

WWW_ROOT='/home/www/phpMyAdmin'

set -x
echo 'Cloning ...'

if [ ! -d "${WWW_ROOT}/.git" ]; then
    echo "Cloning dir !"

    git clone $REF_DIR --depth 1 --branch "${GIT_BRANCH}" "$GIT_URL" "${WWW_ROOT}"
    cd "${WWW_ROOT}"
    if [ ! -z "${GIT_SHA}" ]; then
        git reset --hard "${GIT_SHA}"
    else
        printf 'GIT_SHA ENV is empty, skipping.'
    fi
    cd - > /dev/null
else
    echo "Repo exists at ${WWW_ROOT}"
fi

if [ -z "${GIT_SHA}" ]; then
    echo 'Using git pull'
    cd ${WWW_ROOT}
    git checkout "${GIT_BRANCH}"
    git pull --ff-only
    cd - > /dev/null
fi

if [ ! -d "${WWW_ROOT}/tmp" ]; then
    echo "Creating temp dir !"
    mkdir "${WWW_ROOT}/tmp"
    chmod 777 "${WWW_ROOT}/tmp"
else
    echo "Temp dir exists at ${WWW_ROOT}"
fi

if [ -n "$PMA_CONFIG" ]; then
    echo "$PMA_CONFIG" | base64 -d > "${WWW_ROOT}/config.inc.php"
else
    echo 'No PMA_CONFIG ENV found';
    cp /config.inc.php "${WWW_ROOT}/config.inc.php"
fi

echo 'Launch final deploy'

/deploy-branch.sh "${WWW_ROOT}" "$GIT_BRANCH" "$GIT_SHA"

echo 'Starting the services'

php-fpm7

nginx -g 'pid /tmp/nginx.pid; daemon off;'
