#!/bin/bash

CMD=$1

if [[ ${CMD} = "create"  ]]; then
  ansible-playbook site.yml -i inventory.yml --tags "aws"
  ./update_inventory.sh
elif [[ ${CMD} = "deploy" ]]; then
  ansible-playbook site.yml -i inventory.yml --tags "mongodb,docker,docker-container"
fi
