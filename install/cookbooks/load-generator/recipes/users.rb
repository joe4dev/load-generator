app = node['load-generator']['app']

user app['user'] do
  action :create
  comment 'Runs the app'
end

user app['deploy_user'] do
  action :create
  comment 'Deploys the app'
  supports manage_home: true
end

group app['user'] do
  action :modify
  members [
    app['user'],
    app['deploy_user'],
  ]
end

node.default['authorization']['sudo']['groups'] = [
  'sudo',
  app['deploy_user'],
]
node.default['authorization']['sudo']['passwordless'] = true
include_recipe 'sudo'
