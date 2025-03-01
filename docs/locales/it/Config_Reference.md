# Riferimenti configurazione

Questo documento è un riferimento per le opzioni disponibili nel file di configurazione di Klipper.

Le descrizioni in questo documento sono formattate in modo che sia possibile tagliarle e incollarle in un file di configurazione della stampante. Consulta il [documento di installazione](Installation.md) per informazioni sulla configurazione di Klipper e sulla scelta di un file di configurazione iniziale.

## Configurazione del microcontrollore

### Formato dei nomi dei pin del microcontrollore

Molte opzioni di configurazione richiedono il nome di un pin del microcontrollore. Klipper usa i nomi hardware per questi pin, ad esempio "PA4".

I nomi dei pin possono essere preceduti da `!` per indicare che deve essere utilizzata una polarità inversa (ad esempio, trigger su basso anziché alto).

I pin di input possono essere preceduti da `^` per indicare che un resistore di pull-up hardware deve essere abilitato per il pin. Se il microcontrollore supporta resistori pull-down, un pin di ingresso può in alternativa essere preceduto da `~`.

Nota, alcune sezioni di configurazione potrebbero "creare" pin aggiuntivi. Quando ciò si verifica, la sezione di configurazione che definisce i pin deve essere elencata nel file di configurazione prima di qualsiasi sezione che utilizza tali pin.

### [mcu]

Configurazione del microcontrollore primario.

```
[mcu]
serial:
#   La porta seriale per la connessione all'MCU. In caso di dubbi (o se
#   cambia) vedere "Dov'è la mia porta seriale?" sezione delle FAQ.
#   Questo parametro deve essere fornito quando si utilizza una
#   porta seriale.
#baud: 250000
#   La velocità di trasmissione da utilizzare. Il valore predefinito è 250000.
#canbus_uuid:
#   Se si utilizza un dispositivo collegato a un bus CAN, questo imposta
#   l'identificatore univoco del chip a cui connettersi. Questo valore deve
#   essere fornito quando si utilizza il bus CAN per la comunicazione.
#canbus_interface:
#   Se si utilizza un dispositivo collegato a un bus CAN, viene impostata
#   l'interfaccia di rete CAN da utilizzare. L'impostazione predefinita è 'can0'.
#restart_method:
#   Questo controlla il meccanismo che l'host utilizzerà per reimpostare
#   il microcontrollore. Le scelte sono "arduino", "cheetah", "rpi_usb" e
#   "command". Il metodo 'arduino' (attiva/disattiva DTR) è comune su
#   schede Arduino e cloni. Il metodo 'cheetah' è un metodo speciale
#   necessario per alcune schede Fysetc Cheetah. Il metodo "rpi_usb"
#   è utile sulle schede Raspberry Pi con microcontrollori alimentati
#   tramite USB: disabilita brevemente l'alimentazione a tutte le porte
#   USB per eseguire un ripristino del microcontrollore. Il metodo
#   "comando" prevede l'invio di un comando Klipper al microcontrollore
#   in modo che possa reimpostarsi. L'impostazione predefinita è
#   'arduino' se il microcontrollore comunica su una porta seriale,
#   altrimenti 'comando'.
```

### [mcu my_extra_mcu]

Microcontrollori aggiuntivi (si può definire un numero qualsiasi di sezioni con un prefisso "mcu"). Microcontrollori aggiuntivi introducono pin aggiuntivi che possono essere configurati come riscaldatori, stepper, ventole, ecc. Ad esempio, se viene introdotta una sezione "[mcu extra_mcu]", i pin come "extra_mcu:ar9" possono quindi essere utilizzati altrove nella configurazione (dove "ar9" è un nome pin hardware o un nome alias sul dato mcu).

```
[mcu my_extra_mcu]
# Vedere la sezione "mcu" per i parametri di configurazione.
```

## Impostazioni cinematiche comuni

### [printer]

La sezione printer controlla le impostazioni di alto livello della stampante.

```
[printer]
kinematics:
#   The type of printer in use. This option may be one of: cartesian,
#   corexy, corexz, hybrid_corexy, hybrid_corexz, rotary_delta, delta,
#   deltesian, polar, winch, or none. This parameter must be specified.
max_velocity:
#   Maximum velocity (in mm/s) of the toolhead (relative to the
#   print). This parameter must be specified.
max_accel:
#   Maximum acceleration (in mm/s^2) of the toolhead (relative to the
#   print). Although this parameter is described as a "maximum"
#   acceleration, in practice most moves that accelerate or decelerate
#   will do so at the rate specified here. The value specified here
#   may be changed at runtime using the SET_VELOCITY_LIMIT command.
#   This parameter must be specified.
#minimum_cruise_ratio: 0.5
#   Most moves will accelerate to a cruising speed, travel at that
#   cruising speed, and then decelerate. However, some moves that
#   travel a short distance could nominally accelerate and then
#   immediately decelerate. This option reduces the top speed of these
#   moves to ensure there is always a minimum distance traveled at a
#   cruising speed. That is, it enforces a minimum distance traveled
#   at cruising speed relative to the total distance traveled. It is
#   intended to reduce the top speed of short zigzag moves (and thus
#   reduce printer vibration from these moves). For example, a
#   minimum_cruise_ratio of 0.5 would ensure that a standalone 1.5mm
#   move would have a minimum cruising distance of 0.75mm. Specify a
#   ratio of 0.0 to disable this feature (there would be no minimum
#   cruising distance enforced between acceleration and deceleration).
#   The value specified here may be changed at runtime using the
#   SET_VELOCITY_LIMIT command. The default is 0.5.
#square_corner_velocity: 5.0
#   The maximum velocity (in mm/s) that the toolhead may travel a 90
#   degree corner at. A non-zero value can reduce changes in extruder
#   flow rates by enabling instantaneous velocity changes of the
#   toolhead during cornering. This value configures the internal
#   centripetal velocity cornering algorithm; corners with angles
#   larger than 90 degrees will have a higher cornering velocity while
#   corners with angles less than 90 degrees will have a lower
#   cornering velocity. If this is set to zero then the toolhead will
#   decelerate to zero at each corner. The value specified here may be
#   changed at runtime using the SET_VELOCITY_LIMIT command. The
#   default is 5mm/s.
#max_accel_to_decel:
#   This parameter is deprecated and should no longer be used.
```

### [stepper]

