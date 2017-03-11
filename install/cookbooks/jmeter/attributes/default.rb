extend JMeter::Helpers

# Downloads: http://jmeter.apache.org/download_jmeter.cgi
default['ark']['apache_mirror'] = preferred_apache_mirror || node['ark']['apache_mirror']
default['jmeter']['version'] = '3.1'
default['jmeter']['source_url'] = "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-#{node['jmeter']['version']}.tgz"
# SHA-256 checksum `shasum -a 256`
default['jmeter']['source_checksum'] = 'e697a17ef47f645c81f02c8f98f56400e2a182fa580904d329a0d277935edeec'

DEFAULT_MEMORY = 640 # such that 80% are 512_000
# according to: https://www.blazemeter.com/blog/9-easy-solutions-jmeter-load-test-%E2%80%9Cout-memory%E2%80%9D-failure
default['jmeter']['memory_factor'] = 0.8
total_memory = node['memory']['total'].chomp('kB').to_i rescue DEFAULT_MEMORY # in kB
xmx = (total_memory / 1000 * node['jmeter']['memory_factor']).to_i
default['jmeter']['heap'] = "-Xms512m -Xmx#{xmx}m"
default['jmeter']['perm'] = "-XX:PermSize=256m -XX:MaxPermSize=256m"

# JMeter Plugins
default['jmeter']['cmd_runner_url'] = 'http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar'
default['jmeter']['plugins_manager_url'] = 'https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/0.11/jmeter-plugins-manager-0.11.jar'
default['jmeter']['plugins'] = {
  # Key: Name according to the download button at https://jmeter-plugins.org/
  #      Example: https://jmeter-plugins.org/?search=jpgc-casutg
  # Value: Version
  # Examples:
 # 'jpgc-casutg' => '2.1',
 # 'jpgc-dummy' => '', # installs latest version
}
