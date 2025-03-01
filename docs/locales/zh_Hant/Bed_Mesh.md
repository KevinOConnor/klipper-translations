# 床網

The Bed Mesh module may be used to compensate for bed surface irregularities to achieve a better first layer across the entire bed. It should be noted that software based correction will not achieve perfect results, it can only approximate the shape of the bed. Bed Mesh also cannot compensate for mechanical and electrical issues. If an axis is skewed or a probe is not accurate then the bed_mesh module will not receive accurate results from the probing process.

在進行網格校準之前，需要先校準探針的 Z 偏移。如果使用限位開關進行Z軸定位，也需要對其進行校準。請參閱[探針校準](Probe_Calibrate.md)和[手動調平](Manual_Level.md)中的 Z_ENDSTOP_CALIBRATE 獲取更多資訊。

## 基本配置

### 矩形床

此示例假定印表機具有 250 mm x 220 mm 矩形床和一個 x 偏移為 24 mm和 y 偏移為 5 mm的探針。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `speed: 120` *預設值：50* 探針在兩個點之間移動的速度。
- `horizontal_move_z: 5` *預設值：5* 探針前往下一個點之前Z需要抬升的高度。
- `mesh_min: 35,6` *（必須存在）*第一個探測的座標，距離原點最近。該座標就是探針所在的位置。
- `mesh_max: 240, 198` *Required* The probed coordinate farthest from the origin. This is not necessarily the last point probed, as the probing process occurs in a zig-zag fashion. As with `mesh_min`, this coordinate is relative to the probe's location.
- `probe_count: 5, 3` *預設值：3, 3* 每個軸上要探測的點數，指定為 X, Y 整數值。 在本示例中，將沿 X 軸探測 5 個點，沿 Y 軸探測 3 個點，總共探測 15 個點。 請注意，如果您想要一個方形網格，例如 3x3，可以將指定其為一個整數值，比如 `probe_count: 3`。 請注意，網格需要沿每個軸的最小 probe_count 為3。

下圖演示瞭如何使用 `mesh_min`、`mesh_max` 和 `probe_count` 選項來產生探測點。 箭頭表示探測過程的運動方向，從「mesh_min」開始。 圖中所示，當探針位於「mesh_min」時，噴嘴將位於 (11, 1)，當探針位於「mesh_max」時，噴嘴將位於 (206, 193)。

![矩形網床基本配置](img/bedmesh_rect_basic.svg)

### 圓形床

本示例假設印表機配備的圓床半徑為 100 mm。 我們將使用與矩形網床示例相同的探針偏移來演示，X 偏移為 24 mm，Y 偏移為 5 mm。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *必須配置* 探測網格範圍的半徑（以毫米為單位），相對於 `mesh_origin`。 請注意，探針的偏移會限制網格半徑的大小。 在此示例中，大於 76 mm的半徑會將列印頭移動到印表機的範圍之外。
- `mesh_origin: 0, 0` *預設值：0, 0* 探測網格的中心點。 該座標相對於探針的位置。 雖然預設值為 0,0，但如果希望探測床的邊角可以修改該值。 請參閱下圖。
- `round_probe_count: 5` *預設值： 5* 這是一個整數值，用於限制沿 X 軸和 Y 軸的最大探測點數。 「最大」是指沿網格原點探測的點數。 該值必須是奇數，因為需要探測網格的中心。

The illustration below shows how the probed points are generated. As you can see, setting the `mesh_origin` to (-10, 0) allows us to specify a larger mesh radius of 85.

![圓形網床基本配置](img/bedmesh_round_basic.svg)

## 高級配置

下面詳細解釋了更高級的配置選項。 每個示例都將建立在上面顯示的基本矩形床配置之上。 每個高級選項都以相同的方式應用於圓床。

### 網格插值

