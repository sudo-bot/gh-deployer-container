FROM alpine:3.13

# Metadata params
ARG VCS_REF
ARG BUILD_DATE

RUN apk add --no-cache --update nginx git curl bash su-exec \
    php7-fpm php7-cli php7-mysqli php7-session php7-mbstring \
    php7-iconv php7-xml php7-tokenizer php7-xmlwriter php7-simplexml \
    php7-dom php7-json php7-bz2 php7-curl php7-gd php7-zip php7-pecl-uploadprogress \
    gettext composer yarn && \
    composer self-update --2 && \
    chmod 777 /etc/php7/php-fpm.d/www.conf && \
    mkdir -p /var/log/php7 && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php7/error.log && \
    nginx -v && php-fpm7 -v && composer --version && php -v && yarn -v && date -R > /build_date && \
    printf '{"build_date": "%s", "timestamp": %i}' "$(date -R)" "$(date +%s)" > /build_date.json

COPY nginx-default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm-www-pool.conf /etc/php7/php-fpm.d/www.conf
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
