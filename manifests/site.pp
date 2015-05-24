Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


include basic-stack

class { 'user-setup':
	username => hiera(username),
	password => hiera(password)
}