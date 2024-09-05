# Telepítés

These instructions assume the software will run on a linux based host running a Klipper compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions host relates to the Linux device and mcu relates to the printboard. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Klipper konfigurációs fájl beszerzése

Most Klipper settings are determined by a "printer configuration file" printer.cfg, that will be stored on the host. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

Ha nincs megfelelő nyomtató konfigurációs fájl a Klipper config könyvtárban, akkor keresd meg a nyomtató gyártójának weboldalát, hogy van-e megfelelő Klipper konfigurációs fájljuk.

Ha nem találod a nyomtatóhoz tartozó konfigurációs fájlt, de a nyomtató vezérlőpanelének típusa ismert, akkor keress egy megfelelő [config fájlt](../config/), amely "generic-" előtaggal kezdődik. Ezekkel a nyomtató vezérlőpanel példafájlokkal sikeresen elvégezhető a kezdeti telepítés, de a nyomtató teljes funkcionalitásának eléréséhez némi testreszabásra lesz szükség.

Lehetőség van új nyomtatókonfiguráció nulláról történő meghatározására is. Ehhez azonban jelentős műszaki ismeretekre van szükség a nyomtatóval és annak elektronikájával kapcsolatban. A legtöbb felhasználónak ajánlott, hogy egy megfelelő konfigurációs fájllal kezd. Ha új, egyéni nyomtató konfigurációs fájlt hozol létre, akkor a legközelebbi példával [config fájl](../config/) kezd, és további információkért használd a Klipper [konfigurációs hivatkozás](Config_Reference.md) című dokumentumot.

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

## A mikrokontroller felépítése és égetése

To compile the micro-controller code, start by running these commands on your host device:

```
cd ~/klipper/
make menuconfig
```

A [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) tetején található megjegyzéseknek le kell írniuk a beállításokat, amelyeket a "make menuconfig" során kell beállítani. Nyisd meg a fájlt egy webböngészőben vagy szövegszerkesztőben, és keresd meg ezeket az utasításokat a fájl teteje közelében. Miután a megfelelő "menuconfig" beállításokat elvégezted, nyomd meg a "Q" gombot a kilépéshez, majd az "Y" gombot a mentéshez. Ezután futtasd:

```
make
```

Ha a [nyomtató konfigurációs fájl](#obtain-a-klipper-configuration-file) tetején található megjegyzések egyéni lépéseket írnak le a "flash" végső képnek a nyomtató vezérlőpanelére történő égetéséhez, akkor kövesd ezeket a lépéseket, majd folytasd az [OctoPrint konfigurálása](#configuring-octoprint-to-use-klipper) lépésekkel.

Ellenkező esetben a következő lépéseket gyakran használják a nyomtató vezérlőlapjának "flash" égetésére. Először meg kell határozni a mikrokontrollerhez csatlakoztatott soros portot. Futtasd a következőket:

```
ls /dev/serial/by-id/*
```

Az alábbiakhoz hasonlót kell kapnod:

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

Feltétlenül frissítd a FLASH_DEVICE eszközt a nyomtató egyedi soros portjának nevével.

For common micro-controllers using RP2040 chips, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## A Klipper beállítása

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Gyakori, hogy minden nyomtatónak saját egyedi neve van a mikrokontroller számára. A név a Klipper égetése után megváltozhat, ezért futtasd újra ezeket a lépéseket, még akkor is, ha már az égetéskor elvégezted őket. Futtatás:

```
ls /dev/serial/by-id/*
```

Az alábbiakhoz hasonlót kell kapnod:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Ezután frissítsd a konfigurációs fájlt az egyedi névvel. Például frissítsd az `[mcu]` részt, hogy valami hasonlót kapj:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

A nyomtató konfigurációs fájljának testreszabásakor nem ritka, hogy a Klipper konfigurációs hibát jelez. Ha hiba lép fel, végezd el a szükséges javításokat a nyomtató konfigurációs fájljában, és add ki az "újraindítás" parancsot, amíg az "állapot" nem jelzi, hogy a nyomtató készen áll.

Klipper reports error messages via the command console and via pop up in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located in ~/printer_data/logs this is named klippy.log

Miután a Klipper jelenti, hogy a nyomtató készen áll, folytasd a [konfigurációs ellenőrzés](Config_checks.md) című dokumentummal, hogy elvégezz néhány alapvető ellenőrzést a config fájlban lévő definíciókon. További információkért lásd a fő [dokumentációs hivatkozás](Overview.md) című rész.
