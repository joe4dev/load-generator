include_recipe 'load-generator::attributes'
include_recipe 'git::default'
include_recipe 'load-generator::database'

include_recipe 'load-generator::ruby_binary'
# Takes much longer to install
# include_recipe 'load-generator::ruby_source'

include_recipe 'load-generator::jmeter_binary'
# No latest version available
# include_recipe 'load-generator::jmeter_package'

include_recipe 'load-generator::users'
include_recipe 'load-generator::nginx'
include_recipe 'load-generator::conditional_deploy'
