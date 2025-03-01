# G-Codes

Ce document décrit les commandes que Klipper supporte. Il s'agit de commandes que l'on peut saisir dans l'onglet du terminal OctoPrint.

## Commandes G-Code

Klipper prend en charge les commandes G-Code standard suivantes :

- Move (G0 ou G1): `G1 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>]`
- Temporisation : `G4 P<millisecondes>`
- Déplacement vers l'origine : `G28 [X] [Y] [Z] `
- Éteindre les moteurs : `M18` ou `M84`
- Attendre la fin des mouvements en cours : `M400`
- Utiliser l'extrusion absolue/relative : `M82`, `M83`
- Utiliser des coordonnées absolues/relatives : `G90`, `G91`
- Définir la position : `G92 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] `
- Définir le pourcentage de neutralisation du facteur de vitesse : `M220 S<percent>`
- Définit le pourcentage d'annulation du facteur d'extrusion : `M221 S<percent>`
- Régler l'accélération : `M204 S<valeur>` OU `M204 P<valeur> T<valeur>`
   - Remarque : si S n'est pas spécifié et que P et T le sont, l'accélération sera réglée sur le minimum de P et T. Si un seul P ou T est donné, la commande n'aura aucun effet.
- Obtenir la température de l'extrudeur : `M105`
- Régler la température de l'extrudeur : `M104 [T<index>] [S<température>] `
- Régler la température de l'extrudeur et attendre : `M109 [T<index>] S<température> `
   - Note : M109 attendra toujours que la température se stabilise à la valeur demandée.
- Régler la température du bed : `M140 [S<temperature>]`
- Régler la température du bed et attendre : `M190 S<temperature>`
   - Note : M190 attendra toujours que la température se stabilise à la valeur demandée.
- Régler la vitesse du ventilateur : `M106 S<valeur>`
- Désactiver le ventilateur : `M107`
- Arrêt d'urgence : `M112`
- Obtenir la position actuelle : `M114`
- Obtenir la version du firmware : `M115`

