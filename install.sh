#!/bin/bash

echo -en "\n"
echo "==============================================================="
echo "          Установка Home Assistant и его зависимостей"
echo "==============================================================="

echo -en "\n"
echo "# # Установим зависимости"
sudo apt-get install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev -y </dev/null

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
cd /srv/homeassistant
python3 -m venv .
source bin/activate
python3 -m pip install wheel

echo -en "\n"
echo "# # Ставим сам Home Assistan"
pip3 install homeassistant

echo -en "\n"
echo "# # Обязательно запускаем HA"
Здесь запускаем hass

echo "==============================================================="
echo "          НУЖНА ПОМОЩЬ !!!! ПОМОГИТЕ"
echo "===============================================================" && sudo tee -a help <<_EOF_

После запуска команды hass , надо подождать минут 10, там че то грузиться для полноценной работы homeassistant. Если это не делать, то придётся все удалить и заново установить с нуля!

ИТАК , через минут 10 когда все уже, вроде, готово, надо нажать на комбинацию клавиш ctrl+c и подождать пока закончится остановка, после чего только продолжить выполнение следующих команд....

Надо решить проблему этой загвоздки....
может как то в фоновом режиме запустить??
или вести лог файл, с постоянным монитором, пока там не появиться определённый текс, после чего авто завершение применить?

Очень надеюсь на вашу помощь...
_EOF_
