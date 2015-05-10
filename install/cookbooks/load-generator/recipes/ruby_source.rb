include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'

rbenv_ruby node['load-generator']['ruby']['version']
