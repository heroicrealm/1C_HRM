#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Описание - возвращает описание разделов данных, которые содержит документ
// 
// Возвращаемое значение:
// 	Соответствие - описание разделов данных документов -
//	 *Ключ - Строка - имя раздела. Одно из значений структуры 
//		возвращаемой методом см. МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных
//   *Значение - см. МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных - описание раздела
//
Функция ОписаниеРазделовДанных() Экспорт
	ВсеРазделы = МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных();
	
	ОписаниеРазделовДанных = Новый Соответствие();
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.КадровыеДанные, ОписаниеРаздела);	
	ОписаниеРаздела.РеквизитСостояние = "Проведен";
	ОписаниеРаздела.РеквизитОтветсвенный = "Ответственный";
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.ПлановыеНачисления, ОписаниеРаздела);
	ОписаниеРаздела.РеквизитСостояние = "РазмерОплатыУтвержден";	
	ОписаниеРаздела.ТребуетсяУтверждениеПриПроведении = Истина;
	ОписаниеРаздела.СообщениеДокументНеУтвержден = НСтр("ru = '%1 - документ не утвержден.'");
	
	Возврат ОписаниеРазделовДанных;
КонецФункции

// Описание - возвращает структуру со значениями по которым будут проверяться права на разделы документа
// 				 
// Параметры:
//  ДокументОбъект - ДокументОбъект.ПереводНаОплатуПоСреднемуЗаработку, ДанныеФормыСтруктура - объект или данные формы, 
//					отображающие данные документа, для которого нужно получить данные
//
// Возвращаемое значение:
// 	Структура -  см. НовыйЗначенияДоступа - значения доступа по которым будут проверяться права на документ
//
Функция ЗначенияДоступа(ДокументОбъект) Экспорт
	Возврат МногофункциональныеДокументыБЗК.ЗначенияДоступаПоСоставуДокумента(
		ДокументОбъект, 
		ДокументОбъект.Организация);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке();
КонецФункции

Функция СвойстваИсправляемогоДокумента(ДокументСсылка) Экспорт
	
	Реквизиты = ИсправлениеДокументовЗарплатаКадры.РеквизитыИсправляемогоДокумента();
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, Реквизиты);
	
КонецФункции

Функция ПараметрыИсправляемогоДокумента(ДокументСсылка) Экспорт
	
	Возврат ИсправлениеДокументовЗарплатаКадры.ПараметрыИсправляемогоДокумента(ДокументСсылка,
		СвойстваИсправляемогоДокумента(ДокументСсылка));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Функция ТекстСообщенияНеЗаполненВидРасчета() Экспорт
	
	ТекстСообщения = НСтр("ru = 'Не найдено ни одного начисления для регистрации оплаты.'");
	Возврат ТекстСообщения;
	
КонецФункции

// Функция возвращает структуру с описанием данного вида документа.
//
Функция ОписаниеДокумента() Экспорт 

	ОписаниеДокумента = ЗарплатаКадрыРасширенныйКлиентСервер.СтруктураОписанияДокумента();
	
	ОписаниеДокумента.КраткоеНазваниеИменительныйПадеж	 = НСтр("ru = 'перевод'");
	ОписаниеДокумента.КраткоеНазваниеРодительныйПадеж	 = НСтр("ru = 'перевода'");
	ОписаниеДокумента.ИмяРеквизитаСотрудник				 = "Сотрудник";
	ОписаниеДокумента.ИмяРеквизитаДатаНачалаСобытия		 = "ДатаНачала";
	ОписаниеДокумента.ИмяРеквизитаДатаОкончанияСобытия	 = "ДатаОкончания";
	
	Возврат ОписаниеДокумента;

КонецФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ПереводНаОплатуПоСреднемуЗаработку);
	
КонецФункции

#КонецОбласти
	
#КонецЕсли