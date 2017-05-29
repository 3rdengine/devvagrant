Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


class { 'basic-stack':
	username => hiera(username),
	password => hiera(password),
	mysql_root_password => hiera(mysql_root_password)
}

class { 'engine-dev':
	username => hiera(username)
}

class { 'user-setup':
	username => hiera(username),
	password => hiera(password),
}

#exec { 'www_permissions':
#	command => 'chown -R www-data:www-data /var/www && chmod -R 775 /var/www',
#	require => class['app-estimator']
#}