While its possible to sample the probed matrix directly using simple bi-linear interpolation to determine the Z-Values between probed points, it is often useful to interpolate extra points using more advanced interpolation algorithms to increase mesh density. These algorithms add curvature to the mesh, attempting to simulate the material properties of the bed. Bed Mesh offers lagrange and bicubic interpolation to accomplish this.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
mesh_pps: 2, 3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps: 2,3` *預設值：2,2*`mesh_pps` 選項是每段的網格點數的簡寫。 此選項指定沿 x 軸和 y 軸為每個線段插值的點數。 「段」被視為每個探測點之間的間隔。 與 `probe_count` 一樣，`mesh_pps` 可以是 X, Y 整數對，也可以是同時應用於兩個軸的單個整數。 在此示例中，沿 X 軸有 4 個線段，沿 Y 軸有 2 個線段。 這計算為沿 X 的 8 個插值點，沿 Y 的 6 個插值點，從而產生 13x8 網格。 請注意，如果 mesh_pps 設定為 0，則禁用網格插值，並且將直接對探測網格進行採樣。
- `algorithm: lagrange` *預設值：lagrange* 用於插入網格的演算法。 可能是 `lagrange` or `bicubic`。 拉格朗日插值最多為 6 個探測點，因為大量樣本容易發生振盪。 雙三次插值要求沿每個軸至少有 4 個探測點，如果指定的點少於 4 個，則強制拉格朗日採樣。 如果 `mesh_pps` 設定為 0，則該值將被忽略，因為沒有進行網格插值。
- `bicubic_tension: 0.2` *預設值：0.2* 雙三次插值的張力值。如果`algorithm` 選項設定為雙三次，則可以指定張力值。 張力越高，內插的斜率越大。 調整時要小心，因為較高的值也會產生更多的過沖，這將導致插值高於或低於探測點。

下圖顯示瞭如何使用上述選項產生網格插值。

![網床插值](img/bedmesh_interpolated.svg)

### 移動拆分

床網的工作原理是攔截 G 程式碼移動命令並對其 Z 座標進行變換。長的移動必須被分割成較小的移動以正確地遵循床的形狀。下面的選項可以控制分割的行為。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance: 5` *預設值：5* 在執行拆分之前檢查 Z 中需要變化的最小距離。 在此示例中，演算法將遍歷超過 5 毫米的移動。 每 5mm 將查詢一次網格的Z ，並將其與前一次移動的 Z 值進行比較。 如果三角洲滿足 `split_delta_z` 設定的閾值，則移動將被拆分並繼續遍歷。 重複此過程，直到到達移動結束處，在此將應用最終調整。 比 `move_check_distance` 短的移動將正確的 Z 調整直接應用於移動，無需遍歷或拆分。
- `split_delta_z: .025` *預設值：.025* 如上所述，這是觸發移動拆分所需的最小偏差。 在上面的示例中，任何偏差為 +/- .025 mm的 Z 值都將觸發拆分。

Generally the default values for these options are sufficient, in fact the default value of 5mm for the `move_check_distance` may be overkill. However an advanced user may wish to experiment with these options in an effort to squeeze out the optimal first layer.

### 網格淡出

啟用「網格淡出」后，Z 軸的調整將在配置中定義的距離範圍內逐步消失。 這是通過對層高進行小幅調整來實現的，根據床的形狀增加或減少。 網格淡出完成後，不再使用 Z 調整，使列印的表面是平坦的而不是床彎曲的形狀。 網格淡出也可能會產生一些不良表現，如果網格淡出過快，可能會導致列印件上出現可見的瑕疵（偽影）。 此外，如果您的床明顯變形，網格淡出會縮小或拉伸列印件的 Z 高度。 因此，預設情況下禁用網格淡出。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1` *預設值：1* 開始網格淡出的值，在設定的fade_start值之後逐步停止調整Z的高度。 建議在列印幾層之後再開始淡出層高。
- `fade_end: 10` *預設值：0* 網格淡出完成的 Z 高度。 如果此值低於`fade_start`，則禁用網格淡出。 該值可以根據列印表面的彎曲程度進行調整。 明顯彎曲的表面應該在將網格淡出的距離長。 接近平坦的表面可能能夠降低該值以更快地逐步淘汰。 如果對 `fade_start` 使用預設值 1，則 10mm 是一個合理的值。
- `fade_target: 0` *Default Value: The average Z value of the mesh* The `fade_target` can be thought of as an additional Z offset applied to the entire bed after fade completes. Generally speaking we would like this value to be 0, however there are circumstances where it should not be. For example, lets assume your homing position on the bed is an outlier, its .2 mm lower than the average probed height of the bed. If the `fade_target` is 0, fade will shrink the print by an average of .2 mm across the bed. By setting the `fade_target` to .2, the homed area will expand by .2 mm, however, the rest of the bed will be accurately sized. Generally its a good idea to leave `fade_target` out of the configuration so the average height of the mesh is used, however it may be desirable to manually adjust the fade target if one wants to print on a specific portion of the bed.

### Configuring the zero reference position

Many probes are susceptible to "drift", ie: inaccuracies in probing introduced by heat or interference. This can make calculating the probe's z-offset challenging, particularly at different bed temperatures. As such, some printers use an endstop for homing the Z axis and a probe for calibrating the mesh. In this configuration it is possible offset the mesh so that the (X, Y) `reference position` applies zero adjustment. The `reference postion` should be the location on the bed where a [Z_ENDSTOP_CALIBRATE](./Manual_Level.md#calibrating-a-z-endstop) paper test is performed. The bed_mesh module provides the `zero_reference_position` option for specifying this coordinate:

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
zero_reference_position: 125, 110
probe_count: 5, 3
```

