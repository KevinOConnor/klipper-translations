# OctoPrint для Klipper

У Klipper есть несколько вариантов фронт-эндов, Octoprint был первым и оригинальным фронт-эндом для Klipper. В этом документе будет дан краткий обзор установки с помощью этой опции.

## Установка с помощью OctoPi

Начните с установки [OctoPi](https://github.com/guysoft/OctoPi) на компьютер Raspberry Pi. Используйте OctoPi версии 0.17.0 или более поздней - информацию о выпуске см. в разделе [OctoPi releases](https://github.com/guysoft/OctoPi/releases).

Необходимо убедиться, что OctoPi загружается, а веб-сервер OctoPrint работает. После подключения к веб-странице OctoPrint следуйте подсказкам, чтобы обновить OctoPrint, если это необходимо.

После установки OctoPi и обновления OctoPrint необходимо зайти в систему на целевой машине, чтобы выполнить несколько системных команд.

Начните с выполнения этих команд на хост-устройстве:

**Если у вас не установлен git, пожалуйста, сделайте это с помощью:**

```
sudo apt install git
```

затем приступайте:

```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Вышеописанная операция загрузит Klipper, установит необходимые системные зависимости, настроит Klipper на запуск при старте системы и запустит хост-программу Klipper. Для этого потребуется подключение к Интернету, а выполнение может занять несколько минут.

## Установка с помощью KIAUH

KIAUH может быть использован для установки OctoPrint на различные системы на базе Linux, которые работают под управлением Debian. Более подробную информацию можно найти на сайте https://github.com/dw-0/kiauh

## Настройка OctoPrint для использования Klipper

Веб-сервер OctoPrint должен быть настроен для связи с хост-программой Klipper. Используя веб-браузер, войдите на веб-страницу OctoPrint, а затем настройте следующие элементы:

Перейдите на вкладку "Настройки" (значок гаечного ключа в верхней части страницы). В разделе "Последовательное соединение" в пункте "Дополнительные последовательные порты" добавьте:

```
~/printer_data/comms/klippy.serial
```

Затем нажмите "Сохранить".

*В некоторых старых системах этот адрес может быть `/tmp/printer`*

Снова откройте вкладку "Настройки" и в разделе "Последовательное соединение" измените параметр "Последовательный порт" на тот, который был добавлен выше.

На вкладке "Настройки" перейдите на подвкладку "Поведение" и выберите опцию "Отменить все текущие отпечатки, но оставаться подключенным к принтеру". Нажмите "Сохранить".

На главной странице в разделе "Подключение" (в левом верхнем углу страницы) убедитесь, что "Последовательный порт" установлен на новый дополнительный порт, и нажмите "Подключить". (Если его нет в списке доступных вариантов, попробуйте перезагрузить страницу)

После подключения перейдите на вкладку "Терминал", введите "статус" (без кавычек) в поле ввода команды и нажмите "Отправить". В окне терминала, скорее всего, появится сообщение об ошибке при открытии файла конфигурации - это означает, что OctoPrint успешно взаимодействует с Klipper.

Пожалуйста, перейдите к разделу <Installation.md> и *Сборка и прошивка микроконтроллера*
