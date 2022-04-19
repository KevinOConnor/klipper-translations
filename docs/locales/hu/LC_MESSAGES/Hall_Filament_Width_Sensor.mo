��          �      l      �  5   �  /        G  M   ]     �     �     �  E   �  G   3  �   {     @  D   H  C  �     �  e  �  m   S  b   �  �   $  �   �  i  �	  �  �
  P   �  F   �       q   4  +   �     �     �  h     m   l    �  
   �  ^   �  �  \       �  %  �   �  �   m  �   �  �   �  i  �                  
                	                                                                By default, diameter logging is disabled at power-on. By default, the sensor is disabled at power-on. Calibration procedure Filament diameter is logged on every measurement interval (10 mm by default). Hall filament width sensor How does it work? How to enable sensor Insert first calibration rod (1.5 mm size) get first raw sensor value Insert second calibration rod (2.0 mm size) get second raw sensor value Issue **ENABLE_FILAMENT_WIDTH_LOG** command to start logging and issue **DISABLE_FILAMENT_WIDTH_LOG** command to stop logging. To enable logging at power-on, set the `logging` parameter to `true`. Logging Save raw sensor values in config parameter `Raw_dia1` and `Raw_dia2` Sensor generates two analog output based on calculated filament width. Sum of output voltage always equals to detected filament width. Host module monitors voltage changes and adjusts extrusion multiplier. I use aux2 connector on ramps-like board analog11 and analog12 pins. You can use different pins and differenr boards. Template for menu variables This document describes Filament Width Sensor host module. Hardware used for developing this host module is based on two Hall linear sensors (ss49e for example). Sensors in the body are located opposite sides. Principle of operation: two hall sensors work in differential mode, temperature drift same for sensor. Special temperature compensation not needed. To enable the sensor, issue **ENABLE_FILAMENT_WIDTH_SENSOR** command or set the `enable` parameter to `true`. To get raw sensor value you can use menu item or **QUERY_RAW_FILAMENT_WIDTH** command in terminal. To use Hall filament width sensor, read [Config Reference](Config_Reference.md#hall_filament_width_sensor) and [G-Code documentation](G-Codes.md#hall_filament_width_sensor). You can find designs at [Thingiverse](https://www.thingiverse.com/thing:4138933), an assembly video is also available on [Youtube](https://www.youtube.com/watch?v=TDO9tME8vp4) [menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
 Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:51+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/hall_filament_width_sensor/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 Alapértelmezés szerint az átmérő naplózása bekapcsoláskor le van tiltva. Alapértelmezés szerint az érzékelő le van tiltva bekapcsoláskor. Kalibrálási eljárás A nyomtatószál átmérője minden mérési intervallumban naplózásra kerül (alapértelmezés szerint 10 mm). Hall nyomtatószál szélesség érzékelő Hogyan működik? Az érzékelő engedélyezése Helyezze be az első kalibráló rudat (1,5 mm-es méret), hogy megkapja az első nyers szenzorértéket Helyezze be a második kalibráló rudat (2,0 mm-es méret), hogy megkapja a második nyers szenzorértékét Adja ki az **ENABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás elindításához, és adja ki a **DISABLE_FILAMENT_WIDTH_LOG** parancsot a naplózás leállításához. A bekapcsoláskor történő naplózás engedélyezéséhez állítsa a `logging paramétert `true` értékre. Naplózás Mentse a nyers szenzorértékeket a `Raw_dia1` és a `Raw_dia2` konfigurációs paraméterekbe Az érzékelő két analóg kimenetet generál az izzószál számított szélessége alapján. A kimeneti feszültség összege mindig megegyezik az izzószál érzékelt szélességével. A gazdamodul figyeli a feszültségváltozásokat és beállítja az extrudálási szorzót. Aux2 csatlakozót használok a RAMPS kártya analóg11 és analóg12 érintkezőin. Különböző csapokat és különböző táblákat használhat. Menüváltozók sablonja Ez a dokumentum az izzószálszélesség-érzékelő gazdagép modulját írja le. A gazdamodul fejlesztéséhez használt hardver két Hall lineáris érzékelőn alapul (például ss49e). Az érzékelők a testben ellentétes oldalon helyezkednek el. Működési elv: két Hall érzékelő differenciál üzemmódban működik, a hőmérséklet csúszás ugyanaz a szenzornál. Speciális hőmérséklet kompenzáció nem szükséges. Az érzékelő engedélyezéséhez adja ki az **ENABLE_FILAMENT_WIDTH_SENSOR** parancsot, vagy állítsa az `enable` paramétert `true` értékre. Az érzékelő nyers értékének meghatározásához használhatja a menüelemet vagy a **QUERY_RAW_FILAMENT_WIDTH** parancsot a terminálban. A Hall nyomtatószál szélesség érzékelő használatához olvassa el a [Config Reference](Config_Reference.md#hall_filament_width_sensor) és a [G-Code dokumentáció](G-Codes.md#hall_filament_width_sensor) részt. Terveket a [Thingiverse] oldalon találja (https://www.thingiverse.com/thing:4138933), az összeszerelési videó a [Youtube]-on is elérhető (https://www.youtube.com/watch?v=TDO9tME8vp4 ) [menu __main __filament __width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Dia: {'%.2F' % printer.hall_filament_width_sensor.Diameter}
index: 0

[menu __main __filament __raw_width_current]
type: command
enable: {'hall_filament_width_sensor' in printer}
name: Raw: {'%4.0F' % printer.hall_filament_width_sensor.Raw}
index: 1
 