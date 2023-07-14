#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	ОтборПоОрганизации = Параметры.Организация;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПоказыватьОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЗарплатаКадрыБазовая");
	Если ПоказыватьОрганизации Тогда
		ЗаполнитьСписокВыбораГоловныхОрганизаций();
		Количество = Элементы.ОтборПоГоловнойОрганизации.СписокВыбора.Количество();
		Если Количество > 1 И ЕстьФилиалы() Тогда
			ПоказыватьГоловныеОрганизации = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОтборПоОрганизацииГруппа.Видимость = Ложь;
		Элементы.СписокОрганизацийГруппа.Видимость  = Ложь;
	КонецЕсли;
	
	Если Не ПоказыватьГоловныеОрганизации Тогда
		Элементы.ОтборПоГоловнойОрганизацииГруппа.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЕстьСохраненныеНастройки() Тогда
		ПослеЗагрузкиВсехНастроекФормыНаСервере();
	КонецЕсли;
	
	СЭДОФСС.ПриСозданииФормыЗапросаИлиОтветаДляРасчетаПособия(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПослеЗагрузкиВсехНастроекФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ВходящийЗапросФССДляРасчетаПособия"
		Или ИмяСобытия = "Запись_БольничныйЛист"
		Или ИмяСобытия = "Запись_ОтпускПоУходуЗаРебенком"
		Или ИмяСобытия = "Запись_Отпуск"
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения() Тогда
		ПодключитьОбработчикОбновленияФормы();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоГоловнойОрганизацииПриИзменении(Элемент)
	ОтборПоОрганизации = Неопределено;
	СписокОрганизаций.Очистить();
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоОрганизацииПриИзменении(Элемент)
	СписокОрганизаций.Очистить();
	Если ЗначениеЗаполнено(ОтборПоОрганизации) Тогда
		СписокОрганизаций.Добавить(ОтборПоОрганизации);
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСпискаОрганизацийНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьОрганизации();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьНасколькоОрганизаций(Команда)
	СписокОрганизаций.Очистить();
	Если ЗначениеЗаполнено(ОтборПоОрганизации) Тогда
		СписокОрганизаций.Добавить(ОтборПоОрганизации);
	КонецЕсли;
	ВыбратьОрганизации();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокОрганизаций(Команда)
	СписокОрганизаций.Очистить();
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяКВыборуОднойОрганизации(Команда)
	ИспользоватьСписокОрганизаций = Ложь;
	Если СписокОрганизаций.Количество() > 0 Тогда
		ОтборПоОрганизации = СписокОрганизаций[0].Значение;
	Иначе
		ОтборПоОрганизации = Неопределено;
	КонецЕсли;
	ОтборПоОрганизацииПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСведенияВФонд(Команда)
	СЭДОФССКлиент.ОтправитьДокументы(Элементы.Список.ВыделенныеСтроки);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ВходящийЗапросФССДляРасчетаПособия", Новый Структура, Неопределено);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область РасширениеСобытийФормы

&НаСервере
Функция ЕстьСохраненныеНастройки()
	УстановитьПривилегированныйРежим(Истина);
	Суффикс = НСтр("ru = 'ТекущиеДанные'", Метаданные.ОсновнойЯзык.КодЯзыка);
	СписокЗначений = ХранилищеСистемныхНастроек.ПолучитьСписок(ИмяФормы + "/" + Суффикс);
	Возврат СписокЗначений.Количество() > 0;
КонецФункции

&НаСервере
Процедура ПослеЗагрузкиВсехНастроекФормыНаСервере()
	Если Не ЗначениеЗаполнено(ОтборПоОрганизации) Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация", "ОтборПоОрганизации");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Форма

&НаКлиенте
Процедура ПодключитьОбработчикОбновленияФормы()
	ОтключитьОбработчикОжидания("ОбновитьФормуНаКлиенте");
	ПодключитьОбработчикОжидания("ОбновитьФормуНаКлиенте", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФормуНаКлиенте()
	ОбновитьФорму();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораГоловныхОрганизаций()
	СписокВыбора = Элементы.ОтборПоГоловнойОрганизации.СписокВыбора;
	СписокВыбора.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Значение,
	|	Организации.Представление КАК Представление
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = Организации.ГоловнаяОрганизация";
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(СписокВыбора.Добавить(), СтрокаТаблицы);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьФорму()
	ОбновитьЭлементыФормы();
	ОбновитьПараметрыСписка();
	ОбновитьНадписьСообщенияОжидаемыеОтФСС();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	
	Если Не ПоказыватьОрганизации Тогда
		Возврат;
	КонецЕсли;
	
	СвязиПараметровВыбора = Новый Массив;
	Если ЗначениеЗаполнено(ОтборПоГоловнойОрганизации) Тогда
		СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.ГоловнаяОрганизация", "ОтборПоГоловнойОрганизации"));
	КонецЕсли;
	Элементы.ОтборПоОрганизации.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	
	Если ИспользоватьСписокОрганизаций Тогда
		Элементы.ОтборПоОрганизацииГруппа.Видимость       = Ложь;
		Элементы.СписокОрганизацийГруппа.Видимость = Истина;
		ПредставлениеСписка = СЭДОФСС.ПредставлениеСписка(СписокОрганизаций, 100);
		Если ПустаяСтрока(ПредставлениеСписка) Тогда
			ПредставлениеСписка = НСтр("ru = '<Все>'");
			Элементы.ОчиститьСписокОрганизаций.Видимость = Ложь;
		Иначе
			Элементы.ОчиститьСписокОрганизаций.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОтборПоОрганизацииГруппа.Видимость       = Истина;
		Элементы.СписокОрганизацийГруппа.Видимость = Ложь;
		ПредставлениеСписка = "";
	КонецЕсли;
	Элементы.ПредставлениеСпискаОрганизаций.Заголовок = ПредставлениеСписка;
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьСообщенияОжидаемыеОтФСС()
	КоличествоОжидаемыхСообщений = Документы.ОтветНаЗапросФССДляРасчетаПособия.КоличествоОжидаемыхСообщений(
		ОтборПоГоловнойОрганизации,
		СписокОрганизаций.ВыгрузитьЗначения());
	Если КоличествоОжидаемыхСообщений = 0 Тогда
		Элементы.ГруппаСообщенияОжидаемыеОтФСС.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСообщенияОжидаемыеОтФСС.Видимость = Истина;
		Элементы.НадписьСообщенияОжидаемыеОтФСС.Заголовок = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru = ';Ожидается %1 ответ на запрос ФСС для расчета пособия;;Ожидается %1 ответа на запросы ФСС для расчета пособий;Ожидается %1 ответов на запросы ФСС для расчета пособий;'"),
			КоличествоОжидаемыхСообщений);
		Если КоличествоОжидаемыхСообщений = 1 Тогда
			Элементы.ПолучитьНовыеСообщенияСЭДОФСС.Заголовок = НСтр("ru = 'Проверить наличие ответа ФСС'");
		Иначе
			Элементы.ПолучитьНовыеСообщенияСЭДОФСС.Заголовок = НСтр("ru = 'Проверить наличие ответов ФСС'");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьФилиалы()
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ГоловнаяОрганизация <> Организации.Ссылка
	|	И Организации.ГоловнаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

#КонецОбласти

#Область Список

&НаСервере
Процедура ОбновитьПараметрыСписка()
	
	ОтборКД = Список.КомпоновщикНастроек.Настройки.Отбор;
	
	Если ПоказыватьГоловныеОрганизации Тогда
		Если ИдентификаторОтбораГоловнаяОрганизация = Неопределено Тогда
			ЭлементОтбораКД = Неопределено;
		Иначе
			ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораГоловнаяОрганизация);
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
			Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "ГоловнаяОрганизация") <> 0 Тогда
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "ГоловнаяОрганизация", "=", ОтборПоГоловнойОрганизации);
			ИдентификаторОтбораГоловнаяОрганизация = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
		КонецЕсли;
		ЭлементОтбораКД.Использование  = ЗначениеЗаполнено(ОтборПоГоловнойОрганизации);
		ЭлементОтбораКД.ПравоеЗначение = ОтборПоГоловнойОрганизации;
	КонецЕсли;
	
	Если ПоказыватьОрганизации Тогда
		Если ИдентификаторОтбораОрганизация = Неопределено Тогда
			ЭлементОтбораКД = Неопределено;
		Иначе
			ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораОрганизация);
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
			Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Организация") <> 0 Тогда
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "Организация", "=", ОтборПоОрганизации);
			ИдентификаторОтбораОрганизация = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
		КонецЕсли;
		Количество = СписокОрганизаций.Количество();
		Если Количество = 0 Тогда
			ЭлементОтбораКД.Использование  = Ложь;
		ИначеЕсли Количество = 1 Тогда
			ЭлементОтбораКД.Использование  = Истина;
			ЭлементОтбораКД.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораКД.ПравоеЗначение = СписокОрганизаций[0].Значение;
		Иначе
			ЭлементОтбораКД.Использование  = Истина;
			ЭлементОтбораКД.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбораКД.ПравоеЗначение = СписокОрганизаций;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Организации

