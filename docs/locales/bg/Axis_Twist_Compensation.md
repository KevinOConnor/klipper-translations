# Компенсация на усукването на оста

Този документ описва модула [axis_twist_compensation].

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Този модул използва ръчните измервания на потребителя за коригиране на резултатите от сондата. Обърнете внимание, че ако оста е значително усукана, силно се препоръчва първо да използвате механични средства, за да я фиксирате, преди да прилагате софтуерни корекции.

**Предупреждение**: Този модул все още не е съвместим с докинг сондите и ако го използвате, ще се опита да изследва леглото, без да е прикрепена сондата.

## Преглед на използването на компенсациите

> **Съвет:** Уверете се, че [отместванията на сондата X и Y](Config_Reference.md#probe) са правилно зададени, тъй като те оказват голямо влияние върху калибрирането.

1. След като настроите модула [axis_twist_compensation], изпълнете `AXIS_TWIST_COMPENSATION_CALIBRATE`.

* Съветникът за калибриране ще ви подкани да измерите изместването на сондата Z в няколко точки по протежение на леглото.
* По подразбиране калибрирането е с 3 точки, но можете да използвате опцията `SAMPLE_COUNT=`, за да използвате друг брой.

1. [Настройте изместването Z](Probe_Calibrate.md#calibrating-probe-z-offset)
1. Извършване на автоматични/базирани на сонда операции за трамбоване на леглото, като например [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) и др.
1. Поставете всички оси в изходно положение, след което при необходимост направете [Bed Mesh](Bed_Mesh.md)
1. Извършете тестово отпечатване, последвано от [фина настройка](Axis_Twist_Compensation.md#fine-tuning) по желание.

> **Съвет:** Изглежда, че температурата на леглото и температурата и размерът на дюзата не оказват влияние върху процеса на калибриране.

## [axis_twist_compensation] настройка и команди

Опциите за конфигуриране за [axis_twist_compensation] могат да бъдат намерени в [Configuration Reference](Config_Reference.md#axis_twist_compensation).

Командите за [axis_twist_compensation] могат да бъдат намерени в [G-Codes Reference](G-Codes.md#axis_twist_compensation)
