#!/bin/bash
#set -x
clear

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
  while :
  do
  echo -en "\n"
  echo "        ┌─ Выберите действие: ────────────────────────────────────────┐"
  echo "        │                                                             │"
  echo "        │       1 - Предварительно очистить систему                   │"
  echo "        │       2 - Продолжить без очистки системы (Для опытных)      │"
  echo "        │       3 - Завершить работу скрипта                          │"
  echo "        │                                                             │"
  echo "        └─────────────────────────────────────────────────────────────┘"
  echo "           Чтобы продолжить, введите номер пункта и нажмите на Enter"
  echo -e "\a"
  read a
  printf "\n"
  case $a in
  1)     echo "                     - Предварительная очистка системы..." && sleep 2 && clear && Zagolovok && bash uninstall.sh && return;;
  2)     echo "                  - Выполнение скрипта без очистки системы..." && sleep 2 && clear && Zagolovok
                                            if [ -f /home/homeassistant/.homeassistant/configuration.yaml ]; then
                                            echo -en "\n" ; echo "  # # Создание резервной копии конфигурационного файла Home Assistant..."
                                            sudo mkdir -p ~/HA_BackUp && sudo chmod 777 ~/HA_BackUp
                                            sudo cp -f /home/homeassistant/.homeassistant/configuration.yaml ~/HA_BackUp/configuration.yaml.$(date +%s)000
                                            fi
                                            return;;
  3)     echo "               - Завершение работы скрипта..." && exit 0;;
  *)     echo "                           Попробуйте еще раз.";;
  esac
  done
}

Zagolovok

echo -en "\n" ; echo "# # Проверка на ранее установленную версию..."
if dpkg -l homeassistant &>/dev/null; then
  echo -en "\n" ; echo "     - В вашей системе уже установлен Home Assistant как системный пакет..."
  GoToMenu
elif dpkg -l python3 &>/dev/null; then
  if [ -d /srv/homeassistant ] && (cd /srv/homeassistant && source bin/activate && pip freeze | grep -q homeassistant); then
    echo -en "\n" ; echo "     - В вашей системе уже установлен Home Assistant из PIP3..."
  else
    echo "     - Ранее установленых пакетов не обнаружено, кроме Python3..."
  fi
else
  echo "     - Ранее установленых пакетов не обнаружено..."
fi

echo -en "\n" ; echo "# # Обновление списка пакетов..."
sudo apt-get update > /dev/null

echo -en "\n" ; echo "# # Установка необходимых зависимостей"
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev -y > /dev/null

#echo -en "\n" ; echo "# # Установка пакетов XXXXXXXXXXXXXXXXXXXX python..."

echo -en "\n" ; echo "# # Установка пакета libavahi-compat-libdnssd-dev..."
sudo apt-get install -y libavahi-compat-libdnssd-dev > /dev/null

#echo -en "\n" ; echo "# # Устранение ранее известных проблем..."

echo -en "\n" ; echo "# # Создание аккаунта под названием homeassistant"
sudo useradd -rm homeassistant -G dialout,gpio,i2c > /dev/null

echo -en "\n" ; echo "# # Создание каталога homeassistant с передачей прав новому аккаунту"
cd /srv
sudo mkdir homeassistant
sudo chown homeassistant:homeassistant homeassistant

echo -en "\n" ; echo "# # Создание виртуальной среды для нового аккаунта"
sudo rm -rf /srv/homeassistant/nohup.out ; sudo rm -rf /srv/homeassistant/search_install.sh ; sleep 2
sudo -u homeassistant -i sh -c 'cd /srv/homeassistant ; python3 -m venv . ; source bin/activate ; python3 -m pip install wheel > /dev/null; echo -en "\n" ; echo "# # Устновка Home Assistant..." ; pip3 install homeassistant > /dev/null ; nohup hass & > /dev/null'
echo -en "\n" ; echo -en "\n"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║           Первый запуск Home Assistant и его настройка           ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo "      └─── Это займет некоторое время. Ждем завершения... ───┘      "
echo -en "\n"
sudo rm -rf /srv/homeassistant/search_install.sh
sudo tee -a /srv/homeassistant/search_install.sh > /dev/null <<_EOF_
until grep "Setting up config" /srv/homeassistant/nohup.out > /dev/null
  do
  sleep 10
  done
