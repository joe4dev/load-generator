# load-generator

Installs and deploys the load generator Rails application: https://github.com/joe4dev/load-generator

## Platforms

* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS

## Usage

Add the default recipe to your run list: `recipe[load-generator::default]`
One might need to provision twice (relogin) because the Ruby version seems not to be reflected in the PATH. See `ruby_binary.rb:31ff`.

### Concurrency re-configuration

Concurrency values are currently only updated when a new version is deployed. Notice that this only happens if there changes are available at the `load-generator` master repo.
Also, if you reduce the concurrency (e.g., from jobs=2 to jobs=1), you might need to manually delete the additional Upstart configurations because they are not automatically removed. Example: `sudo rm /etc/init/load-generator-job-2.conf`

### Chef Solo

The following attribues are mandatory using Chef Solo because randomly generated secrets cannot be persistet (e.g., using *node.set*):

```
default['postgresql']['password']
default['load-generator']['db']['password']
default['load-generator']['env']['SECRET_KEY_BASE']
```

## Testing

```
kitchen converge; kitchen converge && kitchen verify
```


## Administer

### Installation directory

`/var/www/load-generator/`

### Manage Services

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

### Show Logs

```bash
tail -f /var/log/upstart/load-generator-web-*
tail -f /var/log/upstart/load-generator-job-*

tail -f /var/log/load-generator/load-generator-access.log
tail -f /var/log/load-generator/load-generator-error.log

tail -f /var/log/postgresql/postgresql-9.1-main.log
```
