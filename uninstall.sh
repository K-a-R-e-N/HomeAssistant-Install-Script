#!/bin/bash

echo -en "\n"
echo "╔═════════════════════════════════════════════════════════════════════════════╗"
echo "                     Удаление Home Assistant и его хвостов"
echo "╚═════════════════════════════════════════════════════════════════════════════╝"
echo -en "\n"

echo -en "\n" ; echo "  # # Завершение процесса Home Assistant..."
sudo killall  -w -s 9 -u homeassistant > /dev/null 2>&1

echo -en "\n" ; echo "  # # Деинсталляция Home Assistant..."
sudo pip3 uninstall homeassistant > /dev/null 2>&1

echo -en "\n" ; echo "  # # Удаление пользователя homeassistant..."
sudo userdel -rf homeassistant > /dev/null 2>&1

echo -en "\n" ; echo "  # #  Удаление служб из списока автозагрузки..."
echo "     - по пути /etc/systemd/system/homeassistant*"
echo "     - по пути /etc/systemd/system/multi-user.target.wants/homeassistant*"
sudo rm -rf /etc/systemd/system/homeassistant*
sudo rm -rf /etc/systemd/system/multi-user.target.wants/homeassistant*
sudo systemctl --system daemon-reload > /dev/null

echo -en "\n" ; echo "  # # Удаление хвостов, для возможности последующей нормальной установки:"
echo "     - по пути /srv/homeassistant"
echo "     - по пути /run/sudo/ts/homeassistant"
sudo rm -rf /srv/homeassistant
sudo rm -rf  /run/sudo/ts/homeassistant

echo -en "\n" ; echo "  # # Удаление хвостов от плагинов:"

echo -en "\n"
echo "╔═════════════════════════════════════════════════════════════════════════════╗"
echo "             Процесс удаления Home Assistant и его хвостов завершен"
echo "╚═════════════════════════════════════════════════════════════════════════════╝"
echo -en "\n"
