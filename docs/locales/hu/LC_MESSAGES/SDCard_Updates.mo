��    %      D  5   l      @  >   A  O   �  �  �     �     �  �   �  b   {  �   �     {     �  �   �       �   �  �   T	  �   �	  �   `
  �   I  �  �  �   �  �   �  �   �  2  W     �  :   �    �  &   �  �        �  �     �   �  �   |  m     �   ~  }     v   �  �     �  �  >   @  O     �  �     �     �  �   �  b   �  �   �     �     �  �   �  �   /  �   �  �   �   �   !  *  �!  �   �"  X  �#    �%    �&  �   �'  ]  �(     (*  ?   A*  M  �*  "   �+    �+     �,    -  �   .  �   �.  �   j/  �   �/  �   �0  �   Q1  �   �1        "                                #                                         !                    $                 	       
      %                                                ./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
 ./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
 ./scripts/flash-sdcard.sh -h
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
 ./scripts/flash-sdcard.sh -l
 Advanced Usage As mentioned in the introduction, this method only works for upgrading firmware. The initial flashing procedure must be done manually per the instructions that apply to your controller board. BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
 BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
 Board Definitions Caveats If software SPI is required the `spi_bus` field should be set to `swspi` and the following additional field should be specified: If you do not see your board listed it may be necessary to add a new board definition as [described below](#board-definitions). If you need a new board definition and you are uncomfortable with the procedure outlined above it is recommended that you request one in the [Klipper Community Discord](Contact.md#discord). If you wish to flash a build of Klipper located somewhere other than the default location it can be done by specifying the `-f` option: If your board is flashed with firmware that connects at a custom baud rate it is possible to upgrade by specifying the `-b` option: It is up to the user to determine the device location and board name. If a user needs to flash multiple boards, `flash-sdcard.sh` (or `make flash` if appropriate) should be run for each board prior to restarting the Klipper service. It should be exceedingly rare that Software SPI is necessary, typically only boards with design errors will require it. The `btt-skr-pro` board definition provides an example. Many of today's popular controller boards ship with a bootloader capable of updating firmware via SD Card. While this is convenient in many circumstances, these bootloaders typically provide no other way to update firmware. This can be a nuisance if your board is mounted in a location that is difficult to access or if you need to update firmware often. After Klipper has been initially flashed to a controller it is possible to transfer new firmware to the SD Card and initiate the flashing procedure via ssh. Most common boards should be available, however it is possible to add a new board definition if necessary. Board definitions are located in `~/klipper/scripts/spi_flash/board_defs.py`. The definitions are stored in dictionary, for example: Note that when upgrading a MKS Robin E3 it is not necessary to manually run `update_mks_robin.py` and supply the resulting binary to `flash-sdcard.sh`. This procedure is automated during the upload process. Only boards that use SPI for SD Card communication are supported. Boards that use SDIO, such as the Flymaker Flyboard and MKS Robin Nano V1/V2, will not work. Prior to creating a new board definition one should check to see if an existing board definition meets the criteria necessary for the new board. If this is the case, a `BOARD_ALIAS` may be specified. For example, the following alias may be added to specify `my-new-board` as an alias for `generic-lpc1768`: SDCard updates Supported boards can be listed with the following command: The above commands assume that your MCU connects at the default baud rate of 250000 and the firmware is located at `~/klipper/out/klipper.bin`. The `flash-sdcard.sh` script provides options for changing these defaults. All options can be viewed by the help screen: The following fields may be specified: The procedure for updating MCU firmware using the SD Card is similar to that of other methods. Instead of using `make flash` it is necessary to run a helper script, `flash-sdcard.sh`. Updating a BigTreeTech SKR 1.3 might look like the following: Typical Upgrade Procedure While it is possible to flash a build that changes the Serial Baud or connection interface (ie: from USB to UART), verification will always fail as the script will be unable to reconnect to the MCU to verify the current version. `cs_pin`: The Chip Select Pin connected to the SD Card. This should be retreived from the board schematic. This field is required. `current_firmware_path` The path on the SD Card where the renamed firmware file is located after a successful flash. The default is `firmware.cur`. `firmware_path`: The path on the SD Card where firmware should be transferred. The default is `firmware.bin`. `mcu`: The mcu type. This can be retrevied after configuring the build via `make menuconfig` by running `cat .config | grep CONFIG_MCU`. This field is required. `spi_bus`: The SPI bus connected to the SD Card. This should be retreived from the board's schematic. This field is required. `spi_pins`: This should be 3 comma separated pins that are connected to the SD Card in the format of `miso,mosi,sclk`. sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
 Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:57+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/sdcard_updates/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 ./scripts/flash-sdcard.sh -b 115200 /dev/ttyAMA0 btt-skr-v1.3
 ./scripts/flash-sdcard.sh -f ~/downloads/klipper.bin /dev/ttyAMA0 btt-skr-v1.3
 ./scripts/flash-sdcard.sh -h
SD Card upload utility for Klipper

usage: flash_sdcard.sh [-h] [-l] [-b <baud>] [-f <firmware>]
                       <device> <board>

positional arguments:
  <device>        device serial port
  <board>         board type

optional arguments:
  -h              show this message
  -l              list available boards
  -b <baud>       serial baud rate (default is 250000)
  -f <firmware>   path to klipper.bin
 ./scripts/flash-sdcard.sh -l
 Fejlett felhasználás Ahogy a bevezetőben említettük, ez a módszer csak a firmware frissítésére alkalmas. A kezdeti égetési eljárást kézzel kell elvégezni az alaplapra vonatkozó utasítások szerint. BOARD_ALIASES = {
    ...<previous aliases>,
    'my-new-board': BOARD_DEFS['generic-lpc1768'],
}
 BOARD_DEFS = {
    'generic-lpc1768': {
        'mcu': "lpc1768",
        'spi_bus': "ssp1",
        "cs_pin": "P0.6"
    },
    ...<further definitions>
}
 Alaplap definíciók Óvintézkedések Ha szoftveres SPI szükséges, az `spi_bus` mezőt `swspi` értékre kell állítani, és a következő további mezőt kell megadni: Ha nem látod az alaplapodat a listában, akkor lehet, hogy új alaplap definíciót kell hozzáadnod a [lentebb leírtak szerint](#board-definitions). Ha új alaplap definícióra van szükséged, és nem tetszik a fent leírt eljárás, akkor ajánlott, hogy a [Klipper Community Discord](Contact.md#discord) segítségével kérj egyet. Ha a Klipper egy, az alapértelmezett helytől eltérő helyen található készletét szeretné égetni, akkor ezt a `-f` opció megadásával teheti meg: Ha az alaplapod olyan firmware-vel égetted, amely egyéni átviteli sebesség mellett csatlakozik, akkor a `-b` opció megadásával frissítheted: Az eszköz helyének és az alaplap nevének meghatározása a felhasználó feladata. Ha a felhasználónak több alaplapot kell égetnie, akkor a Klipper szolgáltatás újraindítása előtt a `flash-sdcard.sh` (vagy `make flash`, ha szükséges) programot kell futtatni minden egyes alaplaphoz. Rendkívül ritkán van szükség a Software SPI-re, jellemzően csak a tervezési hibás lapok igénylik. A `btt-skr-pro` alaplap definíció erre ad példát. A manapság népszerű vezérlőlapok közül sokan olyan bootloaderrel rendelkeznek, amely képes a firmware SD-kártyán keresztül történő frissítésére. Bár ez sok esetben kényelmes, ezek a bootloaderek általában nem biztosítanak más módot a firmware frissítésére. Ez kellemetlen lehet, ha a kártyaolvasót úgy helyezték, hogy nehéz hozzáférni, főleg ha gyakran kell frissíteni a firmware-t. Miután a Klipper eredetileg egy vezérlőre lett égetve, lehetőség van az új firmware átvitelére az SD-kártyára, és a égetési eljárás elindítására SSH-n keresztül. A legtöbb általános alaplapnak rendelkezésre kell állnia, azonban szükség esetén új alaplap definíciót is hozzáadhat. Az alaplapdefiníciók a `~/klipper/scripts/spi_flash/board_defs.py` állományban találhatók. A definíciókat például lexikonban tároljuk: Ne feledje, hogy az MKS Robin E3 frissítésekor nem szükséges manuálisan futtatni a `update_mks_robin.py` fájlt, és az így kapott bináris állományt a `flash-sdcard.sh` fájlba táplálni. Ez az eljárás a feltöltési folyamat során automatikusan megtörténik. Csak azok a kártyák támogatottak, amelyek SPI-t használnak az SD-kártya kommunikációhoz. Az SDIO-t használó alaplapok, például a Flymaker Flyboard és az MKS Robin Nano V1/V2, nem működnek. Egy új alaplap definíció létrehozása előtt ellenőrizni kell, hogy egy meglévő alaplap definíció megfelel-e az új alaplap számára szükséges kritériumoknak. Ha ez a helyzet, akkor egy `BOARD_ALIAS` adható meg. Például a következő álnév adható hozzá `az én-új alaplapom` álneveként a `generic-lpc1768` meghatározásához: SD-kártya frissítések A támogatott alaplapok a következő paranccsal listázhatók: A fenti parancsok feltételezik, hogy az MCU az alapértelmezett 250000-es átviteli sebességgel csatlakozik, és a firmware a `~/klipper/out/klipper.bin` címen található. A `flash-sdcard.sh` szkript lehetőséget biztosít ezen alapértelmezések megváltoztatására. Az összes opciót a súgó képernyőn lehet megtekinteni: A következő mezők adhatók meg: Az MCU firmware SD-kártya használatával történő frissítésének menete hasonló a többi módszerhez. A `make flash` használata helyett egy segédszkriptet kell futtatni, `flash-sdcard.sh`. Egy BigTreeTech SKR 1.3 frissítése a következőképpen néz ki: Tipikus frissítési eljárás Bár lehetséges a soros adatátvitelt vagy a csatlakozási interfészt (pl. USB-ről UART-ra) módosító készlet égetése, az ellenőrzés mindig sikertelen lesz, mivel a szkript nem tud újra csatlakozni az MCU-hoz az aktuális verzió ellenőrzéséhez. `cs_pin`: Az SD-kártyához csatlakoztatott chipkiválasztó tű. Ezt a kártya kapcsolási rajzából kell visszakeresni. Ez a mező kötelező. `current_firmware_path` Az SD-kártyán lévő elérési útvonal, ahol az átnevezett firmware fájl található a sikeres flashelés után. Az alapértelmezett érték `firmware.cur`. `firmware_path`: Az SD-kártyán lévő elérési útvonal, ahová a firmware-t át kell vinni. Az alapértelmezett érték `firmware.bin`. `mcu`: Az mcu típusa. Ezt a készlet `make menuconfig` segítségével történő konfigurálása után a `cat .config | grep CONFIG_MCU` futtatásával lehet visszakeresni. Ez a mező kötelezően kitöltendő. `spi_bus`: Az SD-kártyához csatlakoztatott SPI-busz. Ezt a tábla kapcsolási rajzából kell visszakeresni. Ez a mező kötelező. `spi_pins`: Ennek 3 vesszővel elválasztott tűnek kell lennie, amelyek `miso,mosi,sclk` formátumban csatlakoznak az SD-kártyához. sudo service klipper stop
cd ~/klipper
git pull
make clean
make menuconfig
make
./scripts/flash-sdcard.sh /dev/ttyACM0 btt-skr-v1.3
sudo service klipper start
 