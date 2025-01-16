# Компенсация поворота оси

Этот документ описывает модуль [axis_twist_compensation].

Some printers may have a small twist in their X rail which can skew the results of a probe attached to the X carriage. This is common in printers with designs like the Prusa MK3, Sovol SV06 etc and is further described under [probe location
bias](Probe_Calibrate.md#location-bias-check). It may result in probe operations such as [Bed Mesh](Bed_Mesh.md), [Screws Tilt Adjust](G-Codes.md#screws_tilt_adjust), [Z Tilt Adjust](G-Codes.md#z_tilt_adjust) etc returning inaccurate representations of the bed.

Этот модуль использует ручные измерения пользователя для коррекции результатов измерений датчика. Обратите внимание, что если ваша ось значительно искривлена, настоятельно рекомендуется сначала использовать механические средства для ее исправления, прежде чем применять программные корректировки.

**Предупреждение**: Этот модуль пока не совместим со стыкуемыми зондами и при его использовании будет пытаться прощупать кровать, не прикрепляя зонд.

## Обзор использования компенсаций

> **Совет:** Убедитесь, что параметры [смещения зонда по X и Y](Config_Reference.md#probe) установлены правильно, так как они сильно влияют на калибровку.

1. После настройки модуля [axis_twist_compensation] выполните команду `AXIS_TWIST_COMPENSATION_CALIBRATE`

* Мастер калибровки предложит вам измерить смещение зонда по оси Z в нескольких точках вдоль станины
* По умолчанию калибровка выполняется по 3 точкам, но вы можете использовать опцию `SAMPLE_COUNT=`, чтобы использовать другое число.

1. [Отрегулируйте смещение по оси Z](Probe_Calibrate.md#calibrating-probe-z-offset)
1. Выполняйте автоматические/зондовые операции трамбовки кровати, такие как [[Регулировка наклона винтов](G-Codes.md#screws_tilt_adjust), [Регулировка наклона по Z](G-Codes.md#z_tilt_adjust) и т.д
1. Установите все оси, затем выполните [Bed Mesh](Bed_Mesh.md), если требуется
1. Выполните пробную печать, а затем выполните любую [тонкую настройку](Axis_Twist_Compensation.md#fine-tuning) по желанию

> **Совет: ** Температура слоя, температура и размер сопла не оказывают влияния на процесс калибровки.

## Настройка и команды [axis_twist_compensation]

Параметры конфигурации для [axis_twist_compensation] можно найти в [Ссылка на конфигурацию](Config_Reference.md#axis_twist_compensation).

Команды для [axis_twist_compensation] можно найти в [G-Codes справочнике](G-Codes.md#axis_twist_compensation)
