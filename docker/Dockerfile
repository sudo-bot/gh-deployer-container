FROM alpine:3.17

# Metadata params
ARG VCS_REF
ARG BUILD_DATE

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache --update nginx git curl bash su-exec \
    php81-fpm php81-cli php81-phar php81-mysqli php81-session php81-mbstring \
    php81-iconv php81-xml php81-tokenizer php81-xmlwriter php81-simplexml \
    php81-dom php81-json php81-bz2 php81-curl php81-gd php81-zip php81-pecl-uploadprogress \
    gettext yarn gpg-agent gpg && \
    mkdir -p /var/log/php81 && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php81/error.log && \
    nginx -v && php-fpm81 -v && composer --version && php -v && yarn -v && date -R > /build_date && \
    rm -r /tmp/* && \
    printf '{"build_date": "%s", "timestamp": %i}' "$(date -R)" "$(date +%s)" > /build_date.json

COPY nginx-default.conf /etc/nginx/http.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm-www-pool.conf /etc/php81/php-fpm.d/www.conf
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
