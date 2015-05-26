/usr/bin/mysql -uroot -e "DROP DATABASE IF EXISTS estimator;"
/usr/bin/mysql -uroot -e "CREATE DATABASE IF NOT EXISTS estimator;"
/usr/bin/mysql -uroot -e "CREATE USER 'estimator'@'localhost' IDENTIFIED BY 'estimator';"
/usr/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'estimator'@'localhost' WITH GRANT OPTION;"
/usr/bin/mysql -uroot -e "FLUSH PRIVILEGES;"

mongo --eval "db.addUser('estimator', 'estimator');" estimator
mongo --eval "db.shutdownServer();" admin

sudo mongod --dbpath /var/lib/mongodb/ --fork --logpath /var/log/mongodb/mongodb.log --auth