# Install our dependencies

# ImageMagick
# Mongo
# checkout master
# setup master apache configs
# migrate estimator database
# setup code coverage
# setup xhprof
# change newproject and closeproject to use sites-enabled/ubirimi
# setup ssh key for github
# setup xdebug and remote debugging


exec { "apt-get update":
  path => "/usr/bin",
}

package { "python-software-properties":
  ensure => present,
  before => Exec["add-apt-repository ppa:ondrej/php5"],
  require => Exec["apt-get update"],
}

exec { "add-apt-repository ppa:ondrej/php5":
  command => "/usr/bin/add-apt-repository ppa:ondrej/php5",
  require => Package["python-software-properties"]
}

exec { "apt-get update ppa:ondrej/php5":
  command => "/usr/bin/apt-get update",
  require => Exec["add-apt-repository ppa:ondrej/php5"],
}

exec { "add-apt-repository ppa:ondrej/mysql-5.6":
  command => "/usr/bin/add-apt-repository ppa:ondrej/mysql-5.6",
  require => Package["python-software-properties"]
}

exec { "apt-get update ppa:ondrej/mysql-5.6":
  command => "/usr/bin/apt-get update",
  require => Exec["add-apt-repository ppa:ondrej/mysql-5.6"],
}

exec { "add-apt-repository ppa:ondrej/apache2":
  command => "/usr/bin/add-apt-repository ppa:ondrej/apache2",
  require => Exec["add-apt-repository ppa:ondrej/php5"]
}

exec { "apt-get update ppa:ondrej/apache2":
  command => "/usr/bin/apt-get update",
  require => [Exec["add-apt-repository ppa:ondrej/apache2"], Exec["add-apt-repository ppa:ondrej/php5"]],
}

exec { "add-apt-repository ppa:nijel/phpmyadmin":
  command => "/usr/bin/add-apt-repository ppa:nijel/phpmyadmin",
  require => Exec["apt-get update ppa:ondrej/apache2"]
}

exec { "apt-get update ppa:nijel/phpmyadmin":
  command => "/usr/bin/apt-get update",
  require => Exec["add-apt-repository ppa:nijel/phpmyadmin"]
}

package { "curl":
  ensure => present,
  #require => Exec["apt-get update ppa:nijel/phpmyadmin"],
  require => Exec["apt-get update ppa:ondrej/apache2"],
}

exec { 'install composer':
  command => '/usr/bin/curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
  require => Package['curl'],
}

package {"apache2":
  ensure => present,
  require => [Exec["apt-get update ppa:ondrej/php5"], Exec["apt-get update ppa:ondrej/apache2"]]
}


# mysql packages
package {["mysql-server", "mysql-client"]:
  ensure => installed,
  require => Exec["apt-get update ppa:ondrej/apache2"]
}

service { "mysql":
  ensure  => running,
  require => Package["mysql-server"],
}

package { ["php5-common",
          "libapache2-mod-php5",
          "php5-cli",
#          "php-apc",
          "php5-mysql",
          "php5-gd",
          "php5-mysqlnd",
          "php5-curl"
#          "php5-xdebug"
          ]:
  ensure => installed,
  notify => Service["apache2"],
  require => [Exec["apt-get update ppa:ondrej/apache2"], Package["mysql-client"], Package["apache2"]],
}

exec { "/usr/sbin/a2enmod rewrite" :
  unless => "/bin/readlink -e /etc/apache2/mods-enabled/rewrite.load",
  notify => Service[apache2],
  require => Package["apache2"]
}

service { "apache2":
  ensure => "running",
  enable => true,
  require => Package["apache2"]
}

package { ["git"]:
  ensure => installed
}


# Set up a new VirtualHost


#file { "/etc/apache2/sites-available/ubirimi":
#  ensure => "link",
#  target => "/vagrant/manifests/assets/ubirimi.conf",
##  require => Package["apache2"],
#  notify => Service["apache2"],
#  replace => yes,
#  force => true,
#}

