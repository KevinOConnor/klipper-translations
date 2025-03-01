# 연락처

이 문서는 Klipper와 관련된 연락 수단을 제공합니다.

1. [커뮤니티 포럼](#커뮤니티-포럼)
1. [디스코드 채팅](#디스코드-채팅)
1. [Klipper에 관한 질문이 있습니다](#Klipper에-관한-질문이-있습니다)
1. [새로운 기능을 제안하고 싶습니다](#새로운-기능을-제안하고-싶습니다)
1. [무언가가 작동하지 않습니다! 도와주세요!](#무언가가-작동하지-않습니다-도와주세요)
1. [I found a bug in the Klipper software](#i-found-a-bug-in-the-klipper-software)
1. [I am making changes that I'd like to include in Klipper](#i-am-making-changes-that-id-like-to-include-in-klipper)
1. [Klipper github](#klipper-github)

## 커뮤니티 포럼

Klipper에 관한 논의를 위한 [Klipper 커뮤니니 디스코스 서버](https://community.klipper3d.org)가 있습니다.

## 디스코드 채팅

There is a Discord server dedicated to Klipper at: <https://discord.klipper3d.org>.

이 서버는 Klipper에 관한 논의를 위해 열정적인 Klipper 사용자들에 의하여 운영되며, 다른 사용자들과 실시간으로 대화를 나눌 수 있습니다.

## 클리퍼에 관한 질문이 있습니다

우리가 받는 대부분의 질문에 대한 답은 이미 [Klipper 설명서](Overview.md)에 있습니다. 설명서에 제시된 해결 방법을 따르십시오.

It is also possible to search for similar questions in the [Klipper Community Forum](#community-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Community Forum](#community-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

Many questions we receive are general 3d-printing questions that are not specific to Klipper. If you have a general question or are experiencing general printing problems, then you will likely get a better response by asking in a general 3d-printing forum or a forum dedicated to your printer hardware.

## I have a feature request

All new features require someone interested and able to implement that feature. If you are interested in helping to implement or test a new feature, you can search for ongoing developments in the [Klipper Community Forum](#community-forum). There is also [Klipper Discord Chat](#discord-chat) for discussions between collaborators.

## Help! It doesn't work!

Unfortunately, we receive many more requests for help than we could possibly answer. Most problem reports we see are eventually tracked down to:

1. Subtle errors in the hardware, or
1. Not following all the steps described in the Klipper documentation.

If you are experiencing problems we recommend you carefully read the [Klipper documentation](Overview.md) and double check that all steps were followed.

If you are experiencing a printing problem, then we recommend carefully inspecting the printer hardware (all joints, wires, screws, etc.) and verify nothing is abnormal. We find most printing problems are not related to the Klipper software. If you do find a problem with the printer hardware then you will likely get a better response by searching in a general 3d-printing forum or in a forum dedicated to your printer hardware.

It is also possible to search for similar issues in the [Klipper Community Forum](#community-forum).

If you are interested in sharing your knowledge and experience with other Klipper users then you can join the [Klipper Community Forum](#community-forum) or [Klipper Discord Chat](#discord-chat). Both are communities where Klipper users can discuss Klipper with other users.

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
