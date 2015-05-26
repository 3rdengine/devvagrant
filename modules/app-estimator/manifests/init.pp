class app-estimator ($github_username, $github_password, $username) {
	exec { 'estimator_db_setup':
		command => '/bin/bash /vagrant/modules/app-estimator/manifests/assets/dbSetup.sh',
		require => [service['mysql'], exec['install_phpmyadmin'], exec['install_mongodb']]
	}
	
	exec { 'place_conf_templates':
		command => 'cp /vagrant/modules/app-estimator/manifests/assets/estimator.* /etc/apache2/sites-available/',
		require => service['apache2']
	}
	
	exec { 'checkout_master':
		timeout => 600,
		command => "sudo /bin/bash /vagrant/modules/app-estimator/manifests/assets/masterCheckout.sh ${github_username} ${github_password} ${username}",
		require => [exec['place_conf_templates'], exec['npm_path']]
	}
}