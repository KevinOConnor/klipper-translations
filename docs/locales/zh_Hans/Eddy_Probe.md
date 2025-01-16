# Eddy 感应涡流探针

这个文档解释了如何在klipper 中使用 [eddy 涡流传感器](https://en.wikipedia.org/wiki/Eddy_current)。

目前eddy涡流传感器不能作为z 限位传感器使用。这个传感器只能用作z探针。

首先在 printer.cfg 文件中声明 [probe_eddy_current 配置部分](Config_Reference.md#probe_eddy_current)。建议将 `z_offset` 设置为 0.5mm。传感器通常需要 `x_offset` 和 `y_offset`。如果不知道这些值，则应在初始校准时估算这些值。

校准的第一步是确定传感器的适当 DRIVE_CURRENT。将打印机调至原位，并移动工具头，使传感器靠近床面中心并高出床面约 20 毫米。然后使用 `LDC_CALIBRATE_DRIVE_CURRENT CHIP=<config_name>` 命令。例如，如果配置部分名为`[probe_eddy_current my_eddy_probe]`，则应运行 `LDC_CALIBRATE_DRIVE_CURRENT CHIP=my_eddy_probe`。该命令应在几秒钟内完成。完成后，使用 `SAVE_CONFIG` 命令将结果保存到 printer.cfg 中，然后重新启动。

校准的第二步是将传感器读数与相应的 Z 高度相关联。将打印机调回原位，并移动工具头，使喷嘴靠近床面中心。然后运行 `PROBE_EDDY_CURRENT_CALIBRATE CHIP=my_eddy_probe` 命令。工具启动后，按照[“纸张测试”](Bed_Level.md#the-paper-test)中描述的步骤确定给定位置上喷嘴和床面之间的实际距离。完成这些步骤后，就可以 `ACCEPT` 该位置。然后，工具将移动工具头，使传感器位于喷嘴位置的上方，并运行一系列运动，将传感器与 Z 位置相关联。这需要几分钟时间。工具完成后，发出 `SAVE_CONFIG` 命令将结果保存到 printer.cfg 中，然后重新启动。

在第一次校准后最好验证 `x_offset` 和 `y_offset` 是否准确。请按照[校准探针 X Y 偏移](Probe_Calibrate.md#calibrating-probe-x and-y-offsets)的步骤操作。如果修改了 `x_offset` 或 `y_offset` ，请务必在修改后运行 `PROBE_EDDY_CURRENT_CALIBRATE` 命令（如上所述）。

一旦校准完成，可以使用所有标准的Klipper 工具命令使用z探针。

请注意，涡流传感器（以及一般的感应探针）容易受到 “温飘”的影响。也就是说，温度变化会导致报告的 Z 高度发生变化。床面温度或传感器硬件温度的变化都会导致结果偏差。重要的是，校准和探测只能在打印机温度稳定时进行。

## 温度漂移校准

像所有的感应探针一样，eddy 涡流探针会有很严重的温度偏移。如果eddy 涡流传感器线圈上的温度传感器上可以被配置为`[temperature_probe]` 去反馈线圈的温度并且启用软件温度偏移补偿。要将探针温度传感器与eddy 涡流传感器连接`[temperature_probe]` 的名字必须和`[probe_eddy_current]`一致。比如：

```
[probe_eddy_current my_probe]
# eddy 探针配置文件

[temperature_probe my_probe]
# 温度探针配置文件
```

See the [configuration reference](Config_Reference.md#temperature_probe) for further details on how to configure a `temperature_probe`. It is advised to configure the `calibration_position`, `calibration_extruder_temp`, `extruder_heating_z`, and `calibration_bed_temp` options, as doing so will automate some of the steps outlined below. If the printer to be calibrated is enclosed, it is strongly recommended to set the `max_validation_temp` option to a value between 100 and 120.

Eddy probe的制造商提供了一些可以使用的校准预设可以手动添加到`[probe_eddy_current]`中到`drift_calibration`选项中。如果他们没提供预设的校准文件或者预设的校准文件不适用于你的系统，`temperature_probe`模块可以使用TEMPERATURE_PROBE_CALIBRATE`命令来进行手动校准。

在进行校准前，用户应该知道大概的探针线圈最大温度。这个温度应该被配置到`TEMPERATURE_PROBE_CALIBRATE`命令的`TARGET`选项中。校准的目的是尽量有一个最宽的温度范围，因此最好在打印机冷却后进行校准，并且在线圈到达最高温度的时候停止。

当`[temperature_probe]` 被配置后，可以使用以下步骤进行热偏移校准：

- 当 `[temperature_probe]` 被配置后应该使用`PROBE_EDDY_CURRENT_CALIBRATE`对探针校准。这会获取校准中的温度的变化，并且这对于温度偏移校准是非常有必要的。
- 确保喷头保持清洁并且没有多余的耗材残留。
- 热床，喷头，和探针线圈在校准前需要到达室温。
- 如果**没配置**`[temperature_probe]`中的`calibration_position`，`calibration_extruder_temp`和`extruder_heating_z`选项，则需要执行以下步骤：
   - 移动喷头到热床的中心。z轴高度应该至少高于热床30mm。
   - 加热挤出机温度到最大热床安全温度。150-170C 通常来说适用于绝大部分的配置。加热挤出机的目的是避免喷头在校准过程中的热膨胀。
   - 当挤出机到达设定温度，移动z下降到离热床1mm的位置。
- 开始漂移校准。如果探针名字是`my_probe` 并且最大探针温度可以到达80C，可以使用`TEMPERATURE_PROBE_CALIBRATE PROBE=my_probe TARGET=80`来进行校准。如果进行了配置，喷头的XY应该会移动到`calibration_position` 并且Z轴通过`extruder_heating_z`来调整。将挤出机加热到指定温度后，工具将会移动到`calibration_position`中指定的 Z 值。
- 程序将要求进行手动探测。使用纸张测试执行手动探头，然后使用 `ACCEPT`接受当前位置。校准程序将使用探针采集第一组采样，然后将探针停在加热位置。
- 如果`calibration_bed_temp`**未被**配置启动热床加热到最高安全温度。否则将自动执行此步骤。
- 在默认的校准流程中在到达 `TARGET`之前会每2C要求一次手动偏移探针校准。温度偏移量在校准中可以通过`TEMPERATURE_PROBE_CALIBRATE` 中的`STEP`来进行修改。注意在自定义`STEP` 的值的时候，特别高的值和太少的校准点回导致很差的校准结果。
- 在热偏移校准中，可以使用这些额外的gcode 命令：
   - `TEMPERATURE_PROBE_NEXT`可以到达指定温度之前强制创建一个新的采样点。
   - `TEMPERATURE_PROBE_COMPLETE` 可以在到达 `TARGET` 之前完成校准。
   - `ABORT` 可以用来结束校准或者取消结果。
- 当校准完成使用`SAVE_CONFIG`去保存温度偏移设置。

综上所述，与大多数其他程序相比，上述校准过程更具挑战性，也更耗时。它可能需要练习和多次尝试才能达到最佳校准效果。
