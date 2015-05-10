# load-generator

Installs and deploys the load generator Rails application: https://github.com/joe4dev/load-generator

## Platforms

* Ubuntu 12.04 LTS

## Usage

Add the default recipe to your run list: `recipe[load-generator::default]`

## Manage Services

```bash
sudo initctl list
sudo initctl status load-generator
sudo initctl restart load-generator
sudo initctl stop load-generator

sudo initctl status load-generator-job
sudo initctl restart load-generator-job
sudo initctl status load-generator-job-1
sudo initctl status load-generator-job-2

sudo service nginx status
sudo service nginx restart

sudo service postgresql status
sudo service postgresql restart
```

## Show Logs

```bash
tail -f /var/log/upstart/load-generator-web-*
tail -f /var/log/upstart/load-generator-job-*

tail -f /var/log/load-generator/load-generator-access.log
tail -f /var/log/load-generator/load-generator-error.log

tail -f /var/log/postgresql/postgresql-9.1-main.log
```
