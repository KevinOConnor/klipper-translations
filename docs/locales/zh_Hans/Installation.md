# 安装

These instructions assume the software will run on a linux based host running a Klipper compatible front end. It is recommended that a SBC(Small Board Computer) such as a Raspberry Pi or Debian based Linux device be used as the host machine (see the [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) for other options).

For the purposes of these instructions host relates to the Linux device and mcu relates to the printboard. SBC relates to the term Small Board Computer such as the Raspberry Pi.

## 获取 Klipper 配置文件

Most Klipper settings are determined by a "printer configuration file" printer.cfg, that will be stored on the host. An appropriate configuration file can often be found by looking in the Klipper [config directory](../config/) for a file starting with a "printer-" prefix that corresponds to the target printer. The Klipper configuration file contains technical information about the printer that will be needed during the installation.

如果 Klipper 配置目录中没有合适的打印机配置文件，请尝试搜索打印机制造商的网站，看看他们是否有合适的 Klipper 配置文件。

如果找不到打印机的配置文件，但可以找到打印机控制板的类型，则可以查找以“generic-”前缀开头的适当 [配置文件](../config/)。这些示例打印机模板文件应该足以成功完成初始安装，但需要进行一些自定义才能获得完整的打印机功能。

也可以从头开始定义一个新的打印机配置。然而，这需要关于打印机及其电子系统的大量技术知识。建议大多数用户从一个适当的配置文件开始。如果需要创建一个新的自定义打印机配置文件，那么可以先从最接近的[配置文件](../config/)的例子开始，并从 Klipper [配置参考文档](Config_Reference.md)了解进一步信息。

## Interacting with Klipper

Klipper is a 3d printer firmware, so it needs some way for the user to interact with it.

Currently the best choices are front ends that retrieve information through the [Moonraker web API](https://moonraker.readthedocs.io/) and there is also the option to use [Octoprint](https://octoprint.org/) to control Klipper.

The choice is up to the user on what to use, but the underlying Klipper is the same in all cases. We encourage users to research the options available and make an informed decision.

## Obtaining an OS image for SBC's

There are many ways to obtain an OS image for Klipper for SBC use, most depend on what front end you wish to use. Some manafactures of these SBC boards also provide their own Klipper-centric images.

The two main Moonraker based front ends are [Fluidd](https://docs.fluidd.xyz/) and [Mainsail](https://docs.mainsail.xyz/), the latter of which has a premade install image ["MainsailOS"](http://docs.mainsailOS.xyz), this has the option for Raspberry Pi and some OrangePi varianta.

Fluidd can be installed via KIAUH(Klipper Install And Update Helper), which is explained below and is a 3rd party installer for all things Klipper.

OctoPrint can be installed via the popular OctoPi image or via KIAUH, this process is explained in <OctoPrint.md>

## Installing via KIAUH

Normally you would start with a base image for your SBC, RPiOS Lite for example, or in the case of a x86 Linux device, Ubuntu Server. Please note that Desktop variants are not recommended due to certain helper programs that can stop some Klipper functions working and even mask access to some print boards.

KIAUH can be used to install Klipper and its associated programs on a variety of Linux based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## 构建和刷写微控制器

To compile the micro-controller code, start by running these commands on your host device:

```
cd ~/klipper/
make menuconfig
```

[打印机配置文件](#obtain-a-klipper-configuration-file)的顶部注释应该描述了"make menuconfig"期间需要设置的设置。在网络浏览器或文本编辑器中打开该文件，在文件顶部附近寻找这些说明。一旦适当的"menuconfig"设置被配置好了，按"Q"退出，然后按"Y"保存，运行：

```
make
```

如果[打印机配置文件](#obtain-a-klipper-configuration-file)顶部的注释描述了"flashing"最终固件镜像到打印机控制板的特殊步骤，那么请遵循这些步骤，然后继续进行[配置OctoPrint](#configuring-octoprint-to-use-klipper)。

否则，通常采用以下步骤来"flash"打印机控制板。首先，需要确定连接到微控制器的串行端口。然后，运行以下程序：

```
ls /dev/serial/by-id/*
```

它应该报告类似以下的内容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

It's common for each printer to have its own unique serial port name. This unique name will be used when flashing the micro-controller. It's possible there may be multiple lines in the above output - if so, choose the line corresponding to the micro-controller. If many items are listed and the choice is ambiguous, unplug the board and run the command again, the missing item will be your print board(see the [FAQ](FAQ.md#wheres-my-serial-port) for more information).

For common micro-controllers with STM32 or clone chips, LPC chips and others it is usual that these need an initial Klipper flash via SD card.

When flashing with this method, it is important to make sure that the print board is not connected with USB to the host, due to some boards being able to feed power back to the board and stopping a flash from occuring.

For common micro-controllers using Atmega chips, for example the 2560, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

请务必用打印机的唯一串行端口名称来更新 FLASH_DEVICE 参数。

For common micro-controllers using RP2040 chips, the code can be flashed with something similar to:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

It is important to note that RP2040 chips may need to be put into Boot mode before this operation.

## 配置 Klipper

The next step is to copy the [printer configuration file](#obtain-a-klipper-configuration-file) to the host.

Arguably the easiest way to set the Klipper configuration file is using the built in editors in Mainsail or Fluidd. These will allow the user to open the configuration examples and save them to be printer.cfg.

Another option is to use a desktop editor that supports editing files over the "scp" and/or "sftp" protocols. There are freely available tools that support this (eg, Notepad++, WinSCP, and Cyberduck). Load the printer config file in the editor and then save it as a file named "printer.cfg" in the home directory of the pi user (ie, /home/pi/printer.cfg).

Alternatively, one can also copy and edit the file directly on the host via ssh. That may look something like the following (be sure to update the command to use the appropriate printer config filename):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

通常每台打印机都有自己独特的微控制器名称。刷写Klipper后，名称可能会改变，所以即使在闪存时已经完成，也要重新运行这些步骤。运行：

```
ls /dev/serial/by-id/*
```

它应该报告类似以下的内容：

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

然后用这个唯一的名字更新配置文件。例如，更新`[mcu]`部分，类似于：

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

After creating and editing the file it will be necessary to issue a "restart" command in the command console to load the config. A "status" command will report the printer is ready if the Klipper config file is successfully read and the micro-controller is successfully found and configured.

在定制打印机配置文件时，Klipper 报告配置错误是很正常的情况。如果发生错误，请对打印机配置文件进行必要的修正，并发出"restart"，直到"status"报告打印机已准备就绪。

Klipper reports error messages via the command console and via pop up in Fluidd and Mainsail. The "status" command can be used to re-report error messages. A log is available and usually located in ~/printer_data/logs this is named klippy.log

在Klipper报告打印机已就绪后，继续进入[配置检查文件](Config_checks.md)，对配置文件中的定义进行一些基本检查。其他信息见主[文档参考](Overview.md)。
