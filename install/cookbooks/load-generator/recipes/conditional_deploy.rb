extend LoadGenerator::GitHelpers

app = node['load-generator']['app']
if app_up_to_date?(app['dir'])
  Chef::Log.debug("#{app['name']} already up to date.")
else
  Chef::Log.info("Deploy new release of #{app['name']} to #{app['dir']}.")
  include_recipe 'load-generator::deploy'
end
