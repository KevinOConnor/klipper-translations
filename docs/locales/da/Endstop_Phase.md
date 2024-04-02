# Endestop fase

Dette dokument beskriver Klippers Stepper fase endestop system. Denne funktionalitet kan forbedre præcisionen af traditionelle endestop-kontakter. Det er mest brugbart ved brug af Trinamic stepper motor drivere der tillader "run-time" konfiguration.

En typisk endestop-kontakt har en præcision på ca 100µ. (Hver gang en akse nulstilles kan kontakten aktiveres lidt tidligere eller lidt senere end sidste aktivering). Selvom dette er en relativt lille forskel, kan det resultere i uønskede artefakter. I særdeleshed kan denne afvigelse vise sig ved print af det første lag af et objekt. De fleste stepper motorer kan opnå en markant højere præcision.

Fase justeret endestop kan bruge stepper motorerens precision til at øge endestop-kontaktens præcision. En stepper motor bevæger sig ved at gennemføre en cyklus gennem faser indtil den har udført fire "fulde steps". Så hvis en stepper motor bruger 16 mikro-steps, vil den have 64 faser, og ved bevægelse i positiv retning vil den gennemgå disse faser således: 0, 1, 2, ... 61, 62,63, 0, 1, 2 osv. Derfor bør en stepper motor være ved en bestemt fase, på et bestemt punkt på sin akse. Så når slæden aktiverer endestop-kontakten, bør stepperen altid være på samme fase. Klippers endestop fase system kombinerer stepper motorens fase med endestop-kontakten for at øge præcisionen.

For at bruge denne funktion er det nødvendigt at identificere fasen op stepper motoren. Hvis du bruger Trinamic TMC2130, TMC2208, TMC2224 eller TMC2660 drivere i "run-time"konfiguration (altså ikke i "stand-alone") så kan Klipper anmode om stepper motorens fase fra driveren. (Det er også muligt at bruge dette system med traditionelle driverem hvis disse kan nulstilles stabilt. Se nedenfor for yderligere detaljer.)

## Kalibrering af endestop faser

Hvis du bruger Trinamic stepper drivere med "run-time" konfiguration kan du kalibrere endestop fasen ved brug af ENDSTOP_PHASE_CALIBRATE kommandoen. Start med at tilføje følgende til konfigurationsfilen:

```
[endstop_phase]
```

Genstart derefter printeren og kør `G28` kommandoen efterfulgt af `ENDSTOP_PHASE_CALIBRATE` kommandoen. Flyt derefter aksen til en ny position og kør `G28` igen. Gør dette minimum 5 gange.

Efter at have udført ovenstående, `ENDSTOP_PHASE_CALIBRATE` kommandoen bør vise den samme, eller tæt på, fase for stepper motoren. Denne fase kan gemmes i konfigurationsfilen så alle senere G28 kommandoer bruger denne fase. (På den måde vil Klipper fremover bruge samme postition/fase uanset om endestop-kontakten aktiveres lidt før eller efter.)

For at gemme endestop fasen for en specifik stepper motor, køres en kommando som denne:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Kør ovenstående kommando for alle ønskede steppere/akser. Typisk vil man bruge dette på stepper_z for Kartesiske og CoreXY printere, og på stepper_a, stepper_b og stepper_c for Delta printere. Til sidst køres følgende for at opdatere konfigurationsfilen med de nye data:

```
SAVE_CONFIG
```

### Yderligere noter

* Denne funktion er mest brugbar på Delta printere og på z-aksen på kartesiske og corexy printere. Det ER muligt at bruge denne funktion på X/Y akserne, men det vil ikke have stor effekt, da en så lille forskel sjældent vil have indflydelse på slutresultatet. Funktionen kan IKKE bruges på X/Y akserne på corexy printere, da disse positioner afhænger af 2 stepper motorers positioner. Den kan heller IKKE bruges på printere der bruger "probe:z_virtual_endstop" da stepperens fase kun kan bruges når endestop kontakten er monteret fast på aksen.
* Efter kalibrering af endestop faser, hvis kontakten senere flyttes eller justeres, vil det være nødvendigt at kalibrere endestoppene igen. Fjerne kalibrerings dataene fra konfigurationsfilen og gennemgå trinene ovenfor igen.
* For at bruge dette system skal endestoppet være præcist nok til at aktivere inden for 2 "fulde steps". For eksempel, hvis stepperen bruger 16 mikro-steps med en distance per step på 0.005mm, så skal endestoppet være præcist ned til minimum 0.160mm. Hvis fejlen "Endstop stepper_z incorrect phase" vises, kan det være fordi at endestoppet ikke er præcist nok. Hvis rekalibrering ikke afhjælper fejlen, skal du deaktivere endestop fase systemet ved at fjerne dataene fra konfigurationsfilen.
* Hvis der bruges traditionelle stepper styrede z_akser (som på kartesiske og corexy printere) sammen med traditionel byggeplade skrue-nivellering, så kan dette system også bruges til at arrangere at hvert lag printes på en "fuldt step" grænse. For at aktivere denne funktion skal du sikre dig at slicer-softwaren er konfigureret med en laghøjde der er delelig med højden på et "fuldt step", manueltaktivere "endstop_align_zero" funktionen i "endstop_phase" sektionen af konfigurationsfilen. Se [Konfigurationsreference](Config_Reference.md#endstop_phase) for yderligere detaljer, og juster derefter byggepladens skruer.
* Det er muligt at bruge dette system med traditionelle (ikke Trinamic) stepper motor drivere. Dog kræver dette at det sikres at stepper motor driverne bliver nulstillet hver gang mcu'en nulstilles. Hvis disse altid nulstilles sammen, kan Klipper bestemme stepperens fasen ved at logge det totale antal af steps stepper motoren er blevet bedt om at bevæge sig. I øjeblikket er den eneste pålidelige måde at gøre dette på, hvis både stepper motor driver og mcu begge får strøm via USB, samt at denne USB styres af en vært på en Raspberry Pi. I denne situation kan man indstille mcu konfigurationen til "restartmethod:rpi_usb" - Dette vil sørge for at mcu'en altid nulstilles ved genstart af USB strømtilførslen, Hvilket vil sørge for at både stepper motor drivere og mcu nulstilles på samme tid. Ved brug af denne funktion skal "trigger_phase" sektionen konfigureres, se [Konfigurationsreference](Config_Reference.md#endstop_phase) for yderligere detaljer.
