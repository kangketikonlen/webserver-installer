#!/bin/bash
echo -e "\e[93m=== WEBSERVER GENERATOR ===\e[0m"
echo -e "\e[32m====== TUKANG KETIK =======\e[0m"
sleep 3
if [[ $EUID -ne 0 ]]; then
	echo -e "\e[32m✅ script ini harus berjalan menggunakan user root \e[5msudo su \e[32mdulu mang.. skipped.\e[0m"
	exit 1
else
	echo -e "\e[32m✨ Got it! proceed to the debian setup.\e[0m"
	sleep 3
	chmod +x scripts/debian/*.sh
	./scripts/first.sh
	if [[ $? == 0 ]]; then
		./scripts/auto_apache.sh
	fi
	if [[ $? == 0 ]]; then
		./scripts/auto_mariadb.sh
	fi
fi
