FROM alpine:3.15

# Metadata params
ARG VCS_REF
ARG BUILD_DATE

COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache --update nginx git curl bash su-exec \
    php8-fpm php8-cli php8-phar php8-mysqli php8-session php8-mbstring \
    php8-iconv php8-xml php8-tokenizer php8-xmlwriter php8-simplexml \
    php8-dom php8-json php8-bz2 php8-curl php8-gd php8-zip php8-pecl-uploadprogress \
    gettext yarn gpg-agent gpg && \
    # https://gitlab.alpinelinux.org/alpine/aports/-/issues/12308
    ln -s /usr/bin/php8 /usr/bin/php && \
    mkdir -p /var/log/php8 && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php8/error.log && \
    nginx -v && php-fpm8 -v && composer --version && php -v && yarn -v && date -R > /build_date && \
    rm -r /tmp/* && \
    printf '{"build_date": "%s", "timestamp": %i}' "$(date -R)" "$(date +%s)" > /build_date.json

COPY nginx-default.conf /etc/nginx/http.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm-www-pool.conf /etc/php8/php-fpm.d/www.conf
COPY \
    config.inc.php \
    deploy-branch.sh \
    docker-entrypoint.sh \
    /

# Metadata
LABEL org.label-schema.vendor="Sudo-Bot" \
    org.label-schema.url="https://github.com/sudo-bot/gh-deployer-container#readme" \
    org.label-schema.name="gh-deployer container" \
    org.label-schema.description="gh-deployer container for @sudo-bot/gh-deployer" \
    org.label-schema.version=${RELEASE_VERSION} \
    org.label-schema.vcs-url="https://github.com/sudo-bot/gh-deployer-container.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.schema-version="1.0"

EXPOSE 80

CMD ["/docker-entrypoint.sh"]