Pour plus de détails sur les commandes ci-dessus, voir la [documentation RepRap G-Code] (http://reprap.org/wiki/G-code).

L'objectif de Klipper est de prendre en charge les commandes G-Code produites par les logiciels tiers courants (par exemple, OctoPrint, Printrun, Slic3r, Cura, etc.) dans leurs configurations standards. Le but n'est pas de prendre en charge toutes les commandes G-Code possibles. Au contraire, Klipper préfère les ["commandes G-Code étendues"] (#additional-commands) humainement lisibles. De la même manière, la sortie du terminal G-Code est uniquement destinée à être humainement lisible - voir le [document du serveur API](API_Server.md) si vous contrôlez Klipper depuis un logiciel externe.

Si vous avez besoin d'une commande G-Code moins courante, il est possible de l'implémenter avec une section de configuration [gcode_macro personnalisée](Config_Reference.md#gcode_macro). Par exemple, on peut utiliser ceci pour implémenter : `G12`, `G29`, `G30`, `G31`, `M42`, `M80`, `M81`, `T1`, etc.

## Commandes additionnelles

Klipper utilise des commandes G-Code "étendues" pour la configuration générale et l'état. Ces commandes étendues suivent toutes un format similaire : elles commencent par le nom de la commande et peuvent être suivies d'un ou plusieurs paramètres. Par exemple : `SET_SERVO SERVO=myservo ANGLE=5.3 `. Dans ce document, les commandes et les paramètres sont indiqués en majuscules, mais ils ne sont pas sensibles à la casse. (Ainsi, "SET_SERVO" et "set_servo" exécuteront tous deux la même commande).

Cette section est organisée par nom de module Klipper, en suivant généralement les noms de section spécifiés dans le [fichier de configuration de l'imprimante](Config_Reference.md). Notez que certains modules sont automatiquement chargés.

### [adxl345]

Les commandes suivantes sont disponibles lorsqu'une section [adxl345 config](Config_Reference.md#adxl345) est activée.

#### ACCELEROMETER_MEASURE

`ACCELEROMETER_MEASURE [CHIP=<nom_de_la_configuration>] [NAME=<valeur>]` : Démarre les mesures de l'accéléromètre au nombre d'échantillons par seconde demandé. Si CHIP n'est pas précisé, la valeur par défaut est "adxl345". La commande fonctionne en mode start-stop : exécutée pour la première fois, elle démarre les mesures, l'exécution suivante les arrête. Les résultats des mesures sont écrits dans un fichier nommé `/tmp/adxl345-<chip>-<nom>.csv` où `<chip>` est le nom de la puce accéléromètre (`my_chip_name` de `[adxl345 my_chip_name]`) et `<nom>` est le paramètre optionnel NAME. Si le paramètre NOM n'est pas précisé, l'heure actuelle est utilisée par défaut au format "AAAAMMJJ_HHMMSS". Si l'accéléromètre n'a pas de nom dans sa section de configuration (simplement `[adxl345]`) alors la partie `<chip>` du nom n'est pas générée.

#### ACCELEROMETER_QUERY

`ACCELEROMETER_QUERY [CHIP=<nom_de_la_configuration>] [RATE=<valeur>]` : interroge l'accéléromètre pour la valeur courante. Si CHIP n'est pas précisé, la valeur par défaut est "adxl345". Si RATE n'est pas précisé, la valeur par défaut est utilisée. Cette commande permet de tester la connexion à l'accéléromètre ADXL345 : une des valeurs retournées devrait être une accélération en chute libre (+/- un certain bruit de la puce).

#### ACCELEROMETER_DEBUG_READ

`ACCELEROMETER_DEBUG_READ [CHIP=<nom_de_la_configuration>] REG=<registre>` : interroge le registre ADXL345 "registre" (par exemple 44 ou 0x2C). Peut être utile à des fins de débogage.

#### ACCELEROMETER_DEBUG_WRITE

`ACCELEROMETER_DEBUG_WRITE [CHIP=<nom_de_la_configuration>] REG=<registre> VAL=<valeur>` : Ecrit la "valeur" brute dans le registre "registre". La "valeur" et le "registre" peuvent être des entiers décimaux ou hexadécimaux. A utiliser avec précaution, et se référer à la fiche technique de l'ADXL345 pour la référence.

### [angle]

Les commandes suivantes sont disponibles lorsqu'une section [angle config](Config_Reference.md#angle) est activée.

#### ANGLE_CALIBRATE

`ANGLE_CALIBRATE CHIP=<nom_de_la_puce>` : Effectue une calibration d'angle sur le capteur donné (il doit y avoir une section de configuration `[angle nom_de_la_puce]` qui a indiqué un paramètre `stepper`). IMPORTANT - cet outil commandera au moteur pas à pas de se déplacer sans vérifier les limites normales de la cinématique. Idéalement, le moteur devrait être déconnecté de tout chariot d'imprimante avant d'effectuer le calibrage. Si le moteur pas à pas ne peut pas être déconnecté de l'imprimante, assurez-vous que le chariot est proche du centre de son rail avant de commencer l'étalonnage. (Le moteur pas à pas peut se déplacer vers l'avant ou l'arrière de deux rotations complètes durant ce test). Après avoir terminé ce test, utilisez la commande `SAVE_CONFIG` pour sauvegarder les données de calibration dans le fichier de configuration. Afin d'utiliser cet outil, le paquetage Python "numpy" doit être installé (voir le document [mesurer les résonances](Measuring_Resonances.md#software-installation) pour plus d'informations).

#### ANGLE_CHIP_CALIBRATE

`ANGLE_CHIP_CALIBRATE CHIP=<chip_name>`: Perform internal sensor calibration, if implemented (MT6826S/MT6835).

- **MT68XX**: The motor should be disconnected from any printer carriage before performing calibration. After calibration, the sensor should be reset by disconnecting the power.

#### ANGLE_DEBUG_READ

`ANGLE_DEBUG_READ CHIP=<nom_de_la_configuration> REG=<registre>` : Interroge le registre "registre" du capteur (par exemple 44 ou 0x2C). Peut être utile à des fins de débogage. Ceci n'est disponible que pour les puces tle5012b.

#### ANGLE_DEBUG_WRITE

`ANGLE_DEBUG_WRITE CHIP=<nom_de_la_configuration> REG=<registre> VAL=<valeur>` : Écrit la "valeur" brute dans le registre "registre". La "valeur" et le "registre" peuvent être des entiers décimaux ou hexadécimaux. A utiliser avec précaution, et se référer à la fiche technique du capteur pour la référence. Cette fonction n'est disponible que pour les puces tle5012b.

### [axis_twist_compensation]

The following commands are available when the [axis_twist_compensation config
section](Config_Reference.md#axis_twist_compensation) is enabled.

#### AXIS_TWIST_COMPENSATION_CALIBRATE

`AXIS_TWIST_COMPENSATION_CALIBRATE [AXIS=<X|Y>] [AUTO=<True|False>] [SAMPLE_COUNT=<value>]`

Calibrates axis twist compensation by specifying the target axis or enabling automatic calibration.

- **AXIS:** Define the axis (`X` or `Y`) for which the twist compensation will be calibrated. If not specified, the axis defaults to `'X'`.
- **AUTO:** Enables automatic calibration mode. When `AUTO=True`, the calibration will run for both the X and Y axes. In this mode, `AXIS` cannot be specified. If both `AXIS` and `AUTO` are provided, an error will be raised.

### [bed_mesh]

Les commandes suivantes sont disponibles lorsque la section [configuration de bed_mesh](Config_Reference.md#bed_mesh) est activée (voir également le [guide de bed_mesh](Bed_Mesh.md)).

#### BED_MESH_CALIBRATE

`BED_MESH_CALIBRATE [PROFILE=<name>] [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=1] [ADAPTIVE_MARGIN=<value>]`: This command probes the bed using generated points specified by the parameters in the config. After probing, a mesh is generated and z-movement is adjusted according to the mesh. The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. See the PROBE command for details on the optional probe parameters. If METHOD=manual is specified then the manual probing tool is activated - see the MANUAL_PROBE command above for details on the additional commands available while this tool is active. The optional `HORIZONTAL_MOVE_Z` value overrides the `horizontal_move_z` option specified in the config file. If ADAPTIVE=1 is specified then the objects defined by the Gcode file being printed will be used to define the probed area. The optional `ADAPTIVE_MARGIN` value overrides the `adaptive_margin` option specified in the config file.

#### BED_MESH_OUTPUT

`BED_MESH_OUTPUT PGP=[<0:1>]` : Cette commande écrit les valeurs z palpées actuelles et les valeurs de maillage actuelles sur le terminal. Si PGP=1 est spécifié, les coordonnées X, Y générées par bed_mesh, ainsi que leurs indices associés, seront envoyés au terminal.

#### BED_MESH_MAP

`BED_MESH_MAP` : Comme pour BED_MESH_OUTPUT, cette commande affiche l'état actuel du maillage sur le terminal. L'état sera retourné au format json. Cela permet aux plugins octoprint de récupérer facilement les données et de générer des cartes d'altitude au plus proche de la surface du bed.

#### BED_MESH_CLEAR

`BED_MESH_CLEAR`: Cette commande efface le maillage actuel et supprime les ajustements de l'axe z. Il est recommandé de mettre cette commande dans votre gcode de fin.

#### BED_MESH_PROFILE

`BED_MESH_PROFILE LOAD=<nom> SAVE=<nom> REMOVE=<nom>` : Cette commande fournit une gestion de profil pour l'état du maillage. LOAD restaurera l'état du maillage à partir du profil correspondant au nom fourni. SAVE sauvegarde l'état du maillage actuel dans un profil correspondant au nom fourni. REMOVE supprimera le profil correspondant au nom fourni de la mémoire persistante. Notez qu'après l'exécution des opérations SAVE ou REMOVE, le gcode SAVE_CONFIG doit être exécuté pour rendre les changements de la mémoire persistante permanents.

#### BED_MESH_OFFSET

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value]`: Applies X, Y, and/or ZFADE offsets to the mesh lookup. This is useful for printers with independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Note that a ZFADE offset does not apply additional z-adjustment directly, it is used to correct the `fade` calculation when a `gcode offset` has been applied to the Z axis.

### [bed_screws]

Les commandes suivantes sont disponibles lorsque la section [config bed_screws](Config_Reference.md#bed_screws) est activée (voir également le [guide du nivelage manuel](Manual_Level.md#adjusting-bed-leveling-screws)).

#### BED_SCREWS_ADJUST

`BED_SCREWS_ADJUST`: Cette commande fait appel à l'outil de réglage des vis du bed. Elle commandera la buse à différents endroits (tels que définis dans le fichier de configuration) et permettra d'ajuster les vis du bed afin  que celui-ci et la buse soient à distance constante.

### [bed_tilt]

Les commandes suivantes sont disponibles lorsque la section [config bed_tilt](Config_Reference.md#bed_tilt) est activée.

#### BED_TILT_CALIBRATE

`BED_TILT_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Cette commande sondera les points spécifiés dans la configuration, puis recommandera des ajustements d'inclinaison x et y mis à jour. Voir la commande PROBE pour plus de détails sur les paramètres de sonde facultatifs. Si METHOD=manual est spécifié, l'outil de sondage manuel est activé - voir la commande MANUAL_PROBE ci-dessus pour plus de détails sur les commandes supplémentaires disponibles lorsque cet outil est actif. La valeur facultative `HORIZONTAL_MOVE_Z` remplace l'option `horizontal_move_z` spécifiée dans le fichier de configuration.

### [bltouch]

La commande suivante est disponible lorsqu'une section [bltouch config](Config_Reference.md#bltouch) est activée (voir également le [Guide BL-Touch](BLTouch.md)).

#### BLTOUCH_DEBUG

`BLTOUCH_DEBUG COMMAND=<commande>` : Ceci envoie une commande au BLTouch. Elle peut être utile pour le débogage. Les commandes disponibles sont : `pin_down`, `touch_mode`, `pin_up`, `self_test`, `reset`. Un BL-Touch V3.0 ou V3.1 accepte en plus les commandes `set_5V_output_mode`, `set_OD_output_mode`, `output_mode_store`.

#### BLTOUCH_STORE

`BLTOUCH_STORE MODE=<output_mode>` : Stocke un mode de sortie dans l'EEPROM d'un BLTouch V3.1 Les modes de sortie disponibles sont : `5V`, `OD`

### [configfile]

Le module configfile est automatiquement chargé.

#### SAVE_CONFIG

`SAVE_CONFIG`: Cette commande écrase le fichier de configuration principal de l'imprimante et redémarre le logiciel hôte. Cette commande est utilisée conjointement avec d'autres commandes d'étalonnage pour enregistrer les résultats de ces tests.

### [delayed_gcode]

La commande suivante est activée si une section de configuration [delayed_gcode](Config_Reference.md#delayed_gcode) a été activée (voir également le [guide des modèles](Command_Templates.md#delayed-gcodes)).

#### UPDATE_DELAYED_GCODE

`UPDATE_DELAYED_GCODE [ID=<nom>] [DURATION=<secondes>]` : Met à jour la durée du retard du [delayed_gcode] identifié et démarre le minuteur pour l'exécution du gcode. Une valeur de 0 annulera l'exécution d'un gcode retardé en attente.

### [delta_calibrate]

Les commandes suivantes sont disponibles lorsque la section [delta_calibrate config](Config_Reference.md#linear-delta-kinematics) est activée (voir également le [guide delta calibrate](Delta_Calibrate.md)).

#### DELTA_CALIBRATE

`DELTA_CALIBRATE [METHOD=manual] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Cette commande sondera sept points sur le lit et recommandera des positions de butées de fin de course, des angles des tours et un rayon. Voir la commande PROBE pour plus de détails sur les paramètres de sonde facultatifs. Si METHOD=manual est spécifié, l'outil de sondage manuel est activé - voir la commande MANUAL_PROBE ci-dessus pour plus de détails sur les commandes supplémentaires disponibles lorsque cet outil est actif. La valeur facultative `HORIZONTAL_MOVE_Z` remplace l'option `horizontal_move_z` spécifiée dans le fichier de configuration.

#### DELTA_ANALYZE

`DELTA_ANALYZE`: Cette commande est utilisée pendant l'étalonnage delta amélioré. Voir [Calibrage delta](Delta_Calibrate.md) pour plus de détails.

### [display]

La commande suivante est disponible lorsqu'une section [display config](Config_Reference.md#gcode_macro) est activée.

#### SET_DISPLAY_GROUP

`SET_DISPLAY_GROUP [DISPLAY=<display>] GROUP=<group> ` : Définit le groupe d'affichage actif d'un écran LCD. Cela permet de définir plusieurs groupes de données d'affichage dans la configuration, par exemple `[display_data <group> <elementname>]` et de passer de l'un à l'autre en utilisant cette commande gcode étendue. Si DISPLAY n'est pas spécifié, la valeur par défaut est "display" (l'affichage principal).

### [display_status]

Le module display_status est automatiquement chargé si une section [display config](Config_Reference.md#display) est activée. Il fournit les commandes G-Code standard suivantes :

- Afficher un message : `M117 <message> `
- Définir le pourcentage de génération : `M73 P<pourcentage>`

La commande G-Code étendue suivante est également fournie :

- `SET_DISPLAY_TEXT MSG=<message>` : Effectue l'équivalent de M117, en définissant le `MSG` fourni comme le message d'affichage actuel. Si `MSG` est omis, l'affichage est effacé.

### [dual_carriage]

La commande suivante est disponible lorsque la section [config dual_carriage](Config_Reference.md#dual_carriage) est activée.

#### SET_DUAL_CARRIAGE

`SET_DUAL_CARRIAGE CARRIAGE=[0|1] [MODE=[PRIMARY|COPY|MIRROR]]`: This command will change the mode of the specified carriage. If no `MODE` is provided it defaults to `PRIMARY`. Setting the mode to `PRIMARY` deactivates the other carriage and makes the specified carriage execute subsequent G-Code commands as-is. `COPY` and `MIRROR` modes are supported only for `CARRIAGE=1`. When set to either of these modes, carriage 1 will then track the subsequent moves of the carriage 0 and either copy relative movements of it (in `COPY` mode) or execute them in the opposite (mirror) direction (in `MIRROR` mode).

#### SAVE_DUAL_CARRIAGE_STATE

`SAVE_DUAL_CARRIAGE_STATE [NAME=<state_name>]`: Save the current positions of the dual carriages and their modes. Saving and restoring DUAL_CARRIAGE state can be useful in scripts and macros, as well as in homing routine overrides. If NAME is provided it allows one to name the saved state to the given string. If NAME is not provided it defaults to "default".

#### RESTORE_DUAL_CARRIAGE_STATE

`RESTORE_DUAL_CARRIAGE_STATE [NAME=<state_name>] [MOVE=[0|1] [MOVE_SPEED=<speed>]]`: Restore the previously saved positions of the dual carriages and their modes, unless "MOVE=0" is specified, in which case only the saved modes will be restored, but not the positions of the carriages. If positions are being restored and "MOVE_SPEED" is specified, then the toolhead moves will be performed with the given speed (in mm/s); otherwise the toolhead move will use the rail homing speed. Note that the carriages restore their positions only over their own axis, which may be necessary to correctly restore COPY and MIRROR mode of the dual carraige.

### [endstop_phase]

Les commandes suivantes sont disponibles lorsqu'une section de configuration [endstop_phase](Config_Reference.md#endstop_phase) est activée (voir également le [guide de la phase d'arrêt](Endstop_Phase.md)).

#### ENDSTOP_PHASE_CALIBRATE

`ENDSTOP_PHASE_CALIBRATE [STEPPER=<config_name>]` : Si aucun paramètre STEPPER n'est fourni, cette commande rapporte des statistiques sur les phases d'arrêt du stepper pendant les précédentes opérations de recherche d'origine. Lorsqu'un paramètre STEPPER est fourni, elle fait en sorte que le paramètre de phase de fin de course donné soit écrit dans le fichier de configuration (en lien avec la commande SAVE_CONFIG).

### [exclude_object]

Les commandes suivantes sont disponibles lorsqu'une section de configuration [exclude_object](Config_Reference.md#exclude_object) est activée (voir également le [guide d'exclusion d'objet](Exclude_Object.md)) :

#### `EXCLUDE_OBJECT`

`EXCLUDE_OBJECT [NAME=nom_objet] [CURRENT=1] [RESET=1]` : Sans paramètres, cette commande renvoie une liste de tous les objets actuellement exclus.

Lorsque le paramètre `NAME` est donné, l'objet nommé sera exclu de l'impression.

Lorsque le paramètre `CURRENT` est donné, l'objet courant sera exclu de l'impression.

Lorsque le paramètre `RESET` est donné, la liste des objets exclus sera effacée. De plus, inclure le paramètre `NAME` ne réinitialisera que l'objet nommé. Cela **peut** provoquer des échecs d'impression, si des couches ont déjà été omises.

#### `EXCLUDE_OBJECT_DEFINE`

`EXCLUDE_OBJECT_DEFINE [NAME=nom_objet [CENTER=X,Y] [POLYGON=[[x,y],...]]] [RESET=1] [JSON=1]` : Fournit le résumé d'un objet dans le fichier.

Sans paramètres fournis, ceci va lister les objets définis connus de Klipper. Retourne une liste de chaînes de caractères, à moins que le paramètre `JSON` soit donné, auquel cas retournera les détails de l'objet au format json.

Lorsque le paramètre `NAME` est inclus, cela définit un objet à exclure.

- `NAME` : Ce paramètre est obligatoire. Il s'agit de l'identifiant utilisé par les autres commandes de ce module.
- `CENTER` : Une coordonnée X,Y pour l'objet.
- `POLYGON` : Un tableau de coordonnées X,Y fournissant le contour d'un objet.

Lorsque le paramètre `RESET` est fourni, tous les objets définis seront effacés, et le module `[exclude_object]` sera réinitialisé.

#### `EXCLUDE_OBJECT_START`

`EXCLUDE_OBJECT_START NAME=nom_objet` : Cette commande prend un paramètre `NAME` et indique le début du gcode pour un objet sur la couche courante.

#### `EXCLUDE_OBJECT_END`

`EXCLUDE_OBJECT_END [NAME=nom_objet]` : Indique la fin du gcode de l'objet pour la couche. Il est associé à `EXCLUDE_OBJECT_START`. Le paramètre `NAME` est optionnel, et n'avertira que si le nom fourni ne correspond au nom actuel.

### [extruder]

Les commandes suivantes sont disponibles si une section [configuration de l'extrudeuse](Config_Reference.md#extrudeuse) est activée :

#### ACTIVATE_EXTRUDER

`ACTIVATE_EXTRUDER EXTRUDER=<nom_de_la_configuration>` : Dans une imprimante comportant plusieurs sections de configuration d'[extrudeuse](Config_Reference.md#extrudeur), cette commande sélectionne la tête d'outil active.

#### SET_PRESSURE_ADVANCE

`SET_PRESSURE_ADVANCE [EXTRUDER=<nom_de_la_configuration>] [ADVANCE=<avance_de_pression>] [SMOOTH_TIME=<durée_adoucissemt_avance_de_pression>]` : Définit les paramètres d'avance de pression du moteur d'extrudeuse (comme défini dans une section de configuration [extrudeur](Config_Reference.md#extruder) ou [extruder_stepper](Config_Reference.md#extruder_stepper)). Si EXTRUDER n'est pas spécifié, il s'agit par défaut du stepper défini dans la tête d'outil active.

#### SET_EXTRUDER_ROTATION_DISTANCE

`SET_EXTRUDER_ROTATION_DISTANCE EXTRUDER=<nom_config> [DISTANCE=<distance>]` : Définit une nouvelle valeur pour la "distance de rotation" du moteur de l'extrudeuse fournie (telle que définie dans une section de configuration [extruder](Config_Reference.md#extruder) ou [extruder_stepper](Config_Reference.md#extruder_stepper)). Si la distance de rotation est un nombre négatif, le mouvement du moteur sera inversé (par rapport à la direction du moteur spécifiée dans le fichier de configuration). Les paramètres modifiés ne sont pas conservés lors de la réinitialisation de Klipper. Utilisez avec précaution car de petites modifications peuvent entraîner une pression excessive entre l'extrudeuse et la tête de l'outil. Effectuez un calibrage correct avec le filament avant de l'utiliser. Si la valeur 'DISTANCE' n'est pas fournie, cette commande renvoie la distance de rotation actuelle.

#### SYNC_EXTRUDER_MOTION

`SYNC_EXTRUDER_MOTION EXTRUDER=<nom> MOTION_QUEUE=<nom>` : Cette commande permet de synchroniser le moteur d'entraînement spécifié par EXTRUDER (tel que défini dans la section de configuration [extruder](Config_Reference.md#extruder) ou [extruder_stepper](Config_Reference.md#extruder_stepper) avec le mouvement d'un extrudeur spécifié par MOTION_QUEUE (tel que défini dans la section de configuration [extruder](Config_Reference.md#extruder)). Si MOTION_QUEUE est une chaîne vide, le stepper sera désynchronisé de tout mouvement d'extrudeuse.

### [fan_generic]

La commande suivante est disponible lorsqu'une section [fan_generic config](Config_Reference.md#fan_generic) est activée.

#### SET_FAN_SPEED

`SET_FAN_SPEED FAN=nom_config SPEED=<vitesse>` Cette commande définit la vitesse d'un ventilateur. La valeur de "vitesse" doit être comprise entre 0,0 et 1,0.

`SET_FAN_SPEED PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given fan. For example, if one defined a `[display_template my_fan_template]` config section then one could assign `TEMPLATE=my_fan_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the fan will be automatically set to the resulting speed. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_FAN_SPEED` commands to manage the values directly).

### [filament_switch_sensor]

La commande suivante est disponible lorsqu'une section de configuration [filament_switch_sensor](Config_Reference.md#filament_switch_sensor) ou [filament_motion_sensor](Config_Reference.md#filament_motion_sensor) est activée.

#### QUERY_FILAMENT_SENSOR

`QUERY_FILAMENT_SENSOR SENSOR=<nom_du_capteur>` : Interroge l'état actuel du capteur de filament. Les données affichées sur le terminal dépendront du type de capteur défini dans la configuration.

#### SET_FILAMENT_SENSOR

`SET_FILAMENT_SENSOR SENSOR=<nom_du_capteur> ENABLE=[0|1] ` : Active/désactive le détecteur de filament. Si ENABLE est réglé sur 0, le détecteur de filament est désactivé, s'il est réglé sur 1, il est activé.

### [firmware_retraction]

Les commandes G-Code standard suivantes sont disponibles lorsque la section de configuration [firmware_retraction](Config_Reference.md#firmware_retraction) est activée. Ces commandes vous permettent d'utiliser la fonction de rétraction du micrologiciel disponible dans de nombreux trancheurs, afin de réduire le cordage pendant les déplacements sans extrusion d'une partie de l'impression à une autre. Une configuration appropriée de l'avance à la pression réduit la longueur de rétraction requise.

- `G10` : Rétracte l'extrudeur en utilisant les paramètres actuellement configurés.
- `G11` : Détache l'extrudeur en utilisant les paramètres actuellement configurés.

Les commandes supplémentaires suivantes sont également disponibles.

#### SET_RETRACTION

`SET_RETRACTION [RETRACT_LENGTH=<mm>] [RETRACT_SPEED=<mm/s>] [UNRETRACT_EXTRA_LENGTH=<mm>] [UNRETRACT_SPEED=<mm/s>] ` : Ajuste les paramètres utilisés par la rétraction du micrologiciel. RETRACT_LENGTH détermine la longueur de filament à rétracter et à dérétracter. La vitesse de rétraction est ajustée via RETRACT_SPEED, et est généralement réglée relativement haut. La vitesse de déstratification est ajustée via UNRETRACT_SPEED, et n'est pas particulièrement critique, bien que souvent inférieure à RETRACT_SPEED. Dans certains cas, il est utile d'ajouter une petite quantité de longueur supplémentaire lors de la dérétraction, et ceci est réglé via UNRETRACT_EXTRA_LENGTH. SET_RETRACTION est généralement défini dans le cadre de la configuration du slicer par filament, car les différents filaments nécessitent des paramètres différents.

#### GET_RETRACTION

`GET_RETRACTION`: Interroge les paramètres actuellement utilisés pour la rétraction du firmware et les affiche sur le terminal.

### [force_move]

Le module force_move est automatiquement chargé, mais certaines commandes nécessitent de définir `enable_force_move` dans la [configuration de l'imprimante](Config_Reference.md#force_move).

#### STEPPER_BUZZ

`STEPPER_BUZZ STEPPER=<nom_de_la_configuration>` : Déplace le moteur donné en avant d'un mm puis en arrière d'un mm, répété 10 fois. Il s'agit d'un outil de diagnostic permettant de vérifier la connectivité du moteur.

#### FORCE_MOVE

`FORCE_MOVE STEPPER=<nom_de_la_configuration> DISTANCE=<valeur> VELOCITE=<valeur> [ACCEL=<valeur>] ` : Cette commande forcera le déplacement du stepper donné sur la distance donnée (en mm) à la vitesse constante donnée (en mm/s). Si ACCEL est spécifié et est supérieur à zéro, alors l'accélération donnée (en mm/s^2) sera utilisée ; sinon, aucune accélération n'est effectuée. Aucune vérification des limites n'est effectuée ; aucune mise à jour cinématique n'est faite ; les autres steppers parallèles sur un axe ne seront pas déplacés. Soyez prudent car une commande incorrecte pourrait endommager le matériel ! L'utilisation de cette commande placera presque certainement la cinématique de bas niveau dans un état incorrect ; émettez ensuite un G28 pour réinitialiser la cinématique. Cette commande est destinée aux diagnostics de bas niveau et au débogage.

#### SET_KINEMATIC_POSITION

`SET_KINEMATIC_POSITION [X=<value>] [Y=<value>] [Z=<value>] [CLEAR=<[X][Y][Z]>]`: Force the low-level kinematic code to believe the toolhead is at the given cartesian position. This is a diagnostic and debugging command; use SET_GCODE_OFFSET and/or G92 for regular axis transformations. If an axis is not specified then it will default to the position that the head was last commanded to. Setting an incorrect or invalid position may lead to internal software errors. Use the CLEAR parameter to forget the homing state for the given axes. Note that CLEAR will not override the previous functionality; if an axis is not specified to CLEAR it will have its kinematic position set as per above. This command may invalidate future boundary checks; issue a G28 afterwards to reset the kinematics.

### [gcode]

Le module gcode est automatiquement chargé.

#### RESTART

`RESTART` : Cette commande permet au logiciel hôte de recharger sa configuration et d'effectuer une réinitialisation interne. Cette commande n'efface pas l'état d'erreur du micro-contrôleur (voir FIRMWARE_RESTART) et ne charge pas de nouveau logiciel (voir [la FAQ](FAQ.md#how-do-i-upgrade-to-the-latest-software)).

#### FIRMWARE_RESTART

`FIRMWARE_RESTART` : Cette commande est similaire à un RESTART, mais elle efface également tout état d'erreur du micro-contrôleur.

#### STATUS

`STATUS` : Indique l'état du logiciel de l'hôte Klipper.

#### HELP

`HELP` : Affiche la liste des commandes G-Code étendues disponibles.

### [gcode_arcs]

Les commandes G-Code standard suivantes sont disponibles si une section [gcode_arcs config](Config_Reference.md#gcode_arcs) est activée :

- Déplacement d'un arc dans le sens des aiguilles d'une montre (G2), déplacement d'un arc dans le sens inverse des aiguilles d'une montre (G3) : `G2|G3 [X<pos>] [Y<pos>] [Z<pos>] [E<pos>] [F<speed>] I<value> J<value>|I<value> K<value>|J<value> K<value>`
- Sélection du plan de l'arc : G17 (plan XY), G18 (plan XZ), G19 (plan YZ)

### [gcode_macro]

La commande suivante est disponible lorsqu'une section de configuration [gcode_macro](Config_Reference.md#gcode_macro) est activée (voir également le [guide des modèles de commande](Command_Templates.md)).

#### SET_GCODE_VARIABLE

`SET_GCODE_VARIABLE MACRO=<macro_name> VARIABLE=<name> VALUE=<value> ` : Cette commande permet de changer la valeur d'une variable gcode_macro au moment de l'exécution. La valeur fournie est analysée comme un littéral Python.

### [gcode_move]

Le module gcode_move est automatiquement chargé.

#### GET_POSITION

`GET_POSITION` : Retourne les informations de l'emplacement actuel de la tête d'outil. Voir la documentation du développeur de [restitution de GET_POSITION](Code_Overview.md#coordinate-systems) pour plus d'informations.

#### SET_GCODE_OFFSET

`SET_GCODE_OFFSET [X=<pos>|X_ADJUST=<adjust>] [Y=<pos>|Y_ADJUST=<adjust>] [Z=<pos>|Z_ADJUST=<adjust>] [MOVE=1 [MOVE_SPEED=<speed>]] ` : Définit un décalage positionnel à appliquer aux futures commandes G-Code. Ceci est généralement utilisé pour changer virtuellement le décalage Z du bed ou pour définir les décalages XY des buses lors du changement d'extrudeur. Par exemple, si "SET_GCODE_OFFSET Z=0.2" est donné, les prochains mouvements G-Code auront 0,2mm ajouté à leur hauteur Z. Si les paramètres de style X_ADJUST sont utilisés, l'ajustement sera ajouté à tout décalage existant (par exemple, "SET_GCODE_OFFSET Z=-0.2" suivi de "SET_GCODE_OFFSET Z_ADJUST=0.3" donnerait un décalage Z total de 0.1). Si "MOVE=1" est spécifié, un déplacement de la tête d'outil sera effectué pour appliquer le décalage donné (sinon le décalage prendra effet lors du prochain déplacement absolu en G-code qui spécifie l'axe donné). Si "MOVE_SPEED" est spécifié, le déplacement de la tête d'outil sera effectué avec la vitesse donnée (en mm/s) ; sinon, le déplacement de la tête d'outil utilisera la dernière vitesse G-Code spécifiée.

#### SAVE_GCODE_STATE

`SAVE_GCODE_STATE [NAME=<nom_de_l'état>]` : Sauvegarde l'état actuel de l'analyse des coordonnées du g-code. La sauvegarde et le rétablissement de l'état du g-code sont utiles dans les scripts et les macros. Cette commande enregistre le mode actuel de coordonnées absolues en g-code (G90/G91), le mode d'extrusion absolue (M82/M83), l'origine (G92), le décalage (SET_GCODE_OFFSET), la priorité de vitesse (M220), la priorité d'extrusion (M221), la vitesse de déplacement, la position XYZ actuelle et la position relative de l'extrudeuse "E". Si NOM est fourni, cela permet de nommer l'état sauvegardé avec la chaîne de caractères donnée. Si le NOM n'est pas fourni, la valeur par défaut est "default".

#### RESTORE_GCODE_STATE

`RESTORE_GCODE_STATE [NAME=<nom_de_l'état>] [MOVE=1 [MOVE_SPEED=<speed>]]` : Restaure un état précédemment sauvegardé via SAVE_GCODE_STATE. Si "MOVE=1" est spécifié, un déplacement de la tête d'outil sera effectué pour revenir à la position XYZ précédente. Si "MOVE_SPEED" est spécifié, alors le déplacement de la tête d'outil sera effectué avec la vitesse donnée (en mm/s) ; sinon, le déplacement de la tête d'outil utilisera la vitesse du G-Code restauré.

### [hall_filament_width_sensor]

Les commandes suivantes sont disponibles lorsque la section de configuration [tsl1401cl filament width sensor](Config_Reference.md#tsl1401cl_filament_width_sensor) ou [hall filament width sensor](Config_Reference. md#hall_filament_width_sensor) est activée (voir également [TSLl401CL Filament Width Sensor](TSL1401CL_Filament_Width_Sensor.md) et [Hall Filament Width Sensor](Hall_Filament_Width_Sensor.md)) :

#### QUERY_FILAMENT_WIDTH

`QUERY_FILAMENT_WIDTH` : Renvoie la largeur actuelle du filament mesuré.

#### RESET_FILAMENT_WIDTH_SENSOR

`RESET_FILAMENT_WIDTH_SENSOR` : Efface toutes les lectures du capteur. Utile après un changement de filament.

#### DISABLE_FILAMENT_WIDTH_SENSOR

`DISABLE_FILAMENT_WIDTH_SENSOR` : Désactiver le capteur de largeur de filament et arrêter de l'utiliser pour le contrôle du flux.

#### ENABLE_FILAMENT_WIDTH_SENSOR

`ENABLE_FILAMENT_WIDTH_SENSOR` : Activez le capteur de largeur de filament et commencez à l'utiliser pour le contrôle du flux.

#### QUERY_RAW_FILAMENT_WIDTH

`QUERY_RAW_FILAMENT_WIDTH` : Renvoie les lectures actuelles des canaux ADC et la valeur RAW du capteur des points de calibration.

#### ENABLE_FILAMENT_WIDTH_LOG

`ENABLE_FILAMENT_WIDTH_LOG` : Activer la journalisation du diamètre.

#### DISABLE_FILAMENT_WIDTH_LOG

`DISABLE_FILAMENT_WIDTH_LOG` : Désactiver la journalisation du diamètre.

### [heaters]

Le module chauffages est automatiquement chargé si un chauffage est défini dans le fichier de configuration.

#### TURN_OFF_HEATERS

`TURN_OFF_HEATERS` : Éteindre tous les chauffages.

#### TEMPERATURE_WAIT

`TEMPERATURE_WAIT SENSOR=<nom_config> [MINIMUM=<cible>] [MAXIMUM=<cible>]` : Attend jusqu'à ce que le capteur de température donné soit à ou au-dessus du MINIMUM fourni et/ou à ou en dessous du MAXIMUM fourni.

#### SET_HEATER_TEMPERATURE

`SET_HEATER_TEMPERATURE HEATER=<nom_du_chauffeur> [TARGET=<température_cible>] ` : Définit la température cible d'un élément chauffant. Si une température cible n'est pas fournie, la cible est 0.

### [idle_timeout]

Le module idle_timeout est automatiquement chargé.

#### SET_IDLE_TIMEOUT

`SET_IDLE_TIMEOUT [TIMEOUT=<timeout>]` : Permet à l'utilisateur de définir le délai d'inactivité (en secondes).

### [input_shaper]

La commande suivante est activée si une section de configuration [input_shaper](Config_Reference.md#input_shaper) a été activée (voir également le [guide de compensation de résonance](Resonance_Compensation.md)).

#### SET_INPUT_SHAPER

`SET_INPUT_SHAPER [SHAPER_FREQ_X=<shaper_freq_x>] [SHAPER_FREQ_Y=<shaper_freq_y>] [DAMPING_RATIO_X=<damping_ratio_x>] [DAMPING_RATIO_Y=<damping_ratio_y>] [SHAPER_TYPE=<shaper>] [SHAPER_TYPE_X=<shaper_type_x>] [SHAPER_TYPE_Y=<shaper_type_y>] ` : Modifie les paramètres de mise en forme d'entrée. Notez que le paramètre SHAPER_TYPE réinitialise le shaper d'entrée pour les axes X et Y même si différents types de shaper ont été configurés dans la section [input_shaper]. SHAPER_TYPE ne peut pas être utilisé avec l'un des paramètres SHAPER_TYPE_X et SHAPER_TYPE_Y. Voir [config reference](Config_Reference.md#input_shaper) pour plus de détails sur chacun de ces paramètres.

### [manual_probe]

Le module manual_probe est automatiquement chargé.

#### MANUAL_PROBE

`MANUAL_PROBE [SPEED=<speed>]`: Exécute un script d'aide servant à mesurer la hauteur de la buse à un point donné. Si SPEED est spécifié, il définit la vitesse des commandes TESTZ (la valeur par défaut est 5mm/s). Pendant un sondage manuel, les commandes supplémentaires suivantes sont disponibles :

- `ACCEPT`: Cette commande valide la position Z actuelle et met fin au sondage manuel.
- `ABORT`: Cette commande interrompt le sondage manuel.
- `TESTZ Z=<valeur>` : Cette commande déplace la buse vers le haut ou vers le bas de la quantité spécifiée dans "valeur". Par exemple, `TESTZ Z=-.1` déplacera la buse vers le bas de 0,1mm tandis que `TESTZ Z=.1` déplacera la buse vers le haut de 0,1mm. La valeur peut également être `+`, `-`, `++`, ou `--` pour déplacer la buse vers le haut ou vers le bas d'une quantité relative aux tentatives précédentes.

#### Z_ENDSTOP_CALIBRATE

`Z_ENDSTOP_CALIBRATE [SPEED=<vitesse>]` : Exécute un script d'assistance utile pour calibrer un paramètre de configuration de la position Z_endstop. Voir la commande MANUAL_PROBE pour plus de détails sur les paramètres et les commandes supplémentaires disponibles lorsque l'outil est actif.

#### Z_OFFSET_APPLY_ENDSTOP

`Z_OFFSET_APPLY_ENDSTOP` : Prend le décalage actuel du Gcode Z (alias, babystepping), et le soustrait de la position endstop_position définie dans stepper_z. Ceci permet de prendre une valeur de babystepping fréquemment utilisée, et de la rendre permanente. Nécessite un `SAVE_CONFIG` pour prendre effet.

### [manual_stepper]

La commande suivante est disponible lorsqu'une section [manual_stepper config](Config_Reference.md#manual_stepper) est activée.

#### MANUAL_STEPPER

`MANUAL_STEPPER STEPPER=nom_du_config [ENABLE=[0|1]]] [SET_POSITION=<pos>] [SPEED=<speed>] [ACCEL=<accel>] [MOVE=<pos> [STOP_ON_ENDSTOP=[1|2|-1|-2]] [SYNC=0]] ` : Cette commande modifie l'état du stepper. Utilisez le paramètre ENABLE pour activer/désactiver le stepper. Utilisez le paramètre SET_POSITION pour forcer le moteur pas à pas à penser qu'il se trouve à la position donnée. Utilisez le paramètre MOVE pour déplacer vers la position donnée. Si SPEED et/ou ACCEL sont spécifiés, les valeurs données seront utilisées à la place de celles par défaut issues du fichier de configuration. Si un ACCEL de zéro est spécifié, aucune accélération ne sera effectuée. Si STOP_ON_ENDSTOP=1 est spécifié, le déplacement se terminera prématurément si la fin de course est déclenchée (utilisez STOP_ON_ENDSTOP=2 pour terminer le déplacement sans erreur même si la fin de course n'est pas déclenchée, utilisez -1 ou -2 pour s'arrêter lorsque la fin de course n'est pas déclenchée). Normalement, les futures commandes G-Code seront programmées pour être exécutées après la fin du déplacement de la commande de pas, mais si un déplacement manuel de la commande de pas utilise SYNC=0, les futures commandes de déplacement G-Code peuvent être exécutées en parallèle avec le déplacement de la commande de pas.

### [mcp4018]

La commande suivante est disponible lorsqu'une section [mcp4018 config](Config_Reference.md#mcp4018) est activée.

#### SET_DIGIPOT

`SET_DIGIPOT DIGIPOT=config_name WIPER=<valeur>` : Cette commande change la valeur actuelle du digipot. Cette valeur devrait typiquement être comprise entre 0.0 et 1.0, à moins qu'une 'échelle' soit définie dans la configuration. Lorsque 'scale' est défini, alors cette valeur doit être comprise entre 0.0 et 'scale'.

### [led]

La commande suivante est disponible lorsque l'une des sections [led config](Config_Reference.md#leds) est activée.

#### SET_LED

`SET_LED LED=<nom_de_la_configuration> RED=<valeur> GREEN=<valeur> BLUE=<valeur> WHITE=<valeur> [INDEX=<index>] [TRANSMIT=0] [SYNC=1]` : Ceci définit la sortie de la LED. Chaque `<valeur>` de couleur doit être comprise entre 0.0 et 1.0. L'option WHITE n'est valable que pour les LEDs RGBW. Si la LED supporte plusieurs puces dans une chaîne, on peut spécifier INDEX pour modifier la couleur de la seule puce donnée (1 pour la première puce, 2 pour la seconde, etc.). Si INDEX n'est pas spécifié, alors toutes les LEDs de la chaîne seront réglées sur la couleur fournie. Si TRANSMIT=0 est spécifié, le changement de couleur ne sera effectué que lors de la prochaine commande SET_LED qui ne spécifie pas TRANSMIT=0 ; cela peut être utile en combinaison avec le paramètre INDEX pour effectuer plusieurs mises à jour dans une chaîne. Par défaut, la commande SET_LED synchronisera ses changements avec les autres commandes gcode en cours. Cela peut conduire à un comportement indésirable si les LEDs sont réglées alors que l'imprimante n'imprime pas, car cela réinitialisera le délai d'inactivité. Si un timing précis n'est pas nécessaire, le paramètre optionnel SYNC=0 peut être spécifié pour appliquer les changements sans réinitialiser le délai d'inactivité.

#### SET_LED_TEMPLATE

`SET_LED_TEMPLATE LED=<nom_de_la_led> TEMPLATE=<nom_du_modèle> [<param_x>=<literal>] [INDEX=<index>]` : Attribue un [modèle d'affichage](Config_Reference.md#display_template) à une [LED](Config_Reference.md#leds) donnée. Par exemple, si l'on définit une section de configuration `[display_template my_led_template]`, on peut affecter `TEMPLATE=my_led_template` ici. Le modèle d'affichage doit produire une chaîne de caractères séparée par des virgules contenant quatre nombres à virgule flottante correspondant aux paramètres de couleur rouge, vert, bleu et blanc. Le modèle sera continuellement évalué et la LED sera automatiquement réglée sur les couleurs résultantes. On peut définir des paramètres display_template à utiliser pendant l'évaluation du modèle (les paramètres seront analysés comme des littéraux Python). Si INDEX n'est pas spécifié, alors toutes les puces dans la chaîne de la LED seront réglées sur le modèle, sinon seule la puce avec l'index donné sera mise à jour. Si TEMPLATE est une chaîne vide, cette commande effacera tout modèle précédent assigné à la LED (on peut alors utiliser les commandes `SET_LED` pour gérer les paramètres de couleur de la LED).

### [output_pin]

La commande suivante est disponible lorsqu'une section [output_pin config](Config_Reference.md#output_pin) est activée.

#### SET_PIN

`SET_PIN PIN=config_name VALUE=<value>`: Set the pin to the given output `VALUE`. VALUE should be 0 or 1 for "digital" output pins. For PWM pins, set to a value between 0.0 and 1.0, or between 0.0 and `scale` if a scale is configured in the output_pin config section.

`SET_PIN PIN=config_name TEMPLATE=<template_name> [<param_x>=<literal>]`: If `TEMPLATE` is specified then it assigns a [display_template](Config_Reference.md#display_template) to the given pin. For example, if one defined a `[display_template my_pin_template]` config section then one could assign `TEMPLATE=my_pin_template` here. The display_template should produce a string containing a floating point number with the desired value. The template will be continuously evaluated and the pin will be automatically set to the resulting value. One may set display_template parameters to use during template evaluation (parameters will be parsed as Python literals). If TEMPLATE is an empty string then this command will clear any previous template assigned to the pin (one can then use `SET_PIN` commands to manage the values directly).

### [palette2]

Les commandes suivantes sont disponibles lorsque la section [palette2 config](Config_Reference.md#palette2) est activée.

Les impressions avec Palette fonctionnent en intégrant des OCodes (Omega Codes) spéciaux dans le fichier GCode :

- `O1`...`O32`: Ces codes sont lus à partir du flux GCode, traités par ce module et transmis au dispositif Palette 2.

Les commandes supplémentaires suivantes sont également disponibles.

#### PALETTE_CONNECT

`PALETTE_CONNECT`: Cette commande initie la connexion avec Palette 2.

#### PALETTE_DISCONNECT

`PALETTE_DISCONNECT`: Cette commande permet de se déconnecter de Palette 2.

#### PALETTE_CLEAR

`PALETTE_CLEAR`: Cette commande demande à Palette 2 de purger le filament de tous les chemins d'entrée et de sortie.

#### PALETTE_CUT

`PALETTE_CUT` : Cette commande demande à Palette 2 de couper le filament actuellement chargé dans le noyau de jonction.

#### PALETTE_SMART_LOAD

` PALETTE_SMART_LOAD` : cette commande initialise la séquence de chargement intelligente sur Palette 2. Le filament est chargé automatiquement en l’extrudant sur la distance calibrée sur l’appareil pour l’imprimante, et l'indique à Palette 2 une fois le chargement terminé. Cette commande revient à appuyer sur **Smart Load** directement sur l’écran Palette 2 une fois l'insertion du filament faite.

### [pid_calibrate]

Le module pid_calibrate est automatiquement chargé si un chauffage est défini dans le fichier de configuration.

#### PID_CALIBRATE

` PID_CALIBRATE HEATER=<config_name> TARGET=<temperature> [WRITE_FILE=1]`: Effectuer un test d’étalonnage PID. Le chauffage demandé sera activé jusqu’à ce que la température définie soit atteinte, il s'éteindra et se rallumera durant plusieurs cycles. Si le paramètre WRITE_FILE est activé, le fichier /tmp/heattest.txt sera créé avec un journal de tous les échantillons de température mesurés pendant le test.

### [pause_resume]

Les commandes suivantes sont disponibles lorsque la section [pause_resume config](Config_Reference.md#pause_resume) est activée :

#### PAUSE

` PAUSE` : suspend l’impression en cours. La position actuelle est enregistrée pour reprendre lorsque demandé.

#### RESUME

`RESUME [VELOCITY=<value>]` : Reprend l'impression à la suite d'une pause, en rétablissant d'abord la position capturée précédemment. Le paramètre VELOCITY détermine la vitesse à laquelle l'outil doit revenir à la position capturée d'origine.

#### CLEAR_PAUSE

`CLEAR_PAUSE`: Supprime la mise en pause actuelle sans reprendre l'impression. Ceci est utile si l'on décide d'interrompre une impression après une PAUSE. Il est recommandé d'ajouter ceci à votre gcode de démarrage pour s'assurer que l'état de pause est réinitialisé pour chaque impression.

#### CANCEL_PRINT

`CANCEL_PRINT`: Annule l'impression en cours.

### [print_stats]

Le module print_stats est automatiquement chargé.

#### SET_PRINT_STATS_INFO

`SET_PRINT_STATS_INFO [TOTAL_LAYER=<nombre_total_de_couches>] [CURRENT_LAYER= <couche_actuelle>]` : Passe les informations du trancheur comme le nombre total de couches et celle actuellement en cours à Klipper. Ajoutez `SET_PRINT_STATS_INFO [TOTAL_LAYER=<nombre_total_de_couches>]` à votre section gcode de début du trancheur et `SET_PRINT_STATS_INFO [CURRENT_LAYER= <couche_actuelle>]` à la section gcode de changement de couche pour passer les informations de couche de votre trancheur à Klipper.

### [probe]

Les commandes suivantes sont disponibles lorsqu'une section [probe config](Config_Reference.md#probe) ou [bltouch config](Config_Reference.md#bltouch) est activée (voir également le [guide d'étalonnage de la sonde](Probe_Calibrate.md)).

#### PROBE

`PROBE [PROBE_SPEED=<mm/s>] [LIFT_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>] [SAMPLES_TOLERANCE=<mm>] [SAMPLES_TOLERANCE_RETRIES=<count>] [SAMPLES_RESULT=median|average]` : Déplace la buse vers le bas jusqu'à ce que le palpeur se déclenche. Si l'un des paramètres facultatifs est fourni, il remplace son paramètre équivalent dans la section [configuration de la sonde](Config_Reference.md#probe).

#### QUERY_PROBE

`QUERY_PROBE`: Retourne l'état actuel de la sonde ("triggered" ou "open").

#### PROBE_ACCURACY

` PROBE_ACCURACY [PROBE_SPEED=<mm/s>] [SAMPLES=<count>] [SAMPLE_RETRACT_DIST=<mm>]` : Calculer le maximum, le minimum, la moyenne, la médiane et l’écart type des échantillons des multiples palpeurs. Par défaut, 10 ÉCHANTILLONS sont prélevés. Sinon, les paramètres optionnels peuvent être définis dans la section de configuration du palpeur.

#### PROBE_CALIBRATE

` PROBE_CALIBRATE [SPEED=<speed>] [<probe_parameter>=<value>]` : Exécute l'assistant servant à calibrer le z_offset du palpeur. Consultez la commande PROBE pour plus d’informations sur les paramètres optionnels du palpeur. Reportez-vous à la commande MANUAL_PROBE pour plus d’informations sur le paramètre SPEED et les commandes supplémentaires disponibles lorsque l'assistant est actif. Veuillez noter que la commande PROBE_CALIBRATE utilise la variable de vitesse pour se déplacer dans la direction XY ainsi que dans Z.

#### Z_OFFSET_APPLY_PROBE

`Z_OFFSET_APPLY_PROBE` : Prend le décalage actuel du Gcode Z (alias, babystepping), et le soustrait du z_offset de la sonde. Cela permet de prendre une valeur de babystepping fréquemment utilisée, et de la rendre permanente. Nécessite un `SAVE_CONFIG` pour prendre effet.

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

Le module query_adc est automatiquement chargé.

#### QUERY_ADC

`QUERY_ADC [NAME=<nom_de_la_configuration>] [PULLUP=<valeur>] ` : Rapporte la dernière valeur analogique reçue pour une broche analogique donnée. Si NAME n'est pas fourni, la liste des noms d'adc disponibles est retournée. Si PULLUP est fourni (comme une valeur en Ohms), la valeur analogique brute ainsi que la résistance équivalente relative à ce pullup est retournée.

### [query_endstops]

Le module query_endstops est automatiquement chargé. Les commandes G-Code standard suivantes sont actuellement disponibles, mais leur utilisation n'est pas recommandée :

- Obtenir le statut Fin de course : `M119` (Utilisez QUERY_ENDSTOPS à la place.)

#### QUERY_ENDSTOPS

`QUERY_ENDSTOPS`: Teste les butées d'axe et indique si elles sont "déclenchées" ou dans un état "ouvert". Cette commande est généralement utilisée pour vérifier qu'un butoir de fin de course fonctionne correctement.

### [resonance_tester]

Les commandes suivantes sont disponibles lorsqu'une section [configuration du testeur de résonances](Config_Reference.md#resonance_tester) est activée (voir également le [guide de mesure des résonances](Measuring_Resonances.md)).

#### MEASURE_AXES_NOISE

`MEASURE_AXES_NOISE`: Mesure et affiche le bruit pour tous les axes de toutes les puces accélérométriques activées.

#### TEST_RESONANCES

`TEST_RESONANCES AXIS=<axis> [OUTPUT=<resonances,raw_data>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>] [HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [POINT=x,y,z] [INPUT_SHAPING=<0:1>]`: Runs the resonance test in all configured probe points for the requested "axis" and measures the acceleration using the accelerometer chips configured for the respective axis. "axis" can either be X or Y, or specify an arbitrary direction as `AXIS=dx,dy`, where dx and dy are floating point numbers defining a direction vector (e.g. `AXIS=X`, `AXIS=Y`, or `AXIS=1,-1` to define a diagonal direction). Note that `AXIS=dx,dy` and `AXIS=-dx,-dy` is equivalent. `chip_name` can be one or more configured accel chips, delimited with comma, for example `CHIPS="adxl345, adxl345 rpi"`. If POINT is specified it will override the point(s) configured in `[resonance_tester]`. If `INPUT_SHAPING=0` or not set(default), disables input shaping for the resonance testing, because it is not valid to run the resonance testing with the input shaper enabled. `OUTPUT` parameter is a comma-separated list of which outputs will be written. If `raw_data` is requested, then the raw accelerometer data is written into a file or a series of files `/tmp/raw_data_<axis>_[<chip_name>_][<point>_]<name>.csv` with (`<point>_` part of the name generated only if more than 1 probe point is configured or POINT is specified). If `resonances` is specified, the frequency response is calculated (across all probe points) and written into `/tmp/resonances_<axis>_<name>.csv` file. If unset, OUTPUT defaults to `resonances`, and NAME defaults to the current time in "YYYYMMDD_HHMMSS" format.

#### SHAPER_CALIBRATE

`SHAPER_CALIBRATE [AXIS=<axis>] [NAME=<name>] [FREQ_START=<min_freq>] [FREQ_END=<max_freq>] [ACCEL_PER_HZ=<accel_per_hz>][HZ_PER_SEC=<hz_per_sec>] [CHIPS=<chip_name>] [MAX_SMOOTHING=<max_smoothing>] [INPUT_SHAPING=<0:1>]`: Similarly to `TEST_RESONANCES`, runs the resonance test as configured, and tries to find the optimal parameters for the input shaper for the requested axis (or both X and Y axes if `AXIS` parameter is unset). If `MAX_SMOOTHING` is unset, its value is taken from `[resonance_tester]` section, with the default being unset. See the [Max smoothing](Measuring_Resonances.md#max-smoothing) of the measuring resonances guide for more information on the use of this feature. The results of the tuning are printed to the console, and the frequency responses and the different input shapers values are written to a CSV file(s) `/tmp/calibration_data_<axis>_<name>.csv`. Unless specified, NAME defaults to the current time in "YYYYMMDD_HHMMSS" format. Note that the suggested input shaper parameters can be persisted in the config by issuing `SAVE_CONFIG` command, and if `[input_shaper]` was already enabled previously, these parameters take effect immediately.

### [respond]

Les commandes G-Code standard suivantes sont disponibles lorsque la section [respond config](Config_Reference.md#respond) est activée :

- `M118 <message>` : affiche le message précédé du préfixe par défaut configuré (ou `echo : ` si aucun préfixe n'est configuré).

Les commandes supplémentaires suivantes sont également disponibles.

#### RESPOND

- `RESPOND MSG="<message>"` : Affiche le message précédé du préfixe par défaut configuré (ou `echo : ` si aucun préfixe n'est configuré).
- `RESPOND TYPE=echo MSG="<message>" ` : affiche le message précédé par `echo : `.
- `RESPOND TYPE=echo_no_space MSG="<message>"` : renvoie le message précédé de `echo:` sans espace entre le préfixe et le message, utile pour la compatibilité avec certains plugins octoprint qui attendent un formatage très spécifique.
- `RESPOND TYPE=command MSG="<message>"` : renvoie le message précédé de `// `. OctoPrint peut être configuré pour répondre à ces messages (par exemple, `RESPOND TYPE=command MSG=action:pause`).
- `RESPOND TYPE=error MSG="<message>" ` : affiche le message précédé par ` !!! `.
- `RESPOND PREFIX=<prefix> MSG="<message>"` : renvoie le message précédé de `<prefix>`. (Le paramètre `PREFIX` est prioritaire sur le paramètre `TYPE`).

### [save_variables]

La commande suivante est activée si une section [save_variables config](Config_Reference.md#save_variables) a été activée.

#### SAVE_VARIABLE

`SAVE_VARIABLE VARIABLE=<nom> VALUE=<valeur> ` : Enregistre la variable sur le disque afin qu'elle puisse être utilisée lors des redémarrages. Toutes les variables enregistrées sont chargées dans le dict `printer.save_variables.variables` au démarrage et peuvent être utilisées dans des macros gcode. La VALEUR fournie est analysée comme un littéral Python.

### [screws_tilt_adjust]

Les commandes suivantes sont disponibles lorsque la section de configuration [screws_tilt_adjust](Config_Reference.md#screws_tilt_adjust) est activée (voir également le [guide du nivelage manuel](Manual_Level.md#adjusting-bed-leveling-screws-using-the-bed-probe)).

#### SCREWS_TILT_CALCULATE

`SCREWS_TILT_CALCULATE [DIRECTION=CW|CCW] [MAX_DEVIATION=<value>] [HORIZONTAL_MOVE_Z=<value>] [<probe_parameter>=<value>]`: Cette commande appellera l'outil de réglage des vis de réglage du plateau. Elle déplacera la buse à différents endroits (tels que définis dans le fichier de configuration) en sondant la hauteur z et calculera le nombre de tours de vis nécessaires pour ajuster le niveau du lit. Si DIRECTION est spécifié, les rotations du bouton se feront toutes dans le même sens, dans le sens des aiguilles d'une montre (CW) ou dans le sens inverse des aiguilles d'une montre (CCW). Voir la commande PROBE pour plus de détails sur les paramètres de sonde facultatifs. IMPORTANT : Vous DEVEZ toujours faire un G28 avant d'utiliser cette commande. Si MAX_DEVIATION est spécifié, la commande génère une erreur gcode si une différence de hauteur de vis par rapport à la hauteur de vis de base est supérieure à la valeur fournie. La valeur facultative `HORIZONTAL_MOVE_Z` remplace l'option `horizontal_move_z` spécifiée dans le fichier de configuration.

### [sdcard_loop]

Lorsque la section de configuration [sdcard_loop](Config_Reference.md#sdcard_loop) est activée, les commandes étendues suivantes sont disponibles.

#### SDCARD_LOOP_BEGIN

`SDCARD_LOOP_BEGIN COUNT=<compte>` : Commence une section bouclée dans l'impression SD. Un compte de 0 indique que la section doit être bouclée indéfiniment.

#### SDCARD_LOOP_END

`SDCARD_LOOP_END`: Termine une section de boucle dans l'impression SD.

#### SDCARD_LOOP_DESIST

`SDCARD_LOOP_DESIST`: Termine les boucles existantes sans autres itérations.

### [servo]

Les commandes suivantes sont disponibles lorsqu'une section [servo config](Config_Reference.md#servo) est activée.

#### SET_SERVO

`SET_SERVO SERVO=nom_config [ANGLE=<degrés> | LARGEUR=<secondes>] ` : Définit la position du servo à l'angle (en degrés) ou à la largeur d'impulsion (en secondes) donnés. Utilisez `WIDTH=0` pour désactiver la sortie du servo.

### [skew_correction]

Les commandes suivantes sont disponibles lorsque la section de configuration [skew_correction](Config_Reference.md#skew_correction) est activée (voir également le guide [Skew Correction](Skew_Correction.md)).

#### SET_SKEW

`SET_SKEW [XY=<ac_length,bd_length,ad_length>] [XZ=<ac,bd,ad>] [YZ=<ac,bd,ad>] [CLEAR=<0|1>] ` : Configure le module [skew_correction] avec des mesures (en mm) prises à partir d'une impression d'étalonnage. On peut entrer des mesures pour n'importe quelle combinaison de plans, les plans non entrés conserveront leur valeur actuelle. Si `CLEAR=1` est entré, toute correction d'inclinaison sera désactivée.

#### GET_CURRENT_SKEW

`GET_CURRENT_SKEW`: Indique l'inclinaison actuelle de l'imprimante pour chaque plan en radians et en degrés. L'inclinaison est calculée en fonction des paramètres fournis par le gcode `SET_SKEW`.

#### CALC_MEASURED_SKEW

`CALC_MEASURED_SKEW [AC=<ac_length>] [BD=<bd_length>] [AD=<ad_length>]` : Calcule et rapporte l'inclinaison (en radians et en degrés) basée sur une impression mesurée. Cela peut être utile pour déterminer l'inclinaison actuelle de l'imprimante après l'application de la correction. Elle peut également être utile avant l'application de la correction pour déterminer si une correction de l'inclinaison est nécessaire. Reportez-vous à la section [Correction de l'obliquité] (Skew_Correction.md) pour plus de détails sur les objets et les mesures de calibrage de l'obliquité.

#### SKEW_PROFILE

`SKEW_PROFILE [LOAD=<nom>] [SAVE=<nom>] [REMOVE=<nom>]` : Gestion des profils pour la correction de l'obliquité. LOAD restaurera l'état d'inclinaison à partir du profil correspondant au nom fourni. SAVE sauvegardera l'état actuel d'inclinaison dans un profil correspondant au nom fourni. Remove supprimera le profil correspondant au nom fourni de la mémoire persistante. Notez qu'après l'exécution des opérations SAVE ou REMOVE, le gcode SAVE_CONFIG doit être exécuté pour que les modifications apportées à la mémoire permanente deviennent permanentes.

### [smart_effector]

Plusieurs commandes sont disponibles lorsqu'une section de configuration [smart_effector](Config_Reference.md#smart_effector) est activée. Assurez-vous de consulter la documentation officielle du Smart Effector sur le [Duet3D Wiki](https://duet3d.dozuki.com/Wiki/Smart_effector_and_carriage_adapters_for_delta_printer) avant de modifier les paramètres du Smart Effector. Consultez également le [guide d'étalonnage de la sonde](Probe_Calibrate.md).

#### SET_SMART_EFFECTOR

`SET_SMART_EFFECTOR [SENSITIVITY=<sensitivity>] [ACCEL=<accel>] [RECOVERY_TIME=<time>]` : Définit les paramètres du Smart Effector. Lorsque `SENSITIVITY` est spécifié, la valeur respective est écrite dans l'EEPROM du SmartEffecteur (nécessite que `control_pin` soit fourni). Les valeurs acceptables de `<sensitivity>` sont 0..255, la valeur par défaut est 50. Des valeurs plus faibles nécessitent moins de force de contact de la buse pour se déclencher (mais il y a un plus grand risque de faux déclenchement dû aux vibrations pendant le palpage), des valeurs plus élevées réduisent les faux déclenchements (mais nécessitent une plus grande force de contact pour se déclencher). Comme la sensibilité est écrite dans l'EEPROM, elle est conservée après l'arrêt, il n'est donc pas nécessaire de la configurer à chaque démarrage de l'imprimante. `ACCEL` et `RECOVERY_TIME` permettent de modifier les paramètres correspondants lors de l'exécution, voir la section [config](Config_Reference.md#smart_effector) de Smart Effector pour plus d'informations sur ces paramètres.

#### RESET_SMART_EFFECTOR

`RESET_SMART_EFFECTOR` : Réinitialise la sensibilité du Smart Effector à ses paramètres d'usine. Nécessite que `control_pin` soit fourni dans la section de configuration.

### [stepper_enable]

Le module stepper_enable est automatiquement chargé.

#### SET_STEPPER_ENABLE

`SET_STEPPER_ENABLE STEPPER=<nom_de_la_configuration> ENABLE=[0|1] ` : Active ou désactive uniquement le stepper donné. Il s'agit d'un outil de diagnostic et de débogage qui doit donc être utilisé avec précaution. La désactivation d'un moteur d'axe ne réinitialise pas les informations d'orientation. Le déplacement manuel d'un moteur pas à pas désactivé peut amener la machine à faire fonctionner le moteur en dehors des limites de sécurité. Cela peut entraîner des dommages aux composants de l'axe, aux extrémités chaudes et à la surface d'impression.

### [temperature_fan]

La commande suivante est disponible lorsqu'une section [temperature_fan config](Config_Reference.md#temperature_fan) est activée.

#### SET_TEMPERATURE_FAN_TARGET

`SET_TEMPERATURE_FAN_TARGET temperature_fan=<nom_du_ventilateur_température> [target=<température_cible>] [min_speed=<vitesse_min>] [max_speed=<vitesse_max>]` : Définit la température cible d'un ventilateur_température. Si une cible n'est pas fournie, elle est fixée à la température spécifiée dans le fichier de configuration. Si les vitesses ne sont pas fournies, aucun changement n'est appliqué.

### [tmcXXXX]

Les commandes suivantes sont disponibles lorsque l'une des sections [tmcXXXX config](Config_Reference.md#tmc-stepper-driver-configuration) est activée.

#### DUMP_TMC

`DUMP_TMC STEPPER=<name> [REGISTER=<name>]`: Cette commande lira tous les registres du pilote TMC et remontera leurs valeurs. Si un REGISTRE est fourni, seul le registre spécifié sera remonté.

#### INIT_TMC

`INIT_TMC STEPPER=<nom>` : Cette commande initialise les registres de la puce TMC. Nécessaire pour réactiver le pilote si l'alimentation de la puce est coupée puis rétablie.

#### SET_TMC_CURRENT

`SET_TMC_CURRENT STEPPER=<name> CURRENT=<amps> HOLDCURRENT=<amps>`: Cela ajustera les courants de fonctionnement et de maintien du pilote TMC. `HOLDCURRENT` ne s'applique pas aux pilotes tmc2660. Lorsqu'il est utilisé sur un pilote qui a le champ `globalscaler` (tmc5160 et tmc2240), si StealthChop2 est utilisé, le stepper doit être maintenu à l'arrêt pendant > 130 ms afin que le pilote exécute l'étalonnage AT#1.

#### SET_TMC_FIELD

`SET_TMC_FIELD STEPPER=<name> FIELD=<field> VALUE=<value> VELOCITY=<value>`: cCette commande modifiera la valeur du champ de registre spécifié du pilote TMC. Cette commande est destinée uniquement aux diagnostics de bas niveau et au débogage, car la modification des champs pendant l'exécution peut entraîner un comportement indésirable et potentiellement dangereux de votre imprimante. Les modifications permanentes doivent être effectuées à l'aide du fichier de configuration de l'imprimante à la place. Aucune vérification d'intégrité n'est effectuée pour les valeurs données. Une VITESSE peut également être spécifiée à la place d'une VALEUR. Cette vitesse est convertie en représentation de valeur basée sur TSTEP 20 bits. N'utilisez l'argument VELOCITY que pour les champs qui représentent des vitesses.

### [toolhead]

Le module de tête d'outil est automatiquement chargé.

#### SET_VELOCITY_LIMIT

`SET_VELOCITY_LIMIT [VELOCITY=<value>] [ACCEL=<value>] [MINIMUM_CRUISE_RATIO=<value>] [SQUARE_CORNER_VELOCITY=<value>]`: This command can alter the velocity limits that were specified in the printer config file. See the [printer config section](Config_Reference.md#printer) for a description of each parameter.

### [tuning_tower]

Le module tuning_tower est automatiquement chargé.

#### TUNING_TOWER

`TUNING_TOWER COMMAND=<commande> PARAMETER=<nom> START=<valeur> [SKIP=<valeur>] [FACTOR=<valeur> [BAND=<valeur>]]. | [STEP_DELTA=<valeur> STEP_HEIGHT=<valeur>]` : Un outil pour affiner un paramètre sur chaque hauteur Z pendant une impression. L'outil exécutera la `COMMANDE` donnée avec le `PARAMÈTRE` donné assigné à une valeur qui varie avec `Z` selon une formule. Utilisez `FACTOR` si vous allez utiliser une règle ou un pied à coulisse pour mesurer la hauteur Z de la valeur optimale, ou `STEP_DELTA` et `STEP_HEIGHT` si le modèle de tour de réglage a des bandes de valeurs discrètes comme c'est le cas avec les tours de température. Si `SKIP=<valeur>` est spécifié, le processus de réglage ne commence pas avant que la hauteur Z `<valeur>` soit atteinte, et en dessous, la valeur sera mise à `START` ; dans ce cas, la `z_height` utilisée dans les formules ci-dessous est en fait `max(z - skip, 0)`. Il y a trois combinaisons possibles d'options :

- `FACTOR` : La valeur change à un taux de `factor` par millimètre. La formule utilisée est : `valeur = start + factor * z_height`. Vous pouvez insérer la hauteur Z optimale directement dans la formule pour déterminer la valeur optimale du paramètre.
- `FACTOR` and `BAND`: La valeur change à un taux moyen de `factor` par millimètre, mais dans des bandes discrètes où l'ajustement ne sera fait que tous les `BAND` millimètres de hauteur Z. La formule utilisée est : `valeur =start + factor * ((floor(z_height / band) + .5) * band)`.
- `STEP_DELTA` et `STEP_HEIGHT` : La valeur change de `STEP_DELTA` tous les millimètres de `STEP_HEIGHT`. La formule utilisée est : `valeur = start + step_delta * floor(z_height / step_height)`. Vous pouvez simplement compter les bandes ou lire les étiquettes des tours de réglage pour déterminer la valeur optimale.

### [virtual_sdcard]

Klipper prend en charge les commandes G-Code standards suivantes si la section de configuration [virtual_sdcard](Config_Reference.md#virtual_sdcard) est activée :

- Liste des cartes SD : `M20`
- Initialiser la carte SD : `M21`
- Sélectionnez le fichier SD : `M23 <nom du fichier> `
- Démarrer/reprendre l'impression SD : `M24`
- Suspendre l'impression depuis la SD : `M25`
- Définir la position SD : `M26 S<décalage> `
- Afficher l'état d'impression depuis la carte SD : `M27`

En outre, les commandes étendues suivantes sont disponibles lorsque la section de configuration "virtual_sdcard" est activée.

#### SDCARD_PRINT_FILE

`SDCARD_PRINT_FILE FILENAME=<nom_fichier>` : Charge un fichier et lance l'impression SD.

#### SDCARD_RESET_FILE

`SDCARD_RESET_FILE` : Décharge le fichier et efface l'état de la carte SD.

### [z_thermal_adjust]

Les commandes suivantes sont disponibles lorsque la section [z_thermal_adjust config](Config_Reference.md#z_thermal_adjust) est activée.

#### SET_Z_THERMAL_ADJUST

`SET_Z_THERMAL_ADJUST [ENABLE=<0:1>] [TEMP_COEFF=<valeur>] [REF_TEMP=<valeur>]` : Active ou désactive l'ajustement thermique Z avec `ENABLE`. La désactivation ne supprime pas l'ajustement déjà appliqué, mais gèle la valeur d'ajustement actuelle - cela empêche un mouvement Z vers le bas potentiellement dangereux. La réactivation peut potentiellement causer un mouvement de l'outil vers le haut lorsque l'ajustement est mis à jour et appliqué. `TEMP_COEFF` permet de régler le coefficient de température de l'ajustement en cours d'exécution (c'est-à-dire le paramètre de configuration `TEMP_COEFF`). Les valeurs de `TEMP_COEFF` ne sont pas sauvegardées dans la config. `REF_TEMP` remplace manuellement la température de référence généralement réglée pendant le retour à l'origine (pour une utilisation dans des routines de retour à l'origine non standard) - sera remis à zéro automatiquement lors du retour à l'origine.

### [z_tilt]

Les commandes suivantes sont disponibles lorsque la section [z_tilt config](Config_Reference.md#z_tilt) est activée.

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

#### ABORT

`ABORT`: Aborts the calibration process, discarding the current results. This command is only available during drift calibration.

### TEMPERATURE_PROBE_ENABLE

`TEMPERATURE_PROBE_ENABLE ENABLE=[0|1]`: Sets temperature drift compensation on or off. If ENABLE is set to 0, drift compensation will be disabled, if set to 1 it is enabled.
