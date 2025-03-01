# G-Codes

Ten dokument opisuje polecenia, które obsługuje Klipper. Są to polecenia, które można wpisać w zakładce terminala OctoPrint.

## Polecenia G-Code

Klipper obsługuje następujące standardowe polecenia G-Code:

- Przesunięcie (G0 lub G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`.
- Przerwij: G4 P<milliseconds>`.
- Przejdź do początku: `G28 [X] [Y] [Z]`.
- Wyłączenie silników: `M18` lub `M84`.
- Poczekaj na zakończenie bieżących ruchów: `M400`.
- Użyj bezwzględnych/ względnych odległości dla ekstruzji: `M82`, `M83`.
- Użyj współrzędnych bezwzględnych/relacyjnych: `G90`, `G91`.
- Ustawienie pozycji: `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>]`
- Ustawienie procentowego przesterowania współczynnika prędkości: `M220 S<percent>`.
- Ustawienie procentowego nadpisania współczynnika ekstruzji: `M221 S<percent>`.
- Ustawienie przyśpieszenia: `M204 S<wartość>` LUB `M204 P<wartość> T<wartość>`.
   - Uwaga: Jeżeli nie określono S, a określono P i T, to przyspieszenie jest ustawiane na minimum z P i T. Jeżeli określono tylko jedno z P lub T, to polecenie nie ma wpływu.
- Uzyskaj temperaturę ekstrudera: `M105`.
- Ustawianie temperatury ekstrudera: `M104 [T<index>] [S<temperatura>]`.
- Ustawić temperaturę ekstrudera i czekać: `M109 [T<index>] S<temperatura>`.
   - Wskazówka: M109 zawsze czeka, aż temperatura ustali się na żądanej wartości.
- Ustawienie temperatury stołu grzewczego: `M140 [S<temperatura>]`.
- Ustawić temperaturę stołu grzewczego i czekać: `M190 S<temperatura>`.
   - Uwaga: M190 zawsze czeka, aż temperatura osiągnie żądaną wartość.
- Ustawianie prędkości wentylatora: `M106 S<wartość>`.
- Wyłączenie wentylatora: `M107`.
- Wyłącznik awaryjny: `M112`.
- Uzyskaj aktualną pozycję: `M114`.
- Pobierz wersję firmware: `M115`.

Więcej szczegółów dotyczących powyższych poleceń znajduje się w [dokumentacji RepRap G-Code](http://reprap.org/wiki/G-code).

Klipper's goal is to support the G-Code commands produced by common 3rd party software (eg, OctoPrint, Printrun, Slic3r, Cura, etc.) in their standard configurations. It is not a goal to support every possible G-Code command. Instead, Klipper prefers human readable ["extended G-Code commands"](#additional-commands). Similarly, the G-Code terminal output is only intended to be human readable - see the [API Server document](API_Server.md) if controlling Klipper from external software.

Jeżeli ktoś potrzebuje mniej popularnej komendy G-Code, to może być możliwe zaimplementowanie jej za pomocą własnej sekcji [gcode_macro config](Config_Reference.md#gcode_macro). Na przykład, można użyć tego do implementacji: `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1`, itd.

## Dodatkowe polecenia

Klipper używa "rozszerzonych" poleceń G-Code do ogólnej konfiguracji i statusu. Wszystkie te rozszerzone komendy mają podobny format - rozpoczynają się od nazwy komendy, po której może następować jeden lub więcej parametrów. Na przykład: `SET_SERVO SERVO=myservo ANGLE=5.3`. W tym dokumencie polecenia i parametry są wyświetlane wielkimi literami, ale nie jest rozróżniana wielkość liter. (Tak więc "SET_SERVO" i "set_servo" uruchamiają to samo polecenie).

Przetłumaczono z www.DeepL.com/Translator (wersja darmowa)

This section is organized by Klipper module name, which generally follows the section names specified in the [printer configuration file](Config_Reference.md). Note that some modules are automatically loaded.

### ADXL345

The following commands are available when an [adxl345 config section](Config_Reference.md#adxl345) is enabled.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<config_name>] [NAME=<value>]`: Zaczyna pomiary akcelerometrem na podanych liczbach sampli na sekundę. jezeli "CHIP" nie jest podany, to wraca do domyślnych ustawień: "adxl345". Komenda dziala w w trybie rozpocznij-zatrzymaj: kiedy wykonana pierwszy raz, zaczyna pomiar, kolejna egzekucja zatrzymuje akcelerometr. wyniki pomiaru są zapisane do pliku o nazwie "/tmp/adxl345-<chip>-<name>.csv" gdzie "<chip>" to nazwa czipa akcelerometra ("my_chip_name" z "[adxl345 my_chip_name]") i "<name>" to jest opcjonalny parametr NAME. Jeżeli NAME nie jest użyty to jest używany domyślny czas w formacie "YYYYMMDD_HHMMSS". Jeżeli akcelerometr nie ma nazwy w swojej konfiguracji, to połowa tego imienia nie jest wygenerowana.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<config_name>] [RATE=<value>]`: Pyta akcelerometr o obecną wartość. Jeżeli CHIP nie jest podany to używa domyślnego: "adxl345". Jeżeli RATE nie jest podany, to domyślna wartość jest użyta. Ta komenda jest użyteczna do testowania połączenia do akcelerometra ADXL345: jedna z zwróconych wartości powinno byc przyśpieszenie swobodnego opadania. (+/- troche zakłóceń czipa).

#### Odczyt danych debugowych akcelerometru

`ACCELEROMETER_DEBUG_READ [CHIP=<config_name>] REG=<register>`: Odczytuje rejestr czipu ADXL345 o nazwie "register" (np. 44 lub 0x2C). Może się przydać przy debugowaniu.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<config_name>] REG=<register> VAL=<value>`: Wpisuje Surową "value" w rejestr "register".  "value" i "register" może być w systemie dziesiętnym albo szesnastkowym. Uzywać ostrożnie, i odnoś sie do ADXL345 Arkuszu danych jako referencja.

### kąt

The following commands are available when an [angle config section](Config_Reference.md#angle) is enabled.

#### Kalibracja kąta

`ANGLE_CALIBRATE CHIP=<chip_name>`: Wykonaj kalibrację kąta na podanym czujniku (musi istnieć sekcja konfiguracji `[angle chip_name]`, która określa parametr `stepper`). WAŻNE - to narzędzie wyda polecenie silnikowi krokowemu, aby się przesunął, bez sprawdzania normalnych granic granicznych kinematyki. W idealnym przypadku silnik powinien być odłączony od karetki drukarki przed wykonaniem kalibracji. Jeśli silnika krokowego nie można odłączyć od drukarki, upewnij się, że karetka znajduje się blisko środka swojej szyny przed rozpoczęciem kalibracji. (Silnik krokowy może przesunąć się do przodu lub do tyłu o dwa pełne obroty podczas tego testu.) Po zakończeniu tego testu użyj polecenia `SAVE_CONFIG`, aby zapisać dane kalibracji w pliku konfiguracyjnym. Aby użyć tego narzędzia, musi być zainstalowany pakiet Pythona „numpy” (więcej informacji można znaleźć w [dokumencie pomiaru rezonansu](Measuring_Resonances.md#software-installation)).

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: Perform internal sensor calibration, if implemented (MT6826S/MT6835).

- **MT68XX**: The motor should be disconnected from any printer carriage before performing calibration. After calibration, the sensor should be reset by disconnecting the power.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<config_name> REG=<register>`: Zapytania do rejestru czujnika „register” (np. 44 lub 0x2C). Może być przydatne do celów debugowania. Jest to dostępne tylko dla układów tle5012b.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<config_name> REG=<register> VAL=<value>`: Zapisuje surową „value” do rejestru „register”. Zarówno „value”, jak i „register” mogą być liczbami całkowitymi dziesiętnymi lub szesnastkowymi. Używaj ostrożnie i zapoznaj się z kartą danych czujnika, aby uzyskać odniesienie. Jest to dostępne tylko dla układów tle5012b.

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [AUTO=<True|False>] [SAMPLE_COUNT=<value>]`

Calibrates axis twist compensation by specifying the target axis or enabling automatic calibration.

- **AXIS:** Define the axis (`X` or `Y`) for which the twist compensation will be calibrated. If not specified, the axis defaults to `'X'`.
- **AUTO:** Enables automatic calibration mode. When `AUTO=True`, the calibration will run for both the X and Y axes. In this mode, `AXIS` cannot be specified. If both `AXIS` and `AUTO` are provided, an error will be raised.

### [bed_mesh]

The following commands are available when the [bed_mesh config section](Config_Reference.md#bed_mesh) is enabled (also see the [bed mesh guide](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file. If ADAPTIVE=1 is specified then the objects defined by the Gcode file being printed will be used to define the probed area. The optional `ADAPTIVE_MARGIN` value overrides the `adaptive_margin` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]`: To polecenie wysyła do terminala aktualne sondowane wartości z i aktualne wartości siatki.  Jeśli określono PGP=1, współrzędne X, Y wygenerowane przez bed_mesh wraz z powiązanymi z nimi indeksami zostaną wysłane do terminala.

#### Łóżko_Siatka_Mapa

`Łóżko_Siatka_Mapa`: Podobnie jak Łóżko_Siatka_Wyjście, to polecenie wypisuje bieżący stan siatki na terminalu.  Zamiast drukować wartości w formacie czytelnym dla człowieka, stan jest serializowany w formacie json.  Umożliwia to wtyczkom Octoprint łatwe przechwytywanie danych i generowanie map wysokości zbliżonych do powierzchni łóżka.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: This command clears the mesh and removes all z adjustment. It is recommended to put this in your end-gcode.

#### Łóżko_Siatkowy_Profil

`BED_MESH_PROFILE LOAD=<nazwa> SAVE=<nazwa> REMOVE=<nazwa>`: To polecenie umożliwia zarządzanie profilami dla stanu siatki.  Load przywróci stan siatki z profilu odpowiadającego podanej nazwie.  SAVE zapisze bieżący stan siatki w profilu pasującym do podanej nazwy.  Usuń usunie profil pasujący do podanej nazwy z pamięci trwałej.  Należy pamiętać, że po wykonaniu operacji SAVE lub REMOVE należy uruchomić gcode SAVE_CONFIG, aby zmiany w pamięci trwałej były trwałe.

#### Łóżko_Siatka_Przesunięcie

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value]`: Applies X, Y, and/or ZFADE offsets to the mesh lookup. This is useful for printers with independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Note that a ZFADE offset does not apply additional z-adjustment directly, it is used to correct the `fade` calculation when a `gcode offset` has been applied to the Z axis.

### [łóżkowe_śruby]

The following commands are available when the [bed_screws config section](Config_Reference.md#bed_screws) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws)).

#### Łóżko_Śruby_Dostosowanie

`BED_SCREWS_ADJUST`: To polecenie wywoła narzędzie do regulacji śrub łóżka.  Poleci dyszę do różnych lokalizacji (zgodnie z definicją w pliku konfiguracyjnym) i umożliwi dokonanie regulacji śrub łoża, tak aby łóżko znajdowało się w stałej odległości od dyszy.

### [Łóżko_tytuł]

The following commands are available when the [bed_tilt config section](Config_Reference.md#bed_tilt) is enabled.

#### Łóżko_Pochylenie_Kalibracja

`BED_TILT_CALIBRATE [METODA=ręczny] [HORIZONTAL_MOVE_Z=<wartość>] [<parametr_sondy>=<wartość>]`: To polecenie sprawdzi punkty określone w konfiguracji, a następnie zaleci zaktualizowane regulacje pochylenia x i y.  Szczegółowe informacje na temat opcjonalnych parametrów sondy można znaleźć w poleceniu PROBE.  Jeśli określono METODĘ=manual, aktywowane jest ręczne narzędzie sondujące - zobacz powyższe polecenie MANUAL_PROBE, aby uzyskać szczegółowe informacje na temat dodatkowych poleceń dostępnych, gdy to narzędzie jest aktywne.  Opcjonalna wartość `HORIZONTAL_MOVE_Z` zastępuje opcję `horizontal_move_z` określoną w pliku konfiguracyjnym.

### [dotyk]

The following command is available when a [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [BL-Touch guide](BLTouch.md)).

#### BLTOUCH_DEBUGOWANIE

`BLTOUCH_DEBUG COMMAND=<polecenie>`: Wysyła polecenie do BLTouch.  Może się przydać do debugowania.  Dostępne polecenia to: `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`.  BL-Touch V3.0 lub V3.1 może także obsługiwać polecenia `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`.

#### BLTOUCH_SKLEP

`BLTOUCH_STORE MODE=<output_mode>`: Zapisuje tryb wyjściowy w EEPROM BLTouch V3.1. Dostępne tryby wyjściowe to: `5V`, `OD`

### [plik konfiguracyjny]

The configfile module is automatically loaded.

#### SAVE_CONFIG

`SAVE_CONFIG`: This command will overwrite the main printer config file and restart the host software. This command is used in conjunction with other calibration commands to store the results of calibration tests.

### [opóźniony_gkod]

The following command is enabled if a [delayed_gcode config section](Config_Reference.md#delayed_gcode) has been enabled (also see the [template guide](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<name>] [DURATION=<seconds>]`: Updates the delay duration for the identified [delayed_gcode] and starts the timer for gcode execution. A value of 0 will cancel a pending delayed gcode from executing.

### [delta_kalibracja]

The following commands are available when the [delta_calibrate config section](Config_Reference.md#linear-delta-kinematics) is enabled (also see the [delta calibrate guide](Delta_Calibrate.md)).

#### DELTA_KALIBRACJA

`DELTA_CALIBRATE [METODA=ręczny] [HORIZONTAL_MOVE_Z=<wartość>] [<parametr_sondy>=<wartość>]`: To polecenie sprawdzi siedem punktów na łóżku i zaleci zaktualizowane pozycje końcówek, kąty wieży i promień.  Szczegółowe informacje na temat opcjonalnych parametrów sondy można znaleźć w poleceniu PROBE.  Jeśli określono METODĘ=manual, aktywowane jest ręczne narzędzie sondujące - zobacz powyższe polecenie MANUAL_PROBE, aby uzyskać szczegółowe informacje na temat dodatkowych poleceń dostępnych, gdy to narzędzie jest aktywne.  Opcjonalna wartość `HORIZONTAL_MOVE_Z` zastępuje opcję `horizontal_move_z` określoną w pliku konfiguracyjnym.

#### DELTA_ANALIZA

`DELTA_ANALYZE`: To polecenie jest używane podczas rozszerzonej kalibracji delta.  Aby uzyskać szczegółowe informacje, zobacz [Delta Calibrate](Delta_Calibrate.md).

### [display]

The following command is available when a [display config section](Config_Reference.md#gcode_macro) is enabled.

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group>`: Set the active display group of an lcd display. This allows to define multiple display data groups in the config, e.g. `[display_data <group> <elementname>]` and switch between them using this extended gcode command. If DISPLAY is not specified it defaults to "display" (the primary display).

### [display_status]

The display_status module is automatically loaded if a [display config section](Config_Reference.md#display) is enabled. It provides the following standard G-Code commands:

- Wyświetlenie komunikatu: `M117 <message>`.
- Ustaw procent kompilacji: `M73 P<percent>`

Dostępna jest również rozszerzona komenda G-Code:

- `SET_DISPLAY_TEXT MSG=<message>`: Performs the equivalent of M117, setting the supplied `MSG` as the current display message. If `MSG` is omitted the display will be cleared.

### [dual_carriage]

The following command is available when the [dual_carriage config section](Config_Reference.md#dual_carriage) is enabled.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=[0|1] [MODE=[PRIMARY|COPY|MIRROR]]`: This command will change the mode of the specified carriage. If no `MODE` is provided it defaults to `PRIMARY`. Setting the mode to `PRIMARY` deactivates the other carriage and makes the specified carriage execute subsequent G-Code commands as-is. `COPY` and `MIRROR` modes are supported only for `CARRIAGE=1`. When set to either of these modes, carriage 1 will then track the subsequent moves of the carriage 0 and either copy relative movements of it (in `COPY` mode) or execute them in the opposite (mirror) direction (in `MIRROR` mode).

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Save the current positions of the dual carriages and their modes. Saving and restoring DUAL_CARRIAGE state can be useful in scripts and macros, as well as in homing routine overrides. If NAME is provided it allows one to name the saved state to the given string. If NAME is not provided it defaults to "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Restore the previously saved positions of the dual carriages and their modes, unless "MOVE=0" is specified, in which case only the saved modes will be restored, but not the positions of the carriages. If positions are being restored and "MOVE_SPEED" is specified, then the toolhead moves will be performed with the given speed (in mm/s); otherwise the toolhead move will use the rail homing speed. Note that the carriages restore their positions only over their own axis, which may be necessary to correctly restore COPY and MIRROR mode of the dual carraige.

### [endstop_phase]

The following commands are available when an [endstop_phase config section](Config_Reference.md#endstop_phase) is enabled (also see the [endstop phase guide](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]`: If no STEPPER parameter is provided then this command will reports statistics on endstop stepper phases during past homing operations. When a STEPPER parameter is provided it arranges for the given endstop phase setting to be written to the config file (in conjunction with the SAVE_CONFIG command).

### [exclude_object]

The following commands are available when an [exclude_object config section](Config_Reference.md#exclude_object) is enabled (also see the [exclude object guide](Exclude_Object.md)):

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=object_name] [CURRENT=1] [RESET=1]`: With no parameters, this will return a list of all currently excluded objects.

When the `NAME` parameter is given, the named object will be excluded from printing.

When the `CURRENT` parameter is given, the current object will be excluded from printing.

When the `RESET` parameter is given, the list of excluded objects will be cleared. Additionally including `NAME` will only reset the named object. This **can** cause print failures, if layers were already skipped.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=object_name [CENTER=X,Y] [POLYGON=[[x,y],...]] [RESET=1] [JSON=1]`: Provides a summary of an object in the file.

With no parameters provided, this will list the defined objects known to Klipper. Returns a list of strings, unless the `JSON` parameter is given, when it will return object details in json format.

When the `NAME` parameter is included, this defines an object to be excluded.

- `NAME`: This parameter is required. It is the identifier used by other commands in this module.
- `CENTRUM`: Współrzędne X, Y obiektu.
- `POLYGON`: An array of X,Y coordinates that provide an outline for the object.

When the `RESET` parameter is provided, all defined objects will be cleared, and the `[exclude_object]` module will be reset.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=object_name`: This command takes a `NAME` parameter and denotes the start of the gcode for an object on the current layer.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=object_name]`: Denotes the end of the object's gcode for the layer. It is paired with `EXCLUDE_OBJECT_START`. A `NAME` parameter is optional, and will only warn when the provided name does not match the current object.

### [extruder]

The following commands are available if an [extruder config section](Config_Reference.md#extruder) is enabled:

#### ACTIVATE_EXTRUDER

`ACTIVATE _ EXTRUDER EXTRUDER =<config_name>`: W drukarce z wieloma sekcjami konfiguracyjnymi [extruder] (Config _ Reference.md # extruder) to polecenie zmienia aktywny hotend.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<config_name>] [ADVANCE=<pressure_advance>] [SMOOTH_TIME=<pressure_advance_smooth_time>]`: Set pressure advance parameters of an extruder stepper (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section). If EXTRUDER is not specified, it defaults to the stepper defined in the active hotend.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<config_name> [DISTANCE=<distance>]`: Set a new value for the provided extruder stepper's "rotation distance" (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section). If the rotation distance is a negative number then the stepper motion will be inverted (relative to the stepper direction specified in the config file). Changed settings are not retained on Klipper reset. Use with caution as small changes can result in excessive pressure between extruder and hotend. Do proper calibration with filament before use. If 'DISTANCE' value is not provided then this command will return the current rotation distance.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<name> MOTION_QUEUE=<name>`: This command will cause the stepper specified by EXTRUDER (as defined in an [extruder](Config_Reference.md#extruder) or [extruder_stepper](Config_Reference.md#extruder_stepper) config section) to become synchronized to the movement of an extruder specified by MOTION_QUEUE (as defined in an [extruder](Config_Reference.md#extruder) config section). If MOTION_QUEUE is an empty string then the stepper will be desynchronized from all extruder movement.

### [fan_generic]

The following command is available when a [fan_generic config section](Config_Reference.md#fan_generic) is enabled.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=config_name SPEED=<speed>` This command sets the speed of a fan. "speed" must be between 0.0 and 1.0.

`SET_FAN_SPEED PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given fan. For example, if one defined a `[display_template my_fan_template]` config section then one could assign `TEMPLATE=my_fan_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the fan will be automatically set to the resulting speed. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_FAN_SPEED` commands to manage the values directly).

### [filament_switch_sensor]

The following command is available when a [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) or [filament_motion_sensor](Config_Reference.md#filament_motion_sensor) config section is enabled.

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<sensor_name>`: Queries the current status of the filament sensor. The data displayed on the terminal will depend on the sensor type defined in the configuration.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<sensor_name> ENABLE=[0|1]`: Sets the filament sensor on/off. If ENABLE is set to 0, the filament sensor will be disabled, if set to 1 it is enabled.

### [firmware_retraction]

The following standard G-Code commands are available when the [firmware_retraction config section](Config_Reference.md#firmware_retraction) is enabled. These commands allow you to utilize the firmware retraction feature available in many slicers, to reduce stringing during non-extrusion moves from one part of the print to another. Appropriately configuring pressure advance reduces the length of retraction required.

- `G10`: Retracts the extruder using the currently configured parameters.
- `G11`: Unretracts the extruder using the currently configured parameters.

The following additional commands are also available.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>]`: Adjust the parameters used by firmware retraction. RETRACT_LENGTH determines the length of filament to retract and unretract. The speed of retraction is adjusted via RETRACT_SPEED, and is typically set relatively high. The speed of unretraction is adjusted via UNRETRACT_SPEED, and is not particularly critical, although often lower than RETRACT_SPEED. In some cases it is useful to add a small amount of additional length on unretraction, and this is set via UNRETRACT_EXTRA_LENGTH. SET_RETRACTION is commonly set as part of slicer per-filament configuration, as different filaments require different parameter settings.

#### GET_RETRACTION

`GET_RETRACTION`: Queries the current parameters used by firmware retraction and displays them on the terminal.

### [force_move]

The force_move module is automatically loaded, however some commands require setting `enable_force_move` in the [printer config](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<config_name>`: Move the given stepper forward one mm and then backward one mm, repeated 10 times. This is a diagnostic tool to help verify stepper connectivity.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<config_name> DISTANCE=<value> VELOCITY=<value> [ACCEL=<value>]`: This command will forcibly move the given stepper the given distance (in mm) at the given constant velocity (in mm/s). If ACCEL is specified and is greater than zero, then the given acceleration (in mm/s^2) will be used; otherwise no acceleration is performed. No boundary checks are performed; no kinematic updates are made; other parallel steppers on an axis will not be moved. Use caution as an incorrect command could cause damage! Using this command will almost certainly place the low-level kinematics in an incorrect state; issue a G28 afterwards to reset the kinematics. This command is intended for low-level diagnostics and debugging.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [CLEAR=<[X][Y][Z]>]`: Force the low-level kinematic code to believe the toolhead is at the given cartesian position. This is a diagnostic and debugging command; use SET_GCODE_OFFSET and/or G92 for regular axis transformations. If an axis is not specified then it will default to the position that the head was last commanded to. Setting an incorrect or invalid position may lead to internal software errors. Use the CLEAR parameter to forget the homing state for the given axes. Note that CLEAR will not override the previous functionality; if an axis is not specified to CLEAR it will have its kinematic position set as per above. This command may invalidate future boundary checks; issue a G28 afterwards to reset the kinematics.

### [gcode]

The gcode module is automatically loaded.

#### RESTART

`RESTART`: This will cause the host software to reload its config and perform an internal reset. This command will not clear error state from the micro-controller (see FIRMWARE_RESTART) nor will it load new software (see [the FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART`: This is similar to a RESTART command, but it also clears any error state from the micro-controller.

#### STATUS

`STATUS`: Report the Klipper host software status.

#### HELP

`HELP`: Report the list of available extended G-Code commands.

### [gcode_arcs]

Następujące standardowe polecenia G-Code są dostępne, jeśli włączona jest sekcja konfiguracyjna [gcode_arcs](Config_Reference.md#gcode_arcs):

- Ruch łuku zgodnie z ruchem wskazówek zegara (G2), ruch łuku przeciwnie do ruchu wskazówek zegara (G3): `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- Arc Plane Select: G17 (XY plane), G18 (XZ plane), G19 (YZ plane)

### [gcode_macro]

The following command is available when a [gcode_macro config section](Config_Reference.md#gcode_macro) is enabled (also see the [command templates guide](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value>`: This command allows one to change the value of a gcode_macro variable at run-time. The provided VALUE is parsed as a Python literal.

### [gcode_move]

The gcode_move module is automatically loaded.

#### GET_POSITION

`GET_POSITION`: Return information on the current location of the toolhead. See the developer documentation of [GET_POSITION output](Code_Overview.md#coordinate-systems) for more information.

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Ustawienie przesunięcia pozycji, aby zastosować je do przyszłych poleceń G-Code. Jest to powszechnie używane do wirtualnej zmiany przesunięcia stołu Z lub do ustawienia przesunięcia dysz XY przy przełączaniu ekstruderów. Na przykład, jeśli "SET_GCODE_OFFSET Z=0.2" jest wysłane, to przyszłe ruchy G-Code będą miały 0.2mm dodane do ich wysokości Z. Jeśli użyto parametrów stylu X_ADJUST, to korekta zostanie dodana do istniejącego przesunięcia (np. "SET_GCODE_OFFSET Z=-0.2", a następnie "SET_GCODE_OFFSET Z_ADJUST=0.3" spowoduje całkowite przesunięcie Z o 0.1). Jeśli podano "MOVE=1", to zostanie wydany ruch głowicy narzędziowej, aby zastosować podane przesunięcie (w przeciwnym razie przesunięcie zacznie obowiązywać przy następnym absolutnym ruchu G-Code, który określa daną oś). Jeżeli jest podane "MOVE_SPEED", to zostanie wykonany ruch głowicy narzędziowej z podaną prędkością (w mm/s); w przeciwnym razie zostanie zastosowana ostatnio podana prędkość G-Code.

Przetłumaczono z www.DeepL.com/Translator (wersja darmowa)

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<state_name>]`: Zapisuje bieżący stan parsowania współrzędnych g-code. Zapisywanie i przywracanie stanu g-code jest przydatne w skryptach i makrach. Ta komenda zapisuje bieżący tryb współrzędnych bezwzględnych g-code (G90/G91), tryb ekstrudowania bezwzględnego (M82/M83), początek (G92), przesunięcie (SET_GCODE_OFFSET), nadpisanie prędkości (M220), nadpisanie ekstrudera (M221), prędkość ruchu, bieżącą pozycję XYZ i względną pozycję "E" ekstrudera. Jeśli podano NAME, pozwala to na nazwanie zapisanego stanu na podany ciąg znaków. Jeśli NAME nie jest podane, to domyślnie ustawia się na "default" (domyślnie)

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<state_name>] [MOVE=1 [MOVE_SPEED=<speed>]]`: Przywraca stan zapisany wcześniej poprzez SAVE_GCODE_STATE. Jeśli podano "MOVE=1", to zostanie wydany ruch głowicy narzędziowej, aby cofnąć się do poprzedniej pozycji XYZ. Jeżeli podano "MOVE_SPEED", to ruch głowicy narzędziowej zostanie wykonany z podaną prędkością (w mm/s); w przeciwnym razie ruch głowicy narzędziowej będzie wykorzystywać przywróconą prędkość g-kodu.

### [hall_filament_width_sensor]

The following commands are available when the [tsl1401cl filament width sensor config section](Config_Reference.md#tsl1401cl_filament_width_sensor) or [hall filament width sensor config section](Config_Reference.md#hall_filament_width_sensor) is enabled (also see [TSLl401CL Filament Width Sensor](TSL1401CL_Filament_Width_Sensor.md) and [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)):

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH`: Return the current measured filament width.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR`: Clear all sensor readings. Helpful after filament change.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR`: Turn off the filament width sensor and stop using it for flow control.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR`: Turn on the filament width sensor and start using it for flow control.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH`: Return the current ADC channel readings and RAW sensor value for calibration points.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG`: Turn on diameter logging.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG`: Turn off diameter logging.

### [heaters]

The heaters module is automatically loaded if a heater is defined in the config file.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS`: Wyłącz wszystkie grzałki.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<config_name> [MINIMUM=<target>] [MAXIMUM=<target>]`: Wait until the given temperature sensor is at or above the supplied MINIMUM and/or at or below the supplied MAXIMUM.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<heater_name> [TARGET=<target_temperature>]`: Sets the target temperature for a heater. If a target temperature is not supplied, the target is 0.

### [idle_timeout]

The idle_timeout module is automatically loaded.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]`: Allows the user to set the idle timeout (in seconds).

### [input_shaper]

The following command is enabled if an [input_shaper config section](Config_Reference.md#input_shaper) has been enabled (also see the [resonance compensation guide](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>]`: Modify input shaper parameters. Note that SHAPER_TYPE parameter resets input shaper for both X and Y axes even if different shaper types have been configured in [input_shaper] section. SHAPER_TYPE cannot be used together with either of SHAPER_TYPE_X and SHAPER_TYPE_Y parameters. See [config reference](Config_Reference.md#input_shaper) for more details on each of these parameters.

### [manual_probe]

The manual_probe module is automatically loaded.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Run a helper script useful for measuring the height of the nozzle at a given location. If SPEED is specified, it sets the speed of TESTZ commands (the default is 5mm/s). During a manual probe, the following additional commands are available:

- `ACCEPT`: Ta komenda akceptuje bieżącą pozycję Z i zakańcza działanie narzędzia do ręcznego sondowania.
- `ABORT`: Ta komenda terminuje protokół sondowania ręcznego.
- `TESTZ Z=<value>`: This command moves the nozzle up or down by the amount specified in "value". For example, `TESTZ Z=-.1` would move the nozzle down .1mm while `TESTZ Z=.1` would move the nozzle up .1mm. The value may also be `+`, `-`, `++`, or `--` to move the nozzle up or down an amount relative to previous attempts.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<speed>]`: Run a helper script useful for calibrating a Z position_endstop config setting. See the MANUAL_PROBE command for details on the parameters and the additional commands available while the tool is active.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP`: Take the current Z Gcode offset (aka, babystepping), and subtract it from the stepper_z endstop_position. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.

### [manual_stepper]

The following command is available when a [manual_stepper config section](Config_Reference.md#manual_stepper) is enabled.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=config_name [ENABLE=[0|1]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]]`: This command will alter the state of the stepper. Use the ENABLE parameter to enable/disable the stepper. Use the SET_POSITION parameter to force the stepper to think it is at the given position. Use the MOVE parameter to request a movement to the given position. If SPEED and/or ACCEL is specified then the given values will be used instead of the defaults specified in the config file. If an ACCEL of zero is specified then no acceleration will be performed. If STOP_ON_ENDSTOP=1 is specified then the move will end early should the endstop report as triggered (use STOP_ON_ENDSTOP=2 to complete the move without error even if the endstop does not trigger, use -1 or -2 to stop when the endstop reports not triggered). Normally future G-Code commands will be scheduled to run after the stepper move completes, however if a manual stepper move uses SYNC=0 then future G-Code movement commands may run in parallel with the stepper movement.

### [mcp4018]

The following command is available when a [mcp4018 config section](Config_Reference.md#mcp4018) is enabled.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<value>`: This command will change the current value of the digipot. This value should typically be between 0.0 and 1.0, unless a 'scale' is defined in the config. When 'scale' is defined, then this value should be between 0.0 and 'scale'.

### [led]

The following command is available when any of the [led config sections](Config_Reference.md#leds) are enabled.

#### SET_LED

`SET_LED LED=<config_name> RED=<value> GREEN=<value> BLUE=<value> WHITE=<value> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]`: This sets the LED output. Each color `<value>` must be between 0.0 and 1.0. The WHITE option is only valid on RGBW LEDs. If the LED supports multiple chips in a daisy-chain then one may specify INDEX to alter the color of just the given chip (1 for the first chip, 2 for the second, etc.). If INDEX is not provided then all LEDs in the daisy-chain will be set to the provided color. If TRANSMIT=0 is specified then the color change will only be made on the next SET_LED command that does not specify TRANSMIT=0; this may be useful in combination with the INDEX parameter to batch multiple updates in a daisy-chain. By default, the SET_LED command will sync it's changes with other ongoing gcode commands. This can lead to undesirable behavior if LEDs are being set while the printer is not printing as it will reset the idle timeout. If careful timing is not needed, the optional SYNC=0 parameter can be specified to apply the changes without resetting the idle timeout.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<led_name> TEMPLATE=<template_name> [<param_x>=<literal>] [INDEX=<index>]`: Assign a [display_template](Config_Reference.md#display_template) to a given [LED](Config_Reference.md#leds). For example, if one defined a `[display_template my_led_template]` config section then one could assign `TEMPLATE=my_led_template` here. The display_template should produce a comma separated string containing four floating point numbers corresponding to red, green, blue, and white color settings. The template will be continuously evaluated and the LED will be automatically set to the resulting colors. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If INDEX is not specified then all chips in the LED's daisy-chain will be set to the template, otherwise only the chip with the given index will be updated. If TEMPLATE is an empty string then this command will clear any previous template assigned to the LED (one can then use `SET_LED` commands to manage the LED's color settings).

### [output_pin]

The following command is available when an [output_pin config section](Config_Reference.md#output_pin) is enabled.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: Set the pin to the given output `VALUE`. VALUE should be 0 or 1 for "digital" output pins. For PWM pins, set to a value between 0.0 and 1.0, or between 0.0 and `scale` if a scale is configured in the output_pin config section.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given pin. For example, if one defined a `[display_template my_pin_template]` config section then one could assign `TEMPLATE=my_pin_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the pin will be automatically set to the resulting value. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_PIN` commands to manage the values directly).

### [palette2]

The following commands are available when the [palette2 config section](Config_Reference.md#palette2) is enabled.

Palette prints work by embedding special OCodes (Omega Codes) in the GCode file:

- `O1`...`O32`: These codes are read from the GCode stream and processed by this module and passed to the Palette 2 device.

The following additional commands are also available.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: This command initializes the connection with the Palette 2.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: This command disconnects from the Palette 2.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: This command instructs the Palette 2 to clear all of the input and output paths of filament.

#### PALETTE_CUT

`PALETTE_CUT`: This command instructs the Palette 2 to cut the filament currently loaded in the splice core.

#### PALETTE_SMART_LOAD

`PALETTE_SMART_LOAD`: This command start the smart load sequence on the Palette 2. Filament is loaded automatically by extruding it the distance calibrated on the device for the printer, and instructs the Palette 2 once the loading has been completed. This command is the same as pressing **Smart Load** directly on the Palette 2 screen after the filament load is complete.

### [pid_calibrate]

The pid_calibrate module is automatically loaded if a heater is defined in the config file.

#### PID_CALIBRATE

`PID_CALIBRATE HEATER=<config_name> TARGET=<temperatura> [WRITE_FILE=1]`: Wykonuje test kalibracji PID. Określona grzałka zostanie włączona do momentu osiągnięcia określonej temperatury docelowej, a następnie zostanie wyłączona i włączona na kilka cykli. Jeśli parametr WRITE_FILE jest włączony, to zostanie utworzony plik /tmp/heattest.txt z zapisem wszystkich próbek temperatury pobranych podczas testu.

### [pause_resume]

The following commands are available when the [pause_resume config section](Config_Reference.md#pause_resume) is enabled:

#### PAUSE

`PAUSE`: Pauses the current print. The current position is captured for restoration upon resume.

#### RESUME

`RESUME [VELOCITY=<value>]`: Resumes the print from a pause, first restoring the previously captured position. The VELOCITY parameter determines the speed at which the tool should return to the original captured position.

#### WYCZYŚĆ_PAUZ

`CLEAR_PAUSE`: Czyści bieżący stan wstrzymania bez wznawiania drukowania.  Jest to przydatne, jeśli zdecydujesz się anulować drukowanie po PAUZIE.  Zaleca się dodanie tego do początkowego gcode, aby upewnić się, że stan wstrzymania jest świeży dla każdego wydruku.

#### ANULOWANIE_DRUKU

`ANULOWAĆ_WYDRUKOWAĆ`: Anuluje bieżący wydruk.

### [print_stats]

The print_stats module is automatically loaded.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>] [CURRENT_LAYER= <current_layer>]`: Pass slicer info like layer act and total to Klipper. Add `SET_PRINT_STATS_INFO [TOTAL_LAYER=<total_layer_count>]` to your slicer start gcode section and `SET_PRINT_STATS_INFO [CURRENT_LAYER= <current_layer>]` at the layer change gcode section to pass layer information from your slicer to Klipper.

### [probe]

The following commands are available when a [probe config section](Config_Reference.md#probe) or [bltouch config section](Config_Reference.md#bltouch) is enabled (also see the [probe calibrate guide](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]`: Move the nozzle downwards until the probe triggers. If any of the optional parameters are provided they override their equivalent setting in the [probe config section](Config_Reference.md#probe).

#### QUERY_PROBE

`QUERY_PROBE`: Report the current status of the probe ("triggered" or "open").

#### PROBE_ACCURACY

`PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]`: Calculate the maximum, minimum, average, median, and standard deviation of multiple probe samples. By default, 10 SAMPLES are taken. Otherwise the optional parameters default to their equivalent setting in the probe config section.

#### PROBE_CALIBRATE

`PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]`: Run a helper script useful for calibrating the probe's z_offset. See the PROBE command for details on the optional probe parameters. See the MANUAL_PROBE command for details on the SPEED parameter and the additional commands available while the tool is active. Please note, the PROBE_CALIBRATE command uses the speed variable to move in XY direction as well as Z.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE`: Take the current Z Gcode offset (aka, babystepping), and subtract if from the probe's z_offset. This acts to take a frequently used babystepping value, and "make it permanent". Requires a `SAVE_CONFIG` to take effect.

### [probe_eddy_current]

The following commands are available when a [probe_eddy_current config section](Config_Reference.md#probe_eddy_current) is enabled.

#### PROBE_EDDY_CURRENT_CALIBRATE

`PROBE_EDDY_CURRENT_CALIBRATE CHIP=<config_name>`: This starts a tool that calibrates the sensor resonance frequencies to corresponding Z heights. The tool will take a couple of minutes to complete. After completion, use the SAVE_CONFIG command to store the results in the printer.cfg file.

#### LDC_CALIBRATE_DRIVE_CURRENT

`LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` This tool will calibrate the ldc1612 DRIVE_CURRENT0 register. Prior to using this tool, move the sensor so that it is near the center of the bed and about 20mm above the bed surface. Run this command to determine an appropriate DRIVE_CURRENT for the sensor. After running this command use the SAVE_CONFIG command to store that new setting in the printer.cfg config file.

### [pwm_cycle_time]

The following command is available when a [pwm_cycle_time config section](Config_Reference.md#pwm_cycle_time) is enabled.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value> [CYCLE_TIME=<cycle_time>]`: This command works similarly to [output_pin](#output_pin) SET_PIN commands. The command here supports setting an explicit cycle time using the CYCLE_TIME parameter (specified in seconds). Note that the CYCLE_TIME parameter is not stored between SET_PIN commands (any SET_PIN command without an explicit CYCLE_TIME parameter will use the `cycle_time` specified in the pwm_cycle_time config section).

### [quad_gantry_level]

The following commands are available when the [quad_gantry_level config section](Config_Reference.md#quad_gantry_level) is enabled.

#### QUAD_GANTRY_LEVEL

`QUAD_GANTRY_LEVEL [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.

### [query_adc]

The query_adc module is automatically loaded.

#### QUERY_ADC

`QUERY_ADC [NAME=<config_name>] [PULLUP=<value>]`: Raportuje ostatnią wartość analogową otrzymaną dla skonfigurowanego pinu analogowego. Jeśli NAME nie jest podane, raportowana jest lista dostępnych nazw adc. Jeśli podano PULLUP (jako wartość w Ohmach), to raportowana jest surowa wartość analogowa wraz z ekwiwalentem rezystancji przy danym podciągnięciu.

### [query_endstops]

The query_endstops module is automatically loaded. The following standard G-Code commands are currently available, but using them is not recommended:

- Pobierz status zakończenia: `M119` (zamiast tego użyj QUERY_ENDSTOPS).

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Sondowanie endstopów osi i raportowanie, czy są one "wyzwolone" lub w stanie "otwartym". To polecenie jest zwykle używane do sprawdzenia, czy wyłącznik krańcowy działa poprawnie.

### [resonance_tester]

The following commands are available when a [resonance_tester config section](Config_Reference.md#resonance_tester) is enabled (also see the [measuring resonances guide](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Measures and outputs the noise for all axes of all enabled accelerometer chips.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `chip_name` can be one or more configured accel chips, delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [respond]

The following standard G-Code commands are available when the [respond config section](Config_Reference.md#respond) is enabled:

- `M118 <message>`: echo the message prepended with the configured default prefix (or `echo: ` if no prefix is configured).

The following additional commands are also available.

#### RESPOND

- `RESPOND MSG="<message>"`: echo the message prepended with the configured default prefix (or `echo: ` if no prefix is configured).
- `RESPOND TYPE=echo MSG="<message>"`: echo the message prepended with `echo: `.
- `RESPOND TYPE=echo_no_space MSG="<message>"`: echo the message prepended with `echo:` without a space between prefix and message, helpful for compatibility with some octoprint plugins that expect very specific formatting.
- `RESPOND TYPE=command MSG="<message>"`: echo the message prepended with `// `. OctoPrint can be configured to respond to these messages (e.g. `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>"`: echo the message prepended with `!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"`: echo the message prepended with `<prefix>`. (The `PREFIX` parameter will take priority over the `TYPE` parameter)

### [save_variables]

The following command is enabled if a [save_variables config section](Config_Reference.md#save_variables) has been enabled.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<name> VALUE=<value>`: Saves the variable to disk so that it can be used across restarts. All stored variables are loaded into the `printer.save_variables.variables` dict at startup and can be used in gcode macros. The provided VALUE is parsed as a Python literal.

### [screws_tilt_adjust]

The following commands are available when the [screws_tilt_adjust config section](Config_Reference.md#screws_tilt_adjust) is enabled (also see the [manual level guide](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will invoke the bed screws adjustment tool. It will command the nozzle to different locations (as defined in the config file) probing the z height and calculate the number of knob turns to adjust the bed level. If DIRECTION is specified, the knob turns will all be in the same direction, clockwise (CW) or counterclockwise (CCW). See the PROBE command for details on the optional probe parameters. IMPORTANT: You MUST always do a G28 before using this command. If MAX_DEVIATION is specified, the command will raise a gcode error if any difference in the screw height relative to the base screw height is greater than the value provided. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file.

### [sdcard_loop]

When the [sdcard_loop config section](Config_Reference.md#sdcard_loop) is enabled, the following extended commands are available.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<count>`: Begin a looped section in the SD print. A count of 0 indicates that the section should be looped indefinitely.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: End a looped section in the SD print.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: Complete existing loops without further iterations.

### [servo]

The following commands are available when a [servo config section](Config_Reference.md#servo) is enabled.

#### SET_SERVO

`SET_SERVO SERVO=config_name [ANGLE=<degrees> | WIDTH=<seconds>]`: Set the servo position to the given angle (in degrees) or pulse width (in seconds). Use `WIDTH=0` to disable the servo output.

### [skew_correction]

The following commands are available when the [skew_correction config section](Config_Reference.md#skew_correction) is enabled (also see the [Skew Correction](Skew_Correction.md) guide).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>]`: Configures the [skew_correction] module with measurements (in mm) taken from a calibration print. One may enter measurements for any combination of planes, planes not entered will retain their current value. If `CLEAR=1` is entered then all skew correction will be disabled.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: Reports the current printer skew for each plane in both radians and degrees. The skew is calculated based on parameters provided via the `SET_SKEW` gcode.

#### OBLICZ_POMIAR_SKOŚNY

`CALC_MEASURED_SKEW [AC=<długość_ac>] [BD=<długość_bd>] [AD=<długość_adaktyki>]`: Oblicza i raportuje pochylenie (w radianach i stopniach) na podstawie zmierzonego wydruku.  Może to być przydatne do określenia aktualnego pochylenia drukarki po zastosowaniu korekcji.  Przed zastosowaniem korekcji może być również przydatne określenie, czy konieczna jest korekcja skosu.  Zobacz [Korekcja skosu] (Skew_Correction.md), aby uzyskać szczegółowe informacje na temat obiektów i pomiarów kalibracji skosu.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<name>] [SAVE=<name>] [REMOVE=<name>]`: Profile management for skew_correction. LOAD will restore skew state from the profile matching the supplied name. SAVE will save the current skew state to a profile matching the supplied name. Remove will delete the profile matching the supplied name from persistent memory. Note that after SAVE or REMOVE operations have been run the SAVE_CONFIG gcode must be run to make the changes to persistent memory permanent.

### [smart_effector]

Several commands are available when a [smart_effector config section](Config_Reference.md#smart_effector) is enabled. Be sure to check the official documentation for the Smart Effector on the [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) before changing the Smart Effector parameters. Also check the [probe calibration guide](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]`: Set the Smart Effector parameters. When `SENSITIVITY` is specified, the respective value is written to the SmartEffector EEPROM (requires `control_pin` to be provided). Acceptable `<sensitivity>` values are 0..255, the default is 50. Lower values require less nozzle contact force to trigger (but there is a higher risk of false triggering due to vibrations during probing), and higher values reduce false triggering (but require larger contact force to trigger). Since the sensitivity is written to EEPROM, it is preserved after the shutdown, and so it does not need to be configured on every printer startup. `ACCEL` and `RECOVERY_TIME` allow to override the corresponding parameters at run-time, see the [config section](Config_Reference.md#smart_effector) of Smart Effector for more info on those parameters.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR`: Resets Smart Effector sensitivity to its factory settings. Requires `control_pin` to be provided in the config section.

### [stepper_enable]

The stepper_enable module is automatically loaded.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<config_name> ENABLE=[0|1]`: Enable or disable only the given stepper. This is a diagnostic and debugging tool and must be used with care. Disabling an axis motor does not reset the homing information. Manually moving a disabled stepper may cause the machine to operate the motor outside of safe limits. This can lead to damage to axis components, hot ends, and print surface.

### [temperature_fan]

The following command is available when a [temperature_fan config section](Config_Reference.md#temperature_fan) is enabled.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<temperature_fan_name> [target=<target_temperature>] [min_speed=<min_speed>] [max_speed=<max_speed>]`: Sets the target temperature for a temperature_fan. If a target is not supplied, it is set to the specified temperature in the config file. If speeds are not supplied, no change is applied.

### [tmcXXXX]

The following commands are available when any of the [tmcXXXX config sections](Config_Reference.md#tmc-stepper-driver-configuration) are enabled.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`: This command will read all TMC driver registers and report their values. If a REGISTER is provided, only the specified register will be dumped.

#### INIT_TMC

`INIT_TMC STEPPER=<name>`: This command will initialize the TMC registers. Needed to re-enable the driver if power to the chip is turned off then back on.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: This will adjust the run and hold currents of the TMC driver. `HOLDCURRENT` is not applicable to tmc2660 drivers. When used on a driver which has the `globalscaler` field (tmc5160 and tmc2240), if StealthChop2 is used, the stepper must be held at standstill for >130ms so that the driver executes the AT#1 calibration.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: This will alter the value of the specified register field of the TMC driver. This command is intended for low-level diagnostics and debugging only because changing the fields during run-time can lead to undesired and potentially dangerous behavior of your printer. Permanent changes should be made using the printer configuration file instead. No sanity checks are performed for the given values. A VELOCITY can also be specified instead of a VALUE. This velocity is converted to the 20bit TSTEP based value representation. Only use the VELOCITY argument for fields that represent velocities.

### [toolhead]

The toolhead module is automatically loaded.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [MINIMUM_CRUISE_RATIO=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: This command can alter the velocity limits that were specified in the printer config file. See the [printer config section](Config_Reference.md#printer) for a description of each parameter.

### [tuning_tower]

The tuning_tower module is automatically loaded.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<command> PARAMETER=<name> START=<value> [SKIP=<value>] [FACTOR=<value> [BAND=<value>]] | [STEP_DELTA=<value> STEP_HEIGHT=<value>]`: A tool for tuning a parameter on each Z height during a print. The tool will run the given `COMMAND` with the given `PARAMETER` assigned to a value that varies with `Z` according to a formula. Use `FACTOR` if you will use a ruler or calipers to measure the Z height of the optimum value, or `STEP_DELTA` and `STEP_HEIGHT` if the tuning tower model has bands of discrete values as is common with temperature towers. If `SKIP=<value>` is specified, the tuning process doesn't begin until Z height `<value>` is reached, and below that the value will be set to `START`; in this case, the `z_height` used in the formulas below is actually `max(z - skip, 0)`. There are three possible combinations of options:

- `FACTOR`: The value changes at a rate of `factor` per millimeter. The formula used is: `value = start + factor * z_height`. You can plug the optimum Z height directly into the formula to determine the optimum parameter value.
- `FACTOR` and `BAND`: The value changes at an average rate of `factor` per millimeter, but in discrete bands where the adjustment will only be made every `BAND` millimeters of Z height. The formula used is: `value = start + factor * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` and `STEP_HEIGHT`: The value changes by `STEP_DELTA` every `STEP_HEIGHT` millimeters. The formula used is: `value = start + step_delta * floor(z_height / step_height)`. You can simply count bands or read tuning tower labels to determine the optimum value.

### [virtual_sdcard]

Klipper supports the following standard G-Code commands if the [virtual_sdcard config section](Config_Reference.md#virtual_sdcard) is enabled:

- Lista kart SD: `M20`
- Inicjalizacja karty SD: `M21`
- Wybierz plik SD: `M23 <filename>`.
- Uruchomienie/wznowienie druku SD: `M24`
- Wstrzymać druk SD: `M25`
- Ustawienie pozycji SD: `M26 S<offset>`.
- Raport SD status wydruku: `M27`

In addition, the following extended commands are available when the "virtual_sdcard" config section is enabled.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<filename>`: Load a file and start SD print.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE`: Unload file and clear SD state.

### [z_thermal_adjust]

The following commands are available when the [z_thermal_adjust config section](Config_Reference.md#z_thermal_adjust) is enabled.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<value>] [REF_TEMP=<value>]`: Enable or disable the Z thermal adjustment with `ENABLE`. Disabling does not remove any adjustment already applied, but will freeze the current adjustment value - this prevents potentially unsafe downward Z movement. Re-enabling can potentially cause upward tool movement as the adjustment is updated and applied. `TEMP_COEFF` allows run-time tuning of the adjustment temperature coefficient (i.e. the `TEMP_COEFF` config parameter). `TEMP_COEFF` values are not saved to the config. `REF_TEMP` manually overrides the reference temperature typically set during homing (for use in e.g. non-standard homing routines) - will be reset automatically upon homing.

### [z_tilt]

The following commands are available when the [z_tilt config section](Config_Reference.md#z_tilt) is enabled.

#### Z_TILT_ADJUST

`Z_TILT_ADJUST [RETRIES=<value>] [RETRY_TOLERANCE=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: This command will probe the points specified in the config and then make independent adjustments to each Z stepper to compensate for tilt. See the PROBE command for details on the optional probe parameters. The optional `RETRIES`, `RETRY_TOLERANCE`, and `HORIZONTAL_MOVE_Z` values override those options specified in the config file.

### [temperature_probe]

The following commands are available when a [temperature_probe config section](Config_Reference.md#temperature_probe) is enabled.

#### TEMPERATURE_PROBE_CALIBRATE

`TEMPERATURE_PROBE_CALIBRATE [PROBE=<probe name>] [TARGET=<value>] [STEP=<value>]`: Initiates probe drift calibration for eddy current based probes. The `TARGET` is a target temperature for the last sample. When the temperature recorded during a sample exceeds the `TARGET` calibration will complete. The `STEP` parameter sets temperature delta (in C) between samples. After a sample has been taken, this delta is used to schedule a call to `TEMPERATURE_PROBE_NEXT`. The default `STEP` is 2.

#### TEMPERATURE_PROBE_NEXT

`TEMPERATURE_PROBE_NEXT`: After calibration has started this command is run to take the next sample. It is automatically scheduled to run when the delta specified by `STEP` has been reached, however its also possible to manually run this command to force a new sample. This command is only available during calibration.

#### TEMPERATURE_PROBE_COMPLETE:

`TEMPERATURE_PROBE_COMPLETE`: Can be used to end calibration and save the current result before the `TARGET` temperature is reached. This command is only available during calibration.

#### ANULUJ

`ABORT`: Anuluje proces kalibracji, odrzucając bieżące wyniki. Ta komenda jest dostępna tylko podczas kalibracji driftu.

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: Sets temperature drift compensation on or off. If ENABLE is set to 0, drift compensation will be disabled, if set to 1 it is enabled.
