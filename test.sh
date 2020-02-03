#!/bin/bash

echo -en "\n"
echo "==============================================================="
echo "          Тестовая Установка Home Assistant"
echo "==============================================================="
echo -en "\n"
echo "# # Создаем виртуальную среду для Home Assistant с выше создной учеткой."
sudo su homeassistant -c "cd /srv/homeassistant"


sudo su homeassistant -c "mkdir ./hello"
sudo -u homeassistant -H -s
