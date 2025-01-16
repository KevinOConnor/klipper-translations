# Компенсація скручування осі

Цей документ описує модуль [axis_twist_compensation].

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Цей модуль використовує ручні вимірювання користувача для корекції результатів датчика. Зауважте, що якщо ваша вісь значно перекручена, настійно рекомендується спочатку використати механічні засоби, щоб виправити це, перш ніж застосовувати програмні виправлення.

**Попередження**: цей модуль ще не сумісний із зондами, які можна приєднати, і, якщо ви його використовуєте, намагатиметься досліджувати ліжко, не приєднуючи зонд.

## Огляд використання компенсації

> **Порада.** Переконайтеся, що [зміщення зонда X і Y](Config_Reference.md#probe) налаштовано правильно, оскільки вони значною мірою впливають на калібрування.

### Basic Usage: X-Axis Calibration

1. After setting up the `[axis_twist_compensation]` module, run:

```
AXIS_TWIST_COMPENSATION_CALIBRATE
```

This command will calibrate the X-axis by default. - The calibration wizard will prompt you to measure the probe Z offset at several points along the bed. - By default, the calibration uses 3 points, but you can specify a different number with the option: `SAMPLE_COUNT=<value>`

1. **Adjust Your Z Offset:** After completing the calibration, be sure to [adjust your Z offset] (Probe_Calibrate.md#calibrating-probe-z-offset).
1. **Perform Bed Leveling Operations:** Use probe-based operations as needed, such as:

   - [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust)
   - [Z Tilt Adjust](G-Codes.md#z_tilt_adjust)

1. **Finalize the Setup:**

   - Home all axes, and perform a [Bed Mesh](Bed_Mesh.md) if necessary.
   - Run a test print, followed by any [fine-tuning](Axis_Twist_Compensation.md#fine-tuning) if needed.

### For Y-Axis Calibration

The calibration process for the Y-axis is similar to the X-axis. To calibrate the Y-axis, use:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AXIS=Y
```

This will guide you through the same measuring process as for the X-axis.

### Automatic Calibration for Both Axes

To perform automatic calibration for both the X and Y axes without manual intervention, use:

```
AXIS_TWIST_COMPENSATION_CALIBRATE AUTO=True
```

In this mode, the calibration process will run for both axes automatically.

> **Порада:** Здається, температура шару, температура та розмір сопла не впливають на процес калібрування.

## Налаштування та команди [axis_twist_compensation]

Параметри конфігурації для [axis_twist_compensation] можна знайти в [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Команди для [axis_twist_compensation] можна знайти в [G-Codes Reference](G-Codes.md#axis_twist_compensation)
