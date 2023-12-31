#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ЗарплатаКадрыДляНебольшихОрганизаций.ПособияСоциальногоСтрахования") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УчетПособийСоциальногоСтрахованияНебольшихОрганизаций");
		Модуль.СведенияОЗастрахованныхЛицахФССПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	КонецЕсли;
	
	Команда = Метаданные.РегистрыСведений.СведенияОЗастрахованныхЛицахФСС.Команды.ФормаСписка;
	НавигационнаяСсылка = "e1cib/command/" + Команда.ПолноеИмя();
	Заголовок           = Команда.Представление();
	
	УстановитьЗначениеПараметра("ПустаяДата",                 '00010101');
	УстановитьЗначениеПараметра("МаксимальноеНачалоДня",      '39991231000000');
	УстановитьЗначениеПараметра("ВнутреннееСовместительство", Перечисления.ВидыЗанятости.ВнутреннееСовместительство);
	УстановитьЗначениеПараметра("Подработка",                 Перечисления.ВидыЗанятости.Подработка);
	УстановитьЗначениеПараметра("ПустойВидЗанятости",         Перечисления.ВидыЗанятости.ПустаяСсылка());
	УстановитьЗначениеПараметра("Увольнение",                 Перечисления.ВидыКадровыхСобытий.Увольнение);
	УстановитьТекущуюДату();
	
	Элементы.ОтметитьСведенияКакПринятыеФондом.Видимость = СЭДОФСС.ДоступенОбменЧерезСЭДО();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов("ДокументСсылка.СведенияОЗастрахованномЛицеФСС");
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ПодключаемыеКомандыСведений;
	ПараметрыРазмещения.ПрефиксГрупп = "Сведения";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Организация   = Параметры.Организация;
	Подразделение = Параметры.Подразделение;
	
	ПоказыватьОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЗарплатаКадрыБазовая");
	Если ПоказыватьОрганизации Тогда
		ЗаполнитьСписокВыбораГоловныхОрганизаций();
		Количество = Элементы.ГоловнаяОрганизация.СписокВыбора.Количество();
		Если Количество > 1 И ЕстьФилиалы() Тогда
			ПоказыватьГоловныеОрганизации = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОрганизацияГруппа.Видимость       = Ложь;
		Элементы.СписокОрганизацийГруппа.Видимость = Ложь;
		Элементы.ПоказыватьГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	КонецЕсли;
	
	Если Не ПоказыватьГоловныеОрганизации Тогда
		Элементы.ГоловнаяОрганизацияГруппа.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЕстьСохраненныеНастройки() Тогда
		ПослеЗагрузкиВсехНастроекФормыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("УстановитьТекущуюДатуНаКлиенте", КонецДня(ТекущаяДата) - ТекущаяДата + 60);
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Если Не ПоказыватьГоловныеОрганизации Или ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		Настройки.Удалить("ГоловнаяОрганизация");
	КонецЕсли;
	// Загрузка списка выбора с очисткой представлений.
	Если ПоказыватьОрганизации И СписокОрганизаций.Количество() = 0 Тогда
		СписокОрганизацийИзНастроек = Настройки["СписокОрганизаций"];
		Если ТипЗнч(СписокОрганизацийИзНастроек) = Тип("СписокЗначений") Тогда
			СписокОрганизаций.ЗагрузитьЗначения(СписокОрганизацийИзНастроек.ВыгрузитьЗначения());
		КонецЕсли;
		СписокОрганизацийДляВыбораИзНастроек = Настройки["СписокОрганизацийДляВыбора"];
		Если ТипЗнч(СписокОрганизацийДляВыбораИзНастроек) = Тип("СписокЗначений") Тогда
			СписокОрганизацийДляВыбора.ЗагрузитьЗначения(СписокОрганизацийДляВыбораИзНастроек.ВыгрузитьЗначения());
		КонецЕсли;
	Иначе
		СписокОрганизацийДляВыбора.ЗагрузитьЗначения(СписокОрганизаций.ВыгрузитьЗначения());
		ИспользоватьСписокОрганизаций = СписокОрганизаций.Количество() > 1;
	КонецЕсли;
	Настройки.Удалить("СписокОрганизаций");
	Настройки.Удалить("СписокОрганизацийДляВыбора");
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПослеЗагрузкиВсехНастроекФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СведенияОЗастрахованномЛицеФСС" // Документ.
		Или ИмяСобытия = "Запись_СведенияОЗастрахованныхЛицахФСС" // Регистр.
		Или ИмяСобытия = "ИзменениеДанныхФизическогоЛица"
		Или ИмяСобытия = "Запись_ФизическиеЛица"
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения()
		Или ИмяСобытия = "Запись_РезультатыРегистрацииСведенийОЗастрахованномЛицеФСС" Тогда
		
		ПодключитьОбработчикОбновленияФормы();
		
	ИначеЕсли ИмяСобытия = "Запись_Организации" Тогда
		
		// Очистка представлений организаций.
		СписокОрганизаций.ЗагрузитьЗначения(СписокОрганизаций.ВыгрузитьЗначения());
		СписокОрганизацийДляВыбора.ЗагрузитьЗначения(СписокОрганизацийДляВыбора.ВыгрузитьЗначения());
		ПодключитьОбработчикОбновленияФормы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГоловнаяОрганизацияПриИзменении(Элемент)
	Организация = Неопределено;
	СписокОрганизаций.Очистить();
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	СписокОрганизаций.Очистить();
	Если ЗначениеЗаполнено(Организация) Тогда
		СписокОрганизаций.Добавить(Организация);
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСпискаОрганизацийНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьОрганизации();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПриИзменении(Элемент)
	ОбновитьПараметрыСписка();
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
Процедура СписокВыбор(ТаблицаФормы, ИдентификаторСтроки, ПолеФормы, СтандартнаяОбработка)
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущаяСтрока = Элементы.Список.ДанныеСтроки(ИдентификаторСтроки);
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	Если ПолеФормы = Элементы.СписокСотрудник
		Или ПолеФормы = Элементы.СписокФизическоеЛицо Тогда
		Если ЗначениеЗаполнено(ТекущаяСтрока.ПоследниеСведения) Тогда
			Значение = ТекущаяСтрока.ПоследниеСведения;
		Иначе
			Значение = ТекущаяСтрока.ОтправленныеСведения;
		КонецЕсли;
	ИначеЕсли ПолеФормы = Элементы.СписокОтправленныеСведения
		Или ПолеФормы = Элементы.СостояниеОтправкиИндексКартинки
		Или ПолеФормы = Элементы.СостояниеОтправки
		Или ПолеФормы = Элементы.СписокОтправленныеСведенияНомер
		Или ПолеФормы = Элементы.СписокДатаОтправки Тогда
		Если ЗначениеЗаполнено(ТекущаяСтрока.ОтправленныеСведения) Тогда
			Значение = ТекущаяСтрока.ОтправленныеСведения;
		Иначе
			Значение = ТекущаяСтрока.ПоследниеСведения;
		КонецЕсли;
	Иначе
		Значение = ТекущаяСтрока.ПоследниеСведения;
	КонецЕсли;
	Если ЗначениеЗаполнено(Значение) Тогда
		ПоказатьЗначение(, Значение);
	Иначе
		СоздатьСведенияОЗастрахованномЛице(Неопределено);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиОрганизации(Команда)
	УчетПособийСоциальногоСтрахованияКлиент.ОткрытьНастройкиПрямыхВыплатОрганизации(
		Организация,
		ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНасколькоОрганизаций(Команда)
	СписокОрганизаций.Очистить();
	Если ЗначениеЗаполнено(Организация) Тогда
		СписокОрганизаций.Добавить(Организация);
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
		Организация = СписокОрганизаций[0].Значение;
	Иначе
		Организация = Неопределено;
	КонецЕсли;
	ОрганизацияПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСведенияОЗастрахованномЛице(Команда)
	ИменаКолонок = "Организация, Сотрудник, ФизическоеЛицо, ГоловнаяОрганизация, ПоследниеСведения, ОтправленныеСведения, ДатаОтправки, Доставлен";
	Обработчик = Новый ОписаниеОповещения("СоздатьСведенияОЗастрахованномЛицеПослеВыбораСотрудников", ЭтотОбъект);
	ВыбратьСотрудников(Обработчик, ИменаКолонок, НСтр("ru = 'Создание сведений о застрахованных лицах'"));
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСведенияВФонд(Команда)
	МассивСсылок = Новый Массив;
	ПроиндексироватьВыделенныеСтроки("ПоследниеСведения", МассивСсылок);
	СЭДОФССКлиент.ОтправитьДокументы(МассивСсылок);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСведения(Команда)
	Обработчик = Новый ОписаниеОповещения("ПометитьНаУдалениеСведенияПослеВыбораСведений", ЭтотОбъект);
	ВыбратьСведения(Обработчик, НСтр("ru = 'Пометка на удаление сведений о застрахованных лицах'"));
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьСведенияКакПринятыеФондом(Команда)
	Обработчик = Новый ОписаниеОповещения("ОтметитьСведенияКакПринятыеФондомПослеВыбораСотрудников", ЭтотОбъект);
	ВыбратьСотрудников(Обработчик, "ГоловнаяОрганизация, ФизическоеЛицо", НСтр("ru = 'Сведения уже отправлены в ФСС'"));
КонецПроцедуры

&НаКлиенте
Процедура СведенияНеПланируетсяОтправлятьВФонд(Команда)
	Обработчик = Новый ОписаниеОповещения("СведенияНеПланируетсяОтправлятьПослеВыбораСотрудников", ЭтотОбъект);
	ВыбратьСотрудников(Обработчик, "ГоловнаяОрганизация, ФизическоеЛицо", НСтр("ru = 'Не показывать в списке застрахованных лиц ФСС'"));
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеРегистра(Команда)
	ИменаКолонок = "ФизическоеЛицо, ГоловнаяОрганизация";
	Обработчик = Новый ОписаниеОповещения("ОбновитьДанныеРегистраПослеВыбораСотрудников", ЭтотОбъект);
	ВыбратьСотрудников(Обработчик, ИменаКолонок, НСтр("ru = 'Обновление сведений о застрахованных лицах ФСС'"));
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСкрытые(Команда)
	ПоказыватьСкрытыеНаСервере();
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
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация", "Организация");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МассивСсылок = Новый Массив;
	ПроиндексироватьВыделенныеСтроки("ПоследниеСведения", МассивСсылок);
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, МассивСсылок);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МассивСсылок = Новый Массив;
	ПроиндексироватьВыделенныеСтрокиНаСервере("ПоследниеСведения", МассивСсылок);
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, МассивСсылок);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МассивСсылок = Новый Массив;
	ПроиндексироватьВыделенныеСтроки("ПоследниеСведения", МассивСсылок);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, МассивСсылок);
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
	СписокВыбора = Элементы.ГоловнаяОрганизация.СписокВыбора;
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
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.ГоловнаяОрганизация", "ГоловнаяОрганизация"));
	КонецЕсли;
	Элементы.Организация.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	
	Если ИспользоватьСписокОрганизаций Тогда
		Элементы.ОрганизацияГруппа.Видимость       = Ложь;
		Элементы.СписокОрганизацийГруппа.Видимость = Истина;
		ПредставлениеСписка = СЭДОФСС.ПредставлениеСписка(СписокОрганизаций, 100);
		Если ПустаяСтрока(ПредставлениеСписка) Тогда
			ПредставлениеСписка = НСтр("ru = '<Все>'");
			Элементы.ОчиститьСписокОрганизаций.Видимость = Ложь;
		Иначе
			Элементы.ОчиститьСписокОрганизаций.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОрганизацияГруппа.Видимость       = Истина;
		Элементы.СписокОрганизацийГруппа.Видимость = Ложь;
		ПредставлениеСписка = "";
	КонецЕсли;
	Элементы.ПредставлениеСпискаОрганизаций.Заголовок = ПредставлениеСписка;
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьСообщенияОжидаемыеОтФСС()
	КоличествоОжидаемыхСообщений = РегистрыСведений.СведенияОЗастрахованныхЛицахФСС.КоличествоОжидаемыхСообщений(
		ГоловнаяОрганизация,
		СписокОрганизаций.ВыгрузитьЗначения());
	Если КоличествоОжидаемыхСообщений = 0 Тогда
		Элементы.ГруппаСообщенияОжидаемыеОтФСС.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСообщенияОжидаемыеОтФСС.Видимость = Истина;
		ПредставлениеКоличества = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru = ';%1 сообщение;;%1 сообщения;%1 сообщений;'"), 
			КоличествоОжидаемыхСообщений);
		Элементы.НадписьСообщенияОжидаемыеОтФСС.Заголовок = СтрШаблон(
			НСтр("ru = 'Ожидается %1 ФСС о регистрации сведений о застрахованных лицах'"),
			ПредставлениеКоличества);
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
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "ГоловнаяОрганизация", "=", ГоловнаяОрганизация);
			ИдентификаторОтбораГоловнаяОрганизация = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
		КонецЕсли;
		ЭлементОтбораКД.Использование  = ЗначениеЗаполнено(ГоловнаяОрганизация);
		ЭлементОтбораКД.ПравоеЗначение = ГоловнаяОрганизация;
	КонецЕсли;
	
	Если ПоказыватьОрганизации Тогда
		Если ИдентификаторОтбораОрганизация = Неопределено Тогда
			ЭлементОтбораКД = Неопределено;
		Иначе
			ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораОрганизация);
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
			Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Организация") <> 0 Тогда
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "Организация", "=", Организация);
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
	
	
	Если ИдентификаторОтбораНаОформлении = Неопределено Тогда
		ЭлементОтбораКД = Неопределено;
	Иначе
		ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораНаОформлении);
	КонецЕсли;
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "НаОформлении") <> 0 Тогда
		ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "НаОформлении", "=", Истина);
		ИдентификаторОтбораНаОформлении = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.Использование = (Показывать = "НаОформлении");
	
	
	Если ИдентификаторОтбораКОтправке = Неопределено Тогда
		ЭлементОтбораКД = Неопределено;
	Иначе
		ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораКОтправке);
	КонецЕсли;
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "КОтправке") <> 0 Тогда
		ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "КОтправке", "=", Истина);
		ИдентификаторОтбораКОтправке = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.Использование = (Показывать = "КОтправке");
	
	
	Если ИдентификаторОтбораВРаботе = Неопределено Тогда
		ЭлементОтбораКД = Неопределено;
	Иначе
		ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораВРаботе);
	КонецЕсли;
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "ВРаботе") <> 0 Тогда
		ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "ВРаботе", "=", Истина);
		ИдентификаторОтбораВРаботе = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.Использование = (Показывать = "ВРаботе");
	
	
	Если ИдентификаторОтбораСкрыть = Неопределено Тогда
		ЭлементОтбораКД = Неопределено;
	Иначе
		ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораСкрыть);
	КонецЕсли;
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Скрыть") <> 0 Тогда
		ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "Скрыть", "=", Ложь);
		ИдентификаторОтбораСкрыть = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.Использование = (Не Элементы.ПоказыватьСкрытые.Пометка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеПараметра(Имя, Значение)
	ПараметрКД = Новый ПараметрКомпоновкиДанных(Имя);
	Если Список.Параметры.ДоступныеПараметры.НайтиПараметр(ПараметрКД) <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра(Имя, Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Даты

&НаКлиенте
Процедура УстановитьТекущуюДатуНаКлиенте()
	УстановитьТекущуюДату();
	ПодключитьОбработчикОжидания("УстановитьТекущуюДатуНаКлиенте", КонецДня(ТекущаяДата) - ТекущаяДата + 60);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюДату()
	ТекущаяДата = ТекущаяДатаСеанса();
	УстановитьЗначениеПараметра("ТекущаяДатаСеанса", НачалоДня(ТекущаяДата));
	УстановитьЗначениеПараметра("МаксимальнаяДатаУвольнения", НачалоМесяца(ДобавитьМесяц(ТекущаяДата, -2)));
КонецПроцедуры

#КонецОбласти

#Область Сотрудники

&НаКлиенте
Процедура ПроиндексироватьВыделенныеСтроки(КлючеваяКолонка, ЗначенияКлючевойКолонки, ИменаКолонокТаблицы = "", ДанныеСтрок = Неопределено)
	ЗаполнятьИменаКолонок = ЗначениеЗаполнено(ИменаКолонокТаблицы);
	Для Каждого ИдентификаторСтроки Из Элементы.Список.ВыделенныеСтроки Цикл
		СтрокаСписка = Элементы.Список.ДанныеСтроки(ИдентификаторСтроки);
		Ключ = СтрокаСписка[КлючеваяКолонка];
		Если Не ЗначениеЗаполнено(Ключ) Или ЗначенияКлючевойКолонки.Найти(Ключ) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗначенияКлючевойКолонки.Добавить(Ключ);
		Если ЗаполнятьИменаКолонок Тогда
			СтруктураСтроки = Новый Структура(ИменаКолонокТаблицы);
			ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрокаСписка);
			ДанныеСтрок.Вставить(Ключ, СтруктураСтроки);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПроиндексироватьВыделенныеСтрокиНаСервере(КлючеваяКолонка, ЗначенияКлючевойКолонки, ИменаКолонокТаблицы = "", ДанныеСтрок = Неопределено)
	ЗаполнятьИменаКолонок = ЗначениеЗаполнено(ИменаКолонокТаблицы);
	Для Каждого ИдентификаторСтроки Из Элементы.Список.ВыделенныеСтроки Цикл
		СтрокаСписка = Элементы.Список.ДанныеСтроки(ИдентификаторСтроки);
		Ключ = СтрокаСписка[КлючеваяКолонка];
		Если Не ЗначениеЗаполнено(Ключ) Или ЗначенияКлючевойКолонки.Найти(Ключ) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗначенияКлючевойКолонки.Добавить(Ключ);
		Если ЗаполнятьИменаКолонок Тогда
			СтруктураСтроки = Новый Структура(ИменаКолонокТаблицы);
			ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрокаСписка);
			ДанныеСтрок.Вставить(Ключ, СтруктураСтроки);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСотрудников(ОбработчикРезультата, ИменаКолонокТаблицы, ЗаголовокФормыСФлажками)
	Если Не ЗначениеЗаполнено(Элементы.Список.ВыделенныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	МассивСотрудников = Новый Массив;
	ДанныеСтрок = Новый Соответствие;
	ПроиндексироватьВыделенныеСтроки("Сотрудник", МассивСотрудников, ИменаКолонокТаблицы, ДанныеСтрок);
	
	Количество = МассивСотрудников.Количество();
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура("МассивСотрудников, ДанныеСтрок", МассивСотрудников, ДанныеСтрок);
	Если Количество = 1 Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Контекст);
	Иначе
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.ЗагрузитьЗначения(МассивСотрудников);
		СписокЗначений.ЗаполнитьПометки(Истина);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отмеченные", СписокЗначений);
		ПараметрыФормы.Вставить("ЗначенияДляВыбора", СписокЗначений);
		ПараметрыФормы.Вставить("ЗначенияДляВыбораЗаполнены", Истина);
		ПараметрыФормы.Вставить("ОграничиватьВыборУказаннымиЗначениями", Истина);
		ПараметрыФормы.Вставить("Представление", ЗаголовокФормыСФлажками);
		ПараметрыФормы.Вставить("ОписаниеТипов", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
		
		Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Контекст.Вставить("ОбработчикРезультата", ОбработчикРезультата);
		Обработчик = Новый ОписаниеОповещения("ПослеВыбораСотрудников", ЭтотОбъект, Контекст);
		
		ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыФормы, ЭтотОбъект, , , , Обработчик, Режим);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСотрудников(СписокСсылок, Контекст) Экспорт
	Если ТипЗнч(СписокСсылок) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	МассивСотрудников = Новый Массив;
	Для Каждого ЭлементСписка Из СписокСсылок Цикл
		Если ЭлементСписка.Пометка И МассивСотрудников.Найти(ЭлементСписка.Значение) = Неопределено Тогда
			МассивСотрудников.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	Контекст.МассивСотрудников = МассивСотрудников;
	// Обработчики см. в низлежащих процедурах.
	ВыполнитьОбработкуОповещения(Контекст.ОбработчикРезультата, Контекст);
