# Установка

These instructions assume the software will run on a linux based host running a Klipper compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions host relates to the Linux device and mcu relates to the printboard. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Получение файла конфигурации Klipper

Most Klipper settings are determined by a "printer configuration file" printer.cfg, that will be stored on the host. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

Если в каталоге Klipper config нет соответствующего файла конфигурации принтера, попробуйте поискать на сайте производителя принтера, чтобы узнать, есть ли у него соответствующий файл конфигурации Klipper.

Если конфигурационный файл для принтера не найден, но известен тип платы управления принтером, то ищите соответствующий [config-файл](../config/), начинающийся с префикса "generic-". Приведенные примеры файлов платы управления принтером должны позволить успешно завершить начальную установку, но для получения полной функциональности принтера потребуется некоторая доработка.

Можно также задать новую конфигурацию принтера с нуля. Однако это требует значительных технических знаний о принтере и его электронике. Большинству пользователей рекомендуется начинать работу с соответствующего файла конфигурации. При создании нового файла конфигурации принтера следует начать с ближайшего примера [config file](../config/), а для получения дополнительной информации использовать справочник Klipper [config reference](Config_Reference.md).

## Interacting with Klipper

Klipper is a 3d printer firmware, so it needs some way for the user to interact with it.

Currently the best choices are front ends that retrieve information through the [Moonraker web API](https://moonraker.readthedocs.io/) and there is also the option to use [Octoprint](https://octoprint.org/) to control Klipper.

The choice is up to the user on what to use, but the underlying Klipper is the same in all cases. We encourage users to research the options available and make an informed decision.

## Obtaining an OS image for SBC's

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manafactures of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](http://docs.mainsailOS.xyz), this has the option for Raspberry Pi and some OrangePi varianta.

Fluidd can be installed via KIAUH(Klipper Install And Update Helper), which is explained below and is a 3rd party installer for all things Klipper.

OctoPrint can be installed via the popular OctoPi image or via KIAUH, this process is explained in <OctoPrint.md>

## Installing via KIAUH

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of a x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions working and even mask access to some print boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## Компиляция и прошивка микроконтроллера

To compile the micro-controller code, start by running these commands on your host device:

```
cd ~/klipper/
make menuconfig
```

Комментарии в верхней части файла [printer configuration file](#obtain-a-klipper-configuration-file) должны описывать настройки, которые необходимо задать при выполнении команды "make menuconfig". Откройте файл в браузере или текстовом редакторе и найдите эти инструкции в верхней части файла. После того как соответствующие настройки "menuconfig" будут заданы, нажмите "Q" для выхода, а затем "Y" для сохранения. Затем запустите программу:

```
make
```

Если в комментариях в верхней части файла [printer configuration file](#obtain-a-klipper-configuration-file) описаны пользовательские шаги по "прошивке" конечного изображения на плату управления принтером, то выполните эти шаги, а затем перейдите к [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

В противном случае для "прошивки" платы управления принтером часто используются следующие действия. Во-первых, необходимо определить последовательный порт, подключенный к микроконтроллеру. Для этого выполните следующее:

```
ls /dev/serial/by-id/*
```

Должно отобразиться что-то вроде:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

It's common for each printer to have its own unique serial port name. This unique name will be used when flashing the micro-controller. It's possible there may be multiple lines in the above output - if so, choose the line corresponding to the micro-controller. If many items are listed and the choice is ambiguous, unplug the board and run the command again, the missing item will be your print board(see the [FAQ](FAQ.md#wheres-my-serial-port) for more information).

For common micro-controllers with STM32 or clone chips, LPC chips and others it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occuring.

For common micro-controllers using Atmega chips, for example the 2560, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Не забудьте заменить значение FLASH_DEVICE на имя порта вашего принтера.

For common micro-controllers using RP2040 chips, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## Настройка клиперов

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Обычно каждый принтер имеет свое собственное уникальное имя для микроконтроллера. После прошивки Klipper это имя может измениться, поэтому повторите эти шаги еще раз, даже если они уже были выполнены при прошивке. Выполнить:

```
ls /dev/serial/by-id/*
```

Должно отобразиться что-то вроде:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Затем обновите конфигурационный файл с уникальным именем. Например, обновите секцию `[mcu]`, чтобы она выглядела примерно так:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

При настройке файла конфигурации принтера нередко Klipper сообщает об ошибке конфигурации. При возникновении ошибки внесите необходимые исправления в файл конфигурации принтера и выполняйте команду "restart" до тех пор, пока "status" не сообщит о готовности принтера.

Klipper reports error messages via the command console and via pop up in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located in ~/printer_data/logs this is named klippy.log

После того как Klipper сообщит, что принтер готов, перейдите к документу [Проверка конфигурации](Config_checks.md) для выполнения некоторых базовых проверок определений в файле конфигурации. Другую информацию см. в основной части [справочной документации](Overview.md).
