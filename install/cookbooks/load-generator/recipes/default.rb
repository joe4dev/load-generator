### Base utilities
include_recipe 'load-generator::attributes'
include_recipe 'apt::default'
include_recipe 'git::default'
include_recipe 'load-generator::users'

### Runtime dependencies
include_recipe 'load-generator::java_package'
include_recipe 'load-generator::jmeter_binary'
# No latest version available
# include_recipe 'load-generator::jmeter_package'

### Installation dependencies
include_recipe 'load-generator::database'
include_recipe 'load-generator::ruby_binary'
# Takes much longer to install
# include_recipe 'load-generator::ruby_source'
include_recipe 'load-generator::nginx'
include_recipe 'load-generator::conditional_deploy'
