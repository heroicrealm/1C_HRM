///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(ИсходящийДокумент)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(ИсходящийДокумент)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// АПК:581-выкл. Методы могут вызываться из расширений.
// АПК:299-выкл. Методы могут вызываться из расширений.
// АПК:326-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// АПК:325-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// Транзакция открывается в методе НачатьЗаписьНабора, закрывается в ЗавершитьЗаписьНабора, отменяется в ОтменитьЗаписьНабора.

// Транзакционный вариант (с управляемой блокировкой) получения набора записей, соответствующего значениям измерений.
//
// Параметры:
//   ИсходящийДокумент - ДокументСсылка.ОтветНаЗапросФССДляРасчетаПособия - Значение отбора по соответствующему измерению.
//
// Возвращаемое значение:
//   РегистрСведенийНаборЗаписей.РегистрацииОтветовНаЗапросыФССДляРасчетаПособия - Если удалось установить блокировку
//       и прочитать набор записей. При необходимости, открывает свою локальную транзакцию. Для закрытия транзакции
//       следует использовать одну из терминирующих процедур: ЗавершитьЗаписьНабора, либо ОтменитьЗаписьНабора.
//   Неопределено - Если не удалось установить блокировку и прочитать набор записей.
//       Вызывать процедуры ЗавершитьЗаписьНабора, ОтменитьЗаписьНабора не требуется,
//       поскольку если перед блокировкой функции потребовалось открыть локальную транзакцию,
//       то после неудачной блокировки локальная транзакция была отменена.
//
Функция НачатьЗаписьНабора(ИсходящийДокумент) Экспорт
	Если Не ЗначениеЗаполнено(ИсходящийДокумент) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПолныеПраваИлиПривилегированныйРежим = Пользователи.ЭтоПолноправныйПользователь();
	Если Не ПолныеПраваИлиПривилегированныйРежим
		И Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Недостаточно прав для изменения регистра ""%1"".'"),
			Метаданные.РегистрыСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий.Представление());
	КонецЕсли;
	ЛокальнаяТранзакция = Не ТранзакцияАктивна();
	Если ЛокальнаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий");
		ЭлементБлокировки.УстановитьЗначение("ИсходящийДокумент", ИсходящийДокумент);
		Блокировка.Заблокировать();
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИсходящийДокумент.Установить(ИсходящийДокумент);
		НаборЗаписей.Прочитать();
		НаборЗаписей.ДополнительныеСвойства.Вставить("ЛокальнаяТранзакция", ЛокальнаяТранзакция);
	Исключение
		Если ЛокальнаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось изменить регистрацию сведений для расчета пособия ФСС %1 по причине: %2'"),
			ИсходящийДокумент,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.РегистрыСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий,
			ИсходящийДокумент,
			ТекстСообщения);
		НаборЗаписей = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат НаборЗаписей;
КонецФункции

// Записывает набор и фиксирует локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.РегистрацииОтветовНаЗапросыФССДляРасчетаПособия
//
Процедура ЗавершитьЗаписьНабора(НаборЗаписей) Экспорт
	НаборЗаписей.Записать(Истина);
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Отменяет запись набора и отменяет локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.РегистрацииОтветовНаЗапросыФССДляРасчетаПособия
//
Процедура ОтменитьЗаписьНабора(НаборЗаписей) Экспорт
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ОтменитьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Возвращает строку - имена требуемых реквизитов документа "Сведения о застрахованном лице ФСС".
Функция ТребуемыеРеквизитыСведений() Экспорт
	Возврат "Проведен, РегистрацияСведений, ДатаОтправки";
КонецФункции

