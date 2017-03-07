extend LoadGenerator::Helpers

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

### JMeter
# Downloads: http://jmeter.apache.org/download_jmeter.cgi
default['ark']['apache_mirror'] = preferred_apache_mirror || node['ark']['apache_mirror']
default['load-generator']['jmeter']['version'] = '3.1'
default['load-generator']['jmeter']['source_url'] = "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-#{node['load-generator']['jmeter']['version']}.tgz"
# SHA-256 checksum `shasum -a 256`
default['load-generator']['jmeter']['source_checksum'] = 'e697a17ef47f645c81f02c8f98f56400e2a182fa580904d329a0d277935edeec'

DEFAULT_MEMORY = 640 # such that 80% are 512_000
# according to: https://www.blazemeter.com/blog/9-easy-solutions-jmeter-load-test-%E2%80%9Cout-memory%E2%80%9D-failure
default['load-generator']['jmeter']['memory_factor'] = 0.8
total_memory = node['memory']['total'].chomp('kB').to_i rescue DEFAULT_MEMORY # in kB
xmx = (total_memory / 1000 * node['load-generator']['jmeter']['memory_factor']).to_i
default['load-generator']['jmeter']['heap'] = "-Xms512m -Xmx#{xmx}m"
default['load-generator']['jmeter']['perm'] = "-XX:PermSize=256m -XX:MaxPermSize=256m"

# JMeter Plugins
default['load-generator']['jmeter']['cmd_runner_url'] = 'http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar'
default['load-generator']['jmeter']['plugins_manager_url'] = 'https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/0.11/jmeter-plugins-manager-0.11.jar'
default['load-generator']['jmeter']['plugins'] = {
  # Key: Name according to the download button at https://jmeter-plugins.org/
  #      Example: https://jmeter-plugins.org/?search=jpgc-casutg
  # Value: Version
  # Examples:
 # 'jpgc-casutg' => '2.1',
 # 'jpgc-dummy' => '', # installs latest version
}
