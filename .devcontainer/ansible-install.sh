#!/bin/bash

# use this for consistent results (python dependencies)
pipx install --include-deps ansible
ansible-galaxy collection install check_point.mgmt

# THIS DID NOT WORK WELL due to python dependencies - AVOID IT:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-20-04

# sudo apt-add-repository ppa:ansible/ansible
# sudo apt update
# sudo apt install ansible -y