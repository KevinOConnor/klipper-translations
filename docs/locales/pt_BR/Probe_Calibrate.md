# Probe calibration

This document describes the method for calibrating the X, Y, and Z offsets of an "automatic z probe" in Klipper. This is useful for users that have a `[probe]` or `[bltouch]` section in their config file.

## Calibrando os deslocamentos de Eixo X e Y da sonda

Para calibrar o deslocamento de eixos X e Y, navegue até a aba "Controle" (Control) do OctoPrint, coloque a impressora na posição inicial e use os botões de movimentação do OctoPrint para mover o extrusor para uma posição próxima ao centro da mesa.

Coloque um pedaço de fita azul (ou similar) na mesa, embaixo da sonda (probe). Navegue até a aba "Terminal" do OctoPrint e emita um comando PROBE:

```
PROBE
```

Faça uma marca na fita diretamente abaixo de onde a sonda está (ou use outro método para anotar o local na mesa).

Emita um comando `GET_POSITION` e registre a localização (XY) da cabeça do extrusor relatada por esse comando. Por exemplo:

```
Recv: // toolhead: X:46.500000 Y:27.000000 Z:15.000000 E:0.000000
```

então seria registrada uma posição da sonda (Eixo X) de 46,5 e uma posição da sonda (Eixo Y) de 27.

Após registrar a posição da sonda, emita uma série de comandos G1 até que o extrusor diretamente acima da marca na mesa. Por exemplo:

```
G1 F300 X57 Y30 Z15
```

para mover o extrusor para uma posição de Eixo X de 57 e uma de Eixo Y de 30. Uma vez que se encontre a posição diretamente acima da marca, use o comando `GET_POSITION` para registrar essa posição. Esta é a posição do bocal (extrusor).

The x_offset is then the `nozzle_x_position - probe_x_position` and y_offset is similarly the `nozzle_y_position - probe_y_position`. Update the printer.cfg file with the given values, remove the tape/marks from the bed, and then issue a `RESTART` command so that the new values take effect.

## Calibrating probe Z offset

Providing an accurate probe z_offset is critical to obtaining high quality prints. The z_offset is the distance between the nozzle and bed when the probe triggers. The Klipper `PROBE_CALIBRATE` tool can be used to obtain this value - it will run an automatic probe to measure the probe's Z trigger position and then start a manual probe to obtain the nozzle Z height. The probe z_offset will then be calculated from these measurements.

Start by homing the printer and then move the head to a position near the center of the bed. Navigate to the OctoPrint terminal tab and run the `PROBE_CALIBRATE` command to start the tool.

This tool will perform an automatic probe, then lift the head, move the nozzle over the location of the probe point, and start the manual probe tool. If the nozzle does not move to a position above the automatic probe point, then `ABORT` the manual probe tool and perform the XY probe offset calibration described above.

