#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ЛицензияДатаНачала) И ЗначениеЗаполнено(Объект.ЛицензияДатаОкончания) 
			И ЗначениеЗаполнено(Объект.ЛицензияНаименование) Тогда
			
		// Информация по лицензии
		ЛицензияДатаОкончания = Объект.ЛицензияДатаОкончания;
		ИнформацияОЛицензии = НСтр("ru = 'Лицензия ""%1""
									|Действует с %2 по %3'");
									
		ИнформацияОЛицензии = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ИнформацияОЛицензии, 
			Объект.ЛицензияНаименование, 
			Формат(Объект.ЛицензияДатаНачала, "ДЛФ=D"), 
			Формат(ЛицензияДатаОкончания, "ДЛФ=D"));
		
		Элементы.ИнформацияОЛицензии.Заголовок = ИнформацияОЛицензии;
		
		// Информация по срокам окончания лицензии
		Месяц = 30 * 24 * 60 * 60;
		ТекДата = ТекущаяДатаСеанса();
		// Прибавляем один день, так как в день окончания лицензия еще действует.
		ЛицензияДатаОкончания = ЛицензияДатаОкончания + 24*60*60;
		
		СрокИстеченияЛицензии = ОбработкаЗаявленийАбонентаКлиентСервер.ТекстЧерезСколькоЛетМесяцевНедельДней(ТекДата, ЛицензияДатаОкончания, "", "");
		
		Если СрокИстеченияЛицензии = Неопределено Тогда
			// Лицензия истекла
			СрокИстеченияЛицензии 	= НСтр("ru='Срок действия лицензии истек '") + Формат(ЛицензияДатаОкончания, "ДЛФ=D");
		Иначе
			
			Если НачалоДня(ЛицензияДатаОкончания) - НачалоДня(ТекДата) < Месяц Тогда
				// Лицензия, срок действия которой заканчивается МЕНЕЕ чем через месяц
				СрокИстеченияЛицензии = НСтр("ru='Срок действия лицензии истекает через '") + СрокИстеченияЛицензии;
			Иначе
				// Если срок действия лицензии заканчивается БОЛЕЕ чем через месяц, то предупреждение не показываем
			 	Элементы.ИнформацияОбОкончанииСрокаДействия.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.ИнформацияОбОкончанииСрокаДействия.Заголовок = СрокИстеченияЛицензии;

	Иначе
		
		// Если нет информации о лицензии
		Элементы.ИнформацияОЛицензии.Заголовок = НСтр("ru = 'Информация о лицензии на 1С-Отчетность отсутсвует'");
		Элементы.ИнформацияОбОкончанииСрокаДействия.Видимость = Ложь;
		
	КонецЕсли;
	
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

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

