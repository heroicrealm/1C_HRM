#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Удержания.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТолькоДокументыОснования") И Параметры.ТолькоДокументыОснования Тогда
		Параметры.Отбор.Вставить("ДокументОснование", ОбщегоНазначения.ПредопределенныйЭлемент("Документ.УдержаниеДобровольныхВзносовВНПФ.ПустаяСсылка"));
		Если Параметры.Отбор.Свойство("Организация") Тогда
			ОрганизацияСсылка = Параметры.Отбор.Организация;
			ГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОрганизацияСсылка, "ГоловнаяОрганизация");
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Организации.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	Организации.ГоловнаяОрганизация = &ГоловнаяОрганизация");
			Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
			ВсеФилиалы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
			Параметры.Отбор.Организация = ВсеФилиалы;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.УдержаниеДобровольныхВзносовВНПФ;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