КонецПроцедуры

#КонецОбласти

#Область Организации

&НаКлиенте
Процедура ВыбратьОрганизации()
	ПараметрыВыбора = Новый Массив;
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ГоловнаяОрганизация", ГоловнаяОрганизация));
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

#Область КнопкиСписка

&НаКлиенте
Процедура СоздатьСведенияОЗастрахованномЛицеПослеВыбораСотрудников(РезультатВыбора, ПустойПараметр) Экспорт
	Количество = РезультатВыбора.МассивСотрудников.Количество();
	Если Количество = 0 Тогда
		Возврат;
	ИначеЕсли Количество = 1 Тогда
		Сотрудник = РезультатВыбора.МассивСотрудников[0];
		СтрокаТаблицы = РезультатВыбора.ДанныеСтрок[Сотрудник];
		Если ЗначениеЗаполнено(СтрокаТаблицы.ПоследниеСведения)
			И СтрокаТаблицы.ПоследниеСведения <> СтрокаТаблицы.ОтправленныеСведения Тогда
			Сведения = СтрокаТаблицы.ПоследниеСведения; // Есть более поздние сведения чем подготовленные.
		ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицы.ОтправленныеСведения)
			И Не СтрокаТаблицы.Доставлен Тогда
			Сведения = СтрокаТаблицы.ОтправленныеСведения; // Сведения подготовлены, но не отправлены в ФСС.
		Иначе
			Сведения = Неопределено;
		КонецЕсли;
		ПараметрыФормы = Новый Структура;
		Если ЗначениеЗаполнено(Сведения) Тогда
			ПараметрыФормы.Вставить("Ключ", Сведения);
		КонецЕсли;
		ПараметрыФормы.Вставить("Сотрудник",           Сотрудник);
		ПараметрыФормы.Вставить("Организация",         СтрокаТаблицы.Организация);
		ПараметрыФормы.Вставить("ГоловнаяОрганизация", СтрокаТаблицы.ГоловнаяОрганизация);
		ПараметрыФормы.Вставить("ФизическоеЛицо",      СтрокаТаблицы.ФизическоеЛицо);
		ОткрытьФорму("Документ.СведенияОЗастрахованномЛицеФСС.ФормаОбъекта", ПараметрыФормы);
	Иначе
		МассивСведений = Новый Массив;
		МассивСотрудников = Новый Массив;
		Для Каждого Сотрудник Из РезультатВыбора.МассивСотрудников Цикл
			СтрокаТаблицы = РезультатВыбора.ДанныеСтрок[Сотрудник];
			Если ЗначениеЗаполнено(СтрокаТаблицы.ПоследниеСведения)
				И СтрокаТаблицы.ПоследниеСведения <> СтрокаТаблицы.ОтправленныеСведения Тогда
				МассивСведений.Добавить(СтрокаТаблицы.ПоследниеСведения);
			Иначе
				МассивСотрудников.Добавить(Сотрудник);
			КонецЕсли;
		КонецЦикла;
		Если МассивСотрудников.Количество() > 0 Тогда
			МассивДокументов = СоздатьДокументыСведений(МассивСотрудников);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивСведений, МассивДокументов, Истина);
		КонецЕсли;
		ОповеститьОбИзменении(Тип("ДокументСсылка.СведенияОЗастрахованномЛицеФСС"));
		Оповестить("Запись_СведенияОЗастрахованномЛицеФСС");
		Отбор = Новый Структура("Ссылка", МассивСведений);
		ПараметрыФормы = Новый Структура("Отбор", Отбор);
		Блокировать = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ОткрытьФорму("Документ.СведенияОЗастрахованномЛицеФСС.ФормаСписка", ПараметрыФормы, , Истина, , , , Блокировать);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СоздатьДокументыСведений(МассивСотрудников)
	Возврат Документы.СведенияОЗастрахованномЛицеФСС.СоздатьДокументыПоСотрудникам(МассивСотрудников);
