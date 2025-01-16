# OctoPrint for Klipper

Klipper 有几个不同的前端选择，Octoprint 是最早也是最原始的Klipper 前端。这篇文档会给一个大致的概览关于如何在Octoprint 上安装Klipper。

## 在OctoPi 上进行安装

首先在 Raspberry Pi 上安装 [OctoPi](https://github.com/guysoft/OctoPi)。使用 OctoPi v0.17.0 或更高版本 - 有关版本信息，请参考 [OctoPi release](https://github.com/guysoft/OctoPi/releases)。

需要确认OctoPi 正常启动并且OctoPrint 网页服务器正常工作。当连接到OctoPrint网页后，根据提示更新OctoPrint。

当安装完成OctoPi 并且更新完成OctoPrint 后，使用ssh 进入目标机器运行一些系统命令是有必要的。

现在来在你的Host 设备上运行这些指令：

**如果你没有安装git，你需要使用以下命令进行安装：**

```
sudo apt install git
```

然后使用以下命令：

```
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

以上命令会下载Klipper，并且安装必要的系统依赖，配置Klipper 在系统启动时运行，以及启动Klipper Host 软件。这些操作会需要互联网连接并且可能需要几分钟来完成。

## 使用KIAUH进行安装

KIAUH 可以用来在各种基于Debian Linux 发行版上安装 OctoPrint。更多的使用细节可以在 https://github.com/dw-0/kiauh 找到

## 配置OctoPrint 去使用Klipper

OctoPrint 网页服务器需要配置和Klipper Host 软件的连接。使用浏览器登录到 OctoPrint 网页并且配置以下内容：

浏览到设置界面（在网页顶部的扳手图标）。在"Serial Connection" 下的 "Additional serial ports" 添加：

```
~/printer_data/comms/klippy.serial
```

然后点击"保存"。

*在比较老的配置中这个地址可能是 `/tmp/printer`*

再次进入设置界面中的 "Serial Connection" 更改 "Serial Port" 设置到上面添加的。

在设置界面浏览到 "Behavior" 子菜单并且选择 "Cancel any ongoing prints but stay connected to the printer" 的选项。并且点击"保存"。

在主界面的 "Connection" 下面（在界面的左上角）确定 "Serial Port" 被选择并且点击 "Connect"。（如果没有可选的可以尝试刷新界面。）

当成功连接，选择"Terminal" 窗口并且输入"status"（不要有括号）到命令行窗口中并且点击"Send"。命令行窗口很大的可能会显示缺少配置文件 - 这意味着OctoPrint 成功上了 Klipper。

接下来继续 <Installation.md>的 *Building and flashing the micro-controller*部分
