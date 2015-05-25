Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


class { 'basic-stack':
	mysql_root_password => hiera(mysql_root_password)
}

class { 'engine-dev':
	username => hiera(username)
}

class { 'user-setup':
	username => hiera(username),
	password => hiera(password),
}

class { 'app-estimator':
	github_username => hiera(github_username),
	github_password => hiera(github_password),
	username => hiera(username),
}

#exec { 'www_permissions':
#	command => 'chown -R www-data:www-data /var/www && chmod -R 775 /var/www',
#	require => class['app-estimator']
#}