��          �      �       H    I     a     j  \   ~  �  �     �  6   �     �  �    j   �     �  |    j   �	  �  �	  =  �  	   �     �  ]   �  !  C     e  J   w     �  �  �  �   �       �  0  �   �                             	                      
              **Warning:** When driving a laser, keep all security precautions that you can think of! Diode lasers are usually inverted. This means, that when the MCU restarts, the laser will be *fully on* for the time it takes the MCU to start up again. For good measure, it is recommended to *always* wear appropriate laser-goggles of the right wavelength if the laser is powered; and to disconnect the laser when it is not needed. Also, you should configure a safety timeout, so that when your host or MCU encounters an error, the tool will stop. Commands Current Limitations For an example configuration, see [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg). GCODE START:
    M5            ; Disable Laser
    G21           ; Set units to mm
    G90           ; Absolute positioning
    G0 Z0 F7000   ; Set Non-Cutting speed

GCODE END:
    M5            ; Disable Laser
    G91           ; relative
    G0 Z+20 F4000 ;
    G90           ; absolute

GCODE HOMING:
    M5            ; Disable Laser
    G28           ; Home all axis

TOOL ON:
    M3 $INTENSITY

TOOL OFF:
    M5            ; Disable Laser

LASER INTENSITY:
    S
 How does it work? If you use Laserweb, a working configuration would be: Laserweb Configuration There is a limitation of how frequent PWM updates may occur. While being very precise, a PWM update may only occur every 0.1 seconds, rendering it almost useless for raster engraving. However, there exists an [experimental branch](https://github.com/Cirromulus/klipper/tree/laser_tool) with its own tradeoffs. In long term, it is planned to add this functionality to main-line klipper. This document describes how to setup a PWM-controlled laser or spindle using `output_pin` and some macros. Using PWM tools With re-purposing the printhead's fan pwm output, you can control lasers or spindles. This is useful if you use switchable print heads, for example the E3D toolchanger or a DIY solution. Usually, cam-tools such as LaserWeb can be configured to use `M3-M5` commands, which stand for *spindle speed CW* (`M3 S[0-255]`), *spindle speed CCW* (`M4 S[0-255]`) and *spindle stop* (`M5`). `M3/M4 S<value>` : Set PWM duty-cycle. Values between 0 and 255. `M5` : Stop PWM output to shutdown value. Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:59+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/using_pwm_tools/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 **Figyelmeztetés:** A lézer használatakor tartson be minden biztonsági óvintézkedést, amit csak lehet! A diódalézerek általában invertáltak. Ez azt jelenti, hogy amikor az MCU újraindul, a lézer *teljesen be lesz kapcsolva* arra az időre. A biztonság kedvéért ajánlott *mindig* megfelelő hullámhosszúságú lézerszemüveget viselni, ha a lézer be van kapcsolva, és a lézert le kell kapcsolni, ha nincs rá szükség. Emellett be kell állítania egy biztonsági időkorlátot, hogy ha a gazdagép vagy az MCU hibát észlel, a szerszám leálljon. Parancsok Jelenlegi korlátozások Egy példakonfigurációért lásd [config/sample-pwm-tool.cfg](/config/sample-pwm-tool.cfg). GCODE START:
    M5            ; Lézer letiltása
    G21           ;Állítsa az egységeket mm-re
    G90           ; Abszolút pozicionálás
    G0 Z0 F7000   ;Állítsa be a nem vágási sebességet

GCODE END:
    M5            ; Lézer letiltása
    G91           ; relatív
    G0 Z+20 F4000 ;
    G90           ; abszolút

GCODE HOMING:
    M5            ; Lézer letiltása
    G28           ; Kezdőpontfelvétel minden tengelyen

TOOL ON:
    M3 $INTENSITY

TOOL OFF:
    M5            ; Lézer letiltása

LASER INTENSITY:
    S
 Hogyan működik? Ha a Laserwebet használja, akkor a következő konfiguráció működhet: Laserweb konfiguráció Korlátozott, hogy milyen gyakoriak lehetnek a PWM-frissítések. Bár nagyon pontos, a PWM frissítés csak 0,1 másodpercenként fordulhat elő, így szinte használhatatlanná válik a rasztergravírozáshoz. Létezik azonban egy [kísérleti ág](https://github.com/Cirromulus/klipper/tree/laser_tool), amelynek saját kompromisszumai vannak. Hosszú távon azt tervezik, hogy ezt a funkciót hozzáadják a fővonali klipperhez. Ez a dokumentum leírja, hogyan állíthat be egy PWM-vezérelt lézert vagy orsót az `output_pin` és néhány makró segítségével. PWM eszközök használata A nyomtatófej ventilátor PWM kimenetének felhasználásával lézereket vagy orsókat vezérelhet. Ez akkor hasznos, ha kapcsolható nyomtatófejeket használ, például az E3D szerszámváltó vagy egy barkácsmegoldás. Általában az olyan cam-tool, mint a LaserWeb, úgy konfigurálhatók, hogy `M3-M5` parancsokat használjanak, amelyek *spindle speed CW* (`M3 S[0-255]`), *orsó fordulatszám * (`M4 S[0-255]`) és *orsóstop* (`M5`). `M3/M4 S<value>` : PWM-üzemmód beállítása. Értékek 0 és 255 között. `M5` : PWM kimenet leállítása a kikapcsolási értékre. 