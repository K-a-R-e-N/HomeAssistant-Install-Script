## Скрипт установки Home Assistant и HASS конфигуратора на Raspberry Pi
_Homeb Assistant Installation Script_

Cкрипт, который будет ставить самые свежие версии Home Assistant и HASS конфигуратора. Так же в скрипте учтены важные моменты и проделаны специальные настройки, чтобы у вас не возникало ни каких проблем во время установки.

![logo](https://sprut.ai/static/media/cache/00/05/83/40/2369/50963/1600x_image.png?1580879891)   

### Реализованные функции
* Учтены и проделаны важные модификации, после которых переустановка Homeb Assistant, не будут вызывать каких либо  проблем
* Настроенный файл конфигурации уже импортирован
* Применены специальные права для правильного взаимодействия с платой Raspberry Pi
* Реализовано два отдельных сервиса для автозапуска HomebAssistant и HASS конфигуратора
* В конце установки реализовал вывод полезной информации
* Реализована возможность полной деинсталляции Homeb Assistant и его зависимостей
* Для актуального состояния скрипта, буду постоянно обновлять и дополнять его

### УСТАНОВКА НА RASPBERRY PI
Прежде чем начать, убедитесь, что на вашей Raspberry Pi установлена последняя версия Raspbian OS и обновлены все пакеты до актуального состояния. Для этого введите следующую команду:

```
sudo rm -Rf /var/lib/apt/lists
sudo apt-get update && sudo apt-get upgrade -y && sudo apt install git -y
#Готово
```
#### _Если в  вашей системе ранее был установлен Home Assistant и HASS конфигуратор, то прежде чем приступить к установке, надо предварительно очистить систему. Чтобы проделать эту операцию, воспользуйтесь специальным параметром скрипта, который описан ниже._

Для чистой установки на новую систему надо скопировать нижние строки и ввести в консоль терминала:

```
git clone https://github.com/K-a-R-e-N/HomeAssistant-Install-Script
cd HomeAssistant-Install-Script
bash install.sh && bash stripping.sh && cd ..
#Готово
```
Третья строка: `bash install.sh && bash stripping.sh && cd ..` настраиваемая...  
Можно как добавлять так и удалять параметры...  
Если дописать на начало `bash uninstall.sh &&` - то перед установкой, система будет предварительно очищена от ранее установленных версий. Выглядеть эта команда будет так:

```
git clone https://github.com/K-a-R-e-N/HomeAssistant-Install-Script
cd HomeAssistant-Install-Script
bash uninstall.sh && bash install.sh && bash stripping.sh && cd ..
#Готово
```
итак...

`bash uninstall.sh &&` - Полная деинсталляция Home Assistant и его зависимостей  
`bash install.sh &&` - Чистая установка Home Assistant и его зависимостей  
`bash stripping.sh &&` - Удаляет временную папку с содержимым, где хранился загружаемый скрипт  

### ПОСЛЕДУЮЩЕЕ ОБНОВЛЕНИЕ
Для обновления до последней версии Home Assistant выполните следующие простые шаги:
```
sudo -u homeassistant -H -s
source /srv/homeassistant/bin/activate
pip3 install --upgrade homeassistant
sudo systemctl restart homeassistant@homeassistant.service 
#Готово
```
#### _Помните, что запуск некоторых обновлений может занять больше времени, чем другие._
#### _Если Home Assistant не запускается, не забудьте проверить критические изменения в [заметках о выпуске](https://github.com/home-assistant/home-assistant/releases)_



На этом у меня все!
