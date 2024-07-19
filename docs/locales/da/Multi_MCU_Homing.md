# Fler-mcu homing og probeudmåling

Klipper understøtter homing med endestop tilsluttet på én mcu, og stepper motorer tilsluttet en anden. Dette kaldes "fler-mcu homing". Denne funktion kan også bruges når en z-probe er monteret på en anden mcu end stepper motoren.

Denne funktion kan være nyttig til at forkorte ledningsløb, da det kan være mere beljligt at tilslutte et endestop eller probe til en mcu i nærheden. Dog kan dette resultere i "overshoot", hvor stepper motorerne ikke når at stoppe i tide under homing og probeudmåling.

Dette "overshoot" sker hvis der opstår forsinkelser i transmissionen mellem de 2 mcu'er der håndterer sensorer og stepper motorer. Klippers kode er designet til at begrænse denne forsinkelse til ikke mere end 25ms. (Når fler-mcu funktionen er aktiveret sendes der periodiske status beskeder mellem mcu'er for at holde øje med at forsinkelsen ikke overstiger 25ms..)

For eksempel, hvis homing sker ved 10mm/s, så er det muligt at se et "overshoot" på op til 0.250mm (10mm/s*0,025s = 0,250mm). Det anbefales at planlægge for denne forsinkelse ved konfigurationen, for eksempel ved at sætte homing hastighederne ned.

Stepper motor "overshoot" bør ikke påvirke præcisionen betydeligt. Klippers kode vil registrere dette "overshoot" og tage højde for det i beregningerne. Dog er det vigtigt at hardwaren designes på en sådan måde, at et "overshoot" ikke kan skade printeren eller dens dele.

For at kunne bruge denne "multi-mcu homing" funktion skal hardwaren have en sikker lav latency mellem værtscomputeren og alle mcu'er. Typisk skal send/modtag udføres på mindre end 10ms. Høj latency (selv i korte perioder) vil betyde stor sandsynlighed for at "homing" fejler.

Hvis høj latency forårsager en fejl (eller hvis andre kommunikationsproblemer opstår) vil Klipper vise en "Communication timeout during homing" fejl.

Bemærk at en akse med flere steppere (for eksempel `stepper_z `og `stepper_z1`) skal være på samme mcu. Så hvis endestoppet er tilsluttet én mcu, og `stepper_z` er på en anden, skal `stepper_z1` være tilsluttet samme mcu som `stepper_z`.
