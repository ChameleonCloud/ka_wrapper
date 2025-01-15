#!/bin/bash

sudo mkdir -p /opt/kolla/config
sudo chown ubuntu:ubuntu /opt/kolla

uv venv --python=3.8 .venv
source .venv/bin/activate
uv pip install -r requirements.txt --force-reinstall

kolla-genpwd -p site_config/passwords.yml


sudo rm -rf /opt/kolla/venv/
./ka.sh bootstrap-servers

./ka.sh deploy



# mkdir -p kolla_defaults/config
# cp .venv/share/kolla-ansible/etc_examples/kolla/globals.yml kolla_defaults/config/
# cp .venv/share/kolla-ansible/etc_examples/kolla/passwords.yml kolla_defaults/
