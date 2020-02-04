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
sudo rm -rf /srv/homeassistant/nohup.out
sudo su homeassistant -c "cd /srv/homeassistant ; python3 -m venv . ; source bin/activate ; python3 -m pip install wheel ; pip3 install homeassistant ; nohup hass &"
sudo rm -rf /srv/homeassistant/seaech_install.sh
sudo tee -a /srv/homeassistant/seaech_install.sh <<_EOF_
echo "         ждем завершения..."
until grep "Starting Home Assistant" /srv/homeassistant/nohup.out
  do
  echo "Прошло еще 10 сек"
  sleep 10
  done
echo "# # Получилось!"
_EOF_
sudo su homeassistant -c "cd /srv/homeassistant ; bash seaech_install.sh"
echo "следующий пункт готов"

