
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ ОтражениеЗарплатыВБухучетеРасширенный.ДоступноИзменениеБухучетаЗарплатыПодразделений() Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли; 
	
	Если ТолькоПросмотр Тогда
		
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ФормаКомандаОК",
			"Доступность",
			Ложь);
			
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
	Период = Параметры.Период;
	ИспользуетсяЕНВД = ОтражениеЗарплатыВБухучете.ИспользуетсяЕНВД(Период);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТаблицаРаспределенияОтношениеКЕНВД",
		"Видимость",
		ИспользуетсяЕНВД);
	
	Для каждого СтрокаТЗ Из Параметры.ТаблицаРаспределения Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаРаспределения.Добавить(), СтрокаТЗ);
	КонецЦикла;
	
	
КонецПроцедуры


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Отказ = Ложь;
	ОповеститьОбИзменениях(Отказ);
	Если НЕ Отказ Тогда
		Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОповеститьОбИзменениях(Отказ)
	
	Если Модифицированность Тогда
		
		ОчиститьСообщения();
		
		Если ПроверитьЗаполнение() Тогда
			
			ИменаКолонок = "СпособОтраженияЗарплатыВБухучете,СтатьяФинансирования,ОтношениеКЕНВД,ДоляРаспределения";
			СтруктураВозврата = Новый Массив;
			Для каждого СтрокаРаспределениеРезультатов Из ТаблицаРаспределения Цикл
				ОписаниеСтроки = Новый Структура(ИменаКолонок);
				ЗаполнитьЗначенияСвойств(ОписаниеСтроки, СтрокаРаспределениеРезультатов);
				СтруктураВозврата.Добавить(ОписаниеСтроки);
			КонецЦикла; 
			
			ПараметрыОповещения = Новый Структура;
			ПараметрыОповещения.Вставить("Период", Период); 
			ПараметрыОповещения.Вставить("ТаблицаРаспределения", Новый ФиксированныйМассив(СтруктураВозврата));
			Оповестить("ИзмененоРаспределениеБухучетЗарплаты", ПараметрыОповещения, ВладелецФормы);
			
			Модифицированность = Ложь;
			
		Иначе
			Отказ = Истина;
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТаблицаРаспределения.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='Не заполнено распределение'");
		Возврат;
	КонецЕсли;	
	
	ИменаКолонок = Новый Массив;
	Если ИспользуетсяЕНВД Тогда
		ИменаКолонок.Добавить("ОтношениеКЕНВД");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный") Тогда
		ИменаКолонок.Добавить("СтатьяФинансирования");
	КонецЕсли;
	ИменаКолонок.Добавить("СпособОтраженияЗарплатыВБухучете");
	ИменаКолонок.Добавить("ДоляРаспределения");
	
	ОписаниеКолонок = Новый Соответствие;
	РеквизитыТаблицы = ПолучитьРеквизиты("ТаблицаРаспределения");
	Для каждого РеквизитТаблицы Из РеквизитыТаблицы Цикл
		Если ИменаКолонок.Найти(РеквизитТаблицы.Имя) <> Неопределено Тогда
			ОписаниеКолонок.Вставить(РеквизитТаблицы.Имя, РеквизитТаблицы.Заголовок);
		КонецЕсли; 
	КонецЦикла;
	
	НомерСтроки = 0;
	Для каждого РаспределяемаяСтрока Из ТаблицаРаспределения Цикл
		
		Для каждого ОписаниеКолонки Из ОписаниеКолонок Цикл
			
			Если НЕ ЗначениеЗаполнено(РаспределяемаяСтрока[ОписаниеКолонки.Ключ]) Тогда
				
				ЗаголовокКолонки = ОписаниеКолонки.Значение;
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Поле ""%1"" не заполнено'"),
				ЗаголовокКолонки);
				
				ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				,
				"ТаблицаРаспределения[" + НомерСтроки + "]." + ОписаниеКолонки.Ключ,
				,
				Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
			
		НомерСтроки = НомерСтроки + 1;	
		
	КонецЦикла;
	
КонецПроцедуры



