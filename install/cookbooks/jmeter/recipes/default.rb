include_recipe 'apt::default'

include_recipe 'jmeter::java_package'
include_recipe 'jmeter::binary'
include_recipe 'jmeter::plugins'
include_recipe 'jmeter::configure'
