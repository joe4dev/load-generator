include_recipe 'apt::default'
package 'default-jre' do
  action :install
end
