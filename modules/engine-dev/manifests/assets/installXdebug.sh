sudo apt-get -y install xdebug

echo "" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_enable=1" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_connect_back=1" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.idekey=\"PhpStorm1\"" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_mode=req" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_port=9000" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_host=localhost" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_handler=dbgp" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_autostart=0" | sudo tee -a /etc/php5/apache2/php.ini
echo "xdebug.remote_log=/tmp/xdebug.log" | sudo tee -a /etc/php5/apache2/php.ini

echo "" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_enable=1" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_connect_back=1" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.idekey=\"PhpStorm1\"" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_mode=req" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_port=9000" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_host=localhost" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_handler=dbgp" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_autostart=1" | sudo tee -a /etc/php5/cli/php.ini
echo "xdebug.remote_log=/tmp/xdebug.log" | sudo tee -a /etc/php5/cli/php.ini