app = node['load-generator']['app']

directory app['dir'] do
  owner app['user']
  group app['user']
  mode '0755'
  recursive true
  action :create
end

env_variables = node['load-generator']['env'].map{|k,v| "#{k}=#{v}"}.join("\n")
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
    # Based on: https://github.com/poise/application_ruby/blob/master/providers/rails.rb
    Chef::Log.info 'Running bundle install'
    common_groups = %w(development test staging production doc)
    common_groups.delete(app['rails_env'])
    bundle_install = "bundle install --without #{common_groups.join(' ')}"
    execute bundle_install do
      cwd release_path
      user new_resource.user
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
  environment(node['load-generator']['env'].map { |k, v| [k.to_s, v.to_s] }.to_h)

  ### Symlinks
  purge_before_symlink.clear
  create_dirs_before_symlink.clear
  before_symlink do
    %w(storage).each do |dir|
      directory File.join(shared_path, dir) do
        owner new_resource.user
        group new_resource.group
        mode '0755'
        action :create
      end
    end

    # NOTE: One might consider using lograte here similar to
    # https://github.com/poise/application_ruby/blob/master/providers/rails.rb#L216

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
    'storage' => 'storage',
    '.env' => '.env',
  )

  ### Restart
  before_restart do
    current_release = release_path
    log_file = File.join(app['log_dir'], "#{app['rails_env']}.log")
    execute 'configure-upstart' do
      user new_resource.user
      command "sudo bin/foreman export upstart /etc/init \
                  --procfile Procfile_production \
                  --env .env \
                  --app #{app['name']} \
                  --concurrency web=1,job=#{app['num_workers']} \
                  --log #{log_file} \
                  --port #{app['port']} \
                  --user #{app['user']}"
      cwd current_release
      action :run
    end
  end
  restart_command "sudo service #{app['name']} restart"
  scm_provider Chef::Provider::Git
end
