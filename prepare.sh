#!/bin/bash

set -o xtrace
set -e

[[ -z $(which python3) ]] && echo 'Must install python3'

[[ ! -f venv ]] && python3 -m virtualenv venv
source venv/bin/activate
[[ -z $(pip freeze | grep ansible) ]] && pip install ansible

vagrant destroy --force

