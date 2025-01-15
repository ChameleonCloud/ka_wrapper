#!/bin/bash

# helper script for fast iteration
# we assume this is executed from the ka_native git checkout directory


# delete the tool virtual environment
rm -rf .venv

# delete the virtual env and config dir created by kolla
sudo rm -rf /opt/kolla/config
sudo rm -rf /opt/kolla/venv

# start a new config
uv venv --python=3.8 .venv
source .venv/bin/activate
uv pip install -r requirements.txt --force-reinstall

# cp .venv/share/kolla-ansible/etc_examples/kolla/passwords.yml site_config/passwords.yml
# kolla-genpwd -p site_config/passwords.yml


./ka.sh --site site_config bootstrap-servers
./ka.sh --site site_config prechecks
./ka.sh --site site_config deploy
./ka.sh --site site_config post-deploy
