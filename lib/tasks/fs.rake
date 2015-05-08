require 'fileutils'
namespace :fs do
  desc 'Clean the file system by removing the generated files under `storage`'
  task clean: :environment do
    clean_storage_dir
  end

  def clean_storage_dir
    FileUtils.rm_rf(Dir[Rails.application.config.storage_dir])
  end
end

# Clean the file system on db:drop for non-production environments.
Rake::Task['db:drop'].enhance do
  Rake::Task['fs:clean'].invoke unless Rails.env.production?
end
