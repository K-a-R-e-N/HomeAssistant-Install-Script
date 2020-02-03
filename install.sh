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
killall  -w -s 9 -u homeassistant
echo "# # Получилось!"

echo "# # тест 1!"
ls
echo "# # тест 2!"
mkdir ./tests
cd ./tests
echo "# # тест 3!"
htop
