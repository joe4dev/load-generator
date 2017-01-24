app = node['load-generator']['app']

user app['user'] do
  action :create
  comment 'Runs the app'
end

user app['deploy_user'] do
  comment 'Deploys the app'
  home app['deploy_user_home']
  manage_home true
end.run_action(:create)

group app['user'] do
  action :modify
  members [
    app['user'],
    app['deploy_user'],
  ]
end

node.default['authorization']['sudo']['groups'] = [
  'sudo',
  app['deploy_user']
]
node.default['authorization']['sudo']['passwordless'] = true
include_recipe 'sudo'
