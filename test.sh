#!/bin/bash

echo -en "\n"
echo "==============================================================="
echo "          Тестовая Установка Home Assistant"
echo "==============================================================="
echo -en "\n"
echo "# # Создаем виртуальную среду для Home Assistant с выше создной учеткой."
sudo su homeassistant -c "cd /srv/homeassistant ; python3 -m venv . ; source bin/activate ; python3 -m pip install wheel ; pip3 install homeassistant"
echo "готово"
sudo -u homeassistant -H -s