// АПК:326-вкл.
// АПК:325-вкл.
// АПК:299-вкл.
// АПК:581-вкл.

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументу(ИсходящийДокументОбъект, СтрокаОтправки = Неопределено) Экспорт
	// Регистрация является продолжением текущего документа.
	// Но если документ - новый, то поле "Ссылка" может быть не заполнено.
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = НачатьЗаписьНабора(ИсходящийДокументОбъект.Ссылка);
	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
	Иначе
		Запись = Набор[0];
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Запись, ИсходящийДокументОбъект);
	Запись.ИсходящийДокумент = ИсходящийДокументОбъект.Ссылка;
	
	Если СтрокаОтправки <> Неопределено Тогда
		Запись.Доставлен             = СтрокаОтправки.Доставлен;
		Запись.ДоставкаИдентификатор = СтрокаОтправки.ДоставкаИдентификатор;
		Запись.ДоставкаТекстОшибки   = СтрокаОтправки.Результат;
	КонецЕсли;
	
	ЗавершитьЗаписьНабора(Набор);
КонецПроцедуры

#Область СЭДО

// Загружает ошибку логического контроля регистрации ответа на запрос ФСС для расчета пособий.
Процедура ЗагрузитьОшибкуСообщения101(Страхователь, ИдентификаторСообщения, ТекстОшибки, Результат) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Регистрация.ИсходящийДокумент КАК ИсходящийДокумент,
	|	Регистрация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК Регистрация
	|ГДЕ
	|	Регистрация.ДоставкаИдентификатор = &ИдентификаторСообщения
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Регистрация.ИсходящийДокумент,
	|	Регистрация.ГоловнаяОрганизация
	|ИЗ
	|	РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК Регистрация
	|ГДЕ
	|	Регистрация.РегистрацияИдентификатор = &ИдентификаторСообщения";
	Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
	
	ТекстОшибки = СокрЛП(ТекстОшибки);
	Добавка = Символы.ПС + Символы.ПС + НСтр("ru = 'Ошибка логического контроля: '") + СокрЛ(ТекстОшибки);
	
	ФизическиеЛица = Новый Массив;
	Таблица = Запрос.Выполнить().Выгрузить();
	Найденные = Таблица.Скопировать(Новый Структура("ГоловнаяОрганизация", ГоловнаяОрганизация));
	Если Найденные.Количество() = 0 Тогда
		Найденные = Таблица;
	КонецЕсли;
	Для Каждого СтрокаТаблицы Из Найденные Цикл
		Набор = НачатьЗаписьНабора(СтрокаТаблицы.ИсходящийДокумент);
		Если Набор.Количество() = 0 Тогда
			ОтменитьЗаписьНабора(Набор);
			Продолжить;
		КонецЕсли;
		Запись = Набор[0];
		Если СтрНайти(Запись.ОшибкиЛогическогоКонтроля, ТекстОшибки) = 0 Тогда
			Если ПустаяСтрока(Запись.ОшибкиЛогическогоКонтроля) Тогда
				Запись.ОшибкиЛогическогоКонтроля = ТекстОшибки;
			Иначе
				Запись.ОшибкиЛогическогоКонтроля = Запись.ОшибкиЛогическогоКонтроля + Символы.ПС + Символы.ПС + ТекстОшибки;
			КонецЕсли;
		КонецЕсли;
		Запись.ЕстьОшибкиЛогическогоКонтроля = Истина;
		ЗавершитьЗаписьНабора(Набор);
	КонецЦикла;
	
КонецПроцедуры

