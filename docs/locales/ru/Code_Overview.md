# Обзор кода

В этом документе описывается общая компоновка кода и основной поток кода Klipper.

## Расположение каталогов

Каталог **src/** содержит исходный код C для кода микроконтроллера. **src/atsam/**, **src/atsamd/**, **src/avr/**, **src/linux/**, **src/lpc176x/**, **src/pru/** и **src/каталоги stm32/** содержат код микроконтроллера, специфичный для архитектуры. **src/simulator/** содержит заглушки кода, которые позволяют тестировать микроконтроллер, скомпилированный на других архитектурах. Каталог **src/generic/** содержит вспомогательный код, который может быть полезен в различных архитектурах. Сборка организует включение "board/somefile.h", чтобы сначала заглянуть в текущий каталог архитектуры (например, src/avr/somefile.h), а затем в общий каталог (например, src/generic/somefile.h).

Каталог **klippy/** содержит программное обеспечение хоста. Большая часть программного обеспечения хоста написана на Python, однако каталог **klippy/chelper/** содержит несколько помощников по коду C. Каталог **klippy/kinematics/** содержит код кинематики робота. Каталог **klippy/extras/** содержит расширяемые "модули" хост-кода.

Каталог **lib/** содержит код внешней библиотеки третьей стороны, который необходим для создания некоторых целевых объектов.

Каталог **config/** содержит примеры файлов конфигурации принтера.

Каталог **scripts/** содержит скрипты времени сборки, полезные для компиляции кода микроконтроллера.

Каталог **test/** содержит автоматизированные тестовые случаи.

Во время компиляции сборка может создать каталог **out/**. Он содержит временные объекты времени сборки. Конечным объектом сборки микроконтроллера является **out/klipper.elf.hex** на AVR и **out/klipper.bin** на ARM.

## Поток кода микроконтроллера

Выполнение кода микроконтроллера начинается в коде, специфичном для данной архитектуры (например, **src/avr/main.c**), который в конечном итоге вызывает sched_main(), расположенный в **src/sched.c**. Код sched_main() начинает с запуска всех функций, которые были помечены макросом DECL_INIT(). Затем он повторяет запуск всех функций, помеченных макросом DECL_TASK().

Одной из основных функций задачи является command_dispatch(), расположенная в **src/command.c**. Эта функция вызывается из кода ввода/вывода, специфичного для платы (например, **src/avr/serial.c**, **src/generic/serial_irq.c**), и запускает командные функции, связанные с командами, найденными во входном потоке. Командные функции объявляются с помощью макроса DECL_COMMAND() (более подробную информацию см. в документе [protocol](Protocol.md)).

Функции Task, init и command всегда выполняются с включенными прерываниями (однако при необходимости они могут временно отключить прерывания). Эти функции должны избегать длительных пауз, задержек или выполнения работы, которая длится значительное время. (Длительные задержки в этих функциях "задач" приводят к нарушению планирования других "задач" - задержки более 100 мс могут стать заметными, задержки более 500 мс могут привести к повторной передаче команд, задержки более 100 мс могут привести к перезагрузке сторожевого таймера). Эти функции планируют работу в определенное время с помощью таймеров планирования.

Функции таймера планируются вызовом sched_add_timer() (находится в **src/sched.c**). Код планировщика организует вызов данной функции в требуемое тактовое время. Прерывания таймера первоначально обрабатываются в специфичном для архитектуры обработчике прерываний (например, **src/avr/timer.c**), который вызывает sched_timer_dispatch(), расположенный в **src/sched.c**. Прерывание таймера приводит к выполнению функций таймера расписания. Функции таймера всегда выполняются с отключенными прерываниями. Функции таймера всегда должны завершаться в течение нескольких микросекунд. По завершении события таймера функция может решить перепланировать себя.

В случае обнаружения ошибки код может вызвать shutdown() (макрос, вызывающий sched_shutdown(), расположенный в **src/sched.c**). Вызов shutdown() приводит к запуску всех функций, помеченных макросом DECL_SHUTDOWN(). Функции выключения всегда выполняются с отключенными прерываниями.

Большая часть функциональности микроконтроллера связана с работой с контактами ввода/вывода общего назначения (GPIO). Для того чтобы абстрагировать низкоуровневый код, специфичный для архитектуры, от высокоуровневого кода задачи, все события GPIO реализованы в обертках, специфичных для архитектуры (например, **src/avr/gpio.c**). Код компилируется с помощью оптимизации gcc "-flto -fwhole-program", которая отлично справляется с встраиванием функций в единицы компиляции, поэтому большинство этих крошечных функций gpio встраиваются в вызывающие их устройства, и их использование не требует затрат во время выполнения.

## Обзор кода Klippy

Код хоста (Klippy) предназначен для работы на недорогом компьютере (например, Raspberry Pi) в паре с микроконтроллером. Код в основном написан на Python, однако он использует CFFI для реализации некоторой функциональности в коде на C.

Первоначальное выполнение начинается в **klippy/klippy.py**. Он считывает аргументы командной строки, открывает файл конфигурации принтера, инстанцирует основные объекты принтера и запускает последовательное соединение. Основное выполнение команд G-кода происходит в методе process_commands() в **klippy/gcode.py**. Этот код преобразует команды G-кода в вызовы объектов принтера, которые часто преобразуют действия в команды для выполнения на микроконтроллере (как объявлено с помощью макроса DECL_COMMAND в коде микроконтроллера).

В коде хоста Klippy есть четыре потока. Главный поток обрабатывает входящие команды gcode. Второй поток (который полностью находится в Си-коде **klippy/chelper/serialqueue.c**) обрабатывает низкоуровневые операции ввода-вывода с последовательным портом. Третий поток используется для обработки ответных сообщений от микроконтроллера в Python-коде (см. **klippy/serialhdl.py**). Четвертый поток записывает отладочные сообщения в журнал (см. **klippy/queuelogger.py**), чтобы другие потоки не блокировали запись в журнал.

## Кодовый поток команды перемещения

Типичное перемещение принтера начинается с момента отправки команды "G1" на хост Klippy и завершается, когда на микроконтроллере появляются соответствующие шаговые импульсы. В этом разделе описывается поток кода типичной команды перемещения. В документе [кинематика](Kinematics.md) содержится дополнительная информация о механике перемещений.

* Обработка команды перемещения начинается в gcode.py. Цель gcode.py - перевести G-код во внутренние вызовы. Команда G1 вызовет cmd_G1() в klippy/extras/gcode_move.py. Код gcode_move.py обрабатывает изменения начала координат (например, G92), изменения относительных и абсолютных позиций (например, G90), а также изменения единиц измерения (например, F6000=100 мм/с). Путь кода для перемещения таков: `_process_data() -> _process_commands() -> cmd_G1()`. В конечном итоге вызывается класс ToolHead для выполнения фактического запроса: `cmd_G1() -> ToolHead.move()`
* Класс ToolHead (в файле toolhead.py) обрабатывает "опережающий взгляд" и отслеживает время выполнения действий печати. Основной кодовый путь для перемещения выглядит так: `ToolHead.move() -> LookAheadQueue.add_move() -> LookAheadQueue.flush() -> Move.set_junction() -> ToolHead._process_moves()`.

   * ToolHead.move() создает объект Move() с параметрами перемещения (в картезианском пространстве и в единицах секунд и миллиметров).
   * Классу кинематики предоставляется возможность проверять каждое движение (`ToolHead.move() -> kin.check_move()`). Классы кинематики находятся в директории klippy/kinematics/. Код check_move() может выдать ошибку, если перемещение не является корректным. Если check_move() завершается успешно, то базовая кинематика должна быть способна обработать перемещение.
   * LookAheadQueue.add_move() помещает объект перемещения в очередь "look-ahead".
   * LookAheadQueue.flush() определяет начальную и конечную скорости каждого перемещения.
   * Move.set_junction() реализует "генератор трапеций" в движении. Генератор трапеций" разбивает каждое движение на три части: фаза постоянного ускорения, затем фаза постоянной скорости, затем фаза постоянного замедления. Каждый ход содержит эти три фазы в таком порядке, но некоторые фазы могут быть нулевой продолжительности.
   * Когда вызывается ToolHead._process_moves(), известно все о перемещении - его начальное местоположение, конечное местоположение, ускорение, начальная/круизная/конечная скорость и расстояние, пройденное во время ускорения/круизного/тормозного движения. Вся информация хранится в классе Move() и находится в картезианском пространстве в единицах миллиметров и секунд.
* Klipper использует [итерационный решатель](https://en.wikipedia.org/wiki/Root-finding_algorithm) для генерации времени шага для каждого шага. Для повышения эффективности время импульсов шагов генерируется в коде на языке C. Сначала движения помещаются в "очередь трапециевидных движений": `ToolHead._process_moves() -> trapq_append()` (в klippy/chelper/trapq.c). Затем генерируется время шага: `ToolHead._process_moves() -> ToolHead._advance_move_time() -> ToolHead._advance_flush_time() -> MCU_Stepper.generate_steps() -> itersolve_generate_steps() -> itersolve_gen_steps_range()` (в klippy/chelper/itersolve.c). Цель итеративного решателя - найти время шага, заданное функцией, которая вычисляет положение шага по времени. Это делается путем многократного "угадывания" различных времен, пока формула положения шага не вернет желаемое положение следующего шага на шаговом механизме. Обратная связь, полученная при каждом угадывании, используется для улучшения последующих угадываний, так что процесс быстро сходится к желаемому времени. Формулы кинематической позиции шагового механизма находятся в каталоге klippy/chelper/ (например, kin_cart.c, kin_corexy.c, kin_delta.c, kin_extruder.c).
* Обратите внимание, что экструдер обрабатывается в собственном кинематическом классе: `ToolHead._process_moves() -> PrinterExtruder.move()`. Поскольку класс Move() задает точное время движения и поскольку импульсы шага посылаются на микроконтроллер с определенным временем, движения шага, создаваемые классом экструдера, будут синхронизированы с движением головки, несмотря на то, что код разделен.
* После того как итерационный решатель вычислит время шага, оно добавляется в массив: `itersolve_gen_steps_range() -> stepcompress_append()` (в klippy/chelper/stepcompress.c). В массиве (struct stepcompress.queue) хранится соответствующее время счетчика часов микроконтроллера для каждого шага. Здесь значение "счетчик часов микроконтроллера" напрямую соответствует аппаратному счетчику микроконтроллера - оно относится к моменту последнего включения питания микроконтроллера.
* Следующий важный шаг - сжатие шагов: `stepcompress_flush() -> compress_bisect_add()` (в klippy/chelper/stepcompress.c). Этот код генерирует и кодирует серию команд "queue_step" микроконтроллера, которые соответствуют списку времен шагов шагового механизма, построенному на предыдущем этапе. Затем эти команды "queue_step" ставятся в очередь, определяют приоритет и отправляются на микроконтроллер (через stepcompress.c:steppersync и serialqueue.c:serialqueue).
* Обработка команд queue_step на микроконтроллере начинается в файле src/command.c, который анализирует команду и вызывает `command_queue_step()`. Код command_queue_step() (в src/stepper.c) просто добавляет параметры каждой команды queue_step в очередь для каждого шага. При нормальной работе команда queue_step разбирается и ставится в очередь как минимум за 100 мс до времени первого шага. Наконец, генерация событий шага осуществляется в `stepper_event()`. Она вызывается из прерывания аппаратного таймера в запланированное время первого шага. Код stepper_event() генерирует импульс шага, а затем перестраивается на запуск в момент следующего импульса шага для заданных параметров queue_step. Параметры для каждой команды queue_step - это "interval", "count" и "add". На высоком уровне, stepper_event() выполняет следующие команды, "считанные" разы: `do_step(); next_wake_time = last_wake_time + interval; interval += add;`

Вышеперечисленное может показаться слишком сложным для выполнения движения. Однако по-настоящему интересными являются только классы ToolHead и кинематика. Именно эта часть кода задает движения и их тайминг. Остальные части обработки - это, в основном, просто коммуникация и сантехника.

## Добавление хост-модуля

В коде хоста Klippy предусмотрена возможность динамической загрузки модулей. Если в конфигурационном файле принтера обнаружен раздел с именем "[my_module]", то программа автоматически попытается загрузить python-модуль klippy/extras/my_module.py . Эта система модулей является предпочтительным методом добавления новой функциональности в Klipper.

Самый простой способ добавить новый модуль - это использовать существующий модуль в качестве ссылки - смотрите **klippy/extras/servo.py** в качестве примера.

Также может быть полезно следующее:

* Выполнение модуля начинается в функции уровня модуля `load_config()` (для секций конфига вида [my_module]) или в `load_config_prefix()` (для секций конфига вида [my_module my_name]). Этой функции передается объект "конфигурация", и она должна вернуть новый объект " printer object", связанный с данной секцией конфигурации.
* В процессе инстанцирования нового объекта принтера объект config может быть использован для чтения параметров из заданной секции config. Для этого используются методы `config.get()`, `config.getfloat()`, `config.getint()` и т. д. Обязательно считывайте все значения из конфигурации во время создания объекта принтера - если пользователь укажет параметр конфигурации, который не будет считан на этом этапе, то будет считаться, что это опечатка в конфигурации, и будет выдана ошибка.
* Используйте метод `config.get_printer()`, чтобы получить ссылку на основной класс "принтер". Этот класс "printer" хранит ссылки на все инстанцированные объекты "printer objects". Используйте метод `printer.lookup_object()` для поиска ссылок на другие объекты принтера. Почти вся функциональность (даже основные кинематические модули) заключена в одном из этих объектов принтера. Однако обратите внимание, что при инстанцировании нового модуля не все другие объекты принтера будут инстанцированы. Модули "gcode" и "pins" всегда будут доступны, но для других модулей лучше отложить поиск.
* Зарегистрируйте обработчики событий с помощью метода `printer.register_event_handler()`, если код должен вызываться во время "событий", поднимаемых другими объектами принтера. Имя каждого события - это строка, и по условию это имя основного исходного модуля, который вызывает событие, а также краткое название происходящего действия (например, "klippy:connect"). Параметры, передаваемые каждому обработчику события, специфичны для данного события (как и обработка исключений и контекст выполнения). Двумя распространенными событиями запуска являются:
   * klippy:connect - это событие генерируется после инстанцирования всех объектов принтера. Оно обычно используется для поиска других объектов принтера, проверки настроек конфигурации и для выполнения начального "рукопожатия" с оборудованием принтера.
   * klippy:ready - Это событие генерируется после успешного завершения всех обработчиков подключения. Оно указывает на то, что принтер переходит в состояние, готовое к выполнению обычных операций. Не следует вызывать ошибку в этом обратном вызове.
* Если в пользовательском конфиге произошла ошибка, обязательно сообщите об этом на этапе `load_config()` или "соединить событие". Для сообщения об ошибке используйте либо `raise config.error("моя ошибка")`, либо `raise printer.config_error("моя ошибка")`.
* Используйте модуль " пины" для настройки пина на микроконтроллере. Обычно это делается примерно так: `printer.lookup_object(" пины").setup_pin("pwm", config.get("my_pin"))`. Полученным объектом можно управлять во время выполнения программы.
* Если объект принтера определяет метод `get_status()`, то модуль может экспортировать [информацию о состоянии](Status_Reference.md) через [макросы](Command_Templates.md) и через [API Server](API_Server.md). Метод `get_status()` должен возвращать словарь Python с ключами, которые являются строками, и значениями, которые являются целыми числами, плавающими числами, строками, списками, словарями, True, False или None. Также могут использоваться кортежи (и именованные кортежи) (они отображаются как списки при доступе через API-сервер). Экспортируемые списки и словари должны рассматриваться как "неизменяемые" - если их содержимое меняется, то из `get_status()` должен быть возвращен новый объект, иначе сервер API не обнаружит этих изменений.
* Если модулю нужен доступ к системному таймеру или внешним файловым дескрипторам, то используйте `printer.get_reactor()` для получения доступа к глобальному классу "реактор событий". Этот класс реактора позволяет планировать таймеры, ожидать ввода файловых дескрипторов и "усыплять" код хоста.
* Не используйте глобальные переменные. Все состояние должно храниться в объекте принтера, возвращаемом функцией `load_config()`. Это важно, поскольку в противном случае команда RESTART может не сработать так, как ожидалось. Также, по аналогичным причинам, если открыты какие-либо внешние файлы (или сокеты), не забудьте зарегистрировать обработчик события "klippy:disconnect" и закрыть их из этого обратного вызова.
* Избегайте обращаться к внутренним переменным-членам (или вызывать методы, начинающиеся с символа подчеркивания) других объектов принтера. Соблюдение этого правила облегчает управление будущими изменениями.
* Рекомендуется присваивать значение всем переменным-членам в конструкторе Python классов Python. (И таким образом избегать использования способности Python динамически создавать новые переменные-члены)
* Если переменная Python должна хранить значение с плавающей точкой, то рекомендуется всегда присваивать переменной константы с плавающей точкой (и никогда не использовать константы с целыми числами). Например, предпочтите `self.speed = 1.`, а не `self.speed = 1`, и предпочтите `self.speed = 2. * x` вместо `self.speed = 2 * x`. Последовательное использование значений с плавающей точкой позволяет избежать трудноотлаживаемых причуд в преобразованиях типов в Python.
* Если вы отправляете модуль для включения в основной код Klipper, не забудьте поместить уведомление об авторских правах в верхней части модуля. Предпочтительный формат см. в существующих модулях.

## Добавление новой кинематики

В этом разделе приведены некоторые советы по добавлению в Klipper поддержки дополнительных типов кинематики принтера. Этот вид деятельности требует отличного понимания математических формул для целевой кинематики. Для этого также требуются навыки разработки программного обеспечения, хотя необходимо лишь обновить программное обеспечение хоста.

Полезные шаги:

1. Начните с изучения раздела "[code flow of a move](#code-flow-of-a-move-command)" и документа [Kinematics](Kinematics.md).
1. Просмотрите существующие классы кинематики в каталоге klippy/kinematics/. Задача кинематических классов - преобразовать движение в картезианских координатах в движение на каждом шаге. В качестве отправной точки можно скопировать один из этих файлов.
1. Реализуйте функции кинематической позиции шагового механизма на языке C для каждого шагового механизма, если они еще не доступны (см. kin_cart.c, kin_corexy.c и kin_delta.c в klippy/chelper/). Функция должна вызывать `move_get_coord()` для преобразования заданного времени перемещения (в секундах) в картезианскую координату (в миллиметрах), а затем вычислять желаемую позицию шагового механизма (в миллиметрах) по этой картезианской координате.
1. Реализуйте метод `calc_position()` в новом классе кинематики. Этот метод вычисляет положение головки инструмента в картезианских координатах из положения каждого шагового механизма. Он не должен быть эффективным, так как обычно вызывается только во время операций наведения и зондирования.
1. Other methods. Implement the `check_move()`, `get_status()`, `get_steppers()`, `home()`, `clear_homing_state()`, and `set_position()` methods. These functions are typically used to provide kinematic specific checks. However, at the start of development one can use boiler-plate code here.
1. Реализуйте тестовые случаи. Создайте файл g-кода с серией движений, которые могут проверить важные случаи для заданной кинематики. Следуя [документации по отладке](Debugging.md), преобразуйте этот файл g-кода в команды микроконтроллера. Это полезно для отработки угловых ситуаций и проверки регрессий.

## Перенос на новый микроконтроллер

В этом разделе приведены некоторые советы по переносу кода микроконтроллера Klipper на новую архитектуру. Этот вид деятельности требует хороших знаний в области разработки встраиваемых систем и практического доступа к целевому микроконтроллеру.

Полезные шаги:

1. Начните с определения библиотек сторонних производителей, которые будут использоваться при переносе. Обычные примеры - обертки "CMSIS" и библиотеки производителя "HAL". Весь код сторонних разработчиков должен быть совместим с GNU GPLv3. Код сторонних разработчиков должен быть зафиксирован в каталоге lib/ Klipper. Обновите файл lib/README с информацией о том, где и когда была получена библиотека. Предпочтительно скопировать код в репозиторий Klipper без изменений, но если требуются какие-либо изменения, то эти изменения должны быть явно указаны в файле lib/README.
1. Создайте новый подкаталог архитектуры в каталоге src/ и добавьте начальную поддержку Kconfig и Makefile. Используйте существующие архитектуры в качестве руководства. В src/simulator приведен базовый пример минимальной отправной точки.
1. Первая основная задача кодирования - обеспечить поддержку связи с целевой платой. Это самый сложный шаг в создании нового порта. Как только базовая связь заработает, остальные шаги станут намного проще. Как правило, на начальном этапе разработки используется последовательное устройство типа UART, так как эти типы аппаратных устройств обычно легче включать и контролировать. На этом этапе активно используйте вспомогательный код из каталога src/generic/ (проверьте, как src/simulator/Makefile включает в сборку общий C-код). Также на этом этапе необходимо определить функцию timer_read_time() (которая возвращает текущие системные часы), но нет необходимости полностью поддерживать обработку таймерных irq.
1. Познакомьтесь с инструментом console.py (как описано в документе [Отладка](Debugging.md)) и проверьте с его помощью связь с микроконтроллером. Этот инструмент переводит низкоуровневый протокол связи микроконтроллера в удобочитаемую форму.
1. Добавьте поддержку диспетчеризации таймера из аппаратных прерываний. См. Klipper [commit 970831ee](https://github.com/Klipper3d/klipper/commit/970831ee0d3b91897196e92270d98b2a3067427f) в качестве примера шагов 1-5, выполненных для архитектуры LPC176x.
1. Обеспечьте поддержку базовых входов и выходов GPIO. В качестве примера смотрите Klipper [commit c78b9076](https://github.com/Klipper3d/klipper/commit/c78b90767f19c9e8510c3155b89fb7ad64ca3c54).
1. Поднимите дополнительные периферийные устройства - например, смотрите Klipper commit [65613aed](https://github.com/Klipper3d/klipper/commit/65613aeddfb9ef86905cb1dade9e773a02ef3c27), [c812a40a](https://github.com/Klipper3d/klipper/commit/c812a40a3782415e454b04bf7bd2158a6f0ec8b5) и [c381d03a](https://github.com/Klipper3d/klipper/commit/c381d03aad5c3ee761169b7c7bced519cc14da29).
1. Создайте примерный файл конфигурации Klipper в каталоге config/. Протестируйте микроконтроллер с помощью основной программы klippy.py.
1. Рассмотрите возможность добавления тестовых примеров сборки в каталог test/.

Дополнительные советы по кодированию:

1. Избегайте использования "битовых полей C" для доступа к регистрам ввода-вывода; предпочитайте прямые операции чтения и записи 32-битных, 16-битных или 8-битных целых чисел. В спецификациях языка C нет четких указаний на то, как компилятор должен реализовывать битовые поля C (например, концевые значения и расположение битов), и трудно определить, какие операции ввода-вывода будут выполняться при чтении или записи битового поля C.
1. Предпочтите запись явных значений в регистры ввода-вывода вместо использования операций чтения-модификации-записи. То есть при обновлении поля в регистре ввода-вывода, где остальные поля имеют известные значения, предпочтительнее явно записать полное содержимое регистра. При явной записи код получается меньше, быстрее и легче отлаживается.

## Системы координат

Внутри Klipper в основном отслеживает положение головки инструмента в картезианских координатах, которые относятся к системе координат, указанной в файле конфигурации. То есть большая часть кода Klipper никогда не будет сталкиваться с изменением системы координат. Если пользователь делает запрос на изменение начала координат (например, команда `G92`), то этот эффект достигается путем перевода будущих команд в первичную систему координат.

Однако в некоторых случаях полезно получить положение головки инструмента в другой системе координат, и в Klipper есть несколько инструментов для облегчения этой задачи. Это можно увидеть, выполнив команду GET_POSITION. Например:

```
Отправить: GET_POSITION
Передача: // mcu: stepper_a:-2060 stepper_b:-1169 stepper_c:-1613
Recv: // stepper: stepper_a:457.254159 stepper_b:466.085669 stepper_c:465.382132
Recv: // кинематика: X:8.339144 Y:-3.131558 Z:233.347121
Recv: // головка инструмента: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode: X:8.338078 Y:-3.123175 Z:233.347878 E:0.000000
Recv: // gcode база: X:0.000000 Y:0.000000 Z:0.000000 E:0.000000
Recv: // gcode самонаведение: X:0.000000 Y:0.000000 Z:0.000000
```

Позиция "mcu" (`stepper.get_mcu_position()` в коде) - это общее количество шагов, выполненных микроконтроллером в положительном направлении, минус количество шагов, выполненных в отрицательном направлении с момента последнего сброса микроконтроллера. Если робот находится в движении в момент выдачи запроса, то сообщаемое значение включает в себя перемещения, буферизованные на микроконтроллере, но не включает перемещения, находящиеся в очереди ожидания.

Позиция "степпера" (`stepper.get_commanded_position()`) - это позиция данного степпера, отслеживаемая кодом кинематики. Обычно это соответствует положению (в мм) каретки вдоль ее рельса, относительно position_endstop, указанного в файле конфигурации. (Некоторые кинематики отслеживают положение шагов в радианах, а не в миллиметрах). Если робот находится в движении в момент выдачи запроса, то сообщаемое значение включает движения, буферизованные на микроконтроллере, но не включает движения, находящиеся в очереди look-ahead. Чтобы полностью промыть код look-ahead и генерации шагов, можно использовать вызовы `toolhead.flush_step_generation()` или `toolhead.wait_moves()`.

Кинематическая" позиция (`kin.calc_position()`) - это картезианская позиция головки инструмента, полученная из "шаговых" позиций и относящаяся к системе координат, указанной в файле конфигурации. Это положение может отличаться от запрашиваемого декартова положения из-за гранулярности шаговых двигателей. Если робот находится в движении в момент получения "шаговых" позиций, то сообщаемое значение включает перемещения, буферизованные на микроконтроллере, но не включает перемещения, находящиеся в очереди look-ahead. Для полной очистки кода look-ahead и генерации шагов можно использовать вызовы `toolhead.flush_step_generation()` или `toolhead.wait_moves()`.

Позиция "головки инструмента" (`toolhead.get_position()`) - это последнее запрошенное положение головки инструмента в декартовых координатах относительно системы координат, указанной в файле конфигурации. Если робот находится в движении в момент выдачи запроса, то сообщаемое значение включает все запрошенные перемещения (даже те, которые находятся в буферах и ожидают выдачи драйверам шаговых двигателей).

Позиция "gcode" - это последняя запрошенная позиция из команды `G1` (или `G0`) в декартовых координатах относительно системы координат, указанной в файле конфигурации. Это положение может отличаться от положения "головки инструмента", если действует трансформация g-кода (например, bed_mesh, bed_tilt, skew_correction). Это может отличаться от фактических координат, указанных в последней команде `G1`, если начало g-кода было изменено (например, `G92`, `SET_GCODE_OFFSET`, `M221`). Команда `M114` (`gcode_move.get_status()['gcode_position']`) сообщит последнюю позицию g-кода относительно текущей системы координат g-кода.

База gcode" - это местоположение начала g-кода в картезианских координатах относительно системы координат, указанной в файле конфигурации. Команды `G92`, `SET_GCODE_OFFSET` и `M221` изменяют это значение.

"gcode homing" - это местоположение, которое будет использоваться для начала g-кода (в картезианских координатах относительно системы координат, указанной в файле конфигурации) после выполнения команды `G28` home. Команда `SET_GCODE_OFFSET` может изменить это значение.

## Время

Основой работы Klipper является работа с часами, временем и временными метками. Klipper выполняет действия на принтере, планируя события, которые должны произойти в ближайшем будущем. Например, чтобы включить вентилятор, код может запланировать изменение пина GPIO через 100 мс. Редко когда код пытается выполнить действие мгновенно. Таким образом, обработка времени в Klipper является критически важной для правильной работы.

Существует три типа времени, отслеживаемых внутри программного обеспечения Klipper:

* Системное время. Системное время использует монотонные часы системы - это число с плавающей точкой, хранящееся в виде секунд, и оно (как правило) относится к моменту последнего запуска компьютера. Системное время имеет ограниченное применение в программном обеспечении - в основном оно используется при взаимодействии с операционной системой. В коде хоста системное время часто хранится в переменных с именами *eventtime* или *curtime*.
* Время печати. Время печати синхронизируется с часами главного микроконтроллера (микроконтроллер определен в разделе конфигурации "[mcu]"). Это число с плавающей запятой, хранящееся в секундах и относящееся к моменту последнего перезапуска основного микроконтроллера. Можно преобразовать "время печати" в аппаратные часы главного микроконтроллера, умножив время печати на статически настроенную частоту mcu. Высокоуровневый код хоста использует время печати для расчета почти всех физических действий (например, перемещения головки, изменения нагревателя и т. д.). В коде хоста время печати обычно хранится в переменных с именами *print_time* или *move_time*.
* Часы MCU. Это аппаратный счетчик тактовых импульсов на каждом микроконтроллере. Он хранится как целое число, и частота его обновления зависит от частоты данного микроконтроллера. Программное обеспечение хоста переводит свое внутреннее время в часы перед передачей в микроконтроллер. Код mcu отслеживает время только в тактах. В коде хоста значения часов отслеживаются как 64-битные целые числа, в то время как код mcu использует 32-битные целые числа. В коде хоста часы обычно хранятся в переменных с именами, содержащими *clock* или *ticks*.

Преобразование между различными форматами времени в основном реализовано в коде **klippy/clocksync.py**.

Некоторые моменты, на которые следует обратить внимание при просмотре кода:

* 32-битные и 64-битные часы: Для уменьшения пропускной способности и повышения эффективности микроконтроллера часы на микроконтроллере отслеживаются как 32-битные целые числа. При сравнении двух часов в коде mcu всегда должна использоваться функция `timer_is_before()`, чтобы обеспечить правильную обработку целочисленных переносов. Хост-программа преобразует 32-битные часы в 64-битные, добавляя старшие биты из последней полученной mcu временной метки - ни одно сообщение от mcu никогда не находится более чем на 2^31 такта в будущем или прошлом, поэтому такое преобразование никогда не будет неоднозначным. Хост преобразует 64-битные часы в 32-битные, просто обрезая старшие биты. Чтобы гарантировать отсутствие двусмысленности в этом преобразовании, код **klippy/chelper/serialqueue.c** будет буферизировать сообщения до тех пор, пока они не окажутся в пределах 2^31 такта от целевого времени.
* Несколько микроконтроллеров: Программное обеспечение хоста поддерживает использование нескольких микроконтроллеров на одном принтере. В этом случае "часы MCU" каждого микроконтроллера отслеживаются отдельно. Код clocksync.py справляется с дрейфом часов между микроконтроллерами, изменяя способ преобразования из "времени печати" в "часы MCU". На вторичных mcus частота микроконтроллера, используемая в этом преобразовании, регулярно обновляется для учета измеренного дрейфа.
