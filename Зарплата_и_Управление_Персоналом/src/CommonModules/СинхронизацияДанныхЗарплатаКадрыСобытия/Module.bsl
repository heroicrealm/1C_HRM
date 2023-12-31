////////////////////////////////////////////////////////////////////////////////
// Подсистема "Синхронизация данных".
// Серверные процедуры и функции, обслуживающие подписки на события.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Обмен РИБ Зарплата и управление персоналом 3.0.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации
// объектов на узлах.
//
// Параметры:
//		Источник	- источник события, кроме типа ДокументОбъект.
//		Отказ		- Булево - флаг отказа от выполнения обработчика.
//
Процедура ОбменДаннымиСОтборомРегистрация(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменВРаспределеннойИнформационнойБазе", Источник, Отказ);
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" констант для механизма регистрации объектов на узлах.
//
// Параметры:
//		Источник	- источник события, кроме типа ДокументОбъект.
//		Отказ		- Булево - флаг отказа от выполнения обработчика.
//
Процедура ОбменДаннымиСОтборомРегистрацияКонстанты(Источник, Отказ) Экспорт

	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("ОбменВРаспределеннойИнформационнойБазе", Источник, Отказ);
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах.
//
// Параметры:
//		Источник	- ДокументОбъект - источник события.
//		Отказ		- Булево - флаг отказа от выполнения обработчика.
//
Процедура ОбменДаннымиСОтборомРегистрацияДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменВРаспределеннойИнформационнойБазе", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах.
//
// Параметры:
//		Источник	- НаборЗаписейРегистра - источник события.
//		Отказ		- Булево - флаг отказа от выполнения обработчика.
//		Замещение	- Булево - признак замещения существующего набора записей.
//
Процедура ОбменДаннымиСОтборомРегистрацияНабора(Источник, Отказ, Замещение) Экспорт

	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменВРаспределеннойИнформационнойБазе", Источник, Отказ, Замещение);
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров расчета для механизма регистрации объектов на узлах.
//
// Параметры:
//		Источник	- НаборЗаписейРегистра - источник события.
//		Отказ		- Булево - флаг отказа от выполнения обработчика.
//		Замещение	- Булево - признак замещения существующего набора записей.
//
Процедура ОбменДаннымиСОтборомРегистрацияНабораРасчета(Источник, Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов) Экспорт

	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменВРаспределеннойИнформационнойБазе", Источник, Отказ, Замещение);
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах.
//
// Параметры:
//		Источник	- источник события.
//		Отказ		- Булево - флаг отказа от выполнения обработчика.
//
Процедура ОбменДаннымиСОтборомРегистрацияУдаления(Источник, Отказ) Экспорт

	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменВРаспределеннойИнформационнойБазе", Источник, Отказ);
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#Область ВторичныеДанные

Процедура ПриЗагрузкеПервичныхДанныхНабораПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСОтборомПриЗагрузкеПередЗаписью(Источник, Отказ); // АПК:БЗК.75 Требуется для формирования вторичных данных
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗагрузкеПервичныхДанныхНабораПриЗаписи(Источник, Отказ, Замещение) Экспорт
	ОбменДаннымиСОтборомПриЗагрузкеПриЗаписи(Источник, Отказ);
КонецПроцедуры

Процедура ПриЗагрузкеПервичныхДанныхОбъектаПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСОтборомПриЗагрузкеПередЗаписью(Источник, Отказ); // АПК:БЗК.75 Требуется для регистрации изменений на другие узлы
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗагрузкеПервичныхДанныхОбъектаПриЗаписи(Источник, Отказ) Экспорт
	ОбменДаннымиСОтборомПриЗагрузкеПриЗаписи(Источник, Отказ);
КонецПроцедуры

#КонецОбласти

#Область ФизическиеЛица

Процедура ИзменитьСвязиФизическогоЛицаОбъектПередЗаписью(Источник, Отказ) Экспорт
	
	СинхронизацияДанныхЗарплатаКадрыСервер.ПринадлежностьФизлицаПередЗаписью(Источник); // АПК:БЗК.75 Требуется для регистрации изменений на другие узлы
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьСвязиФизическогоЛицаОбъектПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	СинхронизацияДанныхЗарплатаКадрыСервер.ПринадлежностьФизлицаОрганизацииПриЗаписи(Источник);
	СинхронизацияДанныхЗарплатаКадрыСервер.ПринадлежностьФизлицаПодразделениюПриЗаписи(Источник);
	
КонецПроцедуры

Процедура ИзменитьСвязиФизическогоЛицаНаборЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	// АПК:БЗК.75-выкл Требуется для регистрации изменений на другие узлы
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Источник.Метаданные().ПолноеИмя());
	МенеджерОбъекта.ПринадлежностьНабораПередЗаписью(Источник);
	// АПК:БЗК.75-вкл
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьСвязиФизическогоЛицаНаборЗаписейПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Источник.Метаданные().ПолноеИмя());
	МенеджерОбъекта.ПодразделенияФизическихЛицПриЗаписиРегистра(Источник);
	
КонецПроцедуры

#КонецОбласти

#Область Сотрудники

Процедура ИзменитьСвязиСотрудникаОбъектПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	СинхронизацияДанныхЗарплатаКадрыСервер.ОрганизацииСотрудниковПередЗаписью(Источник); // АПК:БЗК.75 Требуется для регистрации изменений на другие узлы
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьСвязиСотрудникаОбъектПриЗаписи(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	СинхронизацияДанныхЗарплатаКадрыСервер.ОрганизацииСотрудниковПриЗаписи(Источник);
	
КонецПроцедуры

Процедура ИзменитьСвязиСотрудникаНаборЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	// АПК:БЗК.75-выкл Требуется для регистрации изменений на другие узлы
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Источник.Метаданные().ПолноеИмя());
	МенеджерОбъекта.ПринадлежностьНабораПередЗаписью(Источник);
	// АПК:БЗК.75-вкл
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьСвязиСотрудникаНаборЗаписейПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Источник.Метаданные().ПолноеИмя());
	МенеджерОбъекта.ПодразделенияСотрудниковПриЗаписиРегистра(Источник);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбменДаннымиСОтборомПриЗагрузкеПередЗаписью(Источник, Отказ)
	
	Если Не Источник.ДополнительныеСвойства.Свойство("ПодготовитьОбновлениеЗависимыхДанныхПриОбмене") Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.ПодготовитьОбновлениеЗависимыхДанныхПриОбмене = Истина Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Источник.Метаданные().ПолноеИмя());
		МенеджерОбъекта.ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПередЗаписью(Источник);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбменДаннымиСОтборомПриЗагрузкеПриЗаписи(Источник, Отказ)
	
	Если Не Источник.ДополнительныеСвойства.Свойство("ПодготовитьОбновлениеЗависимыхДанныхПриОбмене") Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.ПодготовитьОбновлениеЗависимыхДанныхПриОбмене = Истина Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Источник.Метаданные().ПолноеИмя());
		МенеджерОбъекта.ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПриЗаписи(Источник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
