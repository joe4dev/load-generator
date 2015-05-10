module LoadGenerator
  module GitHelpers
    def app_up_to_date?(app_dir, branch = 'master')
      if File.exist?(current_dir(app_dir))
        repo_up_to_date?(current_dir(app_dir), branch)
      else
        false
      end
    end

    def current_dir(app_dir)
      File.join(app_dir, 'current')
    end

    def repo_up_to_date?(git_repo, branch = 'master')
      update_remote_refs(git_repo)
      if commits_behind_remote(git_repo, branch).to_i == 0
        true
      else
        false
      end
    end

    def update_remote_refs(git_repo)
      shell_cmd('git remote --verbose update', git_repo)
    end

    def commits_behind_remote(git_repo, branch = 'master')
      shell_cmd("git rev-list HEAD...origin/#{branch} --count", git_repo)
    end

    def shell_cmd(cmd, cwd = Dir.pwd)
      cmd = Mixlib::ShellOut.new(cmd, cwd: cwd)
      cmd.run_command
      cmd.error!
      cmd.stdout
    end
  end
end
