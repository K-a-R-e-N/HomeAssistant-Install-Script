#!/bin/bash
red=$(tput setf 4) ; green=$(tput setf 2) ; reset=$(tput sgr0) ; cmdkey=0 ; ME=`basename $0` cd~ ; clear


BackupsFolder=~/HA_Backup


function Zagolovok {
echo -en "\n"
echo "╔═════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                             ║"
echo "║                 Установка Home Assistant и его зависимостей                 ║"
echo "║                                                                             ║"
echo "╚═════════════════════════════════════════════════════════════════════════════╝"
echo -en "\n"
}
function GoToMenu {
  GoToMenuInfo="Чтобы продолжить, введите"
while :
	do
	clear ; CheckBackUp=0 ; BackupRecovery=0
	Zagolovok
	echo -en "\n"
	echo "     ┌─ Выберите действие: ──────────────────────────────────────────────┐"
	echo "     │                                                                   │"
	echo -en "\n" 
	echo "           1 - Установка Home Assistant на чистой системе $InstallInfo"
	echo -en "\n"
	echo "           2 - Установка Home Assistant с полным удалением старой версии $ReinstallInfo"
	echo -en "\n"
	echo "           3 - Полное удаление Home Assistant с очисткой системы $UninstallInfo"
	echo -en "\n"
	echo "           0 - Завершение работы с самоудалением скрипта"
	echo -en "\n"
	echo "     │                                                                   │"
	echo "     └────────────────────────────────────────────── H - Вызов справки ──┘"
	echo -en "\n"
	echo -e "\a"
	echo "           $GoToMenuInfo номер пункта и нажмите на Enter"
	echo -e "\a"
	read item
	printf "\n"
	case "$item" in

		0) 	RremovalItself ;;

		1) 	ReinstallInfo="" ; InstallScript ;;

		2) 	cmdkey=1 ; UninstallScript ; cmdkey=0 ; InstallScript ;;

		3) 	ReinstallInfo="" ; UninstallScript ;;

		D|d) 	RremovalItself ;;

		H|h) 	print_help ;;

		*) 	clear && GoToMenuInfo="Попробуйте еще раз ввести" ;;

	esac
done
}




function СheckingInstalledPackage() {
InstalledPackageKey=0 ; echo -en "\n" ; echo "  # # Проверка на ранее установленную версию..."
if dpkg -l homeassistant &>/dev/null; then
	echo -en "\n" ; echo "     - В вашей системе уже установлен Home Assistant как системный пакет..."
	InstallInfo="${green}[уже установлен]${reset}"
	InstalledPackageKey=1
elif dpkg -l python3 &>/dev/null && [ -d /srv/homeassistant ] && (cd /srv/homeassistant && source ./bin/activate && pip freeze | grep -q homeassistant); then
	echo -en "\n" ; echo "     - В вашей системе уже установлен Home Assistant через PIP..."
  InstallInfo="${green}[уже установлен]${reset}"
	InstalledPackageKey=1
elif [ -d /srv/homeassistant ] &>/dev/null; then
		echo -en "\n" ; echo "     - В вашей системе обнаружена папка homeassistant..."
		InstallInfo="${red}[обнаружена папка homeassistant]${reset}"
		InstalledPackageKey=1
fi

if [ $InstalledPackageKey -eq 1 ]; then
	if [ $cmdkey -eq 1 ]; then
		echo -en "\n" ; echo -e "\a"
		read -p "${green}           Нажмите любую клавишу, чтобы завершить работу скрипта...${reset}"
		exit 0
	else
		echo -en "\n" ; echo -e "\a"
		read -p "${green}           Нажмите любую клавишу, чтобы вернуться в главное меню...${reset}"
		GoToMenu
	fi
fi
}




function BackUpScript() {

[ ! -d $BackupsFolder ] && sudo mkdir -p $BackupsFolder && sudo chmod 777 $BackupsFolder

	HA_SOURCE=/usr/share/hassio/homeassistant
	[ ! -d $HA_SOURCE ] && CheckBackUp=1 && sudo tar cfz $BackupsFolder/$(date +'%Y.%m.%d')-config.tgz -C $HA_SOURCE . > /dev/null 2>&1
	[ ! -f $HA_SOURCE/configuration.yaml ] && CheckBackUp=1 && sudo cp -f $HA_SOURCE/configuration.yaml $BackupsFolder/configuration.yaml.$(date +%s)000 >/dev/null 2>&1 
	
	HA_SOURCE=/home/$USER/.homeassistant
	[ ! -d $HA_SOURCE ] && CheckBackUp=1 && sudo tar cfz $BackupsFolder/$(date +'%Y.%m.%d')-config.tgz -C $HA_SOURCE . > /dev/null 2>&1
	[ ! -f $HA_SOURCE/configuration.yaml ] && CheckBackUp=1 && sudo cp -f $HA_SOURCE/configuration.yaml $BackupsFolder/configuration.yaml.$(date +%s)000 >/dev/null 2>&1 
	
	HA_SOURCE=/home/$USER/homeassistant
	[ ! -d $HA_SOURCE ] && CheckBackUp=1 && sudo tar cfz $BackupsFolder/$(date +'%Y.%m.%d')-config.tgz -C $HA_SOURCE . > /dev/null 2>&1
	[ ! -f $HA_SOURCE/configuration.yaml ] && CheckBackUp=1 && sudo cp -f $HA_SOURCE/configuration.yaml $BackupsFolder/configuration.yaml.$(date +%s)000 >/dev/null 2>&1  

	HA_SOURCE=/home/homeassistant/.homeassistant
	[ ! -d $HA_SOURCE ] && CheckBackUp=1 && sudo tar cfz $BackupsFolder/$(date +'%Y.%m.%d')-config.tgz -C $HA_SOURCE . > /dev/null 2>&1
	[ ! -f $HA_SOURCE/configuration.yaml ] && CheckBackUp=1 && sudo cp -f $HA_SOURCE/configuration.yaml $BackupsFolder/configuration.yaml.$(date +%s)000 >/dev/null 2>&1  

if [ $CheckBackUp -eq 1 ]; then
	echo -en "\n" ; echo "  # # Создание резервной копии конфигурационных файлов Home Assistant..."
fi
}




