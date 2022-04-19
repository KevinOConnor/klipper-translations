��    ,      |  ;   �      �  4   �  �   �  �  �  �  �  f   m  �  �  �   s
  N     *   Z     �  $   �     �  n   �  P   G  �   �  �   �  �   L     �  �   �  4   �  (  �  H  �  �   *  �   �  Q   �  �   ,  3  �       d     �    �     �   �  �   �  &  �  Z   �  �     B   �       K   7  S   �     �     �  �   �  �  w  4      �   6   J  /!    z#  �   �%  �  &  �   (  ^   �(  -   >)     l)  4   �)  #   �)  �   �)  O   j*    �*  	  �+  �   �,     �-  �   �-  -   b.  ?  �.  Q  �/  �   "1    �1  S   �2  �   J3  l  4     �5  �   �5    26  )  ?8  �   i9    7:  S  =;  ^   �<  �   �<  B   �=     >  K   ">  S   n>     �>     �>  �   �>     %                $                  	                        )      (       #   +                       !                 '            ,                              *                  
          &   "    /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
 After Klipper reports that the printer is ready go on to the [config check document](Config_checks.md) to perform some basic checks on the pin definitions in the config file. After creating and editing the file it will be necessary to issue a "restart" command in the OctoPrint web terminal to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured. It is not unusual to have configuration errors during the initial setup - update the printer config file and issue "restart" until "status" reports the printer is ready. After installing OctoPi and upgrading OctoPrint, it will be necessary to ssh into the target machine to run a handful of system commands. If using a Linux or MacOS desktop, then the "ssh" software should already be installed on the desktop. There are free ssh clients available for other desktops (eg, [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Use the ssh utility to connect to the Raspberry Pi (ssh pi@octopi -- password is "raspberry") and run the following commands: Alternatively, one can also copy and edit the file directly on the Raspberry Pi via ssh - for example: Arguably the easiest way to update the Klipper configuration file is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Use one of the example config files as a starting point and save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg). Be sure to see the [FAQ](FAQ.md) for answers to some common questions. See the [contact page](Contact.md) to report a bug or to contact the developers. Be sure to update the FLASH_DEVICE with the printer's unique serial port name. Building and flashing the micro-controller Configuring Klipper Configuring OctoPrint to use Klipper Contacting the developers Enter the Settings tab again and under "Serial Connection" change the "Serial Port" setting to "/tmp/printer". For common micro-controllers, the code can be flashed with something similar to: From the main page, under the "Connection" section (at the top left of the page) make sure the "Serial Port" is set to "/tmp/printer" and click "Connect". (If "/tmp/printer" is not an available selection then try reloading the page.) In addition to common g-code commands, Klipper supports a few extended commands - "status" and "restart" are examples of these commands. Use the "help" command to get a list of other extended commands. In the Settings tab, navigate to the "Behavior" sub-tab and select the "Cancel any ongoing prints but stay connected to the printer" option. Click "Save". Installation It is necessary to determine the serial port connected to the micro-controller. For micro-controllers that connect via USB, run the following: It should report something similar to the following: It's common for each printer to have its own unique name for the micro-controller. The name may change after flashing Klipper, so rerun the `ls /dev/serial/by-id/*` command and then update the config file with the unique name. For example, update the `[mcu]` section to look something similar to: It's common for each printer to have its own unique serial port name. This unique name will be used when flashing the micro-controller. It's possible there may be multiple lines in the above output - if so, choose the line corresponding to the micro-controller (see the [FAQ](FAQ.md#wheres-my-serial-port) for more information). Klipper currently supports a number of Atmel ATmega based micro-controllers, [ARM based micro-controllers](Features.md#step-benchmarks), and [Beaglebone PRU](Beaglebone.md) based printers. Klipper reports error messages via the OctoPrint terminal tab. The "status" command can be used to re-report error messages. The default Klipper startup script also places a log in **/tmp/klippy.log** which provides more detailed information. Make sure to review and update each setting that is appropriate for the hardware. Navigate to the Settings tab (the wrench icon at the top of the page). Under "Serial Connection" in "Additional serial ports" add "/tmp/printer". Then click "Save". Once connected, navigate to the "Terminal" tab and type "status" (without the quotes) into the command entry box and click "Send". The terminal window will likely report there is an error opening the config file - that means OctoPrint is successfully communicating with Klipper. Proceed to the next section. Prepping an OS image Select the appropriate micro-controller and review any other options provided. Once configured, run: Start by installing [OctoPi](https://github.com/guysoft/OctoPi) on the Raspberry Pi computer. Use OctoPi v0.17.0 or later - see the [OctoPi releases](https://github.com/guysoft/OctoPi/releases) for release information. One should verify that OctoPi boots and that the OctoPrint web server works. After connecting to the OctoPrint web page, follow the prompt to upgrade OctoPrint to v1.4.2 or later. The Klipper configuration is stored in a text file on the Raspberry Pi. Take a look at the example config files in the [config directory](../config/). The [Config Reference](Config_Reference.md) contains documentation on config parameters. The OctoPrint web server needs to be configured to communicate with the Klipper host software. Using a web browser, login to the OctoPrint web page and then configure the following items: The above will download Klipper, install some system dependencies, setup Klipper to run at system startup, and start the Klipper host software. It will require an internet connection and it may take a few minutes to complete. These instructions assume the software will run on a Raspberry Pi computer in conjunction with OctoPrint. It is recommended that a Raspberry Pi 2, 3, or 4 computer be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other machines). To compile the micro-controller code, start by running these commands on the Raspberry Pi: When flashing for the first time, make sure that OctoPrint is not connected directly to the printer (from the OctoPrint web page, under the "Connection" section, click "Disconnect"). [mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
 cd ~/klipper/
make menuconfig
 cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
 git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
 ls /dev/serial/by-id/*
 make
 sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
 Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:52+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/installation/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
 Miután a Klipper azt jelenti, hogy a nyomtató készen áll, lépjen tovább a [konfigurációs ellenőrző dokumentum](Config_checks.md) oldalra, és hajtson végre néhány alapvető ellenőrzést a tű-definíciókon a konfigurációs fájlban. A fájl létrehozása és szerkesztése után a konfiguráció betöltéséhez az OctoPrint webterminálban egy "restart" parancsot kell kiadni. A "status" parancs jelzi, hogy a nyomtató készen áll, ha a Klipper konfigurációs fájlja sikeresen beolvasásra került, és a mikrovezérlőt sikerült megtalálni és konfigurálni. Nem szokatlan, hogy a kezdeti beállítás során konfigurációs hibák lépnek fel – frissítse a nyomtató konfigurációs fájlját, és adja meg az „újraindítás” üzenetet, amíg az „állapot” nem jelzi, hogy a nyomtató készen áll. Az OctoPi telepítése és az OctoPrint frissítése után néhány rendszerparancs futtatásához szükség lesz az "SSH" kapcsolatra a célgéphez. Ha Linux vagy MacOS asztali számítógépet használ, akkor az "SSH" szoftvernek már telepítve kell lennie az asztalon. Vannak ingyenes ssh-kliensek más asztali számítógépekhez (pl. [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Az SSH segédprogrammal csatlakozzon a Raspberry Pi-hez (ssh pi@octopi -- a jelszó "raspberry"), és futtassa a következő parancsokat: Alternatív megoldásként a fájlt közvetlenül a Raspberry Pi-n is másolhatja és szerkesztheti SSH-n keresztül - például: A Klipper konfigurációs fájljának frissítésének legegyszerűbb módja egy olyan asztali szerkesztő használata, amely támogatja a fájlok "scp" és/vagy "sftp" protokollon keresztüli szerkesztését. Vannak ingyenesen elérhető eszközök, amelyek ezt támogatják (pl. Notepad++, WinSCP és Cyberduck). Használja az egyik példa konfigurációs fájlt kiindulási pontként, és mentse el "printer.cfg" nevű fájlként a pi felhasználó kezdőkönyvtárába (azaz /home/pi/printer.cfg). Nézze meg a [GYIK](FAQ.md) részt, ahol választ talál néhány gyakori kérdésre. Tekintse meg a [kapcsolati oldalt](Contact.md) a hiba bejelentéséhez vagy a fejlesztőkkel való kapcsolatfelvételhez. Feltétlenül frissítse a FLASH_DEVICE eszközt a nyomtató egyedi soros portjának nevével. A mikrokontroller felépítése és égetése A Klipper beállítása Az OctoPrint beállítása a Klipper használatához Kapcsolatfelvétel a fejlesztőkkel Lépjen újra a Beállítások fülre, és a „Soros kapcsolat” alatt módosítsa a „Soros port” beállítást „/tmp/printer”-re. Az általános mikrokontrollereknél a kódot valami hasonlóval lehet égetni: A főoldalon, a „Kapcsolat” részben (az oldal bal felső sarkában) győződjön meg arról, hogy a „Soros Port” beállítása „/tmp/printer”, majd kattintson a „Csatlakozás” gombra. (Ha a „/tmp/printer” nem elérhető, próbálja meg újratölteni az oldalt.) A gyakori G-Kód parancsokon kívül a Klipper néhány kiterjesztett parancsot is támogat. Az „állapot” és az „újraindítás” példák ezekre a parancsokra. Használja a "help" parancsot az egyéb kiterjesztett parancsok listájának megtekintéséhez. A Beállítások lapon lépjen a „Viselkedés” allapra, és válassza a „Folyamatban lévő nyomtatás törlése, de továbbra is csatlakozva maradjon a nyomtatóhoz” lehetőséget. Kattintson a "Mentés" gombra. Telepítés Meg kell határozni a mikrovezérlőhöz csatlakoztatott soros portot. Az USB-n keresztül csatlakozó mikrovezérlők esetében futtassa a következőt: Valami hasonlót kell kapnia az alábbiakhoz: Gyakori, hogy minden nyomtató mikrovezérlőnek egyedi neve van a. A név megváltozhat a Klipper égetése után, ezért futtassa újra az `ls /dev/serial/by-id/*` parancsot, majd frissítse a konfigurációs fájlt az egyedi névvel. Például frissítse az `[mcu]` részt, hogy az a következőhöz hasonló legyen: Gyakori, hogy minden nyomtatónak saját egyedi soros port neve van. Ezt az egyedi nevet használjuk a mikrokontroller égetésére. Lehetséges, hogy a fenti kimenetben több sor is található – ha igen, válassza ki a mikrovezérlőnek megfelelő sort (további információért lásd a [GYIK](FAQ.md#wheres-my-serial-port) részt). A Klipper jelenleg számos Atmel ATmega alapú mikrovezérlőt, [ARM alapú mikrovezérlőt](Features.md#step-benchmarks) és [Beaglebone PRU](Beaglebone.md) alapú nyomtatót támogat. A Klipper az OctoPrint terminállapon keresztül jelenti a hibaüzeneteket. A "status" paranccsal a hibaüzenetek újra jelenthetők. A Klipper alapértelmezett indítószkriptje egy naplót is elhelyez a **/tmp/klippy.log** fájlban, amely részletesebb információkat tartalmaz. Mindenképpen tekintse át és frissítse a hardvernek megfelelő beállításokat. Lépjen a Beállítások lapra (a csavarkulcs ikon az oldal tetején). A "További soros portok" részben a "Soros kapcsolat" alatt adja hozzá a "/tmp/printer" elemet. Ezután kattintson a "Mentés" gombra. A csatlakozás után lépjen a "Terminal" fülre, és írja be a "status" kifejezést (idézőjelek nélkül) a parancsbeviteli mezőbe, majd kattintson a "Küldés" gombra. A terminálablak valószínűleg hibát jelez a konfigurációs fájl megnyitásakor – ez azt jelenti, hogy az OctoPrint sikeresen kommunikál a Klipperrel. Tovább a következő részhez. OS képfájl előkészítése Válassza ki a megfelelő mikrovezérlőt, és tekintse át a rendelkezésre álló egyéb lehetőségeket. A konfigurálás után futtassa: Kezdje az [OctoPi](https://github.com/guysoft/OctoPi) telepítésével a Raspberry Pi számítógépére. Használja az OctoPi v0.17.0-s vagy újabb verzióját. A kiadásokkal kapcsolatos információkért tekintse meg az [OctoPi-kiadásokat](https://github.com/guysoft/OctoPi/releases). Ellenőrizni kell, hogy az OctoPi elindul-e, és hogy az OctoPrint webszerver működik-e. Miután csatlakozott az OctoPrint weboldalhoz, kövesse az utasításokat az OctoPrint 1.4.2-es vagy újabb verziójára való frissítéséhez. A Klipper konfigurációja a Raspberry Pi szöveges fájljában van tárolva. Vessen egy pillantást a példa konfigurációs fájlokra a [Konfigurációs könyvtárban](../config/). A [Konfigurációs hivatkozás](Config_Reference.md) dokumentációt tartalmaz a konfigurációs paraméterekről. Az OctoPrint webszervert konfigurálni kell, hogy kommunikáljon a Klipper gazdagép szoftverével. Egy webböngészővel jelentkezzen be az OctoPrint weboldalra, majd konfigurálja a következő elemeket: A fentiek letöltik a Klippert, telepítenek néhány rendszerösszetevőt, beállítják a Klippert, hogy a rendszer indulásakor fusson, és elindítja a Klipper gazdagép szoftverét. Internetkapcsolatra lesz szükség, és néhány percet is igénybe vehet. Ezek az utasítások feltételezik, hogy a szoftver egy Raspberry Pi számítógépen fut az OctoPrint-el együtt. Javasoljuk, hogy egy Raspberry Pi 2, 3 vagy 4-es számítógépet használjon gazdagépként (más gépekre vonatkozóan lásd a [GYIK](FAQ.md#can-i-run-klipper-on-something-other-other-than-a-raspberry-pi-3) című részt). A mikrokontroller kódjának lefordításához futtassa ezeket a parancsokat a Raspberry Pi-n: Amikor először éget, győződjön meg arról, hogy az OctoPrint nincs közvetlenül csatlakoztatva a nyomtatóhoz (az OctoPrint weboldalon a "Kapcsolat" részben kattintson a "Kapcsolat bontása" gombra). [mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
 cd ~/klipper/
make menuconfig
 cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
 git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
 ls /dev/serial/by-id/*
 make
 sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
 