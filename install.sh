#!/bin/bash

#Установим зависимости
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev -y </dev/null
#Добавим аккаунт для Home Assistant под названием homeassistant
sudo useradd -rm homeassistant -G dialout,gpio,i2c
#Далее создадим каталог для установки Home Assistant и сделаем владельцем аккаунт homeassistant
cd /srv
sudo mkdir homeassistant
sudo chown homeassistant:homeassistant homeassistant
#Создаем виртуальную среду для Home Assistant с выше создной учеткой.
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
python3 -m pip install wheel
#Ставим сам Home Assistan
pip3 install homeassistant
#Обязательно запускаем HA
hass

#Надо ждать минут 10 после запуска hass. Там че тогрузиться, для полноценной работы homeassistant. если это не делать, то прийдеться все удалить и заново установить с нуля!
ИТАК через минут 10 надо нажать на комбинацию клавиш ctrl+c, подождать пока закончится остановка процеса и после чего только продолжить выполнение слудеющих команд....
Надо решить проблемму этой загквоздки!
