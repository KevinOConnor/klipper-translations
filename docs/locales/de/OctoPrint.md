# OctoPrint für Klipper

Klipper hat ein paar Optionen für sein Frontend, OctoPrint war das erste und originale Frontend für Klipper. Dieses Dokument gibt eine kurze Übersicht über das Installieren mit dieser Option.

## Mit OctoPi installieren

Beginnen Sie mit der Installation von [OctoPi](https://github.com/guysoft/OctoPi) auf dem Raspberry Pi. Benutzen Sie OctoPi v0.17.0 oder neuer - sehen Sie [OctoPi releases](https://github.com/guysoft/OctoPi/releases) für Information über Releases.

Man sollte sicherstellen, dass der OctoPi hochfährt und der OctoPrint-Webserver funktioniert. Nachdem Sie sich mit der OctoPrint-Webseite verbunden haben, folgen Sie, wenn nötig, der Anweisung, OctoPrint zu aktualisieren.

Nach der Installation und dem Upgrade von OctoPi wird es nötig sein, in das Zielgerät zu SSHen und eine Handvoll Systembefehle auszuführen.

Beginnen Sie, indem Sie diese Befehle auf dem Host-Gerät ausführen:

**Wenn Sie git nicht installiert haben, tun Sie das bitte mit:**

```
sudo apt install git
```

dann fortfahren:

```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Das Obenstehende wird Klipper herunterladen, die notwendigen Systemabhängigkeiten installieren, Klipper aufsetzen, sodass es beim Hochfahren startet und die Klipper Host-Software starten. Es benötigt eine Internetverbindung und kann ein paar Minuten zum Fertigstellen brauchen.

## Installation mit KIAUH

KIAUH kann verwendet werden, um OctoPrint auf einer Vielzahl an Linux-Systemen zu installieren, die auf einer Form von Debian laufen. Mehr Informationen können unter https://github.com/dw-0/kiauh gefunden werden

## Konfiguration von OctoPrint zur Nutzung mit Klipper

Der OctoPrint-Webserver muss konfiguriert werden, um mit der Klipper Host-Software zu kommunizieren. Loggen Sie sich mit einem Webbrowser auf der OctoPrint-Website ein und konfigurieren Sie die folgenden Einträge:

Navigieren Sie zum Einstellungstab (Das Zahnradsymbol oben auf der Seite). Fügen Sie unter „Serial Connection“ in „Additional serial ports“ hinzu:

```
~/printer_data/comms/klippy.sock
```

Dann drücken Sie „Save“.

*In einigen älteren Setups kann diese Adresse `/tmp/printer` sein*

Öffnen Sie den Einstellungstab erneut und ändern Sie unter „Serial Connection“ den „Serial Port“ zum oben hinzugefügten.

Navigieren Sie im Einstellungstab zum „Behavior“ Untertab und wählen Sie die Option „Cancel any ongoing prints but stay connected to the printer“. Klicken Sie „Speichern“.

Von der Hauptseite aus, stellen sie sicher, dass unter der Sektion „Connection“ (oben links auf der Seite) der „Serial Port“ zum neuen, zusätzlichen gesetzt ist und klicken Sie „Connect“. (Wenn es nicht in der Auswahl verfügbar ist, versuchen Sie, die Seite neu zu laden.)

Sobald Sie verbunden sind, navigieren Sie zum „Terminal“-Tab und geben sie „status“ (ohne die Anführungszeichen) in die Befehlseingabe und klicken Sie auf „Senden“. Das Terminal-Fenster wird wahrscheinlich melden, dass es einen Fehler beim Öffnen der Konfigurationsdatei gibt - das bedeutet, dass OctoPrint erfolgreich mit Klipper kommuniziert.

Bitte fahren Sie mit <Installation.md> und der Sektion *Building and flashing the micro-controller* fort
