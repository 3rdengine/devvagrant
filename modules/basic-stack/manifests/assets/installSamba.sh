sudo apt-get -y install samba cifs-utils

echo "security = user" | sudo tee -a /etc/samba/smb.conf
echo "username map = /etc/samba/smbusers" | sudo tee -a /etc/samba/smb.conf

echo "" | sudo tee -a /etc/samba/smb.conf
echo "[www]" | sudo tee -a /etc/samba/smb.conf
echo "path = /var/www" | sudo tee -a /etc/samba/smb.conf
echo "available = yes" | sudo tee -a /etc/samba/smb.conf
echo "valid users = $1" | sudo tee -a /etc/samba/smb.conf
echo "read only = no" | sudo tee -a /etc/samba/smb.conf
echo "browseable = yes" | sudo tee -a /etc/samba/smb.conf
echo "public = yes" | sudo tee -a /etc/samba/smb.conf
echo "writable = yes" | sudo tee -a /etc/samba/smb.conf

echo "" | sudo tee -a /etc/samba/smb.conf
echo "[home]" | sudo tee -a /etc/samba/smb.conf
echo "path = /home/$1" | sudo tee -a /etc/samba/smb.conf
echo "available = yes" | sudo tee -a /etc/samba/smb.conf
echo "valid users = $1" | sudo tee -a /etc/samba/smb.conf
echo "read only = no" | sudo tee -a /etc/samba/smb.conf
echo "browseable = yes" | sudo tee -a /etc/samba/smb.conf
echo "public = yes" | sudo tee -a /etc/samba/smb.conf
echo "writable = yes" | sudo tee -a /etc/samba/smb.conf

(echo $2; echo $2) | sudo smbpasswd -as $1

echo "$1 = \"$1\"" | sudo tee -a /etc/samba/smbusers