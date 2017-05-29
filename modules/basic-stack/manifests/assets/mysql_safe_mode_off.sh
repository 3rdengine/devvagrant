sudo echo "[mysqld]" >>/etc/mysql/conf.d/disable_strict_mode.cnf
sudo echo "sql_mode=IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >>/etc/mysql/conf.d/disable_strict_mode.cnf
sudo service mysql restart