// Загружает результат ответа на запрос сведений для расчета и выплаты пособия ФСС.
Процедура ЗагрузитьСообщение105(Страхователь, РегистрацияИдентификатор, ТекстXML, Результат) Экспорт
	// Пример:
	//<pr:approveSocialAssistResult
	//		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	//		xmlns:pr="urn:ru:fss:integration:types:proactive:v01"
	//		responseOn="jebce3d6-0a45-4ecc-835f-866640c48d20"
	//		xsi:schemaLocation="urn:ru:fss:integration:types:proactive:v01 Confirmation.xsd">
	//	<pr:socialAssistNum>0000</pr:socialAssistNum>
	//	<pr:status>ERROR</pr:status>
	//</pr:approveSocialAssistResult>
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураDOM = СериализацияБЗК.СтруктураDOM(ТекстXML);
	КореньDOM = СериализацияБЗК.НайтиУзелDOM(СтруктураDOM, "//*[local-name() = 'approveSocialAssistResult']");
	Если КореньDOM = Неопределено Тогда
		КореньDOM = СериализацияБЗК.НайтиУзелDOM(СтруктураDOM, "//*[local-name() = 'socialAssistNum']/..");
	КонецЕсли;
	Если КореньDOM = Неопределено Тогда
		КореньDOM = СериализацияБЗК.НайтиУзелDOM(СтруктураDOM, "//*[local-name() = 'status']/..");
	КонецЕсли;
	Если КореньDOM = Неопределено Тогда
		КореньDOM = СериализацияБЗК.НайтиУзелDOM(СтруктураDOM, "//*[local-name() = 'registryNum']/..");
	КонецЕсли;
	Если КореньDOM = Неопределено Тогда
		КореньDOM = СериализацияБЗК.НайтиУзелDOM(СтруктураDOM, "//*[local-name() = 'errorList']/..");
	КонецЕсли;
	Если КореньDOM = Неопределено Тогда
		КореньDOM = СтруктураDOM.ДокументDOM;
	КонецЕсли;
	Если КореньDOM = Неопределено Тогда
		ТекстОшибки = СтрШаблон(НСтр("ru = 'В xml-содержимом сообщения 105 не удалось найти узел ""approveSocialAssistResult"". Текст XML: %1'"), ТекстXML);
		СЭДОФСС.ОшибкаОбработки(Результат, РегистрацияИдентификатор, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	АтрибутыКорня = СериализацияБЗК.АтрибутыЭлементаDOM(КореньDOM, "responseOn");
	ДоставкаИдентификатор = АтрибутыКорня.responseOn;
	ТекстОшибки = "";
	Если ДоставкаИдентификатор = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'В xml-содержимом сообщения 105 отсутствует атрибут ""responseOn"".
			|Текст XML:
			|%1'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, ТекстXML);
		СЭДОФСС.ОшибкаОбработки(Результат, РегистрацияИдентификатор, ТекстОшибки);
	ИначеЕсли Не ЗначениеЗаполнено(ДоставкаИдентификатор) Тогда
		ТекстОшибки = НСтр("ru = 'В xml-содержимом сообщения 105 не заполнен атрибут ""responseOn"".
			|Текст XML:
			|%1'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, ТекстXML);
		СЭДОФСС.ОшибкаОбработки(Результат, РегистрацияИдентификатор, ТекстОшибки);
	КонецЕсли;
	
	РеквизитыКорня = СериализацияБЗК.УзлыЭлементаDOM(КореньDOM, "socialAssistNum, status, registryNum, errorList");
	РегистрацияДата             = СЭДОФСС.ДатаСообщения(РегистрацияИдентификатор);
	РегистрацияСтатус           = СериализацияБЗК.ЗначениеXMLТипаСтрока(РеквизитыКорня.status);
	РегистрацияНомерПроцесса    = СериализацияБЗК.ЗначениеXML(РеквизитыКорня.socialAssistNum, Тип("Число"));
	РегистрацияНомерРеестраПВСО = СериализацияБЗК.ЗначениеXMLТипаСтрока(РеквизитыКорня.registryNum);
	РегистрацияПротокол         = ПредставлениеСпискаОшибок(РеквизитыКорня.errorList);
	СведенияОСтатусе            = СведенияОСтатусеРегистрации(РегистрацияСтатус);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		РегистрацияПротокол = СокрЛП(РегистрацияПротокол + Символы.ПС + Символы.ПС + ТекстОшибки);
	КонецЕсли;
	Если ЗначениеЗаполнено(РегистрацияСтатус) И СведенияОСтатусе.Расшифровка = "" Тогда
		Текст = СтрШаблон(НСтр("ru = 'Неизвестный статус: ""%1"".'"), РегистрацияСтатус);
		РегистрацияПротокол = СокрЛП(Текст + Символы.ПС + Символы.ПС + РегистрацияПротокол);
	КонецЕсли;
	
	ОтветНаЗапрос = НайтиОтветНаЗапрос(Страхователь, ДоставкаИдентификатор, РегистрацияНомерПроцесса);
	Если Не ЗначениеЗаполнено(ОтветНаЗапрос) Тогда
		ОтветНаЗапрос = СоздатьОтветНаЗапрос(Страхователь, ДоставкаИдентификатор, РегистрацияНомерПроцесса);
	КонецЕсли;
	
	Набор = НачатьЗаписьНабора(ОтветНаЗапрос);
	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, ОтветНаЗапрос);
		Запись.ИсходящийДокумент = ОтветНаЗапрос;
	Иначе
		Запись = Набор[0];
	КонецЕсли;
	
	Запись.Зарегистрирован             = СведенияОСтатусе.Зарегистрирован;
	Запись.РегистрацияДата             = РегистрацияДата;
	Запись.РегистрацияСтатус           = РегистрацияСтатус;
	Запись.РегистрацияПротокол         = РегистрацияПротокол;
	Запись.РегистрацияИдентификатор    = РегистрацияИдентификатор;
	Запись.РегистрацияНомерПроцесса    = РегистрацияНомерПроцесса;
	Запись.РегистрацияНомерРеестраПВСО = РегистрацияНомерРеестраПВСО;
	
	ЗавершитьЗаписьНабора(Набор);
	
	Результат.Обработано = Истина;
КонецПроцедуры

Функция НайтиОтветНаЗапрос(Страхователь, ИдентификаторСообщения, НомерПроцесса = Неопределено)
	// Формирование набора запросов.
	
	Тексты = Новый ТаблицаЗначений;
	Тексты.Колонки.Добавить("Приоритет");
	Тексты.Колонки.Добавить("Текст");
	
	Если ЗначениеЗаполнено(ИдентификаторСообщения) Тогда
		Если ЗначениеЗаполнено(Страхователь) Тогда
			ЭлементСписка = Тексты.Добавить();
			ЭлементСписка.Приоритет = 1;
			ЭлементСписка.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	НайденныйДокумент.Ссылка КАК Ссылка,
			|	1 КАК Приоритет
			|ИЗ
			|	Документ.ОтветНаЗапросФССДляРасчетаПособия КАК НайденныйДокумент
			|ГДЕ
			|	НайденныйДокумент.ИдентификаторСообщения = &ИдентификаторСообщения
			|	И НайденныйДокумент.Страхователь = &Страхователь";
		КонецЕсли;
		ЭлементСписка = Тексты.Добавить();
		ЭлементСписка.Приоритет = 3;
		ЭлементСписка.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка КАК Ссылка,
		|	3 КАК Приоритет
		|ИЗ
		|	Документ.ОтветНаЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.ИдентификаторСообщения = &ИдентификаторСообщения";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерПроцесса) Тогда
		Если ЗначениеЗаполнено(Страхователь) Тогда
			ЭлементСписка = Тексты.Добавить();
			ЭлементСписка.Приоритет = 2;
			ЭлементСписка.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	НайденныйДокумент.Ссылка КАК Ссылка,
			|	2 КАК Приоритет
			|ИЗ
			|	Документ.ОтветНаЗапросФССДляРасчетаПособия КАК НайденныйДокумент
			|ГДЕ
			|	НайденныйДокумент.НомерПроцесса = &НомерПроцесса
			|	И НайденныйДокумент.Страхователь = &Страхователь";
		КонецЕсли;
		ЭлементСписка = Тексты.Добавить();
		ЭлементСписка.Приоритет = 4;
		ЭлементСписка.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка КАК Ссылка,
		|	4 КАК Приоритет
		|ИЗ
		|	Документ.ОтветНаЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.НомерПроцесса = &НомерПроцесса";
	КонецЕсли;
	
	Если Тексты.Количество() = 0 Тогда
		Если ЗначениеЗаполнено(Страхователь) Тогда
			ЭлементСписка = Тексты.Добавить();
			ЭлементСписка.Приоритет = 5;
			ЭлементСписка.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Регистр.ИсходящийДокумент КАК Ссылка,
			|	5 КАК Приоритет
			|ИЗ
			|	РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК Регистр
			|ГДЕ
			|	Регистр.Доставлен = ИСТИНА
			|	И Регистр.РегистрацияИдентификатор = """"
			|	И Регистр.Страхователь = &Страхователь";
		КонецЕсли;
		ЭлементСписка = Тексты.Добавить();
		ЭлементСписка.Приоритет = 6;
		ЭлементСписка.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регистр.ИсходящийДокумент КАК Ссылка,
		|	6 КАК Приоритет
		|ИЗ
		|	РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК Регистр
		|ГДЕ
		|	Регистр.Доставлен = ИСТИНА
		|	И Регистр.РегистрацияИдентификатор = """"";
	КонецЕсли;
	
	Тексты.Сортировать("Приоритет");
	
	Отступ = Символы.ПС + Символы.ПС;
	Разделитель = Отступ + "ОБЪЕДИНИТЬ ВСЕ" + Отступ;
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(Тексты.ВыгрузитьКолонку("Текст"), Разделитель) + Отступ + "УПОРЯДОЧИТЬ ПО Приоритет";
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
	Запрос.УстановитьПараметр("НомерПроцесса", НомерПроцесса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция СоздатьОтветНаЗапрос(Страхователь, ИдентификаторСообщения, НомерПроцесса = Неопределено)
	ДокументОбъект = Документы.ОтветНаЗапросФССДляРасчетаПособия.СоздатьДокумент();
	ДокументОбъект.Страхователь           = Страхователь;
	ДокументОбъект.ИдентификаторСообщения = ИдентификаторСообщения;
	ДокументОбъект.НомерПроцесса          = НомерПроцесса;
	ДокументОбъект.ВходящийЗапрос         = НайтиВходящийЗапрос(Страхователь, ИдентификаторСообщения, НомерПроцесса);
	ДокументОбъект.Заполнить(ДокументОбъект.ВходящийЗапрос);
	ДокументОбъект.ОбновитьВторичныеДанные();
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект);
	ЗаполнитьПоДокументу(ДокументОбъект);
	Возврат ДокументОбъект.Ссылка;
КонецФункции

Функция НайтиВходящийЗапрос(Страхователь, ИдентификаторСообщения, НомерПроцесса = Неопределено)
	Запрос = Новый Запрос;
	Если ЗначениеЗаполнено(НомерПроцесса) Тогда
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка КАК Ссылка,
		|	1 КАК Приоритет
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.ИдентификаторСообщения = &ИдентификаторСообщения
		|	И НайденныйДокумент.Страхователь = &Страхователь
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка,
		|	2
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.НомерПроцесса = &НомерПроцесса
		|	И НайденныйДокумент.Страхователь = &Страхователь
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка,
		|	3
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.ИдентификаторСообщения = &ИдентификаторСообщения
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка,
		|	4
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.НомерПроцесса = &НомерПроцесса
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка КАК Ссылка,
		|	1 КАК Приоритет
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.ИдентификаторСообщения = &ИдентификаторСообщения
		|	И НайденныйДокумент.Страхователь = &Страхователь
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	НайденныйДокумент.Ссылка,
		|	3
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК НайденныйДокумент
		|ГДЕ
		|	НайденныйДокумент.ИдентификаторСообщения = &ИдентификаторСообщения
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	КонецЕсли;
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
	Запрос.УстановитьПараметр("НомерПроцесса", НомерПроцесса);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция ПредставлениеСпискаОшибок(СписокОшибок)
	// Для сообщения 105 ожидаемые поля: code,message,details.
	Если СписокОшибок = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	МассивСтрок = Новый Массив;
	Для Каждого ОшибкаDOM Из СписокОшибок.ДочерниеУзлы Цикл
		Если ОшибкаDOM.ТипУзла <> ТипУзлаDOM.Элемент Тогда
			Продолжить;
		КонецЕсли;
		УзлыОшибки = СериализацияБЗК.УзлыЭлементаDOMСКонтролем(ОшибкаDOM, "code, message,details");
		Код         = СериализацияБЗК.ЗначениеXMLТипаСтрока(УзлыОшибки.code);
		Сообщение   = СериализацияБЗК.ЗначениеXMLТипаСтрока(УзлыОшибки.message);
		Подробности = СериализацияБЗК.ЗначениеXMLТипаСтрока(УзлыОшибки.details);
		// Все данные будут записываться в переменную Сообщение.
		Если ЗначениеЗаполнено(Сообщение) Тогда
			Массив = СтрРазделить(Сообщение, Символы.ПС + Символы.ВК, Ложь);
			Сообщение = СтрСоединить(Массив, Символы.ПС + "  ");
		КонецЕсли;
		Если ЗначениеЗаполнено(Подробности) Тогда
			Массив = СтрРазделить(Подробности, Символы.ПС + Символы.ВК, Ложь);
			Подробности = СтрСоединить(Массив, Символы.ПС + "    ");
			Сообщение = ?(ЗначениеЗаполнено(Сообщение), Сообщение + Символы.ПС + "    " + Подробности, Подробности);
		КонецЕсли;
		Если ЗначениеЗаполнено(Код) Тогда
			Сообщение = СокрП(Код + ": " + Сообщение);
		КонецЕсли;
		Если УзлыОшибки.ПредставленияНеобработанныхУзловDOM.Количество() > 0 Тогда
			Необработанные = СтрСоединить(УзлыОшибки.ПредставленияНеобработанныхУзловDOM, Символы.ПС);
			Необработанные = НСтр("ru = 'Необработанные узлы сообщения:'") + Символы.ПС + Необработанные;
			Сообщение = ?(ЗначениеЗаполнено(Сообщение), Сообщение + Символы.ПС + "    " + Необработанные, Необработанные);
		КонецЕсли;
		Если ЗначениеЗаполнено(Сообщение) Тогда
			МассивСтрок.Добавить(Сообщение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(МассивСтрок, Символы.ПС);
КонецФункции

Функция СведенияОСтатусеРегистрации(Статус)
	Результат = Новый Структура("Приоритет, Зарегистрирован, Расшифровка");
	
	СтатусВРег = ВРег(СокрЛП(Статус));
	
	// Статусы из актуальной спецификации.
	Если СтатусВРег = "RECEIVED" Тогда
		Результат.Приоритет       = 1;
		Результат.Зарегистрирован = Ложь;
		Результат.Расшифровка     = НСтр("ru = 'Началась регистрация сведений для расчета пособия (документ получен Фондом)'");
		
	ИначеЕсли СтатусВРег = "ERROR" Тогда
		Результат.Приоритет       = 2;
		Результат.Зарегистрирован = Ложь;
		Результат.Расшифровка     = НСтр("ru = 'Регистрация отклонена, выявлены ошибки не позволяющие зарегистрировать сведения для расчета пособия'");
		
	ИначеЕсли СтатусВРег = "PROCESSED" Тогда
		Результат.Приоритет       = 3;
		Результат.Зарегистрирован = Истина;
		Результат.Расшифровка     = НСтр("ru = 'Сведения для расчета пособия приняты (зарегистрированы)'");
	
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли