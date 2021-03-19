#!/bin/bash

set -x

PS1=hack source /root/.bashrc

exec "$@"
