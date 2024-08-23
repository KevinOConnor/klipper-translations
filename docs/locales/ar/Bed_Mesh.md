# شبكة سطح الطباعة

The Bed Mesh module may be used to compensate for bed surface irregularities to achieve a better first layer across the entire bed. It should be noted that software based correction will not achieve perfect results, it can only approximate the shape of the bed. Bed Mesh also cannot compensate for mechanical and electrical issues. If an axis is skewed or a probe is not accurate then the bed_mesh module will not receive accurate results from the probing process.

Prior to Mesh Calibration you will need to be sure that your Probe's Z-Offset is calibrated. If using an endstop for Z homing it will need to be calibrated as well. See [Probe Calibrate](Probe_Calibrate.md) and Z_ENDSTOP_CALIBRATE in [Manual Level](Manual_Level.md) for more information.

## التكوين الأساسي

### سطح مستطيلة

يفترض هذا المثال طابعة ذات سرير مستطيل 250 مم × 220 مم ومسبار مع إزاحة x 24 مم وإزاحة y 5 مم.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35, 6
mesh_max: 240, 198
probe_count: 5, 3
```

- `السرعة: 120` *القيمة الافتراضية: 50* السرعة التي تتحرك بها الأداة بين النقاط.
- `horizontal_move_z: 5` *القيمة الافتراضية: 5* تنسيق Z الذي يرتفع إليه المسبار قبل السفر بين النقاط.
- `mesh_min: 35, 6` *Required* The first probed coordinate, nearest to the origin. This coordinate is relative to the probe's location.
- `mesh_max: 240, 198` *Required* The probed coordinate farthest farthest from the origin. This is not necessarily the last point probed, as the probing process occurs in a zig-zag fashion. As with `mesh_min`, this coordinate is relative to the probe's location.
- `probe_count: 5, 3` *Default Value: 3, 3* The number of points to probe on each axis, specified as X, Y integer values. In this example 5 points will be probed along the X axis, with 3 points along the Y axis, for a total of 15 probed points. Note that if you wanted a square grid, for example 3x3, this could be specified as a single integer value that is used for both axes, ie `probe_count: 3`. Note that a mesh requires a minimum probe_count of 3 along each axis.

يوضح الرسم التوضيحي أدناه كيفية استخدام خيارات `mesh_min` و`mesh_max` و`probe_count` لتوليد نقاط التحقيق. تشير الأسهم إلى اتجاه إجراء التحقيق، بدءا من "mesh_min". كمرجع، عندما يكون المسبار في "mesh_min" ستكون الفوهة في (11، 1)، وعندما يكون المسبار في "mesh_max"، ستكون الفوهة عند (206، 193).

![bedmesh_rect_basic](img/bedmesh_rect_basic.svg)

### سطح مستديرة

يفترض هذا المثال طابعة مجهزة بنصف قطر سرير دائري يبلغ 100 مم. سنستخدم نفس إزاحات المسبار مثل المثال المستطيل، 24 مم على X و5 مم على Y.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0, 0
round_probe_count: 5
```

- `mesh_radius: 75` *مطلوب* نصف قطر الشبكة المدققة بالملليمتر، بالنسبة إلى `mesh_origin`. لاحظ أن إزاحات المسبار تحد من حجم نصف قطر الشبكة. في هذا المثال، من شأن نصف قطر أكبر من 76 أن ينقل الأداة إلى ما وراء نطاق الطابعة.
- `mesh_origin: 0, 0` *Default Value: 0, 0* The center point of the mesh. This coordinate is relative to the probe's location. While the default is 0, 0, it may be useful to adjust the origin in an effort to probe a larger portion of the bed. See the illustration below.
- `round_probe_count: 5` *القيمة الافتراضية: 5* هذه قيمة صحيحة تحدد الحد الأقصى لعدد النقاط المحققة على طول المحورين X وY. نعني ب "الحد الأقصى" عدد النقاط التي تم التحقيق فيها على طول أصل الشبكة. يجب أن تكون هذه القيمة رقما فرديا، حيث أنه مطلوب أن يتم فحص مركز الشبكة.

The illustration below shows how the probed points are generated. As you can see, setting the `mesh_origin` to (-10, 0) allows us to specify a larger mesh radius of 85.

![bedmesh_round_basic](img/bedmesh_round_basic.svg)

## التكوين المتقدم

Below the more advanced configuration options are explained in detail. Each example will build upon the basic rectangular bed configuration shown above. Each of the advanced options apply to round beds in the same manner.

