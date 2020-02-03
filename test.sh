#!/bin/bash

echo -en "\n"
echo "==============================================================="
echo "          Тестовая Установка Home Assistant"
echo "==============================================================="
echo -en "\n"
echo "# # Создаем виртуальную среду для Home Assistant с выше создной учеткой."
sudo su homeassistant -c "cd /srv/homeassistant && python3 -m venv ."
sudo su homeassistant -c "cd /srv/homeassistant && source bin/activate"
sudo su homeassistant -c "cd /srv/homeassistant && python3 -m pip install wheel"
sudo su homeassistant -c "cd /srv/homeassistant && pip3 install homeassistant"
sudo -u homeassistant -H -s
