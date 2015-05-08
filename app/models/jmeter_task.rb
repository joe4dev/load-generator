require 'fileutils'
class JmeterTask < ActiveRecord::Base
  before_destroy :cleanup_filesystem
  enum status: [:pending, :in_progress, :completed, :failed]

  # TODO: It might be better to store the content of the files in the database
  # and copy then into the appropriate place when necessary (i.e., on perform)
  def self.create_from_files!(params)
    jmeter_task = JmeterTask.new(test_plan: 'test_plan.jmx',
                                 benchmark: params[:benchmark_file].original_filename,
                                 node: 'node.yml',
                                 status: 'pending')
    jmeter_task.save!
    jmeter_task.init_filesystem(params)
    jmeter_task.perform
    jmeter_task
  end

  def file_path(name)
    File.join(base_path, name)
  end

  def base_path
    File.join(Rails.application.config.jmeter_tasks_dir, id_string)
  end

  # @example id 13 becomes '0013'
  def id_string
    self.id.to_s.rjust(4, '0')
  end

  def init_filesystem(params)
    FileUtils.mkdir_p(base_path)
    FileUtils.cp(params[:test_plan_file].path, file_path(self.test_plan))
    FileUtils.cp(params[:benchmark_file].path, benchmark_file_path)
    FileUtils.cp(params[:node_file].path, file_path(self.node))
  end

  def benchmark_file_path
    file_path(self.benchmark)
  end

  def perform
    self.status = :in_progress
    self.save!
    %x[ bin/cwb execute #{benchmark_file_path} >#{cwb_log} ]
    if $?.success?
      self.status = :completed
    else
      self.status = :failed
    end
    self.save!
  end
  handle_asynchronously :perform

  def cwb_log
    File.join(Rails.application.config.log_dir, 'cwb.log')
  end

  def cleanup_filesystem
    FileUtils.rm_r(base_path)
  end
end
