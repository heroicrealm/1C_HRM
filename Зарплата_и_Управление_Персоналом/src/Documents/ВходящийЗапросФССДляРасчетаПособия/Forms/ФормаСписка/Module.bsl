#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	ОбновитьПараметрыСписка();
	
	ПравоИзменения = СЭДОФСС.ЕстьПравоОбмена() И ПравоДоступа("Изменение", Метаданные.Документы.ВходящийЗапросФССДляРасчетаПособия);
	
	Элементы.ПолучитьНовыеСообщенияСЭДО.Видимость    = ПравоИзменения;
	Элементы.ПолучитьСообщенияСЭДОЗаПериод.Видимость = ПравоИзменения;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СЭДОФСС.ПриСозданииФормыЗапросаИлиОтветаДляРасчетаПособия(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ОбновитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ВходящийЗапросФССДляРасчетаПособия"
		Или ИмяСобытия = "Запись_БольничныйЛист"
		Или ИмяСобытия = "Запись_ОтпускПоУходуЗаРебенком"
		Или ИмяСобытия = "Запись_Отпуск"
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения() Тогда
		ОтключитьОбработчикОжидания("ОбновитьСписок");
		ПодключитьОбработчикОжидания("ОбновитьСписок", 0.2, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоОрганизацииПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыВРаботеПриИзменении(Элемент)
	ОбновитьСписок();
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

&НаКлиенте
Процедура ОбновитьСписок()
	ОбновитьСписокНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНаСервере()
	ОбновитьПараметрыСписка();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыСписка()
	ОтборКД = Список.КомпоновщикНастроек.Настройки.Отбор;
	
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
	ЭлементОтбораКД.Использование  = ЗначениеЗаполнено(Организация);
	ЭлементОтбораКД.ПравоеЗначение = Организация;
	
	Если ИдентификаторОтбораЗапросыВРаботе = Неопределено Тогда
		ЭлементОтбораКД = Неопределено;
	Иначе
		ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораЗапросыВРаботе);
	КонецЕсли;
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Обработан") <> 0 Тогда
		ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "Обработан", "=", Ложь);
		ИдентификаторОтбораЗапросыВРаботе = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.Использование = ЗапросыВРаботе;
КонецПроцедуры

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
