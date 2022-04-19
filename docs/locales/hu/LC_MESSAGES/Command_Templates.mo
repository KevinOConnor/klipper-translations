��    N      �  k   �      �     �     )     1     Q  �   p     	  U   &  p   |  �  �    �
     �     �  "   �       �     �  �  �  h  �   9  �   �  v   �  |     R   �     �     �  �   �  �   �     =  #   T     x     �     �  �   �  Y   U    �  ,  �  �   �  6   s  C   �  e   �  K  T  g   �  R    y   [  i   �  �   ?  /     2  1  	   d   R   n   `   �   �   "!  �   �!  �   �"  D   i#  ^   �#  �   $  �   �$  x   (%  M   �%    �%  �   o'  d   �'  e  \(  G   �)  �  
*  �   �+  �   �,  �   H-  �   ;.  q   �.  :   9/  n   t/  B   �/     &0  8   D0    }0  1   �1  �  �1  �   O3     �3  !   �3     	4  �   )4      �4  o   �4  �   m5  �  �5  <  �7     9     9  (   (9     Q9  �   k9  �  *:  $  <  �   *>  �   �>  r   �?  �   �?  h   �@      A     A  �   "A  �   �A     B  9   �B     �B     �B     �B  �   C  j   �C    D  �  5E  �   �F  9   UG  V   �G  c   �G  �  JH  p   �I  f  PJ  �   �K  u   PL  �   �L  /   �M  �  �M  
   sP  `   ~P  s   �P    SQ  �   XR  �   	S  D   �S  ^   	T  �   hT  �   �T  x   �U  M   �U    JV  �   �W  d   RX  e  �X  G   Z  �  eZ  
  \  �   ]    �]  �   �^  �   S_  2   �_  �   `  K   �`     �`  F   	a  h  Pa  1   �b     F                      <             K       6   &   N   B           :   $       4   2       9   3   "   '   I   /   ?   H       J              +      1   A       G       D   *   %   .      
          )                  !          >      L         #          =          7   	      C   0   ;      (             5      E       -         @                 8         ,                        M        A common way to accomplish that is to wrap the `G1` moves in `SAVE_GCODE_STATE`, `G91`, and `RESTORE_GCODE_STATE`. For example: Actions Add a description to your macro An example of a complex macro: As an example, it could be used to save the state of 2-in-1-out hotend and when starting a print ensure that the active extruder is used, instead of T0: Available "action" commands: Available fields are defined in the [Status Reference](Status_Reference.md) document. Be sure to take the timing of macro evaluation and command execution into account when using SET_GCODE_VARIABLE. By convention, the name immediately following `printer` is the name of a config section. So, for example, `printer.fan` refers to the fan object created by the `[fan]` config section. There are some exceptions to this rule - notably the `gcode_move` and `toolhead` objects. If the config section contains spaces in it, then one can access it via the `[ ]` accessor - for example: `printer["generic_heater my_chamber_heater"].temperature`. Case is not important for the G-Code macro name - MY_MACRO and my_macro will evaluate the same and may be called in either upper or lower case. If any numbers are used in the macro name then they must all be at the end of the name (eg, TEST_MACRO25 is valid, but MACRO25_TEST3 is not). Commands templates Delayed Gcodes Formatting of G-Code in the config G-Code Macro Naming If a [display config section](Config_Reference.md#display) is enabled, then it is possible to customize the menu with [menu](Config_Reference.md#menu) config sections. If a [save_variables config section](Config_Reference.md#save_variables) has been enabled, `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` can be used to save the variable to disk so that it can be used across restarts. All stored variables are loaded into the `printer.save_variables.variables` dict at startup and can be used in gcode macros. to avoid overly long lines you can add the following at the top of the macro: Important! Macros are first evaluated in entirety and only then are the resulting commands executed. If a macro issues a command that alters the state of the printer, the results of that state change will not be visible during the evaluation of the macro. This can also result in subtle behavior when a macro generates commands that call other macros, as the called macro is evaluated when it is invoked (which is after the entire evaluation of the calling macro). Indentation is important when defining a macro in the config file. To specify a multi-line G-Code sequence it is important for each line to have proper indentation. For example: It is often useful to inspect parameters passed to the macro when it is called. These parameters are available via the `params` pseudo-variable. For example, if the macro: It is possible to inspect (and alter) the current state of the printer via the `printer` pseudo-variable. For example: It's common to use the Jinja2 `set` directive to use a default parameter and assign the result to a local name. For example: Its possible for a delayed gcode to repeat by updating itself in the gcode option: Macro parameters Menu templates Note how the `gcode:` config option always starts at the beginning of the line and subsequent lines in the G-Code macro never start at the beginning. Note that the Jinja2 `set` directive can assign a local name to an object in the `printer` hierarchy. This can make macros more readable and reduce typing. For example: Save Variables to disk Save/Restore state for G-Code moves Template expansion The "printer" Variable The "rawparams" variable The SET_GCODE_VARIABLE command may be useful for saving state between macro calls. Variable names may not contain any upper case characters. For example: The [delayed_gcode] configuration option can be used to execute a delayed gcode sequence: The `G91` command places the G-Code parsing state into "relative move mode" and the `RESTORE_GCODE_STATE` command restores the state to what it was prior to entering the macro. Be sure to specify an explicit speed (via the `F` parameter) on the first `G1` command. The `initial_duration` config option can be set to execute the delayed_gcode on printer startup. The countdown begins when the printer enters the "ready" state. For example, the below delayed_gcode will execute 5 seconds after the printer is ready, initializing the display with a "Welcome!" message: The above delayed_gcode will send "// Extruder Temp: [ex0_temp]" to Octoprint every 2 seconds. This can be canceled with the following gcode: The following actions are available in menu templates: The following read-only attributes are available in menu templates: The full unparsed parameters for the running macro can be access via the `rawparams` pseudo-variable. The gcode_macro `gcode:` config section is evaluated using the Jinja2 template language. One can evaluate expressions at run-time by wrapping them in `{ }` characters or use conditional statements wrapped in `{% %}`. See the [Jinja2 documentation](http://jinja.pocoo.org/docs/2.10/templates/) for further information on the syntax. The terminal will display the description when you use the `HELP` command or the autocomplete function. There are some commands available that can alter the state of the printer. For example, `{ action_emergency_stop() }` would cause the printer to go into a shutdown state. Note that these actions are taken at the time that the macro is evaluated, which may be a significant amount of time before the generated g-code commands are executed. This document provides information on implementing G-Code command sequences in gcode_macro (and similar) config sections. This is quite useful if you want to change the behavior of certain commands like the `M117`. For example: To help identify the functionality a short description can be added. Add `description:` with a short text to describe the functionality. Default is "G-Code macro" if not specified. For example: UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
 Unfortunately, the G-Code command language can be challenging to use. The standard mechanism to move the toolhead is via the `G1` command (the `G0` command is an alias for `G1` and it can be used interchangeably with it). However, this command relies on the "G-Code parsing state" setup by `M82`, `M83`, `G90`, `G91`, `G92`, and previous `G1` commands. When creating a G-Code macro it is a good idea to always explicitly set the G-Code parsing state prior to issuing a `G1` command. (Otherwise, there is a risk the `G1` command will make an undesirable request.) Variables When `<force>` is set True then it will also stop editing. Default value is False. When `<update>` is set False then parent container items are not updated. Default value is True. When the `load_filament` macro above executes, it will display a "Load Complete!" message after the extrusion is finished. The last line of gcode enables the "clear_display" delayed_gcode, set to execute in 10 seconds. [delayed_gcode clear_display]
gcode:
  M117

[gcode_macro load_filament]
gcode:
 G91
 G1 E50
 G90
 M400
 M117 Load Complete!
 UPDATE_DELAYED_GCODE ID=clear_display DURATION=10
 [delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
 [delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
 [gcode_macro M117]
rename_existing: M117.1
gcode:
  M117.1 { rawparams }
  M118 { rawparams }
 [gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
 [gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
 [gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
 [gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
 [gcode_macro T1]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder1
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder1"'

[gcode_macro T0]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder"'

[gcode_macro START_GCODE]
gcode:
  {% set svv = printer.save_variables.variables %}
  ACTIVATE_EXTRUDER extruder={svv.currentextruder}
 [gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
 [gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
 [gcode_macro clean_nozzle]
gcode:
  {% set wipe_count = 8 %}
  SAVE_GCODE_STATE NAME=clean_nozzle_state
  G90
  G0 Z15 F300
  {% for wipe in range(wipe_count) %}
    {% for coordinate in [(275, 4),(235, 4)] %}
      G0 X{coordinate[0]} Y{coordinate[1] + 0.25 * wipe} Z9.7 F12000
    {% endfor %}
  {% endfor %}
  RESTORE_GCODE_STATE NAME=clean_nozzle_state
 [gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
 [gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # Save target temperature to bed_temp variable
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # Disable bed heater
  M140
  # Perform probe
  PROBE
  # Call finish_probe macro at completion of probe
  finish_probe

[gcode_macro finish_probe]
gcode:
  # Restore temperature
  M140 S{printer["gcode_macro start_probe"].bed_temp}
 `action_call_remote_method(method_name)`: Calls a method registered by a remote client. If the method takes parameters they should be provided via keyword arguments, ie: `action_call_remote_method("print_stuff", my_arg="hello_world")` `action_emergency_stop(msg)`: Transition the printer to a shutdown state. The `msg` parameter is optional, it may be useful to describe the reason for the shutdown. `action_raise_error(msg)`: Abort the current macro (and any calling macros) and write the given `msg` to the /tmp/printer pseudo-terminal. The first line of `msg` will be sent with a "!! " prefix and subsequent lines will have a "// " prefix. `action_respond_info(msg)`: Write the given `msg` to the /tmp/printer pseudo-terminal. Each line of `msg` will be sent with a "// " prefix. `menu.back(force, update)`: will execute menu back command, optional boolean parameters `<force>` and `<update>`. `menu.event` - name of the event that triggered the script `menu.exit(force)` - will execute menu exit command, optional boolean parameter `<force>` default value False. `menu.input` - input value, only available in input script context `menu.ns` - element namespace `menu.width` - element width (number of display columns) were invoked as `SET_PERCENT VALUE=.2` it would evaluate to `M117 Now at 20%`. Note that parameter names are always in upper-case when evaluated in the macro and are always passed as strings. If performing math then they must be explicitly converted to integers or floats. {% set svv = printer.save_variables.variables %}
 Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:44+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/command_templates/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 Ennek egyik gyakori módja, hogy a `G1` mozdulatokat `SAVE_GCODE_STATE`-be csomagoljuk, `G91`, és `RESTORE_GCODE_STATE`-ba. Például: Tevékenységek Leírás hozzáadása a makróhoz Példa egy összetett makróra: Példaként a 2 az 1-ben nyomtatófej állapotának mentésére használható, és nyomtatás indításakor győződjön meg arról, hogy az aktív fejet használja a T0 helyett: Elérhető "művelet" parancsok: A rendelkezésre álló mezők a [Referencia állapot](Status_Reference.md) dokumentumban vannak meghatározva. A SET_GCODE_VARIABLE használatakor mindenképpen vegye figyelembe a makró kiértékelésének és a parancs végrehajtásának időzítését. A konvenció szerint a `printer` után közvetlenül következő név a config szakasz neve. Így például a `printer.fan` a `[fan]` config szakasz által létrehozott ventilátor objektumra utal. Van néhány kivétel ez alól a szabály alól. Nevezetesen a `gcode_move` és a `toolhead` objektumok. Ha a config szakasz szóközöket tartalmaz, akkor a `[ ]` jellel lehet elérni. Például: `printer["generic_heater my_chamber_heater"].temperature`. A G-Kódos makronév esetében a nagy- és kisbetűs írásmód nem fontos - a MY_MACRO és a my_macro ugyanúgy kiértékelődik, és kicsi vagy nagybetűvel is meghívható. Ha a makronévben számokat használunk, akkor azoknak a név végén kell állniuk (pl. a TEST_MACRO25 érvényes, de a MACRO25_TEST3 nem). Parancssablonok Késleltetett G-Kódok A G-Kód formázása a konfigurációban G-Kód makró elnevezése Ha a [display config section](Config_Reference.md#display) engedélyezve van, akkor lehetőség van a menü testreszabására a [menu](Config_Reference.md#menu) konfigurációs szakaszokkal. Ha a [save_variables config section](Config_Reference.md#save_variables) engedélyezve van, a `SAVE_VARIABLE VARIABLE=<name> VALUE=<value>` használható a változó lemezre mentésére, hogy az újraindítások során is használható legyen. Minden tárolt változó betöltődik a `printer.save_variables.variables` dict-be indításkor, és felhasználható a G-Kód makrókban. A túl hosszú sorok elkerülése érdekében a makró elejére a következőket írhatjuk: Fontos! A makrók először teljes egészében kiértékelésre kerülnek, és csak ezután kerülnek végrehajtásra a kapott parancsok. Ha egy makró olyan parancsot ad ki, amely megváltoztatja a nyomtató állapotát, az állapotváltozás eredményei nem lesznek láthatóak a makró kiértékelése során. Ez akkor is furcsa viselkedést eredményezhet, ha egy makró más makrókat, hívó parancsokat generál, mivel a meghívott makró a meghíváskor kerül kiértékelésre (ami a hívó makró teljes kiértékelése után történik). A behúzás fontos, amikor makrót definiál a konfigurációs fájlban. Többsoros G-Kód szekvencia megadásához fontos, hogy minden sorban megfelelő behúzás legyen. Például: Gyakran hasznos a makrónak a meghívásakor átadott paraméterek vizsgálata. Ezek a paraméterek a `params` álváltozóval érhetők el. Például, ha a makró: A nyomtató aktuális állapotát a `printer` álváltozóval lehet ellenőrizni (és megváltoztatni). Például: Gyakori a Jinja2 `set` direktíva használata egy alapértelmezett paraméter használatához és az eredmény hozzárendelése egy helyi névhez. Például: Lehetséges, hogy egy késleltetett G-Kód megismétlődik a G-Kód opcióban történő frissítéssel: Makró paraméterek Menüsablonok Figyeljük meg, hogy a `gcode:` config opció mindig a sor elején kezdődik, valamint a G-Kód makró további sorai soha nem kezdődnek a sor elején. Vegyük észre, hogy a Jinja2 `set` direktíva a `printer` hierarchiában lévő objektumhoz rendelhet helyi nevet. Ez olvashatóbbá teheti a makrókat és csökkentheti a gépelést. Például: Változók mentése lemezre Állapot mentése/visszaállítása G-Kódos mozgásokhoz Sablon bővítés A "nyomtató" változó A "rawparams" változó A SET_GCODE_VARIABLE parancs hasznos lehet a makróhívások közötti állapotmentéshez. A változók nevei nem tartalmazhatnak nagybetűket. Például: A [delayed_gcode] konfigurációs opció késleltetett G-Kód szekvencia végrehajtásához használható: A `G91` parancs a G-Kód elemzési állapotot "relatív mozgatási módba" helyezi, a `RESTORE_GCODE_STATE` parancs pedig visszaállítja a makró belépése előtti állapotot. Ügyeljen arra, hogy az első `G1` parancsnál adjon meg explicit sebességet (az `F` paraméterrel). Az `initial_duration` konfigurációs beállítás beállítható úgy, hogy a nyomtató indításakor végrehajtsa a delayed_gcode parancsot. A visszaszámlálás akkor kezdődik, amikor a nyomtató a "ready" állapotba lép. Az alábbi delayed_gcode például a nyomtató elkészülte után 5 másodperccel végrehajtja a műveletet, és a kijelzőt "Üdvözlés!" üzenettel inicializálja: A fenti delayed_gcode 2 másodpercenként elküldi az "// Extruder Temp: [ex0_temp]" kódot az Octoprintnek. Ez a következő G-Kóddal törölhető: A menüsablonokban a következő műveletek érhetők el: A menüsablonokban a következő csak olvasható attribútumok állnak rendelkezésre: A futó makró teljes, be nem elemzett paraméterei a `rawparams` pszeudováltozóval érhetők el. A gcode_macro `gcode:` konfigurációs szakasz kiértékelése a Jinja2 sablonnyelv használatával történik. A kifejezéseket kiértékelhetjük futásidőben `{ }` karakterekbe csomagolva, vagy használhatunk feltételes utasításokat `{% %}` karakterekbe csomagolva. A szintaxissal kapcsolatos további információkért lásd a [Jinja2 dokumentáció](http://jinja.pocoo.org/docs/2.10/templates/). A terminál megjeleníti a leírást, ha a `HELP` parancsot vagy az automatikus kitöltés funkciót használja. A nyomtató állapotának megváltoztatására néhány parancs áll rendelkezésre. Például az `{ action_emergency_stop() }` a nyomtatót leállítási állapotba helyezi. Vegye figyelembe, hogy ezek a műveletek a makró kiértékelésének időpontjában történnek, ami jelentős idővel a generált G-Kód parancsok végrehajtása előtt történhet. Ez a dokumentum a G-Kód parancssorozatok gcode_macro (és hasonló) konfigurációs szakaszokban történő implementálásáról nyújt információt. Ez nagyon hasznos, ha meg akarod változtatni bizonyos parancsok viselkedését, mint például az `M117`. Például: A funkció azonosításának megkönnyítése érdekében rövid leírás adható hozzá. Adjunk hozzá `description:` egy rövid szöveget a funkció leírására. Ha nincs megadva, az alapértelmezett érték "G-Kód makró". Például: UPDATE_DELAYED_GCODE ID=report_temp DURATION=0
 Sajnos a G-Kód parancsnyelv használata kihívást jelenthet. A nyomtatófej mozgatásának szabványos mechanizmusa a `G1` parancson keresztül történik (a `G0` parancs a `G1` parancs álnevének tekinthető, és felcserélhető vele). Ez a parancs azonban a "G-Kód elemzési állapotára" támaszkodik: `M82`, `M83`, `G90` általi beállításra, `G91`, `G92` és a korábbi `G1` parancsok is. Egy G-Kód makró létrehozásakor célszerű mindig kifejezetten beállítani a G-Kód elemzési állapotát a `G1` parancs kiadása előtt. (Ellenkező esetben fennáll annak a veszélye, hogy a `G1` parancs nemkívánatos kérést fog végrehajtani.) Változók Ha a `<force>` értéke True, akkor a szerkesztés is leáll. Az alapértelmezett érték False. Ha az `<update>` értéke False, akkor a felsőbb tárolóelemek nem frissülnek. Az alapértelmezett érték True. Amikor a fenti `load_filament` makró végrehajtódik, az extrudálás befejezése után megjelenik egy "Load Complete!" üzenet. A G-Kód utolsó sora engedélyezi a "clear_display" delayed_gcode-ot, amely 10 másodperc múlva végrehajtásra van beállítva. [delayed_gcode clear_display]
gcode:
  M117

[gcode_macro load_filament]
gcode:
 G91
 G1 E50
 G90
 M400
 M117 Load Complete!
 UPDATE_DELAYED_GCODE ID=clear_display DURATION=10
 [delayed_gcode report_temp]
initial_duration: 2.
gcode:
  {action_respond_info("Extruder Temp: %.1f" % (printer.extruder0.temperature))}
  UPDATE_DELAYED_GCODE ID=report_temp DURATION=2
 [delayed_gcode welcome]
initial_duration: 5.
gcode:
  M117 Welcome!
 [gcode_macro M117]
rename_existing: M117.1
gcode:
  M117.1 { rawparams }
  M118 { rawparams }
 [gcode_macro MOVE_UP]
gcode:
  SAVE_GCODE_STATE NAME=my_move_up_state
  G91
  G1 Z10 F300
  RESTORE_GCODE_STATE NAME=my_move_up_state
 [gcode_macro QUERY_HTU21D]
gcode:
    {% set sensor = printer["htu21d my_sensor"] %}
    M117 Temp:{sensor.temperature} Humidity:{sensor.humidity}
 [gcode_macro SET_BED_TEMPERATURE]
gcode:
  {% set bed_temp = params.TEMPERATURE|default(40)|float %}
  M140 S{bed_temp}
 [gcode_macro SET_PERCENT]
gcode:
  M117 Now at { params.VALUE|float * 100 }%
 [gcode_macro T1]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder1
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder1"'

[gcode_macro T0]
gcode:
  ACTIVATE_EXTRUDER extruder=extruder
  SAVE_VARIABLE VARIABLE=currentextruder VALUE='"extruder"'

[gcode_macro START_GCODE]
gcode:
  {% set svv = printer.save_variables.variables %}
  ACTIVATE_EXTRUDER extruder={svv.currentextruder}
 [gcode_macro blink_led]
description: Blink my_led one time
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
 [gcode_macro blink_led]
gcode:
  SET_PIN PIN=my_led VALUE=1
  G4 P2000
  SET_PIN PIN=my_led VALUE=0
 [gcode_macro clean_nozzle]
gcode:
  {% set wipe_count = 8 %}
  SAVE_GCODE_STATE NAME=clean_nozzle_state
  G90
  G0 Z15 F300
  {% for wipe in range(wipe_count) %}
    {% for coordinate in [(275, 4),(235, 4)] %}
      G0 X{coordinate[0]} Y{coordinate[1] + 0.25 * wipe} Z9.7 F12000
    {% endfor %}
  {% endfor %}
  RESTORE_GCODE_STATE NAME=clean_nozzle_state
 [gcode_macro slow_fan]
gcode:
  M106 S{ printer.fan.speed * 0.9 * 255}
 [gcode_macro start_probe]
variable_bed_temp: 0
gcode:
  # Save target temperature to bed_temp variable
  SET_GCODE_VARIABLE MACRO=start_probe VARIABLE=bed_temp VALUE={printer.heater_bed.target}
  # Disable bed heater
  M140
  # Perform probe
  PROBE
  # Call finish_probe macro at completion of probe
  finish_probe

[gcode_macro finish_probe]
gcode:
  # Restore temperature
  M140 S{printer["gcode_macro start_probe"].bed_temp}
 `action_call_remote_method(method_name)`: Egy távoli ügyfél által regisztrált metódus hívása. Ha a metódus paramétereket fogad el, akkor azokat kulcsszavas argumentumokkal kell megadni, azaz: `action_call_remote_method("print_stuff", my_arg="hello_world")` `action_emergency_stop(msg)`: A nyomtatót leállítási állapotba helyezi. Az `msg` paraméter opcionális, hasznos lehet a leállítás okának leírása. `action_raise_error(msg)`: Megszakítja az aktuális makrót (és minden hívó makrót), és a megadott `msg` üzenetet kiírja a /tmp/printer pseudo-terminálra. Az `msg` első sora "!! " előtaggal, a további sorok pedig "// " előtaggal lesznek elküldve. `action_respond_info(msg)`: A megadott `msg` kiírása a /tmp/printer álterminálra. Az `msg` minden egyes sora "// " előtaggal lesz elküldve. `menu.back(force, update)`: végrehajtja a menü vissza parancsát, az opcionális logikai paramétereket `<force>` és `<frissítés>`. `menu.event` - a szkriptet kiváltó esemény neve `menu.exit(force)` - végrehajtja a menüből való kilépés parancsát, opcionális boolean paraméter `<force>` alapértelmezett értéke False. `menu.input` - beviteli érték, csak input script kontextusban érhető el `menu.ns` - elem névtere `menu.width` - az elem szélessége (a megjelenített oszlopok száma) `SET_PERCENT VALUE=.2` értéket adna, akkor `M117 Most 20%-os értéken`. Vegye figyelembe, hogy a paraméternevek a makróban történő kiértékeléskor mindig nagybetűsek, és mindig karakterláncként kerülnek átadásra. Ha matematikai műveletet hajtunk végre, akkor azokat explicit módon egész számokká vagy lebegőszámokká kell konvertálni. {% set svv = printer.save_variables.variables %}
 