function InstallScript() {
clear
Zagolovok
СheckingInstalledPackage
BackUpScript

#echo -en "\n" ; echo "  # # Добавление репозитория HomeBridge..."
#curl -sSfL https://repo.homebridge.io/KEY.gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/homebridge.gpg  > /dev/null
#echo "deb [signed-by=/usr/share/keyrings/homebridge.gpg] https://repo.homebridge.io stable main" | sudo tee /etc/apt/sources.list.d/homebridge.list > /dev/null

echo -en "\n" ; echo "  # # Обновление кеша данных и индексов репозиторий..."
sudo rm -Rf /var/lib/apt/lists
sudo apt update -y > /dev/null 2>&1
sudo apt upgrade -y > /dev/null 2>&1

#echo -en "\n" ; echo "  # # Установка необходимых зависимостей"
#sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev autoconf build-essential -y > /dev/null
sudo apt-get install python3 -y > /dev/null
sudo apt-get install python3-dev -y > /dev/null
sudo apt-get install python3-venv -y > /dev/null
sudo apt-get install python3-pip -y > /dev/null
sudo apt-get install bluez -y > /dev/null
sudo apt-get install libffi-dev -y > /dev/null
sudo apt-get install libssl-dev -y > /dev/null
sudo apt-get install libjpeg-dev -y > /dev/null
sudo apt-get install zlib1g-dev -y > /dev/null
sudo apt-get install autoconf -y > /dev/null
sudo apt-get install build-essential -y > /dev/null
sudo apt-get install libopenjp2-7 -y > /dev/null
sudo apt-get install libtiff5 -y > /dev/null
sudo apt-get install libturbojpeg0-dev -y > /dev/null
sudo apt-get install tzdata -y > /dev/null

#echo -en "\n" ; echo "  # # Устранение ранее известных проблем..."
#sudo python3 -m pip -q install --no-cache-dir flask

#echo -en "\n" ; echo "  # # Установка пакета libavahi-compat-libdnssd-dev..."
#sudo apt-get install -y libavahi-compat-libdnssd-dev > /dev/null

echo -en "\n" ; echo "  # # Создание аккаунта homeassistant..."
sudo useradd -rm homeassistant -G dialout,gpio,i2c > /dev/null
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant

#Создание виртуальной среды для нового аккаунта через Bash вариант
sudo -u homeassistant -H -s bash -c 'cd /srv/homeassistant && printf "\n  # # Создание виртуальной среды для нового аккаунта...\n" && python3 -m venv . && printf "     - Активация виртуальной среды...\n" && source bin/activate && printf "     - Установка зависимостей для виртуальной среды...\n" && python3 -m pip -q install wheel && printf "\n  # # Установка Home Assistant...\n" && python3 -m pip -q install --no-cache-dir --default-timeout=100 homeassistant  > /dev/null 2>&1'
if [ $? -eq 0 ]; then
	echo "${green}[ok]${reset}"
else
	echo "${red}[false]${reset}"
fi

if [ -d /srv/homeassistant ] && (cd /srv/homeassistant && source ./bin/activate && pip freeze | grep -q homeassistant); then
  echo "     ${green}- Home Assistant успешно установлен через PIP...${reset}"
else
  echo "     {red}- Не удалось установить Home Assistant через PIP!!!${reset}"
	if [ $cmdkey -eq 1 ]; then
		echo -en "\n" ; echo -e "\a"
		read -p "${green}           Нажмите любую клавишу, чтобы завершить работу скрипта...${reset}"
		exit 0
	else
		echo -en "\n" ; echo -e "\a"
		read -p "${green}           Нажмите любую клавишу, чтобы вернуться в главное меню...${reset}"
		GoToMenu
	fi
fi

##################################################################################################################

# Очистка перед запуском специального скрипта
sudo rm -rf /srv/homeassistant/nohup.out
sudo rm -rf /srv/homeassistant/hass-progress.log
sudo rm -rf /srv/homeassistant/search_install.sh
sleep 1

#echo -en "\n" ; echo "  # # Первый запуск Home Assistant для его настройки..."
sudo -u homeassistant -H -s bash -c 'cd /srv/homeassistant && python3 -m venv . && source bin/activate && nohup hass -v &>/srv/homeassistant/hass-progress.log &'

# Создание специального скрипта
sudo tee -a /srv/homeassistant/search_install.sh > /dev/null <<_EOF_
until grep "Setting up config" /srv/homeassistant/hass-progress.log > /dev/null
  do
  sleep 10
  done
echo "     - Настройка конфигурации..."
until grep "Setting up frontend" /srv/homeassistant/hass-progress.log > /dev/null
  do
  sleep 10
  done
echo "     - Настройка внешнего интерфейса..."
until grep "Starting Home Assistant" /srv/homeassistant/hass-progress.log > /dev/null
  do
  sleep 10
  done
echo "     - Настройка сети...  нужно больше времени..."
until grep "Setting up network" /srv/homeassistant/hass-progress.log > /dev/null
  do
  sleep 10
  done
echo "     - Остальные необходимые настройки успешно завершены..."
_EOF_
sleep 1

# Запуск специального скрипта
echo "     - Инициализация Home Assistant..."
sudo -u homeassistant -H -s bash -c 'cd /srv/homeassistant && python3 -m venv . && source bin/activate && bash /srv/homeassistant/search_install.sh'

echo "     - Завершение работы Home Assistant..."
#sudo killall -w -s 9 -u homeassistant
sudo killall -s 9 -u homeassistant

# Очистка после запуска специального скрипта
sleep 1
sudo rm -rf /srv/homeassistant/nohup.out
sudo rm -rf /srv/homeassistant/hass-progress.log
sudo rm -rf /srv/homeassistant/search_install.sh

#Просмотр процессов
#htop

##################################################################################################################

echo -en "\n" ; echo "  # # Установка HASS конфигуратора"
sudo -u homeassistant -H -s bash -c 'cd /srv/homeassistant && python3 -m venv . && source bin/activate && cd /home/homeassistant/.homeassistant && wget -q https://raw.githubusercontent.com/danielperna84/hass-configurator/master/configurator.py'
sudo chmod 755 /home/homeassistant/.homeassistant/configurator.py

echo -en "\n" ; echo "  # # Добавление HASS конфигуратора в меню Home Assistant..."
sudo grep "#HASS-Configurator" /home/homeassistant/.homeassistant/configuration.yaml > /dev/null 2>&1 || sudo tee -a /home/homeassistant/.homeassistant/configuration.yaml > /dev/null 2>&1 <<_EOF_
# HASS-Configurator #
panel_iframe:
  configurator:
    title: Configurator
    icon: mdi:square-edit-outline
    url: http://$(hostname -I | tr -d ' '):3218
_EOF_

echo -en "\n" ; echo "  # # Создание службы для автозапуска Home Assistant"
sudo rm -rf /etc/systemd/system/homeassistant@homeassistant.service
sudo tee -a /etc/systemd/system/homeassistant@homeassistant.service > /dev/null <<_EOF_
[Unit]
Description=Home Assistant
After=network-online.target
[Service]
Type=simple
User=%i
ExecStart=/srv/homeassistant/bin/hass -c "/home/homeassistant/.homeassistant"
[Install]
WantedBy=multi-user.target
_EOF_

echo -en "\n" ; echo "  # # Создание службы для автозапуска HASS Configurator"
sudo rm -rf /etc/systemd/system/hass-configurator.service
sudo tee -a /etc/systemd/system/hass-configurator.service > /dev/null <<_EOF_
[Unit]
Description=HASS-Configurator
After=network.target
[Service]
Type=simple
User=homeassistant
WorkingDirectory=/home/homeassistant/.homeassistant
ExecStart=/usr/bin/python3 /home/homeassistant/.homeassistant/configurator.py
Restart=always
[Install]
WantedBy=multi-user.target
_EOF_

# Восстанавление резервной копии
if [ -f $BackupsFolder/* ]; then

	BackupRecovery=1 && echo -en "\n" && echo "  # # Восстанавление резервной копии Home Assistant в папку backup..."

	if [ ! -d /home/homeassistant/.homeassistant/backup ] ; then 
		sudo mkdir -p /home/homeassistant/.homeassistant/backup/ && sudo chown homeassistant.homeassistant /home/homeassistant/.homeassistant/backup/
	fi
	sudo mv -f $BackupsFolder/* /home/homeassistant/.homeassistant/backup/
	sudo rm -rf $BackupsFolder
fi


echo -en "\n" ; echo "  # # Создание автозагрузки и запуск служб..."
sudo systemctl -q daemon-reload
# sudo systemctl -q --system daemon-reload
sudo systemctl -q enable homeassistant@homeassistant.service
sudo systemctl -q start homeassistant@homeassistant.service
sudo systemctl -q enable hass-configurator.service
sudo systemctl -q start hass-configurator.service

echo -en "\n"
echo -en "\n"
echo -en "\n"
echo -en "\n"
echo "╔═════════════════════════════════════════════════════════════════════════════╗"
echo "║            ${green}Установка Home Assistant и его зависимостей завершена${reset}            ║"
echo "╚═════════════════════════════════════════════════════════════════════════════╝"
echo -en "\n"
echo "    ┌────────── Полезная информация для работы с Home Assistant ──────────┐"
echo "    │                                                                     │"
echo "    │                  Доступ к Home Assistant по адресу                  │"
echo "    │                      ${green}http://$(hostname -I | tr -d ' '):8123/${reset}                      │"
echo "    │                                                                     │"
echo "    │                Доступ к HASS конфигуратору по адресу                │"
echo "    │                      ${green}http://$(hostname -I | tr -d ' '):3218/${reset}                      │"
echo "    │                                                                     │"
echo "    │                      Войти в Homebridge Shell                       │"
echo "    │                            ${green}sudo hb-shell${reset}                            │"
echo "    │                                                                     │"
echo "    │                  Редактирование файла конфигурации                  │"
echo "    │     ${green}sudo nano /home/homeassistant/.homeassistant/configurator.py${reset}    │"
echo "    │                                                                     │"
echo "    │                     Перезагрузка Home Assistant                     │"
echo "    │      sudo systemctl restart homeassistant@homeassistant.service     │"
echo "    │                                                                     │"
echo "    │                   Перезагрузка HASS конфигуратора                   │"
echo "    │           sudo systemctl restart hass-configurator.service          │"
echo "    │                                                                     │"
echo "    │                  Путь хранения - ${green}/var/lib/homebridge${reset}                │"
echo "    │                   Путь плагина - ${green}/var/lib/homebridge/node_modules${reset}   │"
echo "    │                      Узел Путь - ${green}/opt/homebridge/bin/node${reset}           │"
echo "    │                                                                     │"
echo "    │                Перезагрузка HB - ${green}sudo hb-service restart${reset}            │"
echo "    │                  Остановить HB - ${green}sudo hb-service stop${reset}               │"
echo "    │                    Запустит HB - ${green}sudo hb-service start${reset}              │"
echo "    │                                                                     │"
echo "    │              Просмотр журналов - ${green}sudo hb-service logs${reset}               │"
echo "    │                                                                     │"
echo "    │                    Установка и удаление плагинов                    │"
echo "    │               ${green}sudo hb-service add homebridge-example${reset}                │"
echo "    │               ${green}sudo hb-service remove homebridge-example${reset}             │"
echo "    │                                                                     │"
echo "    └─────────────────────────────────────────────────────────────────────┘"
echo -e "\a"

InstallInfo="${green}[OK]${reset}"

if [ $cmdkey -eq 1 ]; then
	sleep 5
	return
fi

read -p "${green}           Нажмите любую клавишу, чтобы вернуться в главное меню...${reset}"
sleep 1
GoToMenu
}





function UninstallScript() {
clear
echo -en "\n"
echo "╔═════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                             ║"
echo "║    Удаление Home Assistant, а так же всех его плагинов с конфигурациями     ║"
echo "║                                                                             ║"
echo "╚═════════════════════════════════════════════════════════════════════════════╝"
echo -en "\n"

echo -en "\n" ; echo "  # # Остановка и завершение процесса Homebridge..."
####sudo systemctl stop homeassistant > /dev/null 2>&1
####sudo service homeassistant stop > /dev/null 2>&1
sudo killall -w -s 9 -u homeassistant > /dev/null 2>&1

BackUpScript

echo -en "\n" ; echo "  # # Деинсталляция Home Assistant..."
sudo pip uninstall homeassistant > /dev/null 2>&1
sudo pip3 uninstall homeassistant > /dev/null 2>&1

#echo -en "\n" ; echo "  # # Удаление репозитория Home Assistant..."
#sudo rm -rf /etc/apt/sources.list.d/HomeAssistant.list

#echo -en "\n" ; echo "  # # Деинсталляция всех плагинов и конфигурацию Home Assistant..."
#sudo apt-get purge homeassistant -y > /dev/null 2>&1

echo -en "\n" ; echo "  # # Удаление пользователя homeassistant..."
sudo userdel -rf homeassistant > /dev/null 2>&1

echo -en "\n" ; echo "  # # Удаление служб из списока автозагрузки..."
####sudo update-rc.d homeassistant remove > /dev/null 2>&1
####sudo rm -rf /etc/init.d/homeassistant*
sudo rm -rf /etc/systemd/system/homeassistant*
sudo rm -rf /etc/systemd/system/multi-user.target.wants/homeassistant*
sudo systemctl --system daemon-reload > /dev/null

echo -en "\n" ; echo "  # # Удаление хвостов, для возможности последующей нормальной установки..."
####sudo rm -rf /usr/lib/node_modules/homeassistant*
####sudo rm -rf /usr/bin/homeassistant*
####sudo rm -rf /etc/default/homeassistant*
####sudo rm -rf /var/lib/homeassistant*
####sudo rm -rf /home/pi/.homeassistant*
####sudo rm -rf /home/homeassistant*
####sudo rm -rf ~/.homeassistant*
sudo rm -rf /home/homeassistant
sudo rm -rf /srv/homeassistant
sudo rm -rf  /run/sudo/ts/homeassistant

#echo -en "\n" ; echo "  # # Удаление хвостов от плагинов..."



echo -en "\n"
echo "╔═════════════════════════════════════════════════════════════════════════════╗"
echo "  ${green}Удаление Home Assistant, а так же всех его плагинов с конфигурациями завершено${reset}"
echo "╚═════════════════════════════════════════════════════════════════════════════╝"
echo -e "\a"

UninstallInfo="${green}[OK]${reset}"

if [ $cmdkey -eq 1 ]; then
	sleep 5
	return
fi

read -p "${green}           Нажмите любую клавишу, чтобы вернуться в главное меню...${reset}"
sleep 1
GoToMenu
}





function RremovalItself() {
clear ; echo -en "\n" ; echo "                   Самоудаление папки со скриптом установки...  " ; cd
sudo rm -rf ~/HomeAssistant-Install-Script
if [ $? -eq 0 ]; then
	echo "                ${green}[Успешно удалено]${reset} - ${red}Завершение работы скрипта...${reset}" ; echo -en "\n"
else
	echo "            ${red}[Удаление не удалось] - Завершение работы скрипта...${reset}" ; echo -en "\n"
fi
sleep 1
exit 0
}



function print_help() {
	echo -en "\n"
	echo "  Справка по работе скрипта $ME из командной строки"
	echo -en "\n"
	echo "    Использование: $ME [-i] [-u] [-r] [-d] [-h] "
	echo -en "\n"
	echo "        Параметры:"
	echo "            -i        Установка Home Assistant на чистой системе."
	echo "            -u        Полное удаление Home Assistant с очисткой системы."
	echo "            -r        Установка Home Assistant с полным удалением старой версии."
	echo "            -d        Самоудаление папки со скриптом установки."
	echo -en "\n"
	echo "            -h        Вызов справки."
	echo -en "\n"
exit 0
}





# Если скрипт запущен без аргументов, открываем справку.
if [ $# = 0 ]; then
	GoToMenu
fi

while getopts ":uUiIrRhHdD" Option
	do

	cmdkey=1
 
	case $Option in

		I|i) 	InstallScript ;;

		U|u) 	UninstallScript ;;

		R|r) 	UninstallScript ; InstallScript ;;

		D|d) 	RremovalItself ;;

		H|h) 	print_help ;;

		*) 	echo -en "\n" ; echo -en "\n"
			echo "${red}           Неправильный параметр!${reset}"
			print_help ; exit 1 ;;
	esac
done

shift $(($OPTIND - 1))

exit 0
