# Устранение неполадок CANBUS

Этот документ содержит информацию об исправлении проблем соединения, при использовании шины CAN [Klipper with CAN bus](CANBUS.md).

## Проверьте правильность подключения проводников шины CAN

Первым шагом в устранении проблем со связью является проверка проводки шины CAN.

Be sure there are exactly two 120 Ohm [terminating
resistors](CANBUS.md#terminating-resistors) on the CAN bus. If the resistors are not properly installed then messages may not be able to be sent at all or the connection may have sporadic instability.

Провода шин CANH и CANL должны быть скручены вокруг друг друга. Как минимум, проводка должна иметь скрутку через каждые несколько сантиметров. Избегайте скручивания проводов CANH и CANL вокруг силовых проводов и следите за тем, чтобы силовые провода, идущие параллельно проводам CANH и CANL, не имели одинакового количества скруток.

Убедитесь, что все штекеры и обжимки проводов на шине CAN полностью закреплены. Движение инструментальной головки принтера может привести к смещению проводки шины CAN, в результате чего плохой обжим провода или незакрепленный штекер могут привести к прерывистым ошибкам связи.

## Проверка на увеличение счетчика bytes_invalid

Лог-файл Klipper будет сообщать о строке `Stats` раз в секунду, когда принтер активен. Эти строки "Stats" будут содержать счетчик `bytes_invalid` для каждого микроконтроллера. Этот счетчик не должен увеличиваться во время нормальной работы принтера (нормально, если счетчик будет ненулевым после перезагрузки, и не страшно, если счетчик будет увеличиваться раз в месяц или около того). Если этот счетчик увеличивается на микроконтроллере шины CAN во время нормальной печати (он увеличивается каждые несколько часов или чаще), это свидетельствует о серьезной проблеме.

Увеличение `bytes_invalid` при подключении к шине CAN является симптомом неупорядоченных сообщений на шине CAN. Известны две причины возникновения неупорядоченных сообщений:

1. В старых версиях популярной прошивки candlight_firmware для USB CAN-адаптеров была обнаружена ошибка, которая могла привести к переупорядочиванию сообщений. Если вы используете USB CAN адаптер с этой прошивкой, то обязательно обновите ее до последней версии, если наблюдается увеличение `bytes_invalid`.
1. Известно, что некоторые сборки ядра Linux для встраиваемых устройств перестраивают сообщения шины CAN. Может потребоваться использование альтернативного ядра Linux или использование альтернативного оборудования, поддерживающего основные ядра Linux, в которых эта проблема не наблюдается.

Переупорядоченные сообщения - серьезная проблема, которую необходимо устранить. Она приводит к нестабильному поведению и может стать причиной ошибок на любом этапе печати.

## Используйте соответствующую настройку txqueuelen

Код Klipper использует ядро Linux для управления трафиком шины CAN. По умолчанию ядро ставит в очередь только 10 пакетов передачи данных CAN. Рекомендуется [сконфигурировать устройство can0](CANBUS.md#host-hardware) с `txqueuelen 128`, чтобы увеличить этот размер.

Если Klipper передаст пакет, а Linux заполнит все место в очереди на передачу, Linux отбросит этот пакет, и в журнале Klipper появятся сообщения, подобные следующему:

```
Получена ошибка -1 при записи: (105)Нет свободного места в буфере
```

Klipper автоматически повторно передаст потерянные сообщения в рамках своей обычной системы повторной передачи сообщений на уровне приложения. Таким образом, это сообщение журнала является предупреждением и не указывает на неустранимую ошибку.

Если произойдет полный отказ шины CAN (например, обрыв провода CAN), то Linux не сможет передавать сообщения по шине CAN, и обычно в журнале Klipper появляется вышеуказанное сообщение. В этом случае сообщение в журнале является симптомом более серьезной проблемы (невозможность передачи сообщений) и не имеет прямого отношения к Linux `txqueuelen`.

Проверить текущий размер очереди можно, выполнив команду Linux `ip link show can0`. Она должна выдать кучу текста, включая фрагмент `qlen 128`. Если вы увидите что-то вроде `qlen 10`, это указывает на то, что CAN-устройство не было правильно сконфигурировано.

Не рекомендуется использовать `txqueuelen` значительно больше 128. CAN-шине, работающей на частоте 1000000, обычно требуется около 120 с для передачи CAN-пакета. Таким образом, очередь из 128 пакетов, скорее всего, займет около 15-20 мс. Значительно большая очередь может привести к чрезмерным скачкам времени прохождения сообщений, что может привести к неустранимым ошибкам. С другой стороны, система ретрансляции приложений Klipper будет более надежной, если ей не придется ждать, пока Linux осушит слишком большую очередь, состоящую из, возможно, устаревших данных. Это аналогично проблеме [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) на интернет-маршрутизаторах.

В обычных условиях Klipper может использовать ~25 слотов очереди на MCU - обычно больше слотов используется только при повторной передаче. (В частности, хост Klipper может передать до 192 байт каждому MCU Klipper, прежде чем получит подтверждение от этого MCU). Если на одной шине CAN установлено 5 или более MCU Klipper, то может потребоваться увеличить `txqueuelen` выше рекомендуемого значения 128. Однако, как указано выше, при выборе нового значения следует соблюдать осторожность, чтобы избежать чрезмерных задержек при обходе.

## Получение журналов candump

Сообщения шины CAN, отправляемые в микроконтроллер и из него, обрабатываются ядром Linux. Можно перехватить эти сообщения из ядра для отладки. Журнал этих сообщений может быть полезен при диагностике.

Инструмент Linux [can-utils](https://github.com/linux-can/can-utils) обеспечивает программное обеспечение для захвата. Обычно она устанавливается на машину путем запуска:

```
sudo apt-get update && sudo apt-get install can-utils
```

После установки можно получить захват всех сообщений CAN-шины на интерфейсе с помощью следующей команды:

```
candump -tz -Ddex can0,#FFFFFFFF > mycanlog
```

Можно просмотреть полученный файл журнала (`mycanlog` в примере выше), чтобы увидеть каждое необработанное сообщение CAN-шины, которое было отправлено и получено Klipper. Для понимания содержания этих сообщений, скорее всего, потребуются знания низкого уровня протокола [CANBUS](CANBUS_protocol.md) и команд [MCU](MCU_Commands.md) Klipper.

### Разбор сообщений Klipper в журнале candump

Для разбора низкоуровневых сообщений микроконтроллера Klipper, содержащихся в журнале candump, можно использовать инструмент `parsecandump.py`. Использование этого инструмента является продвинутой темой, требующей знания Klipper [команд MCU](MCU_Commands.md). Например:

```
./scripts/parsecandump.py mycanlog 108 ./out/klipper.dict
```

This tool produces output similar to the [parsedump
tool](Debugging.md#translating-gcode-files-to-micro-controller-commands). See the documentation for that tool for information on generating the Klipper micro-controller data dictionary.

In the above example, `108` is the [CAN bus
id](CANBUS_protocol.md#micro-controller-id-assignment). It is a hexadecimal number. The id `108` is assigned by Klipper to the first micro-controller. If the CAN bus has multiple micro-controllers on it, then the second micro-controller would be `10a`, the third would be `10c`, and so on.

Для использования инструмента `parsecandump.py` необходимо создать журнал candump, используя аргументы командной строки `-tz -Ddex` (например: `candump -tz -Ddex can0,#FFFFFF`).

## Использование логического анализатора в проводке canbus

Программное обеспечение [Sigrok Pulseview](https://sigrok.org/wiki/PulseView) вместе с недорогим [логическим анализатором](https://en.wikipedia.org/wiki/Logic_analyzer) может быть полезно для диагностики сигналов шины CAN. Это сложная тема, которая может быть интересна только специалистам.

Часто можно найти "логические USB-анализаторы" по цене менее 15 долларов (цены в США по состоянию на 2023 год). Эти устройства часто перечисляются как "логические клоны Saleae" или как "24 МГц 8-канальные USB логические анализаторы".

![pulseview-canbus](img/pulseview-canbus.png)

Приведенная выше фотография была сделана при использовании Pulseview с логическим анализатором "клон Saleae". Программное обеспечение Sigrok и Pulseview было установлено на настольном компьютере (также установите прошивку "fx2lafw", если она поставляется отдельно). Вывод CH0 логического анализатора был подключен к линии CAN Rx, вывод CH1 - к выводу CAN Tx, а GND - к GND. Программа Pulseview была настроена на отображение только линий D0 и D1 (красный значок "зонда" в центре верхней панели инструментов). Количество выборок было установлено на 5 миллионов (верхняя панель инструментов), а частота выборки - на 24 МГц (верхняя панель инструментов). Был добавлен CAN-декодер (желто-зеленый значок "пузырька" справа вверху панели инструментов). Канал D0 был помечен как RX и настроен на срабатывание по спадающему фронту импульса (нажмите на черную метку D0 слева). Канал D1 был помечен как TX (нажмите на коричневую метку D1 слева). Декодер CAN был настроен на скорость 1 Мбит (нажмите на зеленую метку CAN слева). CAN-декодер был перемещен в верхнюю часть дисплея (нажмите и перетащите зеленую метку CAN). Наконец, был запущен захват (нажмите "Run" в левом верхнем углу) и передан пакет по шине CAN (`cansend can0 123#121212121212`).

Логический анализатор представляет собой независимый инструмент для захвата пакетов и проверки временных характеристик битов.
