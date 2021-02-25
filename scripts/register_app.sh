echo -e "\e[32m✅ assign new app...\e[0m"
read -p "Masukan app name: " app_name
read -p "Masukan git url: " git_url
### Creating folders
WWW_FOLD=/var/www/${app_name}
CONF_FOLD=/usr/local/lsws/conf/vhost/${app_name}

if [[ -f "$WWW_FOLD" ]]; then
    rm -rf "$WWW_FOLD"
    echo -e "\e[32m✅ ${server_name} root folder exist.. deleted.\e[0m"
    mkdir -p "$WWW_FOLD/{html,repo}"
    echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
    mkdir -p "$WWW_FOLD/{html,repo}"
    echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
    git clone ${git_url} ${WWW_FOLD}/repo/
else
    mkdir -p "$WWW_FOLD/{html,repo}"
    echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
    mkdir -p "$WWW_FOLD/{html,repo}"/
    echo -e "\e[32m✅ ${server_name} root folder created.. ok.\e[0m"
    git clone ${git_url} ${WWW_FOLD}/repo/
fi

sudo cp -r ols_default ${CONF_FOLD}
sudo chown -R lsadm:nogroup ${CONF_FOLD}
"\e[32m✅ DONE Edit manualy from your ip_address:7080\e[0m"
