ruby_version = node['load-generator']['ruby']['version']
ruby_with_version = "ruby-#{ruby_version}"

cache_file = File.join(Chef::Config[:file_cache_path], "#{ruby_with_version}.tgz")
remote_file cache_file do
  owner 'root'
  group 'root'
  mode '0644'
  source "https://s3.amazonaws.com/pkgr-buildpack-ruby/current/#{node['platform']}-#{node['platform_version']}/#{ruby_with_version}.tgz"
  checksum node['load-generator']['ruby']['checksum'] if node['load-generator']['ruby']['checksum']
  action :create
  notifies :run, "execute[unpack #{ruby_with_version}]"
end

install_dir = '/usr/local'
bin_dir = File.join(install_dir, 'bin')
execute "unpack #{ruby_with_version}" do
  command "tar xzf #{cache_file} -C #{install_dir}"
  creates File.join(bin_dir, 'ruby')
  action :nothing
end

bundler_bin = File.join(bin_dir, 'bundle')
execute 'install bundler' do
  command 'gem install bundler'
  creates bundler_bin
  action :run
  not_if { ::File.exist?(bundler_bin) }
end

# Add to path for the current chef-client converge.
ruby_block "adding '#{bin_dir}' to chef-client ENV['PATH']" do
  block do
    ENV['PATH'] = bin_dir + ':' + ENV['PATH']
    Chef::Log.debug("Added #{bin_dir} to PATH: #{ENV['PATH']}")
  end
  # Ensure imdempotence by not adding twice
  only_if do
    ENV['PATH'].scan(bin_dir).empty?
  end
end

# Add to path for interactive bash sessions
template "/etc/profile.d/#{ruby_with_version}.sh" do
  cookbook 'load-generator'
  source 'add_to_path.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(directory: bin_dir)
end
