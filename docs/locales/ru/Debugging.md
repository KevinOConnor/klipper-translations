# Отладка

В этом документе описаны некоторые инструменты отладки Klipper.

## Запуск регрессионных тестов

Основной репозиторий Klipper на GitHub использует "github actions" для запуска серии регрессионных тестов. Может быть полезно запускать некоторые из этих тестов локально.

Исходный код "Проверка пробельных символов" можно запустить с помощью:

```
./scripts/check_whitespace.sh
```

Набор регрессионных тестов Klippy требует "словарей данных" со многих платформ. Самый простой способ получить их - [скачать с github](https://github.com/Klipper3d/klipper/issues/1438). После загрузки словарей данных запустите регрессионный набор следующим образом:

```
tar xfz klipper-dict-20??????.tar.gz
~/klippy-env/bin/python ~/klipper/scripts/test_klippy.py -d dict/ ~/klipper/test/klippy/*.test
```

## Ручная отправка команд на микроконтроллер

Обычно для преобразования команд gcode в команды микроконтроллера Klipper используется процесс klippy.py. Однако можно и вручную отправить эти команды MCU (функции, отмеченные макросом DECL_COMMAND() в исходном коде Klipper). Для этого выполните команду:

```
~/klippy-env/bin/python ./klippy/console.py /tmp/pseudoserial
```

Дополнительную информацию о функциях инструмента можно найти в команде " ПОМОЩЬ ".

Доступны некоторые параметры командной строки. Для получения дополнительной информации выполните команду: `~/klippy-env/bin/python ./klippy/console.py --help`

## Преобразование файлов gcode в команды микроконтроллера

Код хоста Klippy может выполняться в пакетном режиме для создания низкоуровневых команд микроконтроллера, связанных с файлом gcode. Проверка этих низкоуровневых команд полезна при попытке понять действия низкоуровневого оборудования. Также может быть полезно сравнить разницу в командах микроконтроллера после изменения кода.

Чтобы запустить Klippy в этом пакетном режиме, необходим один временной шаг для создания "словаря данных" микроконтроллера. Это делается путем компиляции кода микроконтроллера для получения файла **out/klipper.dict**:

```
make menuconfig
make
```

После выполнения этих действий можно запускать Klipper в пакетном режиме (шаги, необходимые для создания виртуальной среды python и файла printer.cfg, см. в [installation](Installation.md)):

```
~/klippy-env/bin/python ./klippy/klippy.py ~/printer.cfg -i test.gcode -o test.serial -v -d out/klipper.dict
```

В результате выполнения этих действий будет создан файл **test.serial** с двоичным последовательным выводом. Этот вывод может быть переведен в читаемый текст с помощью:

```
~/klippy-env/bin/python ./klippy/parsedump.py out/klipper.dict test.serial > test.txt
```

Результирующий файл **test.txt** содержит человекочитаемый список команд микроконтроллера.

Пакетный режим отключает определенные команды ответа/запроса, чтобы функционировать. В результате будут наблюдаться некоторые различия между фактическими командами и приведенными выше выходными данными. Сгенерированные данные полезны для тестирования и проверки; они не годятся для отправки в реальный микроконтроллер.

## Анализ движений и регистрация данных

Klipper поддерживает запись в журнал внутренней истории движения, которую впоследствии можно проанализировать. Чтобы использовать эту функцию, Klipper должен быть запущен с включенным [API Server](API_Server.md).

Регистрация данных включается с помощью инструмента `data_logger.py`. Например:

```
~/klipper/scripts/motan/data_logger.py /tmp/klippy_uds mylog
```

Эта команда подключается к API-серверу Klipper, подписывается на информацию о состоянии и движении и записывает результаты в журнал. При этом генерируются два файла - сжатый файл данных и индексный файл (например, `mylog.json.gz` и `mylog.index.gz`). После запуска логирования можно завершить печать и другие действия - логирование будет продолжаться в фоновом режиме. После завершения протоколирования нажмите `ctrl-c` для выхода из инструмента `data_logger.py`.

Полученные файлы можно прочитать и построить графики с помощью инструмента `motan_graph.py`. Для создания графиков на Raspberry Pi необходимо один раз установить пакет matplotlib:

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Однако, возможно, будет удобнее скопировать файлы данных на машину настольного класса вместе с кодом Python в директорию `scripts/motan/`. Сценарии анализа движения должны выполняться на любой машине с установленной последней версией [Python](https://python.org) и [Matplotlib](https://matplotlib.org/).

Графики можно построить с помощью следующей команды:

```
~/klipper/scripts/motan/motan_graph.py mylog -o mygraph.png
```

Можно использовать опцию `-g`, чтобы указать наборы данных для построения графика (она принимает Python-литерал, содержащий список списков). Например:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)"], ["trapq(toolhead,accel)"]]'
```

Список доступных наборов данных можно найти с помощью опции `-l` - например:

```
~/klipper/scripts/motan/motan_graph.py -l
```

Также можно указать параметры графиков matplotlib для каждого набора данных:

```
~/klipper/scripts/motan/motan_graph.py mylog -g '[["trapq(toolhead,velocity)?color=red&alpha=0.4"]]'
```

Доступно множество опций matplotlib; некоторые примеры - " цвет", "метка", "альфа" и "стиль линии".

Инструмент `motan_graph.py` поддерживает несколько других опций командной строки - используйте опцию `--help` для просмотра списка. Также может быть удобно просматривать/изменять сам скрипт [motan_graph.py](../scripts/motan/motan_graph.py).

Журналы необработанных данных, создаваемые инструментом `data_logger.py`, имеют формат, описанный в [API Server](API_Server.md). Может оказаться полезным просмотреть данные с помощью Unix-команды, например, следующей: `gunzip < mylog.json.gz | tr '\03' '\n' | less`

## Создание графиков нагрузки

В файле журнала Klippy (/tmp/klippy.log) хранится статистика пропускной способности, загрузки микроконтроллера и загрузки буфера хоста. Может быть полезно построить график этой статистики после печати.

Чтобы сгенерировать график, необходимо установить пакет "matplotlib":

```
sudo apt-get update
sudo apt-get install python-matplotlib
```

Затем можно построить графики:

```
~/klipper/scripts/graphstats.py /tmp/klippy.log -o loadgraph.png
```

Затем можно просмотреть полученный файл **loadgraph.png**.

Могут быть получены различные графики. Для получения дополнительной информации выполните команду: `~/klipper/scripts/graphstats.py --help`

## Извлечение информации из файла klippy.log

Файл журнала Klippy (/tmp/klippy.log) также содержит отладочную информацию. Существует скрипт logextract.py, который может быть полезен при анализе отключения микроконтроллера или других подобных проблем. Обычно его запускают с такими словами, как:

```
mkdir work_directory
cd work_directory
cp /tmp/klippy.log .
~/klipper/scripts/logextract.py ./klippy.log
```

Сценарий извлечет файл конфигурации принтера и информацию о выключении MCU. Дампы информации о выключении MCU (если они присутствуют) будут упорядочены по временной метке, что поможет в диагностике причинно-следственных связей.

## Тестирование с помощью симулятора

Инструмент [simulavr](http://www.nongnu.org/simulavr/) позволяет моделировать микроконтроллер Atmel ATmega. В этом разделе описывается, как можно запускать тестовые gcode-файлы через simulavr. Рекомендуется запускать эту программу на машине настольного класса (не на Raspberry Pi), поскольку для ее эффективной работы требуется значительное количество процессора.

Чтобы использовать simulavr, загрузите пакет simulavr и скомпилируйте его с поддержкой python. Обратите внимание, что для сборки модуля python в системе сборки могут быть установлены некоторые пакеты (например, swig).

```
git clone git://git.savannah.nongnu.org/simulavr.git
cd simulavr
make python
make build
```

Убедитесь, что после вышеуказанной компиляции присутствует файл вида: **./build/pysimulavr/_pysimulavr.*.so**

```
ls ./build/pysimulavr/_pysimulavr.*.so
```

Эта команда должна сообщить о конкретном файле (например, **./build/pysimulavr/_pysimulavr.cpython-39-x86_64-linux-gnu.so**), а не об ошибке.

Если вы работаете в системе на базе Debian (Debian, Ubuntu и т.д.), вы можете установить следующие пакеты и сгенерировать файлы *.deb для установки simulavr в масштабах всей системы:

```
sudo apt update
sudo apt install g++ make cmake swig rst2pdf help2man texinfo
make cfgclean python debian
sudo dpkg -i build/debian/python3-simulavr*.deb
```

Чтобы скомпилировать Klipper для использования в симуляторе, выполните команду:

```
cd /path/to/klipper
make menuconfig
```

скомпилируйте программное обеспечение микроконтроллера для AVR atmega644p и выберите поддержку программной эмуляции SIMULAVR. Затем можно скомпилировать Klipper (запустить `make`) и запустить моделирование с помощью:

```
PYTHONPATH=/path/to/simulavr/build/pysimulavr/ ./scripts/avrsim.py out/klipper.elf
```

Обратите внимание, что если вы установили python3-simulavr по всей системе, вам не нужно задавать `PYTHONPATH`, и вы можете просто запустить симулятор как

```
./scripts/avrsim.py out/klipper.elf
```

Затем, запустив симулятор в другом окне, можно выполнить следующие действия, чтобы считать gcode из файла (например, "test.gcode"), обработать его с помощью Klippy и отправить в Klipper, запущенный в симуляторе (шаги, необходимые для создания виртуальной среды python, смотрите в [Установка](Installation.md)):

```
~/klippy-env/bin/python ./klippy/klippy.py config/generic-simulavr.cfg -i test.gcode -v
```

### Использование simulavr с gtkwave

Одной из полезных особенностей симулятора является его способность создавать файлы генерации волны сигнала с точным указанием времени событий. Для этого следуйте инструкциям выше, но запустите avrsim.py с помощью командной строки, как показано ниже:

```
PYTHONPATH=/path/to/simulavr/src/python/ ./scripts/avrsim.py out/klipper.elf -t PORTA.PORT,PORTC.PORT
```

Вышеописанное создаст файл **avrsim.vcd** с информацией о каждом изменении GPIO на PORTA и PORTB. Затем его можно просмотреть с помощью gtkwave:

```
gtkwave avrsim.vcd
```
