# Github: https://github.com/agileorbit-cookbooks/java
# Supermarket: https://supermarket.chef.io/cookbooks/java#readme
node.default['java']['install_flavor'] = 'oracle'
node.default['java']['jdk_version'] = '8'
node.default['java']['oracle']['accept_oracle_download_terms'] = true
include_recipe 'java'

# Github: https://github.com/burtlo/ark
# Supermarket: https://supermarket.chef.io/cookbooks/ark
jmeter = node['load-generator']['jmeter']
ark 'jmeter' do
  url jmeter['source_url']
  version jmeter['version']
  checksum jmeter['source_checksum']
  has_binaries %w(bin/jmeter)
  append_env_path true
  action :install
end
