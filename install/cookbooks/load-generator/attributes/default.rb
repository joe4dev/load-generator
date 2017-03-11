### Database
default['load-generator']['db']['name'] = 'load_generator_production'
default['load-generator']['db']['user'] = 'load_generator'
default['load-generator']['db']['password'] = nil

### Ruby
default['load-generator']['ruby']['version'] = '2.2.2'
default['load-generator']['ruby']['checksum'] = nil

### App
default['load-generator']['app']['name'] = 'load-generator'
default['load-generator']['app']['user'] = 'apps'
default['load-generator']['app']['deploy_user'] = 'deploy'
default['load-generator']['app']['deploy_user_home'] = "/home/#{node['load-generator']['app']['deploy_user']}"
default['load-generator']['app']['dir'] = '/var/www/load-generator'
default['load-generator']['app']['log_dir'] = "/var/log/#{node['load-generator']['app']['name']}"
default['load-generator']['app']['rails_env'] = 'production'
default['load-generator']['app']['repo'] = 'https://github.com/joe4dev/load-generator.git'
default['load-generator']['app']['branch'] = 'master'
default['load-generator']['app']['num_workers'] = 2
# should be a multiple of 1000 according to foreman: http://ddollar.github.io/foreman/#EXPORTING
default['load-generator']['app']['port'] = 3000
default['load-generator']['app']['hostname'] = nil

### Environment
default['load-generator']['env']['RAILS_ENV'] = node['load-generator']['app']['rails_env']
default['load-generator']['env']['SECRET_KEY_BASE'] = nil
# Dynamic: [node['cpu']['total'].to_i * 4, 8].min
default['load-generator']['env']['WEB_CONCURRENCY'] = 3