### Mesh Interpolation

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

- `mesh_pps: 2, 3` *Default Value: 2, 2* The `mesh_pps` option is shorthand for Mesh Points Per Segment. This option specifies how many points to interpolate for each segment along the X and Y axes. Consider a 'segment' to be the space between each probed point. Like `probe_count`, `mesh_pps` is specified as an X, Y integer pair, and also may be specified a single integer that is applied to both axes. In this example there are 4 segments along the X axis and 2 segments along the Y axis. This evaluates to 8 interpolated points along X, 6 interpolated points along Y, which results in a 13x8 mesh. Note that if mesh_pps is set to 0 then mesh interpolation is disabled and the probed matrix will be sampled directly.
- `algorithm: lagrange` *Default Value: lagrange* The algorithm used to interpolate the mesh. May be `lagrange` or `bicubic`. Lagrange interpolation is capped at 6 probed points as oscillation tends to occur with a larger number of samples. Bicubic interpolation requires a minimum of 4 probed points along each axis, if less than 4 points are specified then lagrange sampling is forced. If `mesh_pps` is set to 0 then this value is ignored as no mesh interpolation is done.
- `bicubic_tension: 0.2` *Default Value: 0.2* If the `algorithm` option is set to bicubic it is possible to specify the tension value. The higher the tension the more slope is interpolated. Be careful when adjusting this, as higher values also create more overshoot, which will result in interpolated values higher or lower than your probed points.

يوضح الرسم التوضيحي أدناه كيفية استخدام الخيارات المذكورة أعلاه لإنشاء شبكة محرفة.

![bedmesh_interpolated](img/bedmesh_interpolated.svg)

### نقل الانقسام

Bed Mesh works by intercepting gcode move commands and applying a transform to their Z coordinate. Long moves must be split into smaller moves to correctly follow the shape of the bed. The options below control the splitting behavior.

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

- `move_check_distance: 5` *القيمة الافتراضية: 5* الحد الأدنى للمسافة للتحقق من التغيير المطلوب في Z قبل إجراء الانقسام. في هذا المثال، سيتم اجتياز خطوة أطول من 5 مم بواسطة الخوارزمية. سيحدث كل 5 مم بحث شبكة Z، ومقارنته بقيمة Z للخطوة السابقة. إذا استوفت الدلتا العتبة التي حددها "split_delta_z"، فسيتم تقسيم الحركة وسيستمر العبور. تتكرر هذه العملية حتى يتم الوصول إلى نهاية الخطوة، حيث سيتم تطبيق تعديل نهائي. التحركات الأقصر من "move_check_distance" لها تعديل Z الصحيح المطبق مباشرة على الحركة دون اجتياز أو تقسيم.
- `split_delta_z: .025` *القيمة الافتراضية: .025* كما ذكر أعلاه، هذا هو الحد الأدنى للانحراف المطلوب لتحريك تقسيم الحركة. في هذا المثال، أي قيمة Z مع انحراف +/- .025mm ستتسبب الانقسام.

Generally the default values for these options are sufficient, in fact the default value of 5mm for the `move_check_distance` may be overkill. However an advanced user may wish to experiment with these options in an effort to squeeze out the optimal first layer.

### شبكة تتلاشى

عند تمكين "التلاشي" يتم التخلص التدريجي من تعديل Z على مسافة يحددها التكوين. يتم تحقيق ذلك من خلال تطبيق تعديلات صغيرة على ارتفاع الطبقة، إما زيادة أو تناقص اعتمادا على شكل السرير. عند اكتمال التلاشي، لم يعد يتم تطبيق تعديل Z، مما يسمح للجزء العلوي من الطباعة أن يكون مسطحا بدلا من عكس شكل السرير. قد يكون للتلاشي أيضا بعض السمات غير المرغوب فيها، إذا تلاشى بسرعة كبيرة، فقد يؤدي ذلك إلى قطع أثرية مرئية على الطباعة. أيضا، إذا كان سريرك مشوها بشكل كبير، فإن التلاشي يمكن أن يتقلص أو يمتد ارتفاع الطباعة Z. على هذا النحو، يتم تعطيل التلاشي افتراضيا.

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

