FROM php:7.3-apache

COPY install-composer.sh /
COPY . /var/www/

RUN set -ex; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update \
    && apt-get install -y \
        zip unzip wget \
    && /install-composer.sh \
    && a2enmod authz_core authz_groupfile rewrite \
    && rm -r /var/www/html \
    && ln -s /var/www/web /var/www/html \
    && cd /var/www/ \
    && composer install \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    && apt-mark auto '.*' > /dev/null \
    && apt-mark manual $savedAptMark \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/www/sessions \
    && chown www-data /var/www/sessions \
    && echo "[global]\ndisplay_errors = Off" > /usr/local/etc/php/conf.d/php-password-manager.ini \
    && sed -i -E 's/\s*print_r\(\s*\$users\s*\)\s*;//' /var/www/vendor/rafaelgou/php-apache2-basic-auth/src/Apache2BasicAuth/Model/Group.php

