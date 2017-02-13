#
# Cookbook Name:: deploy_CB
# Recipe:: default
file '/root/.ssh/config' do
        action :delete
end

file '/root/.ssh/git_var' do
        action :delete
end

cookbook_file '/root/.ssh/config' do
        source 'config'
        action :create
end

cookbook_file '/root/.ssh/git_var' do
        source 'git_var'
	mode '0600'
	owner 'root'
	group 'root'
	action :create
end

execute 'stop ssh verification' do
	command 'sed -i "/StrictHostKeyChecking/c\StrictHostKeyChecking no"'
	action :run
end

git "/var/www/html/#{node["project_name"]}" do
  repository node["git_uri"]
  revision 'master'
  #action :checkout
end

execute 'stop ssh verification' do
        command 'sed -i "/StrictHostKeyChecking/c\StrictHostKeyChecking ask"'
        action :run
end

file '/root/.ssh/git_var' do
        action :delete
end

file '/root/.ssh/config' do
        action :delete
end

template "/etc/nginx/conf.d/#{node["server_name"]}.conf" do
  source 'vhost.erb'
  owner 'nginx'
  group 'nginx'
  mode '0775'
end

service "nginx" do
        action :restart
end
