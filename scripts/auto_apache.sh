#!/bin/bash
echo -e "\e[32m✅ assign new domain...\e[0m"
read -p "Masukan domain: " server_name
read -p "Masukan app name: " app_name
read -p "Masukan git url: " git_url

DEF_AVA=/etc/apache2/sites-available/default.conf
AVAIL_CONF=/etc/apache2/sites-available/"${app_name}".conf
APACHE_CONF=/etc/apache2/apache2.conf
WWW_FOLD=/var/www/"${app_name}".conf

if [[ -f "$DEF_AVA" ]]; then
	sudo a2dissite default
	sudo rm -rf $DEF_AVA
	echo -e "\e[32m✅ Default available conf exist.. deleted.\e[0m"
else
	echo -e "\e[32m✅ Default available conf not exist.. skipped.\e[0m"
fi

if [[ -f "$AVAIL_CONF" ]]; then
	sudo a2dissite $app_name
	rm -rf "$AVAIL_CONF"
	echo -e "\e[32m✅ ${app_name} conf avail exist.. deleted.\e[0m"
	cp -r default.conf $AVAIL_CONF
	sudo a2ensite $app_name
	echo -e "\e[32m✅ ${app_name} conf avail created.. ok.\e[0m"
else
	cp -r default.conf $AVAIL_CONF
	sudo a2ensite $app_name
	echo -e "\e[32m✅ ${server_name} conf avail created.. ok.\e[0m"
fi

sed -i "s/your_domain/${server_name}/g" $AVAIL_CONF
sed -i "s/maintenance/${app_name}/g" $AVAIL_CONF

if [[ -f "$WWW_FOLD" ]]; then
	rm -rf "$WWW_FOLD"
	echo -e "\e[32m✅ ${server_name} root folder exist.. deleted.\e[0m"
	mkdir -p "$WWW_FOLD"
	echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
	mkdir -p "$WWW_FOLD"
	echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
	git clone ${git_url} ${WWW_FOLD}
else
	mkdir -p "$WWW_FOLD"
	echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
	mkdir -p "$WWW_FOLD"/
	echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
	git clone ${git_url} ${WWW_FOLD}
fi
echo -e "\e[32m✅ change root folder ownership.. ok.\e[0m"
sudo chown -R www-data:devs /var/www/
sudo chmod -R 775 /var/www/
echo -e "\e[32m🙏 checking apache2 status.. please wait.\e[0m"
sudo service apache2 restart >/dev/null >/dev/null
if [[ $? == 0 ]]; then
	sudo service apache2 restart
	echo -e "\e[32m✅ apache2 SUCCESSFULLY CONFIGURED\e[0m"
	echo -e "\e[36m💌 Hooray! ${server_name} sudah live. Silahkan kembali ke user non administrator anda dan ganti isi folder ${WWW_FOLD}/html/ dengan aplikasimu!\e[0m"
	exit 0
else
	rm -rf $AVAIL_CONF
	rm -rf $ENA_CONF
	rm -rf $WWW_FOLD
	echo -e "\e[31m❌ ERROR apache2 CONFIG FAILED ROLLBACK!\e[0m"
	exit 1
fi