# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.define :development do |dev|

    dev.vm.box = "ubuntu-server-64"
    dev.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04-omnibus-chef.box"

    dev.vm.hostname = ''

    dev.vm.network :forwarded_port, guest: 80, host: 8083
    dev.vm.network :forwarded_port, guest: 3000, host: 3000
    dev.omnibus.chef_version = :latest

    dev.vm.network :private_network, ip: ''

    dev.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    dev.vm.provision :chef_solo do |chef|
      chef.json = {
        mysql: { server_root_password: "", server_repl_password: "", server_debian_password: "", host: 'localhost' },
        install_mysql: true,
        environment: 'development',
        unicorn: { rails_path: '/vagrant' },
        nginx_host: 'dev.nome_do_projeto.com.br',
        nginx_conf_name: 'conf_default'
      }

      chef.cookbooks_path = "chef/cookbooks"
      chef.add_recipe 'default'
    end

    dev.vm.provision :shell, path: 'vagrant_scripts/after_script.sh'
  end

  config.vm.define :staging do |instance|

    instance.vm.box = "dummy"
    instance.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

    instance.omnibus.chef_version = :latest

    instance.vm.provider :aws do |aws, override|
      aws.access_key_id = ""
      aws.secret_access_key = ""

      aws.instance_type = 't1.micro'

      # aws.region = 'us-west-2'
      # aws.ami = 'ami-30079e00' # Precise disponivel em us-west-2
      
      # aws.region = 'sa-east-1'
      # aws.ami = 'ami-a3da00be' # Precise disponivel em sa-east-1

      aws.keypair_name = ""

      aws.security_groups = ['default']
      
      #Quaisquer tags que quiser utilizar na instância. Elas aparecerão no console
      aws.tags = {  }

      override.ssh.private_key_path = File.join(File.dirname(__FILE__), 'aws_keys', '')
      override.ssh.username = 'ubuntu'

      override.vm.provision :chef_solo do |chef|
        chef.json = {
          mysql: { server_root_password: '', server_repl_password: '', server_debian_password: '', host: 'localhost' },
          install_mysql: true,
          environment: 'staging',
          unicorn: { rails_path: File.join('home', 'ubuntu', '', 'current') },
          nginx_host: 'staging.nome_do_projeto.com.br',
          nginx_conf_name: 'conf_default'
        }

        chef.cookbooks_path = "chef/cookbooks"
        chef.add_recipe 'default'
      end 

      override.vm.provision :shell, path: 'vagrant_scripts/after_script.sh'
    end
  end

end