- `zero_reference_position: ` *Default Value: None (disabled)* The `zero_reference_position` expects an (X, Y) coordinate matching that of the `reference position` described above. If the coordinate lies within the mesh then the mesh will be offset so the reference position applies zero adjustment. If the coordinate lies outside of the mesh then the coordinate will be probed after calibration, with the resulting z-value used as the z-offset. Note that this coordinate must NOT be in a location specified as a `faulty_region` if a probe is necessary.

#### The deprecated relative_reference_index

Existing configurations using the `relative_reference_index` option must be updated to use the `zero_reference_position`. The response to the [BED_MESH_OUTPUT PGP=1](#output) gcode command will include the (X, Y) coordinate associated with the index; this position may be used as the value for the `zero_reference_position`. The output will look similar to the following:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (1.0, 1.0) | (24.0, 6.0)
// 1 | (36.7, 1.0) | (59.7, 6.0)
// 2 | (72.3, 1.0) | (95.3, 6.0)
// 3 | (108.0, 1.0) | (131.0, 6.0)
... (additional generated points)
// bed_mesh: relative_reference_index 24 is (131.5, 108.0)
```

*Note: The above output is also printed in `klippy.log` during initialization.*

Using the example above we see that the `relative_reference_index` is printed along with its coordinate. Thus the `zero_reference_position` is `131.5, 108`.

### 故障區域

由於特定位置的「故障」，熱床的某些區域在探測時可能會報告不準確的結果。 最好的例子是帶有用彈簧鋼板的磁鐵熱床。 這些磁鐵處和周圍的磁場可能干擾探針觸發的高度，從而導致網格無法準確表示這些位置的表面。 **注意：不要與探頭位置偏差導致探測結果不準確的結果混淆。**

可以配置 `faulty_region` 選項來避免這種影響。 如果產生的點位於故障區域內，熱床網格將嘗試在該區域的邊界處探測最多 4 個點。 這些探測的平均值將插入網床中作為產生的 (X, Y) 座標處的 Z 值。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min` `faulty_region_{1...99}_max` *預設值：None （無）(disabled（禁用）)* 故障區域的定義方式類似床網本身，必須為每個區域指定最小和最大（X, Y）座標。一個故障區域可以延伸到網格之外，但是產生的替代探測點總是在網格的邊界內。兩個區域不可以重疊。

下面的圖片說明了當一個產生的探測點位於一個故障區域內時，如何產生替代探測點。所顯示的區域與上述樣本配置中的區域一致。替代點和它們的座標以綠色標識。

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

### Adaptive Meshes

Adaptive bed meshing is a way to speed up the bed mesh generation by only probing the area of the bed used by the objects being printed. When used, the method will automatically adjust the mesh parameters based on the area occupied by the defined print objects.

The adapted mesh area will be computed from the area defined by the boundaries of all the defined print objects so it covers every object, including any margins defined in the configuration. After the area is computed, the number of probe points will be scaled down based on the ratio of the default mesh area and the adapted mesh area. To illustrate this consider the following example:

For a 150mmx150mm bed with `mesh_min` set to `25,25` and `mesh_max` set to `125,125`, the default mesh area is a 100mmx100mm square. An adapted mesh area of `50,50` means a ratio of `0.5x0.5` between the adapted area and default mesh area.

If the `bed_mesh` configuration specified `probe_count` as `7x7`, the adapted bed mesh will use 4x4 probe points (7 * 0.5 rounded up).

![adaptive_bedmesh](img/adaptive_bed_mesh.svg)

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
adaptive_margin: 5
```

- `adaptive_margin`  *Default Value: 0*  Margin (in mm) to add around the area of the bed used by the defined objects. The diagram below shows the adapted bed mesh area with an `adaptive_margin` of 5mm. The adapted mesh area (area in green) is computed as the used bed area (area in blue) plus the defined margin.

   ![adaptive_bedmesh_margin](img/adaptive_bed_mesh_margin.svg)

By nature, adaptive bed meshes use the objects defined by the Gcode file being printed. Therefore, it is expected that each Gcode file will generate a mesh that probes a different area of the print bed. Therefore, adapted bed meshes should not be re-used. The expectation is that a new mesh will be generated for each print if adaptive meshing is used.

It is also important to consider that adaptive bed meshing is best used on machines that can normally probe the entire bed and achieve a maximum variance less than or equal to 1 layer height. Machines with mechanical issues that a full bed mesh normally compensates for may have undesirable results when attempting print moves **outside** of the probed area. If a full bed mesh has a variance greater than 1 layer height, caution must be taken when using adaptive bed meshes and attempting print moves outside of the meshed area.

## Surface Scans

Some probes, such as the [Eddy Current Probe](./Eddy_Probe.md), are capable of "scanning" the surface of the bed. That is, these probes can sample a mesh without lifting the tool between samples. To activate scanning mode, the `METHOD=scan` or `METHOD=rapid_scan` probe parameter should be passed in the `BED_MESH_CALIBRATE` gcode command.

### Scan Height

The scan height is set by the `horizontal_move_z` option in `[bed_mesh]`. In addition it can be supplied with the `BED_MESH_CALIBRATE` gcode command via the `HORIZONTAL_MOVE_Z` parameter.

The scan height must be sufficiently low to avoid scanning errors. Typically a height of 2mm (ie: `HORIZONTAL_MOVE_Z=2`) should work well, presuming that the probe is mounted correctly.

It should be noted that if the probe is more than 4mm above the surface then the results will be invalid. Thus, scanning is not possible on beds with severe surface deviation or beds with extreme tilt that hasn't been corrected.

### Rapid (Continuous) Scanning

When performing a `rapid_scan` one should keep in mind that the results will have some amount of error. This error should be low enough to be useful on large print areas with reasonably thick layer heights. Some probes may be more prone to error than others.

It is not recommended that rapid mode be used to scan a "dense" mesh. Some of the error introduced during a rapid scan may be gaussian noise from the sensor, and a dense mesh will reflect this noise (ie: there will be peaks and valleys).

Bed Mesh will attempt to optimize the travel path to provide the best possible result based on the configuration. This includes avoiding faulty regions when collecting samples and "overshooting" the mesh when changing direction. This overshoot improves sampling at the edges of a mesh, however it requires that the mesh be configured in a way that allows the tool to travel outside of the mesh.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5
scan_overshoot: 8
```

- `scan_overshoot` *Default Value: 0 (disabled)* The maximum amount of travel (in mm) available outside of the mesh. For rectangular beds this applies to travel on the X axis, and for round beds it applies to the entire radius. The tool must be able to travel the amount specified outside of the mesh. This value is used to optimize the travel path when performing a "rapid scan". The minimum value that may be specified is 1. The default is no overshoot.

If no scan overshoot is configured then travel path optimization will not be applied to changes in direction.

## 床網 G程式碼

### 校準

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic | scan | rapid_scan] \ [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] \ [ADAPTIVE_MARGIN=<value>]` *Default Profile: default* *Default Method: automatic if a probe is detected, otherwise manual*  *Default Adaptive: 0*  *Default Adaptive Margin: 0*

啟動床網校準的探測程式。

The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. The `METHOD` parameter takes one of the following values:

- `METHOD=manual`: enables manual probing using the nozzle and the paper test
- `METHOD=automatic`: Automatic (standard) probing. This is the default.
- `METHOD=scan`: Enables surface scanning. The tool will pause over each position to collect a sample.
- `METHOD=rapid_scan`: Enables continuous surface scanning.

XY positions are automatically adjusted to include the X and/or Y offsets when a probing method other than `manual` is selected.

可以通過指定網格參數來修改探測區域。以下參數可用：

- 矩形列印床（笛卡爾 Cartesian）：
   - `MESH_MIN`
   - `MESH_MAX`
   - `PROBE_COUNT`
- 圓形列印床（三角洲 delta）：
   - `MESH_RADIUS`
   - `MESH_ORIGIN`
   - `ROUND_PROBE_COUNT`
- 全部列印床：
   - `MESH_PPS`
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

有關在網格中使用的配置參數詳見配置文件。

### 配置

`BED_MESH_PROFILE SAVE=<名稱> LOAD=<名稱> REMOVE=<名稱>`

在執行 BED_MESH_CALIBRATE 后，可以將目前網格狀態儲存到一個命名的配置中。這樣不需要重新探測列印床就可以載入一個網格。在使用`BED_MESH_PROFILE SAVE=<名稱>`儲存了一個配置檔案后，可以執行`SAVE_CONFIG` G程式碼將配置寫入 printer.cfg。

可以通過執行 `BED_MESH_PROFILE LOAD=<名稱>` 來載入配置。

It should be noted that each time a BED_MESH_CALIBRATE occurs, the current state is automatically saved to the *default* profile. The *default* profile can be removed as follows:

`BED_MESH_PROFILE REMOVE=default`

任何其他儲存的配置也可以用相同的方式刪除，用你想刪除的配置名稱替換*default*。

#### Loading the default profile

Previous versions of `bed_mesh` always loaded the profile named *default* on startup if it was present. This behavior has been removed in favor of allowing the user to determine when a profile is loaded. If a user wishes to load the `default` profile it is recommended to add `BED_MESH_PROFILE LOAD=default` to either their `START_PRINT` macro or their slicer's "Start G-Code" configuration, whichever is applicable.

Alternatively the old behavior of loading a profile at startup can be restored with a `[delayed_gcode]`:

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### 輸出

`BED_MESH_OUTPUT PGP=[0 | 1]`

將目前網格狀態輸出到終端。請注意，輸出的是網格本身

PGP 參數是「列印產生的點」的簡寫。如果設定了`PGP=1`，產生的探測點將輸出到終端：

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

"Tool Adjusted"（工具調整）點指每個點的噴嘴位置，"Probe"（探針）點指探頭位置。請注意，手動探測時"Probe"（探針）點時將同時指工具和噴嘴位置。

### 清除網格狀態

`BED_MESH_CLEAR`

此 gcode 可用於清除內部網格狀態。

### 應用X/Y偏移量

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

This is useful for printers with multiple independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Offsets should be specified relative to the primary extruder. That is, a positive X offset should be specified if the secondary extruder is mounted to the right of the primary extruder, a positive Y offset should be specified if the secondary extruder is mounted "behind" the primary extruder, and a positive ZFADE offset should be specified if the secondary extruder's nozzle is above the primary extruder's.

Note that a ZFADE offset does *NOT* directly apply additional adjustment. It is intended to compensate for a `gcode offset` when [mesh fade](#mesh-fade) is enabled. For example, if a secondary extruder is higher than the primary and needs a negative gcode offset, ie: `SET_GCODE_OFFSET Z=-.2`, it can be accounted for in `bed_mesh` with `BED_MESH_OFFSET ZFADE=.2`.

## Bed Mesh Webhooks APIs

### Dumping mesh data

`{"id": 123, "method": "bed_mesh/dump_mesh"}`

Dumps the configuration and state for the current mesh and all saved profiles.

The `dump_mesh` endpoint takes one optional parameter, `mesh_args`. This parameter must be an object, where the keys and values are parameters available to [BED_MESH_CALIBRATE](#bed_mesh_calibrate). This will update the mesh configuration and probe points using the supplied parameters prior to returning the result. It is recommended to omit mesh parameters unless it is desired to visualize the probe points and/or travel path before performing `BED_MESH_CALIBRATE`.

## Visualization and analysis

Most users will likely find that the visualizers included with applications such as Mainsail, Fluidd, and Octoprint are sufficient for basic analysis. However, Klipper's `scripts` folder contains the `graph_mesh.py` script that may be used to perform additional visualizations and more detailed analysis, particularly useful for debugging hardware or the results produced by `bed_mesh`:

```
usage: graph_mesh.py [-h] {list,plot,analyze,dump} ...

