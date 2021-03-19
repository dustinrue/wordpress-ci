FROM ubuntu:20.04

ARG PHP_VERSION=7.3

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.utf8
ENV COMPOSER_ALLOW_SUPERUSER 1

SHELL ["/bin/bash", "-c"]

RUN \
  apt update && \
  apt dist-upgrade -y && \
  apt install gnupg -y && \
  echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" | tee /etc/apt/sources.list.d/ondrej-ubuntu-php-focal.list && \
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C && \
  apt update && \
  apt clean all

RUN \
  apt install -y \
  php${PHP_VERSION}-gd \
  php${PHP_VERSION}-mbstring \
  php${PHP_VERSION}-cli \
  php${PHP_VERSION}-bcmath \
  php${PHP_VERSION}-zip \
  php${PHP_VERSION}-intl \
  php${PHP_VERSION}-imagick \
  subversion \
  wget \
  rsync \
  mercurial \
  jq \
  lftp \
  git \
  curl \
  && apt clean all

RUN \
  cd /etc/php/$(ls /etc/php)/cli/conf.d && \
  echo "memory_limit=-1" > memory-limit.ini && \
  echo "date.timezone=${PHP_TIMEZONE:-UTC}" > date_timezone.ini

RUN \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

RUN \
  export PS1='hack-so-bashrc-is-evaluated' && \
  source /root/.bashrc && \
  nvm install --lts

COPY scripts/composer-installer.sh /composer-installer.sh
COPY scripts/composer /usr/local/bin/composer
COPY scripts/entrypoint.sh /entrypoint.sh

RUN \
  sh /composer-installer.sh && \
  mv /composer1 /usr/local/bin/composer1 && \
  mv /composer2 /usr/local/bin/composer2 && \
  chmod +x /usr/local/bin/composer1 && \
  chmod +x /usr/local/bin/composer2 && \
  chmod +x /usr/local/bin/composer && \
  chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
