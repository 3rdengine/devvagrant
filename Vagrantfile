# /Vagrantfile
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

#  config.vm.hostname = "thirdengine.local"

  config.vm.define 'thirdengine' do |node|
    node.vm.hostname = 'thirdengine.local'
    node.vm.network :private_network, ip: '192.168.42.42'
  end
  
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  # Distributor ID:	Ubuntu
  # Description:	Ubuntu 14.04 LTS
  # Release:	    14.04
  # Codename:	    trusty
  config.vm.box = "ubuntu/trusty64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  # Forward MySql port on 33066, used for connecting admin-clients to localhost:33066
  config.vm.network "forwarded_port", guest: 3306, host: 33066
  # Forward http port on 8080, used for connecting web browsers to localhost:8080
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.ssh.password = "vagrant"
  config.ssh.forward_agent = true

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  config.vm.provision "puppet" do |puppet|
	puppet.module_path = "modules"
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
	puppet.hiera_config_path = "hiera/hiera.yaml"
    puppet.options = "--verbose"
  end
  
end
