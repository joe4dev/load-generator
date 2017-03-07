## Install plugin manager
# https://jmeter-plugins.org/wiki/PluginsManager/#Plugins-Manager-from-Command-Line
jmeter = node['load-generator']['jmeter']
jmeter_home = '/usr/local/jmeter'
plugin_manager = "#{jmeter_home}/lib/ext/jmeter-plugins-manager.jar"

remote_file plugin_manager do
  source jmeter['plugins_manager_url']
  action :create
end

remote_file "#{jmeter_home}/lib/cmdrunner-2.0.jar" do
  source jmeter['cmd_runner_url']
  action :create
end

plugin_script = "#{jmeter_home}/bin/PluginsManagerCMD.sh"
execute 'copy_jmeter_plugins_manager_cmd' do
  command "java -cp #{plugin_manager} org.jmeterplugins.repository.PluginManagerCMDInstaller"
  creates plugin_script
end

# Make the plugin script executable
file plugin_script do
  mode '0755'
end

# Script to forward call because symlinking doesn't work
# (PluginsManagerCMD.sh is not robust enough to handle being called from another directory)
file '/usr/local/bin/PluginsManagerCMD' do
  content <<-HEREDOC
#!/usr/bin/env bash
#{plugin_script} "$@"
    HEREDOC
  mode '0755'
end

plugin_list = ''
jmeter['plugins'].each do |plugin_name, version|
  plugin_list << "#{plugin_name}"
  plugin_list << "=#{version}" if version.is_a? Numeric
  plugin_list << ','
end
plugin_list = plugin_list.chomp(',')

## Install plugins
log "Installing Jmeter plugins: #{plugin_list}"
execute 'install_jmeter_plugins' do
  command "PluginsManagerCMD install #{plugin_list}" unless plugin_list.empty?
end
