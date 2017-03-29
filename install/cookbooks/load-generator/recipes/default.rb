### Base utilities
include_recipe 'openssl::default'
include_recipe 'load-generator::attributes'
include_recipe 'apt::default'
include_recipe 'git::default'
include_recipe 'load-generator::users'

### Runtime dependencies
include_recipe 'jmeter::default'
package 'iperf'

### Installation dependencies
include_recipe 'load-generator::database'
include_recipe 'load-generator::ruby_binary'
# Takes much longer to install
# include_recipe 'load-generator::ruby_source'
include_recipe 'load-generator::nginx'
include_recipe 'load-generator::conditional_deploy'
