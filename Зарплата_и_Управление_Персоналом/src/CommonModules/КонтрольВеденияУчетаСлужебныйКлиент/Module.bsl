///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик двойного щелчка мыши, нажатия клавиши Enter или гиперссылки в табличном документе формы отчета.
// См. "Расширение поля формы для поля табличного документа.Выбор" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета          - ФормаКлиентскогоПриложения - форма отчета.
//   Элемент              - ПолеФормы        - табличный документ.
//   Область              - ОбластьЯчеекТабличногоДокумента - выбранное значение.
//   СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя <> "Отчет.РезультатыПроверкиУчета" Тогда
		Возврат;
	КонецЕсли;
		
	Расшифровка = Область.Расшифровка;
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Расшифровка.Свойство("Назначение") Тогда
			Если Расшифровка.Назначение = "ИсправитьПроблемы" Тогда
				ИсправитьПроблему(ФормаОтчета, Расшифровка);
			ИначеЕсли Расшифровка.Назначение = "ОткрытьФормуСписка" Тогда
				ОткрытьПроблемныйСписок(ФормаОтчета, Расшифровка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

// Открывает форму отчета с отбором по проблемам, препятствующим нормальному обновлению
// информационной базы.
//
//  Параметры:
//     Форма                - ФормаКлиентскогоПриложения - управляемая форма проблемного объекта.
//     СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения
//                            стандартной (системной) обработки события.
//
// Пример:
//    МодульКонтрольВеденияУчетаСлужебныйКлиент.ОткрытьОтчетПоПроблемамИзОбработкиОбновления(ЭтотОбъект, СтандартнаяОбработка);
//
Процедура ОткрытьОтчетПоПроблемамИзОбработкиОбновления(Форма, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ОткрытьОтчетПоПроблемам("СистемныеПроверки");
	
КонецПроцедуры

// см. КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемам.
Процедура ОткрытьОтчетПоПроблемам(ВидПроверок) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидПроверки", ВидПроверок);
	
	ОткрытьФорму("Отчет.РезультатыПроверкиУчета.Форма", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму списка справочника ПравилаПроверкиУчета.
//
Процедура ОткрытьСписокПроверокВеденияУчета() Экспорт
	ОткрытьФорму("Справочник.ПравилаПроверкиУчета.ФормаСписка");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("КонтрольВеденияУчета")
		И ПараметрыКлиента.КонтрольВеденияУчета.ОповещатьОПроблемахВеденияУчета Тогда
		ПодключитьОбработчикОжидания("ОповеститьОПроблемахВеденияУчета", 30, Истина);
	КонецЕсли;
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаРасшифровки.
Процедура ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя = "Отчет.РезультатыПроверкиУчета" Тогда
		Расшифровка = ФормаОтчета.ОтчетТабличныйДокумент.ТекущаяОбласть.Расшифровка;
		Результат = КонтрольВеденияУчетаВызовСервера.РасшифровкаВыделеннойЯчейки(ФормаОтчета.ОтчетДанныеРасшифровки, ФормаОтчета.ОтчетТабличныйДокумент, Расшифровка);
		Если Результат <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(, Результат.ПроблемныйОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения:
//    * ОтчетТабличныйДокумент - ТабличныйДокумент
//   Команда - КомандаФормы
//   Результат - Булево
// 
Процедура ПриОбработкеКоманды(ФормаОтчета, Команда, Результат) Экспорт
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя = "Отчет.РезультатыПроверкиУчета" Тогда
		ТекстНеуспешногоДействия = НСтр("ru = 'Выберите строку с проблемным объектом.'");
		Расшифровка = ФормаОтчета.ОтчетТабличныйДокумент.ТекущаяОбласть.Расшифровка;
		Если Команда.Имя = "КонтрольВеденияУчетаИсторияИзмененийОбъекта" Тогда
			Результат = КонтрольВеденияУчетаВызовСервера.ДанныеДляИсторииИзмененийОбъекта(ФормаОтчета.ОтчетДанныеРасшифровки, ФормаОтчета.ОтчетТабличныйДокумент, Расшифровка);
			Если Результат <> Неопределено Тогда
				Если Результат.Версионируется Тогда
					МодульВерсионированиеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВерсионированиеОбъектовКлиент");
					МодульВерсионированиеОбъектовКлиент.ПоказатьИсториюИзменений(Результат.Ссылка, ФормаОтчета);
				Иначе
					События = Новый Массив;
					События.Добавить("_$Data$_.Delete");
					События.Добавить("_$Data$_.New");
					События.Добавить("_$Data$_.Update");
					Отбор = Новый Структура;
					Отбор.Вставить("Данные", Результат.Ссылка);
					Отбор.Вставить("СобытиеЖурналаРегистрации", События);
					Отбор.Вставить("ДатаНачала", НачалоМесяца(ТекущаяДата()));
					ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
				КонецЕсли;
			Иначе
				ПоказатьПредупреждение(, ТекстНеуспешногоДействия);
			КонецЕсли;
		ИначеЕсли Команда.Имя = "КонтрольВеденияУчетаИгнорироватьПроблему" Тогда
			ПроблемаПроигнорирована = КонтрольВеденияУчетаВызовСервера.ИгнорироватьПроблему(ФормаОтчета.ОтчетДанныеРасшифровки, ФормаОтчета.ОтчетТабличныйДокумент, Расшифровка);
			Если Не ПроблемаПроигнорирована Тогда
				ПоказатьПредупреждение(, ТекстНеуспешногоДействия);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму для интерактивных действий пользователя для решения проблемы.
//
// Параметры:
//   Форма       - ФормаКлиентскогоПриложения - форма отчета РезультатыПроверкиУчета.
//   Расшифровка - Структура - дополнительные сведения для исправления проблемы:
//      * Назначение                     - Строка - строковый идентификатор назначения расшифровки.
//      * ИдентификаторПроверки          - Строка - строковый индикатор проверки.
//      * ОбработчикПереходаКИсправлению - Строка - имя экспортной клиентской процедуры-обработчика исправления 
//                                                   проблемы или полное имя открываемой формы.
//      * ВидПроверки                    - СправочникСсылка.ВидыПроверок - вид проверки,
//                                         дополнительно уточняющий область исправления проблемы.
//
Процедура ИсправитьПроблему(Форма, Расшифровка)
	
	ПараметрыИсправления = Новый Структура;
	ПараметрыИсправления.Вставить("ИдентификаторПроверки", Расшифровка.ИдентификаторПроверки);
	ПараметрыИсправления.Вставить("ВидПроверки",           Расшифровка.ВидПроверки);
	
	ОбработчикПереходаКИсправлению = Расшифровка.ОбработчикПереходаКИсправлению;
	Если СтрНачинаетсяС(ОбработчикПереходаКИсправлению, "ОбщаяФорма.") Или СтрНайти(ОбработчикПереходаКИсправлению, ".Форма") > 0 Тогда
		ОткрытьФорму(ОбработчикПереходаКИсправлению, ПараметрыИсправления, Форма);
	Иначе
		ОбработчикИсправления = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОбработчикПереходаКИсправлению, ".");
		
		МодульОбработчикаИсправления  = ОбщегоНазначенияКлиент.ОбщийМодуль(ОбработчикИсправления[0]);
		ИмяПроцедуры = ОбработчикИсправления[1];
		
		ВыполнитьОбработкуОповещения(Новый ОписаниеОповещения(ИмяПроцедуры, МодульОбработчикаИсправления), ПараметрыИсправления);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму списка (в случае регистра - с проблемным набором записей).
//
// Параметры:
//   Форма                          - ФормаКлиентскогоПриложения - форма отчета.
//   Расшифровка - Структура - структура, содержащая данные по исправлению проблемы
//                 расшифровки ячейки отчета по результатам проверок учета:
//      * Назначение         - Строка - строковый идентификатор назначения расшифровки.
//      * ПолноеИмяОбъекта   - Строка - полное имя объекта метаданных.
//      * Отбор              - Структура - отбор в форме списка.
//
Процедура ОткрытьПроблемныйСписок(Форма, Расшифровка)
	
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ОтборКомпоновки           = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	
	ФормаРегистра = ПолучитьФорму(Расшифровка.ПолноеИмяОбъекта + ".ФормаСписка", , Форма);
	
	Для Каждого ЭлементОтбораНабора Из Расшифровка.Отбор Цикл
		
		ЭлементОтбора                = ОтборКомпоновки.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ЭлементОтбораНабора.Ключ);
		ЭлементОтбора.ПравоеЗначение = ЭлементОтбораНабора.Значение;
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование  = Истина;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Поле",          ЭлементОтбораНабора.Ключ);
		ПараметрыОтбора.Вставить("Значение",      ЭлементОтбораНабора.Значение);
		ПараметрыОтбора.Вставить("ВидСравнения",  ВидСравненияКомпоновкиДанных.Равно);
		ПараметрыОтбора.Вставить("Использование", Истина);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Истина);
		ДополнительныеПараметры.Вставить("ЗаменятьСуществующий",       Истина);
		
		ДобавитьОтбор(ФормаРегистра.Список.КомпоновщикНастроек, ПараметрыОтбора, ДополнительныеПараметры);
		
	КонецЦикла;
	
	ФормаРегистра.Открыть();
	
КонецПроцедуры

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов
//
// Параметры:
//   ЭлементСтруктуры        - КомпоновщикНастроекКомпоновкиДанных
//                           - НастройкиКомпоновкиДанных - элемент структуры КД
//   ПараметрыОтбора         - Структура - содержит параметры отбора компоновки данных:
//     * Поле                - Строка - имя поля, по которому добавляется отбор.
//     * Значение            - Произвольный - значение отбора КД (по умолчанию: Неопределено).
//     * ВидСравнения        - ВидСравненияКомпоновкиДанных - вид сравнений КД (по умолчанию: Неопределено).
//     * Использование       - Булево - признак использования отбора (по умолчанию: Истина).
//   ДополнительныеПараметры - Структура - содержит дополнительные параметры, перечисленные ниже:
//     * ВПользовательскиеНастройки - Булево - признак добавления в пользовательские настройки КД (по умолчанию: Ложь).
//     * ЗаменятьСуществующий       - Булево - признак полной замены существующего отбора по полю (по умолчанию: Истина).
//
// Возвращаемое значение:
//   ЭлементОтбораКомпоновкиДанных - добавленный отбор.
//
Функция ДобавитьОтбор(ЭлементСтруктуры, ПараметрыОтбора, ДополнительныеПараметры = Неопределено)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Ложь);
		ДополнительныеПараметры.Вставить("ЗаменятьСуществующий",       Истина);
	Иначе
		Если Не ДополнительныеПараметры.Свойство("ВПользовательскиеНастройки") Тогда
			ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Ложь);
		КонецЕсли;
		Если Не ДополнительныеПараметры.Свойство("ЗаменятьСуществующий") Тогда
			ДополнительныеПараметры.Вставить("ЗаменятьСуществующий", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыОтбора.Поле) = Тип("Строка") Тогда
		НовоеПоле = Новый ПолеКомпоновкиДанных(ПараметрыОтбора.Поле);
	Иначе
		НовоеПоле = ПараметрыОтбора.Поле;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		
		Если ДополнительныеПараметры.ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки =
					ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	ЭлементОтбора = Неопределено;
	Если ДополнительныеПараметры.ЗаменятьСуществующий Тогда
		Для каждого Элемент Из Отбор.Элементы Цикл
	
			Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
	
			Если Элемент.ЛевоеЗначение = НовоеПоле Тогда
				ЭлементОтбора = Элемент;
			КонецЕсли;
	
		КонецЦикла;
	КонецЕсли;
	
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КонецЕсли;
	ЭлементОтбора.Использование  = ПараметрыОтбора.Использование;
	ЭлементОтбора.ЛевоеЗначение  = НовоеПоле;
	ЭлементОтбора.ВидСравнения   = ?(ПараметрыОтбора.ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно,
		ПараметрыОтбора.ВидСравнения);
	ЭлементОтбора.ПравоеЗначение = ПараметрыОтбора.Значение;
	
	Возврат ЭлементОтбора;
	
КонецФункции

Процедура ОповеститьОНаличииПроблемВеденияУчета() Экспорт
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("КонтрольВеденияУчета") Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоПроблем = ПараметрыКлиента.КонтрольВеденияУчета.КоличествоПроблемВеденияУчета;
	Если КоличествоПроблем = 0 Тогда
		Возврат;
	КонецЕсли;
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Проверка ведения учета'"),
		"e1cib/app/Отчет.РезультатыПроверкиУчета",
		НСтр("ru = 'Найдены проблемы ведения учета'") + " (" + КоличествоПроблем + ")",
		БиблиотекаКартинок.Предупреждение32);
КонецПроцедуры



#КонецОбласти