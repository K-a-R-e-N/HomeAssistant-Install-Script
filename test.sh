  
#!/bin/bash
#set -x

echo "     - Принудительное закрытие Home Assistant..."
sudo killall  -w -s 9 -u homeassistant

echo "     - Удаление хвостов от предыдущих действий..."
sudo rm -rf /srv/homeassistant/nohup.out
sudo rm -rf /srv/homeassistant/hass-progress.log
sudo rm -rf /srv/homeassistant/search_install.sh
clear







echo -en "\n" ; echo -en "\n"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║           Первый запуск Home Assistant и его настройка           ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
sudo -u homeassistant -H -s bash -c 'cd /srv/homeassistant && python3 -m venv . && source bin/activate && nohup hass &>/srv/homeassistant/hass-progress.log &'
echo "      └─── Это займет некоторое время. Ждем завершения... ───┘"
echo -en "\n"

sudo rm -rf /srv/homeassistant/search_install.sh
sudo tee -a /srv/homeassistant/search_install.sh > /dev/null <<_EOF_
until grep "Setting up config" /srv/homeassistant/hass-progress.log > /dev/null
  do
  sleep 10
  done
echo "     - Настройка конфигурации... нужно больше времени..."
until grep "Setting up frontend" /srv/homeassistant/hass-progress.log > /dev/null
  do
  sleep 10
  done
echo "     - Настройка внешнего интерфейса... все еще ждем..."
until grep "Starting Home Assistant" /srv/homeassistant/hass-progress.log > /dev/null
  do
  sleep 10
  done
echo "     - Завершение процесса настраивания..."
_EOF_
sleep 1

echo "     - Инициализация программы Home Assistant... подождите..."
sudo -u homeassistant -H -s bash -c 'cd /srv/homeassistant && python3 -m venv . && source bin/activate && bash /srv/homeassistant/search_install.sh'

echo "     - Принудительное закрытие Home Assistant..."
sudo killall  -w -s 9 -u homeassistant

echo "     - Удаление хвостов от предыдущих действий..."
sudo rm -rf /srv/homeassistant/nohup.out ; sudo rm -rf /srv/homeassistant/hass-progress.log
sudo rm -rf /srv/homeassistant/search_install.sh

#htop ; echo -en "\n" ; echo "  # # Просмотр процессов..."

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

echo -en "\n" ; echo "  # # Создание службы для автозапуска HASS Configurator-а"
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
echo -en "\n" ; echo "  # # Восстанавление резервной копии конфигурационного файла Home Assistant..."
sudo mkdir -p /home/homeassistant/.homeassistant/HA_BackUp && sudo chmod 777 /home/homeassistant/.homeassistant/HA_BackUp
sudo mv -f ~/HA_BackUp/configuration.yaml.* /home/homeassistant/.homeassistant/HA_BackUp
sudo rm -rf ~/HA_BackUp
fi

echo -en "\n" ; echo "  # # Добавление служб в список автозагрузки и их запуск..."
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
