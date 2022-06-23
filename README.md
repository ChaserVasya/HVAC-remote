# HVAC-remote

Данный проект затевался, как гибкая система управлением HVAC(Heating, Ventilation, Air Conditioning). 
На момент создания, данная система должна была подключаться к HVAC системам здания. Обслуживающий персонал должен был получать актуальную информацию через приложение, а также управлять HVAC.

Предполагаемый функционал:
- Мониторинг данных
- Авторизация и аутентификация
- Предупреждения
- Управление в реальном времени
  
 Проект развалился. Однако, идея мне понравилась, поэтому я её продолжил в дипломной работе в качестве IoT проекта
 
В дипломном приложении будет следующий функционал:
- Мониторинг данных
- Предупреждения
- Анализ данных посредством ML

Модули автороизации, аутентификации и управления останутся в данном приложении в качестве экспериментальных, для получения навыков работы с данными задачами

# Структура проекта

**client**

Данная директория описывает клиентское приложение.<br /> 
Основной функционал: Отображение Timeseries в виде графиков, авторизация, аутентификация. <br />
Также, планируется переработать библиотеку графиков, убрать фризы, добавить умный функционал для взаимодействия с графиком на основе TimeSeries (различные уровни детализации, больше взаимодействия посредством движений)

Технология: **_Flutter, Kotlin(push-уведомления)_**

<br />

**controller**

Данная директория описывает Thing (в контексте IoT), а именно - стенд с датчиками. <br />
В качестве шлюза взят ESP32. Он собирает данные, обрабатывает их и отправляет на сервер через MQTT.

Технология: **_PlatformIO, С++_, Matlab(Калибровка датчиков)**

<br />

**firebase**

Данная директория описывает код, взаимодействующий с Firebase: <br />
Подпапка "functions" содержит функции, размещающиеся в Firebase Functions. <br />
Подпапка "admin" содержит скрипты для различных случаев.

Технология: **_NodeJS, TypeScript_**

В связи с санкциями стало невозможно использовать большую часть сервисов Firebase. В связи с этим бэк переезжает на Yandex Cloud

<br />

**yandex-cloud**

Данная директория описывает код, взаимодействующий с Yandex Cloud <br /> <br />
Подпапка "functions" содержит функции, размещающиеся в Yandex Functions <br /> Технология: **_NodeJS, TypeScript_** <br /> <br />
Подпапка "datasphere" (планируется) содержит код для разработки ML-сервиса. <br /> Технология: **_Jupiter, Python_** <br />

**В будущем**
Для осуществления Push-уведомлений планируется поднять свой MQTT-брокер.  MQTT-брокеры в IoT-сервисах в облаках не способны добавлять девайсы динамически. В связи с этим, принято решение поднять свой MQTT-брокер с более свободной политикой.
