export MAINUSER=tonyvance
sudo su -c "useradd tonyvance -s /bin/bash -m"

sudo chpasswd << 'END'
tonyvance:angelfire3
END

usermod -a -G www-data tonyvance
usermod -a -G vboxsf tonyvance
usermod -a -G sudo tonyvance