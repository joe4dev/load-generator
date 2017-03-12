# Github: https://github.com/burtlo/ark
# Supermarket: https://supermarket.chef.io/cookbooks/ark
jmeter = node['jmeter']
ark 'jmeter' do
  url jmeter['source_url']
  version jmeter['version']
  checksum jmeter['source_checksum']
  has_binaries %w(bin/jmeter)
  append_env_path true
  action :install
end
