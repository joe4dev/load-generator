include_recipe 'apt::default'

include_recipe 'jmeter::java_package'
include_recipe 'jmeter::jmeter_binary'
include_recipe 'jmeter::jmeter_plugins'
include_recipe 'jmeter::jmeter_configure'
