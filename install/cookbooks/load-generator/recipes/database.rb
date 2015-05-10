include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

db = node['load-generator']['db']
postgresql_connection_info = {
  :host      => node['postgresql']['config']['listen_addresses'],
  :port      => node['postgresql']['config']['port'],
  :username  => 'postgres',
  :password  => node['postgresql']['password']['postgres']
}

postgresql_database db['name'] do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user node['load-generator']['db']['user'] do
  connection postgresql_connection_info
  password db['password']
  database_name db['name']
  action [:create, :grant]
end
