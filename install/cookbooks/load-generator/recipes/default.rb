include_recipe 'load-generator::attributes'
include_recipe 'git::default'
include_recipe 'load-generator::database'

include_recipe 'load-generator::ruby_binary'
# include_recipe 'load-generator::ruby_source'

# include_recipe 'load-generator::jmeter_package'
include_recipe 'load-generator::jmeter_binary'

include_recipe 'load-generator::users'
include_recipe 'load-generator::deploy'
