# Драйвери TMC

Цей документ надає інформацію про використання драйверів двигуна Trinamic stepper у режимі SPI / UART на Klipper.

Кліппер також може використовувати Тринамічні драйвери в режимі "standalone". Однак, коли драйвери знаходяться в цьому режимі, не потрібно спеціальної конфігурації Klipper і розширені функції Klipper обговорюються в цьому документі.

Додатково до цього документа обов'язково перегляньте посилання на налаштування драйвера [TMC](Config_Reference.md#tmc-stepper-driver-configuration).

## Тюнінговий струм двигуна

Більший струм водія збільшує точність позицій і крутний момент. Тим не менш, чим вище струм також підвищує тепло, що виробляється кроковим двигуном і кроковим двигуном. Якщо водій крокової двигуна занадто спекотний він буде відключити себе і Klipper повідомить про помилку. Якщо кроковий двигун занадто гаряча, він втрачає крутний момент і точність позицій. (Якщо вона дуже гаряча, вона також може розтопити пластикові деталі, прикріплені до неї або біля неї.)

В якості загального наконечника, віддайте перевагу більш високі значення струму до тих пір, поки кроковий двигун не отримує занадто спекотний і кроковий драйвер не повідомляє попередження або помилки. В цілому, для крокової мотора відчуває себе теплим, але це не повинно стати настільки гарячим, що це болісно доторкнеться.

## Не вказуйте про утримання_поточної

Якщо один налаштовує `hold_current`, то драйвер TMC може зменшити струм на кроковий двигун, коли він виявляє, що степпер не рухається. Однак, змінний струм двигуна може сам ввести рух двигуна. Це може виникати через "детентні сили" в рамках крокової мотори (постійний магніт в роторі тягнеться до залізних зубів в статорі) або через зовнішні сили на вісь-перевезення.

Більшість крокових моторів не отримають суттєву користь для зменшення струму при нормальних друкух, оскільки деякі рухи друку залишать кроковий двигун свічки досить довго, щоб активувати функцію `hold_current`. І, навряд чи, що потрібно ввести тонкі артефакти друку на кілька перегонів друку, які залишають крокової свічки досить довго.

