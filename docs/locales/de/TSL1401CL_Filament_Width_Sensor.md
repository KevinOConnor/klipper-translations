# TSL1401CL Filamentbreitensensor

Dieses Dokument beschreibt das Hostmodul Filament Width Sensor. Die für die Entwicklung dieses Hostmoduls verwendete Hardware basiert auf dem linearen Sensorarray TSL1401CL, kann aber mit jedem Sensorarray mit Analogausgang verwendet werden. Sie können Entwürfe auf [Thingiverse](https://www.thingiverse.com/search?q=filament%20width%20sensor) finden.

Um ein Sensor-Array als Filament Breitensensor zu verwenden, lesen Sie [Config Reference](Config_Reference.md#tsl1401cl_filament_width_sensor) und [G-Code documentation](G-Codes.md#hall_filament_width_sensor).

## Wie funktioniert das?

Der Sensor erzeugt ein analoges Ausgangssignal basierend auf der berechneten Filamentbreite. Die Ausgangsspannung entspricht immer der ermittelten Filamentbreite (z. B. 1,65 V, 1,70 V, 3,0 V). Das Host-Modul überwacht Spannungsänderungen und passt den Extrusionsmultiplikator an.

## Hinweis:

Die Sensormessungen werden standardmäßig in 10-mm-Abständen durchgeführt. Bei Bedarf können Sie diese Einstellung jedoch ändern, indem Sie den Parameter ***MEASUREMENT_INTERVAL_MM*** in der Datei **filament_width_sensor.py** bearbeiten.
