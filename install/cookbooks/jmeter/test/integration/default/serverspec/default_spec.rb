require 'spec_helper'

# Serverspec examples can be found at
# http://serverspec.org/resource_types.html
describe 'jmeter::default' do
  describe command('PluginsManagerCMD status') do
    its(:stdout) { should match /jpgc-casutg=2.1/ }
    its(:stdout) { should match /jpgc-dummy/ }
  end
end
