# Contact

Dit document bevat contactinformatie voor Klipper.

1. [Community-forum](#community-forum)
1. [Discord-chat](#discord-chat)
1. [Ik heb een vraag over Klipper](#i-have-a-question-about-klipper)
1. [Ik heb een verzoek voor een functie](#i-have-a-feature-request)
1. [Help! Het werkt niet!](#help-it-doesnt-work)
1. [I found a bug in the Klipper software](#i-found-a-bug-in-the-klipper-software)
1. [Ik doe wijzigingen die ik graag terugzie in Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Klipper github](#klipper-github)

## Community-forum

Er is een [Klipper Community Discourse-server](https://community.klipper3d.org) voor discussies over Klipper.

## Discord-chat

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>.

Deze server wordt gebruikt door een community van Klipper-fans voor discussies over Klipper. Het stelt gebruikers in staat om te chatten met anderen.

## Ik heb een vraag over Klipper

Veel vragen die we krijgen zijn al beantwoord in de [Klipper-documentatie](Overview.md). Lees alstublieft de documentatie en volg de daar gegeven aanwijzingen.

Het is ook mogelijk om te zoeken naar vergelijkbare vragen in het [community-forum](#community-forum).

Als je bent geïnteresseerd in het delen van je kennis en ervaring met andere Klipper-gebruikers, dan kun je de [Klipper Community Forum](#community-forum) of de [Klipper Discord Chat](#discord-chat) joinen. Beide zijn community's waar Klipper-gebruikers kunnen discussiëren met andere Klipper-gebruikers.

Veel vragen die we krijgen zijn algemene 3D-printer vragen die niet specifiek over Klipper gaan. Als je een algemene vraag of algemeen printerprobleem hebt, dan heb je een grotere kans op een beter antwoord door de vraag te stellen in een algemeen 3D-printer-forum die gericht is op je type printer.

## Ik heb een functie-aanvraag

Alle nieuwe functies vereisen enige interesse en moeten geïmplementeerd kunnen worden. Als je geïnteresseerd bent in het helpen implementeren of testen van nieuwe functies, kan je zoeken op lopende ontwikkelingen in de [Klipper Community Forum](#community-forum). Er is ook een [Klipper Discord Chat](#discord-chat) voor discussies tussen medewerkers.

## Help! Het werkt niet!

We krijgen helaas meer hulpaanvragen dan we kunnen beantwoorden. De meeste probleemrapportages die we zien worden onderverdeeld in:

1. Kleine fouten in de hardware, of
1. Het niet volgen van de stappen zoals beschreven in de Klipper-documentatie.

If you are experiencing problems we recommend you carefully read the [Klipper documentation](Overview.md) and double check that all steps were followed.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then you will likely get a better response by searching in a general 3d-printing forum or in a forum dedicated to your printer hardware.

It is also possible to search for similar issues in the [Klipper Community Forum](#community-forum).

Als je bent geïnteresseerd in het delen van je kennis en ervaring met andere Klipper-gebruikers, dan kun je de [Klipper Community Forum](#community-forum) of de [Klipper Discord Chat](#discord-chat) joinen. Beide zijn community's waar Klipper-gebruikers kunnen discussiëren met andere Klipper-gebruikers.

## I found a bug in the Klipper software

Klipper is an open-source project and we appreciate when collaborators diagnose errors in the software.

Problems should be reported in the [Klipper Community Forum](#community-forum).

There is important information that will be needed in order to fix a bug. Please follow these steps:

1. Make sure you are running unmodified code from <https://github.com/Klipper3d/klipper>. If the code has been modified or is obtained from another source, then you should reproduce the problem on the unmodified code from <https://github.com/Klipper3d/klipper> prior to reporting.
1. If possible, run an `M112` command immediately after the undesirable event occurs. This causes Klipper to go into a "shutdown state" and it will cause additional debugging information to be written to the log file.
1. Obtain the Klipper log file from the event. The log file has been engineered to answer common questions the Klipper developers have about the software and its environment (software version, hardware type, configuration, event timing, and hundreds of other questions).
   1. The Klipper log file is located in `/tmp/klippy.log` on the Klipper "host" computer (the Raspberry Pi).
   1. An "scp" or "sftp" utility is needed to copy this log file to your desktop computer. The "scp" utility comes standard with Linux and MacOS desktops. There are freely available scp utilities for other desktops (eg, WinSCP). If using a graphical scp utility that can not directly copy `/tmp/klippy.log` then repeatedly click on `..` or `parent folder` until you get to the root directory, click on the `tmp` folder, and then select the `klippy.log` file.
   1. Copy the log file to your desktop so that it can be attached to an issue report.
   1. Do not modify the log file in any way; do not provide a snippet of the log. Only the full unmodified log file provides the necessary information.
   1. It is a good idea to compress the log file with zip or gzip.
1. Open a new topic on the [Klipper Community Forum](#community-forum) and provide a clear description of the problem. Other Klipper contributors will need to understand what steps were taken, what the desired outcome was, and what outcome actually occurred. The compressed Klipper log file should be attached to that topic.

## I am making changes that I'd like to include in Klipper

Klipper is open-source software and we appreciate new contributions.

New contributions (for both code and documentation) are submitted via Github Pull Requests. See the [CONTRIBUTING document](CONTRIBUTING.md) for important information.

There are several [documents for developers](Overview.md#developer-documentation). If you have questions on the code then you can also ask in the [Klipper Community Forum](#community-forum) or on the [Klipper Community Discord](#discord-chat).

## Klipper github

Klipper github may be used by contributors to share the status of their work to improve Klipper. It is expected that the person opening a github ticket is actively working on the given task and will be the one performing all the work necessary to accomplish it. The Klipper github is not used for requests, nor to report bugs, nor to ask questions. Use the [Klipper Community Forum](#community-forum) or the [Klipper Community Discord](#discord-chat) instead.
