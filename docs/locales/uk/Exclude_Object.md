# Виключити Об'єкти

The `[exclude_object]` module allows Klipper to exclude objects while a print is in progress. To enable this feature include an [exclude_object config
section](Config_Reference.md#exclude_object) (also see the [command
reference](G-Codes.md#exclude-object) and [sample-macros.cfg](../config/sample-macros.cfg) file for a Marlin/RepRapFirmware compatible M486 G-Code macro.)

На відміну від інших варіантів мікропрограми 3D принтера, принтер, що працює Klipper, використовує люкс компонентів і користувачів, мають безліч варіантів, щоб вибрати з. Таким чином, для забезпечення послідовного досвіду користувача, модуль `[exclude_object]` дозволить встановити договір або API сортування. Договір охоплює зміст файлу gcode, як здійснюється контрольний внутрішній стан модуля, і як забезпечується стан клієнтів.

## Огляд робочого процесу

Типовий робочий процес для друку файлу може виглядати так:

1. Завантажується на друк. Під час завантаження файл обробляється і `[exclude_object]` маркери додаються в файл. Змінно, скибки можуть бути налаштовані, щоб підготувати маркери об'єкта, що відключають рідно, або в ньому власний передпроцесуальний крок.
1. Коли починається друк, Klipper буде скидати `[exclude_object]` [status](Status_Reference.md#exclude_object).
1. Коли Klipper обробляє `EXCLUDE_OBJECT_DEFINE` блок, він буде оновлювати статус з відомими об'єктами і передати його клієнтам.
1. Клієнт може використовувати цю інформацію для представлення UI до користувача, щоб прогрес може бути відстежений. Klipper поновить статус, щоб включити поточний об'єкт друку, який клієнт може використовуватися для цілей відображення.
1. Якщо користувач запитує, що об’єкт буде скасований, клієнт видає `EXCLUDE_OBJECT NAME=<name>` команди Klipper.
1. Після обробки кліппера команда додасть об'єкту до переліку виключених об'єктів і оновити статус для клієнта.
1. Клієнт отримає оновлений статус від Klipper і може використовувати цю інформацію для відображення стану об'єкта в UI.
1. Коли обробка друку, статус `[exclude_object]` буде продовжувати доступ до інших дій.

## Файл GCode

Спеціалізована обробка штрих-коду, необхідна для підтримки об'єктів, що не вписуються в основні цілі дизайну Klipper. Тому цей модуль вимагає, щоб файл був оброблений до відправки на Klipper для друку. За допомогою скрипта після обробки в скибці або маючи посередник процес, файл на завантаження є двома можливостями для приготування файлу для Klipper. Довідковий скрипт після обробки доступний як виконуваний, так і python бібліотеки, див. [cancelobject-preprocessor](https://github.com/kageurufu/cancelobject-preprocessor).

### Визначення об'єкта

Команда `EXCLUDE_OBJECT_DEFINE` використовується для надання резюме кожного об'єкта в файлі gcode, який буде надруковано. Забезпечує резюме об'єкта в файлі. Об'єкти не повинні бути визначені для того, щоб бути позначені іншими командами. Основне призначення цієї команди полягає в тому, щоб надати інформацію до UI без необхідності розпарювати весь файл gcode.

Визначення об'єкта, щоб дозволити користувачам легко вибрати об'єкт, який повинен бути виключений, і додаткові метадані можуть бути надані, щоб дозволити відображення графічної скасування. В даний час визначені метадані є ` ЦЕНТР` X,Y координат і `POLYGON` список X,Y точок, що представляють мінімальний контур об'єкта. Це може бути простою об'єднаною коробкою, або складним корпусом для відображення більш детальної візуалізації друкованих об'єктів. Особливо, коли файли gcode включають кілька частин з перекриттям межних регіонів, точки центру стають важко візуально відрізняти. `POLYGONS` повинен бути джесон-сумісний масив точки `[X,Y]` приколів без білого простору. Додаткові параметри будуть збережені як рядки у визначенні об'єкта і надані в оновленнях стану.

`EXCLUDE_OBJECT_DEFINE НАМ=Калібрація_пірамід Центр=50,50 ПОЛІГОН=[40,40],[50,60],[60,40]]`

All available G-Code commands are documented in the [G-Code
Reference](./G-Codes.md#excludeobject)

## Інформація про стан

The state of this module is provided to clients by the [exclude_object
status](Status_Reference.md#exclude_object).

Статус скидається при:

- Прошивка Klipper перезавантажена.
- `[virtual_sdcard]`. Можливо, це скидання від Klipper на старті друку.
- Коли видано команду `EXCLUDE_OBJECT_DEFINE RESET=1`.

Перелік визначених об'єктів представлений в `exclude_object.objects` поле стану. У добре визначеному файлі gcode це буде зроблено з `EXCLUDE_OBJECT_DEFINE` команди на початку файлу. Це дозволить клієнтам з іменами об'єктів і координаціями, так що UI може забезпечити графічне представлення об'єктів при бажанні.

`exCLUDE_OBJECT_START` і `EXCLUDE_OBJECT_END` команди. `current_object` поле буде встановлюватися навіть якщо об'єкт був виключений. Не визначені об'єкти, позначені `EXCLUDE_OBJECT_START` будуть додані до відомих об'єктів, які допомагають в натяку UI, без додаткових метаданих.

`EXCLUDE_OBJECT` команди видаються, список виключених об'єктів надається в `exclude_object.excluded_objects` array. З того, як Klipper видається вперед, щоб обробляти майбутні gcode, може бути затримка між коли команда видається, і коли статус оновлений.
