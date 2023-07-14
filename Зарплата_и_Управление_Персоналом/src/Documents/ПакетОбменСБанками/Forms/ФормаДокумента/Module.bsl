
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокВыбораСтатусовПакета();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеВидимостьюДоступностью(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеВидимостьюДоступностью(ЭтотОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСообщения

&НаКлиенте
Процедура СообщенияОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение( , Элемент.ТекущиеДанные.Сообщение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РаспаковатьПакетЭД(Команда)
	
	МассивПЭД = Новый Массив;
	МассивПЭД.Добавить(Объект.Ссылка);
	РаспаковатьМассивПакетов(МассивПЭД);
	Прочитать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораСтатусовПакета()
	
	Если Объект.Направление = Перечисления.НаправленияЭДО.Входящий Тогда
		Элементы.СтатусПакета.СписокВыбора.ЗагрузитьЗначения(СписокСтатусовВходящий());
	Иначе
		Элементы.СтатусПакета.СписокВыбора.ЗагрузитьЗначения(СписокСтатусовИсходящий());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостьюДоступностью(Форма, Объект)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"КомандаРаспаковатьПакет",
		"Видимость",
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыТранспортныхСообщенийБЭД.КРаспаковке"));
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокСтатусовВходящий()
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.КРаспаковке);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Распакован);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Неизвестный);
	
	Возврат МассивСтатусов;
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокСтатусовИсходящий()
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Доставлен);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отменен);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отправлен);
	МассивСтатусов.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.ПодготовленКОтправке);
	
	Возврат МассивСтатусов;
	
КонецФункции

&НаКлиенте
Процедура РаспаковатьМассивПакетов(МассивПакетов)
	
	ТекстСообщения = НСтр("ru = 'Выполняется распаковка пакетов электронных документов. Подождите...'");
	Состояние(НСтр("ru = 'Распаковка.'"), , ТекстСообщения);
	
	ВсегоРаспаковано = 0;
	ДанныеДляОбработкиНаКлиенте = Неопределено;
	РаспаковатьПакетыНаСервере(МассивПакетов, ДанныеДляОбработкиНаКлиенте);
	
	Для Каждого ДанныеВозврата Из ДанныеДляОбработкиНаКлиенте Цикл
		Если Не ДанныеВозврата.ЕстьОшибка Тогда
			ВсегоРаспаковано = ВсегоРаспаковано + 1;
		КонецЕсли;
		Если ДанныеВозврата.Свойство("ДанныеЭП") И ДанныеВозврата.ДанныеЭП.Количество() Тогда
			ПустойОбработчик = Новый ОписаниеОповещения;
			Для Каждого КлючЗначение Из ДанныеВозврата.ДанныеЭП Цикл
				ОбменСБанкамиСлужебныйКлиент.ДобавитьПодписиИОпределитьСтатусы(
					ПустойОбработчик, КлючЗначение.Ключ, КлючЗначение.Значение);
			КонецЦикла;
		КонецЕсли;
		ОбменСБанкамиСлужебныйКлиент.ВызватьОповещения(ДанныеВозврата);
		Оповестить("ОбновитьСостояниеОбменСБанками", ДанныеВозврата.ПараметрОповещения);
	КонецЦикла;
	
	СообщитьРезультатыРаспаковкиПакетовЭД(ВсегоРаспаковано);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура РаспаковатьПакетыНаСервере(Знач ПакетыЭД, ДанныеДляОбработкиНаКлиенте)
	
	ДанныеДляОбработкиНаКлиенте = Новый Массив;
	
	ПакетыЭДКРаспаковке = ОбменСБанкамиСлужебный.ГотовыеКРаспаковкеПакетыЭД(ПакетыЭД);
	Если ПакетыЭДКРаспаковке.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ПакетЭД Из ПакетыЭДКРаспаковке Цикл
		ДанныеВозврата = ОбменСБанкамиКлиентСервер.ПараметрыПолученияНовыхДокументовАсинхронныйОбмен();
		Попытка
			ОбменСБанкамиСлужебный.РаспаковатьПакетОбменСБанками(ПакетЭД, Истина, ДанныеВозврата);
			ДанныеДляОбработкиНаКлиенте.Добавить(ДанныеВозврата);
		Исключение
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ПакетЭД);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СообщитьРезультатыРаспаковкиПакетовЭД(ВсегоРаспаковано)
	
	Если НЕ ЗначениеЗаполнено(ВсегоРаспаковано) Тогда
		ВсегоРаспаковано = 0;
	КонецЕсли;
	
	ЗаголовокОповещения = НСтр("ru = '1С:ДиректБанк'");
	ТекстСообщения = НСтр("ru = 'Распаковано электронных документов: (%1)'");
	ТекстОповещения = СтрШаблон(ТекстСообщения, ВсегоРаспаковано);
	ПоказатьОповещениеПользователя(ЗаголовокОповещения, , ТекстОповещения);
	
КонецПроцедуры


#КонецОбласти