#file { "/etc/apache2/sites-enabled/ubirimi.conf":
#  ensure  => "link",
#  target  => "/vagrant/manifests/assets/ubirimi.conf",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#  replace => yes,
#  force   => true,
#}

#exec { "Disable apache 000-default" :
#  command => "/usr/sbin/a2dissite 000-default",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#}

#exec { "Reload apache" :
#  command => "/usr/sbin/service apache2 reload",
#  notify  => Service["apache2"],
##  require => [Exec['Disable apache 000-default']],
#  refreshonly => true,
#}

# Setup xdebug
file { '/etc/php5/mods-available/xdebug.ini':
  ensure => file,
  source => '/vagrant/manifests/assets/xdebug.ini',
  require => Package["apache2"],
  notify  => Service["apache2"],
}

# Set Apache to run as the Vagrant user

#exec { "ApacheUserChange" :
#  command => "/bin/sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
#  onlyif  => "/bin/grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#}

#exec { "ApacheGroupChange" :
#  command => "/bin/sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
#  onlyif  => "/bin/grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#}

#exec { "apache_lockfile_permissions" :
#  command => "/bin/chown -R vagrant:www-data /var/lock/apache2",
#  require => Package["apache2"],
#  notify  => Service["apache2"],
#}


# Setup Default BashRC
exec { 'setup bashrc':
	command => '/bin/cat /vagrant/manifests/assets/bashrc >> /etc/skel/.bashrc',
	require => Service['apache2'],
}

# Create main user
exec { 'create user':
  command => '/vagrant/manifests/assets/createUser.sh',
  require => Exec['setup bashrc'],
}

# Setup the initial database
exec { "drop existing estimator database" :
  command => "/usr/bin/mysql -uroot -e \"drop database if exists estimator;\"",
  require => Service["mysql"],
}

exec { "create estimator database" :
  command => "/usr/bin/mysql -uroot -e \"create database if not exists estimator;\"",
  logoutput => on_failure,
  require => [Service["mysql"], Exec['drop existing estimator database']]
}

exec { "create estimator user" :
  command => "/usr/bin/mysql -uroot -e \"CREATE USER 'estimator'@'localhost' IDENTIFIED BY 'estimator';\"",
  logoutput => on_failure,
  require => [Service["mysql"], Exec['create estimator database']]
}

exec { "grant estimator user permissions" :
  command => "/usr/bin/mysql -uroot -e \"GRANT ALL PRIVILEGES ON *.* TO 'estimator'@'localhost' WITH GRANT OPTION;\"",
  logoutput => on_failure,
  require => [Service["mysql"], Exec['create estimator user']]
}

exec { "flush privileges" :
  command => "/usr/bin/mysql -uroot -e \"FLUSH PRIVILEGES;\"",
  logoutput => on_failure,
  require => [Service["mysql"], Exec['grant estimator user permissions']]
}

# Install PHP My Admin
exec { 'install phpmyadmin':
  command => '/bin/bash /vagrant/manifests/assets/phpMyAdmin.sh',
  require => [Exec['flush privileges'], Package['mysql-client']],
}


# composer install

#exec { 'run install composer':
#  path => "/usr/bin:/usr/sbin:/bin",
#  environment => "HOME=/root",
#  command => '/usr/local/bin/composer install --working-dir /var/www/products',
#  timeout => 0,
#  require => [Package["apache2"],Exec['install composer']]
#}

# create assets folders

#exec { 'create assets folder':
#  command => '/bin/mkdir /var/www/assets; /bin/mkdir -p /var/www/assets/documentador/attachments; /bin/mkdir -p /var/www/assets/documentador/filelists; /bin/mkdir -p #/var/www/assets/yongo/attachments; /bin/mkdir -p /var/www/assets/users;',
#  require => [Exec['run install composer']]
#}