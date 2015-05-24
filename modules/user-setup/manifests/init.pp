class user-setup ($username, $password) {
	user { $username:
		ensure => present,
		groups => ["sudo", "www-data", "vboxsf", "src"],
		shell => "/bin/bash",
		password => $password,
		system => true,
		managehome => true,
	}
}