FROM php:8.1.0RC6-fpm-alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" >> /etc/apk/repositories
ARG APK_COMMON_DEPENDENCIES="bash dcron busybox-suid libcap curl zip unzip git nodejs npm"
RUN apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/latest-stable/main $APK_COMMON_DEPENDENCIES

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
ARG PHP_EXTENSIONS="intl bcmath gd pdo_mysql pdo_pgsql opcache uuid exif pcntl zip sockets gmp openswoole"
RUN install-php-extensions $PHP_EXTENSIONS

ENV NON_ROOT_GROUP=${NON_ROOT_GROUP:-app}
ENV NON_ROOT_USER=${NON_ROOT_USER:-app}
RUN addgroup -S $NON_ROOT_GROUP && adduser -S $NON_ROOT_USER -G $NON_ROOT_GROUP
RUN addgroup $NON_ROOT_USER wheel

ENV NPM_CONFIG_PREFIX=~/.npm-global
ENV PATH "$PATH:/home/$NON_ROOT_USER/.npm-global/bin"
USER $NON_ROOT_USER
RUN npm install -g chokidar
