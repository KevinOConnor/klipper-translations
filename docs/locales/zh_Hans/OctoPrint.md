# OctoPrint for Klipper

Klipper 有几个不同的前端选择，Octoprint 是最早也是最原始的Klipper 前端。这篇文档会给一个大致的概览关于如何在Octoprint 上安装Klipper。

## 在OctoPi 上进行安装

首先在 Raspberry Pi 上安装 [OctoPi](https://github.com/guysoft/OctoPi)。使用 OctoPi v0.17.0 或更高版本 - 有关版本信息，请参考 [OctoPi release](https://github.com/guysoft/OctoPi/releases)。

One should verify that OctoPi boots and that the OctoPrint web server works. After connecting to the OctoPrint web page, follow the prompt to upgrade OctoPrint if needed.

After installing OctoPi and upgrading OctoPrint, it will be necessary to ssh into the target machine to run a handful of system commands.

Start by running these commands on your host device:

**If you do not have git installed, please do so with:**

```
sudo apt install git
```

then proceed:

```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

The above will download Klipper, install the needed system dependencies, setup Klipper to run at system startup, and start the Klipper host software. It will require an internet connection and it may take a few minutes to complete.

## Installing with KIAUH

KIAUH can be used to install OctoPrint on a variety of Linux based systems that run a form of Debian. More information can be found at https://github.com/dw-0/kiauh

## Configuring OctoPrint to use Klipper

The OctoPrint web server needs to be configured to communicate with the Klipper host software. Using a web browser, login to the OctoPrint web page and then configure the following items:

Navigate to the Settings tab (the wrench icon at the top of the page). Under "Serial Connection" in "Additional serial ports" add:

```
~/printer_data/comms/klippy.sock
```

Then click "Save".

*In some older setups this address may be `/tmp/printer`*

Enter the Settings tab again and under "Serial Connection" change the "Serial Port" setting to the one added above.

In the Settings tab, navigate to the "Behavior" sub-tab and select the "Cancel any ongoing prints but stay connected to the printer" option. Click "Save".

From the main page, under the "Connection" section (at the top left of the page) make sure the "Serial Port" is set to the new additional one added and click "Connect". (If it is not in the available selection then try reloading the page.)

Once connected, navigate to the "Terminal" tab and type "status" (without the quotes) into the command entry box and click "Send". The terminal window will likely report there is an error opening the config file - that means OctoPrint is successfully communicating with Klipper.

Please proceed to <Installation.md> and the *Building and flashing the micro-controller* section
