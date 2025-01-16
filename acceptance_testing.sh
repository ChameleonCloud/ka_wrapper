#!/bin/bash

source site_config/admin-openrc.sh
rally db create
rally deployment create --name local --fromenv
rally verify create-verifier --name tempest --type tempest
rally verify configure-verifier --reconfigure --extend 'network: {floating_network_name: public}'
rally verify start --concurrency 4 --pattern set=smoke
