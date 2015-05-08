class Application < Rails::Application
  config.storage_dir = File.join(Rails.root, 'storage', Rails.env)
  config.log_dir = File.join(Rails.root, 'log')
  config.jmeter_tasks_dir = File.join(config.storage_dir, 'jmeter_tasks')
end
