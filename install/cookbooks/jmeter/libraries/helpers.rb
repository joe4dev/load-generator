module JMeter
  module Helpers
    def preferred_apache_mirror(mirror_api_url = 'http://www.apache.org/dyn/closer.cgi?as_json=1')
      grep_expression = '(?<="preferred": ")[^"]*'
      cmd_string = "wget --quiet --output-document=- '#{mirror_api_url}' | grep -Po '#{grep_expression}'"
      cmd = Mixlib::ShellOut.new(cmd_string)
      cmd.run_command
      cmd.error!
      cmd.stdout.strip
    rescue => e
      Chef::Log.warn("Could not detect preferred apache mirror #{e.message}.")
      nil
    end
  end
end
