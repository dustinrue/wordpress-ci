#!/bin/bash

source /etc/profile
source $HOME/.bashrc

nvm use --lts

exec "$@"

