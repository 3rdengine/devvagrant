sudo apt-get -y install php-pear
printf "\n" | sudo pecl install mongodb
sudo phpenmod mongodb
mongo <<END
db.createUser({user:"admin",pwd:"whoFledu",roles:[{role:'userAdminAnyDatabase',db:'admin'}]});
END
sudo echo 'security.authentication: enabled' >>/etc/mongod.conf
sudo service mongod restart
mongo <<END
use lightspark
db.createUser({user:"lightsparkdemo",pwd:"lightsparkdemo",roles:[{role:"readWrite",db:"lightsparkdemo"}]});
END
sudo service mongod stop
sudo echo "[Unit]" >>/etc/systemd/system/mongodb.service
sudo echo "Description=High-performance, schema-free document-oriented database" >>/etc/systemd/system/mongodb.service
sudo echo "After=network.target" >>/etc/systemd/system/mongodb.service
sudo echo "" >>/etc/systemd/system/mongodb.service
sudo echo "[Service]" >>/etc/systemd/system/mongodb.service
sudo echo "User=mongodb" >>/etc/systemd/system/mongodb.service
sudo echo "ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf" >>/etc/systemd/system/mongodb.service
sudo echo "" >>/etc/systemd/system/mongodb.service
sudo echo "[Install]" >>/etc/systemd/system/mongodb.service
sudo echo "WantedBy=multi-user.target" >>/etc/systemd/system/mongodb.service
sudo systemctl start mongodb
sudo systemctl enable mongodb
