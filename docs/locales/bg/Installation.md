# Инсталация

Тези инструкции предполагат, че софтуерът ще работи на линукс базиран хост със съвместим с Klipper Front End. Препоръчително е за хост машина да се използва SBC(Small Board Computer), като Raspberry Pi или устройство, базирано на Debian Linux (вижте [FAQ](FAQ.md#can-i-run-klipper-on-something-other-than-a-raspberry-pi-3) за други възможности).

За целите на тези инструкции хостът се отнася за устройството Linux, а mcu - за печатната платка. SBC се отнася до термина Small Board Computer, като например Raspberry Pi.

## Получаване на конфигурационен файл на Klipper

Повечето настройки на Klipper се определят от "файл за конфигурация на принтера" printer.cfg, който се съхранява на хоста. Подходящият конфигурационен файл често може да бъде намерен, като се потърси в Klipper [config directory](../config/) за файл, започващ с префикс "printer-", който съответства на целевия принтер. Конфигурационният файл на Klipper съдържа техническа информация за принтера, която ще бъде необходима по време на инсталацията.

Ако в директорията config на Klipper няма подходящ файл за конфигурация на принтера, опитайте се да потърсите на уебсайта на производителя на принтера, за да видите дали има подходящ файл за конфигурация на Klipper.

Ако не може да бъде намерен конфигурационен файл за принтера, но е известен типът на платката за управление на принтера, тогава потърсете подходящ [конфигурационен файл](../config/), започващ с префикс "generic-". Тези примерни файлове за платките на принтера би трябвало да позволят успешно завършване на първоначалната инсталация, но ще изискват някои настройки, за да се получи пълна функционалност на принтера.

Възможно е също така да дефинирате нова конфигурация на принтера от нулата. Това обаче изисква значителни технически познания за принтера и неговата електроника. Препоръчително е повечето потребители да започнат с подходящ конфигурационен файл. Ако създавате нов потребителски конфигурационен файл за принтер, започнете с най-близкия примерен [config file](../config/) и използвайте Klipper [config reference](Config_Reference.md) за допълнителна информация.

## Взаимодействие с Klipper

Klipper е фърмуер за 3D принтер, така че се нуждае от някакъв начин, по който потребителят да взаимодейства с него.

Понастоящем най-добрият избор са фронтовете, които извличат информация чрез [Moonraker web API](https://moonraker.readthedocs.io/), а също така има възможност да се използва [Octoprint](https://octoprint.org/) за управление на Klipper.

Потребителят може да избере какво да използва, но основният Klipper е един и същ във всички случаи. Препоръчваме на потребителите да проучат наличните възможности и да вземат информирано решение.

## Получаване на образ на операционната система за SBC

Има много начини за получаване на образ на операционната система Klipper за използване в SBC, повечето от които зависят от това какъв фронт енд искате да използвате. Някои производители на тези SBC платки също предоставят свои собствени образи, ориентирани към Klipper.

Двата основни фронт енда, базирани на Moonraker, са [Fluidd](https://docs.fluidd.xyz/) и [Mainsail](https://docs.mainsail.xyz/), последният от които има предварително подготвено инсталационно изображение ["MainsailOS"](http://docs.mainsailOS.xyz), което има опция за Raspberry Pi и някои варианти на OrangePi.

Fluidd може да се инсталира чрез KIAUH (Klipper Install And Update Helper), който е обяснен по-долу и представлява инсталатор от трета страна за всичко, свързано с Klipper.

OctoPrint може да бъде инсталиран чрез популярния образ OctoPi или чрез KIAUH, този процес е обяснен в <OctoPrint.md>

## Инсталиране чрез KIAUH

Обикновено започвате с базово изображение за вашия SBC, например RPiOS Lite, или в случай на устройство с x86 Linux - Ubuntu Server. Обърнете внимание, че вариантите Desktop не се препоръчват поради някои помощни програми, които могат да спрат работата на някои функции на Klipper и дори да маскират достъпа до някои печатни платки.

KIAUH може да се използва за инсталиране на Klipper и свързаните с него програми на различни системи, базирани на Linux, които работят под формата на Debian. Повече информация можете да намерите на адрес https://github.com/dw-0/kiauh

## Изграждане и мигане на микроконтролера

За да компилирате кода на микроконтролера, започнете с изпълнението на тези команди на вашето хост устройство:

```
cd ~/klipper/
make menuconfig
```

Коментарите в горната част на файла [конфигурация на принтера](#obtain-a-klipper-configuration-file) трябва да описват настройките, които трябва да бъдат зададени по време на "make menuconfig". Отворете файла в уеб браузър или текстов редактор и потърсете тези инструкции близо до горната част на файла. След като конфигурирате съответните настройки на "menuconfig", натиснете "Q", за да излезете, и след това "Y", за да запазите. След това стартирайте:

```
make
```

Ако коментарите в горната част на файла [конфигурация на принтера](#obtain-a-klipper-configuration-file) описват персонализирани стъпки за "проблясване" на крайното изображение на контролната платка на принтера, следвайте тези стъпки и след това преминете към [конфигуриране на OctoPrint](#configuring-octoprint-to-use-klipper).

В противен случай често се използват следните стъпки за "флашване" на контролната платка на принтера. Първо е необходимо да се определи серийният порт, свързан с микроконтролера. Изпълнете следното:

```
ls /dev/serial/by-id/*
```

Тя трябва да отчете нещо подобно на следното:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Обикновено всеки принтер има свое собствено уникално име на сериен порт. Това уникално име ще се използва при флашването на микроконтролера. Възможно е в горния изход да има няколко реда - ако е така, изберете реда, съответстващ на микроконтролера. Ако са изброени много елементи и изборът е двусмислен, изключете платката и изпълнете командата отново, като липсващият елемент ще бъде вашата печатна платка(за повече информация вижте [FAQ](FAQ.md#wheres-my-serial-port)).

За обикновените микроконтролери със STM32 или клонирани чипове, LPC чипове и други е обичайно те да се нуждаят от първоначална флаш памет на Klipper чрез SD карта.

При мигане с този метод е важно да се уверите, че печатната платка не е свързана с USB към хоста, тъй като някои платки могат да подават енергия обратно към платката и да спрат мигането.

За обикновените микроконтролери, използващи чипове Atmega, например 2560, кодът може да се флашне с нещо подобно:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Не забравяйте да актуализирате FLASH_DEVICE с уникалното име на серийния порт на принтера.

За обикновените микроконтролери, използващи чипове RP2040, кодът може да бъде променен с нещо подобно на:

```
sudo service klipper stop
make flash FLASH_DEVICE=first
sudo service klipper start
```

Важно е да се отбележи, че преди тази операция може да се наложи чиповете RP2040 да бъдат въведени в режим на зареждане.

## Конфигуриране на Klipper

Следващата стъпка е да копирате [конфигурационния файл на принтера](#obtain-a-klipper-configuration-file) на хоста.

Вероятно най-лесният начин за задаване на конфигурационния файл на Klipper е да използвате вградените редактори в Mainsail или Fluidd. Те ще позволят на потребителя да отвори конфигурационните примери и да ги запише като printer.cfg.

Друга възможност е да използвате настолен редактор, който поддържа редактиране на файлове чрез протоколите "scp" и/или "sftp". Съществуват свободно достъпни инструменти, които поддържат това (например Notepad++, WinSCP и Cyberduck). Заредете файла с конфигурацията на принтера в редактора и след това го запишете като файл с име "printer.cfg" в домашната директория на потребителя на pi (т.е. /home/pi/printer.cfg).

Освен това можете да копирате и редактирате файла директно на хоста чрез ssh. Това може да изглежда по следния начин (не забравяйте да актуализирате командата, за да използвате съответното име на файла с конфигурацията на принтера):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

Обичайно е всеки принтер да има свое собствено уникално име за микроконтролера. Името може да се промени след флашването на Klipper, така че повторете тези стъпки отново, дори ако те вече са били извършени при флашването. Изпълнете:

```
ls /dev/serial/by-id/*
```

Тя трябва да отчете нещо подобно на следното:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

След това актуализирайте файла с конфигурацията с уникалното име. Например актуализирайте раздела `[mcu]`, за да изглежда по следния начин:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

След като създадете и редактирате файла, ще е необходимо да издадете команда "restart" в командната конзола, за да заредите конфигурацията. Командата "статус" ще съобщи, че принтерът е готов, ако конфигурационният файл на Klipper е прочетен успешно и микроконтролерът е намерен и конфигуриран успешно.

При персонализиране на конфигурационния файл на принтера нерядко Klipper съобщава за грешка в конфигурацията. Ако възникне грешка, направете необходимите корекции в конфигурационния файл на принтера и издайте "restart", докато "status" отчете, че принтерът е готов.

Klipper съобщава съобщения за грешки чрез командната конзола и чрез изскачащи прозорци в Fluidd и Mainsail. Командата "статус" може да се използва за повторно съобщаване на съобщения за грешки. Наличен е дневник, който обикновено се намира в ~/printer_data/logs и се нарича klippy.log

След като Klipper съобщи, че принтерът е готов, преминете към документа [config check document](Config_checks.md), за да извършите някои основни проверки на дефинициите в конфигурационния файл. За друга информация вижте основния документ [documentation reference](Overview.md).
