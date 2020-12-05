#!/bin/bash
## ======= WEBSERVER AUTOMATION ======= ##
## =======++++ TUKANG KETIK ++++======= ##
#
### setup variables
PHP_VER=7.4
MARIADB_VER=10.5
### perl warning fix
apt install sudo net-tools -y
localedef -i en_US -f UTF-8 en_US.UTF-8
sudo timedatectl set-timezone Asia/Jakarta
cat >/etc/environment <<EOF
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
EOF
echo 'LANG=en_US.utf-8' >>~/.bashrc
echo 'LC_ALL=en_US.utf-8' >>~/.bashrc
source ~/.bashrc
### disable ipv6 because it's buggy here.
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >>/etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >>/etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >>/etc/sysctl.conf
echo 1 >/proc/sys/net/ipv6/conf/default/disable_ipv6
echo 1 >/proc/sys/net/ipv6/conf/all/disable_ipv6
### add additional sources.
echo 'deb http://ftp.debian.org/debian stretch-backports main' >>/etc/apt/sources.list
sudo apt update && sudo apt upgrade -y
### installing apache2.
sudo apt install apache2 -y
### installing lattest PHP.
sudo apt -y install lsb-release apt-transport-https ca-certificates
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update && sudo apt upgrade -y && sudo apt -y install php${PHP_VER}
sudo apt-get install php${PHP_VER}-{bcmath,bz2,intl,gd,mbstring,mysql,zip} -y
# install latest mariadb
sudo apt -y install software-properties-common dirmngr
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8
sudo add-apt-repository "deb [arch=amd64,i386,ppc64el] http://mirror.zol.co.zw/mariadb/repo/${MARIADB_VER}/debian stretch main"
sudo apt update && sudo apt install mariadb-server mariadb-client -y
# installing additional apps
sudo apt install htop nethogs git ufw -y
sudo apt install python-certbot-apache -t stretch-backports -y
# configure firewall
ufw allow ssh
ufw allow 80
ufw allow 443
ufw allow 3306
ufw allow 14045
# configure apache2
sudo a2dissite 000-default.conf
sudo a2enmod rewrite
rm -rf /etc/apache2/sites-available/*
rm -rf /var/www/*
# configure users & folders
sed -i "s/#Port 22/Port 14045/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sudo service ssh restart
sudo addgroup devs
echo -e "\e[32m✅ creating devs users...\e[0m"
read -p "Masukkan username devs: " username
read -p "Masukkan password devs: " password
sudo adduser --disabled-password --gecos "" $username
if [[ $? == 0 ]]; then
	echo "akasakaryu:${password}" | chpasswd
	echo -e "\e[32m✅ devs users created.. ok.\e[0m"
else
	echo -e "\e[32m✅ devs users exists or fail to create please create it manually.\e[0m"
fi
usermod -aG sudo $username
usermod -aG devs $username
sudo chown -R www-data:devs /var/www/
sudo chmod -R 775 /var/www/
git clone https://github.com/fathtech/maintenance.git /var/www/maintenance
touch /etc/apache2/sites-available/default.conf
cat >/etc/apache2/sites-available/default.conf <<EOF
<VirtualHost *:80>
	#ServerName your_domain
	ServerAdmin support@fathtech.co.id
	DocumentRoot /var/www/maintenance

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
sudo a2ensite default.conf
sudo service apache2 restart
