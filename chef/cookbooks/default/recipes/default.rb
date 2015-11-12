#Basic Configuration
node.set['build_essential']['compiletime'] = true
include_recipe 'build-essential'
include_recipe 'locale'
include_recipe 'ohai'

#Ruby Environment Configuration
include_recipe 'runit'
include_recipe 'git'
include_recipe 'ruby_build'
include_recipe 'rbenv'

rbenv_ruby '2.2.3' do
  ruby_version '2.2.3'
  global true
end

rbenv_gem 'bundler'

# Unicorn
template '/etc/init.d/unicorn' do
  source 'unicorn.init.erb'
  owner 'root'
  group 'root'
  mode 00755
  variables({
    rails_path: node[:unicorn][:rails_path],
    stage:      node[:environment],
    pid_path:   File.join(node[:unicorn][:rails_path], 'tmp/pids/unicorn.pid')
  })
end

service 'unicorn' do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :enable
end

service 'unicorn' do
  action :start
end

# Acesso ao repositório via chave ssh + ssh-forwarding
unless(['staging', 'production'].include?(node[:environment]))
  cookbook_file 'id_rsa' do
    path '/home/vagrant/.ssh/id_rsa'
    owner 'vagrant'
    group 'vagrant'
    mode 00400
  end

  cookbook_file 'id_rsa.pub' do
    path '/home/vagrant/.ssh/id_rsa.pub'
    owner 'vagrant'
    group 'vagrant'
    mode 00644
  end

  package 'keychain'

  ruby_block 'insert_line' do
    block do
      file = Chef::Util::FileEdit.new('/home/vagrant/.bashrc')
      file.insert_line_if_no_match('eval \`ssh-agent\`; ssh-add;', 'eval \`ssh-agent\`; ssh-add;')
      file.write_file
    end
  end
end

# Configure Nginx
node.set['nginx']['default_site_enabled'] = false
node.set['nginx']['source']['modules'] = ['http_gzip_static_module', 'http_ssl_module']
include_recipe 'nginx'

node.set['nginx_conf']['confs'] = [
  node[:nginx_host] => {
    'action' => :create,
    'conf_name' => node[:nginx_conf_name],
    'upstream' => {rails: ['server unix:/tmp/unicorn.sock']},
    'root' => "#{node['unicorn']['rails_path']}/public",
    'locations' => {
      '/' => {
        'autoindex' => 'on',
        'proxy_set_header' => [ 'X-Forwarded-For $proxy_add_x_forwarded_for', 'Host $http_host', 'CLIENT_IP $remote_addr' ],
        'proxy_redirect' => 'off',

        'proxy_pass' => 'http://rails'
      }
    }
  }
]
include_recipe 'nginx_conf'

# MySQL
if(node[:install_mysql])
  include_recipe 'mysql::server'
end

package 'libsqlite3-dev'
