#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	Если ТолькоПросмотр Тогда
		Элементы.Готово.Видимость = Ложь;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
	КонецЕсли;
	
	Сумма = Параметры.Сумма;
	СуммаНДС = Параметры.СуммаНДС;
	УчитыватьНДС = Параметры.УчитыватьНДС;
	Для Каждого СтрокаПараметра Из Параметры.СтатьиДДС Цикл
		ЗаполнитьЗначенияСвойств(ВыбранныеСтатьи.Добавить(), СтрокаПараметра);
	КонецЦикла;
	
	ЗаполнитьДеревоСтатей(ДеревоСтатей.ПолучитьЭлементы());
	
	Элементы.ВыбранныеСтатьиСуммаНДС.Видимость = УчитыватьНДС;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПодвал();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоСтатей

&НаКлиенте
Процедура ДеревоСтатейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ДеревоСтатей.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено 
		И Не ТекущиеДанные.ЭтоГруппа Тогда
		ДобавитьСтатьюКВыбранным(ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтатейПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = ДеревоСтатей.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоСтатейПоИдентификатору(Строка, Лист.СтатьяДДСID);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтатейПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоСтатей.ТекущиеДанные;
	ДоступенВыбор = (ТекущиеДанные <> Неопределено)
		И Не ТекущиеДанные.ЭтоГруппа
		И Не ТолькоПросмотр;
	Если ДоступенВыбор Тогда
		СтруктураПоиска = Новый Структура("СтатьяДДСID", ТекущиеДанные.СтатьяДДСID);
		ДоступенВыбор = ДоступенВыбор
			И (ВыбранныеСтатьи.НайтиСтроки(СтруктураПоиска).Количество() = 0);
	КонецЕсли;
	
	Элементы.ПеренестиВправо.Доступность = ДоступенВыбор;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеСтатьи

&НаКлиенте
Процедура ВыбранныеСтатьиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ВыбранныеСтатьи.ТекущиеДанные;
	ДоступенВыбор = (ТекущиеДанные <> Неопределено) 
		И Не ТолькоПросмотр;
	Элементы.ПеренестиВлево.Доступность = ДоступенВыбор;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеСтатьиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле <> Элементы.ВыбранныеСтатьиСтатьяДДС Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ВыбранныеСтатьи.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено
		И Не ТолькоПросмотр Тогда
		УдалитьСтатьюИзВыбранных(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВлево(Команда)
	
	ТекущиеДанные = Элементы.ВыбранныеСтатьи.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УдалитьСтатьюИзВыбранных(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВправо(Команда)
	
	ТекущиеДанные = Элементы.ДеревоСтатей.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено 
		И Не ТекущиеДанные.ЭтоГруппа Тогда
		ДобавитьСтатьюКВыбранным(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Результат = Новый Массив;
	Для Каждого Строка Из ВыбранныеСтатьи Цикл
		СтрокаРезультата = Новый Структура;
		СтрокаРезультата.Вставить("СтатьяДДС", Строка.СтатьяДДС);
		СтрокаРезультата.Вставить("СтатьяДДСID", Строка.СтатьяДДСID);
		СтрокаРезультата.Вставить("СтатьяДДСТип", Строка.СтатьяДДСТип);
		СтрокаРезультата.Вставить("Сумма", Строка.Сумма);
		СтрокаРезультата.Вставить("СуммаНДС", Строка.СуммаНДС);
		Результат.Добавить(СтрокаРезультата);
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоСтатей(ВеткаДерева, ИдентификаторПапки = "")
	
	ВеткаДерева.Очистить();
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	СписокУсловий = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	УсловияОтбора = СписокУсловий.conditions; // СписокXDTO
	
	Если ЗначениеЗаполнено(ИдентификаторПапки) Тогда
		
		РодительИд = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ИдентификаторПапки, "DMCashFlowItem");
		
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "Parent";
		Условие.value = РодительИд;
		Если Условие.Свойства().Получить("comparisonOperator") <> Неопределено Тогда
			Условие.comparisonOperator = "=";
		КонецЕсли;
		
		УсловияОтбора.Добавить(Условие);
		
	КонецЕсли;
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMCashFlowItem";
	Запрос.query = СписокУсловий;
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Для Каждого Элемент Из Результат.items Цикл
		Если Элемент.Установлено("parentID") Тогда
			ИдентификаторРодителяЭлемента = Элемент.parentID.ID;
		Иначе
			ИдентификаторРодителяЭлемента = "";
		КонецЕсли;
		Если ИдентификаторПапки = ИдентификаторРодителяЭлемента Тогда
			НоваяСтрока = ВеткаДерева.Добавить();
			ЗаполнитьЭлементДереваСтатей(НоваяСтрока, Элемент);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементДереваСтатей(НоваяСтрока, Элемент)
	
	НоваяСтрока.СтатьяДДС = Элемент.object.name;
	НоваяСтрока.СтатьяДДСID = Элемент.object.objectID.ID;
	НоваяСтрока.СтатьяДДСТип = Элемент.object.objectID.type;
	НоваяСтрока.ЭтоГруппа = Элемент.isFolder;
	
	Если Элемент.isFolder Тогда
		НоваяСтрока.НомерКартинки = 0;
	Иначе
		НоваяСтрока.НомерКартинки = ИнтеграцияС1СДокументооборот.ИндексКартинкиЭлементаСправочника();
	КонецЕсли;
	
	Если Элемент.isFolder Тогда
		НоваяСтрока.ПодпапкиСчитаны = Ложь;
		НоваяСтрока.ПолучитьЭлементы().Добавить();
	Иначе
		НоваяСтрока.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоСтатейПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = ДеревоСтатей.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоСтатей(Лист.ПолучитьЭлементы(), Лист.СтатьяДДСID);
	
КонецПроцедуры

// Добавляет статью в список выбранных, обновляя общий список.
//
// Параметры:
//   ВыбраннаяСтрока - ДанныеФормыЭлементКоллекции - выбранная к добавлению строка.
//
&НаКлиенте
Процедура ДобавитьСтатьюКВыбранным(ВыбраннаяСтрока)
	
	ИтогСумма = 0; ИтогСуммаНДС = 0;
	Для Каждого Строка Из ВыбранныеСтатьи Цикл
		Если Строка.СтатьяДДСID = ВыбраннаяСтрока.СтатьяДДСID Тогда
			Возврат;
		КонецЕсли;
		ИтогСумма = ИтогСумма + Строка.Сумма;
		ИтогСуммаНДС = ИтогСуммаНДС + Строка.СуммаНДС;
	КонецЦикла;
	
	Строка = ВыбранныеСтатьи.Добавить();
	Строка.СтатьяДДС = ВыбраннаяСтрока.СтатьяДДС;
	Строка.СтатьяДДСID = ВыбраннаяСтрока.СтатьяДДСID;
	Строка.СтатьяДДСТип = ВыбраннаяСтрока.СтатьяДДСТип;
	Если ИтогСумма < Сумма Тогда
		Строка.Сумма = Сумма - ИтогСумма;
		Если ИтогСуммаНДС < СуммаНДС Тогда
			Строка.СуммаНДС = СуммаНДС - ИтогСуммаНДС;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьПодвал();
	
КонецПроцедуры

// Удаляет статью из списка выбранных, обновляя общий список.
//
// Параметры:
//   ВыбраннаяСтрока - ДанныеФормыЭлементКоллекции - выбранная к удалению строка.
//
&НаКлиенте
Процедура УдалитьСтатьюИзВыбранных(ВыбраннаяСтрока)
	
	Для Каждого Строка Из ВыбранныеСтатьи Цикл
		Если Строка.СтатьяДДСID = ВыбраннаяСтрока.СтатьяДДСID Тогда
			ВыбранныеСтатьи.Удалить(Строка);
			ОбновитьПодвал();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обновляет итоги в подвале.
//
&НаКлиенте
Процедура ОбновитьПодвал()
	
	ИтогСумма = 0;
	ИтогСуммаНДС = 0;
	Для Каждого Строка Из ВыбранныеСтатьи Цикл
		ИтогСумма = ИтогСумма + Строка.Сумма;
		ИтогСуммаНДС = ИтогСуммаНДС + Строка.СуммаНДС;
	КонецЦикла;
	Элементы.ВыбранныеСтатьиСумма.ТекстПодвала = Формат(ИтогСумма, "ЧДЦ=2; ЧГ=3,0");
	Элементы.ВыбранныеСтатьиСуммаНДС.ТекстПодвала = Формат(ИтогСуммаНДС, "ЧДЦ=2; ЧГ=3,0");
	
КонецПроцедуры

#КонецОбласти