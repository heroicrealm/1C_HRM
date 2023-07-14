
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийБСП
// Обработка программных событий, возникающих в подсистемах БСП.
// Только для вызовов из библиотеки БСП в БТС.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - Структура - Ключами свойств структуры являются имена событий, на которые
//           подписана эта библиотека.
//
Процедура ПриОпределенииПодписокНаСобытияБСП(Подписки) Экспорт
	
	// БазоваяФункциональность
	Подписки.ПередНачаломРаботыСистемы = Истина;
	Подписки.ПриНачалеРаботыСистемы = Истина;
	
	// ЗавершениеРаботыПользователей
	Подписки.ПриЗавершенииСеансов = Истина;
	
	// ПрофилиБезопасности
	Подписки.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов = Истина;
	
КонецПроцедуры

#Область БазоваяФункциональность

// См. процедуру ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы
// Параметры:
//	Параметры - см. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.Параметры
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	Параметры.Модули.Добавить(РаботаВМоделиСервисаКлиент);
	Параметры.Модули.Вставить(0, ВыгрузкаЗагрузкаДанныхКлиент);
	
КонецПроцедуры

// См. процедуру ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
// Параметры:
//	Параметры - Структура:
//	 * Модули - Массив - ссылки на модули.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Параметры.Модули.Добавить(ВитриныКлиент);
	Параметры.Модули.Добавить(МиграцияПриложенийКлиент);
	Параметры.Модули.Добавить(КаталогРасширенийКлиент);
	
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеРаботыПользователей

// См. процедуру УдаленноеАдминистрированиеБТСКлиент.ПриЗавершенииСеансов.
Процедура ПриЗавершенииСеансов(ФормаВладелец, Знач НомераСеансов, СтандартнаяОбработка, Знач ОповещениеПослеЗавершенияСеанса = Неопределено) Экспорт
	
	УдаленноеАдминистрированиеБТСКлиент.ПриЗавершенииСеансов(ФормаВладелец, НомераСеансов, СтандартнаяОбработка, ОповещениеПослеЗавершенияСеанса);
	
КонецПроцедуры

#КонецОбласти

#Область ПрофилиБезопасности

// См. процедуру РаботаВБезопасномРежимеКлиентПереопределяемый.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов.
Процедура ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт

	НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервисаКлиент.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(
		ИдентификаторыЗапросов, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ИнформационныйЦентр

// См. ВызовОнлайнПоддержкиКлиент.ОбработкаОповещения.
Процедура ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения(ИмяСобытия, Элемент) Экспорт
	
	Если ИнтеграцияПодсистемБТСКлиентПовтИсп.ПодпискиБСП().ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения Тогда
		ИнтеграцияПодсистемБСПКлиент.ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения(ИмяСобытия, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет события, на которые могут подписаться другие библиотеки.
//
// Возвращаемое значение:
//   Структура - ключами свойств структуры являются имена событий, на которые могут быть подписаны библиотеки:
//   * ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения - Булево - Ложь по-умолчанию.
//
Функция СобытияБТС() Экспорт
	
	События = Новый Структура;
	
	// ВыгрузкаЗагрузкаДанных
	События.Вставить("ИнтеграцияВызовОнлайнПоддержкиКлиентОбработкаОповещения", Ложь);
	
	Возврат События;
	
КонецФункции

#КонецОбласти