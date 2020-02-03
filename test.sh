#!/bin/bash

echo -en "\n"
echo "==============================================================="
echo "          Тестовая Установка Home Assistant"
echo "==============================================================="
echo -en "\n"


echo "# # Запускаем hass и ждем завершения"

sudo su homeassistant -c "cd /srv/homeassistant ;nohup hass &"
cd /srv/homeassistant
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
