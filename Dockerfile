ARG PHP_VERSION=7.4
FROM 10up/base-php:${PHP_VERSION}-ubuntu

ARG PHP_VERSION=7.4

ENV LANG en_US.utf8
ENV COMPOSER_ALLOW_SUPERUSER 1

USER root
SHELL ["/bin/bash", "-c"]

RUN \
  apt update && \
  apt install -y \
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
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

RUN \
  sed -i "/&& return/d" ~/.bashrc && \
  source /root/.bashrc && \
  nvm install --lts

COPY scripts/composer-installer.sh /composer-installer.sh
COPY scripts/composer /usr/local/bin/composer
COPY scripts/nvm /usr/local/bin/nvm
COPY scripts/entrypoint.sh /entrypoint.sh

RUN \
  sh /composer-installer.sh && \
  mv /composer1 /usr/local/bin/composer1 && \
  mv /composer2 /usr/local/bin/composer2 && \
  chmod +x /usr/local/bin/composer1 && \
  chmod +x /usr/local/bin/composer2 && \
  chmod +x /usr/local/bin/composer && \
  chmod +x /usr/local/bin/nvm && \
  chmod +x /entrypoint.sh && \
  sed -i '3 i PS1="docker-fix"' /etc/profile

ENTRYPOINT ["/entrypoint.sh"]
