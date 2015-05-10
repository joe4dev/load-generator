include_recipe 'apt::default'
package 'jmeter' do
  action :install
end
