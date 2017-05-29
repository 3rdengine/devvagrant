class basic-stack ($username, $password, $mysql_root_password) {
	exec  { 'initial_update':
		command => 'apt-get update',
		path => '/usr/bin',
	}
	
	package { 'python-software-properties':
		ensure => present,
		require => exec['initial_update'],
	}
	
	
	#########################################################################################
	## Include PPAs
	
#	exec { 'ondrej_php5':
#		command => '/usr/bin/add-apt-repository ppa:ondrej/php5',
#		require => package['python-software-properties']
#	}
#	
#	exec { 'repository_update':
#		command => '/usr/bin/apt-get update',
#		require => [
#			exec['ondrej_php5'], exec['ondrej_mysql56'], exec['ondrej_apache2'], exec['nijel_phpmyadmin']
#		]
#	}


	#########################################################################################
	## Install cURL, git, apache2, php5, composer, phpMyAdmin, mysql, mongo DB
	
	package { 'curl':
		ensure => present,
		require => exec['repository_update'],
	}
	
	package { 'apache2':
		ensure => present,
		require => exec['repository_update']
	}
	
	package { ['mysql-server', 'mysql-client']:
		ensure => installed,
		require => exec['repository_update']
	}
	
	exec { 'install_nodejs':
		command => 'apt-get -y install nodejs',
		require => exec['repository_update']
	}
	
	exec { 'install_npm':
		command => 'apt-get -y install npm',
		require => exec['install_nodejs']
	}
	
	service { 'mysql':
		ensure  => running,
		require => package['mysql-server'],
	}
	
	exec { 'install_mongodb':
		command => '/usr/bin/apt-get install -y mongodb',
		require => service['mysql']
	}
	
	package { 
		[
			'php5-common', 
			'libapache2-mod-php5',
			'php5-cli',
#			'php-apc',
			'php5-mysql',
			'php5-gd',
			'php5-mysqlnd',
			'php5-curl',
#			'php5-xdebug'
		]:
		ensure => installed,
		notify => service['apache2'],
		require => [exec['repository_update'], package['mysql-client'], package['apache2']],
	}
	
	exec { 'install_composer':
		command => '/usr/bin/curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
		require => [package['curl'], package['php5-common'], package['php5-cli']],
	}
	
	exec { '/usr/sbin/a2enmod rewrite' :
		unless => '/bin/readlink -e /etc/apache2/mods-enabled/rewrite.load',
		notify => service['apache2'],
		require => package['apache2']
	}
	
	service { 'apache2':
		ensure => 'running',
		enable => true,
		require => package['apache2']
	}
	
	exec { 'install_mongo_php_driver':
		command => '/bin/bash /vagrant/modules/basic-stack/manifests/assets/phpMongo.sh',
		require => [package['apache2'], package['libapache2-mod-php5'], exec['install_mongodb']],
		notify => service['apache2'],
	}
	
	package { ['git']:
		ensure => installed
	}
	
	exec { 'install_samba':
		command => "/bin/bash /vagrant/modules/basic-stack/manifests/assets/installSamba.sh ${username} ${password}",
		require => exec['install_mongo_php_driver']
	}
	
	exec { 'secure_mysql':
		command => "mysqladmin -u root password ${mysql_root_password}",
		require => package['mysql-server']
	}
	
	exec { 'install_phpmyadmin':
		command => '/bin/bash /vagrant/modules/basic-stack/manifests/assets/phpMyAdmin.sh',
		require => [package['mysql-client'], package['mysql-server']],
		notify => service['apache2'],
	}
	
	exec { 'install_grunt':
		command => 'npm install -g grunt-cli',
		require => exec['install_npm']
	}
	
	exec { 'install_bower':
		command => 'npm install -g bower',
		require => exec['install_grunt']
	}
	
	exec { 'npm_path':
		command => 'ln -s /usr/bin/nodejs /usr/bin/node',
		require => exec['install_bower']
	}
}
