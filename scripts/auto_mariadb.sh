#!/bin/bash
echo 🙏 MARIADB CONFIG GENERATOR
echo 🥰 TUKANG KETIK
sleep 3
MARIA_CONF=/etc/mysql/mariadb.conf.d/50-server.cnf
RESULT_VARIABLE="$(mysql -u root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$user_db')")"
sed -i "s/127.0.0.1/0.0.0.0/g" $MARIA_CONF
echo -e "\e[32m✅ remote database activated.. ok.\e[0m"
sudo service mysql restart
echo -e "\e[32m🙏 restarting database server.. please wait.\e[0m"
if [[ $? == 0 ]]; then
	echo -e "\e[32m✨ DATABASE SUCCESSFULLY CONFIGURED\e[0m"
	Q1="CREATE USER 'fath_dev'@'%' IDENTIFIED BY 'older45.,';"
	Q2="GRANT ALL PRIVILEGES ON *.* TO 'fath_dev'@'%';"
	Q3="FLUSH PRIVILEGES;"
	QUERYS="${Q1}${Q2}${Q3}"

	mysql -uroot -e "$QUERYS"
	echo -e "\e[32m🙏 creating username and database.. please wait.\e[0m"

	if [[ $? == 0 ]]; then
		sed -i "s/127.0.0.1/0.0.0.0/g" $MARIA_CONF
		echo -e "\e[32m✅ remote database activated.. ok.\e[0m"
		sudo service mysql restart
		echo -e "\e[32m🙏 restarting database server.. please wait.\e[0m"
		if [[ $? == 0 ]]; then
			echo -e "\e[32m✨ DATABASE SUCCESSFULLY CONFIGURED\e[0m"
			echo -e "\e[36m💌 Hooray! fath_dev berhasil di daftarkan. Silahkan login menggunakan username: fath_dev dan password: older45., secara remote atau non remote.\e[0m"
			exit 0
		else
			echo -e "\e[31m‼️ DATABASE FAILED TO CONFIGURE\e[0m"
			exit 0
		fi
	else
		echo -e "\e[31m‼️ DATABASE FAILED TO CONFIGURE\e[0m"
		exit 0
	fi
else
	echo -e "\e[31m‼️ DATABASE FAILED TO CONFIGURE\e[0m"
	exit 0
fi