Definizioni di motori passo-passo. Diversi tipi di stampante (come specificato dall'opzione "cinematica" nella sezione di configurazione [stampante]) richiedono nomi diversi per lo stepper (ad esempio, `stepper_x` vs `stepper_a`). Di seguito sono riportate le definizioni comuni di stepper.

Vedere il [documento distanza di rotazione](Rotation_Distance.md) per informazioni sul calcolo del parametro `rotation_distance`. Consultare il documento [Multi-MCU homing](Multi_MCU_Homing.md) per informazioni sull'homing utilizzando più microcontrollori.

```
[stepper_x]
step_pin:
#   Pin GPIO Step (attivato in alto) . Questo parametro deve essere fornito.
dir_pin:
#   Pin GPIO di direzione (alto indica una direzione positiva).
#   Questo parametro deve essere fornito.
enable_pin:
#   Pin GPIO di abilitazione (l'impostazione predefinita è abilita alto; usa !
#   per indicare abilita basso). Se questo parametro non viene fornito, il
#   driver del motore passo-passo deve essere sempre abilitato.
rotation_distance:
#   Distanza (in mm) che l'asse percorre con una rotazione completa del
#   motore passo-passo (o viene specificata la marcia finale del rapporto di
#   trasmissione). Questo parametro deve essere fornito.
microsteps:
#   Il numero di micropassi utilizzati dal driver del motore passo-passo.
#   Questo parametro deve essere fornito.
#full_steps_per_rotation: 200
#   Il numero di passi completi per una rotazione del motore passo-passo.
#   Impostarlo su 200 per un motore passo-passo da 1.8 gradi o su 400 per
#   un motore da 0.9 gradi. Il valore predefinito è 200.
#gear_ratio:
#   Il rapporto di trasmissione se il motore passo-passo è collegato all'asse
#   tramite un riduttore. Ad esempio, si può specificare "5:1" se è in uso un
#   riduttore 5 a 1. Se l'asse ha più riduttori, è possibile specificare un elenco
#   di rapporti di trasmissione separati da virgole (ad esempio, "57:11, 2:1").
#   Se viene specificato gear_ratio, rotation_distance specifica la distanza
#   percorsa dall'asse per una rotazione completa dell'ingranaggio finale.
#   L'impostazione predefinita è di non utilizzare un rapporto di trasmissione.
#step_pulse_duration:
#   Il tempo minimo tra il fronte del segnale dell'impulso del passo e il
#   successivo fronte del segnale "non passo". Viene utilizzato anche per
#   impostare il tempo minimo tra un impulso di passo e un segnale di cambio
#   di direzione. L'impostazione predefinita è 0.000000100 (100ns) per gli
#   stepper TMC configurati in modalità UART o SPI e l'impostazione
#   predefinita è 0.000002 (che è 2us) per tutti gli altri stepper.
endstop_pin:
#   Pin di rilevamento interruttore di fine corsa. Se questo pin di fine corsa
#   si trova su un mcu diverso dal motore passo-passo, abilita il
#   "homing multi-mcu". Questo parametro deve essere fornito per gli
#   stepper X, Y e Z su stampanti in stile cartesiano.
#position_min: 0
#   Distanza minima valida (in mm) alla quale l'utente può comandare
#   il movimento dello stepper. Il valore predefinito è 0 mm.
position_endstop:
#   Posizione del finecorsa (in mm). Questo parametro deve essere fornito
#   per gli stepper X, Y e Z su stampanti in stile cartesiano.
position_max:
#   Distanza massima valida (in mm) alla quale l'utente può comandare lo
#   spostamento dello stepper. Questo parametro deve essere fornito per
#   gli stepper X, Y e Z su stampanti in stile cartesiano.
#homing_speed: 5.0
#   Velocità massima (in mm/s) dello stepper durante l'homing.
#   Il valore predefinito è 5 mm/s.
#homing_retract_dist: 5.0
#   Distanza dall'arretramento (in mm) prima della corsa di riferimento
#   una seconda volta durante la corsa di riferimento. Impostalo a zero per
#   disabilitare la seconda casa. Il valore predefinito è 5 mm.
#homing_retract_speed:
#   Velocità da utilizzare nella corsa di ritorno dopo l'homing nel caso in
#   cui questa dovesse essere diversa dalla velocità di homing, che è
#   l'impostazione predefinita per questo parametro
#second_homing_speed:
#   Velocità (in mm/s) dello stepper durante l'esecuzione del secondo
#   homing. L'impostazione predefinita è homing_speed/2.
#homing_positive_dir:
#   Se true, l'homing farà muovere lo stepper in una direzione positiva
#   (allontanandosi da zero); se falso, home verso zero. È meglio utilizzare
#   l'impostazione predefinita piuttosto che specificare questo parametro.
#   Il valore predefinito è true se position_endstop è vicino a position_max
#   false se vicino a position_min.
```

### Cinematica cartesiana

Vedere [example-cartesian.cfg](../config/example-cartesian.cfg) per un file di configurazione della cinematica cartesiana di esempio.

Qui sono descritti solo i parametri specifici delle stampanti cartesiane - vedere [impostazioni cinematiche comuni](#impostazioni-cinema-comuni) per i parametri disponibili.

```
[printer]
kinematics: cartesian
max_z_velocity:
#   Imposta la velocità massima (in mm/s) di movimento lungo
#   l'asse z. Questa impostazione può essere utilizzata per limitare
#   la velocità massima del motore passo-passo z. L'impostazione
#   predefinita è utilizzare max_velocity per max_z_velocity.
max_z_accel:
#   Imposta l'accelerazione massima (in mm/s^2) del movimento
#   lungo l'asse z. Limita l'accelerazione del motore passo-passo z.
#   L'impostazione predefinita è utilizzare max_accel per max_z_accel.

# La sezione stepper_x viene utilizzata per descrivere lo stepper
# che controlla l'asse X in un robot cartesiano.
[stepper_x]

# La sezione stepper_y viene utilizzata per descrivere lo stepper
# che controlla l'asse Y in un robot cartesiano.
[stepper_y]

# La sezione stepper_z viene utilizzata per descrivere lo stepper
# che controlla l'asse Z in un robot cartesiano.
[stepper_z]
```

### Cinematica Delta lineare

Vedere [example-delta.cfg](../config/example-delta.cfg) per un file di configurazione della cinematica delta lineare di esempio. Consultare la [guida alla calibrazione delta](Delta_Calibrate.md) per informazioni sulla calibrazione.

Qui vengono descritti solo i parametri specifici per le stampanti delta lineari - vedere [impostazioni cinematiche comuni](#impostazioni-cinematica-comune) per i parametri disponibili.

```
[printer]
kinematics: delta
max_z_velocity:
#   Per le stampanti delta questo limita la velocità massima (in mm/s) dei
#   movimenti con movimento dell'asse z. Questa impostazione può essere
#   utilizzata per ridurre la velocità massima dei movimenti su/giù (che
#   richiedono una velocità di incremento maggiore rispetto ad altri
#   movimenti su una stampante delta). L'impostazione predefinita è
#   utilizzare max_velocity per max_z_velocity.
#max_z_accel:
#   Imposta l'accelerazione massima (in mm/s^2) del movimento lungo
#   l'asse z. L'impostazione può essere utile se la stampante può
#   raggiungere un'accelerazione maggiore sui movimenti XY rispetto ai
#   movimenti Z (ad esempio, quando si utilizza l'input shaper).
#   L'impostazione predefinita è utilizzare max_accel per max_z_accel.
#minimum_z_position: 0
#   La posizione Z minima in cui l'utente può comandare alla testa di
#   spostarsi. Il valore predefinito è 0.
delta_radius:
#   Raggio (in mm) del cerchio orizzontale formato dalle tre torri ad
#   asse lineare. Questo parametro può anche essere calcolato come:
#   delta_radius = smooth_rod_offset - effector_offset - carriage_offset
#   Questo parametro deve essere fornito.
#print_radius:
#   Il raggio (in mm) delle coordinate XY della testa di stampa valide.
#   È possibile utilizzare questa impostazione per personalizzare il
#   controllo dell'intervallo dei movimenti della testa. Se qui
#   viene specificato un valore elevato, potrebbe essere possibile
#   comandare la collisione della testa di stampa con una torre.
#   L'impostazione predefinita è usare delta_radius per print_radius
#   (che normalmente impedirebbe una collisione con torri).

# La sezione stepper_a descrive lo stepper che controlla la torre
# anteriore sinistra (a 210 gradi). Questa sezione controlla anche i
# parametri di homing (velocità di homing, homing retract_dist) 
# per tutte le torri.
[stepper_a]
position_endstop:
#   Distanza (in mm) tra l'ugello e il piatto quando l'ugello si trova al
#   centro dell'area di costruzione e si attiva il finecorsa. Questo
#   parametro deve essere fornito per stepper_a; per stepper_b e
#   stepper_c questo parametro è predefinito sul valore specificato
#   per stepper_a.
arm_length:
#   Lunghezza (in mm) dell'asta diagonale che collega questa torre
#   alla testa di stampa. Questo parametro deve essere fornito per
#   stepper_a; per stepper_b e stepper_c questo parametro è
predefinito sul valore specificato per stepper_a.
#angle:
#   Questa opzione specifica l'angolo (in gradi) a cui si trova la torre.
#   Il valore predefinito è 210 per stepper_a, 330 per stepper_b e 90
#   per stepper_c.

# La sezione stepper_b descrive lo stepper che controlla la torre
# anteriore destra (a 330 gradi).
[stepper_b]

# La sezione stepper_c descrive lo stepper che controlla la torre
# posteriore (a 90 gradi).
[stepper_c]

# La sezione delta_calibrate abilita un comando G-code esteso
# DELTA_CALIBRATE in grado di calibrare le posizioni e gli angoli
# dei finecorsa della torre.
[delta_calibrate]
radius:
#   Raggio (in mm) dell'area che può essere sondata. Questo è
#   il raggio delle coordinate dell'ugello da sondare; se si utilizza
#   una sonda automatica con un offset XY, scegliere un raggio
#   sufficientemente piccolo in modo che la sonda si adatti sempre
#   al piatto. Questo parametro deve essere fornito.
#speed: 50
#   La velocità (in mm/s) degli spostamenti senza probing durante
#   la calibrazione. Il valore predefinito è 50.
#horizontal_move_z: 5
#   L'altezza (in mm) a cui la testa deve essere comandata di
#   spostarsi appena prima di avviare un'operazione di sonda.
#   L'impostazione predefinita è 5.
```

### Cinematica Deltesiana

Vedere [example-deltesian.cfg](../config/example-deltesian.cfg) per un esempio di file di configurazione della cinematica deltesiana.

Qui sono descritti solo i parametri specifici per le stampanti deltesiane - vedere [impostazioni cinematiche comuni](#common-kinematic-settings) per i parametri disponibili.

```
[printer]
kinematics: deltesian
max_z_velocity:
#   For deltesian printers, this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a deltesian printer). The default is to use
#   max_velocity for max_z_velocity.
#max_z_accel:
#   This sets the maximum acceleration (in mm/s^2) of movement along
#   the z axis. Setting this may be useful if the printer can reach higher
#   acceleration on XY moves than Z moves (eg, when using input shaper).
#   The default is to use max_accel for max_z_accel.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to. The default is 0.
#min_angle: 5
#   This represents the minimum angle (in degrees) relative to horizontal
#   that the deltesian arms are allowed to achieve. This parameter is
#   intended to restrict the arms from becoming completely horizontal,
#   which would risk accidental inversion of the XZ axis. The default is 5.
#print_width:
#   The distance (in mm) of valid toolhead X coordinates. One may use
#   this setting to customize the range checking of toolhead moves. If
#   a large value is specified here then it may be possible to command
#   the toolhead into a collision with a tower. This setting usually
#   corresponds to bed width (in mm).
#slow_ratio: 3
#   The ratio used to limit velocity and acceleration on moves near the
#   extremes of the X axis. If vertical distance divided by horizontal
#   distance exceeds the value of slow_ratio, then velocity and
#   acceleration are limited to half their nominal values. If vertical
#   distance divided by horizontal distance exceeds twice the value of
#   the slow_ratio, then velocity and acceleration are limited to one
#   quarter of their nominal values. The default is 3.

# The stepper_left section is used to describe the stepper controlling
# the left tower. This section also controls the homing parameters
# (homing_speed, homing_retract_dist) for all towers.
[stepper_left]
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstops are triggered. This
#   parameter must be provided for stepper_left; for stepper_right this
#   parameter defaults to the value specified for stepper_left.
arm_length:
#   Length (in mm) of the diagonal rod that connects the tower carriage to
#   the print head. This parameter must be provided for stepper_left; for
#   stepper_right, this parameter defaults to the value specified for
#   stepper_left.
arm_x_length:
#   Horizontal distance between the print head and the tower when the
#   printers is homed. This parameter must be provided for stepper_left;
#   for stepper_right, this parameter defaults to the value specified for
#   stepper_left.

# The stepper_right section is used to describe the stepper controlling the
# right tower.
[stepper_right]

# The stepper_y section is used to describe the stepper controlling
# the Y axis in a deltesian robot.
[stepper_y]
```

### Cinematica CoreXY

Vedere [example-corexy.cfg](../config/example-corexy.cfg) per un file cinematico corexy (e h-bot) di esempio.

Qui sono descritti solo i parametri specifici per le stampanti corexy - vedere [impostazioni cinematiche comuni](#impostazioni-cinema-comune) per i parametri disponibili.

```
[printer]
kinematics: corexy
max_z_velocity:
#   Imposta la velocità massima (in mm/s) di movimento lungo l'asse z.
#   Questa impostazione può essere utilizzata per limitare la velocità
#   massima del motore passo-passo z. L'impostazione predefinita è
#   utilizzare max_velocity per max_z_velocity.
max_z_accel:
#   Imposta l'accelerazione massima (in mm/s^2) del movimento
#   lungo l'asse z. Limita l'accelerazione del motore passo-passo z.
#   L'impostazione predefinita è utilizzare max_accel per max_z_accel.

# La sezione stepper_x viene utilizzata per descrivere l'asse X e lo
# stepper che controlla il movimento X+Y.
[stepper_x]

# La sezione stepper_y viene utilizzata per descrivere l'asse Y e lo
# stepper che controlla il movimento X+Y.
[stepper_y]

# La sezione stepper_z viene utilizzata per descrivere l'asse Z
[stepper_z]
```

### Cinematica CoreXZ

Vedere [example-corexz.cfg](../config/example-corexz.cfg) per un file di configurazione della cinematica corexz di esempio.

Qui sono descritti solo i parametri specifici per le stampanti corexz - vedere [impostazioni cinematiche comuni](#impostazioni-cinema-comune) per i parametri disponibili.

```
[printer]
kinematics: corexz
max_z_velocity:
#   Imposta la velocità massima (in mm/s) di movimento lungo l'asse z.
#   L'impostazione predefinita è utilizzare max_velocity per
#   max_z_velocity.
max_z_accel:
#   Imposta l'accelerazione massima (in mm/s^2) del movimento lungo
#   l'asse z. L'impostazione predefinita è utilizzare max_accel per
#   max_z_accel.

# La sezione stepper_x viene utilizzata per descrivere l'asse X e lo
# stepper che controlla il movimento X+Z.
[stepper_x]

# La sezione stepper_y viene utilizzata per descrivere l'asse Y
[stepper_y]

# La sezione stepper_z viene utilizzata per descrivere l'asse Z e lo
# stepper che controlla il movimento X+Z.
[stepper_z]
```

### Cinematica Hybrid-CoreXY

Vedere [example-hybrid-corexy.cfg](../config/example-hybrid-corexy.cfg) per un file di configurazione della cinematica corexy ibrida di esempio.

Questa cinematica è anche nota come cinematica Markforged.

Qui vengono descritti solo i parametri specifici delle stampanti corexy ibride, vedere [impostazioni cinematiche comuni](#impostazioni-cinematica-comune) per i parametri disponibili.

```
[printer]
kinematics: hybrid_corexy
max_z_velocity:
#   Imposta la velocità massima (in mm/s) di movimento lungo
#   l'asse z. L'impostazione predefinita è utilizzare max_velocity
#   per max_z_velocity.
max_z_accel:
#   Imposta l'accelerazione massima (in mm/s^2) del movimento
#   lungo l'asse z. L'impostazione predefinita è utilizzare max_accel
#   per max_z_accel.

# La sezione stepper_x viene utilizzata per descrivere l'asse X e lo
# stepper che controlla il movimento X-Y.
[stepper_x]

# La sezione stepper_y viene utilizzata per descrivere lo stepper
# che controlla l'asse Y.
[stepper_y]

# La sezione stepper_z viene utilizzata per descrivere lo stepper
# che controlla l'asse Z.
[stepper_z]
```

### Cinematica Hybrid-CoreXZ

Vedere [example-hybrid-corexz.cfg](../config/example-hybrid-corexz.cfg) per un file di configurazione della cinematica corexz ibrido di esempio.

Questa cinematica è anche nota come cinematica Markforged.

Qui vengono descritti solo i parametri specifici delle stampanti corexy ibride, vedere [impostazioni cinematiche comuni](#impostazioni-cinematica-comune) per i parametri disponibili.

```
[printer]
kinematics: hybrid_corexz
max_z_velocity:
#   Questo imposta la velocità massima (in mm/s) di movimento lungo
#   l'asse z. L'impostazione predefinita è utilizzare max_velocity per
#   max_z_velocity.
max_z_accel:
#   Imposta l'accelerazione massima (in mm/s^2) del movimento lungo
#   l'asse z. L'impostazione predefinita è utilizzare max_accel per
#   max_z_accel.

# La sezione stepper_x viene utilizzata per descrivere l'asse X e lo
# stepper che controlla il movimento X-Z.
[stepper_x]

# La sezione stepper_y viene utilizzata per descrivere lo stepper che
# controlla l'asse Y.
[stepper_y]

# La sezione stepper_z viene utilizzata per descrivere lo stepper che
# controlla l'asse Z.
[stepper_z]
```

### Cinematica polare

Vedere [example-polar.cfg](../config/example-polar.cfg) per un file di configurazione della cinematica polare di esempio.

Qui sono descritti solo i parametri specifici per le stampanti polari - vedere [impostazioni cinematiche comuni](#impostazioni-cinema-comuni) per i parametri disponibili.

LA CINEMATICA POLARE È UN LAVORO IN CORSO. È noto che i movimenti intorno alla posizione 0, 0 non funzionano correttamente.

```
[printer]
kinematics: polar
max_z_velocity:
#   Imposta la velocità massima (in mm/s) di movimento lungo l'asse z.
#   Questa impostazione può essere utilizzata per limitare la velocità
#   massima del motore passo-passo z. L'impostazione predefinita è
#   utilizzare max_velocity per max_z_velocity.
max_z_accel:
#   Questo imposta l'accelerazione massima (in mm/s^2) del
#   movimento lungo l'asse z. Limita l'accelerazione del motore
#   passo-passo z. L'impostazione predefinita è utilizzare max_accel
#   per max_z_accel.

# La sezione stepper_bed viene utilizzata per descrivere lo stepper
# che controlla il piatto
[stepper_bed]
gear_ratio:
#   È necessario specificare un gear_ratio e rotation_distance
#   potrebbe non essere specificato. Ad esempio, se il piatto ha una
#   ruota a 80 denti azionata da uno stepper con una ruota a 16
#   denti, si dovrebbe specificare un rapporto di trasmissione di "80:16".
#   Questo parametro deve essere fornito.

# La sezione stepper_arm è usata per descrivere lo stepper che
# controlla il carrello sul braccio.
[stepper_arm]

# La sezione stepper_z viene utilizzata per descrivere lo stepper che
# controlla l'asse Z.
[stepper_z]
```

### Cinematica delta rotatoria

Vedere [example-rotary-delta.cfg](../config/example-rotary-delta.cfg) per un esempio di file di configurazione della cinematica delta rotante.

Qui vengono descritti solo i parametri specifici delle stampanti delta rotative - vedere [impostazioni cinematiche comuni](#impostazioni-cinematica-comune) per i parametri disponibili.

LA CINEMATICA DELTA ROTANTE È UN LAVORO IN CORSO. Gli spostamenti di homing potrebbero scadere e alcuni controlli dei confini non vengono implementati.

```
[printer]
kinematics: rotary_delta
max_z_velocity:
#   For delta printers this limits the maximum velocity (in mm/s) of
#   moves with z axis movement. This setting can be used to reduce the
#   maximum speed of up/down moves (which require a higher step rate
#   than other moves on a delta printer). The default is to use
#   max_velocity for max_z_velocity.
#minimum_z_position: 0
#   The minimum Z position that the user may command the head to move
#   to.  The default is 0.
shoulder_radius:
#   Radius (in mm) of the horizontal circle formed by the three
#   shoulder joints, minus the radius of the circle formed by the
#   effector joints. This parameter may also be calculated as:
#     shoulder_radius = (delta_f - delta_e) / sqrt(12)
#   This parameter must be provided.
shoulder_height:
#   Distance (in mm) of the shoulder joints from the bed, minus the
#   effector toolhead height. This parameter must be provided.

# The stepper_a section describes the stepper controlling the rear
# right arm (at 30 degrees). This section also controls the homing
# parameters (homing_speed, homing_retract_dist) for all arms.
[stepper_a]
gear_ratio:
#   A gear_ratio must be specified and rotation_distance may not be
#   specified. For example, if the arm has an 80 toothed pulley driven
#   by a pulley with 16 teeth, which is in turn connected to a 60
#   toothed pulley driven by a stepper with a 16 toothed pulley, then
#   one would specify a gear ratio of "80:16, 60:16". This parameter
#   must be provided.
position_endstop:
#   Distance (in mm) between the nozzle and the bed when the nozzle is
#   in the center of the build area and the endstop triggers. This
#   parameter must be provided for stepper_a; for stepper_b and
#   stepper_c this parameter defaults to the value specified for
#   stepper_a.
upper_arm_length:
#   Length (in mm) of the arm connecting the "shoulder joint" to the
#   "elbow joint". This parameter must be provided for stepper_a; for
#   stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
lower_arm_length:
#   Length (in mm) of the arm connecting the "elbow joint" to the
#   "effector joint". This parameter must be provided for stepper_a;
#   for stepper_b and stepper_c this parameter defaults to the value
#   specified for stepper_a.
#angle:
#   This option specifies the angle (in degrees) that the arm is at.
#   The default is 30 for stepper_a, 150 for stepper_b, and 270 for
#   stepper_c.

# The stepper_b section describes the stepper controlling the rear
# left arm (at 150 degrees).
[stepper_b]

# The stepper_c section describes the stepper controlling the front
# arm (at 270 degrees).
[stepper_c]

# The delta_calibrate section enables a DELTA_CALIBRATE extended
# g-code command that can calibrate the shoulder endstop positions.
[delta_calibrate]
radius:
#   Radius (in mm) of the area that may be probed. This is the radius
#   of nozzle coordinates to be probed; if using an automatic probe
#   with an XY offset then choose a radius small enough so that the
#   probe always fits over the bed. This parameter must be provided.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### Cinematica dell'argano a fune

Vedere [example-winch.cfg](../config/example-winch.cfg) per un esempio di file di configurazione della cinematica con verricello, cable winch.

Qui sono descritti solo i parametri specifici per le stampanti cavo verricello - vedere [impostazioni comuni cinematiche](#common-kinematic-settings) per i parametri disponibili.

IL SUPPORTO DEL VERRICELLO È SPERIMENTALE. L'homing non è implementato nella cinematica del verricello. Per riportare la stampante alla posizione iniziale, inviare manualmente i comandi di movimento finché la testa utensile non si trova su 0, 0, 0, quindi emettere un comando "G28".

```
[printer]
kinematics: winch

# The stepper_a section describes the stepper connected to the first
# cable winch. A minimum of 3 and a maximum of 26 cable winches may be
# defined (stepper_a to stepper_z) though it is common to define 4.
[stepper_a]
rotation_distance:
#   The rotation_distance is the nominal distance (in mm) the toolhead
#   moves towards the cable winch for each full rotation of the
#   stepper motor. This parameter must be provided.
anchor_x:
anchor_y:
anchor_z:
#   The X, Y, and Z position of the cable winch in cartesian space.
#   These parameters must be provided.
```

### Nessuna cinematica

È possibile definire una cinematica speciale "none" per disabilitare il supporto cinematico in Klipper. Questo può essere utile per controllare dispositivi che non sono le tipiche stampanti 3D o per scopi di debug.

```
[printer]
kinematics: none
max_velocity: 1
max_accel: 1
#   È necessario definire i parametri max_velocity e max_accel. I valori
#   non vengono utilizzati per la cinematica "none".
```

## Supporto per estrusore e piatto riscaldato comuni

### [extruder]

La sezione dell'estrusore viene utilizzata per descrivere i parametri del riscaldatore per l'hotend dell'ugello insieme allo stepper che controlla l'estrusore. Per ulteriori informazioni, vedere [riferimento comando](G-Codes.md#extruder). Consultare la [Guida all'avanzamento della pressione](Pressure_Advance.md) per informazioni sulla regolazione dell'anticipo della pressione.

```
[extruder]
step_pin:
dir_pin:
enable_pin:
microsteps:
rotation_distance:
#full_steps_per_rotation:
#gear_ratio:
#   Vedere la sezione "stepper" per una descrizione di quanto sopra
#   Se nessuno dei parametri precedenti è specificato, nessuno stepper 
#   sarà associato all'hotend dell'ugello (sebbene un comando
#   SYNC_EXTRUDER_MOTION possa associarne uno in fase di esecuzione).
nozzle_diameter:
#   Diametro dell'orifizio dell'ugello (in mm). Questo parametro deve essere fornito.
filament_diameter::
#   Il diametro nominale del filamento grezzo (in mm) quando
#   entra nell'estrusore. Questo parametro deve essere fornito.
#max_extrude_cross_section:
#   Area massima (in mm^2) di una sezione trasversale dell'estrusione
#   (ad es. larghezza dell'estrusione moltiplicata per l'altezza dello strato).
#   Questa impostazione previene quantità eccessive di estrusione
#   durante spostamenti XY relativamente piccoli.
#   Se un movimento richiede una velocità di estrusione che supererebbe questo valore
#   causerà la restituzione di un errore. L'impostazione predefinita
#   è: 4.0 * diametro_ugello^2
instantaneous_corner_velocity: 1.000
#   La variazione di velocità istantanea massima (in mm/s) del
#   estrusore durante il collegamento di due movimenti. Il valore predefinito è 1 mm/s.
#max_extrude_only_distance: 50.0
#   Lunghezza massima (in mm di filamento grezzo) che può avere un movimento
#    di retrazione o di sola estrusione. Se uno spostamento di retrazione
#    o di sola estrusione richiede una distanza maggiore di questo valore,
#   verrà restituito un errore. Il valore predefinito è 50 mm.
#max_extrude_only_velocity:
#max_extrude_only_accel:
#   Velocità massima (in mm/s) e accelerazione (in mm/s^2) del
#   motore estrusore per retrazioni e movimenti di sola estrusione.
#   Queste impostazioni non hanno alcun impatto sui normali movimenti di stampa.
#   Se non specificati, vengono calcolati per corrispondere al limite che avrebbe
#   un movimento di stampa XY con una sezione trasversale di 4,0*diametro_ugello^2.
#pressure_advance: 0.0
#   La quantità di filamento grezzo da spingere nell'estrusore durante
#   accelerazione dell'estrusore. Una uguale quantità di filamento viene
#   retratta durante la decelerazione. Si misura in millimetri per
#   millimetro/secondo. Il valore predefinito è 0, che disabilita l'avanzamento della pressione.
#pressure_advance_smooth_time: 0,040
#   Un intervallo di tempo (in secondi) da utilizzare per calcolare la velocità media
#   dell'estrusore per l'avanzamento della pressione. Un valore maggiore si traduce
#   in movimenti più fluidi dell'estrusore. Questo parametro non può superare i 200 ms.
#   Questa impostazione si applica solo se pressure_advance è diverso da zero.
#   Il valore predefinito è 0,040 (40 millisecondi).
#
#   Le restanti variabili descrivono il riscaldatore dell'estrusore.
heater_pin:
#   Pin di uscita PWM che controlla il riscaldatore. Questo parametro deve essere fornito.
#max_power: 1.0
#   La potenza massima (espressa come un valore compreso tra 0,0 e 1,0) a cui
#   può essere impostato il riscaldatore_pin. Il valore 1.0 consente di impostare il pin
#   completamente abilitato per periodi prolungati, mentre un valore di 0,5
#   consentirebbe di abilitare il pin per non più della metà del tempo. Questo
#   l'impostazione può essere utilizzata per limitare la potenza totale
#   (per periodi prolungati) al riscaldatore. L'impostazione predefinita è 1.0.
sensor_type:
#   Tipo di sensore - i termistori comuni sono "EPCOS 100K B57560G104F",
#   "ATC Semitec 104GT-2", "ATC Semitec 104NT-4-R025H42G", "Generico
#   3950","Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450" e "TDK NTCG104LH104JT1". Vedere la sezione
#   "Sensori di temperatura" per altri sensori. Questo parametro deve essere fornito.
sensor_pin:
#   Pin di ingresso analogico collegato al sensore. Questo parametro deve essere fornito.
#pullup_resistor: 4700
#   La resistenza (in ohm) del pullup collegato al termistore. Questo parametro
#   è valido solo quando il sensore è un termistore. Il valore predefinito è 4700 ohm.
#smooth_time: 1.0
#   Un valore di tempo (in secondi) durante il quale le misurazioni della
#   temperatura verranno uniformate per ridurre l'impatto del rumore
#   di misurazione. Il valore predefinito è 1 secondo.
control:
#   Algoritmo di controllo (pid o filigrana). Questo parametro deve
#   essere fornito.
pid_Kp:
pid_Ki:
pid_Kd:
#   Il proporzionale (pid_Kp), l'integrale (pid_Ki) e la derivata
#   (pid_Kd) impostazioni per il sistema di controllo del feedback PID. Klipper
#   valuta le impostazioni PID con la seguente formula generale:
#   riscaldatore_pwm = (Kp*errore + Ki*integrale(errore) - Kd*derivato(errore)) / 255
#   Dove "errore" è "temperatura_richiesta - temperatura_misurata"
#   e "heater_pwm" è la velocità di riscaldamento richiesta con 0,0 completamente
#   off e 1.0 completamente on. Prendi in considerazione l'utilizzo di PID_CALIBRATE
#   comando per ottenere questi parametri. pid_Kp, pid_Ki e pid_Kd
#   i parametri devono essere forniti per i riscaldatori PID.
#delta_max: 2.0
#   Sui riscaldatori controllati questo è il numero di gradi in
#   Celsius al di sopra della temperatura target prima di disattivare il riscaldatore
#   così come il numero di gradi sotto il target prima
#   riattivare il riscaldatore. L'impostazione predefinita è 2 gradi Celsius.
#pwm_cycle_time: 0,100
#   Tempo in secondi per ogni ciclo PWM software del riscaldatore.
#   non è consigliabile impostarlo a meno che non ci sia necessario come
#   requisito accendere il riscaldatore più velocemente di 10 volte al secondo.
#   Il valore predefinito è 0,100 secondi.
#min_extrude_temp: 170
#   La temperatura minima (in gradi Celsius) alla quale possono essere
#   impartiti comandi all'estrusore. L'impostazione predefinita è 170 gradi Celsius.
min_temp:
max_temp:
#   L'intervallo massimo di temperature valide (in gradi Celsius) in cui
#   il riscaldatore deve rimanere all'interno. Questo controlla una funzione di sicurezza
#   implementata nel codice del microcontrollore , la temperatura
#   non cadrà mai al di fuori di questo intervallo, altrimenti il microcontrollore
#   entrerà in uno stato di arresto. Questo controllo può aiutare a rilevarne alcuni
#   guasti hardware del riscaldatore e del sensore. Imposta questo intervallo solo in modo ampio
#   abbastanza in modo che temperature ragionevoli non si traducano in un errore.
#   Questi parametri devono essere forniti.
```

### [heater_bed]

La sezione heater_bed descrive un piatto riscaldato. Utilizza le stesse impostazioni del riscaldatore descritte nella sezione "extruder".

```
[heater_bed]
heater_pin:
sensor_type:
sensor_pin:
control:
min_temp:
max_temp:
#   Vedere la sezione "extruder" per una descrizione dei parametri sopra.
```

## Supporto livellamento del piatto

### [bed_mesh]

Mesh Bed Leveling. Si può definire una sezione di configurazione bed_mesh per abilitare trasformazioni di spostamento che sfalsano l'asse z in base a una mesh generata da punti sondati. Quando si utilizza una sonda per la posizione di riferimento sull'asse z, si consiglia di definire una sezione safe_z_home in printer.cfg per la posizione di riferimento verso il centro dell'area di stampa.

Per ulteriori informazioni, vedere la [bed mesh guide](Bed_Mesh.md) e [riferimento del comando](G-Codes.md#bed_mesh).

Esempi visivi:

```
 rectangular bed, probe_count = 3, 3:
             x---x---x (max_point)
             |
             x---x---x
                     |
 (min_point) x---x---x

 round bed, round_probe_count = 5, bed_radius = r:
                 x (0, r) end
               /
             x---x---x
                       \
 (-r, 0) x---x---x---x---x (r, 0)
           \
             x---x---x
                   /
                 x  (0, -r) start
```

```
[bed_mesh]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#mesh_radius:
#   Defines the radius of the mesh to probe for round beds. Note that
#   the radius is relative to the coordinate specified by the
#   mesh_origin option. This parameter must be provided for round beds
#   and omitted for rectangular beds.
#mesh_origin:
#   Defines the center X, Y coordinate of the mesh for round beds. This
#   coordinate is relative to the probe's location. It may be useful
#   to adjust the mesh_origin in an effort to maximize the size of the
#   mesh radius. Default is 0, 0. This parameter must be omitted for
#   rectangular beds.
#mesh_min:
#   Defines the minimum X, Y coordinate of the mesh for rectangular
#   beds. This coordinate is relative to the probe's location. This
#   will be the first point probed, nearest to the origin. This
#   parameter must be provided for rectangular beds.
#mesh_max:
#   Defines the maximum X, Y coordinate of the mesh for rectangular
#   beds. Adheres to the same principle as mesh_min, however this will
#   be the furthest point probed from the bed's origin. This parameter
#   must be provided for rectangular beds.
#probe_count: 3, 3
#   For rectangular beds, this is a comma separate pair of integer
#   values X, Y defining the number of points to probe along each
#   axis. A single value is also valid, in which case that value will
#   be applied to both axes. Default is 3, 3.
#round_probe_count: 5
#   For round beds, this integer value defines the maximum number of
#   points to probe along each axis. This value must be an odd number.
#   Default is 5.
#fade_start: 1.0
#   The gcode z position in which to start phasing out z-adjustment
#   when fade is enabled. Default is 1.0.
#fade_end: 0.0
#   The gcode z position in which phasing out completes. When set to a
#   value below fade_start, fade is disabled. It should be noted that
#   fade may add unwanted scaling along the z-axis of a print. If a
#   user wishes to enable fade, a value of 10.0 is recommended.
#   Default is 0.0, which disables fade.
#fade_target:
#   The z position in which fade should converge. When this value is
#   set to a non-zero value it must be within the range of z-values in
#   the mesh. Users that wish to converge to the z homing position
#   should set this to 0. Default is the average z value of the mesh.
#split_delta_z: .025
#   The amount of Z difference (in mm) along a move that will trigger
#   a split. Default is .025.
#move_check_distance: 5.0
#   The distance (in mm) along a move to check for split_delta_z.
#   This is also the minimum length that a move can be split. Default
#   is 5.0.
#mesh_pps: 2, 2
#   A comma separated pair of integers X, Y defining the number of
#   points per segment to interpolate in the mesh along each axis. A
#   "segment" can be defined as the space between each probed point.
#   The user may enter a single value which will be applied to both
#   axes. Default is 2, 2.
#algorithm: lagrange
#   The interpolation algorithm to use. May be either "lagrange" or
#   "bicubic". This option will not affect 3x3 grids, which are forced
#   to use lagrange sampling. Default is lagrange.
#bicubic_tension: .2
#   When using the bicubic algorithm the tension parameter above may
#   be applied to change the amount of slope interpolated. Larger
#   numbers will increase the amount of slope, which results in more
#   curvature in the mesh. Default is .2.
#zero_reference_position:
#   An optional X,Y coordinate that specifies the location on the bed
#   where Z = 0.  When this option is specified the mesh will be offset
#   so that zero Z adjustment occurs at this location.  The default is
#   no zero reference.
#faulty_region_1_min:
#faulty_region_1_max:
#   Optional points that define a faulty region.  See docs/Bed_Mesh.md
#   for details on faulty regions.  Up to 99 faulty regions may be added.
#   By default no faulty regions are set.
#adaptive_margin:
#   An optional margin (in mm) to be added around the bed area used by
#   the defined print objects when generating an adaptive mesh.
#scan_overshoot:
#  The maximum amount of travel (in mm) available outside of the mesh.
#  For rectangular beds this applies to travel on the X axis, and for round beds
#  it applies to the entire radius.  The tool must be able to travel the amount
#  specified outside of the mesh.  This value is used to optimize the travel
#  path when performing a "rapid scan".  The minimum value that may be specified
#  is 1.  The default is no overshoot.
```

### [bed_tilt]

Compensazione dell'inclinazione del piatto. Si può definire una sezione di configurazione bed_tilt per abilitare le trasformazioni di movimento che tengono conto di un piatto inclinato. Nota che bed_mesh e bed_tilt sono incompatibili; entrambi non possono essere definiti.

Per ulteriori informazioni, vedere [riferimento comando](G-Codes.md#bed_tilt).

```
[bed_tilt]
#x_adjust: 0
#   The amount to add to each move's Z height for each mm on the X
#   axis. The default is 0.
#y_adjust: 0
#   The amount to add to each move's Z height for each mm on the Y
#   axis. The default is 0.
#z_adjust: 0
#   The amount to add to the Z height when the nozzle is nominally at
#   0, 0. The default is 0.
# The remaining parameters control a BED_TILT_CALIBRATE extended
# g-code command that may be used to calibrate appropriate x and y
# adjustment parameters.
#points:
#   A list of X, Y coordinates (one per line; subsequent lines
#   indented) that should be probed during a BED_TILT_CALIBRATE
#   command. Specify coordinates of the nozzle and be sure the probe
#   is above the bed at the given nozzle coordinates. The default is
#   to not enable the command.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
```

### [bed_screws]

Strumento per aiutare a regolare le viti di livellamento del letto. Si può definire una sezione di configurazione [bed_screws] per abilitare un comando g-code BED_SCREWS_ADJUST.

Per ulteriori informazioni, vedere la [guida al livellamento](Manual_Level.md#adjusting-bed-leveling-screws) e il [riferimento al comando](G-Codes.md#bed_screws).

```
[bed_screws]
#screw1:
#   The X, Y coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to that is directly above the bed
#   screw (or as close as possible while still being above the bed).
#   This parameter must be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw1_fine_adjust:
#   An X, Y coordinate to command the nozzle to so that one can fine
#   tune the bed leveling screw. The default is to not perform fine
#   adjustments on the bed screw.
#screw2:
#screw2_name:
#screw2_fine_adjust:
#...
#   Additional bed leveling screws. At least three screws must be
#   defined.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   when moving from one screw location to the next. The default is 5.
#probe_height: 0
#   The height of the probe (in mm) after adjusting for the thermal
#   expansion of bed and nozzle. The default is zero.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#probe_speed: 5
#   The speed (in mm/s) when moving from a horizontal_move_z position
#   to a probe_height position. The default is 5.
```

### [screws_tilt_adjust]

Strumento per aiutare a regolare l'inclinazione delle viti del piatto utilizzando la sonda Z. Si può definire una sezione di configurazione Screws_tilt_adjust per abilitare un comando g-code SCREWS_TILT_CALCULATE.

Per ulteriori informazioni, vedere la [guida al livellamento](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe) e [riferimento al comando](G-Codes.md#screws_tilt_adjust).

```
[screws_tilt_adjust]
#screw1:
#   The (X, Y) coordinate of the first bed leveling screw. This is a
#   position to command the nozzle to so that the probe is directly
#   above the bed screw (or as close as possible while still being
#   above the bed). This is the base screw used in calculations. This
#   parameter must be provided.
#screw1_name:
#   An arbitrary name for the given screw. This name is displayed when
#   the helper script runs. The default is to use a name based upon
#   the screw XY location.
#screw2:
#screw2_name:
#...
#   Additional bed leveling screws. At least two screws must be
#   defined.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#screw_thread: CW-M3
#   The type of screw used for bed leveling, M3, M4, or M5, and the
#   rotation direction of the knob that is used to level the bed.
#   Accepted values: CW-M3, CCW-M3, CW-M4, CCW-M4, CW-M5, CCW-M5.
#   Default value is CW-M3 which most printers use. A clockwise
#   rotation of the knob decreases the gap between the nozzle and the
#   bed. Conversely, a counter-clockwise rotation increases the gap.
```

### [z_tilt]

Regolazione multipla dell'inclinazione dello stepper Z. Questa funzione consente la regolazione indipendente di più stepper z (vedere la sezione "stepper_z1") per regolare l'inclinazione. Se questa sezione è presente, diventa disponibile un [comando G-Code](G-Codes.md#z_tilt) esteso Z_TILT_ADJUST.

```
[z_tilt]
#z_positions:
#   Un elenco di coordinate X, Y (una per riga; le righe successive
#   identate) che descrivono la posizione di ciascun "pivot point"
#   del piattotto. Il "pivot point" è il punto in cui il piatto si attacca
#   al dato stepper Z. Viene descritto utilizzando le coordinate dell'ugello
#   (la posizione X, Y dell'ugello se potesse spostarsi direttamente sopra
#   il punto). La prima voce corrisponde a stepper_z, la seconda a
#   stepper_z1, la terza a stepper_z2, ecc.
#   Questo parametro deve essere fornito.
#points:
#   Un elenco di coordinate X, Y (una per riga; righe successive identate)
#   che devono essere rilevate durante un comando Z_TILT_ADJUST.
#   Specificare le coordinate dell'ugello e assicurarsi che la sonda sia
#   sopra il piatto alle coordinate dell'ugello date.
#   Questo parametro deve essere fornito.
#speed: 50
#   La velocità (in mm/s) degli spostamenti senza probing durante
#   la calibrazione. Il valore predefinito è 50.
#horizontal_move_z: 5
#   L'altezza (in mm) a cui la testa deve essere comandata per spostarsi
#   appena prima di avviare un'operazione di probing.
#   L'impostazione predefinita è 5.
#retries: 0
#   Numero di volte per riprovare se i punti rilevati non sono all'interno
#   della tolleranza.
#retry_tolerance: 0
#   Se i tentativi sono abilitati, riprovare se i punti sondati più grande e
#   più piccolo differiscono più di retry_tolerance. Nota che l'unità di
#   modifica più piccola qui sarebbe un singolo passaggio.
#   Tuttavia, se stai sondando più punti rispetto agli stepper,
#   probabilmente avrai un valore minimo fisso per l'intervallo di punti
#   sondati che puoi apprendere osservando l'output del comando.
```

### [quad_gantry_level]

Livellamento del gantly mediante 4 motori Z controllati in modo indipendente. Corregge gli effetti della parabola iperbolica (patatine fritte) sul portale mobile che è più flessibile. ATTENZIONE: l'utilizzo su un letto mobile può portare a risultati indesiderati. Se questa sezione è presente, diventa disponibile un comando G-Code esteso QUAD_GANTRY_LEVEL. Questa routine presuppone la seguente configurazione del motore Z:

```
 ----------------
 |Z1          Z2|
 |  ---------   |
 |  |       |   |
 |  |       |   |
 |  x--------   |
 |Z           Z3|
 ----------------
```

Dove x è il punto 0, 0 sul piatto

```
[quad_gantry_level]
#gantry_corners:
#   A newline separated list of X, Y coordinates describing the two
#   opposing corners of the gantry. The first entry corresponds to Z,
#   the second to Z2. This parameter must be provided.
#points:
#   A newline separated list of four X, Y points that should be probed
#   during a QUAD_GANTRY_LEVEL command. Order of the locations is
#   important, and should correspond to Z, Z1, Z2, and Z3 location in
#   order. This parameter must be provided. For maximum accuracy,
#   ensure your probe offsets are configured.
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
#max_adjust: 4
#   Safety limit if an adjustment greater than this value is requested
#   quad_gantry_level will abort.
#retries: 0
#   Number of times to retry if the probed points aren't within
#   tolerance.
#retry_tolerance: 0
#   If retries are enabled then retry if largest and smallest probed
#   points differ more than retry_tolerance.
```

### [skew_correction]

Correzione dell'inclinazione della stampante. È possibile utilizzare il software per correggere l'inclinazione della stampante su 3 piani, xy, xz, yz. Questo viene fatto stampando un modello di calibrazione lungo un piano e misurando tre lunghezze. A causa della natura della correzione dell'inclinazione, queste lunghezze vengono impostate tramite gcode. Per i dettagli, vedere [Correzione inclinazione](Correzione_inclinazione.md) e [Command Reference](G-Codes.md#correzione_inclinazione).

```
[skew_correction]
```

### [z_thermal_adjust]

Regolazione della posizione Z della testa di stampa in funzione della temperatura. Compensare il movimento verticale della testina utensile causato dall'espansione termica del telaio della stampante in tempo reale utilizzando un sensore di temperatura (tipicamente accoppiato a una sezione verticale del telaio).

Vedi anche: [comandi g-code estesi](G-Codes.md#z_thermal_adjust).

```
[z_thermal_adjust]
#temp_coeff:
#   Il coefficiente di dilatazione della temperatura, in mm/degC. Ad esempio, un
#   temp_coeff di 0,01 mm/degC sposterà l'asse Z verso il basso di 0,01 mm per ogni
#   grado Celsius di auemnto del sensore di temperatura . Il valore predefinito è
#   0,0 mm/degC, che non applica alcuna regolazione.
#smooth_time:
#   Finestra di smoothing applicata al sensore di temperatura, in secondi. Può
#   ridurre il rumore del motore da piccole correzioni eccessive in risposta al
#   rumore del sensore. Il valore predefinito è 2,0 secondi.
#z_adjust_off_above:
#   Disattiva le regolazioni al di sopra di questa altezza Z [mm]. L'ultima correzione
#   calcolata rimarrà applicata finché la testa utensile non si sposterà nuovamente
#   al di sotto dell'altezza Z specificata.
#   Il valore predefinito è 99999999,0 mm (sempre attivo).
#max_z_adjustment:
#   Massima regolazione assoluta applicabile all'asse Z [mm]. Il valore predefinito
#   è 99999999,0 mm (illimitato).
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Configurazione del sensore di temperatura. Vedere la sezione "extruder" per
#   la definizione dei parametri di cui sopra.
#gcode_id:
#   Vedere la sezione "heater_generic" per la definizione di questo parametro.
```

## Homing personalizzato

### [safe_z_home]

Homing Z sicuro. Si può utilizzare questo meccanismo per posizionare l'asse Z su una specifica coordinata X, Y. Ciò è utile se la testa portautensili, ad esempio, deve spostarsi al centro del letto prima che Z possa essere riposizionato.

```
[safe_z_home]
home_xy_position:
#   Una coordinata X, Y (ad es. 100, 100) dove deve essere eseguita
#   homing Z. Questo parametro deve essere fornito.
#speed: 50.0
#   Velocità alla quale la testa di stampa viene spostata sulla
#   coordinata Z sicura. Il valore predefinito è 50 mm/s
#z_hop:
#   Distanza (in mm) per sollevare l'asse Z prima dell'homing.
#   Questo si applica a qualsiasi comando di homing, anche se non
#   si trova sull'asse Z. Se l'asse Z è già azzerato e la posizione Z
#   corrente è inferiore a z_hop, questo solleverà la testa a un'altezza
#   di z_hop. Se l'asse Z non è già azzerato la testina viene sollevata
#   di z_hop. L'impostazione predefinita è di non implementare Z hop.
#z_hop_speed: 15.0
#   Velocità (in mm/s) alla quale l'asse Z viene sollevato prima
#   del homing. Il valore predefinito è 15 mm/s.
#move_to_previous: False
#   Quando è impostato su True, gli assi X e Y vengono ripristinati alle
#   posizioni precedenti dopo l'homing dell'asse Z.
#   L'impostazione predefinita è False.
```

### [homing_override]

Homing Override. Si può utilizzare questo meccanismo per eseguire una serie di comandi g-code al posto di un G28 che si trova nel normale input di g-code. Questo può essere utile su stampanti che richiedono una procedura specifica per l'home della macchina.

```
[homing_override]
gcode:
#   Un elenco di comandi G-Code da eseguire al posto dei comandi
#   G28 trovati nel normale input di G-Code.
#   Vedi docs/Command_Templates.md per il formato G-Code.
#   Se un G28 è contenuto in questo elenco di comandi, invocherà
#   la normale procedura di homing per la stampante. I comandi
#   qui elencati devono eseguire l'home di tutti gli assi.
#   Questo parametro deve essere fornito.
#axes: xyz
#   Gli assi da sovrascrivere. Ad esempio, se questo è impostato
#   su "z", lo script di override verrà eseguito solo quando l'asse z
#   è azzerato (ad esempio, tramite un comando "G28" o "G28 Z0").
#   Nota, lo script di sovrascrittura dovrebbe comunque ospitare
#   tutti gli assi. L'impostazione predefinita è "xyz" che fa sì che lo
#   script di override venga eseguito al posto di tutti i comandi G28.
#set_position_x:
#set_position_y:
#set_position_z:
#   Se specificato, la stampante presumerà che l'asse si trovi
#   nella posizione specificata prima di eseguire i comandi g-code
#   precedenti. L'impostazione di questa opzione disabilita i
#   controlli di riferimento per quell'asse. Questo può essere utile
#   se la testa deve muoversi prima di invocare il normale
#   meccanismo G28 per un asse. L'impostazione predefinita è
#   di non forzare una posizione per un asse.
```

### [endstop_phase]

Finecorsa regolati in fase stepper. Per utilizzare questa funzione, definire una sezione di configurazione con un prefisso "endstop_phase" seguito dal nome della corrispondente sezione di configurazione dello stepper (ad esempio, "[endstop_phase stepper_z]"). Questa funzione può migliorare la precisione degli interruttori di fine corsa. Aggiungi una semplice dichiarazione "[endstop_phase]" per abilitare il comando ENDSTOP_PHASE_CALIBRATE.

Per ulteriori informazioni, vedere la [endstop phases guide](Endstop_Phase.md) e [command reference](G-Codes.md#endstop_phase).

```
[endstop_phase stepper_z]
#endstop_accuracy:
#    Imposta la precisione prevista (in mm) del finecorsa. Questo rappresenta
#    la distanza massima di errore che il finecorsa può attivare (ad es. se un
#    finecorsa può occasionalmente attivarsi 100um in anticipo o fino a 100um in ritardo
#    quindi impostalo su 0,200 per 200 um). L'impostazione predefinita è
#    4*distanza_rotazione/passi_completi_per_rotazione.
#trigger_phase:
#    Questo specifica la fase del driver del motore passo-passo da aspettarsi
#    quando si raggiunge il finecorsa. È composto da due numeri separati
#    da un '/' - la fase e il numero totale di
#    fasi (ad es. "7/64"). Impostare questo valore solo se si è sicuri che il
#    driver del motore passo-passo viene ripristinato ogni volta che viene ripristinato l'mcu. Se questo
#    non è impostato, la prima fase verrà rilevata al primo home
#    e quella fase sarà utilizzata su tutte le abitazioni successive.
#endstop_align_zero: False
#    Se true, la posizione_endstop dell'asse sarà effettivamente
#    modificato in modo che la posizione zero dell'asse avvenga a passo pieno
#    sul motore. (Se utilizzato sull'asse Z e la stampa
#    l'altezza del livello è un multiplo di una distanza di un passo intero, allora ogni
#    layer si eseguirà in un step completo.) L'impostazione predefinita è False.
```

## Macro ed eventi G-Code

### [gcode_macro]

Macro G-Code (è possibile definire un numero qualsiasi di sezioni con un prefisso "gcode_macro"). Per ulteriori informazioni, consulta la [Guida ai modelli di comando](Command_Templates.md).

```
[gcode_macro my_cmd]
#gcode:
#   Un elenco di comandi G-Code da eseguire al posto di "my_cmd".
#   Vedi docs/Command_Templates.md per il formato G-Code.
#   Questo parametro deve essere fornito.
#variable_<name>:
#   Si può specificare un numero qualsiasi di opzioni con un prefisso
#   "variable_". Al nome della variabile data verrà assegnato il valore dato
#   (analizzato come un valore letterale Python) e sarà disponibile durante
#   l'espansione della macro. Ad esempio, una configurazione con
#   "variable_fan_speed = 75" potrebbe avere comandi gcode contenenti
#   "M106 S{ fan_speed * 255 }". Le variabili possono essere modificate in
#   fase di esecuzione utilizzando il comando SET_GCODE_VARIABLE
#   (consultare docs/Command_Templates.md per i dettagli).
#   I nomi delle variabili potrebbero non utilizzare caratteri maiuscoli.
#rename_existing:
#   Questa opzione farà sì che la macro ignori un comando G-Code
#   esistente e fornisca la definizione precedente del comando tramite
#   il nome fornito qui. Questo può essere usato per sovrascrivere i
#   comandi G-Code integrati. Prestare attenzione quando si ignorano
#   i comandi poiché possono causare risultati complessi e imprevisti.
#   L'impostazione predefinita è di non sovrascrivere un comando
#   G-Code esistente.
#description: G-Code macro
#   Ciò aggiungerà una breve descrizione utilizzata al comando HELP
#   o durante l'utilizzo della funzione di completamento automatico.
#   Predefinito "G-Code macro"
```

### [delayed_gcode]

Esegui un gcode con un ritardo impostato. Per ulteriori informazioni, consulta la [Guida template dei comandi](Command_Templates.md#delayed-gcodes) e [riferimento al comando](G-Codes.md#delayed_gcode).

```
[delayed_gcode my_delayed_gcode]
gcode:
#   A list of G-Code commands to execute when the delay duration has
#   elapsed. G-Code templates are supported. This parameter must be
#   provided.
#initial_duration: 0.0
#   The duration of the initial delay (in seconds). If set to a
#   non-zero value the delayed_gcode will execute the specified number
#   of seconds after the printer enters the "ready" state. This can be
#   useful for initialization procedures or a repeating delayed_gcode.
#   If set to 0 the delayed_gcode will not execute on startup.
#   Default is 0.
```

### [save_variables]

Supporta il salvataggio delle variabili su disco in modo che vengano mantenute durante i riavvii. Per ulteriori informazioni, vedere [template dei comandi](Command_Templates.md#save-variables-to-disk) e [G-Code reference](G-Codes.md#save_variables).

```
[save_variables]
filename:
#   Richiesto: fornire un nome file che verrebbe utilizzato per salvare
#   le variabili su disco, ad es. ~/variables.cfg
```

### [idle_timeout]

Timeout di inattività. Viene automaticamente abilitato un timeout di inattività: aggiungi una sezione di configurazione di idle_timeout esplicita per modificare le impostazioni predefinite.

```
[idle_timeout]
#gcode:
#   Un elenco di comandi G-Code da eseguire in un timeout di
#   inattività. Vedi docs/Command Templates.md per il formato
#   G-Code. L'impostazione predefinita è
#   eseguire "TURN_OFF HEATERS" e "M84".
#timeout: 600
#   Tempo di inattività (in secondi) da attendere prima di eseguire
#   i comandi G-Code sopra. Il valore predefinito è 600 secondi.
```

## Funzionalità opzionali G-Code

### [virtual_sdcard]

Una scheda SD virtuale può essere utile se la macchina host non è abbastanza veloce per eseguire bene OctoPrint. Consente al software host Klipper di stampare direttamente i file gcode archiviati in una directory sull'host utilizzando i comandi G-Code standard (ad esempio, M24).

```
[virtual_sdcard]
path:
#   The path of the local directory on the host machine to look for
#   g-code files. This is a read-only directory (sdcard file writes
#   are not supported). One may point this to OctoPrint's upload
#   directory (generally ~/.octoprint/uploads/ ). This parameter must
#   be provided.
#on_error_gcode:
#   A list of G-Code commands to execute when an error is reported.
#   See docs/Command_Templates.md for G-Code format. The default is to
#   run TURN_OFF_HEATERS.
```

### [sdcard_loop]

Alcune stampanti con funzionalità di pulizia del piatto, come un espulsore di parti o una stampante a nastro, possono trovare impiego nelle sezioni di loop del file sdcard. (Ad esempio, per stampare la stessa parte più e più volte, o ripetere la sezione a di una parte per una catena o un altro motivo ripetuto).

Consulta il [command reference](G-Codes.md#sdcard_loop) per i comandi supportati. Vedere il file [sample-macros.cfg](../config/sample-macros.cfg) per una macro M808 G-Code compatibile con Marlin.

```
[sdcard_loop]
```

### [force_move]

Supporta lo spostamento manuale dei motori passo-passo per scopi diagnostici. Nota, l'utilizzo di questa funzione potrebbe mettere la stampante in uno stato non valido - vedere il [command reference](G-Codes.md#force_move) per dettagli importanti.

```
[force_move]
#enable_force_move: False
#   Impostare su True per abilitare FORCE_MOVE e SET_KINEMATIC_POSITION
#   i comandi G-Code estesi. L'impostazione predefinita è False.
```

### [pause_resume]

Funzionalità di Pause/Resume con supporto di acquisizione e ripristino della posizione. Per ulteriori informazioni, vedere [riferimento comando](G-Codes.md#pause_resume).

```
[pause_resume]
#recover_velocity: 50.
#   Quando si abilita pause_resume, la velocità con cui tornare alla
#   posizione catturata (in mm/s). Il valore predefinito è 50,0 mm/s.
```

### [firmware_retraction]

Retrazione del filamento del firmware. Ciò abilita i comandi GCODE G10 (ritiro) e G11 (non ritirati) emessi da molti slicer. I parametri seguenti forniscono le impostazioni predefinite di avvio, sebbene i valori possano essere regolati tramite il [comando] SET_RETRACTION (G-Codes.md#firmware_retraction)), consentendo l'impostazione e l'ottimizzazione del filamento a runtime.

```
[firmware_retraction]
#retract_length: 0
#   La lunghezza del filamento (in mm) da ritrarre quando G10
#   è attivato e da ritrarre quando G11 è attivato (ma vedere
#   unretract_extra_length di seguito).
I#   l valore predefinito è 0 mm.
#retract_speed: 20
#   La velocità di retrazione, in mm/s.
#   Il valore predefinito è 20 mm/s.
#unretract_extra_length: 0
#   La lunghezza (in mm) del filamento *aggiuntivo* da
#   sommare quando non si ritrae.
#unretract_speed: 10
#   La velocità di srotolamento, in mm/s.
#   Il valore predefinito è 10 mm/s.
```

### [gcode_arcs]

Supporto per i comandi Gcode arc (G2/G3).

```
[gcode_arcs]
#resolution: 1.0
#   Un arco sarà diviso in segmenti. La lunghezza di ciascun segmento
#   sarà uguale alla risoluzione in mm impostata sopra. Valori più bassi
#   produrranno un arco più fine, ma anche più lavoro per la tua macchina.
#   Archi più piccoli del valore configurato diventerà linee rette.
#   L'impostazione predefinita è
#   1mm.
```

### [respond]

Abilita i comandi estesi "M118" e "RESPOND" [commands](G-Codes.md#respond).

```
[respond]
#default_type: echo
#   Imposta il prefisso predefinito dell'output "M118" e "RESPOND" su uno dei seguenti:
#       echo: "echo: " (Questa è l'impostazione predefinita)
#       command: "// "
#       error: "!! "
#default_prefix: echo:
#   Imposta direttamente il prefisso predefinito. Se presente
#   questo valore sovrascriverà il "default_type".
```

### [exclude_object]

Abilita il supporto per escludere o cancellare singoli oggetti durante il processo di stampa.

Per ulteriori informazioni, vedere la [guida escludi oggetti](Exclude_Object.md) e [riferimento ai comandi](G-Codes.md#excludeobject). Vedere il file [sample-macros.cfg](../config/sample-macros.cfg) per una macro G-Code M486 compatibile con Marlin/RepRapFirmware.

```
[exclude_object]
```

## Compensazione della risonanza

### [input_shaper]

Abilita [compensazione della risonanza](Resonance_Compensation.md). Vedere anche il [command reference](G-Codes.md#input_shaper).

```
[input_shaper]
#shaper_freq_x: 0
#   Una frequenza (in Hz) dell'input shaper per l'asse X. Questa è
#   solitamente una frequenza di risonanza dell'asse X che l'input
#   shaper dovrebbe sopprimere. Per shaper più complessi, come
#   shaper di input EI a 2 e 3 gobbe, questo parametro può essere
#   impostato in base a diverse considerazioni.
#   Il valore predefinito è 0, che disabilita la modellatura dell'input
#   per l'asse X.
#shaper_freq_y: 0
#   Una frequenza (in Hz) dell'input shaper per l'asse Y. Questa è
#   solitamente una frequenza di risonanza dell'asse Y che l'input
#   shaper dovrebbe sopprimere. Per shaper più complessi, come
#   shaper di input EI a 2 e 3 gobbe, questo parametro può essere
#   impostato in base a diverse considerazioni. Il valore predefinito
#   è 0, che disabilita la modellatura dell'input per l'asse Y.
#shaper_type: mzv
#   Un tipo di input shaper da utilizzare per entrambi gli assi X e Y.
#   Gli shaper supportati sono zv, mzv, zvd, ei, 2hump_ei e
#   3hump_ei. L'impostazione predefinita è mzv input shaper.
#shaper_type_x:
#shaper_type_y:
#   Se shaper_type non è impostato, questi due parametri possono
#   essere utilizzati per configurare diversi shaper di input per gli
#   assi X e Y. Sono supportati gli stessi valori del parametro
#   shaper_type.
#damping_ratio_x: 0.1
#damping_ratio_y: 0.1
#   Rapporti di smorzamento delle vibrazioni degli assi X e Y
#   utilizzati dagli shaper di input per migliorare la soppressione
#   delle vibrazioni. Il valore predefinito è 0,1, un buon valore per la
#   maggior parte delle stampanti. Nella maggior parte dei casi
#   questo parametro non richiede ottimizzazione e
#   non deve essere modificato.
```

### [adxl345]

Supporto per accelerometri ADXL345. Questo supporto consente di interrogare le misurazioni dell'accelerometro dal sensore. Ciò abilita un comando ACCELEROMETER_MEASURE (consultare [G-Codes](G-Codes.md#adxl345) per ulteriori informazioni). Il nome del chip predefinito è "predefinito", ma è possibile specificare un nome esplicito (ad esempio, [adxl345 my_chip_name]).

```
[adxl345]
cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#axes_map: x, y, z
#   The accelerometer axis for each of the printer's X, Y, and Z axes.
#   This may be useful if the accelerometer is mounted in an
#   orientation that does not match the printer orientation. For
#   example, one could set this to "y, x, z" to swap the X and Y axes.
#   It is also possible to negate an axis if the accelerometer
#   direction is reversed (eg, "x, z, -y"). The default is "x, y, z".
#rate: 3200
#   Output data rate for ADXL345. ADXL345 supports the following data
#   rates: 3200, 1600, 800, 400, 200, 100, 50, and 25. Note that it is
#   not recommended to change this rate from the default 3200, and
#   rates below 800 will considerably affect the quality of resonance
#   measurements.
```

### [lis2dw]

Support for LIS2DW accelerometers.

```
[lis2dw]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [lis3dh]

Support for LIS3DH accelerometers.

```
[lis3dh]
#cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided
#   if using SPI.
#spi_speed: 5000000
#   The SPI speed (in hz) to use when communicating with the chip.
#   The default is 5000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#i2c_address:
#   Default is 25 (0x19). If SA0 is high, it would be 24 (0x18) instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [mpu9250]

Supporto per accelerometri MPU-9250, MPU-9255, MPU-6515, MPU-6050 e MPU-6500 (è possibile definire un numero qualsiasi di sezioni con un prefisso "mpu9250").

```
[mpu9250 my_accelerometer]
#i2c_address:
#   Default is 104 (0x68). If AD0 is high, it would be 0x69 instead.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed: 400000
#   See the "common I2C settings" section for a description of the
#   above parameters. The default "i2c_speed" is 400000.
#axes_map: x, y, z
#   See the "adxl345" section for information on this parameter.
```

### [resonance_tester]

Supporto per test di risonanza e calibrazione automatica del input shaper. Per utilizzare la maggior parte delle funzionalità di questo modulo, devono essere installate dipendenze software aggiuntive; fare riferimento a [Measuring Resonances](Measuring_Resonances.md) e al [command reference](G-Codes.md#resonance_tester) per ulteriori informazioni. Per ulteriori informazioni sul parametro `max_smoothing` e sul suo utilizzo, vedere la sezione [Max smoothing](Measuring_Resonances.md#max-smoothing) della guida alla misurazione delle risonanze.

```
[resonance_tester]
#probe_points:
#   A list of X, Y, Z coordinates of points (one point per line) to test
#   resonances at. At least one point is required. Make sure that all
#   points with some safety margin in XY plane (~a few centimeters)
#   are reachable by the toolhead.
#accel_chip:
#   A name of the accelerometer chip to use for measurements. If
#   adxl345 chip was defined without an explicit name, this parameter
#   can simply reference it as "accel_chip: adxl345", otherwise an
#   explicit name must be supplied as well, e.g. "accel_chip: adxl345
#   my_chip_name". Either this, or the next two parameters must be
#   set.
#accel_chip_x:
#accel_chip_y:
#   Names of the accelerometer chips to use for measurements for each
#   of the axis. Can be useful, for instance, on bed slinger printer,
#   if two separate accelerometers are mounted on the bed (for Y axis)
#   and on the toolhead (for X axis). These parameters have the same
#   format as 'accel_chip' parameter. Only 'accel_chip' or these two
#   parameters must be provided.
#max_smoothing:
#   Maximum input shaper smoothing to allow for each axis during shaper
#   auto-calibration (with 'SHAPER_CALIBRATE' command). By default no
#   maximum smoothing is specified. Refer to Measuring_Resonances guide
#   for more details on using this feature.
#move_speed: 50
#   The speed (in mm/s) to move the toolhead to and between test points
#   during the calibration. The default is 50.
#min_freq: 5
#   Minimum frequency to test for resonances. The default is 5 Hz.
#max_freq: 133.33
#   Maximum frequency to test for resonances. The default is 133.33 Hz.
#accel_per_hz: 60
#   This parameter is used to determine which acceleration to use to
#   test a specific frequency: accel = accel_per_hz * freq. Higher the
#   value, the higher is the energy of the oscillations. Can be set to
#   a lower than the default value if the resonances get too strong on
#   the printer. However, lower values make measurements of
#   high-frequency resonances less precise. The default value is 75
#   (mm/sec).
#hz_per_sec: 1
#   Determines the speed of the test. When testing all frequencies in
#   range [min_freq, max_freq], each second the frequency increases by
#   hz_per_sec. Small values make the test slow, and the large values
#   will decrease the precision of the test. The default value is 1.0
#   (Hz/sec == sec^-2).
#sweeping_accel: 400
#   An acceleration of slow sweeping moves. The default is 400 mm/sec^2.
#sweeping_period: 1.2
#   A period of slow sweeping moves. Setting this parameter to 0
#   disables slow sweeping moves. Avoid setting it to a too small
#   non-zero value in order to not poison the measurements.
#   The default is 1.2 sec which is a good all-round choice.
```

## Helper per i file di configurazione

### [board_pins]

Alias pin board (si può definire un numero qualsiasi di sezioni con un prefisso "board_pins"). Usalo per definire gli alias per i pin su un microcontrollore.

```
[board_pins my_aliases]
mcu: mcu
#   A comma separated list of micro-controllers that may use the
#   aliases. The default is to apply the aliases to the main "mcu".
aliases:
aliases_<name>:
#   A comma separated list of "name=value" aliases to create for the
#   given micro-controller. For example, "EXP1_1=PE6" would create an
#   "EXP1_1" alias for the "PE6" pin. However, if "value" is enclosed
#   in "<>" then "name" is created as a reserved pin (for example,
#   "EXP1_9=<GND>" would reserve "EXP1_9"). Any number of options
#   starting with "aliases_" may be specified.
```

### [include]

Supporto per includere i file. Uno può includere un file di configurazione aggiuntivo dal file di configurazione della stampante principale. Possono essere utilizzati anche caratteri jolly (ad es. "configs/*.cfg").

```
[include my_other_config.cfg]
```

### [duplicate_pin_override]

Questo strumento consente di definire più volte un singolo pin del microcontrollore in un file di configurazione senza il normale controllo degli errori. Questo è inteso per scopi diagnostici e di debug. Questa sezione non è necessaria laddove Klipper supporta l'utilizzo dello stesso pin più volte e l'utilizzo di questa sostituzione può causare risultati confusi e imprevisti.

```
[duplicate_pin_override]
pins:
#   Un elenco di pin separato da virgole che possono essere utilizzati più volte in
#   un file di configurazione senza normali controlli degli errori. Questo parametro deve essere
#   fornito.
```

## Hardware per probing del piatto

### [probe]

Sonda di altezza Z. Si può definire questa sezione per abilitare l'hardware di rilevamento dell'altezza Z. Quando questa sezione è abilitata, i comandi estesi PROBE e QUERY_PROBE  [comandi g-code](G-Codes.md#probe) diventano disponibili. Inoltre, vedere la [Guida alla calibrazione della sonda](Probe_Calibrate.md). La sezione probe crea anche un pin virtuale "probe:z_virtual_endstop". Si può impostare stepper_z endstop_pin su questo pin virtuale su stampanti in stile cartesiano che utilizzano la sonda al posto di un endstop z. Se si utilizza "probe:z_virtual_endstop", non definire un position_endstop nella sezione di configurazione stepper_z.

```
[probe]
pin:
#   Pin di rilevamento della sonda. Se il pin si trova su un
#   microcontrollore diverso rispetto agli stepper Z, abilita
#   "homing multi-mcu". Questo parametro deve essere fornito.
#deactivate_on_each_sample: True
#   Questo determina se Klipper deve eseguire la disattivazione
#   gcode tra ogni tentativo di esplorazione durante l'esecuzione di
#   una sequenza di probe multiple. L'impostazione predefinita è True.
#x_offset: 0.0
#   La distanza (in mm) tra la sonda e l'ugello lungo l'asse x.
#   Il valore predefinito è 0.
#y_offset: 0.0
#   La distanza (in mm) tra la sonda e l'ugello lungo l'asse y.
#   Il valore predefinito è 0.
z_offset:
#   La distanza (in mm) tra il piatto e l'ugello quando la sonda si attiva.
#   Questo parametro deve essere fornito.
#speed: 5.0
#   Velocità (in mm/s) dell'asse Z durante probing.
#   Il valore predefinito è 5 mm/s.
#samples: 1
#   Il numero di volte in cui sondare ciascun punto. I valori z sondati
#   verranno mediati. L'impostazione predefinita è sondare 1 volta.
#sample_retract_dist: 2.0
#   La distanza (in mm) per sollevare la testa di stampa tra ciascun
#   campione (se si esegue il campionamento più di una volta).
#   Il valore predefinito è 2 mm.
#lift_speed:
#   Velocità (in mm/s) dell'asse Z durante il sollevamento della sonda
#   tra i campioni. L'impostazione predefinita prevede l'utilizzo dello
#   stesso valore del parametro 'speed'.
#samples_result: average
#   Il metodo di calcolo durante il campionamento più di una volta:
#   "median" o "average". L'impostazione predefinita è average.
#samples_tolerance: 0.100
#   La distanza Z massima (in mm) che un campione può differire da
#   altri campioni. Se questa tolleranza viene superata, viene segnalato
#   un errore o il tentativo viene riavviato
#   (vedere samples_tolerance_retries). Il valore predefinito è 0,100 mm.
#samples_tolerance_retries: 0
#   Il numero di tentativi per riprovare se viene trovato un campione che
#   supera samples_tolerance. In un nuovo tentativo, tutti i campioni
#   correnti vengono eliminati e il tentativo di sonda viene riavviato.
#   Se non si ottiene un insieme valido di campioni nel numero di tentativi
#   specificato, viene segnalato un errore. Il valore predefinito è zero che
#   causa la segnalazione di un errore sul primo campione che supera
#   samples_tolerance.
#activate_gcode:
#   Un elenco di comandi G-Code da eseguire prima di ogni tentativo di
#   esplorazione. Vedi docs/Command_Templates.md per il formato
#   G-Code. Questo può essere utile se la sonda deve essere attivata in
#   qualche modo. Non impartire qui alcun comando che sposti la testa
#   di stampa (ad es. G1). L'impostazione predefinita è di non eseguire
#   alcun comando G-Code speciale all'attivazione.
#deactivate_gcode:
#   Un elenco di comandi G-Code da eseguire dopo il completamento di
#   ogni tentativo di esplorazione. Vedi docs/Command_Templates.md
#   per il formato G-Code. Non impartire qui alcun comando che sposti
#   la testina. L'impostazione predefinita è di non eseguire alcun
#   comando G-Code speciale alla disattivazione.
```

### [bltouch]

Sonda BLTouch. Si può definire questa sezione (anziché una sezione sonda) per abilitare una sonda BLTouch. Per ulteriori informazioni, vedere [BL-Touch guide](BLTouch.md) e [command reference](G-Codes.md#bltouch).. Viene anche creato un pin virtuale "probe:z_virtual_endstop" (consultare la sezione "probe" per i dettagli).

```
[bltouch]
sensor_pin:
#   Pin connected to the BLTouch sensor pin. Most BLTouch devices
#   require a pullup on the sensor pin (prefix the pin name with "^").
#   This parameter must be provided.
control_pin:
#   Pin connected to the BLTouch control pin. This parameter must be
#   provided.
#pin_move_time: 0.680
#   The amount of time (in seconds) to wait for the BLTouch pin to
#   move up or down. The default is 0.680 seconds.
#stow_on_each_sample: True
#   This determines if Klipper should command the pin to move up
#   between each probe attempt when performing a multiple probe
#   sequence. Read the directions in docs/BLTouch.md before setting
#   this to False. The default is True.
#probe_with_touch_mode: False
#   If this is set to True then Klipper will probe with the device in
#   "touch_mode". The default is False (probing in "pin_down" mode).
#pin_up_reports_not_triggered: True
#   Set if the BLTouch consistently reports the probe in a "not
#   triggered" state after a successful "pin_up" command. This should
#   be True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#pin_up_touch_mode_reports_triggered: True
#   Set if the BLTouch consistently reports a "triggered" state after
#   the commands "pin_up" followed by "touch_mode". This should be
#   True for all genuine BLTouch devices. Read the directions in
#   docs/BLTouch.md before setting this to False. The default is True.
#set_output_mode:
#   Request a specific sensor pin output mode on the BLTouch V3.0 (and
#   later). This setting should not be used on other types of probes.
#   Set to "5V" to request a sensor pin output of 5 Volts (only use if
#   the controller board needs 5V mode and is 5V tolerant on its input
#   signal line). Set to "OD" to request the sensor pin output use
#   open drain mode. The default is to not request an output mode.
#x_offset:
#y_offset:
#z_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

### [smart_effector]

Lo "Smart Effector" di Duet3d implementa una sonda Z utilizzando un sensore di forza. Si può definire questa sezione invece di `[probe]` per abilitare le funzioni specifiche di Smart Effector. Ciò consente anche a [comandi di runtime](G-Codes.md#smart_effector) di regolare i parametri di Smart Effector in fase di esecuzione.

```
[smart_effector]
pin:
#   Pin collegato al pin di uscita della sonda Z Smart Effector (pin 5). Si noti
#   che la resistenza di pullup sulla scheda generalmente non è richiesta.
#   Tuttavia, se il pin di uscita è collegato al pin della scheda con un resistore
#   di pullup, tale resistore deve essere di valore elevato (ad es. 10K Ohm o più).
#   Alcune schede hanno un resistore di pullup di basso valore sull'ingresso
#   della sonda Z, che probabilmente farà risultare in uno stato di sonda sempre
#   attivato. In questo caso, collegare lo Smart Effector a un pin diverso sulla
#   scheda. Questo parametro è obbligatorio.
#control_pin:
#   Pin collegato al pin di ingresso di controllo Smart Effector (pin 7). Se fornito,
#   diventano disponibili i comandi di programmazione della sensibilità
#   di Smart Effector.
#probe_accel:
#   Se impostato, limita l'accelerazione dei movimenti di tastatura (in mm/sec^2).
#   Un'improvvisa grande accelerazione all'inizio del movimento di esplorazione
#   può causare l'attivazione spuria della sonda, specialmente se l'hotend è pesante.
#   Per evitarlo, potrebbe essere necessario ridurre l'accelerazione dei movimenti
#   di tastatura tramite questo parametro.
#recovery_time: 0.4
#   Un ritardo tra i movimenti di spostamento e tastatura in secondi. Un
#   movimento veloce prima della tastatura può causare l'attivazione spuria della
#   sonda. Ciò può causare errori "Sonda attivata prima del movimento" se non
#   è impostato alcun ritardo. Il valore 0 disabilita il ritardo di ripristino.
#   Il valore predefinito è 0.4.
#x_offset:
#y_offset:
#   Dovrebbe essere lasciato non impostato (o impostato su 0).
z_offset:
#   Altezza di attivazione della sonda. Inizia con -0.1 (mm) e regola in seguito
#   usando il comando `PROBE_CALIBRATE`. Questo parametro deve essere fornito.
#speed:
#   Velocità (in mm/s) dell'asse Z durante la tastatura. Si consiglia di iniziare con la
#   velocità di tastatura di 20 mm/s e di regolarla secondo necessità per migliorare la
#   precisione e la ripetibilità dell'attivazione della sonda.
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#activate_gcode:
#deactivate_gcode:
#deactivate_on_each_sample:
#   Vedere la sezione "probe" per ulteriori informazioni sui parametri di cui sopra.
```

### [probe_eddy_current]

Support for eddy current inductive probes. One may define this section (instead of a probe section) to enable this probe. See the [command reference](G-Codes.md#probe_eddy_current) for further information.

```
[probe_eddy_current my_eddy_probe]
sensor_type: ldc1612
#   The sensor chip used to perform eddy current measurements. This
#   parameter must be provided and must be set to ldc1612.
#intb_pin:
#   MCU gpio pin connected to the ldc1612 sensor's INTB pin (if
#   available). The default is to not use the INTB pin.
#z_offset:
#   The nominal distance (in mm) between the nozzle and bed that a
#   probing attempt should stop at. This parameter must be provided.
#i2c_address:
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   The i2c settings for the sensor chip. See the "common I2C
#   settings" section for a description of the above parameters.
#x_offset:
#y_offset:
#speed:
#lift_speed:
#samples:
#sample_retract_dist:
#samples_result:
#samples_tolerance:
#samples_tolerance_retries:
#   See the "probe" section for information on these parameters.
```

### [axis_twist_compensation]

A tool to compensate for inaccurate probe readings due to twist in X or Y gantry. See the [Axis Twist Compensation Guide](Axis_Twist_Compensation.md) for more detailed information regarding symptoms, configuration and setup.

```
[axis_twist_compensation]
#speed: 50
#   The speed (in mm/s) of non-probing moves during the calibration.
#   The default is 50.
#horizontal_move_z: 5
#   The height (in mm) that the head should be commanded to move to
#   just prior to starting a probe operation. The default is 5.
calibrate_start_x: 20
#   Defines the minimum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the starting
#   calibration position.
calibrate_end_x: 200
#   Defines the maximum X coordinate of the calibration
#   This should be the X coordinate that positions the nozzle at the ending
#   calibration position.
calibrate_y: 112.5
#   Defines the Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle during the
#   calibration process. This parameter is recommended to
#   be near the center of the bed

# For Y-axis twist compensation, specify the following parameters:
calibrate_start_y: ...
#   Defines the minimum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the starting
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_end_y: ...
#   Defines the maximum Y coordinate of the calibration
#   This should be the Y coordinate that positions the nozzle at the ending
#   calibration position for the Y axis. This parameter must be provided if
#   compensating for Y axis twist.
calibrate_x: ...
#   Defines the X coordinate of the calibration for Y axis twist compensation
#   This should be the X coordinate that positions the nozzle during the
#   calibration process for Y axis twist compensation. This parameter must be
#   provided and is recommended to be near the center of the bed.
```

## Motori passo-passo ed estrusori aggiuntivi

### [stepper_z1]

Assi multi-stepper. Su una stampante in stile cartesiano, lo stepper che controlla un dato asse può avere blocchi di configurazione aggiuntivi che definiscono gli stepper che dovrebbero essere azionati insieme allo stepper primario. Si può definire un numero qualsiasi di sezioni con un suffisso numerico che inizia da 1 (ad esempio, "stepper_z1", "stepper_z2", ecc.).

```
[stepper_z1]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   Vedere la sezione "stepper" per la definizione dei parametri di cui sopra.
#endstop_pin:
#   Se viene definito un endstop_pin per lo stepper aggiuntivo, lo stepper
#   si fermerà fino all'attivazione dell'endstop. In caso contrario, lo stepper
#   si fermerà fino a quando non verrà attivato il finecorsa sullo stepper
#   primario per l'asse.
```

### [extruder1]

In una stampante multiestrusore aggiungere una sezione estrusore aggiuntiva per ogni estrusore aggiuntivo. Le sezioni aggiuntive dell'estrusore devono essere denominate "extruder1", "extruder2", "extruder3" e così via. Vedere la sezione "extruder" per una descrizione dei parametri disponibili.

Vedere [sample-multi-extruder.cfg](../config/sample-multi-extruder.cfg) per un esempio di configurazione.

```
[extruder1]
#step_pin:
#dir_pin:
#...
#   Vedere la sezione "estrusore" per i parametri per lo stepper e il riscaldatore
#   disponibili.
#shared_heater:
#   Questa opzione è obsoleta e non deve più essere specificata.
```

### [dual_carriage]

Support for cartesian and hybrid_corexy/z printers with dual carriages on a single axis. The carriage mode can be set via the SET_DUAL_CARRIAGE extended g-code command. For example, "SET_DUAL_CARRIAGE CARRIAGE=1" command will activate the carriage defined in this section (CARRIAGE=0 will return activation to the primary carriage). Dual carriage support is typically combined with extra extruders - the SET_DUAL_CARRIAGE command is often called at the same time as the ACTIVATE_EXTRUDER command. Be sure to park the carriages during deactivation. Note that during G28 homing, typically the primary carriage is homed first followed by the carriage defined in the `[dual_carriage]` config section. However, the `[dual_carriage]` carriage will be homed first if both carriages home in a positive direction and the [dual_carriage] carriage has a `position_endstop` greater than the primary carriage, or if both carriages home in a negative direction and the `[dual_carriage]` carriage has a `position_endstop` less than the primary carriage.

Inoltre, è possibile utilizzare i comandi "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=COPY" o "SET_DUAL_CARRIAGE CARRIAGE=1 MODE=MIRROR" per attivare la modalità di copia o di mirroring del doppio carrello, nel qual caso seguirà di conseguenza il movimento del carrello 0 . Questi comandi possono essere utilizzati per stampare due parti contemporaneamente: due parti identiche (in modalità COPIA) o parti specchiate (in modalità SPECCHIO). Tieni presente che le modalità COPY e MIRROR richiedono anche la configurazione appropriata dell'estrusore sul doppio carrello, che in genere può essere ottenuta con "SYNC_EXTRUDER_MOTION MOTION_QUEUE=extruder EXTRUDER=<dual_carriage_extruder>" o un comando simile.

Vedere [sample-idex.cfg](../config/sample-idex.cfg) per un esempio di configurazione.

```
[dual_carriage]
axis:
#   The axis this extra carriage is on (either x or y). This parameter
#   must be provided.
#safe_distance:
#   The minimum distance (in mm) to enforce between the dual and the primary
#   carriages. If a G-Code command is executed that will bring the carriages
#   closer than the specified limit, such a command will be rejected with an
#   error. If safe_distance is not provided, it will be inferred from
#   position_min and position_max for the dual and primary carriages. If set
#   to 0 (or safe_distance is unset and position_min and position_max are
#   identical for the primary and dual carraiges), the carriages proximity
#   checks will be disabled.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#endstop_pin:
#position_endstop:
#position_min:
#position_max:
#   See the "stepper" section for the definition of the above parameters.
```

### [extruder_stepper]

Supporto per stepper aggiuntivi sincronizzati al movimento di un estrusore (si può definire un numero qualsiasi di sezioni con un prefisso "extruder_stepper").

Per ulteriori informazioni, vedere [riferimento comando](G-Codes.md#extruder).

```
[extruder_stepper my_extra_stepper]
extruder:
#   L'estrusore con cui è sincronizzato questo stepper. Se questo è impostato su
#   una stringa vuota, lo stepper non verrà sincronizzato con un
#   estrusore. Questo parametro deve essere fornito.
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
# Vedere la sezione "stepper" per la definizione dei parametri sopra.
# .
```

### [Stepper manuali]

Stepper manuali (è possibile definire un numero qualsiasi di sezioni con un prefisso "manual_stepper"). Questi sono stepper controllati dal comando g-code MANUAL_STEPPER. Ad esempio: "MANUAL_STEPPER STEPPER=my_stepper MOVE=10 SPEED=5". Vedere il file [G-Codes](G-Codes.md#manual_stepper) per una descrizione del comando MANUAL_STEPPER. Gli stepper non sono collegati alla normale cinematica della stampante.

```
[manual_stepper my_stepper]
#step_pin:
#dir_pin:
#enable_pin:
#microsteps:
#rotation_distance:
#   Vedere la sezione "stepper" per una descrizione di questi parametri.
#velocity:
#   Impostare la velocità predefinita (in mm/s) per lo stepper. Questo
#   valore verrà utilizzato se un comando MANUAL_STEPPER non specifica
#   un parametro SPEED. Il valore predefinito è 5 mm/s.
#accel:
#   Imposta l'accelerazione predefinita (in mm/s^2) per lo stepper.
#   Un'accelerazione pari a zero non risulterà in nessuna accelerazione.
#   Questo valore verrà utilizzato se un comando MANUAL_STEPPER non
#   specifica un parametro ACCEL. Il valore predefinito è zero.
#endstop_pin:
#   Pin di rilevamento interruttore di fine corsa. Se specificato, è possibile
#   eseguire "movimenti di riferimento" aggiungendo un parametro
#   STOP_ON_ENDSTOP ai comandi di movimento MANUAL_STEPPER.
```

## Riscaldatori e sensori personalizzati

### [verify_heater]

Verifica riscaldatore e sensore di temperatura. La verifica del riscaldatore viene abilitata automaticamente per ogni riscaldatore configurato sulla stampante. Usa le sezioni di verifica_riscaldatore per modificare le impostazioni predefinite.

```
[verify_heater heater_config_name]
#max_error: 120
#   Il massimo "errore di temperatura cumulativo" prima di generare un
#   errore. Valori più piccoli comportano un controllo più rigoroso e valori
#   più grandi consentono più tempo prima che venga segnalato un errore.
#   Nello specifico la temperatura viene osservata una volta al secondo e
#   se è prossima alla temperatura target viene azzerato un "contatore errori"
#   interno; in caso contrario, se la temperatura è inferiore all'intervallo target,
#   il contatore viene aumentato della quantità in cui la temperatura riportata
#   differisce da tale intervallo. Se il contatore supera questo "errore_max",
#   viene generato un errore. Il valore predefinito è 120.
#check_gain_time:
#   Questo controlla la verifica del riscaldatore durante il riscaldamento
#   iniziale. Valori più piccoli comportano un controllo più rigoroso e valori
#   più grandi consentono più tempo prima che venga segnalato un errore.
#   In particolare, durante il riscaldamento iniziale, fintanto che il riscaldatore
#   aumenta di temperatura entro questo intervallo di tempo (specificato in
#   secondi), il "contatore errori" interno viene azzerato. Il valore predefinito
#   è 20 secondi per gli estrusori e 60 secondi per heater_bed.
#hysteresis: 5
#   La differenza di temperatura massima (in gradi Celsius) rispetto a una
#   temperatura target considerata nell'intervallo del target. Questo controlla
#   nell'intervallo max_error. È raro personalizzare questo valore.
#   L'impostazione predefinita è 5.
#heating_gain: 2
#   La temperatura minima (in gradi Celsius) di cui il riscaldatore deve
#   aumentare durante il check_gain_time. È raro personalizzare questo valore.
#   L'impostazione predefinita è 2.
```

### [homing_heaters]

Strumento per disabilitare i riscaldatori durante l'homing o la probing di un asse.

```
[homing_heaters]
#steppers:
#   Un elenco separato da virgole di stepper che dovrebbero causare
#   la disattivazione dei riscaldatori. L'impostazione predefinita è
#   disabilitare i riscaldatori per qualsiasi spostamento di homing/sonda.
#   Esempio tipico: stepper_z
#heaters:
#   Un elenco separato da virgole di riscaldatori da disabilitare
#   durante i movimenti di homing/probing. L'impostazione
#   predefinita è disabilitare tutti i riscaldatori.
#   Esempio tipico: estrusore, letto riscaldatore
```

### [thermistor]

Termistori personalizzati (si può definire un numero qualsiasi di sezioni con un prefisso "thermistor"). È possibile utilizzare un termistore personalizzato nel campo sensor_type di una sezione di configurazione del riscaldatore. (Ad esempio, se si definisce una sezione "[thermistor my_thermistor]", è possibile utilizzare un "sensor_type: my_thermistor" quando si definisce un riscaldatore.) Assicurati di posizionare la sezione del termistore nel file di configurazione sopra il suo primo utilizzo in una sezione del riscaldatore .

```
[thermistor my_thermistor]
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#temperature3:
#resistance3:
#   Tre misure di resistenza (in Ohm) alle temperature date (in Celsius).
#   Le tre misurazioni verranno utilizzate per calcolare i coefficienti di
#   Steinhart-Hart per il termistore. Questi parametri devono essere
#   forniti quando si utilizza Steinhart-Hart per definire il termistore.
#beta:
#   In alternativa, è possibile definire temperatura1, resistenza1 e beta
#   per definire i parametri del termistore. Questo parametro deve
#   essere fornito quando si utilizza "beta" per definire il termistore.
```

### [adc_temperature]

Sensori di temperatura ADC personalizzati (si può definire un numero qualsiasi di sezioni con un prefisso "adc_temperature"). Ciò consente di definire un sensore di temperatura personalizzato che misura una tensione su un pin del convertitore da analogico a digitale (ADC) e utilizza l'interpolazione lineare tra una serie di misurazioni di temperatura/tensione (o temperatura/resistenza) configurate per determinare la temperatura. Il sensore risultante può essere utilizzato come tipo_sensore in una sezione riscaldatore. (Ad esempio, se si definisce una sezione "[adc_temperature my_sensor]", è possibile utilizzare un "sensor_type: my_sensor" quando si definisce un riscaldatore.) Assicurati di posizionare la sezione del sensore nel file di configurazione sopra il suo primo utilizzo in una sezione del riscaldatore.

```
[adc_temperature my_sensor]
#temperature1:
#voltage1:
#temperature2:
#voltage2:
#...
#   A set of temperatures (in Celsius) and voltages (in Volts) to use
#   as reference when converting a temperature. A heater section using
#   this sensor may also specify adc_voltage and voltage_offset
#   parameters to define the ADC voltage (see "Common temperature
#   amplifiers" section for details). At least two measurements must
#   be provided.
#temperature1:
#resistance1:
#temperature2:
#resistance2:
#...
#   Alternatively one may specify a set of temperatures (in Celsius)
#   and resistance (in Ohms) to use as reference when converting a
#   temperature. A heater section using this sensor may also specify a
#   pullup_resistor parameter (see "extruder" section for details). At
#   least two measurements must be provided.
```

### [heater_generic]

Riscaldatori generici (si può definire un numero qualsiasi di sezioni con il prefisso "riscaldatore_generico"). Questi riscaldatori si comportano in modo simile ai riscaldatori standard (estrusori, piatti riscaldati). Utilizzare il comando SET_HEATER_TEMPERATURE (consultare [G-Codes](G-Codes.md#heaters) per i dettagli) per impostare la temperatura target.

```
[heater_generic my_generic_heater]
#gcode_id:
#   L'ID da utilizzare quando si riporta la temperatura nel comando M105.
#   Questo parametro deve essere fornito.
#max_power:
#sensor_type:
#sensor_pin:
#smooth_time:
#control:
#pid_Kp:
#pid_Ki:
#pid_Kd:
#pwm_cycle_time:
#min_temp:
#max_temp:
#   Vedere la sezione "extruder" per la definizione dei parametri sopra.
```

### [temperature_sensor]

Sensori di temperatura generici. È possibile definire un numero qualsiasi di sensori di temperatura aggiuntivi che vengono riportati tramite il comando M105.

```
[temperature_sensor my_sensor]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Vedi la sezione "extruder" per la definizione dei parametri
#   sopra indicati.
#gcode_id:
#   Vedi la sezione "heater_generic" per la definizione dei
#   parametri sopra indicati.
```

### [temperature_probe]

Reports probe coil temperature. Includes optional thermal drift calibration for eddy current based probes. A `[temperature_probe]` section may be linked to a `[probe_eddy_current]` by using the same postfix for both sections.

```
[temperature_probe my_probe]
#sensor_type:
#sensor_pin:
#min_temp:
#max_temp:
#   Temperature sensor configuration.
#   See the "extruder" section for the definition of the above
#   parameters.
#smooth_time:
#   A time value (in seconds) over which temperature measurements will
#   be smoothed to reduce the impact of measurement noise. The default
#   is 2.0 seconds.
#gcode_id:
#   See the "heater_generic" section for the definition of this
#   parameter.
#speed:
#   The travel speed [mm/s] for xy moves during calibration.  Default
#   is the speed defined by the probe.
#horizontal_move_z:
#   The z distance [mm] from the bed at which xy moves will occur
#   during calibration. Default is 2mm.
#resting_z:
#   The z distance [mm] from the bed at which the tool will rest
#   to heat the probe coil during calibration.  Default is .4mm
#calibration_position:
#   The X, Y, Z position where the tool should be moved when
#   probe drift calibration initializes.  This is the location
#   where the first manual probe will occur.  If omitted, the
#   default behavior is not to move the tool prior to the first
#   manual probe.
#calibration_bed_temp:
#   The maximum safe bed temperature (in C) used to heat the probe
#   during probe drift calibration.  When set, the calibration
#   procedure will turn on the bed after the first sample is
#   taken.  When the calibration procedure is complete the bed
#   temperature will be set to zero.  When omitted the default
#   behavior is not to set the bed temperature.
#calibration_extruder_temp:
#   The extruder temperature (in C) set probe during drift calibration.
#   When this option is supplied the procedure will wait for until the
#   specified temperature is reached before requesting the first manual
#   probe.  When the calibration procedure is complete the extruder
#   temperature will be set to 0.  When omitted the default behavior is
#   not to set the extruder temperature.
#extruder_heating_z: 50.
#   The Z location where extruder heating will occur if the
#   "calibration_extruder_temp" option is set.  Its recommended to heat
#   the extruder some distance from the bed to minimize its impact on
#   the probe coil temperature.  The default is 50.
#max_validation_temp: 60.
#   The maximum temperature used to validate the calibration.  It is
#   recommended to set this to a value between 100 and 120 for enclosed
#   printers.  The default is 60.
```

## Sensori di temperatura

Klipper include definizioni per molti tipi di sensori di temperatura. Questi sensori possono essere utilizzati in qualsiasi sezione di configurazione che richieda un sensore di temperatura (come una sezione `[extruder]` o `[heater_bed]`).

### Termistori comuni

Termistori comuni. I seguenti parametri sono disponibili nelle sezioni del riscaldatore che utilizzano uno di questi sensori.

```
sensor_type:
#   Uno di "EPCOS 100K B57560G104F", "ATC Semitec 104GT-2",
#   "ATC Semitec 104NT-4-R025H42G", "Generic 3950",
#   "Honeywell 100K 135-104LAG-J01", "NTC 100K MGB18-104F39050L32",
#   "SliceEngineering 450", o "TDK NTCG104LH104JT1"
sensor_pin:
#   Pin di ingresso analogico collegato al termistore.
#   Questo parametro deve essere fornito.
#pullup_resistor: 4700
#   La resistenza (in ohm) del pullup collegato al termistore.
#   Il valore predefinito è 4700 ohm.
#inline_resistor: 0
#   La resistenza (in ohm) di un resistore aggiuntivo (non a variazione di
#   calore) posizionato in linea con il termistore. È raro impostare questo.
#   Il valore predefinito è 0 ohm.
```

### Amplificatori di temperatura comuni

Amplificatori di temperatura comuni. I seguenti parametri sono disponibili nelle sezioni del riscaldatore che utilizzano uno di questi sensori.

```
sensor_type:
#   Uno tra "PT100 INA826", "AD595", "AD597", "AD8494", "AD8495",
#   "AD8496", o "AD8497".
sensor_pin:
#   Pin di ingresso analogico collegato al sensore. Questo parametro
#   deve essere fornito.
#adc_voltage: 5.0
#   La tensione di confronto dell'ADC (in Volt). Il valore predefinito
#   è 5 volt.
#voltage_offset: 0
#   L'offset di tensione ADC (in Volt). Il valore predefinito è 0.
```

### Sensore PT1000 collegato direttamente

Sensore PT1000 collegato direttamente. I seguenti parametri sono disponibili nelle sezioni del riscaldatore che utilizzano uno di questi sensori.

```
sensor_type: PT1000
sensor_pin:
#   Pin di ingresso analogico collegato al sensore. Questo parametro
#   deve essere fornito.
#pullup_resistor: 4700
#   La resistenza (in ohm) del pullup collegato al sensore. Il valore
#   predefinito è 4700 ohm.
```

### Sensori di temperatura MAXxxxxx

Sensori temperatura MAXxxxxx con interfaccia periferica seriale (SPI). I seguenti parametri sono disponibili nelle sezioni del riscaldatore che utilizzano uno di questi tipi di sensore.

```
sensor_type:
#   Uno tra "MAX6675", "MAX31855", "MAX31856", o "MAX31865".
sensor_pin:
#   Il pin mcu collegato al pin di selezione del chip del sensore.
#   Questo parametro deve essere fornito.
#spi_speed: 4000000
#   La velocità SPI (in hz) da utilizzare durante la comunicazione
#   con il chip. Il valore predefinito è 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Vedere la sezione "impostazioni comuni SPI" per una
#   descrizione dei parametri di cui sopra.
#tc_type: K
#tc_use_50Hz_filter: False
#tc_averaging_count: 1
#   I parametri di cui sopra controllano i parametri del sensore
#   dei chip MAX31856. I valori predefiniti per ciascun parametro
#   sono accanto al nome del parametro nell'elenco precedente.
#rtd_nominal_r: 100
#rtd_reference_r: 430
#rtd_num_of_wires: 2
#rtd_use_50Hz_filter: False
#   I parametri di cui sopra controllano i parametri del sensore dei
#   chip MAX31865. I valori predefiniti per ciascun parametro sono
#   accanto al nome del parametro nell'elenco precedente.
```

### BMP180/BMP280/BME280/BMP388/BME680 temperature sensor

BMP180/BMP280/BME280/BMP388/BME680 two wire interface (I2C) environmental sensors. Note that these sensors are not intended for use with extruders and heater beds, but rather for monitoring ambient temperature (C), pressure (hPa), relative humidity and in case of the BME680 gas level. See [sample-macros.cfg](../config/sample-macros.cfg) for a gcode_macro that may be used to report pressure and humidity in addition to temperature.

```
sensor_type: BME280
#i2c_address:
#   Default is 118 (0x76). The BMP180, BMP388 and some BME280 sensors
#   have an address of 119 (0x77).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### Sensore temperatura AHT10/AHT20/AHT21

Sensori ambientali con interfaccia a due fili (I2C) AHT10/AHT20/AHT21. Si noti che questi sensori non sono destinati all'uso con estrusori e letti riscaldanti, ma piuttosto per il monitoraggio della temperatura ambiente (C) e dell'umidità relativa. Vedi [sample-macros.cfg](../config/sample-macros.cfg) per un gcode_macro che può essere utilizzato per segnalare l'umidità oltre alla temperatura.

```
sensor_type: AHT10
#   Also use AHT10 for AHT20 and AHT21 sensors.
#i2c_address:
#   Default is 56 (0x38). Some AHT10 sensors give the option to use
#   57 (0x39) by moving a resistor.
#i2c_mcu:
#i2c_bus:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#aht10_report_time:
#   Interval in seconds between readings. Default is 30, minimum is 5
```

### Sensore HTU21D

Sensore ambientale con interfaccia a due fili (I2C) della famiglia HTU21D. Si noti che questo sensore non è destinato all'uso con estrusori e letti riscaldanti, ma piuttosto per il monitoraggio della temperatura ambiente (C) e dell'umidità relativa(%). Vedere [sample-macros.cfg](../config/sample-macros.cfg) per una gcode_macro che può essere utilizzata per riportare l'umidità oltre alla temperatura.

```
sensor_type:
#   Must be "HTU21D" , "SI7013", "SI7020", "SI7021" or "SHT21"
#i2c_address:
#   Default is 64 (0x40).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#htu21d_hold_master:
#   If the sensor can hold the I2C buf while reading. If True no other
#   bus communication can be performed while reading is in progress.
#   Default is False.
#htu21d_resolution:
#   The resolution of temperature and humidity reading.
#   Valid values are:
#    'TEMP14_HUM12' -> 14bit for Temp and 12bit for humidity
#    'TEMP13_HUM10' -> 13bit for Temp and 10bit for humidity
#    'TEMP12_HUM08' -> 12bit for Temp and 08bit for humidity
#    'TEMP11_HUM11' -> 11bit for Temp and 11bit for humidity
#   Default is: "TEMP11_HUM11"
#htu21d_report_time:
#   Interval in seconds between readings. Default is 30
```

### SHT3X sensor

SHT3X family two wire interface (I2C) environmental sensor. These sensors have a range of -55~125 C, so are usable for e.g. chamber temperature monitoring. They can also function as simple fan/heater controllers.

```
sensor_type: SHT3X
#i2c_address:
#   Default is 68 (0x44).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### Sensore di temperatura LM75

Sensori di temperatura (I2C) LM75/LM75A. Questi sensori hanno una gamma di -55~125 C, quindi sono utilizzabili ad es. monitoraggio della temperatura della camera. Possono anche funzionare come semplici controller per ventole/riscaldatori.

```
sensor_type: LM75
#i2c_address:
#   Default is 72 (0x48). Normal range is 72-79 (0x48-0x4F) and the 3
#   low bits of the address are configured via pins on the chip
#   (usually with jumpers or hard wired).
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#lm75_report_time:
#   Interval in seconds between readings. Default is 0.8, with minimum
#   0.5.
```

### Sensore di temperatura integrato nel microcontrollore

I microcontrollori atsam, atsamd e stm32 contengono un sensore di temperatura interno. È possibile utilizzare il sensore "temperature_mcu" per monitorare queste temperature.

```
sensor_type: temperature_mcu
#sensor_mcu: mcu
#   Il microcontrollore da cui leggere. L'impostazione predefinita è "mcu".
#sensor_temperature1:
#sensor_adc1:
#   Specificare i due parametri precedenti (una temperatura in gradi
#   Celsius e un valore ADC come float compreso tra 0,0 e 1,0) per
#   calibrare la temperatura del microcontrollore. Ciò potrebbe
#   migliorare la precisione della temperatura riportata su alcuni chip.
#   Un modo tipico per ottenere queste informazioni di calibrazione
#   consiste nel rimuovere completamente l'alimentazione dalla
#   stampante per alcune ore (per assicurarsi che sia alla temperatura
#   ambiente), quindi accenderla e utilizzare il comando QUERY_ADC
#   per ottenere una misurazione ADC. Utilizzare un altro sensore di
#   temperatura sulla stampante per trovare la temperatura ambiente
#   corrispondente. L'impostazione predefinita consiste nell'utilizzare
#   i dati di calibrazione di fabbrica sul microcontrollore (se applicabile)
#   o i valori nominali dalle specifiche del microcontrollore.
#sensor_temperature2:
#sensor_adc2:
#   Se viene specificato sensor_temperature1/sensor_adc1, è anche
#   possibile specificare i dati di calibrazione sensor_temperature2/sensor_adc2.
#   Ciò potrebbe fornire informazioni calibrate sulla "curva della
#   temperatura". L'impostazione predefinita consiste nell'utilizzare i dati
#   di calibrazione di fabbrica sul microcontrollore (se applicabile) o i
#   valori nominali dalle specifiche del microcontrollore.
```

### Sensore di temperatura host

Temperatura dalla macchina (es. Raspberry Pi) che esegue il software host.

```
sensor_type: temperature_host
#sensor_path:
#   il percorso del file di sistema della temperatura. L'impostazione
#   predefinita è "/sys/class/thermal/thermal_zone0/temp" che è il file di
#   sistema della temperatura su un computer Raspberry Pi.
```

### Sensore di temperatura DS18B20

DS18B20 è un sensore di temperatura digitale a 1 filo (w1). Si noti che questo sensore non è destinato all'uso con estrusori e letti riscaldanti, ma piuttosto per il monitoraggio della temperatura ambiente (C). Questi sensori hanno una portata fino a 125 C, quindi sono utilizzabili ad es. monitoraggio della temperatura della camera. Possono anche funzionare come semplici controller per ventole/riscaldatori. I sensori DS18B20 sono supportati solo su "host mcu", ad es. il Raspberry Pi. È necessario installare il modulo del kernel Linux w1-gpio.

```
sensor_type: DS18B20
serial_no:
#   Ogni dispositivo a 1 filo ha un numero di serie univoco utilizzato per
#   identificare il dispositivo, solitamente nel formato 28-031674b175ff. Questo
#   parametro deve essere fornito. I dispositivi collegati a 1 filo possono essere
#   elencati utilizzando il seguente comando Linux: ls /sys/bus/w1/devices/
#ds18_report_time:
#   Intervallo in secondi tra le letture. Il valore predefinito è 3.0, con un
#   minimo di 1.0
#sensor_mcu:
#   Il microcontrollore da cui leggere. Deve essere host_mcu
```

### Combined temperature sensor

Combined temperature sensor is a virtual temperature sensor based on several other sensors. This sensor can be used with extruders, heater_generic and heater beds.

```
sensor_type: temperature_combined
#sensor_list:
#   Must be provided. List of sensors to combine to new "virtual"
#   sensor.
#   E.g. 'temperature_sensor sensor1,extruder,heater_bed'
#combination_method:
#   Must be provided. Combination method used for the sensor.
#   Available options are 'max', 'min', 'mean'.
#maximum_deviation:
#   Must be provided. Maximum permissible deviation between the sensors
#   to combine (e.g. 5 degrees). To disable it, use a large value (e.g. 999.9)
```

## Ventole

### [fan]

Ventola di raffreddamento della stampa.

```
[fan]
pin:
#   Pin di output che controlla la ventola. Questo parametro deve essere fornito.
#max_power: 1.0
#   La potenza massima (espressa come un valore compreso tra 0.0 e 1.0) a
#   cui può essere impostato il pin. Il valore 1.0 consente di impostare il pin
#   completamente abilitato per periodi prolungati, mentre un valore di 0.5
#   consentirebbe di abilitare il pin per non più della metà del tempo. Questa
#   impostazione può essere utilizzata per limitare la potenza totale (per
#   periodi prolungati) della ventola. Se questo valore è inferiore a 1.0, le
#   richieste di velocità della ventola verranno ridimensionate tra zero e
#   max_power (ad esempio, se max_power è 0.9 e viene richiesta una
#   velocità della ventola dell'80%, la potenza della ventola verrà impostata
#   su 72%). L'impostazione predefinita è 1.0.
#shutdown_speed: 0
#   La velocità della ventola desiderata (espressa come valore da 0.0 a
#   1.0) se il software del microcontrollore entra in uno stato di errore.
#   Il valore predefinito è 0.
#cycle_time: 0.010
#   La quantità di tempo (in secondi) per ogni ciclo di alimentazione PWM
#   alla ventola. Si consiglia di essere pari o superiore a 10 millisecondi
#   quando si utilizza il PWM basato su software.
#   Il valore predefinito è 0,010 secondi.
#hardware_pwm: False
#   Abilitare questa opzione per utilizzare PWM hardware anziché PWM
#   software. La maggior parte delle ventole non funziona bene con PWM
#   hardware, quindi non è consigliabile abilitarlo a meno che non vi sia
#   un requisito elettrico per passare a velocità molto elevate. Quando
#   si utilizza l'hardware PWM, il tempo di ciclo effettivo è vincolato
#   dall'implementazione e può essere notevolmente diverso dal tempo
#   di ciclo richiesto. L'impostazione predefinita è False.
#kick_start_time: 0.100
#   Tempo (in secondi) per far funzionare la ventola a piena velocità
#   quando la si abilita per la prima volta o la si aumenta di oltre il 50%
#   (aiuta a far girare la ventola). Il valore predefinito è 0,100 secondi.
#off_below: 0.0
#   La velocità minima in input che alimenterà la ventola (espressa
#   come un valore da 0.0 a 1.0). Quando viene richiesta una velocità
#   inferiore a off_below la ventola verrà invece spenta. Questa
#   impostazione può essere utilizzata per prevenire lo stallo della
#   ventola e per garantire che i kick start siano efficaci.
#   Il valore predefinito è 0.0.
#
#   Questa impostazione deve essere ricalibrata ogni volta che
#   max_power viene regolato. Per calibrare questa impostazione,
#   inizia con off_below impostato su 0.0 e la ventola gira. Abbassare
#   gradualmente la velocità della ventola per determinare la velocità
#   di ingresso più bassa che aziona la ventola in modo affidabile senza
#   stalli. Impostare off_below al duty cycle corrispondente a questo
#   valore (ad esempio, 12% -> 0,12) o leggermente superiore.
#tachometer_pin:
#   Pin di ingresso contagiri per il monitoraggio della velocità della
#   ventola. In genere è richiesto un pullup. Questo parametro è facoltativo.
#tachometer_ppr: 2
#   Quando viene specificato tachometer_pin, questo è il numero di
#   impulsi per giro del segnale del tachimetro. Per una ventola BLDC
#   questo è normalmente la metà del numero di poli.
#   L'impostazione predefinita è 2.
#tachometer_poll_interval: 0.0015
#   Quando viene specificato tachometer_pin, questo è il periodo di polling
#   del pin del contagiri, in secondi. Il valore predefinito è 0.0015, che è
#   abbastanza veloce per le ventole al di sotto di 10000 RPM a 2 PPR. Deve
#   essere inferiore a 30/(tachometer_ppr*rpm), con un certo margine,
#   dove rpm è la velocità massima (in RPM) della ventola.
#enable_pin:
#   Pin opzionale per abilitare l'alimentazione alla ventola. Questo può
#   essere utile per le ventole con ingressi PWM dedicati. Alcune di queste
#   ventole rimangono accese anche allo 0% di ingresso PWM. In tal caso,
#   il pin PWM può essere utilizzato normalmente e ad es. un FET commutato
#   a terra (pin della ventola standard) può essere utilizzato per controllare
#   l'alimentazione alla ventola.
```

### [heater_fan]

Ventole di raffreddamento del riscaldatore (si può definire un numero qualsiasi di sezioni con un prefisso "heater_fan"). Una "ventola riscaldatore" è una ventola che verrà abilitata ogni volta che il riscaldatore associato è attivo. Per impostazione predefinita, un heater_fan ha una velocità di spegnimento pari a max_power.

```
[heater_fan heatbreak_cooling_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   See the "fan" section for a description of the above parameters.
#heater: extruder
#   Name of the config section defining the heater that this fan is
#   associated with. If a comma separated list of heater names is
#   provided here, then the fan will be enabled when any of the given
#   heaters are enabled. The default is "extruder".
#heater_temp: 50.0
#   A temperature (in Celsius) that the heater must drop below before
#   the fan is disabled. The default is 50 Celsius.
#fan_speed: 1.0
#   The fan speed (expressed as a value from 0.0 to 1.0) that the fan
#   will be set to when its associated heater is enabled. The default
#   is 1.0
```

### [controller_fan]

Ventola di raffreddamento del controller (è possibile definire un numero qualsiasi di sezioni con il prefisso "controller_fan"). Una "ventola del controller" è una ventola che verrà abilitata ogni volta che il riscaldatore associato o il driver stepper associato è attivo. La ventola si fermerà ogni volta che viene raggiunto un idle_timeout per garantire che non si verifichi alcun surriscaldamento dopo la disattivazione di un componente osservato.

```
[controller_fan my_controller_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   Vedere la sezione "fan" per una descrizione dei parametri di cui sopra.
#fan_speed: 1.0
#   La velocità della ventola (espressa come un valore compreso tra 0.0 e
#   1.0) a cui verrà impostata la ventola quando è attivo un riscaldatore
#   o un driver passo-passo. L'impostazione predefinita è 1.0
#idle_timeout:
#   La quantità di tempo (in secondi) dopo che un driver passo-passo o
#   un riscaldatore è stato attivo per la quale la ventola deve essere tenuta
#   in funzione. L'impostazione predefinita è 30 secondi.
#idle_speed:
#   La velocità della ventola (espressa come un valore compreso tra 0.0
#   e 1.0) a cui verrà impostata la ventola quando era attivo un riscaldatore
#   o un driver passo-passo e prima che venga raggiunto l'idle_timeout.
#   L'impostazione predefinita è fan_speed.
#heater:
#stepper:
#   Nome della sezione di configurazione che definisce il riscaldatore/
#   stepper a cui è associata questa ventola. Se qui viene fornito un
#   elenco separato da virgole di nomi di riscaldatori/stepper, la ventola
#   sarà abilitata quando uno qualsiasi dei riscaldatori/stepper indicati
#   è abilitato. Il riscaldatore predefinito è "estrusore", lo stepper
#   predefinito sono tutti.
```

### [temperature_fan]

Ventole di raffreddamento attivate dalla temperatura (è possibile definire un numero qualsiasi di sezioni con un prefisso "temperature_fan"). Una "ventola di temperatura" è una ventola che verrà abilitata ogni volta che il sensore associato è al di sopra di una temperatura impostata. Per impostazione predefinita, una ventola_temperatura ha una velocità_di_arresto pari a potenza_massima.

Per ulteriori informazioni, vedere [command reference](G-Codes.md#temperature_fan).

```
[temperature_fan my_temp_fan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   Vedere la sezione "fan" per una descrizione dei parametri di cui sopra.
#sensor_type:
#sensor_pin:
#control:
#max_delta:
#min_temp:
#max_temp:
#   Vedere la sezione "extruder" per una descrizione dei parametri di cui sopra.
#pid_Kp:
#pid_Ki:
#pid_Kd:
#   Le impostazioni proporzionale (pid_Kp), integrale (pid_Ki) e derivata (pid_Kd)
#   per il sistema di controllo del feedback PID. Klipper valuta le impostazioni PID
#   con la seguente formula generale: fan_pwm = max_power - (Kp*e + Ki*integral(e)
#   - Kd*derivative(e)) / 255 Dove "e" è "target_temperature - measure_temperature"
#   e "fan_pwm" è la frequenza della ventola richiesta con 0.0 per spento e 1.0 al
#   massimo. I parametri pid_Kp, pid_Ki e pid_Kd devono essere forniti quando
l#   'algoritmo di controllo PID è abilitato.
#pid_deriv_time: 2.0
#   Un valore di tempo (in secondi) su cui le misurazioni della temperatura verranno
#   livellate quando si utilizza l'algoritmo di controllo PID. Ciò può ridurre l'impatto
#   del rumore di misurazione. Il valore predefinito è 2 secondi.
#target_temp: 40.0
#   Una temperatura (in Celsius) che sarà la temperatura target.
#   L'impostazione predefinita è 40 gradi.
#max_speed: 1.0
#   La velocità della ventola (espressa come un valore compreso tra 0.0 e 1.0) a cui
#   verrà impostata la ventola quando la temperatura del sensore supera il valore
#   impostato. L'impostazione predefinita è 1.0.
#min_speed: 0.3
#   La velocità minima della ventola (espressa come un valore compreso tra 0.0 e
#   1.0) alla quale la ventola verrà impostata per le ventole con temperatura PID.
#   Il valore predefinito è 0.3.
#gcode_id:
#   Se impostata, la temperatura verrà riportata nelle query M105 utilizzando l'id
#   fornito. L'impostazione predefinita è di non riportare la temperatura tramite M105.
```

### [fan_generic]

Ventola a controllo manuale (si può definire un numero qualsiasi di sezioni con il prefisso "fan_generic"). La velocità di una ventola controllata manualmente viene impostata con SET_FAN_SPEED [comando gcode](G-Codes.md#fan_generic).

```
[fan_generic extruder_partfan]
#pin:
#max_power:
#shutdown_speed:
#cycle_time:
#hardware_pwm:
#kick_start_time:
#off_below:
#tachometer_pin:
#tachometer_ppr:
#tachometer_poll_interval:
#enable_pin:
#   Vedere la sezione "fan" per una descrizione dei parametri di cui sopra.
```

## LEDs

### [led]

Supporto per LED (e strisce LED) controllati tramite pin PWM del microcontrollore (si può definire un numero qualsiasi di sezioni con un prefisso "led"). Per ulteriori informazioni, vedere [command reference](G-Codes.md#led).

```
[led my_led]
#red_pin:
#green_pin:
#blue_pin:
#white_pin:
#   Il pin che controlla il colore del LED specificato. Deve essere fornito
#   almeno uno dei parametri sopra indicati.
#cycle_time: 0.010
#   La quantità di tempo (in secondi) per ciclo PWM. Si consiglia che sia
#   pari o superiore a 10 millisecondi quando si utilizza il PWM basato
#   su software. Il valore predefinito è 0,010 secondi.
#hardware_pwm: False
#   Abilitare questa opzione per utilizzare PWM hardware anziché PWM
#   software. Quando si utilizza l'hardware PWM, il tempo di ciclo effettivo
#   è vincolato dall'implementazione e può essere notevolmente diverso
#   dal tempo di ciclo richiesto. L'impostazione predefinita è Falso.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Imposta il colore iniziale del LED. Ciascun valore deve essere
#   compreso tra 0,0 e 1,0. Il valore predefinito per ogni colore è 0.
```

### [neopixel]

Supporto LED Neopixel (aka WS2812) (si può definire un numero qualsiasi di sezioni con un prefisso "neopixel"). Per ulteriori informazioni, vedere [riferimento comando](G-Codes.md#led).

Si noti che l'implementazione di [linux mcu](RPi_microcontroller.md) non supporta attualmente i neopixel collegati direttamente. L'attuale design che utilizza l'interfaccia del kernel Linux non consente questo scenario perché l'interfaccia GPIO del kernel non è sufficientemente veloce da fornire le frequenze di impulso richieste.

```
[neopixel my_neopixel]
pin:
#   Il pin collegato al neopixel. Questo parametro deve essere fornito.
#chain_count:
#   Il numero di chip Neopixel che sono "collegati a margherita" al
#   pin fornito. Il valore predefinito è 1 (che indica che un solo
#   Neopixel è collegato al pin).
#color_order: GRB
#   Impostare l'ordine dei pixel richiesto dall'hardware del LED
#   (utilizzando una stringa contenente le lettere R, G, B, W con W
#   opzionale). In alternativa, questo può essere un elenco separato
#   da virgole di pixel, uno per ogni LED nella catena.
#   L'impostazione predefinita è GRB.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   Vedere la sezione "led" per informazioni su questi parametri.
```

### [dotstar]

Supporto LED Dotstar (conosciuti anche come APA102) (si può definire un numero qualsiasi di sezioni con un prefisso "dotstar"). Per ulteriori informazioni, vedere [command reference](G-Codes.md#led).

```
[dotstar my_dotstar]
data_pin:
#   Il pin connesso alla data line del dotstar. Questo parametro
#   deve essere fornito.
clock_pin:
#   Il pin connesso alla clock line del dotstar. Questo parametro
#   deve essere fornito.
#chain_count:
#   Vedere la sezione "neopixel" per informazioni su questo parametro.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#   Vedere la sezione "led" per informazioni su questo parametro.
```

### [pca9533]

PCA9533 Supporto LED. Il PCA9533 viene utilizzato sulla scheda mightyboard.

```
[pca9533 my_pca9533]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. Use 98 for
#   the PCA9533/1, 99 for the PCA9533/2. The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

### [pca9632]

Supporto LED PCA9632. Il PCA9632 viene utilizzato su FlashForge Dreamer.

```
[pca9632 my_pca9632]
#i2c_address: 98
#   The i2c address that the chip is using on the i2c bus. This may be
#   96, 97, 98, or 99.  The default is 98.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#scl_pin:
#sda_pin:
#   Alternatively, if the pca9632 is not connected to a hardware I2C
#   bus, then one may specify the "clock" (scl_pin) and "data"
#   (sda_pin) pins. The default is to use hardware I2C.
#color_order: RGBW
#   Set the pixel order of the LED (using a string containing the
#   letters R, G, B, W). The default is RGBW.
#initial_RED: 0.0
#initial_GREEN: 0.0
#initial_BLUE: 0.0
#initial_WHITE: 0.0
#   See the "led" section for information on these parameters.
```

## Servocomandi aggiuntivi, pulsanti e altri pin

### [servo]

Servo (si può definire un numero qualsiasi di sezioni con un prefisso "servo"). I servo possono essere controllati usando SET_SERVO [comando g-code](G-Codes.md#servo). Ad esempio: SET_SERVO SERVO=my_servo ANGLE=180

```
[servo my_servo]
pin:
#   Pin di uscita PWM che controlla il servo. Questo parametro deve
#   essere fornito.
#maximum_servo_angle: 180
#   L'angolo massimo (in gradi) a cui questo servo può essere impostato.
#   L'impostazione predefinita è 180 gradi.
#minimum_pulse_width: 0.001
#   La durata minima dell'impulso (in secondi). Questo dovrebbe
#   corrispondere a un angolo di 0 gradi. Il valore predefinito è 0.001 secondi.
#maximum_pulse_width: 0.002
#   La durata massima dell'impulso (in secondi). Questo dovrebbe
#   corrispondere a un angolo di maximum_servo_angle. Il valore
#   predefinito è 0.002 secondi.
#initial_angle:
#   Angolo iniziale (in gradi) su cui impostare il servo. L'impostazione
#   predefinita è di non inviare alcun segnale all'avvio.
#initial_pulse_width:
#   Durata iniziale dell'impulso (in secondi) su cui impostare il servo.
#   (Questo è valido solo se initial_angle non è impostato.)
#   L'impostazione predefinita è di non inviare alcun segnale all'avvio.
```

### [gcode_button]

Esegui gcode quando un pulsante viene premuto o rilasciato (o quando un pin cambia stato). Puoi controllare lo stato del pulsante usando `QUERY_BUTTON button=my_gcode_button`.

```
[gcode_button my_gcode_button]
pin:
#   Il pin su cui è collegato il pulsante. Questo parametro deve essere fornito.
#analog_range:
#   Due resistenze separate da virgole (in Ohm) che specificano l'intervallo
#   di resistenza minimo e massimo per il pulsante. Se viene fornito
#   analog_range, il pin deve essere un pin con capacità analogica.
#   L'impostazione predefinita è utilizzare digital gpio per il pulsante.
#analog_pullup_resistor:
#   La resistenza di pullup (in Ohm) quando è specificato analog_range.
#   Il valore predefinito è 4700 ohm.
#press_gcode:
#   Un elenco di comandi G-Code da eseguire quando si preme il pulsante.
#   I modelli G-Code sono supportati. Questo parametro deve essere fornito.
#release_gcode:
#   Un elenco di comandi G-Code da eseguire quando il pulsante viene
#   rilasciato. I modelli G-Code sono supportati. L'impostazione predefinita
#   è di non eseguire alcun comando al rilascio di un pulsante.
```

### [output_pin]

Pin di uscita configurabili in fase di run-time (è possibile definire un numero qualsiasi di sezioni con un prefisso "output_pin"). I pin configurati qui verranno impostati come pin di output e sarà possibile modificarli in fase di esecuzione utilizzando il comando esteso "SET_PIN PIN=my_pin VALUE=.1" [comandi g-code](G-Codes.md#output_pin).

```
[output_pin my_pin]
pin:
#   The pin to configure as an output. This parameter must be
#   provided.
#pwm: False
#   Set if the output pin should be capable of pulse-width-modulation.
#   If this is true, the value fields should be between 0 and 1; if it
#   is false the value fields should be either 0 or 1. The default is
#   False.
#value:
#   The value to initially set the pin to during MCU configuration.
#   The default is 0 (for low voltage).
#shutdown_value:
#   The value to set the pin to on an MCU shutdown event. The default
#   is 0 (for low voltage).
#cycle_time: 0.100
#   The amount of time (in seconds) per PWM cycle. It is recommended
#   this be 10 milliseconds or greater when using software based PWM.
#   The default is 0.100 seconds for pwm pins.
#hardware_pwm: False
#   Enable this to use hardware PWM instead of software PWM. When
#   using hardware PWM the actual cycle time is constrained by the
#   implementation and may be significantly different than the
#   requested cycle_time. The default is False.
#scale:
#   This parameter can be used to alter how the 'value' and
#   'shutdown_value' parameters are interpreted for pwm pins. If
#   provided, then the 'value' parameter should be between 0.0 and
#   'scale'. This may be useful when configuring a PWM pin that
#   controls a stepper voltage reference. The 'scale' can be set to
#   the equivalent stepper amperage if the PWM were fully enabled, and
#   then the 'value' parameter can be specified using the desired
#   amperage for the stepper. The default is to not scale the 'value'
#   parameter.
#maximum_mcu_duration:
#static_value:
#   These options are deprecated and should no longer be specified.
```

### [pwm_tool]

Pulse width modulation digital output pins capable of high speed updates (one may define any number of sections with an "output_pin" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1" type extended [g-code commands](G-Codes.md#output_pin).

```
[pwm_tool my_tool]
pin:
#   The pin to configure as an output. This parameter must be provided.
#maximum_mcu_duration:
#   The maximum duration a non-shutdown value may be driven by the MCU
#   without an acknowledge from the host.
#   If host can not keep up with an update, the MCU will shutdown
#   and set all pins to their respective shutdown values.
#   Default: 0 (disabled)
#   Usual values are around 5 seconds.
#value:
#shutdown_value:
#cycle_time: 0.100
#hardware_pwm: False
#scale:
#   See the "output_pin" section for the definition of these parameters.
```

### [pwm_cycle_time]

Run-time configurable output pins with dynamic pwm cycle timing (one may define any number of sections with an "pwm_cycle_time" prefix). Pins configured here will be setup as output pins and one may modify them at run-time using "SET_PIN PIN=my_pin VALUE=.1 CYCLE_TIME=0.100" type extended [g-code commands](G-Codes.md#pwm_cycle_time).

```
[pwm_cycle_time my_pin]
pin:
#value:
#shutdown_value:
#cycle_time: 0.100
#scale:
#   See the "output_pin" section for information on these parameters.
```

### [static_digital_output]

Pin di uscita digitali configurati staticamente (è possibile definire un numero qualsiasi di sezioni con un prefisso "static_digital_output"). I pin configurati qui verranno impostati come uscita GPIO durante la configurazione dell'MCU. Non possono essere modificati in fase di esecuzione.

```
[static_digital_output my_output_pins]
pins:
#   Un elenco separato da virgole di pin da impostare come pin di
#   output GPIO. Il pin verrà impostato su un livello alto a meno che il
#   nome del pin non sia preceduto da "!". Questo parametro deve
#   essere fornito.
```

### [multi_pin]

Uscite a pin multipli (si può definire un numero qualsiasi di sezioni con un prefisso "multi_pin"). Un output multi_pin crea un alias pin interno che può modificare più pin di output ogni volta che viene impostato il pin alias. Ad esempio, si potrebbe definire un oggetto "[multi_pin my_fan]" contenente due pin e quindi impostare "pin=multi_pin:my_fan" nella sezione "[fan]" - ad ogni cambio di ventola entrambi i pin di output verrebbero aggiornati. Questi alias non possono essere utilizzati con i pin del motore passo-passo.

```
[multi_pin my_multi_pin]
pins:
#   Un elenco separato da virgole di pin associati a questo alias.
#   Questo parametro deve essere fornito.
```

## Configurazione del driver TMC per stepper

Configurazione dei driver per motori passo-passo Trinamic in modalità UART/SPI. Ulteriori informazioni si trovano nella [TMC Drivers guide](TMC_Drivers.md) e nel [command reference](G-Codes.md#tmcxxxx).

### [tmc2130]

Configurare un driver per motore passo-passo TMC2130 tramite bus SPI. Per utilizzare questa funzione, definire una sezione di configurazione con un prefisso "tmc2130" seguito dal nome della sezione di configurazione dello stepper corrispondente (ad esempio, "[tmc2130 stepper_x]").

```
[tmc2130 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2130 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 0
#driver_TBL: 1
#driver_TOFF: 4
#driver_HEND: 7
#driver_HSTRT: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 4
#driver_PWM_AMPL: 128
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#   Set the given register during the configuration of the TMC2130
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2130 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2130_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2208]

Configurare un driver per motore passo-passo TMC2208 (o TMC2224) tramite UART a filo singolo. Per utilizzare questa funzione, definire una sezione di configurazione con un prefisso "tmc2208" seguito dal nome della sezione di configurazione dello stepper corrispondente (ad esempio, "[tmc2208 stepper_x]").

```
[tmc2208 stepper_x]
uart_pin:
#   The pin connected to the TMC2208 PDN_UART line. This parameter
#   must be provided.
#tx_pin:
#   If using separate receive and transmit lines to communicate with
#   the driver then set uart_pin to the receive pin and tx_pin to the
#   transmit pin. The default is to use uart_pin for both reading and
#   writing.
#select_pins:
#   A comma separated list of pins to set prior to accessing the
#   tmc2208 UART. This may be useful for configuring an analog mux for
#   UART communication. The default is to not configure any pins.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). This interpolation does
#   introduce a small systemic positional deviation - see
#   TMC_Drivers.md for details. The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.110
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.110 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#   Set the given register during the configuration of the TMC2208
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
```

### [tmc2209]

Configurare un driver per motore passo-passo TMC2209 tramite UART a filo singolo. Per utilizzare questa funzione, definire una sezione di configurazione con un prefisso "tmc2209" seguito dal nome della sezione di configurazione dello stepper corrispondente (ad esempio, "[tmc2209 stepper_x]").

```
[tmc2209 stepper_x]
uart_pin:
#tx_pin:
#select_pins:
#interpolate: True
run_current:
#hold_current:
#sense_resistor: 0.110
#stealthchop_threshold: 0
#   See the "tmc2208" section for the definition of these parameters.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#uart_address:
#   The address of the TMC2209 chip for UART messages (an integer
#   between 0 and 3). This is typically used when multiple TMC2209
#   chips are connected to the same UART pin. The default is zero.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 8
#driver_TPOWERDOWN: 20
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 0
#driver_HSTRT: 5
#driver_PWM_AUTOGRAD: True
#driver_PWM_AUTOSCALE: True
#driver_PWM_LIM: 12
#driver_PWM_REG: 8
#driver_PWM_FREQ: 1
#driver_PWM_GRAD: 14
#driver_PWM_OFS: 36
#driver_SGTHRS: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#   Set the given register during the configuration of the TMC2209
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag_pin:
#   The micro-controller pin attached to the DIAG line of the TMC2209
#   chip. The pin is normally prefaced with "^" to enable a pullup.
#   Setting this creates a "tmc2209_stepper_x:virtual_endstop" virtual
#   pin which may be used as the stepper's endstop_pin. Doing this
#   enables "sensorless homing". (Be sure to also set driver_SGTHRS to
#   an appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc2660]

Configurare un driver per motore passo-passo TMC2660 tramite bus SPI. Per utilizzare questa funzione, definire una sezione di configurazione con un prefisso tmc2660 seguito dal nome della sezione di configurazione dello stepper corrispondente (ad esempio, "[tmc2660 stepper_x]").

```
[tmc2660 stepper_x]
cs_pin:
#   Il pin corrispondente al pin di selezione del chip TMC2660. Questo pin
#   verrà impostato su basso all'inizio dei messaggi SPI e impostato su
#   alto al termine del trasferimento del messaggio. Questo parametro
#   deve essere fornito.
#spi_speed: 4000000
#   Frequenza bus SPI utilizzata per comunicare con il driver
#   passo-passo TMC2660. Il valore predefinito è 4000000.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Vedere la sezione "impostazioni comuni SPI" per una descrizione
#   dei parametri di cui sopra.
#interpolate: True
#   Se true, abilita l'interpolazione del passo (il driver eseguirà un passo
#   interno a una velocità di 256 micropassi). Funziona solo se microsteps
#   è impostato su 16. L'interpolazione introduce una piccola deviazione
#   posizionale sistemica - vedere TMC_Drivers.md per i dettagli.
#   L'impostazione predefinita è Vero.
run_current:
#   La quantità di corrente (in ampere RMS) utilizzata dal driver durante
#   il movimento passo-passo. Questo parametro deve essere fornito.
#sense_resistor:
#   La resistenza (in ohm) del resistore di rilevamento del motore.
#   Questo parametro deve essere fornito.
#idle_current_percent: 100
#   La percentuale di run_current a cui il driver stepper sarà ridotto allo
#   scadere del timeout di inattività (è necessario impostare il timeout
#   utilizzando una sezione di configurazione [idle_timeout]). La corrente
#   verrà nuovamente aumentata una volta che lo stepper dovrà muoversi
#   di nuovo. Assicurati di impostarlo su un valore sufficientemente alto in
#   modo che gli stepper non perdano la loro posizione. C'è anche un piccolo
#   ritardo fino a quando la corrente non viene nuovamente aumentata,
#   quindi tienine conto quando comandi mosse veloci mentre lo stepper è
#   al minimo. Il valore predefinito è 100 (nessuna riduzione).
#driver_TBL: 2
#driver_RNDTF: 0
#driver_HDEC: 0
#driver_CHM: 0
#driver_HEND: 3
#driver_HSTRT: 3
#driver_TOFF: 4
#driver_SEIMIN: 0
#driver_SEDN: 0
#driver_SEMAX: 0
#driver_SEUP: 0
#driver_SEMIN: 0
#driver_SFILT: 0
#driver_SGT: 0
#driver_SLPH: 0
#driver_SLPL: 0
#driver_DISS2G: 0
#driver_TS2G: 3
#   Imposta il parametro indicato durante la configurazione del chip TMC2660.
#   Questo può essere utilizzato per impostare parametri del driver personalizzati.
#   Le impostazioni predefinite per ogni parametro sono accanto al nome del
#   parametro nell'elenco sopra. Vedere la scheda tecnica del TMC2660 su cosa
#   fa ogni parametro e quali sono le restrizioni sulle combinazioni di parametri.
#   Prestare particolare attenzione al registro CHOPCONF, dove l'impostazione
#   di CHM su zero o uno comporterà modifiche al layout (il primo bit di HDEC)
#   viene interpretato come MSB di HSTRT in questo caso).
```

### [tmc2240]

Configure a TMC2240 stepper motor driver via SPI bus or UART. To use this feature, define a config section with a "tmc2240" prefix followed by the name of the corresponding stepper config section (for example, "[tmc2240 stepper_x]").

```
[tmc2240 stepper_x]
cs_pin:
#   The pin corresponding to the TMC2240 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#uart_pin:
#   The pin connected to the TMC2240 DIAG1/SW line. If this parameter
#   is provided UART communication is used rather then SPI.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#rref: 12000
#   The resistance (in ohms) of the resistor between IREF and GND. The
#   default is 12000.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#driver_OFFSET_SIN90: 0
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#   Additionally, this driver also has the OFFSET_SIN90 field which can be used
#   to tune a motor with unbalanced coils. See the `Sine Wave Lookup Table`
#   section in the datasheet for information about this field and how to tune
#   it.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_IRUNDELAY: 4
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 29
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_SG4_ANGLE_OFFSET: 1
#driver_SLOPE_CONTROL: 0
#   Set the given register during the configuration of the TMC2240
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC2240 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc2240_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

### [tmc5160]

Configurare un driver per motore passo-passo TMC5160 tramite bus SPI. Per utilizzare questa funzione, definire una sezione di configurazione con un prefisso "tmc5160" seguito dal nome della sezione di configurazione dello stepper corrispondente (ad esempio, "[tmc5160 stepper_x]").

```
[tmc5160 stepper_x]
cs_pin:
#   The pin corresponding to the TMC5160 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#chain_position:
#chain_length:
#   These parameters configure an SPI daisy chain. The two parameters
#   define the stepper position in the chain and the total chain length.
#   Position 1 corresponds to the stepper that connects to the MOSI signal.
#   The default is to not use an SPI daisy chain.
#interpolate: True
#   If true, enable step interpolation (the driver will internally
#   step at a rate of 256 micro-steps). The default is True.
run_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   during stepper movement. This parameter must be provided.
#hold_current:
#   The amount of current (in amps RMS) to configure the driver to use
#   when the stepper is not moving. Setting a hold_current is not
#   recommended (see TMC_Drivers.md for details). The default is to
#   not reduce the current.
#sense_resistor: 0.075
#   The resistance (in ohms) of the motor sense resistor. The default
#   is 0.075 ohms.
#stealthchop_threshold: 0
#   The velocity (in mm/s) to set the "stealthChop" threshold to. When
#   set, "stealthChop" mode will be enabled if the stepper motor
#   velocity is below this value. The default is 0, which disables
#   "stealthChop" mode.
#coolstep_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "CoolStep"
#   threshold to. If set, the coolstep feature will be enabled when
#   the stepper motor velocity is near or above this value. Important
#   - if coolstep_threshold is set and "sensorless homing" is used,
#   then one must ensure that the homing speed is above the coolstep
#   threshold! The default is to not enable the coolstep feature.
#high_velocity_threshold:
#   The velocity (in mm/s) to set the TMC driver internal "high
#   velocity" threshold (THIGH) to. This is typically used to disable
#   the "CoolStep" feature at high speeds. The default is to not set a
#   TMC "high velocity" threshold.
#driver_MSLUT0: 2863314260
#driver_MSLUT1: 1251300522
#driver_MSLUT2: 608774441
#driver_MSLUT3: 269500962
#driver_MSLUT4: 4227858431
#driver_MSLUT5: 3048961917
#driver_MSLUT6: 1227445590
#driver_MSLUT7: 4211234
#driver_W0: 2
#driver_W1: 1
#driver_W2: 1
#driver_W3: 1
#driver_X1: 128
#driver_X2: 255
#driver_X3: 255
#driver_START_SIN: 0
#driver_START_SIN90: 247
#   These fields control the Microstep Table registers directly. The optimal
#   wave table is specific to each motor and might vary with current. An
#   optimal configuration will have minimal print artifacts caused by
#   non-linear stepper movement. The values specified above are the default
#   values used by the driver. The value must be specified as a decimal integer
#   (hex form is not supported). In order to compute the wave table fields,
#   see the tmc2130 "Calculation Sheet" from the Trinamic website.
#driver_MULTISTEP_FILT: True
#driver_IHOLDDELAY: 6
#driver_TPOWERDOWN: 10
#driver_TBL: 2
#driver_TOFF: 3
#driver_HEND: 2
#driver_HSTRT: 5
#driver_FD3: 0
#driver_TPFD: 4
#driver_CHM: 0
#driver_VHIGHFS: 0
#driver_VHIGHCHM: 0
#driver_DISS2G: 0
#driver_DISS2VS: 0
#driver_PWM_AUTOSCALE: True
#driver_PWM_AUTOGRAD: True
#driver_PWM_FREQ: 0
#driver_FREEWHEEL: 0
#driver_PWM_GRAD: 0
#driver_PWM_OFS: 30
#driver_PWM_REG: 4
#driver_PWM_LIM: 12
#driver_SGT: 0
#driver_SEMIN: 0
#driver_SEUP: 0
#driver_SEMAX: 0
#driver_SEDN: 0
#driver_SEIMIN: 0
#driver_SFILT: 0
#driver_DRVSTRENGTH: 0
#driver_BBMCLKS: 4
#driver_BBMTIME: 0
#driver_FILT_ISENSE: 0
#   Set the given register during the configuration of the TMC5160
#   chip. This may be used to set custom motor parameters. The
#   defaults for each parameter are next to the parameter name in the
#   above list.
#diag0_pin:
#diag1_pin:
#   The micro-controller pin attached to one of the DIAG lines of the
#   TMC5160 chip. Only a single diag pin should be specified. The pin
#   is "active low" and is thus normally prefaced with "^!". Setting
#   this creates a "tmc5160_stepper_x:virtual_endstop" virtual pin
#   which may be used as the stepper's endstop_pin. Doing this enables
#   "sensorless homing". (Be sure to also set driver_SGT to an
#   appropriate sensitivity value.) The default is to not enable
#   sensorless homing.
```

## Configurazione della corrente del motore passo-passo a run-time

### [ad5206]

Digipot AD5206 configurati staticamente collegati tramite bus SPI (si può definire un numero qualsiasi di sezioni con un prefisso "ad5206").

```
[ad5206 my_digipot]
enable_pin:
#   The pin corresponding to the AD5206 chip select line. This pin
#   will be set to low at the start of SPI messages and raised to high
#   after the message completes. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
#channel_1:
#channel_2:
#channel_3:
#channel_4:
#channel_5:
#channel_6:
#   The value to statically set the given AD5206 channel to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest resistance and 0.0 being the lowest resistance. However,
#   the range may be changed with the 'scale' parameter (see below).
#   If a channel is not specified then it is left unconfigured.
#scale:
#   This parameter can be used to alter how the 'channel_x' parameters
#   are interpreted. If provided, then the 'channel_x' parameters
#   should be between 0.0 and 'scale'. This may be useful when the
#   AD5206 is used to set stepper voltage references. The 'scale' can
#   be set to the equivalent stepper amperage if the AD5206 were at
#   its highest resistance, and then the 'channel_x' parameters can be
#   specified using the desired amperage value for the stepper. The
#   default is to not scale the 'channel_x' parameters.
```

### [mcp4451]

Digipot MCP4451 configurato staticamente collegato tramite bus I2C (si può definire un numero qualsiasi di sezioni con un prefisso "mcp4451").

```
[mcp4451 my_digipot]
i2c_address:
#   The i2c address that the chip is using on the i2c bus. This
#   parameter must be provided.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#wiper_0:
#wiper_1:
#wiper_2:
#wiper_3:
#   The value to statically set the given MCP4451 "wiper" to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest resistance and 0.0 being the lowest resistance. However,
#   the range may be changed with the 'scale' parameter (see below).
#   If a wiper is not specified then it is left unconfigured.
#scale:
#   This parameter can be used to alter how the 'wiper_x' parameters
#   are interpreted. If provided, then the 'wiper_x' parameters should
#   be between 0.0 and 'scale'. This may be useful when the MCP4451 is
#   used to set stepper voltage references. The 'scale' can be set to
#   the equivalent stepper amperage if the MCP4451 were at its highest
#   resistance, and then the 'wiper_x' parameters can be specified
#   using the desired amperage value for the stepper. The default is
#   to not scale the 'wiper_x' parameters.
```

### [mcp4728]

Convertitore digitale-analogico MCP4728 in configurazione statica collegato tramite bus I2C (è possibile definire un numero qualsiasi di sezioni con prefisso "mcp4728").

```
[mcp4728 my_dac]
#i2c_address: 96
#   The i2c address that the chip is using on the i2c bus. The default
#   is 96.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
#channel_a:
#channel_b:
#channel_c:
#channel_d:
#   The value to statically set the given MCP4728 channel to. This is
#   typically set to a number between 0.0 and 1.0 with 1.0 being the
#   highest voltage (2.048V) and 0.0 being the lowest voltage.
#   However, the range may be changed with the 'scale' parameter (see
#   below). If a channel is not specified then it is left
#   unconfigured.
#scale:
#   This parameter can be used to alter how the 'channel_x' parameters
#   are interpreted. If provided, then the 'channel_x' parameters
#   should be between 0.0 and 'scale'. This may be useful when the
#   MCP4728 is used to set stepper voltage references. The 'scale' can
#   be set to the equivalent stepper amperage if the MCP4728 were at
#   its highest voltage (2.048V), and then the 'channel_x' parameters
#   can be specified using the desired amperage value for the
#   stepper. The default is to not scale the 'channel_x' parameters.
```

### [mcp4018]

Digipot MCP4018 configurato staticamente collegato tramite due pin gpio "bit banging" (si può definire un numero qualsiasi di sezioni con un prefisso "mcp4018").

```
[mcp4018 my_digipot]
scl_pin:
#   Il pin "clock" SCL. Questo parametro deve essere fornito.
sda_pin:
#   Il pin "dati" SDA. Questo parametro deve essere fornito.
wiper:
#   Il valore su cui impostare staticamente il "Wiper" MCP4018
#   specificato. Questo è in genere impostato su un numero compreso
#   tra 0,0 e 1,0 con 1,0 come resistenza più alta e 0,0 come resistenza
#   più bassa. Tuttavia, l'intervallo può essere modificato con il
#   parametro 'scale' (vedi sotto). Questo parametro deve essere fornito.
#scale:
#   Questo parametro può essere utilizzato per modificare il modo in
#   cui viene interpretato il parametro 'wiper'. Se fornito, il parametro
#   'wiper' dovrebbe essere compreso tra 0.0 e 'scale'. Questo può essere
#   utile quando l'MCP4018 viene utilizzato per impostare i riferimenti di
#   tensione stepper. La "scala" può essere impostata sull'amperaggio
#   stepper equivalente se l'MCP4018 è alla sua massima resistenza,
#   quindi è possibile specificare il parametro "wiper" utilizzando il
#   valore di amperaggio desiderato per lo stepper. L'impostazione
#   predefinita è di non ridimensionare il parametro 'wiper'.
```

## Supporto display

### [display]

Supporto per un display collegato al microcontrollore.

```
[display]
lcd_type:
#   The type of LCD chip in use. This may be "hd44780", "hd44780_spi",
#   "aip31068_spi", "st7920", "emulated_st7920", "uc1701", "ssd1306", or
#   "sh1106".
#   See the display sections below for information on each type and
#   additional parameters they provide. This parameter must be
#   provided.
#display_group:
#   The name of the display_data group to show on the display. This
#   controls the content of the screen (see the "display_data" section
#   for more information). The default is _default_20x4 for hd44780 or
#   aip31068_spi displays and _default_16x4 for other displays.
#menu_timeout:
#   Timeout for menu. Being inactive this amount of seconds will
#   trigger menu exit or return to root menu when having autorun
#   enabled. The default is 0 seconds (disabled)
#menu_root:
#   Name of the main menu section to show when clicking the encoder
#   on the home screen. The defaults is __main, and this shows the
#   the default menus as defined in klippy/extras/display/menu.cfg
#menu_reverse_navigation:
#   When enabled it will reverse up and down directions for list
#   navigation. The default is False. This parameter is optional.
#encoder_pins:
#   The pins connected to encoder. 2 pins must be provided when using
#   encoder. This parameter must be provided when using menu.
#encoder_steps_per_detent:
#   How many steps the encoder emits per detent ("click"). If the
#   encoder takes two detents to move between entries or moves two
#   entries from one detent, try changing this. Allowed values are 2
#   (half-stepping) or 4 (full-stepping). The default is 4.
#click_pin:
#   The pin connected to 'enter' button or encoder 'click'. This
#   parameter must be provided when using menu. The presence of an
#   'analog_range_click_pin' config parameter turns this parameter
#   from digital to analog.
#back_pin:
#   The pin connected to 'back' button. This parameter is optional,
#   menu can be used without it. The presence of an
#   'analog_range_back_pin' config parameter turns this parameter from
#   digital to analog.
#up_pin:
#   The pin connected to 'up' button. This parameter must be provided
#   when using menu without encoder. The presence of an
#   'analog_range_up_pin' config parameter turns this parameter from
#   digital to analog.
#down_pin:
#   The pin connected to 'down' button. This parameter must be
#   provided when using menu without encoder. The presence of an
#   'analog_range_down_pin' config parameter turns this parameter from
#   digital to analog.
#kill_pin:
#   The pin connected to 'kill' button. This button will call
#   emergency stop. The presence of an 'analog_range_kill_pin' config
#   parameter turns this parameter from digital to analog.
#analog_pullup_resistor: 4700
#   The resistance (in ohms) of the pullup attached to the analog
#   button. The default is 4700 ohms.
#analog_range_click_pin:
#   The resistance range for a 'enter' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_back_pin:
#   The resistance range for a 'back' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_up_pin:
#   The resistance range for a 'up' button. Range minimum and maximum
#   comma-separated values must be provided when using analog button.
#analog_range_down_pin:
#   The resistance range for a 'down' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
#analog_range_kill_pin:
#   The resistance range for a 'kill' button. Range minimum and
#   maximum comma-separated values must be provided when using analog
#   button.
```

#### display hd44780

Informazioni sulla configurazione dei display hd44780 (utilizzati nei display di tipo "RepRapDiscount 2004 Smart Controller").

```
[display]
lcd_type: hd44780
#   Set to "hd44780" for hd44780 displays.
rs_pin:
e_pin:
d4_pin:
d5_pin:
d6_pin:
d7_pin:
#   The pins connected to an hd44780 type lcd. These parameters must
#   be provided.
#hd44780_protocol_init: True
#   Perform 8-bit/4-bit protocol initialization on an hd44780 display.
#   This is necessary on real hd44780 devices. However, one may need
#   to disable this on some "clone" devices. The default is True.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### display hd44780_spi

Informazioni sulla configurazione di un display hd44780_spi - un display 20x04 controllato tramite uno "shift register" hardware (che viene utilizzato nelle stampanti basate su mightyboard).

```
[display]
lcd_type: hd44780_spi
#   Set to "hd44780_spi" for hd44780_spi displays.
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to the shift register controlling the display.
#   The spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the shift register does not have a MISO pin,
#   but the software spi implementation requires this pin to be
#   configured.
#hd44780_protocol_init: True
#   Perform 8-bit/4-bit protocol initialization on an hd44780 display.
#   This is necessary on real hd44780 devices. However, one may need
#   to disable this on some "clone" devices. The default is True.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### aip31068_spi display

Information on configuring an aip31068_spi display - a very similar to hd44780_spi a 20x04 (20 symbols by 4 lines) display with slightly different internal protocol.

```
[display]
lcd_type: aip31068_spi
latch_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to the shift register controlling the display.
#   The spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the shift register does not have a MISO pin,
#   but the software spi implementation requires this pin to be
#   configured.
#line_length:
#   Set the number of characters per line for an hd44780 type lcd.
#   Possible values are 20 (default) and 16. The number of lines is
#   fixed to 4.
...
```

#### display st7920

Informazioni sulla configurazione dei display st7920 (utilizzati nei display di tipo "RepRapDiscount 12864 Full Graphic Smart Controller").

```
[display]
lcd_type: st7920
#   Set to "st7920" for st7920 displays.
cs_pin:
sclk_pin:
sid_pin:
#   The pins connected to an st7920 type lcd. These parameters must be
#   provided.
...
```

#### display emulazione emulated_st7920

Informazioni sulla configurazione di un display st7920 emulato, presenti in alcuni "dispositivi touchscreen da 2,4 pollici" e simili.

```
[display]
lcd_type: emulated_st7920
#   Set to "emulated_st7920" for emulated_st7920 displays.
en_pin:
spi_software_sclk_pin:
spi_software_mosi_pin:
spi_software_miso_pin:
#   The pins connected to an emulated_st7920 type lcd. The en_pin
#   corresponds to the cs_pin of the st7920 type lcd,
#   spi_software_sclk_pin corresponds to sclk_pin and
#   spi_software_mosi_pin corresponds to sid_pin. The
#   spi_software_miso_pin needs to be set to an unused pin of the
#   printer mainboard as the st7920 as no MISO pin but the software
#   spi implementation requires this pin to be configured.
...
```

#### display uc1701

Informazioni sulla configurazione dei display uc1701 (utilizzati nei display di tipo "MKS Mini 12864").

```
[display]
lcd_type: uc1701
#   Set to "uc1701" for uc1701 displays.
cs_pin:
a0_pin:
#   The pins connected to a uc1701 type lcd. These parameters must be
#   provided.
#rst_pin:
#   The pin connected to the "rst" pin on the lcd. If it is not
#   specified then the hardware must have a pull-up on the
#   corresponding lcd line.
#contrast:
#   The contrast to set. The value may range from 0 to 63 and the
#   default is 40.
...
```

#### display ssd1306 e sh1106

Informazioni sulla configurazione dei display ssd1306 e sh1106.

```
[display]
lcd_type:
#   Set to either "ssd1306" or "sh1106" for the given display type.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   Optional parameters available for displays connected via an i2c
#   bus. See the "common I2C settings" section for a description of
#   the above parameters.
#cs_pin:
#dc_pin:
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   The pins connected to the lcd when in "4-wire" spi mode. See the
#   "common SPI settings" section for a description of the parameters
#   that start with "spi_". The default is to use i2c mode for the
#   display.
#reset_pin:
#   A reset pin may be specified on the display. If it is not
#   specified then the hardware must have a pull-up on the
#   corresponding lcd line.
#contrast:
#   The contrast to set. The value may range from 0 to 256 and the
#   default is 239.
#vcomh: 0
#   Set the Vcomh value on the display. This value is associated with
#   a "smearing" effect on some OLED displays. The value may range
#   from 0 to 63. Default is 0.
#invert: False
#   TRUE inverts the pixels on certain OLED displays.  The default is
#   False.
#x_offset: 0
#   Set the horizontal offset value on SH1106 displays. The default is
#   0.
...
```

### [display_data]

Supporto per la visualizzazione di dati personalizzati su uno schermo LCD. È possibile creare un numero qualsiasi di gruppi di visualizzazione e un numero qualsiasi di elementi di dati in quei gruppi. Il display mostrerà tutti gli elementi di dati per un determinato gruppo se l'opzione display_group nella sezione [display] è impostata sul nome del gruppo specificato.

Viene creato automaticamente un [default set of display groups](../klippy/extras/display/display.cfg) . È possibile sostituire o estendere questi elementi display_data sovrascrivendo i valori predefiniti nel file di configurazione principale printer.cfg .

```
[display_data my_group_name my_data_name]
position:
#   Comma separated row and column of the display position that should
#   be used to display the information. This parameter must be
#   provided.
text:
#   The text to show at the given position. This field is evaluated
#   using command templates (see docs/Command_Templates.md). This
#   parameter must be provided.
```

### [display_template]

Visualizza il testo dei dati "macro" (è possibile definire un numero qualsiasi di sezioni con un prefisso display_template). Per informazioni sul template, vedere il documento [template di comandi](Command_Templates.md).

Questa funzione consente di ridurre le definizioni ripetitive nelle sezioni display_data. Si può usare la funzione incorporata `render()` nelle sezioni display_data per valutare un template. Per esempio, se si dovesse definire `[display_template my_template]` allora si potrebbe usare `{ render('my_template') }` in una sezione display_data.

Questa funzione può essere utilizzata anche per aggiornamenti LED continui utilizzando il comando [SET_LED_TEMPLATE](G-Codes.md#set_led_template).

```
[display_template my_template_name]
#param_<name>:
#   One may specify any number of options with a "param_" prefix. The
#   given name will be assigned the given value (parsed as a Python
#   literal) and will be available during macro expansion. If the
#   parameter is passed in the call to render() then that value will
#   be used during macro expansion. For example, a config with
#   "param_speed = 75" might have a caller with
#   "render('my_template_name', param_speed=80)". Parameter names may
#   not use upper case characters.
text:
#   The text to return when the this template is rendered. This field
#   is evaluated using command templates (see
#   docs/Command_Templates.md). This parameter must be provided.
```

### [display_glyph]

Visualizza un glifo personalizzato sui display che lo supportano. Al nome dato verranno assegnati i dati di visualizzazione dati che possono quindi essere referenziati nei modelli di visualizzazione con il loro nome circondato da due simboli "tilde" per esempio `~my_display_glyph~`

Vedere [sample-glyphs.cfg](../config/sample-glyphs.cfg) per alcuni esempi.

```
[display_glyph my_display_glyph]
#data:
#   The display data, stored as 16 lines consisting of 16 bits (1 per
#   pixel) where '.' is a blank pixel and '*' is an on pixel (e.g.,
#   "****************" to display a solid horizontal line).
#   Alternatively, one can use '0' for a blank pixel and '1' for an on
#   pixel. Put each display line into a separate config line. The
#   glyph must consist of exactly 16 lines with 16 bits each. This
#   parameter is optional.
#hd44780_data:
#   Glyph to use on 20x4 hd44780 displays. The glyph must consist of
#   exactly 8 lines with 5 bits each. This parameter is optional.
#hd44780_slot:
#   The hd44780 hardware index (0..7) to store the glyph at. If
#   multiple distinct images use the same slot then make sure to only
#   use one of those images in any given screen. This parameter is
#   required if hd44780_data is specified.
```

### [display my_extra_display]

Se in printer.cfg è stata definita una sezione primaria [display] come mostrato sopra, è possibile definire più display ausiliari. Si noti che i display ausiliari attualmente non supportano la funzionalità del menu, quindi non supportano le opzioni del "menu" o la configurazione dei pulsanti.

```
[display my_extra_display]
# Vedere la sezione "display" per i parametri disponibili.
```

### [menu]

Menu display lcd personalizzabili.

Viene creato automaticamente un [default set of menus](../klippy/extras/display/menu.cfg) . È possibile sostituire o estendere il menu sovrascrivendo le impostazioni predefinite nel file di configurazione principale printer.cfg .

Consulta il [command template document](Command_Templates.md#menu-templates) per informazioni sugli attributi di menu disponibili durante il rendering del modello.

```
# Common parameters available for all menu config sections.
#[menu __some_list __some_name]
#type: disabled
#   Permanently disabled menu element, only required attribute is 'type'.
#   Allows you to easily disable/hide existing menu items.

#[menu some_name]
#type:
#   One of command, input, list, text:
#       command - basic menu element with various script triggers
#       input   - same like 'command' but has value changing capabilities.
#                 Press will start/stop edit mode.
#       list    - it allows for menu items to be grouped together in a
#                 scrollable list.  Add to the list by creating menu
#                 configurations using "some_list" as a prefix - for
#                 example: [menu some_list some_item_in_the_list]
#       vsdlist - same as 'list' but will append files from virtual sdcard
#                 (will be removed in the future)
#name:
#   Name of menu item - evaluated as a template.
#enable:
#   Template that evaluates to True or False.
#index:
#   Position where an item needs to be inserted in list. By default
#   the item is added at the end.

#[menu some_list]
#type: list
#name:
#enable:
#   See above for a description of these parameters.

#[menu some_list some_command]
#type: command
#name:
#enable:
#   See above for a description of these parameters.
#gcode:
#   Script to run on button click or long click. Evaluated as a
#   template.

#[menu some_list some_input]
#type: input
#name:
#enable:
#   See above for a description of these parameters.
#input:
#   Initial value to use when editing - evaluated as a template.
#   Result must be float.
#input_min:
#   Minimum value of range - evaluated as a template. Default -99999.
#input_max:
#   Maximum value of range - evaluated as a template. Default 99999.
#input_step:
#   Editing step - Must be a positive integer or float value. It has
#   internal fast rate step. When "(input_max - input_min) /
#   input_step > 100" then fast rate step is 10 * input_step else fast
#   rate step is same input_step.
#realtime:
#   This attribute accepts static boolean value. When enabled then
#   gcode script is run after each value change. The default is False.
#gcode:
#   Script to run on button click, long click or value change.
#   Evaluated as a template. The button click will trigger the edit
#   mode start or end.
```

## Sensori di filamento

### [filament_switch_sensor]

Sensore del filamento a interruttore. Supporto per l'inserimento del filamento e il rilevamento dell'esaurimento tramite un sensore interruttore, come un interruttore di fine corsa.

Per ulteriori informazioni, vedere [command reference](G-Codes.md#filament_switch_sensor).

```
[filament_switch_sensor my_sensor]
#pause_on_runout: True
#   Se impostato su True, verrà eseguita una PAUSA immediatamente
#   dopo il rilevamento di un'eccentricità. Si noti che se pause_on_runout
#   è False e runout_gcode viene omesso, il rilevamento dell'eccentricità
#   è disabilitato. L'impostazione predefinita è Vero.
#runout_gcode:
#   Un elenco di comandi G-Code da eseguire dopo il rilevamento di
#   un'esaurimento del filamento. Vedi docs/Command_Templates.md
#   per il formato G-Code. Se pause_on_runout è impostato su True,
#   questo codice G verrà eseguito al termine della PAUSA.
#   L'impostazione predefinita è di non eseguire alcun comando G-Code.
#insert_gcode:
#   Un elenco di comandi G-Code da eseguire dopo il rilevamento
#   dell'inserimento di filamento. Vedi docs/Command_Templates.md
#   per il formato G-Code. L'impostazione predefinita non prevede
#   l'esecuzione di alcun comando G-Code, che disabilita il rilevamento
#   dell'inserimento.
#event_delay: 3.0
#   Il tempo minimo in secondi per ritardare tra gli eventi. Gli eventi
#   attivati durante questo periodo di tempo verranno ignorati
#   silenziosamente. L'impostazione predefinita è 3 secondi.
#pause_delay: 0.5
#   Il tempo di ritardo, in secondi, tra l'invio del comando pause e
#   l'esecuzione di runout_gcode. Potrebbe essere utile aumentare
#   questo ritardo se OctoPrint mostra uno strano comportamento
#   di pausa. Il valore predefinito è 0,5 secondi.
#switch_pin:
#   Il pin su cui è collegato l'interruttore.
#   Questo parametro deve essere fornito.
```

### [filament_motion_sensor]

Sensore di movimento del filamento. Supporto per l'inserimento del filamento e il rilevamento dell'esaurimento mediante un codificatore che commuta il pin di uscita durante il movimento del filamento attraverso il sensore.

Per ulteriori informazioni, vedere [command reference](G-Codes.md#filament_switch_sensor).

```
[filament_motion_sensor my_sensor]
detection_length: 7.0
#   La lunghezza minima di filamento tirato attraverso il sensore
#   per attivare un cambio di stato su switch_pin
#   Il default è 7 mm.
extruder:
#   Nome della sezione extruder section con cui questo sensore è associato.
#   Questo parametro deve essere fornito.
switch_pin:
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   Vedere la sezione "filament_switch_sensor" per la descrizione dei
#   parametri riportati sopra.
```

### [tsl1401cl_filament_width_sensor]

Sensore di larghezza del filamento basato su TSLl401CL. Consulta la [guida](TSL1401CL_Filament_Width_Sensor.md) per ulteriori informazioni.

```
sl1401cl_filament_width_sensor]
#pin:
#diametro nominale del filamento predefinito: 1,75 (mm)
#   Differenza massima consentita del diametro del filamento in mm.
#max_difference: 0.2
#   La distanza dal sensore alla camera di fusione in mm.
#measurement_delay: 100
```

### [hall_filament_width_sensor]

Sensore di larghezza del filamento ad effetto Hall (vedere [Sensore di larghezza del filamento Hall](Hall_Filament_Width_Sensor.md)).

```
[hall_filament_width_sensor]
adc1:
adc2:
#   Pin di ingresso analogico collegati al sensore.
#   Questi parametri devono essere forniti.
#cal_dia1: 1.50
#cal_dia2: 2.00
#   I valori di calibrazione (in mm) per i sensori. Il valore predefinito
#   è 1.50 per cal_dia1 e 2.00 per cal_dia2.
#raw_dia1: 9500
#raw_dia2: 10500
#   I valori di calibrazione grezzi per i sensori. Il valore predefinito è
#   9500 per raw_dia1 e 10500 per raw_dia2.
#default_nominal_filament_diameter: 1.75
#   Il diametro nominale del filamento.
#   Questo parametro deve essere fornito.
#max_difference: 0.200
#   Differenza massima consentita del diametro del filamento in
#   millimetri (mm). Se la differenza tra il diametro nominale del
#   filamento e l'uscita del sensore è maggiore di +- max_difference,
#   il moltiplicatore di estrusione viene riportato a %100.
#   Il valore predefinito è 0,200.
#measurement_delay: 70
#   La distanza dal sensore alla camera di fusione/hot-end in
#   millimetri (mm). Il filamento tra il sensore e l'hot-end verrà
#   trattato come default_nominal_filament_diameter. Il modulo
#   host funziona con la logica FIFO. Mantiene ogni valore e posizione
#   del sensore in un array e li riporta nella posizione corretta.
#   Questo parametro deve essere fornito.
#enable: False
#   Sensore abilitato o disabilitato dopo l'accensione.
L'impostazione predefinita è disabilitare.
#measurement_interval: 10
#   La distanza approssimativa (in mm) tra le letture del sensore.
#   Il valore predefinito è 10 mm.
#logging: False
#   Il log esterno al terminale e klipper.log può essere 
#   attivato|off tramite comando.
#min_diameter: 1.0
#   Diametro minimo per trigger filament_switch_sensor virtuale.
#use_current_dia_while_delay: False
#   Utilizzare il diametro attuale invece del diametro nominale
#   mentre il ritardo di misurazione non è trascorso.
#pause_on_runout:
#runout_gcode:
#insert_gcode:
#event_delay:
#pause_delay:
#   Vedere la sezione "filament_switch_sensor" per una
#   descrizione dei parametri di cui sopra.
```

## Load Cells

### [load_cell]

Load Cell. Uses an ADC sensor attached to a load cell to create a digital scale.

```
[load_cell]
sensor_type:
#   This must be one of the supported sensor types, see below.
```

#### HX711

This is a 24 bit low sample rate chip using "bit-bang" communications. It is suitable for filament scales.

```
[load_cell]
sensor_type: hx711
sclk_pin:
#   The pin connected to the HX711 clock line. This parameter must be provided.
dout_pin:
#   The pin connected to the HX711 data output line. This parameter must be
#   provided.
#gain: A-128
#   Valid values for gain are: A-128, A-64, B-32. The default is A-128.
#   'A' denotes the input channel and the number denotes the gain. Only the 3
#   listed combinations are supported by the chip. Note that changing the gain
#   setting also selects the channel being read.
#sample_rate: 80
#   Valid values for sample_rate are 80 or 10. The default value is 80.
#   This must match the wiring of the chip. The sample rate cannot be changed
#   in software.
```

#### HX717

This is the 4x higher sample rate version of the HX711, suitable for probing.

```
[load_cell]
sensor_type: hx717
sclk_pin:
#   The pin connected to the HX717 clock line. This parameter must be provided.
dout_pin:
#   The pin connected to the HX717 data output line. This parameter must be
#   provided.
#gain: A-128
#   Valid values for gain are A-128, B-64, A-64, B-8.
#   'A' denotes the input channel and the number denotes the gain setting.
#   Only the 4 listed combinations are supported by the chip. Note that
#   changing the gain setting also selects the channel being read.
#sample_rate: 320
#   Valid values for sample_rate are: 10, 20, 80, 320. The default is 320.
#   This must match the wiring of the chip. The sample rate cannot be changed
#   in software.
```

#### ADS1220

The ADS1220 is a 24 bit ADC supporting up to a 2Khz sample rate configurable in software.

```
[load_cell]
sensor_type: ads1220
cs_pin:
#   The pin connected to the ADS1220 chip select line. This parameter must
#   be provided.
#spi_speed: 512000
#   This chip supports 2 speeds: 256000 or 512000. The faster speed is only
#   enabled when one of the Turbo sample rates is used. The correct spi_speed
#   is selected based on the sample rate.
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
data_ready_pin:
#   Pin connected to the ADS1220 data ready line. This parameter must be
#   provided.
#gain: 128
#   Valid gain values are 128, 64, 32, 16, 8, 4, 2, 1
#   The default is 128
#pga_bypass: False
#   Disable the internal Programmable Gain Amplifier. If
#   True the PGA will be disabled for gains 1, 2, and 4. The PGA is always
#   enabled for gain settings 8 to 128, regardless of the pga_bypass setting.
#   If AVSS is used as an input pga_bypass is forced to True.
#   The default is False.
#sample_rate: 660
#   This chip supports two ranges of sample rates, Normal and Turbo. In turbo
#   mode the chip's internal clock runs twice as fast and the SPI communication
#   speed is also doubled.
#   Normal sample rates: 20, 45, 90, 175, 330, 600, 1000
#   Turbo sample rates: 40, 90, 180, 350, 660, 1200, 2000
#   The default is 660
#input_mux:
#   Input multiplexer configuration, select a pair of pins to use. The first pin
#   is the positive, AINP, and the second pin is the negative, AINN. Valid
#   values are: 'AIN0_AIN1', 'AIN0_AIN2', 'AIN0_AIN3', 'AIN1_AIN2', 'AIN1_AIN3',
#   'AIN2_AIN3', 'AIN1_AIN0', 'AIN3_AIN2', 'AIN0_AVSS', 'AIN1_AVSS', 'AIN2_AVSS'
#   and 'AIN3_AVSS'. If AVSS is used the PGA is bypassed and the pga_bypass
#   setting will be forced to True.
#   The default is AIN0_AIN1.
#vref:
#   The selected voltage reference. Valid values are: 'internal', 'REF0', 'REF1'
#   and 'analog_supply'. Default is 'internal'.
```

## Supporto hardware per specifica scheda

### [sx1509]

Configurare un'espansione SX1509 da I2C a GPIO. A causa del ritardo dovuto alla comunicazione I2C, NON utilizzare i pin SX1509 come abilitazione stepper, pin step o dir o qualsiasi altro pin che richieda un bit banging veloce. Sono utilizzati al meglio come uscite digitali statiche o controllate da gcode o pin hardware-pwm per es. fan. Si può definire un numero qualsiasi di sezioni con un prefisso "sx1509". Ogni espansione fornisce un set di 16 pin (da sx1509_my_sx1509:PIN_0 a sx1509_my_sx1509:PIN_15) che possono essere utilizzati nella configurazione della stampante.

Per un esempio, vedere il file [generic-duet2-duex.cfg](../config/generic-duet2-duex.cfg).

```
[sx1509 my_sx1509]
i2c_address:
#   I2C address used by this expander. Depending on the hardware
#   jumpers this is one out of the following addresses: 62 63 112
#   113. This parameter must be provided.
#i2c_mcu:
#i2c_bus:
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#i2c_speed:
#   See the "common I2C settings" section for a description of the
#   above parameters.
```

### [samd_sercom]

Configurazione SAMD SERCOM per specificare quali pin utilizzare su un determinato SERCOM. Si può definire un numero qualsiasi di sezioni con un prefisso "samd_sercom". Ogni SERCOM deve essere configurato prima di utilizzarlo come periferica SPI o I2C. Posiziona questa sezione di configurazione sopra qualsiasi altra sezione che fa uso di bus SPI o I2C.

```
[samd_sercom my_sercom]
sercom:
#   Il nome del bus Sercom da configurare nel microcontrollore. I nomi
#   disponibili sono "sercom0", "sercom1", ecc.
#   Questo parametro deve essere fornito.
tx_pin:
#   Pin MOSI per la comunicazione SPI o pin SDA (dati) per la
#   comunicazione I2C. Il pin deve avere una configurazione pinmux
#   valida per la specifica periferica SERCOM.
#   Questo parametro deve essere fornito.
#rx_pin:
#   Pin MISO per la comunicazione SPI. Questo pin non viene utilizzato
#   per la comunicazione I2C (I2C utilizza tx_pin sia per l'invio che per la
#   ricezione). Il pin deve avere una configurazione pinmux valida per la
#   specifica periferica SERCOM. Questo parametro è facoltativo.
clk_pin:
#   Pin CLK per la comunicazione SPI o pin SCL (clock) per la
#   comunicazione I2C. Il pin deve avere una configurazione pinmux
#   valida per la specifica periferica SERCOM. Questo parametro deve
#   essere fornito.
```

### [adc_scaled]

Scaling analogico di Duet2 Maestro tramite letture vref e vssa. La definizione di una sezione adc_scaled abilita pin adc virtuali (come "my_name:PB0") che vengono regolati automaticamente dai pin di monitoraggio vref e vssa della scheda. Assicurati di definire questa sezione di configurazione sopra qualsiasi sezione di configurazione che utilizza uno di questi pin virtuali.

Per un esempio, vedere il file [generic-duet2-maestro.cfg](../config/generic-duet2-maestro.cfg).

```
[adc_scaled my_name]
vref_pin:
#   The ADC pin to use for VREF monitoring. This parameter must be
#   provided.
vssa_pin:
#   The ADC pin to use for VSSA monitoring. This parameter must be
#   provided.
#smooth_time: 2.0
#   A time value (in seconds) over which the vref and vssa
#   measurements will be smoothed to reduce the impact of measurement
#   noise. The default is 2 seconds.
```

### [replicape]

Supporto per Replicape: vedere la [guida beaglebone](Beaglebone.md) e il file [generic-replicape.cfg](../config/generic-replicape.cfg) per un esempio.

```
# La sezione di configurazione "replicape" aggiunge i pin di abilitazione
# dello stepper virtuale "replicape: stepper_x_enable" (per stepper X, Y, Z,
# E e H) e i pin di uscita PWM "replicape: power_x" (per hotbed, e, h, fan0,
# fan1 , fan2 e fan3) che possono quindi essere utilizzati altrove nel file
# di configurazione.
[replicape]
revision:
#   La revisione dell'hardware di replicape. Attualmente è supportata solo
#   la revisione "B3". Questo parametro deve essere fornito.
#enable_pin: !gpio0_20
#   Il pin di abilitazione globale dei replicape. L'impostazione predefinita
#   è !gpio0_20 (aka P9_41).
host_mcu:
#   Il nome della sezione mcu config che comunica con l'istanza mcu
#   "linux process" di Klipper. Questo parametro deve essere fornito.
#standstill_power_down: False
#   Questo parametro controlla la linea CFG6_ENN su tutti i motori
#   passo-passo. True imposta le righe di abilitazione su "open".
#   L'impostazione predefinita è Falso.
#stepper_x_microstep_mode:
#stepper_y_microstep_mode:
#stepper_z_microstep_mode:
#stepper_e_microstep_mode:
#stepper_h_microstep_mode:
#   Questo parametro controlla i pin CFG1 e CFG2 del driver del motore
#   passo-passo specificato. Le opzioni disponibili sono: disabilita, 1, 2,
#   spread2, 4, 16, spread4, spread16, stealth4 e stealth16. L'impostazione
#   predefinita è disabilitata.
#stepper_x_current:
#stepper_y_current:
#stepper_z_current:
#stepper_e_current:
#stepper_h_current:
#   La corrente massima configurata (in Amp) del driver del motore
#   passo-passo. Questo parametro deve essere fornito se lo stepper non
#   è in modalità disabilitazione.
#stepper_x_chopper_off_time_high:
#stepper_y_chopper_off_time_high:
#stepper_z_chopper_off_time_high:
#stepper_e_chopper_off_time_high:
#stepper_h_chopper_off_time_high:
#   Questo parametro controlla il pin CFG0 del driver del motore
#   passo-passo (True imposta CFG0 alto, False lo imposta basso).
#   L'impostazione predefinita è False.
#stepper_x_chopper_hysteresis_high:
#stepper_y_chopper_hysteresis_high:
#stepper_z_chopper_hysteresis_high:
#stepper_e_chopper_hysteresis_high:
#stepper_h_chopper_hysteresis_high:
#   Questo parametro controlla il pin CFG4 del driver del motore
#   passo-passo (True imposta CFG4 alto, False lo imposta basso).
#   L'impostazione predefinita è False.
#stepper_x_chopper_blank_time_high:
#stepper_y_chopper_blank_time_high:
#stepper_z_chopper_blank_time_high:
#stepper_e_chopper_blank_time_high:
#stepper_h_chopper_blank_time_high:
#   Questo parametro controlla il pin CFG5 del driver del motore
#   passo-passo (True imposta CFG5 alto, False lo imposta basso).
#   L'impostazione predefinita è True.
```

## Altri moduli personalizzati

### [palette2]

Supporto multimateriale Palette 2: fornisce un'integrazione più stretta supportando i dispositivi Palette 2 in modalità connessa.

Questo modulo richiede anche `[virtual_sdcard]` e `[pause_resume]` per la piena funzionalità.

Se si utilizza questo modulo, non utilizzare il plug-in Palette 2 per Octoprint poiché entreranno in conflitto e 1 non si inizializzerà correttamente, probabilmente interrompendo la stampa.

Se utilizzi Octoprint e esegui lo streaming di gcode sulla porta seriale invece di stampare da virtual_sd, rimuovere **M1** e **M0** da *Pausa dei comandi* in *Impostazioni > Connessione seriale > Firmware e protocollo* eviterà la necessità per avviare la stampa sulla tavolozza 2 e riattivare la pausa in Octoprint per avviare la stampa.

```
[palette2]
serial:
#   The serial port to connect to the Palette 2.
#baud: 115200
#   The baud rate to use. The default is 115200.
#feedrate_splice: 0.8
#   The feedrate to use when splicing, default is 0.8
#feedrate_normal: 1.0
#   The feedrate to use after splicing, default is 1.0
#auto_load_speed: 2
#   Extrude feedrate when autoloading, default is 2 (mm/s)
#auto_cancel_variation: 0.1
#   Auto cancel print when ping variation is above this threshold
```

### [angle]

Magnetic hall angle sensor support for reading stepper motor angle shaft measurements using a1333, as5047d, mt6816, mt6826s, or tle5012b SPI chips. The measurements are available via the [API Server](API_Server.md) and [motion analysis tool](Debugging.md#motion-analysis-and-data-logging). See the [G-Code reference](G-Codes.md#angle) for available commands.

```
[angle my_angle_sensor]
sensor_type:
#   The type of the magnetic hall sensor chip. Available choices are
#   "a1333", "as5047d", "mt6816", "mt6826s", and "tle5012b". This parameter must be
#   specified.
#sample_period: 0.000400
#   The query period (in seconds) to use during measurements. The
#   default is 0.000400 (which is 2500 samples per second).
#stepper:
#   The name of the stepper that the angle sensor is attached to (eg,
#   "stepper_x"). Setting this value enables an angle calibration
#   tool. To use this feature, the Python "numpy" package must be
#   installed. The default is to not enable angle calibration for the
#   angle sensor.
cs_pin:
#   The SPI enable pin for the sensor. This parameter must be provided.
#spi_speed:
#spi_bus:
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   See the "common SPI settings" section for a description of the
#   above parameters.
```

## Parametri bus comuni

### Impostazioni SPI comuni

I seguenti parametri sono generalmente disponibili per i dispositivi che utilizzano un bus SPI.

```
#spi_speed:
#   La velocità SPI (in Hz) da utilizzare durante la comunicazione con il
#   dispositivo. L'impostazione predefinita dipende dal tipo di dispositivo.
#spi_bus:
#   Se il microcontrollore supporta più bus SPI, è possibile specificare
#   qui il nome del bus del microcontrollore. L'impostazione predefinita
#   dipende dal tipo di microcontrollore.
#spi_software_sclk_pin:
#spi_software_mosi_pin:
#spi_software_miso_pin:
#   Specificare i parametri di cui sopra per utilizzare "SPI basato su
#   software". Questa modalità non richiede il supporto hardware del
#   microcontrollore (in genere è possibile utilizzare qualsiasi pin generico).
#   L'impostazione predefinita è di non utilizzare "spi software".
```

### Impostazioni I2C comuni

I seguenti parametri sono generalmente disponibili per i dispositivi che utilizzano un bus I2C.

Tieni presente che l'attuale supporto del microcontrollore di Klipper per I2C generalmente non tollera il rumore di linea. Errori imprevisti sui cavi I2C potrebbero far sì che Klipper sollevi un errore di runtime. Il supporto di Klipper per il ripristino degli errori varia a seconda del tipo di microcontrollore. In genere si consiglia di utilizzare solo dispositivi I2C che si trovano sullo stesso circuito stampato del microcontrollore.

Most Klipper micro-controller implementations only support an `i2c_speed` of 100000 (*standard mode*, 100kbit/s). The Klipper "Linux" micro-controller supports a 400000 speed (*fast mode*, 400kbit/s), but it must be [set in the operating system](RPi_microcontroller.md#optional-enabling-i2c) and the `i2c_speed` parameter is otherwise ignored. The Klipper "RP2040" micro-controller and ATmega AVR family and some STM32 (F0, G0, G4, L4, F7, H7) support a rate of 400000 via the `i2c_speed` parameter. All other Klipper micro-controllers use a 100000 rate and ignore the `i2c_speed` parameter.

```
#i2c_address:
#   The i2c address of the device. This must specified as a decimal
#   number (not in hex). The default depends on the type of device.
#i2c_mcu:
#   The name of the micro-controller that the chip is connected to.
#   The default is "mcu".
#i2c_bus:
#   If the micro-controller supports multiple I2C busses then one may
#   specify the micro-controller bus name here. The default depends on
#   the type of micro-controller.
#i2c_software_scl_pin:
#i2c_software_sda_pin:
#   Specify these parameters to use micro-controller software based
#   I2C "bit-banging" support. The two parameters should the two pins
#   on the micro-controller to use for the scl and sda wires. The
#   default is to use hardware based I2C support as specified by the
#   i2c_bus parameter.
#i2c_speed:
#   The I2C speed (in Hz) to use when communicating with the device.
#   The Klipper implementation on most micro-controllers is hard-coded
#   to 100000 and changing this value has no effect. The default is
#   100000. Linux, RP2040 and ATmega support 400000.
```