Якщо один хоче зменшити струм до моторів під час початку друку, то розглянути емітацію [SET_TMC_CURRENT](G-Codes.md#set_tmc_current) команди в [START_PRINT макро](Slicers.md#klipper-gcode_macro) для регулювання струму до і після нормального переміщення друку.

Деякі принтери з виділеними Двигуни Z, які свічуються при нормальному перетворенні друку (не ліжко_меш, немає ліжко_тил, немає Z skew_correction, немає "масового режиму" принтів і т.д.) може знайти, що двигуни Z працюють охолоджувача з `hold_current`. При реалізації цього потім обов'язково враховуйте цей тип некомандованого руху осі Z під час вирівнювання місця, пров'язування ліжка, калібрування зонда та аналогічного. `driver_TPOWERDOWN` і `driver_IHOLDDELAY` також слід калібрувати відповідно. `hold_current`.

## Налаштування "spreadCycle" проти "stealthChop" Mode

За замовчуванням Klipper розміщує драйвери TMC в режимі "spreadCycle". Якщо драйвер підтримує "stealthChop", то він може бути включений, додаючи `stealthchop_threshold: 999999999` до розділу налаштування TMC.

В цілому поширення Режим циклів забезпечує більший крутний момент і більша точність позицій, ніж стелтКхоп режим. Тим не менш, режим крадіжкиЧоп може значно знизити шум на деяких принтерах.

Випробування режимів порівняння показали підвищений "положений лаг" близько 75% повного кроку при постійному русі швидкості при використанні крадіжки Режим хопа (наприклад, на принтері з 40mm обертання_distance і 200 кроків_per_rotation, відхилення позицій постійного руху швидкості збільшено ~0.150mm). Тим не менш, це "деле в отриманні запитуваного положення" може не проявлятися як суттєвий дефект друку і може віддати перевагу тихій поведінці крадіжкиChop-моделі.

Рекомендовано завжди використовувати режим "спредКікле" (за умови `stealthchop_threshold`) або завжди використовувати режим "stealthChop" (встановивши `stealthchop_threshold` до 999999). На жаль, драйвери часто виробляють погані і переконливі результати, якщо зміни режиму, коли двигун знаходиться на неоднорідній швидкості.

## Налаштування інтерполяції TMC вводить невелике відхилення позиції

Драйвер TMC ` інтерпольат` може зменшити шум принтера за вартістю введення невеликої системної похибки. Цей системний результат похибки про похибки водія у виконанні "кроків", які відправляє її. Під час постійної швидкості рухи, це результат затримки в позиційній похибці майже половини налаштованого мікрокрокрокропу (точніше, похибка - половина мікрокроступної дистанції мінус 512-го поверху). Наприклад, на віссю з поворотом 40mm, 200 кроків_per_rotation, і 16 мікрокроступів, системна похибка, введена при постійному русі швидкості ~0.006mm.

Для найкращої точності позицій слід розглянути за допомогою поширення Режим циклу та відключення інтерполяції (set `interpolate: False` в налаштуваннях драйвера TMC). При налаштуванні цього шляху можна збільшити мікрокроп ` ` для зменшення шуму під час руху крокової атаки. Як правило, мікрокроступна установка `64` або `128` буде мати схожий шум, як інтерполяція, і зробити так без введення системної похибки.

При використанні стелс Хоп-режим, після чого послідовна неточність від інтерполяції невелика порівняно з позиційною неточністю, введеною з режиму крадіжкиЧоп. Таким чином, перевтілення інтерполяції не вважається корисною, коли в прихованому режимі, і можна залишити інтерполяції в його стандартному стані.

## Сенсорний блиск

Безсенсорне замішування дозволяє в домашніх умовах вісь без необхідності фізичного вимикача. Замість, перевезення на віссю переноситься в механічний ліміт, що робить кроковий двигун пропускає кроки. Драйвер кроковий відзначає втрачені кроки і вказує на це для контролінгу MCU (Klipper) шляхом засвоєння шпильки. Ця інформація може бути використана Klipper як кінцева зупинка для осі.

Цей посібник охоплює налаштування безсенсорного гоління для принтера X. Тим не менш, він працює однаково з усіма іншими осями (що вимагають закінчення зупинки). Ви повинні налаштовувати і налаштовувати його на одну вісь одночасно.

### Лімітації

Обов'язково, що Ваші механічні компоненти здатні обробити навантаження вагонки, що припливають в ліміт осі багаторазово. Тим не менш, це може створити багато сил. Пришийте вісь Z, змащуючи насадку на поверхню друку, може бути непогана ідея. Для кращих результатів перевірте, що вісь-перевезення зробить контакт фірми з обмеженням осі.

Крім того, для принтера не буде достатньо точного. В той час як хмінг X і Y осі на картонній машині може добре працювати, хмінг осі Z, як правило, не точніше і може призвести до невідповідної висоти першого шару. Захоплення дельта принтера не бажано через відсутність точності.

Далі, стиглий виявлення крокового драйвера залежить від механічного навантаження на двигун, струм двигуна і температури двигуна (резистентність вологи).

Відстеження безшумних голів найкраще працює на швидкості середнього двигуна. Для дуже повільних швидкостей (без 10 RPM) двигун не генерує значну задню EMF і TMC не може надійно виявити моторні стилі. далі, при дуже високих швидкостях, спина EMF мотора підійде напругу живлення мотора, тому TMC не може виявити столи. Повідомляємо, що в описі вашого конкретного TMCs ви можете переглянути опис. Ви також можете дізнатися більше про обмеження цього налаштування.

### Вимоги

Кілька передумов необхідно використовувати безсенсорне гоління:

1. СталГуард здатний драйвера стартера TMC (tmc2130, tmc2209, tmc2660 або tmc5160).
1. SPI / інтерфейс UART драйвера ТМC проводилася до мікроконтролера (режим витримки не працює).
1. Привідний "DIAG" або "SG_TST" штифт драйвера TMC підключений до мікроконтролера.
1. Заходи в документі [config checks](Config_checks.md) повинні працювати, щоб підтвердити крокові двигуни налаштовані і працюють належним чином.

### Тюнінг

Процедура описана тут має шість основних кроків:

1. Виберіть швидкість стрибка.
1. Налаштуйте файл `printer.cfg`, щоб увімкнути сенсорне панування.
1. Знайдіть налаштування стійкого захисту з найвищою чутливістю, яка успішно домовласників.
1. Знайдіть налаштування траалгарду з найнижчою чутливістю, яка вдало домовласників з одним дотиком.
1. Оновлення `printer.cfg` з бажаним налаштуванням траалгарду.
1. Створення або оновлення `printer.cfg` макроси до дому послідовно.

#### Виберіть швидкість лосини

Швидкість панування є важливим вибором при виконанні безсенсорного гоління. Бажано використовувати повільну швидкість хмелю, щоб перевезення не вичерпувала зайву силу на каркасі при виготовленні контакту з закінченням рейки. Тим не менш, драйвери TMC не можуть надійно виявити високий рівень при дуже повільній швидкості.

Хороша початкова точка для швидкості замішування є для крокової двигуна, щоб зробити повне обертання кожні два секунди. Для багатьох осей це буде `rotation_distance` розділений на два. Наприклад:

```
[stepper_x]
обертання_distance: 40
код товару: 20
...
```

#### Налаштування принтера.cfg для безсенсорного гоління

`homing_retract_dist` налаштування повинна бути встановлена до нуля в `stepper_x` розділ налаштування для відключення другого підйому. Друга спроба хмінгу не додасть значення при використанні безсенсорного хмінгу, це не буде надійно працювати, і він буде плутати процес налаштування.

Переконайтеся, що параметр `hold_current` не вказано в розділі драйвера TMC config. (Якщо утримувати_поточний встановлюється після того, як з'явиться контакт, рух припиняється, поки перевезення натискається на кінець рейки, а зменшення струму в той час як в такому положенні може викликати перевезення, щоб пересуватися - це призводить до низької продуктивності і буде протистояти процесу тюнінгу.)

Необхідно налаштовувати безсенсорні замшеві шпильки і налаштовувати початкові налаштування "стандарт". Прикладна конфігурація Tmc2209 для осі X може виглядати:

```
[tmc2209 stepper_x]
diag_pin: ^PA1 # Комплект до MCU, підключений до штифта TMC DIAG
Драйвери SGTHRS: 255 # 255 є найбільш чутливою вартістю, 0 найменш чутлива
...

[stepper_x]
JavaScript licenses API Веб-сайт Go1.13.8
код товару: 0
...
```

Приклад tmc2130 або tmc5160 config може виглядати як:

```
[tmc2130 stepper_x]
diag1_pin: ^!PA1 # Pin підключений до штифта TMC DIAG1 (або використовувати діаг0_pin / DIAG0 шпилька)
драйвер_SGT: -64 # -64 є найбільш чутливим значенням, 63 є найменш чутливим
...

[stepper_x]
JavaScript licenses API Веб-сайт Go1.13.8
код товару: 0
...
```

Приклад tmc2660 config може виглядати як:

```
[tmc2660 stepper_x]
драйвер_SGT: -64 # -64 є найбільш чутливим значенням, 63 є найменш чутливим
...

[stepper_x]
endstop_pin: ^PA1 # Pin підключений до TMC SG_TST шпильки
код товару: 0
...
```

Приклади вище тільки показують параметри, специфічні для безсенсорного гоління. Дивитися посилання [config](Config_Reference.md#tmc-stepper-driver-configuration) для всіх доступних варіантів.

#### Знайдіть найвищу чутливість, яка успішно будинки

Помістити вагонку біля центру рейки. Використовуйте команду SET_TMC_FIELD, щоб встановити найвищу чутливість. Для tmc2209:

```
СЕТ_TMC_FIELD СТЕППЕР=Степпер_x ФАЙЛД=СГТРС ВАЛУ=255
```

Для tmc2130, tmc5160 і tmc2660:

```
СЕТ_TMC_FIELD СТЕППЕР=Степпер_x ФАЙЛД=СТ ВАЛЭ=-64
```

Потім випишіть команду `G28 X0` і перевірте віссю не рухається на всіх або швидко зупиняється переміщення. Якщо вісь не зупиняється, то виписайте `M112`, щоб захопити принтер - щось не вірно з діаг / сg_tst шпилькою або конфігурацією, і її необхідно виправити до продовження.

Далі, безперервно зменшуючи чутливість параметра `VALUE` і запустити `SET_TMC_FIELD` `G28 X0` команди знову знайдуть найвищу чутливість, яка призводить до перевезення, успішно перемістивши весь шлях до кінця і жовчі. (Для драйверів tmc2209 це буде знешкоджено SGTHRS, для інших водіїв він буде збільшуватися sgt.) Обов'язково запустіть кожну спробу з перевезенням поруч з центром рейки (у разі необхідності `M84`, а потім вручну перемістіть перевезення до центру). Необхідно знайти найбільшу чутливість, що домівки надійно (постановки з вищим результатом чутливості в малому або без руху). Зверніть увагу, що знайшли значення *maximum_sensitivity*. (Якщо мінімальна можлива чутливість (SGTHRS=0 або sgt=63) отримується без будь-якого руху перевезення, то щось не правильне з діаг/сg_tst шпилькою або конфігурацією, і вона повинна бути виправлена до продовження.)

При пошуку максимальної_чутливості, це може бути зручно стрибати на різні налаштування VALUE (наприклад, для виявлення параметра VALUE). Якщо це зробити, то приготувавши, щоб випустити `M112`, щоб захопити принтер, так як установка з дуже низькою чутливістю може викликати вісь для багаторазового "чубчик" в кінці рейки.

Обов'язково почекайте пару секунд між кожною спробою. Після того, як драйвер TMC виявляє високий рівень, він може зайняти трохи часу для того, щоб очистити його внутрішній показник і бути здатний виявляти інший високий рівень.

Під час цих тестів, якщо команда `G28 X0` не пересуває весь шлях до обмеження осі, то будьте обережні з видачею будь-яких регулярних команд руху (наприклад, `G1`). Кліппер не має правильного розуміння положення про перевезення та команди руху може викликати небажані та переконливі результати.

#### Знайти найменшу чутливість, які будинки з одним дотиком

Коли захоплення з знайденим *maximum_sensitivity* значення, вісь повинна переходити до кінця рейки і зупинитися з "сингом дотиком" - тобто не повинно бути "затискання" або "чуття" звуку. (Якщо є чубчик або натискання звуку в максимальній_чутливості, то хмінг_швидкість може бути занадто низьким, струм водія може бути занадто низьким, або безсенсорне хміння може бути недобрим вибором для осі.)

Наступний крок полягає в тому, щоб знову безперервно перемістити перевезення в позицію недалеко від центру рейки, зменшити чутливість і запустити `SET_TMC_FIELD` `G28 X0` команди - ціль тепер знайти найнижчу чутливість, яка все ще призводить до перевезення, вдало занурення з "синглінним дотиком". Що це, це не "чубчик" або "клацання" при контакті з закінченням рейки. Зверніть увагу, що знайшли значення *minimum_sensitivity*.

#### Оновлення принтера.cfg з значенням чутливості

*maximum_sensitivity* і *minimum_sensitivity*, використовуйте калькулятор для отримання рекомендувати чутливість як *minimum_sensitivity + (maximum_sensitivity - мінімум_sensitivity)/3*. Рекомендована чутливість повинна бути в діапазоні між мінімальним і максимальним, але трохи ближче до мінімуму. Закруглити кінцеве значення до найближчого цілого значення.

Для tmc2209 встановити це в конфігурації, як `driver_SGTHRS`, для інших драйверів TMC встановити це в конфігурації, як `driver_SGT`.

Якщо діапазон між *maximum_sensitivity* і *minimum_sensitivity* є невеликим (наприклад, менше 5), то це може призвести до нестабільного панування. Швидша швидкість замші може збільшити діапазон і зробити операцію більш стабільною.

Зверніть увагу, що якщо будь-яка зміна виконана на струм драйвера, швидкість замішування або нездатна зміна проводиться до обладнання принтера, то буде потрібно знову запустити процес налаштування.

#### Використання Macros при голодуванні

Після безшумного гоління завершується перевалка буде натискати на кінець рейки, а кроковий крок закріпить сили на каркасі до того, як перевезення переміщається. Це гарна ідея для створення макросу до будинку осі і відразу ж перемістити перевезення з кінця рейки.

Це хороша ідея для макросу, щоб пауза принаймні 2 секунди до початку безсенсорного гоління (або іншим чином, не існує руху на степпері протягом 2 секунд). Без затримки можна за внутрішнім стиглим прапором, щоб все-таки було встановлено з попереднього ходу.

Також можна скористатися тим, що макроси встановлюють струм драйвера перед замішуванням і встановлюють новий струм після переїзду.

Наприклад, макро може виглядати щось схоже:

```
[gcode_macro SENSORLESS_HOME_X]
гкод:
{% встановити HOME_CUR = 0.700 %}
{% встановити драйвер_config = принтер.configfile.settings['tmc2209 stepper_x'] %}
{% встановити RUN_CUR = драйвер_config.run_current %}
# Встановити струм для безсенсорного гоління
SET_TMC_CURRENT STEPPER=Степпер_x КУРЕНТ={HOME_CUR}
#Застосувати, щоб забезпечити водій стиглий прапор ясно
Г4 П2000
# Головна
Г28 Х0
#Перемістити
Г90
Г1 Х5 Ф1200
# Встановити струм під час друку
SET_TMC_CURRENT STEPPER=Степпер_x КУРЕНТ={RUN_CUR}
```

Отриманий макрос можна назвати з розділу [homing_override config](Config_Reference.md#homing_override) або з [START_PRINT макро](Slicers.md#klipper-gcode_macro).

Зверніть увагу, що якщо змінено струм водія, то процес налаштування повинен знову працювати.

### Поради щодо безсенсорного гоління на CoreXY

Можливе використання безсенсорних штрихів на X і Y-колесках принтера CoreXY. Klipper використовує `[stepper_x]` stepper для виявлення стол, коли захоплення X-транспорту і використовує `[stepper_y]` stepper для виявлення стол, коли панування Y-транспорту.

Використовуйте посібник, описаний вище, щоб знайти відповідну "високу чутливість" для кожного перевезення, але врахувати такі обмеження:

1. При використанні безсенсорного гоління на CoreXY, переконайтеся, що немає `hold_current` налаштовано для будь-якого кроку.
1. В той час як тюнінг, переконайтеся, що обидві вагони X і Y знаходяться недалеко від центру своїх рейок до кожної домашньої спроби.
1. Після того, як тюнінг завершений, коли панування як X, так і Y використовуйте макроси, щоб забезпечити, що одна вісь спочатку додається, потім перемістіть, що перевозиться від обмеження осі, пауза не менше 2 секунд, а потім починайте гоління іншого перевезення. Відіймається від осі уникає захоплення однієї осі, а інший притискається до обмеження осі (що може скребити стійке виявлення). Пауза необхідна для того, щоб забезпечити дорожний прапор водія був очищений до того, як знову захопити.

Наприклад, CoreXY кодування макро може виглядати:

```
[gcode_macro HOME]
гкод:
Г90
# Головна З
Г28 З0
Г1 З10 Ф1200
# Головна Y
Г28 Y0
G1 Y5 F1200
# Головна X
Г4 П2000
Г28 Х0
Г1 Х5 Ф1200
```

## Налаштування драйвера та діагностики

`[DUMP_TMC команди](G-Codes.md#dump_tmc) є корисним інструментом при налаштуванні та діагностуванні драйверів. Повідомляти всі поля, налаштовані Klipper, а також всі поля, які можуть бути перевірені з водія.

Всі зазначені поля визначені в таблиці даних Trinamic для кожного водія. Ці таблиці можна знайти на сайті [Тринадимий сайт](https://www.trinamic.com/). Ознайомтеся з та ознайомтеся з табличкою даних для водія, щоб інтерпретувати результати DUMP_TMC.

## Налаштування параметрів драйвера_XXX

Klipper підтримує налаштування багатьох драйверів низького рівня за допомогою параметра `driver_XXX`. [Налаштування драйвера TMC](Config_Reference.md#tmc-stepper-driver-configuration) має повний перелік полів, доступних для кожного типу драйвера.

Крім того, майже всі поля можуть бути змінені в режимі run-time за допомогою команди [SET_TMC_FIELD](G-Codes.md#set_tmc_field).

Кожна з цих полів визначається в таблиці даних Trinamic для кожного водія. Ці таблиці можна знайти на сайті [Тринадимий сайт](https://www.trinamic.com/).

Зауважте, що Тринамічні описи іноді використовують формулювання, яке може заплутати налаштування високого рівня (наприклад, "гістерез енд") з низькою вартістю поля (наприклад, "HEND"). У Klipper `driver_XXX` і SET_TMC_FIELD завжди встановлюють значення поля низького рівня, яке фактично написано водієм. Так, наприклад, якщо Тринамічний опис таблиці стверджує, що значення 3 має бути написано на поле HEND, щоб отримати "гістерезний кінець" 0, потім встановити `driver_HEND=3` для отримання високої ціни 0.

## Загальні питання

### Чи можу я використовувати прихованийChop режим на екструдера з передовим тиском?

Багато людей успішно використовують режим «stealthChop» з передовим тиском Klipper. Klipper впроваджує [попереднє оновлення тиску](кінематика.md#pressure-advance), що не вводить будь-які миттєві зміни швидкості.

Однак режим «stealthChop» може виготовити нижню моторну крутку та/або виготовити більш високу моторну спеку. Не може бути достатній режим для вашого конкретного принтера.

### Я тримую "Не вдалося прочитати tmc uart 'stepper_x' реєстрація IFCNT" помилки?

Це відбувається, коли Klipper не може спілкуватися з драйвером tmc2208 або tmc2209.

Переконайтеся, що моторна потужність ввімкнена, як кроковий двигун водій, як правило, потребує моторної потужності, перш ніж вона може спілкуватися з мікроконтролером.

Якщо ця помилка виникає після того, як миготливий ковпачок вперше, то драйвер може попередньо запрограмований в штаті, який не сумісний з Klipper. Щоб скидати стан, видаліть всю потужність з принтера протягом декількох секунд (фізично не розгорніть як USB, так і заглушки живлення).

В іншому випадку, ця помилка, як правило, є результатом неправильного UART шприцом або неправильною конфігурацією клиппера UART настройок.

### Я тримую "Неможливо писати tmc spi 'stepper_x' реєстрація ..." помилки?

Це відбувається, коли Klipper не може спілкуватися з драйвером tmc2130 або tmc5160.

Переконайтеся, що моторна потужність ввімкнена, як кроковий двигун водій, як правило, потребує моторної потужності, перш ніж вона може спілкуватися з мікроконтролером.

В іншому випадку, ця помилка, як правило, є результатом неправильної передачі SPI, неправильної конфігурації Klipper параметрів SPI або неповної конфігурації пристроїв на автобусі SPI.

Зверніть увагу, що якщо водій знаходиться на спільному автобусі SPI з декількома пристроями, то обов'язково в повній мірі налаштовувати кожен пристрій на цьому спільному автобусі SPI в Klipper. Якщо пристрій на спільному автобусі SPI не налаштовується, то він може некоректно реагувати на команди, які не призначені для нього і псувати зв'язок до призначеного пристрою. Якщо є пристрій на спільному автобусі SPI, який не може бути налаштований в Klipper, то скористайтеся [static_digital_вихідна конфігурація розділу](Config_Reference.md#static_digital_вихід) для встановлення CS шпильки невикористаного пристрою високої (так що він не намагатиметься використовувати SPI автобус). Дошка схема часто є корисною для пошуку, які пристрої знаходяться на автобусі SPI і їх пов'язані шпильки.

### Чому я отримав "TMC повідомлення про помилку: ..." помилка?

Цей тип помилки показує, що драйвер TMC виявив проблему і відключив себе. Таким чином, водій припинив позицію та ігнорував командування руху. Якщо Klipper виявляє, що активний водій відключився самостійно, він перетворить принтер в стан «пошуку».

Також можливо, що **TMC звітує про помилку** виникає через помилки SPI, які запобігають зв'язкам з водієм (на tmc2130, tmc5160 або tmc2660). Якщо це відбувається, це загальний для вказаного стану драйвера, щоб показати `0000000000000000` або `ffffffffffffffffffffffffff` - наприклад: `TMC Повідомлення: DRV_STATUS: ffffffffff ...` OR `TMC повідомлення про помилку: READRSP@RDSEL2: 00000000 ...`. Таку несправність може бути пов’язано з проблемою електропроводки SPI або може бути пов’язано з самовідновленням або збою драйвера TMC.

Деякі загальні помилки і поради щодо діагностики їх:

#### `... ot=1(OvertempError!)`

Це говорить про те, що водій відключився, тому що він став занадто гарячим. Типові рішення є зменшення струменя крокового двигуна, збільшення охолодження на кроковий двигун водія, а/або збільшення охолодження на кроковий двигун.

#### TMC повідомляє про помилку: `... ShortToGND` АБО `ShortToSupply`

Це говорить про те, що водій відключився себе, тому що він виявлений дуже високий струм проходження через драйвер. Це може вказати пухкий або скорочений дріт на кроковий двигун або всередині самого крокової двигуна.

Ця помилка також може виникнути при використанні крадіжки Шоп-режим і драйвер TMC точно не здатний прогнозувати механічне навантаження двигуна. (Якщо водій робить поганий прогноз, то він може надсилати занадто багато струму через двигун і запускати його самостійно за рахунок виявлення.) Щоб перевірити це, відключити крадіжкуChop режим і перевірити, якщо помилки продовжують виникати.

#### TMC повідомляє про помилку: `... reset=1(Reset)` АБО `CS_ACTUAL=0(Reset?)` АБО `SE=0(Reset?)`

Це вказує на те, що водій скинути себе середнім друком. Це може бути пов'язано з питаннями напруги або проводки.

#### TMC повідомляє про помилку: `... uv_cp=1(Знижена напруга!)`

Це свідчить про те, що водій виявив низьковольтний захід і відключив себе. Це може бути пов'язано з питаннями електропроводки або електропостачання.

### Як я налаштовую поширенняCycle/coolStep/etc. режим на драйверах?

[Trinamic веб-сайт](https://www.trinamic.com/) має керівництва щодо налаштування драйверів. Ці керівництва часто технічні, низький рівень, і може знадобитися спеціалізоване обладнання. Незалежно від того, що вони є найкращим джерелом інформації.
