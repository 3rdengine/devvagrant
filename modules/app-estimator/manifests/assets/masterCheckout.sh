mkdir /var/www/estimator
mkdir /var/www/estimator/master

cd /var/www/estimator/master
git clone https://$1:$2@github.com/latentcodex/estimator.git .
git checkout master

sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www

sudo npm install

sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www

grunt dev

sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www

sudo composer update
sudo composer install

sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www


cat /etc/apache2/sites-available/estimator.local.conf |sed "s/estimator.local/master.estimator.local/g" |sed "s/\/var\/www\/estimator/\/var\/www\/estimator\/master\/dist/g" |sudo tee /etc/apache2/sites-enabled/master.estimator.local.conf > /dev/null

cat /etc/apache2/sites-available/estimator.web.local.conf |sed "s/web.estimator.local/master.web.estimator.local/g" |sed "s/\/var\/www\/estimator/\/var\/www\/estimator\/master\/web/g" |sudo tee /etc/apache2/sites-enabled/master.web.estimator.local.conf > /dev/null

mkdir /home/$3/config
cp /vagrant/modules/app-estimator/manifests/assets/phinx.yml /home/$3/config/
cp /vagrant/modules/app-estimator/manifests/assets/phinx.yml ./

bin/phinx status
bin/phinx migrate

sudo /etc/init.d/apache2 restart
