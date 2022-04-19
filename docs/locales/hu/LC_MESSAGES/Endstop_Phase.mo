��          �      l      �  �  �       �   �  m  a     �  *   �       <  #  �   `  �  +	     �
  �  �    �     �    �      �   5  n  )  [   �     �  �    �  �     S  �   j  �  j  #   F   *   j      �   �  �   �   j#  �  X$  L  >&  v  �(  1  -     4.  �  A.  �  �1  ,  K3  �  x4  p   ;7     �7                                    
                    	                                          A typical endstop switch has an accuracy of around 100 microns. (Each time an axis is homed the switch may trigger slightly earlier or slightly later.) Although this is a relatively small error, it can result in unwanted artifacts. In particular, this positional deviation may be noticeable when printing the first layer of an object. In contrast, typical stepper motors can obtain significantly higher precision. Additional notes After calibrating the endstop phase, if the endstop is later moved or adjusted then it will be necessary to recalibrate the endstop. Remove the calibration data from the config file and rerun the steps above. After performing the above, the `ENDSTOP_PHASE_CALIBRATE` command will often report the same (or nearly the same) phase for the stepper. This phase can be saved in the config file so that all future G28 commands use that phase. (So, in future homing operations, Klipper will obtain the same position even if the endstop triggers a little earlier or a little later.) Calibrating endstop phases ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
 Endstop phase If one is using a traditional stepper controlled Z axis (as on a cartesian or corexy printer) along with traditional bed leveling screws then it is also possible to use this system to arrange for each print layer to be performed on a "full step" boundary. To enable this feature be sure the G-Code slicer is configured with a layer height that is a multiple of a "full step", manually enable the endstop_align_zero option in the endstop_phase config section (see [config reference](Config_Reference.md#endstop_phase) for further details), and then re-level the bed screws. If using Trinamic stepper motor drivers with run-time configuration then one can calibrate the endstop phases using the ENDSTOP_PHASE_CALIBRATE command. Start by adding the following to the config file: In order to use this functionality it is necessary to be able to identify the phase of the stepper motor. If one is using Trinamic TMC2130, TMC2208, TMC2224 or TMC2660 drivers in run-time configuration mode (ie, not stand-alone mode) then Klipper can query the stepper phase from the driver. (It is also possible to use this system on traditional stepper drivers if one can reliably reset the stepper drivers - see below for details.) In order to use this system the endstop must be accurate enough to identify the stepper position within two "full steps". So, for example, if a stepper is using 16 micro-steps with a step distance of 0.005mm then the endstop must have an accuracy of at least 0.160mm. If one gets "Endstop stepper_z incorrect phase" type error messages than in may be due to an endstop that is not sufficiently accurate. If recalibration does not help then disable endstop phase adjustments by removing them from the config file. It is possible to use this system with traditional (non-Trinamic) stepper motor drivers. However, doing this requires making sure that the stepper motor drivers are reset every time the micro-controller is reset. (If the two are always reset together then Klipper can determine the stepper phase by tracking the total number of steps it has commanded the stepper to move.) Currently, the only way to do this reliably is if both the micro-controller and stepper motor drivers are powered solely from USB and that USB power is provided from a host running on a Raspberry Pi. In this situation one can specify an mcu config with "restart_method: rpi_usb" - that option will arrange for the micro-controller to always be reset via a USB power reset, which would arrange for both the micro-controller and stepper motor drivers to be reset together. If using this mechanism, one would then need to manually configure the "trigger_phase" config sections (see [config reference](Config_Reference.md#endstop_phase) for the details). Run the above for all the steppers one wishes to save. Typically, one would use this on stepper_z for cartesian and corexy printers, and for stepper_a, stepper_b, and stepper_c on delta printers. Finally, run the following to update the configuration file with the data: SAVE_CONFIG
 The stepper phase adjusted endstop mechanism can use the precision of the stepper motors to improve the precision of the endstop switches. A stepper motor moves by cycling through a series of phases until in completes four "full steps". So, a stepper motor using 16 micro-steps would have 64 phases and when moving in a positive direction it would cycle through phases: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, etc. Crucially, when the stepper motor is at a particular position on a linear rail it should always be at the same stepper phase. Thus, when a carriage triggers the endstop switch the stepper controlling that carriage should always be at the same stepper motor phase. Klipper's endstop phase system combines the stepper phase with the endstop trigger to improve the accuracy of the endstop. Then RESTART the printer and run a `G28` command followed by an `ENDSTOP_PHASE_CALIBRATE` command. Then move the toolhead to a new location and run `G28` again. Try moving the toolhead to several different locations and rerun `G28` from each position. Run at least five `G28` commands. This document describes Klipper's stepper phase adjusted endstop system. This functionality can improve the accuracy of traditional endstop switches. It is most useful when using a Trinamic stepper motor driver that has run-time configuration. This feature is most useful on delta printers and on the Z endstop of cartesian/corexy printers. It is possible to use this feature on the XY endstops of cartesian printers, but that isn't particularly useful as a minor error in X/Y endstop position is unlikely to impact print quality. It is not valid to use this feature on the XY endstops of corexy printers (as the XY position is not determined by a single stepper on corexy kinematics). It is not valid to use this feature on a printer using a "probe:z_virtual_endstop" Z endstop (as the stepper phase is only stable if the endstop is at a static location on a rail). To save the endstop phase for a particular stepper motor, run something like the following: [endstop_phase]
 Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:49+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/endstop_phase/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 Egy tipikus végálláskapcsoló pontossága körülbelül 100 mikron. (A tengely minden egyes indításakor a kapcsoló valamivel korábban vagy valamivel később léphet működésbe). Bár ez viszonylag kis hiba, nem kívánt nyomtatványokat eredményezhet. Különösen a tárgy első rétegének nyomtatásakor lehet észrevehető ez a pozícióeltérés. Ezzel szemben a tipikus léptetőmotorokkal lényegesen nagyobb pontosság érhető el. További megjegyzések A végállásfázis kalibrálása után, ha a végállást később elmozdítják vagy beállítják, akkor a végállást újra kell kalibrálni. Távolítsa el a kalibrálási adatokat a konfigurációs fájlból, és futtassa újra a fenti lépéseket. A fentiek elvégzése után a `ENDSTOP_PHASE_CALIBRATE` parancs gyakran ugyanazt (vagy közel ugyanazt) a fázist fogja jelenteni a léptető számára. Ezt a fázist el lehet menteni a konfigurációs fájlban, hogy a jövőben minden G28 parancs ezt a fázist használja. (Így a jövőbeni kezdőpont kérési műveletek során a Klipper ugyanazt a pozíciót fogja elérni, még akkor is, ha a végállás egy kicsit korábban vagy egy kicsit később lép működésbe.) Végállási fázisok kalibrálása ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
 Végállás szakasz Ha valaki hagyományos léptető vezérlésű Z tengelyt használ (mint egy cartesian vagy corexy nyomtatón) hagyományos ágykiegyenlítő csavarokkal együtt, akkor az is lehetséges, hogy ezt a rendszert úgy használja, hogy minden egyes nyomtatási réteget egy "teljes lépés" határon végezzen el. Ennek a funkciónak az engedélyezéséhez győződjön meg arról, hogy a G-Kód szeletelő olyan rétegmagassággal van konfigurálva, amely a "teljes lépés" többszöröse, manuálisan engedélyezze az endstop_align_zero opciót az endstop_phase config szakaszban (további részletekért lásd [config reference](Config_Reference.md#endstop_phase)), majd szintezze újra az ágy csavarjait. Ha Trinamic léptetőmotor-meghajtókat használunk futásidejű konfigurációval, akkor az ENDSTOP_PHASE_CALIBRATE paranccsal kalibrálhatjuk a végállási fázisokat. Kezdje a következők hozzáadásával a konfigurációs fájlhoz: Ahhoz, hogy ezt a funkciót használni lehessen, azonosítani kell a léptetőmotor fázisát. Ha a Trinamic TMC2130, TMC2208, TMC2224 vagy TMC2660 meghajtókat futásidejű konfigurációs módban használja (azaz nem önálló módban), akkor a Klipper le tudja kérdezni a léptetőmotor fázisát a meghajtóból. (Ez a rendszer hagyományos léptető meghajtókon is használható, ha megbízhatóan vissza lehet állítani a léptető meghajtókat - a részleteket lásd alább.) A rendszer használatához a végállásnak elég pontosnak kell lennie ahhoz, hogy a léptető pozícióját két "teljes lépésen" belül azonosítsa. Így például, ha egy léptető 16 mikrolépést használ 0,005 mm-es lépésközzel, akkor a végállásnak legalább 0,160 mm-es pontossággal kell rendelkeznie. Ha a "Endstop stepper_z incorrect phase" típusú hibaüzeneteket kapunk, akkor ez egy nem kellően pontos végállás miatt lehet. Ha az újrakalibrálás nem segít, akkor tiltsa le az endstop fázisbeállítását a konfigurációs fájlból való eltávolítással. Ez a rendszer hagyományos (nem Trinamic) léptetőmotor-meghajtókkal is használható. Ehhez azonban gondoskodni kell arról, hogy a léptetőmotor-meghajtók a mikrokontroller minden egyes resetelésekor újrainduljanak. (Ha a kettő mindig együtt van resetelve, akkor a Klipper a léptető fázisát úgy tudja meghatározni, hogy nyomon követi a léptetőnek adott parancsok teljes lépésszámát). Jelenleg ez csak akkor lehetséges megbízhatóan, ha mind a mikrokontroller, mind a léptetőmotor-meghajtók kizárólag USB-ről kapnak áramot, és az USB-ről egy Raspberry Pi-n futó hostról kapjuk az áramot. Ebben a helyzetben meg lehet adni egy MCU konfigurációt a "restart_method: rpi_usb" - ez az opció gondoskodik arról, hogy a mikrokontrollert mindig USB tápellátás-visszaállítással állítsák vissza, ami gondoskodik arról, hogy a mikrokontroller és a léptetőmotor-illesztőprogramok együtt álljanak vissza. Ha ezt a mechanizmust használjuk, akkor manuálisan kell konfigurálni a "trigger_phase" konfigurációs szakaszokat (a részleteket lásd [config reference](Config_Reference.md#endstop_phase)). Futtassa a fenti lépéseket az összes menteni kívánt léptetőre. Általában ezt a stepper_z-nél használjuk cartesian és corexy-nyomtatókhoz, illetve stepper_a, stepper_b és stepper_c-hez delta nyomtatókhoz. Végül futtassa a következőt a konfigurációs fájl frissítéséhez az adatokkal: SAVE_CONFIG
 A lépcsős fázisú végállás mechanizmus a lépcsős motorok pontosságát használhatja a végálláskapcsolók pontosságának javítására. A léptetőmotor egy sor fázison keresztül ciklikusan mozog, amíg négy "teljes lépést" nem teljesít. Tehát egy 16 mikrolépést használó léptetőmotornak 64 fázisa lenne, és pozitív irányba történő mozgáskor a fázisok között ciklikusan haladna: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, stb. Lényeges, hogy amikor a léptetőmotor egy adott pozícióban van a lineáris sínen, mindig ugyanabban a léptetőfázisban kell lennie. Így amikor egy kocsi a végálláskapcsolót aktiválja, az adott kocsit vezérlő léptetőnek mindig ugyanabban a léptetőmotor fázisban kell lennie. A Klipper'végállás fázis rendszere a végállás pontosságának javítása érdekében kombinálja a léptető fázist a végállás kioldójával. Ezután indítsa újra a nyomtatót, és futtasson egy `G28` parancsot, amelyet egy `ENDSTOP_PHASE_CALIBRATE` parancs követ. Ezután mozgassa a szerszámfejet egy új helyre, és futtassa újra a `G28` parancsot. Próbálja meg a szerszámfejet több különböző helyre mozgatni, és minden egyes pozícióból futtassa újra a `G28` parancsot. Futtasson legalább öt `G28` parancsot. Ez a dokumentum a Klipper léptetőfázis-beállított végütköző rendszerét írja le. Ez a funkció javíthatja a hagyományos végálláskapcsolók pontosságát. Ez a leghasznosabb olyan Trinamic léptetőmotor-illesztőprogram használatakor, amely futásidejű konfigurációval rendelkezik. Ez a funkció a leghasznosabb a delta nyomtatókon és a cartesian/corexy nyomtatók Z végpontján. A funkciót a cartesian nyomtatók XY végállásainál is lehet használni, de ez nem túl hasznos, mivel az X/Y végállás pozíciójának kisebb hibája valószínűleg nem befolyásolja a nyomtatás minőségét. Nem érvényes ezt a funkciót a corexy nyomtatók XY végállásainál használni (mivel az XY pozíciót nem egyetlen léptető határozza meg a corexy kinematikánál). Nem érvényes ezt a funkciót olyan nyomtatókon használni, amelyek "probe:z_virtual_endstop" Z végállást használnak (mivel a léptetőfázis csak akkor stabil, ha a végállás egy sín statikus helyén van). Egy adott léptetőmotor végállási fázisának elmentéséhez futtasson valami hasonlót, mint a következő: [endstop_phase]
 