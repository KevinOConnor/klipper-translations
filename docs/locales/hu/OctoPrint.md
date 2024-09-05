# OctoPrint a Klipper-hez

A Klipper-nek van néhány opciója az alaplapokhoz, az Octoprint volt a Klipper első és eredeti kezelőfelülete. Ez a dokumentum rövid áttekintést ad az ezzel az opcióval történő telepítésről.

## Telepítés OctoPi-vel

Kezdd az [OctoPi](https://github.com/guysoft/OctoPi) telepítésével a Raspberry Pi számítógépre. Használd az OctoPi v0.17.0 vagy újabb verziót - a kiadással kapcsolatos információkért tekintsd meg az [OctoPi kiadást](https://github.com/guysoft/OctoPi/releases).

Ellenőrizni kell, hogy az OctoPi elindul-e, és hogy az OctoPrint webszerver működik-e. Miután csatlakoztál az OctoPrint weblaphoz, kövesd a felszólítást az OctoPrint frissítésére, ha szükséges.

Az OctoPi telepítése és az OctoPrint frissítése után be kell lépned a célgépre, hogy futtass egy maréknyi rendszerparancsot.

Kezd a következő parancsok futtatásával a gazdagépen:

**Ha nincs telepítve a git, kérjük, tedd ezt meg:**

```
sudo apt install git
```

majd folytasd:

```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

A fentiek letöltik a Klippert, telepítik a szükséges rendszerfüggőségeket, beállítják a Klippert, hogy a rendszer indításakor fusson, és elindítják a Klipper gazda szoftvert. Ehhez internetkapcsolat szükséges, és a művelet befejezése néhány percet vehet igénybe.

## Telepítés KIAUH-val

A KIAUH használható az OctoPrint telepítéséhez számos Linux alapú rendszerre, amelyeken a Debian egy formája fut. További információ található itt https://github.com/dw-0/kiauh

## OctoPrint beállítása a Klipper használatához

Az OctoPrint webszerverét úgy kell konfigurálni, hogy kommunikálni tudjon a Klipper gazda szoftverrel. Egy webböngésző segítségével jelentkezz be az OctoPrint weboldalára, majd konfiguráld a következő elemeket:

Navigálj a Beállítások fülre (a csavarkulcs ikon az oldal tetején). A "Soros kapcsolat" alatt a "További soros portok" alatt add hozzá:

```
~/printer_data/comms/klippy.sock
```

Ezután kattints a "Mentés" gombra.

*Némely régebbi rendszerben ez a cím lehet `/tmp/printer`*

Lépj be ismét a Beállítások fülre, és a "Soros kapcsolat" alatt módosítsd a "Soros port" beállítást a fent megadottra.

A Beállítások lapon navigálj a "Viselkedés" alfülre, és válaszd a "Folyamatban lévő nyomtatások törlése, de a nyomtatóhoz való csatlakozás fenntartása" lehetőséget. Kattints a "Mentés" gombra.

A főoldalon a "Csatlakozás" szakaszban (az oldal bal felső részén) győződj meg róla, hogy a "Soros port" az újonnan hozzáadott kiegészítő portra van beállítva, majd kattints a "Csatlakozás" gombra. (Ha nincs a rendelkezésre álló választékban, akkor próbáld meg újratölteni az oldalt.)

Ha csatlakoztál, navigálj a "Terminál" fülre, és írd be a "status" (idézőjelek nélkül) parancsot a parancsbeviteli mezőbe, majd kattints a "Küldés" gombra. A terminálablak valószínűleg azt fogja jelenteni, hogy hiba történt a konfigurációs fájl megnyitásakor - ez azt jelenti, hogy az OctoPrint sikeresen kommunikál a Klipper-rel.

Kérjük, folytasd az <Installation.md> és *A mikrokontroller építése és égetése* részt