Graph Bed Mesh Data

positional arguments:
  {list,plot,analyze,dump}
    list                List available plot types
    plot                Plot a specified type
    analyze             Perform analysis on mesh data
    dump                Dump API response to json file

options:
  -h, --help            show this help message and exit
```

### Pre-requisites

Like most graphing tools provided by Klipper, `graph_mesh.py` requires the `matplotlib` and `numpy` python dependencies. In addition, connecting to Klipper via Moonraker's websocket requires the `websockets` python dependency. While all visualizations can be output to an `svg` file, most of the visualizations offered by `graph_mesh.py` are better viewed in live preview mode on a desktop class PC. For example, the 3D visualizations may be rotated and zoomed in preview mode, and the path visualizations can optionally be animated in preview mode.

### Plotting Mesh data

The `graph_mesh.py` tool can plot several types of visualizations. Available types can be shown by running `graph_mesh.py list`:

```
graph_mesh.py list
points    Plot original generated points
path      Plot probe travel path
rapid     Plot rapid scan travel path
probedz   Plot probed Z values
meshz     Plot mesh Z values
overlay   Plots the current probed mesh overlaid with a profile
delta     Plots the delta between current probed mesh and a profile
```

Several options are available when plotting visualizations:

```
usage: graph_mesh.py plot [-h] [-a] [-s] [-p PROFILE_NAME] [-o OUTPUT] <plot type> <input>

