# native kolla-ansible site deployment

this repo contains a configuration of kolla-ansible, to be used for incremental upgrades of kvm@tacc.

Major parameters of interest:

* python version to use, 3.8-3.10 (default 3.8)
* location of target host virtual environment (default /opt/kolla/venv)
* location of target host templated kolla service config (default /opt/kolla/config)
* location of "site_config" directory, part of this git repo (default /home/ubuntu/ka_native/site_config)


# Usage

## tool installation

```
uv venv --python=3.8 .venv
source .venv/bin/activate
uv pip install -r requirements.txt --force-reinstall
```

## init passwords

```
cp .venv/share/kolla-ansible/etc_examples/kolla/passwords.yml site_config/passwords.yml
kolla-genpwd -p site_config/passwords.yml
```

## do everything else
```
./ka.sh --site site_config bootstrap-servers
./ka.sh --site site_config genconfig
./ka.sh --site site_config pull
./ka.sh --site site_config deploy
./ka.sh --site site_config post-deploy
```

## acceptance tests
