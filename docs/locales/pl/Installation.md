# Instalacja

These instructions assume the software will run on a linux based host running a Klipper compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions host relates to the Linux device and mcu relates to the printboard. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## Pobierz plik konfiguracyjny Klippera

Most Klipper settings are determined by a "printer configuration file" printer.cfg, that will be stored on the host. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

## Interakcja z Klipperem

Klipper jest wyłącznie oprogramowaniem układowym dla drukarek 3D, dlatego użytkownik potrzebuje oddzielnego interface'u do zarządzania nim.

Obecnie najlepszym wyborem są interface'y użytkownika oparte o Moonraker web API (https://moonraker.readthedocs.io/) Jako kontroler można również wykorzystać OctoPrint (https://octoprint.org/).

Wybór interface'u należy do użytkownika, podstawowy Klipper pozostaje taki sam we wszystkich przypadkach. Zachęcamy użytkowników do zapoznania się z dostępnymi opcjami i podjęcia świadomej decyzji.

## Uzyskiwanie obrazu systemu operacyjnego dla SBC (komputerów jednopłytkowych).

Istnieje wiele sposobów na uzyskanie obrazu systemu operacyjnego dla Klippera do użytku z komputerami jednopłytkowymi (SBC), a większość z nich zależy od wybranego interfejsu użytkownika. Niektórzy producenci płyt SBC również udostępniają własne obrazy systemowe skoncentrowane na Klipperze.

Dwa główne interfejsy użytkownika oparte na Moonraker to [Fluidd](https://docs.fluidd.xyz/) oraz [Mainsail](https://docs.mainsail.xyz/). Ten drugi oferuje gotowy obraz instalacyjny ["MainsailOS"](http://docs.mainsailOS.xyz), który jest dostępny dla Raspberry Pi oraz niektórych wariantów OrangePi.

Fluidd można zainstalować za pomocą KIAUH (Klipper Install And Update Helper), co jest opisane poniżej. Jest to narzędzie firm trzecich służące do instalacji i aktualizacji wszystkich komponentów Klippera.

OctoPrint można zainstalować za pomocą popularnego obrazu OctoPi lub za pomocą KIAUH. Proces ten jest opisany w pliku <OctoPrint.md>

## Instalacja przez KIAUH

Zazwyczaj rozpoczyna się od podstawowego obrazu systemu operacyjnego dla SBC, na przykład RPiOS Lite, lub w przypadku urządzenia x86 z Linuxem – Ubuntu Server. Należy pamiętać, że warianty z interfejsem graficznym (Desktop) nie są zalecane ze względu na niektóre programy pomocnicze, które mogą zakłócać działanie niektórych funkcji Klippera, a nawet uniemożliwiać dostęp do niektórych płyt drukarek.

KIAUH można użyć do zainstalowania Klippera i powiązanych programów na różnych systemach opartych na Linuksie, które działają na wersji Debiana. Więcej informacji można znaleźć pod adresem https://github.com/dw-0/kiauh

## Tworzenie zawartości i programowanie mikrokontrolera

Aby skompilować kod mikrokontrolera, zacznij od uruchomienia następujących poleceń na swoim urządzeniu:

```
cd ~/klipper/
make menuconfig
```

The comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) should describe the settings that need to be set during "make menuconfig". Open the file in a web browser or text editor and look for these instructions near the top of the file. Once the appropriate "menuconfig" settings have been configured, press "Q" to exit, and then "Y" to save. Then run:

```
make
```

If the comments at the top of the [printer configuration file](#obtain-a-klipper-configuration-file) describe custom steps for "flashing" the final image to the printer control board then follow those steps and then proceed to [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Otherwise, the following steps are often used to "flash" the printer control board. First, it is necessary to determine the serial port connected to the micro-controller. Run the following:

```
ls /dev/serial/by-id/*
```

Powinien zaraportować coś podobnego do tego:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Wiele drukarek 3D ma swoją unikalną nazwę portu szeregowego. Ta unikalna nazwa będzie używana podczas wgrywania oprogramowania do mikrokontrolera. Może wystąpić sytuacja, w której w powyższym wyniku pojawi się wiele linii – w takim przypadku wybierz linię odpowiadającą mikrokontrolerowi. Jeśli lista jest długa i wybór jest niejednoznaczny, odłącz płytę drukarki i uruchom polecenie ponownie. Brakujący element to właśnie twoja płyta drukarki (więcej informacji znajdziesz w FAQ).

Dla popularnych mikrokontrolerów z chipami STM32 lub ich klonami, chipami LPC i innymi, zwykle konieczne jest wstępne wgranie oprogramowania Klipper za pomocą karty SD.

Podczas wgrywania oprogramowania tą metodą, ważne jest, aby upewnić się, że płyta drukarki nie jest podłączona do hosta za pomocą USB, ponieważ niektóre płyty mogą przesyłać zasilanie z powrotem do mikrokontrolera, co uniemożliwia poprawne przeprowadzenie procesu wgrywania.

Dla powszechnych mikrokontrolerów używających chipów Atmega, na przykład 2560, kod można wgrać za pomocą polecenia podobnego do:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Be sure to update the FLASH_DEVICE with the printer's unique serial port name.

For common micro-controllers using RP2040 chips, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## Konfiguracja Klippera

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun these steps again even if they were already done when flashing. Run:

```
ls /dev/serial/by-id/*
```

Powinien zaraportować coś podobnego do tego:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Then update the config file with the unique name. For example, update the `[mcu]` section to look something similar to:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper reports error messages via the command console and via pop up in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located in ~/printer_data/logs this is named klippy.log

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
