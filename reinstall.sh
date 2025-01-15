#!/bin/bash

# helper script for fast iteration
# we assume this is executed from the ka_native git checkout directory


# delete the tool virtual environment
rm -rf .venv

# delete the virtual env and config dir created by kolla
rm -rf /opt/kolla/config
rm -rf /opt/kolla/venv
rm -rf /opt/kolla/

# start a new config
uv venv --python=3.8 .venv
source .venv/bin/activate
uv pip install -r requirements.txt --force-reinstall

cp .venv/share/kolla-ansible/etc_examples/kolla/passwords.yml site_config/passwords.yml
kolla-genpwd -p site_config/passwords.yml


./ka.sh bootstrap-servers
./ka.sh deploy
./ka.sh post-deploy