Once the manual probe tool starts, follow the steps described at ["the paper test"](Bed_Level.md#the-paper-test) to determine the actual distance between the nozzle and bed at the given location. Once those steps are complete one can `ACCEPT` the position and save the results to the config file with:

```
SAVE_CONFIG
```

Note that if a change is made to the printer's motion system, hotend position, or probe location then it will invalidate the results of PROBE_CALIBRATE.

If the probe has an X or Y offset and the bed tilt is changed (eg, by adjusting bed screws, running DELTA_CALIBRATE, running Z_TILT_ADJUST, running QUAD_GANTRY_LEVEL, or similar) then it will invalidate the results of PROBE_CALIBRATE. After making any of the above adjustments it will be necessary to run PROBE_CALIBRATE again.

If the results of PROBE_CALIBRATE are invalidated, then any previous [bed mesh](Bed_Mesh.md) results that were obtained using the probe are also invalidated - it will be necessary to rerun BED_MESH_CALIBRATE after recalibrating the probe.

## Repeatability check

After calibrating the probe X, Y, and Z offsets it is a good idea to verify that the probe provides repeatable results. Start by homing the printer and then move the head to a position near the center of the bed. Navigate to the OctoPrint terminal tab and run the `PROBE_ACCURACY` command.

This command will run the probe ten times and produce output similar to the following:

```
Recv: // probe accuracy: at X:0.000 Y:0.000 Z:10.000
Recv: // and read 10 times with speed of 5 mm/s
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe at -0.003,0.005 is z=2.519448
Recv: // probe at -0.003,0.005 is z=2.506948
Recv: // probe accuracy results: maximum 2.519448, minimum 2.506948, range 0.012500, average 2.513198, median 2.513198, standard deviation 0.006250
```

Ideally the tool will report an identical maximum and minimum value. (That is, ideally the probe obtains an identical result on all ten probes.) However, it's normal for the minimum and maximum values to differ by one Z "step distance" or up to 5 microns (.005mm). A "step distance" is `rotation_distance/(full_steps_per_rotation*microsteps)`. The distance between the minimum and the maximum value is called the range. So, in the above example, since the printer uses a Z step distance of .0125, a range of 0.012500 would be considered normal.

Se os resultados do teste mostrarem um valor de intervalo maior que 25 mícrons (0,025 mm), a sonda (probe) não tem precisão suficiente para procedimentos típicos de nivelamento da mesa. Pode ser possível ajustar a velocidade da sonda e/ou a altura inicial da sonda para melhorar a repetibilidade da sonda. O comando `PROBE_ACCURACY` permite executar testes com parâmetros diferentes para ver seu impacto - consulte o [G-Codes document](G-Codes.md#probe_accuracy) para obter mais detalhes. Se a sonda geralmente obtém resultados repetíveis, mas tem um problema ocasional, pode ser possível contabilizar isso usando várias amostras em cada sonda - leia a descrição dos parâmetros de configuração `samples` da sonda na [config reference](Config_Reference.md#probe) para mais detalhes.

If new probe speed, samples count, or other settings are needed, then update the printer.cfg file and issue a `RESTART` command. If so, it is a good idea to [calibrate the z_offset](#calibrating-probe-z-offset) again. If repeatable results can not be obtained then don't use the probe for bed leveling. Klipper has several manual probing tools that can be used instead - see the [Bed Level document](Bed_Level.md) for further details.

## Location Bias Check

Some probes can have a systemic bias that corrupts the results of the probe at certain toolhead locations. For example, if the probe mount tilts slightly when moving along the Y axis then it could result in the probe reporting biased results at different Y positions.

This is a common issue with probes on delta printers, however it can occur on all printers.

One can check for a location bias by using the `PROBE_CALIBRATE` command to measuring the probe z_offset at various X and Y locations. Ideally, the probe z_offset would be a constant value at every printer location.

For delta printers, try measuring the z_offset at a position near the A tower, at a position near the B tower, and at a position near the C tower. For cartesian, corexy, and similar printers, try measuring the z_offset at positions near the four corners of the bed.

Before starting this test, first calibrate the probe X, Y, and Z offsets as described at the beginning of this document. Then home the printer and navigate to the first XY position. Follow the steps at [calibrating probe Z offset](#calibrating-probe-z-offset) to run the `PROBE_CALIBRATE` command, `TESTZ` commands, and `ACCEPT` command, but do not run `SAVE_CONFIG`. Note the reported z_offset found. Then navigate to the other XY positions, repeat these `PROBE_CALIBRATE` steps, and note the reported z_offset.

If the difference between the minimum reported z_offset and the maximum reported z_offset is greater than 25 microns (.025mm) then the probe is not suitable for typical bed leveling procedures. See the [Bed Level document](Bed_Level.md) for manual probe alternatives.

## Temperature Bias

Many probes have a systemic bias when probing at different temperatures. For example, the probe may consistently trigger at a lower height when the probe is at a higher temperature.

It is recommended to run the bed leveling tools at a consistent temperature to account for this bias. For example, either always run the tools when the printer is at room temperature, or always run the tools after the printer has obtained a consistent print temperature. In either case, it is a good idea to wait several minutes after the desired temperature is reached, so that the printer apparatus is consistently at the desired temperature.

To check for a temperature bias, start with the printer at room temperature and then home the printer, move the head to a position near the center of the bed, and run the `PROBE_ACCURACY` command. Note the results. Then, without homing or disabling the stepper motors, heat the printer nozzle and bed to printing temperature, and run the `PROBE_ACCURACY` command again. Ideally, the command will report identical results. As above, if the probe does have a temperature bias then be careful to always use the probe at a consistent temperature.
