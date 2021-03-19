#!/bin/bash

set -x
source /etc/profile
source $HOME/.bashrc

export $PATH

exec "$@"