echo "     - Настройка конфигурации... нужно еще времени..."
until grep "Setting up frontend" /srv/homeassistant/nohup.out > /dev/null
  do
  sleep 10
  done
echo "     - Настройка внешнего интерфейса... все еще ждем..."
until grep "Starting Home Assistant" /srv/homeassistant/nohup.out > /dev/null
  do
  sleep 10
  done
echo "     - Завершение процесса настраивания..."
_EOF_
sleep 1

echo "     - Инициализация программы Home Assistant... подождите..."
sudo -u homeassistant -i sh -c 'bash /srv/homeassistant/search_install.sh'

echo "     - Принудительное закрытие Home Assistant..."
sudo killall  -w -s 9 -u homeassistant

echo "     - Удаление хвостов от предыдущих действий..."
sudo rm -rf /srv/homeassistant/nohup.out
sudo rm -rf /srv/homeassistant/search_install.sh

#htop ; echo -en "\n" ; echo "# # Просмотр процессов..."

echo -en "\n" ; echo "# # Установка HASS конфигуратора"
sudo -u homeassistant -i sh -c 'cd /home/homeassistant/.homeassistant ; wget -q https://raw.githubusercontent.com/danielperna84/hass-configurator/master/configurator.py'
sudo chmod 755 /home/homeassistant/.homeassistant/configurator.py

echo -en "\n" ; echo "# # Создание службы для автозапуска Home Assistant"
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

echo -en "\n" ; echo "# # Создание службы для автозапуска HASS Configurator-а"
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

if [ -d ~/HA_BackUp/ ]; then 
echo -en "\n" ; echo "# # Восстанавление резервной копии конфигурационного файла Home Assistant..."
sudo mkdir -p /home/homeassistant/.homeassistant/HA_BackUp && sudo chmod 777 /home/homeassistant/.homeassistant/HA_BackUp
sudo mv -f ~/HA_BackUp/configuration.yaml.* /home/homeassistant/.homeassistant/HA_BackUp
sudo rm -rf ~/HA_BackUp
fi

echo -en "\n" ; echo "# # Добавление служб в список автозагрузки и их запуск..."
sudo systemctl -q daemon-reload
# sudo systemctl -q --system daemon-reload
sudo systemctl -q enable homeassistant@homeassistant.service
sudo systemctl -q start homeassistant@homeassistant.service
sudo systemctl -q enable hass-configurator.service
sudo systemctl -q start hass-configurator.service

echo -en "\n" ; echo "# # Добавление HASS конфигуратора в меню Home Assistant..."
sudo grep "#HASS-Configurator" /home/homeassistant/.homeassistant/configuration.yaml > /dev/null 2>&1 || sudo tee -a /home/homeassistant/.homeassistant/configuration.yaml > /dev/null 2>&1 <<_EOF_


# HASS-Configurator #
panel_iframe:
  configurator:
    title: Configurator
    icon: mdi:square-edit-outline
    url: http://$(hostname -I | tr -d ' '):3218
_EOF_

echo -en "\n"
echo -en "\n"
echo -en "\n"
echo -en "\n"
echo -en "\n"
echo "╔═════════════════════════════════════════════════════════════════════════════╗"
echo "║        Процесс установки Home Assistant и его зависимостей завершена        ║"
echo "╚═════════════════════════════════════════════════════════════════════════════╝"
echo -en "\n"
echo "    ┌────────── Полезная информация для работы с Home Assistant ──────────┐"
echo "    │                                                                     │"
echo "    │                  Доступ к Home Assistant по адресу                  │"
echo "    │                      http://$(hostname -I | tr -d ' '):8123/                      │"
echo "    │                                                                     │"
echo "    │                Доступ к HASS конфигуратору по адресу                │"
echo "    │                      http://$(hostname -I | tr -d ' '):3218/                      │"
echo "    │                                                                     │"
echo "    │                  Редактирование файла конфигурации                  │"
echo "    │                 sudo nano ~/.homebridge/config.json                 │"
echo "    │                                                                     │"
echo "    │                     Перезагрузка Home Assistant                     │"
echo "    │      sudo systemctl restart homeassistant@homeassistant.service     │"
echo "    │                                                                     │"
echo "    │                   Перезагрузка HASS конфигуратора                   │"
echo "    │           sudo systemctl restart hass-configurator.service          │"
echo "    │                                                                     │"
echo "    └─────────────────────────────────────────────────────────────────────┘"
echo -en "\n"
