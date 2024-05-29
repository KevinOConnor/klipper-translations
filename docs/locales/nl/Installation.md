# Installatie

Deze instructies gaan er vanuit dat de software op een Raspberry Pi draait samen met octoprint. Het word aangeraden een Raspberry Pi 2,3 of 4 te gebruiken als host machine (zie de [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) voor andere machines).

## Verkrijg een klipper configuratie bestand

Most Klipper settings are determined by a "printer configuration file" that will be stored on the Raspberry Pi. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

If there isn't an appropriate printer configuration file in the Klipper config directory then try searching the printer manufacturer's website to see if they have an appropriate Klipper configuration file.

If no configuration file for the printer can be found, but the type of printer control board is known, then look for an appropriate [config file](../config/) starting with a "generic-" prefix. These example printer board files should allow one to successfully complete the initial installation, but will require some customization to obtain full printer functionality.

It is also possible to define a new printer configuration from scratch. However, this requires significant technical knowledge about the printer and its electronics. It is recommended that most users start with an appropriate configuration file. If creating a new custom printer configuration file, then start with the closest example [config file](../config/) and use the Klipper [config reference](Config_Reference.md) for further information.

## Besturingssysteem afbeelding voorbereiden

Start by installing [OctoPi](https://github.com/guysoft/OctoPi) on the Raspberry Pi computer. Use OctoPi v0.17.0 or later - see the [OctoPi releases](https://github.com/guysoft/OctoPi/releases) for release information. One should verify that OctoPi boots and that the OctoPrint web server works. After connecting to the OctoPrint web page, follow the prompt to upgrade OctoPrint to v1.4.2 or later.

Na het installeren van octopi en het upgraden van octoprint is het nodig om te ssh'en in de doel machine en een paar commandos te draaien. Als je een Linux of macOS computer gebruikt zou ssh al geïnstalleerd moeten zijn op je computer. Voor andere besturingssystemen zijn andere gratis ssh clients beschikbaar (bijvoorbeeld [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Gebruik de ssh tool om met de Raspberry Pi te verbinden (ssh pi@octopi -- password is "raspberry") en voor de volgende commando's uit:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Het bovenstaande zal klipper downloaden, een paar afhankelijkheden instaleren, klipper instellen zodat het draait bij het opstarten, en de klipper software opstarten. Dit vereist een internet verbinding en kan een paar minuten duren.

## Bouwen en flashen van de microcontroller software

Om de microcontroller code te compileren start met het draaien van de volgende commando's op de Raspberry Pi:

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

Het zou iets vergelijkbaars als het volgende moeten teruggeven:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Het komt vaak voor dat elke printer een eigen unieke seriële poort naam heeft. Deze unieke naam word gebruikt bij het flashen van de microcontroller. Het is mogelijk dat er meerdere regels zijn in de resultaten van hierboven. Als dat zo is kies de correcte regel met de microcontroller erop(zie [FAQ](FAQ.md#wheres-my-serial-port) voor meer informatie).

Voor veelvoorkomende microcontrollers kan de code geflashed worden met iets vergelijkbaar met:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Controleer dat je het FLASH_DEVICE update met de printer's unieke seriële poort naam.

Als je het voor de eerste keer flashed wees zeker dat octoprint niet direct verbonden is met de printer(in de octoprint webpagina onder het "connection" deel, klik "disconnect").

## Configureer octoprint om klipper te gebruiken

The OctoPrint web server needs to be configured to communicate with the Klipper host software. Using a web browser, login to the OctoPrint web page and then configure the following items:

Navigate to the Settings tab (the wrench icon at the top of the page). Under "Serial Connection" in "Additional serial ports" add "/tmp/printer". Then click "Save".

Ga opnieuw naar de instelling en onder "Serial connection" Verander de "Serial port" instelling naar "/tmp/printer".

In het instelling tablat, Navigeer naar het "behavior" onderdeel en klik de "Cancel any ongoing prints but stay connected to the printer" optie. Klik "Save".

From the main page, under the "Connection" section (at the top left of the page) make sure the "Serial Port" is set to "/tmp/printer" and click "Connect". (If "/tmp/printer" is not an available selection then try reloading the page.)

Once connected, navigate to the "Terminal" tab and type "status" (without the quotes) into the command entry box and click "Send". The terminal window will likely report there is an error opening the config file - that means OctoPrint is successfully communicating with Klipper. Proceed to the next section.

## Configureer Klipper

De volgende stap is om het [printer configuratie bestand](#obtain-a-klipper-configuration-file) te kopiëren naar de Raspberry Pi.

Arguably the easiest way to set the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun these steps again even if they were already done when flashing. Run:

```
ls /dev/serial/by-id/*
```

Het zou iets vergelijkbaars als het volgende moeten teruggeven:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Dan werk je het configuratie bestand bij met een unieke naam. Bijvoorbeeld, weinig het `[mcu]` deel zodat het er vergelijkbaar uitziet met:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

When customizing the printer config file, it is not uncommon for Klipper to report a configuration error. If an error occurs, make any necessary corrections to the printer config file and issue "restart" until "status" reports the printer is ready.

Klipper reports error messages via the OctoPrint terminal tab. The "status" command can be used to re-report error messages. The default Klipper startup script also places a log in **/tmp/klippy.log** which provides more detailed information.

After Klipper reports that the printer is ready, proceed to the [config check document](Config_checks.md) to perform some basic checks on the definitions in the config file. See the main [documentation reference](Overview.md) for other information.
