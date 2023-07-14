#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДатаСобытия", ДатаСобытия);
	Параметры.Свойство("СозданиеПриУтверждении", СозданиеПриУтверждении);
	Параметры.Отбор.Свойство("ВидТарифнойСетки", ВидТарифнойСетки);
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	Заголовок = 
		РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов(
			"ТарифнаяСеткаСписок", 
			ВидТарифнойСетки); 
	Элементы.ВидТарифнойСетки.Видимость = НЕ ЗначениеЗаполнено(ВидТарифнойСетки);
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "ВидТарифнойСетки");
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_УтверждениеТарифнойСетки" Тогда
		
		Если Параметр.Свойство("ТарифнаяСетка") Тогда
			Если Параметр.Свойство("ВидТарифнойСетки")
				И Параметр.ВидТарифнойСетки = ВидТарифнойСетки Тогда
				Элементы.Список.Обновить();
				Элементы.Список.ТекущаяСтрока = Параметр.ТарифнаяСетка;
			КонецЕсли; 
		КонецЕсли; 
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока <> Неопределено И ЗначениеЗаполнено(ДатаСобытия) Тогда 
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Ключ, ДатаСобытия, ВидТарифнойСетки", ВыбраннаяСтрока, ДатаСобытия, ВидТарифнойСетки);
		ОткрытьФорму("Справочник.ТарифныеСетки.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не СозданиеПриУтверждении Тогда
		
		Отказ = Истина;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВидТарифнойСетки", ВидТарифнойСетки);
		
		Если ЗначениеЗаполнено(ДатаСобытия) Тогда 
			ЗначенияЗаполнения.Вставить("ДатаВступленияВСилу", ДатаСобытия);
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УтверждениеНовойТарифнойСетки", Истина);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.УтверждениеТарифнойСетки.ФормаОбъекта", ПараметрыФормы );
		
	Иначе
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВидТарифнойСетки", ВидТарифнойСетки);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.ТарифныеСетки.ФормаОбъекта", ПараметрыФормы, ВладелецФормы);
		Закрыть();
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
