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
sudo su homeassistant -c "cd /srv/homeassistant ; python3 -m venv . ; source bin/activate ; python3 -m pip install wheel ; echo '# # Устновка Home Assistant...' ; pip3 install homeassistant ; nohup hass &"

echo "# # Первый запуск Home Assistant и его настройка..."
sudo rm -rf /srv/homeassistant/seaech_install.sh
sudo tee -a /srv/homeassistant/seaech_install.sh <<_EOF_
echo "         это займет некоторое время... ждем завершения..."
until grep "Setting up homeassistant" /srv/homeassistant/nohup.out
  do
  sleep 10
  done
echo "         Настройка homeassistant..."
until grep "Setting up lovelace" /srv/homeassistant/nohup.out
  do
  sleep 10
  done
echo "         настройки lovelace подняты..."
until grep "Setting up frontend" /srv/homeassistant/nohup.out
  do
  sleep 10
  done
echo "         Настройка внешнего интерфейса..."
until grep "Starting Home Assistant" /srv/homeassistant/nohup.out
  do
  sleep 10
  done
echo "         Первый запуск Home Assistant и его настройка завершена..."
_EOF_
sudo su homeassistant -c "cd /srv/homeassistant ; bash seaech_install.sh"
echo -en "\n"
echo "# # Убываем процесс hass"
echo "# # sudo killall  -w -s 9 -u homeassistant"
echo -en "\n"
echo "# # Очищаем хвосты..."
sudo rm -rf /srv/homeassistant/nohup.out
sudo rm -rf /srv/homeassistant/seaech_install.sh


echo -en "\n"
echo -en "\n"
echo -en "\n"
echo "# # тест 1!"
ls
echo "# # тест 2!"
mkdir ./tests
cd ./tests
echo "# # тест 3!"
htop
