# Tengely fordulat kompenzáció

Ez a dokumentum leírja az [axis_twist_compensation] modult.

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Ez a modul kézi méréseket használ a felhasználó számára, hogy korrigálja a szonda eredményeit. Vedd figyelembe, hogy ha a tengely jelentősen csavart, akkor határozottan ajánlott először mechanikai eszközöket használni a szoftveres korrekciók alkalmazása előtt.

**Figyelem**: Ez a modul még nem kompatibilis a dokkolható szondákkal, és a szonda csatlakoztatása nélkül próbáld meg megmérni az ágyat, mielőtt használod.

## A kompenzációs használat áttekintése

> **Tip:** Győződj meg róla, hogy az [ X és Y eltolás](Config_Reference.md#probe) megfelelően van beállítva, mivel nagymértékben befolyásolják a kalibrálást.

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

> **Tipp:** Úgy tűnik, hogy az ágy hőmérséklete és a fúvóka hőmérséklete és mértéke nem befolyásolja a kalibrálási folyamatot.

## [axis_twist_compensation] beállítások és parancsok

Az [axis_twist_compensation] konfigurációs beállításai a [Konfigurációs referenciában](Config_Reference.md#axis_twist_compensation) találhatóak.

Az [axis_twist_compensation] parancsok megtalálhatók a [G-Kódok referencia](G-Codes.md#axis_twist_compensation) című dokumentumban