- `fade_start: 1` *القيمة الافتراضية: 1* الارتفاع Z الذي يبدأ فيه التخلص التدريجي من التعديل. من الجيد خفض بضع طبقات قبل بدء عملية التلاشي.
- `fade_end: 10` *القيمة الافتراضية: 0* يجب أن يكتمل الارتفاع Z الذي يجب أن يتلاشى فيه. إذا كانت هذه القيمة أقل من "fade_start"، فسيتم تعطيل fade. يمكن تعديل هذه القيمة اعتمادا على مدى تشوه سطح الطباعة. يجب أن يتلاشى السطح المشوه بشكل كبير على مسافة أطول. قد يكون السطح المسطح القريب قادرا على تقليل هذه القيمة للتخلص التدريجي بسرعة أكبر. 10 مم هي قيمة عاقلة للبدء بها إذا كنت تستخدم القيمة الافتراضية 1 ل "fade_start".
- `fade_target: 0` *Default Value: The average Z value of the mesh* The `fade_target` can be thought of as an additional Z offset applied to the entire bed after fade completes. Generally speaking we would like this value to be 0, however there are circumstances where it should not be. For example, lets assume your homing position on the bed is an outlier, its .2 mm lower than the average probed height of the bed. If the `fade_target` is 0, fade will shrink the print by an average of .2 mm across the bed. By setting the `fade_target` to .2, the homed area will expand by .2 mm, however, the rest of the bed will be accurately sized. Generally its a good idea to leave `fade_target` out of the configuration so the average height of the mesh is used, however it may be desirable to manually adjust the fade target if one wants to print on a specific portion of the bed.

### Configuring the zero reference position

Many probes are susceptible to "drift", ie: inaccuracies in probing introduced by heat or interference. This can make calculating the probe's z-offset challenging, particularly at different bed temperatures. As such, some printers use an endstop for homing the Z axis and a probe for calibrating the mesh. In this configuration it is possible offset the mesh so that the (X, Y) `reference position` applies zero adjustment. The `reference postion` should be the location on the bed where a [Z_ENDSTOP_CALIBRATE](./Manual_Level#calibrating-a-z-endstop) paper test is performed. The bed_mesh module provides the `zero_reference_position` option for specifying this coordinate:

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

### المناطق المعيبة

من الممكن لبعض مناطق السرير الإبلاغ عن نتائج غير دقيقة عند التحقيق بسبب "خطأ" في مواقع محددة. أفضل مثال على ذلك هو الأسرة مع سلسلة من المغناطيسات المتكاملة المستخدمة للاحتفاظ بألواح الصلب القابلة للإزالة. قد يتسبب المجال المغناطيسي في هذه المغناطيسات وحولها في تشغيل مسبار حثي على مسافة أعلى أو أقل مما كان سيفعله لولا ذلك، مما يؤدي إلى شبكة لا تمثل السطح بدقة في هذه المواقع. **ملاحظة: لا ينبغي الخلط بين هذا وتحيز موقع التحقيق، الذي ينتج نتائج غير دقيقة عبر السرير بأكمله. **

يمكن تكوين خيارات "faulty_region" للتعويض عن هذا التأثير. إذا كانت النقطة المتولدة تقع داخل شبكة سطح الطباعة منطقة معيبة، فستحاول التحقيق في ما يصل إلى 4 نقاط على حدود هذه المنطقة. سيتم حساب متوسط هذه القيم المحققة وإدراجها في الشبكة كقيمة Z عند الإحداثيات المتولدة (X، Y).

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

- `faulty_region_{1...99}_min` `faulty_region_{1..99}_max` *القيمة الافتراضية: لا شيء (معطل)* يتم تعريف المناطق الخاطئة بطريقة مماثلة لتلك الخاصة بالشبكة نفسها، حيث يجب تحديد إحداثيات الحد الأدنى والحد الأقصى (X، Y) لكل منطقة. قد تمتد المنطقة المعيبة خارج الشبكة، ومع ذلك فإن النقاط البديلة المتولدة ستكون دائما داخل حدود الشبكة. لا يجوز أن تتداخل منطقتان.

توضح الصورة أدناه كيفية إنشاء نقاط الاستبدال عندما تقع نقطة تم إنشاؤها داخل منطقة خاطئة. تتطابق المناطق الموضحة مع تلك الموجودة في تكوين العينة أعلاه. يتم تحديد نقاط الاستبدال وإحداثياتها باللون الأخضر.

![ Bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

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

## شبكة السرير Gcodes

### معايرة

`BED_MESH_CALIBRATE PROFILE=<name> METHOD=[manual | automatic] [<probe_parameter>=<value>] [<mesh_parameter>=<value>] [ADAPTIVE=[0|1] [ADAPTIVE_MARGIN=<value>]` *Default Profile: default* *Default Method: automatic if a probe is detected, otherwise manual*  *Default Adaptive: 0*  *Default Adaptive Margin: 0*

Initiates the probing procedure for Bed Mesh Calibration.

The mesh will be saved into a profile specified by the `PROFILE` parameter, or `default` if unspecified. If `METHOD=manual` is selected then manual probing will occur. When switching between automatic and manual probing the generated mesh points will automatically be adjusted.

من الممكن تحديد معلمات الشبكة لتعديل المنطقة المحققة. تتوفر المعايير التالية:

- أسرة مستطيلة (كارتية):
   - `اصغر_الشبكة`
   - `اعلي_ حدود الشبكة`
   - `عدد_الاستشعارات`
- سرير مستدير (دلتا):
   - `نصف_قطر_الشبكة`
   - `أصل_الشبكة`
   - `عدد_الاستشعارات_الدائرية`
- جميع الاسطح:
   - `ALGORITHM`
   - `ADAPTIVE`
   - `ADAPTIVE_MARGIN`

See the configuration documentation above for details on how each parameter applies to the mesh.

### ملفات تعريف

`BED_MESH_PROFILE SAVE=<name> LOAD=<name> REMOVE=<name>`

After a BED_MESH_CALIBRATE has been performed, it is possible to save the current mesh state into a named profile. This makes it possible to load a mesh without re-probing the bed. After a profile has been saved using `BED_MESH_PROFILE SAVE=<name>` the `SAVE_CONFIG` gcode may be executed to write the profile to printer.cfg.

Profiles can be loaded by executing `BED_MESH_PROFILE LOAD=<name>`.

It should be noted that each time a BED_MESH_CALIBRATE occurs, the current state is automatically saved to the *default* profile. The *default* profile can be removed as follows:

`إزالة_ملف_الشبكة_صطح الطباعة = افتراضي`

يمكن إزالة أي ملف تعريف آخر محفوظ بنفس الطريقة، واستبدال *افتراضي* بالملف الشخصي المسمى الذي ترغب في إزالته.

#### Loading the default profile

Previous versions of `bed_mesh` always loaded the profile named *default* on startup if it was present. This behavior has been removed in favor of allowing the user to determine when a profile is loaded. If a user wishes to load the `default` profile it is recommended to add `BED_MESH_PROFILE LOAD=default` to either their `START_PRINT` macro or their slicer's "Start G-Code" configuration, whichever is applicable.

Alternatively the old behavior of loading a profile at startup can be restored with a `[delayed_gcode]`:

```ini
[delayed_gcode bed_mesh_init]
initial_duration: .01
gcode:
  BED_MESH_PROFILE LOAD=default
```

### إنتاج

`BED_MESH_OUTPUT PGP=[0 | 1]`

Outputs the current mesh state to the terminal. Note that the mesh itself is output

The PGP parameter is shorthand for "Print Generated Points". If `PGP=1` is set, the generated probed points will be output to the terminal:

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

The "Tool Adjusted" points refer to the nozzle location for each point, and the "Probe" points refer to the probe location. Note that when manually probing the "Probe" points will refer to both the tool and nozzle locations.

### Clear Mesh State

`BED_MESH_CLEAR`

يمكن استخدام رمز g هذا لمسح حالة الشبكة الداخلية.

### Apply X/Y offsets

`BED_MESH_OFFSET [X=<value>] [Y=<value>] [ZFADE=<value>]`

This is useful for printers with multiple independent extruders, as an offset is necessary to produce correct Z adjustment after a tool change. Offsets should be specified relative to the primary extruder. That is, a positive X offset should be specified if the secondary extruder is mounted to the right of the primary extruder, a positive Y offset should be specified if the secondary extruder is mounted "behind" the primary extruder, and a positive ZFADE offset should be specified if the secondary extruder's nozzle is above the primary extruder's.

Note that a ZFADE offset does *NOT* directly apply additional adjustment. It is intended to compensate for a `gcode offset` when [mesh fade](#mesh-fade) is enabled. For example, if a secondary extruder is higher than the primary and needs a negative gcode offset, ie: `SET_GCODE_OFFSET Z=-.2`, it can be accounted for in `bed_mesh` with `BED_MESH_OFFSET ZFADE=.2`.
