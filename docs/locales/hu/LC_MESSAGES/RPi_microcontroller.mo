��    8      �  O   �      �  =   �  i    �   �  �        �     �     �     �     �     �     �     �  2   �  "   �  �      C   �     ?  �   D  j     W   �     �     �  �  u  �  U     1     H  '   _     �  Q   �     �  h  �     Z   �   r   �   C!  f   �!  x   L"  t   �"  �   :#  8   �#      $  5   8$  ^   n$  _   �$     -%  �   M%  a   �%     8&  u   W&  (   �&     �&     �&  	   '     '  @   1'     r'  �  �'  G   )  i  f)  �   �9  �   X:     ;     	;     ;     ;     ;     ;     ;     ;  9   ;  +   U;  �   �;  L   n<     �<  �   �<  |   �=  t   5>     �>  �   �>  G  y?    �A  "   �C     �C  3   D     KD  O   OD     �D  �  �D     dF  �   F  �   hG     H  �   �H  �   ,I  �   �I  b   \J  =   �J  I   �J  e   GK  �   �K  :   2L  �   mL  a   M     qM  u   �M  (   N     /N     8N  	   DN     NN  @   jN     �N        8              1                4   ,      +   $   0          7                                 (             !                     -   2   )          6      	                
            *   .   &       5          /           %   "         '            3   #                       # Enable pwmchip sysfs interface
dtoverlay=pwm,pin=12,func=4
 $ gpiodetect
gpiochip0 [pinctrl-bcm2835] (54 lines)
gpiochip1 [raspberrypi-exp-gpio] (8 lines)

$ gpioinfo
gpiochip0 - 54 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       unused   input  active-high
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
        line   8:      unnamed       unused   input  active-high
        line   9:      unnamed       unused   input  active-high
        line  10:      unnamed       unused   input  active-high
        line  11:      unnamed       unused   input  active-high
        line  12:      unnamed       unused   input  active-high
        line  13:      unnamed       unused   input  active-high
        line  14:      unnamed       unused   input  active-high
        line  15:      unnamed       unused   input  active-high
        line  16:      unnamed       unused   input  active-high
        line  17:      unnamed       unused   input  active-high
        line  18:      unnamed       unused   input  active-high
        line  19:      unnamed       unused   input  active-high
        line  20:      unnamed    "klipper"  output  active-high [used]
        line  21:      unnamed       unused   input  active-high
        line  22:      unnamed       unused   input  active-high
        line  23:      unnamed       unused   input  active-high
        line  24:      unnamed       unused   input  active-high
        line  25:      unnamed       unused   input  active-high
        line  26:      unnamed       unused   input  active-high
        line  27:      unnamed       unused   input  active-high
        line  28:      unnamed       unused   input  active-high
        line  29:      unnamed       "led0"  output  active-high [used]
        line  30:      unnamed       unused   input  active-high
        line  31:      unnamed       unused   input  active-high
        line  32:      unnamed       unused   input  active-high
        line  33:      unnamed       unused   input  active-high
        line  34:      unnamed       unused   input  active-high
        line  35:      unnamed       unused   input  active-high
        line  36:      unnamed       unused   input  active-high
        line  37:      unnamed       unused   input  active-high
        line  38:      unnamed       unused   input  active-high
        line  39:      unnamed       unused   input  active-high
        line  40:      unnamed       unused   input  active-high
        line  41:      unnamed       unused   input  active-high
        line  42:      unnamed       unused   input  active-high
        line  43:      unnamed       unused   input  active-high
        line  44:      unnamed       unused   input  active-high
        line  45:      unnamed       unused   input  active-high
        line  46:      unnamed       unused   input  active-high
        line  47:      unnamed       unused   input  active-high
        line  48:      unnamed       unused   input  active-high
        line  49:      unnamed       unused   input  active-high
        line  50:      unnamed       unused   input  active-high
        line  51:      unnamed       unused   input  active-high
        line  52:      unnamed       unused   input  active-high
        line  53:      unnamed       unused   input  active-high
gpiochip1 - 8 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       "led1"  output   active-low [used]
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
 ***Warning:*** only gpio marked as `unused` can be used. It is not possible for a *line* to be used by multiple processes simultaneously. **Warning**: If your platform is a *Beaglebone* and you have correctly followed the installation steps, the linux mcu is already installed and configured for your system. 0 1 12 13 18 19 2 4 After installing Klipper, install the script. run: Building the micro-controller code Complete the installation by configuring Klipper secondary MCU following the instructions in [RaspberryPi sample config](../config/sample-raspberry-pi.cfg) and [Multi MCU sample config](../config/sample-multi-mcu.cfg). For example on a RPi 3B+ where klipper use the GPIO20 for a switch: Func If klippy.log reports a "Permission denied" error when attempting to connect to `/tmp/klipper_host_mcu` then you need to add your user to the tty group. The following command will add the "pi" user to the tty group: If you want to use the host as a secondary MCU the klipper_mcu process must run before the klippy process. In the menu, set "Microcontroller Architecture" to "Linux process," then save and exit. Install the rc script Make sure the Linux SPI driver is enabled by running `sudo raspi-config` and enabling SPI under the "Interfacing options" menu. Often the MCUs dedicated to controlling 3D printers have a limited and pre-configured number of exposed pins to manage the main printing functions (thermal resistors, extruders, steppers ...). Using the RPi where Klipper is installed as a secondary MCU gives the possibility to directly use the GPIOs and the buses (i2c, spi) of the RPi inside klipper without using Octoprint plugins (if used) or external programs giving the ability to control everything within the print GCODE. On Raspberry Pi and on many clones the pins exposed on the GPIO belong to the first gpiochip. They can therefore be used on klipper simply by referring them with the name `gpio0..n`. However, there are cases in which the exposed pins belong to gpiochips other than the first. For example in the case of some OrangePi models or if a Port Expander is used. In these cases it is useful to use the commands to access the *Linux GPIO character device* to verify the configuration. Optional: Enabling SPI Optional: Hardware PWM Optional: Identify the correct gpiochip PWM PWM0 can be routed to gpio12 and gpio18, PWM1 can be routed to gpio13 and gpio19: RPi microcontroller Raspberry Pi's have two PWM channels (PWM0 and PWM1) which are exposed on the header or if not, can be routed to existing gpio pins. The Linux mcu daemon uses the pwmchip sysfs interface to control hardware pwm devices on Linux hosts. The pwm sysfs interface is not exposed by default on a Raspberry and can be activated by adding a line to `/boot/config.txt`: Remaining configuration The chosen pin can thus be used within the configuration as `gpiochip<n>/gpio<o>` where **n** is the chip number as seen by the `gpiodetect` command and **o** is the line number seen by the`gpioinfo` command. The overlay does not expose the pwm line on sysfs on boot and needs to be exported by echo'ing the number of the pwm channel to `/sys/class/pwm/pwmchip0/export`: This document describes the process of running Klipper on a RPi and use the same RPi as secondary mcu. This example enables only PWM0 and routes it to gpio12. If both PWM channels need to be enabled you can use `pwm-2chan`. This will add hardware pwm control to gpio12 on the Pi (because the overlay was configured to route pwm0 to pin=12). This will create device `/sys/class/pwm/pwmchip0/pwm0` in the filesystem. The easiest way to do this is by adding this to `/etc/rc.local` before the `exit 0` line. To build and install the new micro-controller code, run: To check available gpiochip run: To check the pin number and the pin availability tun: To compile the Klipper micro-controller code, start by configuring it for the "Linux process": To install the *Linux GPIO character device - binary* on a debian based distro like octopi run: Why use RPi as a secondary MCU? With the sysfs in place, you can now use either the pwm channel(s) by adding the following piece of configuration to your `printer.cfg`: [output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001
 cd ~/klipper/
make menuconfig
 cd ~/klipper/
sudo cp "./scripts/klipper-mcu-start.sh" /etc/init.d/klipper_mcu
sudo update-rc.d klipper_mcu defaults
 echo 0 > /sys/class/pwm/pwmchip0/export
 gpio PIN gpiodetect
 gpioinfo
 sudo apt-get install gpiod
 sudo service klipper stop
make flash
sudo service klipper start
 sudo usermod -a -G tty pi
 Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:56+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/rpi_microcontroller/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 # A pwmchip sysfs felület engedélyezése
dtoverlay=pwm,pin=12,func=4
 $ gpiodetect
gpiochip0 [pinctrl-bcm2835] (54 lines)
gpiochip1 [raspberrypi-exp-gpio] (8 lines)

$ gpioinfo
gpiochip0 - 54 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       unused   input  active-high
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
        line   8:      unnamed       unused   input  active-high
        line   9:      unnamed       unused   input  active-high
        line  10:      unnamed       unused   input  active-high
        line  11:      unnamed       unused   input  active-high
        line  12:      unnamed       unused   input  active-high
        line  13:      unnamed       unused   input  active-high
        line  14:      unnamed       unused   input  active-high
        line  15:      unnamed       unused   input  active-high
        line  16:      unnamed       unused   input  active-high
        line  17:      unnamed       unused   input  active-high
        line  18:      unnamed       unused   input  active-high
        line  19:      unnamed       unused   input  active-high
        line  20:      unnamed    "klipper"  output  active-high [used]
        line  21:      unnamed       unused   input  active-high
        line  22:      unnamed       unused   input  active-high
        line  23:      unnamed       unused   input  active-high
        line  24:      unnamed       unused   input  active-high
        line  25:      unnamed       unused   input  active-high
        line  26:      unnamed       unused   input  active-high
        line  27:      unnamed       unused   input  active-high
        line  28:      unnamed       unused   input  active-high
        line  29:      unnamed       "led0"  output  active-high [used]
        line  30:      unnamed       unused   input  active-high
        line  31:      unnamed       unused   input  active-high
        line  32:      unnamed       unused   input  active-high
        line  33:      unnamed       unused   input  active-high
        line  34:      unnamed       unused   input  active-high
        line  35:      unnamed       unused   input  active-high
        line  36:      unnamed       unused   input  active-high
        line  37:      unnamed       unused   input  active-high
        line  38:      unnamed       unused   input  active-high
        line  39:      unnamed       unused   input  active-high
        line  40:      unnamed       unused   input  active-high
        line  41:      unnamed       unused   input  active-high
        line  42:      unnamed       unused   input  active-high
        line  43:      unnamed       unused   input  active-high
        line  44:      unnamed       unused   input  active-high
        line  45:      unnamed       unused   input  active-high
        line  46:      unnamed       unused   input  active-high
        line  47:      unnamed       unused   input  active-high
        line  48:      unnamed       unused   input  active-high
        line  49:      unnamed       unused   input  active-high
        line  50:      unnamed       unused   input  active-high
        line  51:      unnamed       unused   input  active-high
        line  52:      unnamed       unused   input  active-high
        line  53:      unnamed       unused   input  active-high
gpiochip1 - 8 lines:
        line   0:      unnamed       unused   input  active-high
        line   1:      unnamed       unused   input  active-high
        line   2:      unnamed       "led1"  output   active-low [used]
        line   3:      unnamed       unused   input  active-high
        line   4:      unnamed       unused   input  active-high
        line   5:      unnamed       unused   input  active-high
        line   6:      unnamed       unused   input  active-high
        line   7:      unnamed       unused   input  active-high
 **Figyelmeztetés:** csak `unused` jelöléssel rendelkező GPIO használható. A *line* nem használható egyszerre több folyamatban. **Figyelmeztetés**: Ha az Ön platformja egy *Beaglebone*, és helyesen követte a telepítés lépéseit, a Linux MCU már telepítve és konfigurálva van a rendszeréhez. 0 1 12 13 18 19 2 4 A Klipper telepítése után telepítse a szkriptet. run: A mikrokontroller kódjának elkészítése Fejezze be a telepítést a Klipper másodlagos MCU konfigurálásával a [RaspberryPi minta konfiguráció](../config/sample-raspberry-pi.cfg) és a [Multi MCU minta konfiguráció](../config/sample-multi-mcu.cfg) utasításai szerint. Például egy RPi 3B+, ahol a klipper használja a GPIO20-at, egy kapcsoló: Func Ha a klippy.log a `/tmp/klipper_host_mcu`-hoz való kapcsolódási kísérletnél "Permission denied" hibát jelez, akkor a felhasználót hozzá kell adnia a tty csoporthoz. A következő parancs hozzáadja a "pi" felhasználót a tty csoporthoz: Ha a gazdagépet másodlagos MCU-ként szeretné használni, a klipper_mcu folyamatnak a klippy folyamat előtt kell futnia. A menüben állítsa be a "Mikrokontroller architektúra" értéket "Linux process,"-re, majd mentse és lépjen ki. Az rc szkript telepítése Győződjünk meg róla, hogy a Linux SPI-illesztőprogram engedélyezve van a `sudo raspi-config` futtatásával és az SPI engedélyezésével az "Interfacing options" menüben. A 3D nyomtatók vezérlésére szolgáló MCU-k gyakran korlátozott és előre konfigurált számú szabad kimenettel rendelkeznek a fő nyomtatási funkciók (hőellenállások, extruderek, léptetők stb.) kezelésére. Az RPi használata, ahol a Klipper másodlagos MCU-ként van telepítve, lehetővé teszi a GPIO-k és az RPi kimeneteinek (I2C, SPI) közvetlen használatát a klipperben anélkül, hogy Octoprint bővítményeket (ha van ilyen) vagy külső programokat használva, amelyek lehetővé teszik, hogy mindent vezéreljen a Klipper-en belül a nyomtatási G-Kód. A Raspberry Pi-n és sok klónon a GPIO-n látható tűk az első GPIO chiphez tartoznak. Ezért a klipperben egyszerűen úgy használhatók, hogy a `gpio0..n` névvel hivatkozunk rájuk. Vannak azonban olyan esetek, amikor a kitett tűk az elsőtől eltérő GPIO chipekhez tartoznak. Például egyes OrangePi modellek esetében, vagy ha Port Expander-t használunk. Ezekben az esetekben hasznos a *Linux GPIO karakteres eszköz *Linux GPIO eszköz* elérésére szolgáló parancsok használata a konfiguráció ellenőrzéséhez. Választható: SPI engedélyezése Választható: Hardveres PWM Választható: A megfelelő GPIO chip azonosítása PWM A PWM0 a GPIO12 és a GPIO18 a PWM1 a GPIO13 és a GPIO19 felé irányítható: RPi mikrokontroller A Raspberry Pi két PWM csatornával (PWM0 és PWM1) rendelkezik, amelyek a fejlécen láthatók, vagy ha nem, akkor a meglévő GPIO érintkezőkhöz irányíthatók. A Linux mcu démon a pwmchip sysfs interfészt használja a hardveres PWM eszközök vezérlésére a Linux gazdagépeken. A PWM sysfs interfész alapértelmezés szerint nincs kitéve a Raspberry-n, és a `/boot/config.txt` egy sor hozzáadásával aktiválható: Hátralevő konfiguráció A kiválasztott tű így a konfiguráción belül `gpiochip<n>/gpio<o> néven használható;` ahol **n** a `gpiodetect` által látott chipszám parancs által látott sorszám, és **o** a`gpioinfo` parancs által látott sorszám. Az átfedés nem teszi ki a PWM sort a sysfs-en a rendszerindításkor, és azt a PWM csatorna számát a `/sys/class/pwm/pwmchip0/export` echo'ing-be kell exportálni: Ez a dokumentum leírja a Klipper futtatásának folyamatát egy RPi-n, és ugyanazt az RPi-t használja másodlagos MCU-ként. Ez a példa csak a PWM0-t engedélyezi, és a GPIO12-re irányítja. Ha mindkét PWM csatornát engedélyezni kell, használhatja a `pwm-2chan` parancsot. Ez hozzáadja a hardveres PWM vezérlést a Pi GPIO12-höz (mivel az átfedés úgy volt konfigurálva, hogy a PWM0-t a pin=12-re irányítsa). Ez létrehozza a `/sys/class/pwm/pwmchip0/pwm0` eszközt a fájlrendszerben. A legegyszerűbb, ha ezt a `/etc/rc.local` sor előtt az `exit 0` sorba írjuk be. Az új mikrokontroller kódjának elkészítéséhez és telepítéséhez futtassa a következőt: A rendelkezésre álló GPIO chip ellenőrzéséhez futtassa: A tű számának és a tű elérhetőségének ellenőrzésére futtassa: A Klipper mikrokontroller kódjának lefordításához kezdje a "Linux folyamat" konfigurálásával: A *Linux GPIO character device - binary* telepítéséhez egy debian alapú disztribúció kell, mint például az octopi. Futtassa: Miért érdemes az RPi-t másodlagos MCU-ként használni? Ha a sysfs a helyén van, akkor most már használhatja a PWM csatornát vagy csatornákat, ha a következő konfigurációt hozzáadja a `printer.cfg` fájlhoz: [output_pin caselight]
pin: host:pwmchip0/pwm0
pwm: True
hardware_pwm: True
cycle_time: 0.000001
 cd ~/klipper/
make menuconfig
 cd ~/klipper/
sudo cp "./scripts/klipper-mcu-start.sh" /etc/init.d/klipper_mcu
sudo update-rc.d klipper_mcu defaults
 echo 0 > /sys/class/pwm/pwmchip0/export
 gpio PIN gpiodetect
 gpioinfo
 sudo apt-get install gpiod
 sudo service klipper stop
make flash
sudo service klipper start
 sudo usermod -a -G tty pi
 