#!/bin/bash
echo 🙏 MARIADB CONFIG GENERATOR
echo 🥰 TUKANG KETIK
sleep 3
read -p "Masukkan username database: " user_db
read -p "Masukkan password database: " pass_db
MARIA_CONF=/etc/mysql/mariadb.conf.d/50-server.cnf
if [[ -z "${user_db}" ]]; then
	echo -e "\e[31m❌ USER DATABASE TIDAK BOLEH KOSONG!\e[0m"
	exit 1
else
	if [[ -z "${pass_db}" ]]; then
		echo -e "\e[31m❌ PASSWORD DATABASE TIDAK BOLEH KOSONG!\e[0m"
		exit 1
	else
		RESULT_VARIABLE="$(mysql -u root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$user_db')")"
		if [ "$RESULT_VARIABLE" = 1 ]; then
			echo -e "\e[32m✅ username exist.. skipped.\e[0m"
			sed -i "s/127.0.0.1/0.0.0.0/g" $MARIA_CONF
			echo -e "\e[32m✅ remote database activated.. ok.\e[0m"
			sudo service mysql restart
			echo -e "\e[32m🙏 restarting database server.. please wait.\e[0m"
			if [[ $? == 0 ]]; then
				echo -e "\e[32m✨ DATABASE SUCCESSFULLY CONFIGURED\e[0m"
				exit 0
			else
				echo -e "\e[31m‼️ DATABASE FAILED TO CONFIGURE\e[0m"
				exit 0
			fi
		else
			Q1="CREATE USER '"${user_db}"'@'%' IDENTIFIED BY '"${pass_db}"';"
			Q2="GRANT ALL PRIVILEGES ON *.* TO '"${user_db}"'@'%';"
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
					echo -e "\e[36m💌 Hooray! ${user_db} berhasil di daftarkan. Silahkan login menggunakan username: ${user_db} dan password: ${pass_db} secara remote atau non remote.\e[0m"
					exit 0
				else
					echo -e "\e[31m‼️ DATABASE FAILED TO CONFIGURE\e[0m"
					exit 0
				fi
			else
				echo -e "\e[31m‼️ DATABASE FAILED TO CONFIGURE\e[0m"
				exit 0
			fi
		fi
	fi
fi