positional arguments:
  <plot type>           Type of data to graph
  <input>               Path/url to Klipper Socket or path to json file

options:
  -h, --help            show this help message and exit
  -a, --animate         Animate paths in live preview
  -s, --scale-plot      Use axis limits reported by Klipper to scale plot X/Y
  -p PROFILE_NAME, --profile-name PROFILE_NAME
                        Optional name of a profile to plot for 'probedz'
  -o OUTPUT, --output OUTPUT
                        Output file path
```

Below is a description of each argument:

- `plot type`: A required positional argument designating the type of visualization to generate. Must be one of the types output by the `graph_mesh.py list` command.
- `input`: A required positional argument containing a path or url to the input source. This must be one of the following:
   - A path to Klipper's Unix Domain Socket
   - A url to an instance of Moonraker
   - A path to a json file produced by `graph_mesh.py dump <input>`
- `-a`: Optional animation for the `path` and `rapid` visualization types. Animations only apply to a live preview.
- `-s`: Optionally scales a plot using the `axis_minimum` and `axis_maximum` values reported by Klipper's `toolhead` object when the dump file was generated.
- `-p`: A profile name that may be specified when generating the `probedz` 3D mesh visualization. When generating an `overlay` or `delta` visualization this argument must be provided.
- `-o`: An optional file path indicating that the script should save the visualization to this location rather than run in preview mode. Images are saved in `svg` format.

For example, to plot an animated rapid path, connecting via Klipper's unix socket:

```
graph_mesh.py plot -a rapid ~/printer_data/comms/klippy.sock
```

Or to plot a 3d visualization of the mesh, connecting via Moonraker:

```
graph_mesh.py plot meshz http://my-printer.local
```

### Bed Mesh Analysis

The `graph_mesh.py` tool may also be used to perform an analysis on the data provided by the [bed_mesh/dump_mesh](#dumping-mesh-data) API:

```
graph_mesh.py analyze <input>
```

As with the `plot` command, the `<input>` must be a path to Klipper's unix socket, a URL to an instance of Moonraker, or a path to a json file generated by the dump command.

To begin, the analysis will perform various checks on the points and probe paths generated by `bed_mesh` at the time of the dump. This includes the following:

- The number of probe points generated, without any additions
- The number of probe points generated including any points generated as the result faulty regions and/or a configured zero reference position.
- The number of probe points generated when performing a rapid scan.
- The total number of moves generated for a rapid scan.
- A validation that the probe points generated for a rapid scan are identical to the probe points generated for a standard probing procedure.
- A "backtracking" check for both the standard probe path and a rapid scan path. Backtracking can be defined as moving to the same position more than once during the probing procedure. Backtracking should never occur during a standard probe. Faulty regions *can* result in backtracking during a rapid scan in an attempt to avoid entering a faulty region when approaching or leaving a probe location, however should never occur otherwise.

Next each probed mesh present in the dump will by analyzed, beginning with the mesh loaded at the time of the dump (if present) and followed by any saved profiles. The following data is extracted:

- Mesh shape (Min X,Y, Max X,Y Probe Count)
- Mesh Z range, (Minimum Z, Maximum Z)
- Mean Z value in the mesh
- Standard Deviation of the Z values in the Mesh

In addition to the above, a delta analysis is performed between meshes with the same shape, reporting the following:

- The range of the delta between to meshes (Minimum and Maximum)
- The mean delta
- Standard Deviation of the delta
- The absolute maximum difference
- The absolute mean

### Save mesh data to a file

The `dump` command may be used to save the response to a file which can be shared for analysis when troubleshooting:

```
graph_mesh.py dump -o <output file name> <input>
```

The `<input>` should be a path to Klipper's unix socket or a URL to an instance of Moonraker. The `-o` option may be used to specify the path to the output file. If omitted, the file will be saved in the working directory, with a file name in the following format:

`klipper-bedmesh-{year}{month}{day}{hour}{minute}{second}.json`
