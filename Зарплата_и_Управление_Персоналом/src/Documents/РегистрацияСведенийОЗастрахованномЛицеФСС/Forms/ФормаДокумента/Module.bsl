#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТолькоПросмотр = Истина;
	Если Объект.Ссылка.Пустая() Тогда
		ОбновитьЭлементыФормы();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ОбновитьЭлементыФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ЗначениеЗаполнено(Объект.РегистрацияСтатус)
		И Элементы.РегистрацияСтатус.СписокВыбора.НайтиПоЗначению(Объект.РегистрацияСтатус) = Неопределено Тогда
		Представление = СтрШаблон(НСтр("ru = 'Неизвестный статус регистрации: %1'"), Объект.РегистрацияСтатус);
		Элементы.РегистрацияСтатус.СписокВыбора.Добавить(Объект.РегистрацияСтатус, Представление);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_СведенияОЗастрахованномЛицеФСС"
		И (Источник = Объект.ДокументОснование Или Не ЗначениеЗаполнено(Источник)) Тогда
		ПодключитьОбработчикОжиданияПрочитать();
		
	ИначеЕсли ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения() Тогда
		ПодключитьОбработчикОжиданияПрочитать();
		
	ИначеЕсли ИмяСобытия = "Запись_РезультатыРегистрацииСведенийОЗастрахованномЛицеФСС"
		И (Источник = Объект.Ссылка Или Не ЗначениеЗаполнено(Источник)) Тогда
		ПодключитьОбработчикОжиданияПрочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_РегистрацияСведенийОЗастрахованномЛицеФСС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьТребуетсяПодтверждениеОбработкаНавигационнойСсылки(Элемент, Адрес, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Отбор = Новый Структура("ФизическоеЛицо", Объект.ФизическоеЛицо);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	СтандартныеПодсистемыКлиент.ПоказатьВСписке(Объект.ДокументОснование, Неопределено, ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	ТолькоПросмотр = Ложь;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДоставкаИдентификаторТекстXML(Команда)
	СЭДОФССКлиент.ПоказатьТекстXML(Объект.ДоставкаИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияИдентификаторТекстXML(Команда)
	СЭДОФССКлиент.ПоказатьТекстXML(Объект.РегистрацияИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура НесоответствиеИдентификаторТекстXML(Команда)
	СЭДОФССКлиент.ПоказатьТекстXML(Объект.НесоответствиеИдентификатор);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область Свойства

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияПрочитать()
	ОтключитьОбработчикОжидания("ОбработчикОжиданияПрочитать");
	ПодключитьОбработчикОжидания("ОбработчикОжиданияПрочитать", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПрочитать()
	Если Не Модифицированность Тогда
		Прочитать();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	Элементы.ДоставкаИдентификаторТекстXML.Видимость       = ЗначениеЗаполнено(Объект.ДоставкаИдентификатор);
	Элементы.РегистрацияИдентификаторТекстXML.Видимость    = ЗначениеЗаполнено(Объект.РегистрацияИдентификатор);
	Элементы.НесоответствиеИдентификаторТекстXML.Видимость = ЗначениеЗаполнено(Объект.НесоответствиеИдентификатор);
	
	Если РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца Тогда
		Элементы.КоманднаяПанельПодвал.Видимость = Истина;
		КнопкаЗакрыть = Элементы.КнопкаЗакрытьВПодвале;
	Иначе
		Элементы.КоманднаяПанельПодвал.Видимость = Ложь;
		КнопкаЗакрыть = Элементы.КнопкаЗакрытьВШапке;
	КонецЕсли;
	
	Если Объект.Доставлен
		И Не ЗначениеЗаполнено(Объект.РегистрацияИдентификатор)
		И Не Объект.ЕстьОшибкиЛогическогоКонтроля Тогда
		Элементы.ПолучитьНовыеСообщенияСЭДОФСС.КнопкаПоУмолчанию = Истина;
	Иначе
		КнопкаЗакрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
