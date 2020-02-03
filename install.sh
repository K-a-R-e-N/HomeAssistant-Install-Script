#!/bin/bash

echo -en "\n"
echo "==============================================================="
echo "          Установка Home Assistant и его зависимостей"
echo "==============================================================="

echo -en "\n"
echo "# # Установим зависимости"
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev -y

echo -en "\n"
echo "# # Добавим аккаунт для Home Assistant под названием homeassistant"
sudo useradd -rm homeassistant -G dialout,gpio,i2c

echo -en "\n"
echo "# # Далее создадим каталог для установки Home Assistant и сделаем владельцем аккаунт homeassistant"
cd /srv
sudo mkdir homeassistant
sudo chown homeassistant:homeassistant homeassistant

echo -en "\n"
echo "# # Создаем виртуальную среду для Home Assistant с выше создной учеткой."
sudo -u homeassistant -H -s
echo "Отладка: делаем cd /srv/homeassistant"
cd /srv/homeassistant
echo "Отладка: делаем python3 -m venv ."
python3 -m venv .
echo "Отладка: делаем source bin/activate"
source bin/activate
echo "Отладка: делаем python3 -m pip install wheel"
python3 -m pip install wheel

echo -en "\n"
echo "# # Ставим сам Home Assistan"
pip3 install homeassistant

echo -en "\n"
echo "# # Запускаем hass и ждем завершения"
nohup hass &
echo "         ждем завершения..."
until grep "Starting Home Assistant" ./nohup.out
  do
  echo "Прошло еще 10 сек"
  sleep 10
  done
echo "# # Убываем процесс hass"
echo -en "\n"



echo "# # Получилось!"

#Установка HASS конфигуратора
cd /home/homeassistant/.homeassistant
wget https://raw.githubusercontent.com/danielperna84/hass-configurator/master/configurator.py
#Выходим из под шелла пользователя homeassistant командой 
exit
cd /home/homeassistant/.homeassistant
sudo chmod 755 configurator.py
cd
#Cоздадим сервис, который будет запускать HA при перезагрузке системы
sudo rm -rf /etc/systemd/system/homeassistant@homeassistant.service
sudo tee -a /etc/systemd/system/homeassistant@homeassistant.service <<_EOF_
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
#Cоздадим сервис, который будет запускать HASS Configurator при перезагрузке системы
sudo rm -rf /etc/systemd/system/hass-configurator.service
sudo tee -a /etc/systemd/system/hass-configurator.service <<_EOF_
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
#Активируем наш сервисы и запустим их
sudo systemctl --system daemon-reload
sudo systemctl enable homeassistant@homeassistant.service
sudo systemctl start homeassistant@homeassistant.service
sudo systemctl enable hass-configurator.service
sudo systemctl start hass-configurator.service
#Добавим быстрый доступ на левую панель HA ! Второй раз не вводить!
sudo tee -a /home/homeassistant/.homeassistant/configuration.yaml <<_EOF_

#HASS-Configurator
panel_iframe:
  configurator:
    title: Configurator
    icon: mdi:square-edit-outline
    url: http://192.168.1.33:3218
_EOF_
#Готов
#sudo nano /home/homeassistant/.homeassistant/configuration.yaml