КонецФункции

&НаСервере
Процедура ПоказыватьСкрытыеНаСервере()
	Элементы.ПоказыватьСкрытые.Пометка = Не Элементы.ПоказыватьСкрытые.Пометка;
	ОбновитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСведения(ОбработчикРезультата, ЗаголовокФормыСФлажками, ИменаКолонокТаблицы = "")
	Если Не ЗначениеЗаполнено(Элементы.Список.ВыделенныеСтроки) Тогда
		Возврат;
	КонецЕсли;
	МассивСсылок = Новый Массив;
	ДанныеСтрок = Новый Соответствие;
	ПроиндексироватьВыделенныеСтроки("ПоследниеСведения", МассивСсылок, ИменаКолонокТаблицы, ДанныеСтрок);
	
	Количество = МассивСсылок.Количество();
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура("МассивСсылок, ДанныеСтрок", МассивСсылок, ДанныеСтрок);
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.ЗагрузитьЗначения(МассивСсылок);
	СписокЗначений.ЗаполнитьПометки(Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отмеченные", СписокЗначений);
	ПараметрыФормы.Вставить("ЗначенияДляВыбора", СписокЗначений);
	ПараметрыФормы.Вставить("ЗначенияДляВыбораЗаполнены", Истина);
	ПараметрыФормы.Вставить("ОграничиватьВыборУказаннымиЗначениями", Истина);
	ПараметрыФормы.Вставить("Представление", ЗаголовокФормыСФлажками);
	ПараметрыФормы.Вставить("ОписаниеТипов", Новый ОписаниеТипов("ДокументСсылка.СведенияОЗастрахованномЛицеФСС"));
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	Контекст.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораСведений", ЭтотОбъект, Контекст);
	
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыФормы, ЭтотОбъект, , , , Обработчик, Режим);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСведений(СписокСсылок, Контекст) Экспорт
	Если ТипЗнч(СписокСсылок) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	МассивСсылок = Новый Массив;
	Для Каждого ЭлементСписка Из СписокСсылок Цикл
		Если ЭлементСписка.Пометка И МассивСсылок.Найти(ЭлементСписка.Значение) = Неопределено Тогда
			МассивСсылок.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	Контекст.МассивСсылок = МассивСсылок;
	// Обработчики см. в низлежащих процедурах.
	ВыполнитьОбработкуОповещения(Контекст.ОбработчикРезультата, Контекст);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСведенияПослеВыбораСведений(РезультатВыбора, ПустойПараметр) Экспорт
	ОчиститьСообщения();
	ПометитьНаУдалениеНаСервере(РезультатВыбора.МассивСсылок);
	ОповеститьОбИзменении(Тип("ДокументСсылка.СведенияОЗастрахованномЛицеФСС"));
	Оповестить("Запись_СведенияОЗастрахованномЛицеФСС");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПометитьНаУдалениеНаСервере(МассивСсылок)
	Для Каждого Ссылка Из МассивСсылок Цикл
		Если Не ЗначениеЗаполнено(Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		ДокументОбъект = Ссылка.ПолучитьОбъект();
		Если ДокументОбъект.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		Если Документы.СведенияОЗастрахованномЛицеФСС.ОбъектЗафиксирован(ДокументОбъект) Тогда
			Текст = СтрШаблон(НСтр("ru = '%1 не может быть помечен на удаление, поскольку отправлен в ФСС.'"), Ссылка);
			СообщенияПользователюБЗК.СообщитьОбОшибкеВОбъекте(Ложь, ДокументОбъект, "ДатаОтправки", Текст);
			Продолжить;
		КонецЕсли;
		ДокументОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьСведенияКакПринятыеФондомПослеВыбораСотрудников(РезультатВыбора, ПустойПараметр) Экспорт
	Количество = РезультатВыбора.МассивСотрудников.Количество();
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	ОтметитьСведенияКакПринятыеФондомНаСервере(РезультатВыбора.ДанныеСтрок);
	ОповеститьОбИзменении(Тип("ДокументСсылка.СведенияОЗастрахованномЛицеФСС"));
	Оповестить("Запись_СведенияОЗастрахованномЛицеФСС");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтметитьСведенияКакПринятыеФондомНаСервере(Соответствие)
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Реквизиты = КлючИЗначение.Значение;
		РегистрыСведений.СведенияОЗастрахованныхЛицахФСС.ОтметитьСведенияКакПринятыеФондом(Реквизиты.ГоловнаяОрганизация, Реквизиты.ФизическоеЛицо);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СведенияНеПланируетсяОтправлятьПослеВыбораСотрудников(РезультатВыбора, ПустойПараметр) Экспорт
	Количество = РезультатВыбора.МассивСотрудников.Количество();
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	СведенияНеПланируетсяОтправлятьНаСервере(РезультатВыбора.ДанныеСтрок);
	ОповеститьОбИзменении(Тип("ДокументСсылка.СведенияОЗастрахованномЛицеФСС"));
	Оповестить("Запись_СведенияОЗастрахованномЛицеФСС");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СведенияНеПланируетсяОтправлятьНаСервере(Соответствие)
	Для Каждого КлючИЗначение Из Соответствие Цикл
		Реквизиты = КлючИЗначение.Значение;
		РегистрыСведений.СведенияОЗастрахованныхЛицахФСС.СведенияНеПланируетсяОтправлять(Реквизиты.ГоловнаяОрганизация, Реквизиты.ФизическоеЛицо);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбновитьДанныеРегистра

&НаКлиенте
Процедура ОбновитьДанныеРегистраПослеВыбораСотрудников(РезультатВыбора, ПустойПараметр) Экспорт
	ОбновитьДанныеРегистраНаСервере(РезультатВыбора.ДанныеСтрок);
	ОжидатьЗавершенияОбновленияДанныхРегистра();
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеРегистраНаСервере(ДанныеСтрок)
	Если ДлительнаяОперация <> Неопределено И ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ГоловныеОрганизацииИФизическиеЛица = Новый Соответствие;
	Для Каждого КлючИЗначение Из ДанныеСтрок Цикл
		СтрокаСписка = КлючИЗначение.Значение;
		ФизическиеЛица = ГоловныеОрганизацииИФизическиеЛица[СтрокаСписка.ГоловнаяОрганизация];
		Если ФизическиеЛица = Неопределено Тогда
			ФизическиеЛица = Новый Массив;
			ГоловныеОрганизацииИФизическиеЛица.Вставить(СтрокаСписка.ГоловнаяОрганизация, ФизическиеЛица);
		КонецЕсли;
		ФизическиеЛица.Добавить(СтрокаСписка.ФизическоеЛицо);
	КонецЦикла;
	Для Каждого КлючИЗначение Из ГоловныеОрганизацииИФизическиеЛица Цикл
		РегистрыСведений.СведенияОЗастрахованныхЛицахФСС.ОбновитьСведения(
			КлючИЗначение.Ключ,
			КлючИЗначение.Значение);
	КонецЦикла;
	
	ИмяМетода = "СЭДОФСС.ОчередьОбработкиКадровыхДанныхФСС";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Сведения о застрахованных лицах ФСС: Очередь обработки кадровых данных'");
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьПроцедуру(НастройкиЗапуска, ИмяМетода);
	
	Элементы.КартинкаДанныеРегистраОбновляются.Видимость = (ДлительнаяОперация <> Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершенияОбновленияДанныхРегистра()
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияОбновленияДанныхРегистраКлиент", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияОбновленияДанныхРегистраКлиент(Задание, ДополнительныеПараметры) Экспорт
	// Задание - Неопределено - Если задание было отменено;
	//         - Структура - Результат выполнения фонового задания:
	//   * Статус - Строка - "Выполнено", если задание завершено успешно; "Ошибка", если возникло исключение.
	//   * АдресРезультата - Строка - адрес временного хранилища, в которое помещен результат работы процедуры.
	//   * АдресДополнительногоРезультата - Строка - если установлен параметр ДополнительныйРезультат,
	//       содержит адрес дополнительного временного хранилища, в которое помещен результат работы процедуры.
	//   * КраткоеПредставлениеОшибки   - Строка - краткая информация об исключении, если Статус = "Ошибка".
	//   * ПодробноеПредставлениеОшибки - Строка - подробная информация об исключении, если Статус = "Ошибка".
	//   * Сообщения - Неопределено, ФиксированныйМассив из СообщениеПользователю
	ДлительнаяОперация = Неопределено;
	Элементы.КартинкаДанныеРегистраОбновляются.Видимость = Ложь;
	Оповестить("Запись_СведенияОЗастрахованныхЛицахФСС", Неопределено, ЭтотОбъект);
	Если Задание <> Неопределено И ЗначениеЗаполнено(Задание.КраткоеПредставлениеОшибки) Тогда
		ИнформированиеПользователяКлиент.Предупредить(Задание.КраткоеПредставлениеОшибки, Задание.ПодробноеПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
