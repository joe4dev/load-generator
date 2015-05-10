node.default['nginx']['install_method'] = 'package' # or 'source'
# Source releases from: http://nginx.org/en/download.html
# Example url: http://nginx.org/download/nginx-1.9.0.tar.gz
# Details in: https://github.com/miketheman/nginx/blob/master/attributes/source.rb
# node.default['nginx']['source']['version'] = '1.9.0'
# node.default['nginx']['source']['checksum'] = e12aa1d5b701edde880ebcc7be47ca171c3fbeed8fa7c8c62054a6f19d27f248'
node.default['nginx']['init_style'] = 'upstart'
node.default['nginx']['default_site_enabled'] = false
include_recipe 'nginx::default'

def detect_public_ip
  cmd = Mixlib::ShellOut.new('curl http://ipecho.net/plain')
  cmd.run_command
  cmd.stdout
rescue
  default_ip = node['ipaddress'] || 'localhost'
  Chef::Log.warn("Could not detect public ip. Using: #{default_ip}.")
  default_ip
end

app = node['load-generator']['app']

directory app['log_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

nginx_config = File.join(node['nginx']['dir'], 'sites-available', app['name'])
hostname = app['hostname'] || detect_public_ip
template nginx_config do
  source 'nginx_vhost.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    app: app,
    hostname: hostname,
    root_path: File.join(app['dir'], 'current', 'public')
  )
  notifies :reload, 'service[nginx]'
end

nginx_site app['name'], enable: true do
  notifies :reload, 'service[nginx]'
end