&НаКлиенте
Процедура ВыбратьОрганизации()
	ПараметрыВыбора = Новый Массив;
	Если ЗначениеЗаполнено(ОтборПоГоловнойОрганизации) Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ГоловнаяОрганизация", ОтборПоГоловнойОрганизации));
	КонецЕсли;
	Для Каждого ЭлементСписка Из СписокОрганизаций Цикл
		Если СписокОрганизацийДляВыбора.НайтиПоЗначению(ЭлементСписка.Значение) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СписокОрганизацийДляВыбора.Добавить(), ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отмеченные", СписокОрганизаций);
	ПараметрыФормы.Вставить("ЗначенияДляВыбора", СписокОрганизацийДляВыбора);
	ПараметрыФормы.Вставить("ЗначенияДляВыбораЗаполнены", Истина);
	ПараметрыФормы.Вставить("ОграничиватьВыборУказаннымиЗначениями", Ложь);
	ПараметрыФормы.Вставить("БыстрыйВыбор", Ложь);
	ПараметрыФормы.Вставить("Представление", НСтр("ru = 'Организации'"));
	ПараметрыФормы.Вставить("ПараметрыВыбора", ПараметрыВыбора);
	ПараметрыФормы.Вставить("ОписаниеТипов", СписокОрганизаций.ТипЗначения);
	
	Если СписокОрганизацийДляВыбора.Количество() = 0 Тогда
		ПараметрыФормы.БыстрыйВыбор = Истина;
		ПараметрыФормы.ЗначенияДляВыбораЗаполнены = Ложь;
	КонецЕсли;
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораОрганизаций", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыФормы, ЭтотОбъект, , , , Обработчик, Режим);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОрганизаций(РезультатВыбора, ПустойПараметр) Экспорт
	Если ТипЗнч(РезультатВыбора) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	СписокОрганизацийДляВыбора = РезультатВыбора;
	ИспользоватьСписокОрганизаций = Истина;
	СписокОрганизаций.Очистить();
	Для Каждого ЭлементСписка Из РезультатВыбора Цикл
		Если ЭлементСписка.Пометка Тогда
			ЗаполнитьЗначенияСвойств(СписокОрганизаций.Добавить(), ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
