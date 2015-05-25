class engine-dev ($username) {
	exec { 'engine_bashrc':
		command => '/bin/cat /vagrant/modules/engine-dev/manifests/assets/bashrc >> /etc/skel/.bashrc',
		before => user[$username],
	}
	
	exec { 'setup_coverage':
		command => '/bin/bash /vagrant/modules/engine-dev/manifests/assets/coverage.sh',
		require => service['apache2']
	}
}