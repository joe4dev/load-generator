app = node['load-generator']['app']

directory app['dir'] do
  owner app['deploy_user']
  group app['deploy_user']
  mode '0755'
  recursive true
  action :create
end

envs = node['load-generator']['env']
env_variables = envs.map { |k,v| "#{k}=#{v}" }.join("\n")
home_env = { 'HOME' => app['deploy_user_home'] }
deploy_env = envs.merge(home_env).map { |k, v| [k.to_s, v.to_s] }.to_h
deploy app['dir'] do
  repo app['repo']
  branch app['branch']
  keep_releases 5
  action :deploy # or :rollback

  ### User and group
  user app['deploy_user']
  group app['deploy_user']

  ### Migrations
  before_migrate do
    # MUST remove existing log directory before creating the symlink
    directory File.join(release_path, 'log') do
      owner new_resource.user
      group new_resource.group
      action :delete
      recursive true
    end

    # Using different owners is useless because this resource enforces ownership
    # of the entire deployment directory recursively:
    # See https://github.com/chef/chef/blob/master/lib/chef/provider/deploy.rb#L277
    %w(log storage).each do |dir|
      directory File.join(shared_path, dir) do
        owner new_resource.user
        group new_resource.group
        mode '0755'
        action :create
      end
      # MUST link the log dir before any Rails commands creates this directory!
      link File.join(release_path, dir) do
        # mode '0755' # Not implemented!
        to File.join(shared_path, dir)
      end
    end

    # NOTE: One might consider using lograte here similar to
    # https://github.com/poise/application_ruby/blob/master/providers/rails.rb#L216

    # Based on: https://github.com/poise/application_ruby/blob/master/providers/rails.rb
    Chef::Log.info 'Running bundle install'
    common_groups = %w(development test staging production doc)
    common_groups.delete(app['rails_env'])
    bundle_install = "bundle install --without #{common_groups.join(' ')}"
    execute bundle_install do
      cwd release_path
      user new_resource.user
      group new_resource.group
      environment new_resource.environment
    end

    directory File.join(shared_path, 'config') do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      action :create
    end

    template File.join(shared_path, 'config', 'database.yml') do
      source 'database.yml.erb'
      owner new_resource.user
      group new_resource.group
      mode '0644'
      variables(db: node['load-generator']['db'])
    end
  end
  symlink_before_migrate(
    'config/database.yml' => 'config/database.yml',
  )
  migrate true
  migration_command 'bundle exec rake db:migrate --trace'
  environment deploy_env

  ### Symlinks
  purge_before_symlink.clear
  create_dirs_before_symlink.clear
  before_symlink do
    file File.join(shared_path, '.env') do
      owner new_resource.user
      group new_resource.group
      mode '0644'
      content env_variables
    end

    Chef::Log.info('Precompiling assets')
    precompile_assets = 'bundle exec rake assets:precompile'
    execute precompile_assets do
      cwd release_path
      user new_resource.user
      environment new_resource.environment
    end
  end
  symlinks(
    '.env' => '.env',
  )

  ### Restart
  before_restart do
    ruby_block 'grant app user ownership' do
      block do
        FileUtils.chown_R(app['user'], app['user'], File.join(shared_path, 'storage'))
        FileUtils.chown_R(app['user'], app['user'], File.join(shared_path, 'log'))
      end
    end

    current_release = release_path
    execute 'configure-upstart' do
      user new_resource.user
      # --log #{app['log_dir']} has no effect,
      # Upstarts logs to /var/log/upstart/APPNAME per convention
      command "sudo bin/foreman export upstart /etc/init \
                  --procfile Procfile_production \
                  --env .env \
                  --app #{app['name']} \
                  --concurrency web=1,job=#{app['num_workers']} \
                  --port #{app['port']} \
                  --user #{app['user']}"
      cwd current_release
      action :run
    end
  end
  restart_command "sudo service #{app['name']} restart"
  scm_provider Chef::Provider::Git
end
