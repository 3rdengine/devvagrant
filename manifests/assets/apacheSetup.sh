sudo mkdir /var/www/estimator
sudo mkdir /var/www/coverage
sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www

cp /vagrant/manifests/assets/estimator.local.conf /etc/apache2/sites-available/
cp /vagrant/manifests/assets/estimator.web.local.conf /etc/apache2/sites-available/
cp /vagrant/manifests/assets/coverage.local.conf /etc/apache2/sites-enabled/