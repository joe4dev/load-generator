require 'spec_helper'

# Serverspec examples can be found at
# http://serverspec.org/resource_types.html
describe 'load-generator::default' do
  describe user('deploy') do
    it { should exist }
    it { should have_home_directory '/home/deploy' }
  end

  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

  it "has a running service of postgresql" do
    expect(service("postgresql")).to be_running
  end

  it "has a running service of nginx" do
    expect(service("nginx")).to be_running
  end

  describe command('wget http://192.168.33.44 -O - -q') do
    its(:stdout) { should contain('Listing Jmeter Tasks') }
  end

  describe command('PluginsManagerCMD status') do
    its(:stdout) { should match /jpgc-casutg=2.1/ }
    its(:stdout) { should match /jpgc-dummy/ }
  end
end
