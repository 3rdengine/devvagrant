sudo apt-get -y install php-pear
sudo apt-get -y install php5-dev
sudo apt-get -y install libcurl3-openssl-dev
printf "\n" | sudo pecl install mongo


cp /etc/php5/cli/php.ini /home/vagrant/cli.ini
cp /etc/php5/apache2/php.ini /home/vagrant/apache2.ini
echo "extension=mongo.so\n" | sudo tee -a /etc/php5/cli/php.ini
echo "extension=mongo.so\n" | sudo tee -a /etc/php5/apache2/php.ini
echo "extension=mongo.so\n" | sudo tee -a /home/vagrant/cli.ini
echo "extension=mongo.so\n" | sudo tee -a /home/vagrant/apache2.ini