poise_service 'jmeter-server' do
  command "#{node['jmeter']['env']} ./jmeter-server #{node['jmeter']['cli_args']}"
  user node['jmeter']['user']
  directory '/usr/local/jmeter/bin'
  # environment JAVA_HOME: ...
  action node['jmeter']['service'].to_sym
end
