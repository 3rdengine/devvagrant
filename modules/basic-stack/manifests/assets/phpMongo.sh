sudo apt-get -y install php-pear
sudo apt-get -y install php5-dev
sudo apt-get -y install libcurl3-openssl-dev
printf "\n" | sudo pecl install mongo


echo "extension=mongo.so" | sudo tee -a /etc/php5/cli/php.ini
echo "extension=mongo.so" | sudo tee -a /etc/php5/apache2/php.ini
