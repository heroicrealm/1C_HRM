
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПериодРегистрации", ПериодРегистрации);
	
	Если Параметры.МассивДат.Количество() = 0 Тогда 
		Календарь = НачалоМесяца(ПериодРегистрации);
	Иначе
		Календарь = Параметры.МассивДат[0];
	КонецЕсли;	
		
	Список.ЗагрузитьЗначения(Параметры.МассивДат);
	
	ЭлементыОформления = Новый Структура;
	ЭлементыОформления.Вставить("ВыбранныйДень", ЦветаСтиля.ЦветФонаВыделенияПоля);
	ЭлементыОформления.Вставить("НеРабочийДень", ЦветаСтиля.ЦветОсобогоТекста);
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(ЭтотОбъект, "Календарь", Параметры.Подсказка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КалендарьПриВыводеПериода(Элемент, ОформлениеПериода)

	Для Каждого СтрокаОформленияПериода Из ОформлениеПериода.Даты Цикл
		
		Элемент = Список.НайтиПоЗначению(СтрокаОформленияПериода.Дата);
		
		Если Элемент <> Неопределено Тогда
			СтрокаОформленияПериода.ЦветФона = ЭлементыОформления["ВыбранныйДень"];
		КонецЕсли;
		
		НомерДняНедели = ДеньНедели(СтрокаОформленияПериода.Дата);
		Если НомерДняНедели = 6 Или НомерДняНедели = 7 Тогда 
			СтрокаОформленияПериода.ЦветТекста = ЭлементыОформления["НеРабочийДень"];
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура КалендарьВыбор(Элемент, ВыбраннаяДата)
	
	ЭлементСписка = Список.НайтиПоЗначению(ВыбраннаяДата);
	
	Если ЭлементСписка <> Неопределено Тогда
		Список.Удалить(ЭлементСписка);
	Иначе 
		Список.Добавить(ВыбраннаяДата);
	КонецЕсли;
	
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		ЭлементСписка = Список.НайтиПоЗначению(ТекущиеДанные.Значение);
		Если ЭлементСписка <> Неопределено Тогда 
			Список.Удалить(ЭлементСписка);
			Элементы.Календарь.Обновить();
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если ЕстьОшибки() Тогда 
		Возврат;
	КонецЕсли;	
	
	ОповеститьОВыборе(Список.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)

	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЕстьОшибки()
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	УникальныеЗначения = Новый Соответствие;
	
	ИндексСтроки = 0;
	
	Для Каждого Элемент Из Список Цикл
		Если УникальныеЗначения[Элемент.Значение] = Неопределено Тогда
			УникальныеЗначения.Вставить(Элемент.Значение, Истина);
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дата %1 уже была введена ранее.'"), Формат(Элемент.Значение, "ДЛФ=Д"));
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла;
	
	Возврат Отказ;
	
КонецФункции

#КонецОбласти
