# OctoPrint для кліппера

Klipper має кілька варіантів для своїх передніх кінців, Octoprint був першим і оригінальним переднім кінцем для Klipper. Цей документ дасть короткий огляд установки з цим варіантом.

## Встановлення з OctoPi

Почати установку [OctoPi](https://github.com/guysoft/OctoPi) на Raspberry Pi комп'ютер. Використовуйте OctoPi v0.17.0 або пізніше - див. [OctoPi релізи](https://github.com/guysoft/OctoPi/випуски) для отримання інформації.

Ви можете перевірити, що завантаження OctoPi і що працює на сервері OctoPrint. Після підключення до веб-сторінки OctoPrint слідувати за запитом, щоб оновити OctoPrint, якщо це необхідно.

Після установки OctoPi і оновлення OctoPrint, потрібно буде заштовхуватися в цільову машину, щоб запустити зручний системних команд.

Після запуску цих команд на вашому пристрої хост:

**Якщо ви не встановили git, будь ласка, з:**

```
sudo apt встановити git
```

далі:

```
з
git клон https://github.com/Klipper3d/klipper
JavaScript licenses API Веб-сайт Go1.13.8
```

Завантажуйте Klipper, встановіть потрібні залежності системи, налаштуйте Klipper для запуску системи та запустіть програмне забезпечення Klipper. Задовольнить підключення до Інтернету і може зайняти декілька хвилин.

## Установка КІАУХ

KIAUH може використовуватися для установки OctoPrint на різних Linux базових системах, які виконують форму Debian. Більше інформації можна знайти на https://github.com/dw-0/kiauh

## Налаштування OctoPrint для використання Klipper

Веб-сервер OctoPrint повинен бути налаштований для спілкування з програмним забезпеченням Klipper. Використання веб-браузера, логіна на веб-сторінку OctoPrint, а потім налаштовувати такі елементи:

Навігація на вкладку «Налаштування». Під "Серійне підключення" в "Додаткові серійні порти" додати:

```
~/printer_data/comms/klippy.serial
```

Потім натисніть "Зберегти".

*У деяких старих налаштуваннях ця адреса може бути `/tmp/printer`*

Введіть вкладку Параметри знову і під параметром "Серійне підключення" змінити параметр "Серійний порт" додано вище.

У вкладці «Налаштування», навігація на субтаб «Бегавіор» і виберіть пункт «Перевірити будь-які поточні принти, але залишайтеся підключеними до принтера». Натисніть "Зберегти".

З головної сторінки в розділі «Підключення» (вгорі зліва від сторінки) переконайтеся, що «Серійний порт» встановлюється на новий додатковий доданий і натисніть кнопку «Підключення». (Якщо це не в доступний вибір, то спробуйте перезавантажити сторінку.)

Після підключення навігація до вкладки «Terminal» та типу «статус» (без лапок) в поле введення команди та натисніть кнопку «Зберегти». Вікно терміналу, швидше за все, повідомляється, що є помилка відкриття файлу налаштування - це означає, що OctoPrint успішно спілкується з Klipper.

Будь ласка, перейдіть до <Installation.md> і розділу *Створення та прошивка мікроконтролера*
