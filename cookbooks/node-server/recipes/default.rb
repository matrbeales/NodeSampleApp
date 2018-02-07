# 
#
# Cookbook:: node-server
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'nginx'

service 'nginx' do 
	supports status: true, restart: true, reload: true
	action [:enable, :start]
end

template '/etc/nginx/sites-available/default' do
	source 'nginx.default.erb'
	notifies :reload, "service[nginx]"
end

include_recipe 'git'

remote_file '/tmp/nodesource_setup.sh' do
  source 'https://deb.nodesource.com/setup_6.x'
  action :create
end

execute "update node resources" do
  command "sh /tmp/nodesource_setup.sh"
end

package 'nodejs'
package 'build-essential'
package 'python'

execute "install NPM package pm2 globally" do
    command "npm install -g pm2"
end

execute "install NPM package bower globally" do
    command "npm install -g bower"
end


# nodejs_npm 'bower'


# https://github.com/customink-webops/magic_shell
# magic_shell_environment 'MONGODB_URI' do
#   value 'mongodb://192.168.10.101/outliners'
# end

# execute 'nodejs-sources' do
#   command 'curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -'
# end

# package 'nodejs' do
#   # version '6.10.0'
# end

# execute 'npm install pm2' do
#   command 'sudo npm install pm2 -g'
# end









