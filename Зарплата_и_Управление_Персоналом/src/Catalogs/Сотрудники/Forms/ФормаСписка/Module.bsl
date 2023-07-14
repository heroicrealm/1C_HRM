#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем ИдентификаторЗамера;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеШтатнымРасписаниемФормы.УстановитьУсловноеОформлениеСпискаПодразделений(ЭтотОбъект, "Подразделения", "СформированоНаСегодня", "РасформированоНаСегодня");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Настройка вида списка сотрудников по умолчанию.
	НастройкаВидВсеСотрудники = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("СписокСотрудников", "ВидВсеСотрудники");
	ВидВсеСотрудники = ?(НастройкаВидВсеСотрудники = Неопределено, Истина, НастройкаВидВсеСотрудники);
	
	Если Не ВидВсеСотрудники Тогда
		НастройкаВидПоПодразделениям = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("СписокСотрудников", "ВидПоПодразделениям");
		ВидПоПодразделениям = ?(НастройкаВидПоПодразделениям = Неопределено, Истина, НастройкаВидПоПодразделениям);
	Иначе
		ВидПоПодразделениям = Ложь;
	КонецЕсли;
	
	НастройкаВидПоГруппам = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("СписокСотрудников", "ВидПоГруппам");
	ВидПоГруппам = ?(НастройкаВидПоГруппам = Неопределено, Не ВидВсеСотрудники И Не ВидПоПодразделениям, НастройкаВидПоГруппам);
	
	ПоказыватьСотрудниковПодчиненныхПодразделений = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("СписокСотрудников", "ПоказыватьСотрудниковПодчиненныхПодразделений");
	
	СотрудникиФормы.УстановитьМенюВводаНаОсновании(ЭтаФорма, "ОформитьДокумент");
	
	ИсключаемыеИменаПолейОтборов = "ЭтоГоловнойСотрудник";
	
	// Настройка списка в зависимости от значения функциональной опции ИспользоватьШтатноеРасписание.
	ИспользоватьШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокПодразделение",
		"Видимость",
		Не ИспользоватьШтатноеРасписание);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокДолжность",
		"Видимость",
		Не ИспользоватьШтатноеРасписание);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокДолжностьПоШтатномуРасписанию",
		"Видимость",
		ИспользоватьШтатноеРасписание);
	
	// Установка параметров динамических списков
	ДатаОкончания = КонецДня(ТекущаяДатаСеанса());
	ДатаНачала = НачалоДня(ДатаОкончания);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаНачала", ДатаНачала, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаНачалаСведений", ДатаНачала, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаОкончания", ДатаОкончания, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Подразделения, "ДатаОкончания", ДатаОкончания, Истина);
	
	// Отбор по головному сотруднику.
	ПоказыватьПодработки = Неопределено;
	Если Параметры.Отбор.Свойство("ПоказыватьПодработки", ПоказыватьПодработки) Тогда
		
		Если ПоказыватьПодработки <> Истина Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"ЭтоГоловнойСотрудник",
				Истина,
				ВидСравненияКомпоновкиДанных.Равно,
				,
				Истина);
			
		КонецЕсли;
		
		Параметры.Отбор.Удалить("ПоказыватьПодработки");
		
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ПоказыватьПодработки", ПоказыватьПодработки = Истина, Истина);
	
	// Отбор сотрудников в архиве
	Если Параметры.Отбор.Свойство("ВАрхиве") И  Параметры.Отбор.ВАрхиве = Ложь Тогда
		
		ВидимостьСкрыватьСотрудниковПоКоторымУжеНеВыполняютсяОперации = Истина;
		УстановитьОтборСотрудниковВАрхиве(ЭтаФорма, Истина);
		ИсключаемыеИменаПолейОтборов = ИсключаемыеИменаПолейОтборов + ",ВАрхиве";
		СкрыватьСотрудниковПоКоторымУжеНеВыполняютсяОперации = Истина;
		Параметры.Отбор.Удалить("ВАрхиве");
		
	Иначе
		ВидимостьСкрыватьСотрудниковПоКоторымУжеНеВыполняютсяОперации = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СкрыватьСотрудниковПоКоторымУжеНеВыполняютсяОперации",
		"Видимость",
		ВидимостьСкрыватьСотрудниковПоКоторымУжеНеВыполняютсяОперации);
	
	Если Параметры.Отбор.Свойство("Подразделение") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ВидСпискаГруппа",
			"Видимость",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПоказыватьСотрудниковПодчиненныхПодразделений",
			"Видимость",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Список",
			"ИзменятьСоставСтрок",
			Ложь);
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ДолжностьПоШтатномуРасписанию")
		И ЗначениеЗаполнено(Параметры.Отбор.ДолжностьПоШтатномуРасписанию) Тогда
		
		Если Не ПустаяСтрока(ИсключаемыеИменаПолейОтборов) Тогда
			ИсключаемыеИменаПолейОтборов = ИсключаемыеИменаПолейОтборов + ",";
		КонецЕсли;
		
		ИсключаемыеИменаПолейОтборов = ИсключаемыеИменаПолейОтборов + "ДолжностьПоШтатномуРасписанию";
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДолжностьПоШтатномуРасписанию", Параметры.Отбор.ДолжностьПоШтатномуРасписанию);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ШтатноеРасписание.Владелец.ГоловнаяОрганизация КАК Организация,
			|	ШтатноеРасписание.Владелец КАК Филиал
			|ИЗ
			|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
			|ГДЕ
			|	ШтатноеРасписание.Ссылка = &ДолжностьПоШтатномуРасписанию";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			
			Параметры.Отбор.Вставить("Организация", Выборка.Организация);
			ИсключаемыеИменаПолейОтборов = ИсключаемыеИменаПолейОтборов + ",Организация";
			
			Если Выборка.Организация <> Выборка.Филиал Тогда
				Параметры.Отбор.Вставить("Филиал", Выборка.Филиал);
				ИсключаемыеИменаПолейОтборов = ИсключаемыеИменаПолейОтборов + ",Филиал";
			КонецЕсли; 
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СписокДолжностьПоШтатномуРасписанию",
			"Видимость",
			Ложь);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		МодульОрганизационнаяСтруктура = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		МодульОрганизационнаяСтруктура.ПриСозданииФормСпискаИлиВыбораСотрудников(ЭтотОбъект, Параметры);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ИспытательныйСрокСотрудников") Тогда
		МодульИспытательныйСрок = ОбщегоНазначения.ОбщийМодуль("ИспытательныйСрокСотрудников");
		МодульИспытательныйСрок.ПриСозданииФормСпискаИлиВыбораСотрудников(ЭтотОбъект, "СостояниеГруппа", Список);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		МодульОхранаТрудаФормы = ОбщегоНазначения.ОбщийМодуль("ОхранаТрудаФормы");
		МодульОхранаТрудаФормы.ПриСозданииФормСпискаИлиВыбораСотрудников(ЭтотОбъект, "ДатаПриема", Ложь);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Подразделение") Тогда
		ПрименятьПользовательскиеНастройки = Ложь;
		УстановитьОтображениеСписков(Истина, Ложь, Ложь, Ложь);
	Иначе
		ПрименятьПользовательскиеНастройки = Истина;
		УстановитьОтображениеСписков(ВидВсеСотрудники, ВидПоПодразделениям, ВидПоГруппам, Ложь);
	КонецЕсли;
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", , , , ИсключаемыеИменаПолейОтборов);
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список", Новый Структура("ИмяПоляИндикатораПроблем", "ИндикаторПроблем"));
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		
		МодульОрганизационнаяСтруктураКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОрганизационнаяСтруктураКлиент");
		МодульОрганизационнаяСтруктураКлиент.НастроитьСписокОрганизационнойСтруктуры(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкрыватьСотрудниковПоКоторымУжеНеВыполняютсяОперацииПриИзменении(Элемент)
	
	УстановитьОтборСотрудниковВАрхиве(ЭтаФорма, СкрыватьСотрудниковПоКоторымУжеНеВыполняютсяОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСотрудниковПодчиненныхПодразделенийПриИзменении(Элемент)
	
	Если Элементы.ФормаПоПодразделениям.Пометка Тогда
		УстановитьОтборПоПодразделению();
	ИначеЕсли Элементы.ФормаПоГруппам.Пометка Тогда
		УстановитьОтборПоГруппеСотрудниковНаКлиенте();
	КонецЕсли;
	
	СохранитьНастройкуПоказыватьСотрудниковПодчиненныхПодразделений(ПоказыватьСотрудниковПодчиненныхПодразделений);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииЭлементаОтбора(Элемент)
	
	ОбновитьНастройкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОрганизационнаяСтруктураПриАктивизацииСтроки(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		МодульОрганизационнаяСтруктураКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОрганизационнаяСтруктураКлиент");
		МодульОрганизационнаяСтруктураКлиент.СписокСотрудниковОрганизационнаяСтруктураПриАктивизацииСтроки(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыПодразделения

&НаКлиенте
Процедура ПодразделенияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("УстановитьОтборПоПодразделению", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыСотрудников

&НаКлиенте
Процедура ТаблицаГруппСотрудниковПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("УстановитьОтборПоГруппеСотрудников", 0.1, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТаблицаГруппСотрудниковПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ГруппыСотрудников.ДинамическийСписокГруппСотрудниковПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаГруппСотрудниковПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	Если Строка <> Неопределено Тогда
		
		Если ПодходящийРодитель(Строка) Тогда
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
		Иначе
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаГруппСотрудниковПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка <> Неопределено Тогда
		ДобавитьСотрудниковВГруппу(Строка, ПараметрыПеретаскивания.Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПриЗагрузкеПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Если Не ПрименятьПользовательскиеНастройки Тогда
		
		ПользовательскиеНастройки = СотрудникиКлиентСерверРасширенный.ПользовательскиеОтборы(Список);
		Если ПользовательскиеНастройки <> Неопределено Тогда
			ПользовательскиеНастройки.Очистить();
		КонецЕсли;
		
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
	
	ЭлементОтбораПоФилиалу = Неопределено;
	ОтборПоФилиалу = Неопределено;
	ЭлементыОтбораПользовательскихНастроек = Неопределено;
	Для Каждого ЭлементПользовательскихНастроек Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		
		Если ТипЗнч(ЭлементПользовательскихНастроек) = Тип("ОтборКомпоновкиДанных") Тогда
			
			ЭлементыОтбораПользовательскихНастроек = ЭлементПользовательскихНастроек;
			Для Каждого ЭлементОтбора Из ЭлементПользовательскихНастроек.Элементы Цикл
				
				Если ТипЗнч(ЭлементОтбора) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
					Продолжить;
				КонецЕсли;
				
				Если ЭлементОтбора.Использование
					И ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
					
					Если ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СписокЗначений") Тогда
						
						Организация = Новый СписокЗначений;
						Для Каждого ЭлементСписка Из ЭлементОтбора.ПравоеЗначение Цикл
							Организация.Добавить(ЗарплатаКадры.ГоловнаяОрганизация(ЭлементСписка.Значение));
						КонецЦикла;
						
					Иначе
						
						Организация = ЗарплатаКадры.ГоловнаяОрганизация(ЭлементОтбора.ПравоеЗначение);
						Если ЭлементОтбора.ПравоеЗначение <> Организация Тогда
							
							ОтборПоФилиалу = ЭлементОтбора.ПравоеЗначение;
							ЭлементОтбора.ПравоеЗначение = Организация;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
				Если ЭлементОтбора.Использование
					И ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Филиал") Тогда
					
					ЭлементОтбораПоФилиалу = ЭлементОтбора;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОтборПоФилиалу <> Неопределено Тогда
		
		Если ЭлементОтбораПоФилиалу = Неопределено Тогда
			
			Если ЭлементыОтбораПользовательскихНастроек = Неопределено Тогда
				ЭлементыОтбораПользовательскихНастроек = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ЭлементыОтбораПользовательскихНастроек, "Филиал", ОтборПоФилиалу, , , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ, Новый УникальныйИдентификатор);
			
		Иначе
			ЭлементОтбораПоФилиалу.ПравоеЗначение = ОтборПоФилиалу;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		СтандартнаяОбработка = Ложь;
		Элементы.Список.СоздатьЭлементыФормыПользовательскихНастроек();
	КонецЕсли;
	
	ПодключитьОбработчикиСобытийЭлементамПолейОтбора();
	
	ОбновитьНастройкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормыНовогоЭлементаСправочникаСотрудники");
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ИдентификаторЗамера = Неопределено Тогда
		ИдентификаторЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени();
	КонецЕсли;
	ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамера, "ОткрытиеФормыЭлементаСправочникаСотрудники");
	ИдентификаторЗамера = Неопределено;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ОформитьНаОсновании(Команда)
	
	СотрудникиКлиент.ОформитьНаОсновании(ЭтаФорма, Элементы.Список.ТекущаяСтрока, Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииНеВыполняются(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 0 Тогда
		
		ОперацияУстановить = Истина;
		Для каждого СотрудникСсылка Из Элементы.Список.ВыделенныеСтроки Цикл
			
			Если Элементы.Список.ДанныеСтроки(СотрудникСсылка).ВАрхиве Тогда
				ОперацияУстановить = Ложь;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ОперацияУстановить Тогда
			ТекстВопроса = НСтр("ru='Установить отметку того, что все операции по %1 завершены'") + "?";
		Иначе
			ТекстВопроса = НСтр("ru='Снять отметку того, что все операции по %1 завершены'") + "?";
		КонецЕсли;
		
		Если Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстВопроса,
				НСтр("ru='сотруднику'") + " " + Элементы.Список.ВыделенныеСтроки[0]
			);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстВопроса,
				НСтр("ru='сотрудникам'")
			);
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОперацияУстановить", ОперацияУстановить);
		ДополнительныеПараметры.Вставить("Сотрудники", Элементы.Список.ВыделенныеСтроки);
		ДополнительныеПараметры.Вставить("ЭлементФормыСписок", Элементы.Список);
		
		Оповещение = Новый ОписаниеОповещения("ОперацииНеВыполняютсяЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Нет);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеСотрудники(Команда)
	
	Если Не Элементы.ФормаВсеСотрудники.Пометка Тогда
		УстановитьОтображениеСписков(Истина, Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоГруппам(Команда)
	
	Если Не Элементы.ФормаПоГруппам.Пометка Тогда
		УстановитьОтображениеСписков(Ложь, Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПодразделениям(Команда)
	
	Если Не Элементы.ФормаПоПодразделениям.Пометка Тогда
		УстановитьОтображениеСписков(Ложь, Истина, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСотрудников(Команда)
	
	ОбновитьСотрудниковНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьОДнеРождения(Команда)
	ОткрытьФормуНапоминаниеОДнеРождения();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоОрганизационнойСтруктуре(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		
		МодульОрганизационнаяСтруктураКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОрганизационнаяСтруктураКлиент");
		МодульОрганизационнаяСтруктураКлиент.СписокСотрудниковПоОрганизационнойСтруктуре(ЭтотОбъект);
		
		УстановитьОтображениеСписков(Ложь, Ложь, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	ИдентификаторЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени();
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамИзСписка(ЭтотОбъект, "Список", Поле, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	КонецЕсли;
	ИдентификаторЗамера = Неопределено;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

&НаСервере
Процедура УстановитьОтборПоДате()
	
	ТекущаяРабочаяДата = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ДатаОкончания = КонецДня(ТекущаяРабочаяДата);
	ДатаНачала = НачалоДня(ДатаОкончания);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаНачала", ДатаНачала, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаНачалаСведений", ДатаНачала, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ДатаОкончания", ДатаОкончания, Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Подразделения, "ДатаОкончания", ДатаОкончания, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСотрудниковНаСервере()
	
	УстановитьОтборПоДате();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацииНеВыполняютсяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОперацииНеВыполняютсяНаСервере(ДополнительныеПараметры.Сотрудники, ДополнительныеПараметры.ОперацияУстановить);
		ДополнительныеПараметры.ЭлементФормыСписок.Обновить();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОперацииНеВыполняютсяНаСервере(Сотрудники, ОперацияУстановить)
	
	ЗначениеРеквизитовВАрхиве = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сотрудники, "ВАрхиве");
	Для каждого ОписаниеОбъекта Из ЗначениеРеквизитовВАрхиве Цикл
		
		Если ОписаниеОбъекта.Значение <> ОперацияУстановить Тогда
			
			СотрудникОбъект = ОписаниеОбъекта.Ключ.ПолучитьОбъект();
			СотрудникОбъект.ВАрхиве = ОперацияУстановить;
			СотрудникОбъект.Записать();
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОбновитьНастройкиФормы()
	
	УстановитьОтборПоДате();
	НастройкиСписка = СотрудникиФормыРасширенный.НастройкиСпискаФормы(ЭтаФорма);
	
	Если НастройкиСписка.УстановленОтборПоПодразделению И Элементы.ФормаПоПодразделениям.Пометка Тогда
		УстановитьОтображениеСписков(Истина, Ложь, Ложь);
	КонецЕсли; 
	
	СотрудникиФормыРасширенный.ПрименитьНастройкиСписка(ЭтаФорма, НастройкиСписка);
	ДополнительныеПараметры = СотрудникиФормыРасширенный.УстановитьЗапросДинамическогоСписка(ЭтаФорма, НастройкиСписка.ОтборыСписка, Ложь);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаСервере
Процедура ПодключитьОбработчикиСобытийЭлементамПолейОтбора(ГруппаФормы = Неопределено)
	
	Если ГруппаФормы = Неопределено Тогда
		ГруппаФормы = Элементы.СписокКомпоновщикНастроекПользовательскиеНастройки
	КонецЕсли; 
	
	Для каждого ЭлементГруппы Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(ЭлементГруппы) = Тип("ГруппаФормы") Тогда
			ПодключитьОбработчикиСобытийЭлементамПолейОтбора(ЭлементГруппы);
		КонецЕсли; 
		
		Если ТипЗнч(ЭлементГруппы) = Тип("ПолеФормы") Тогда
			ЭлементГруппы.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзмененииЭлементаОтбора");
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоПодразделению()
	
	Если Элементы.ФормаПоПодразделениям.Пометка
		И Элементы.Подразделения.ВыделенныеСтроки.Количество() > 0 Тогда
		
		Если ПоказыватьСотрудниковПодчиненныхПодразделений Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
		Иначе
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
		КонецЕсли;
		
		ОтборПоПодразделениям = Неопределено;
		ОтборыПоПодразделениям = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
			Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
			,
			"ОтборПоПодразделениям");
			
		Если ОтборыПоПодразделениям.Количество() > 0 Тогда
			ОтборПоПодразделениям = ОтборыПоПодразделениям[0];
			ОтборПоПодразделениям.Элементы.Очистить();
		Иначе
			ОтборПоПодразделениям = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
				Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы, "ОтборПоПодразделениям", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		КонецЕсли; 
		
		ВыделенныеПодразделения = Новый Массив;
		ВыделенныеФилиалы = Новый Массив;
		Для каждого ВыделеннаяСтрока Из Элементы.Подразделения.ВыделенныеСтроки Цикл
			
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
				ВыделенныеПодразделения.Добавить(ВыделеннаяСтрока);
			Иначе
				ВыделенныеФилиалы.Добавить(ВыделеннаяСтрока.Ключ);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ВыделенныеПодразделения.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ОтборПоПодразделениям, "Подразделение", ВыделенныеПодразделения, ВидСравненияОтбора);
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				ОтборПоПодразделениям, "Филиал", ВыделенныеФилиалы, ВидСравненияОтбора);
		КонецЕсли; 
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, , "ОтборПоПодразделениям");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоГруппеСотрудниковНаКлиенте()
	
	Если Элементы.ФормаПоГруппам.Пометка
		И Элементы.ТаблицаГруппСотрудников.ВыделенныеСтроки.Количество() > 0 Тогда
		
		УстановитьОтборПоГруппеСотрудников();
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, , "ОтборПоГруппеСотрудников");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоГруппеСотрудников()
	
	Если Элементы.ТаблицаГруппСотрудников.ВыделенныеСтроки.Количество() > 0 Тогда
		
		СписокГрупп = Новый Массив;
		Для каждого ГруппаСотрудников Из Элементы.ТаблицаГруппСотрудников.ВыделенныеСтроки Цикл
			
			Если ЗначениеЗаполнено(ГруппаСотрудников) Тогда
				СписокГрупп.Добавить(ГруппаСотрудников);
			КонецЕсли;
			
		КонецЦикла;
		
		Если СписокГрупп.Количество() > 0 Тогда
			
			Результат = УстановитьОтборПоГруппеСотрудниковНаСервере(СписокГрупп);
			Если Не Результат.Статус = "Выполнено" Тогда
				
				ИдентификаторЗадания = Результат.ИдентификаторЗадания;
				АдресХранилища		 = Результат.АдресРезультата;
				
				ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
				ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
				
			Иначе
				
				УстановитьОтборСотрудниковПоГруппам(АдресХранилища);
				
			КонецЕсли;
			
		Иначе
			УстановитьОтборСотрудниковПоГруппам();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				УстановитьОтборСотрудниковПоГруппам(АдресХранилища);
				
			Иначе
				
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
				
				КонецЕсли;
				
			КонецЕсли;
			
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
			
		КонецЕсли;
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСотрудниковПоГруппам(АдресХранилища = Неопределено)
	
	Если АдресХранилища = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, , "ОтборПоГруппеСотрудников");
		
	Иначе
		
		ОтборПоГруппеСотрудников = Неопределено;
		ОтборыПоГруппеСотрудников = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
			Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
			,
			"ОтборПоГруппеСотрудников");
		
		Если ОтборыПоГруппеСотрудников.Количество() > 0 Тогда
			ОтборПоГруппеСотрудников = ОтборыПоГруппеСотрудников[0];
		КонецЕсли;
		
		СотрудникиГрупп = ПолучитьИзВременногоХранилища(АдресХранилища);
		Если ОтборПоГруппеСотрудников = Неопределено Тогда
			
			ОтборПоГруппеСотрудников = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
				Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы, "ОтборПоГруппеСотрудников", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ОтборПоГруппеСотрудников, "Ссылка", СотрудникиГрупп, ВидСравненияКомпоновкиДанных.ВСписке);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УстановитьОтборПоГруппеСотрудниковНаСервере(СписокГрупп)
	
	ПараметрыПолученияСотрудниковПоГруппам = Новый Структура("СписокГрупп,ПоказыватьСотрудниковПодчиненныхПодразделений",
		СписокГрупп, ПоказыватьСотрудниковПодчиненныхПодразделений);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение сотрудников по группам'");
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"ГруппыСотрудников.СотрудникиГруппСотрудниковВФоне",
		ПараметрыПолученияСотрудниковПоГруппам,
		ПараметрыВыполнения);
	
	АдресХранилища = Результат.АдресРезультата;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСотрудниковВАрхиве(Форма, Использование)
	
	Если Использование Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.Список, "ВАрхиве", Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Форма.Список, "ВАрхиве");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеСписков(ВсеСотрудники, ПоПодразделениям, ПоГруппам, СохранитьНастройки = Истина)
	
	Элементы.ФормаВсеСотрудники.Пометка = ВсеСотрудники;
	Элементы.ФормаПоПодразделениям.Пометка = ПоПодразделениям;
	Элементы.ФормаПоГруппам.Пометка = ПоГруппам;
	
	Если Элементы.ФормаВсеСотрудники.Пометка Тогда
		ВидимостьПодразделенияГруппыСотрудниковСтраницы = Ложь;
	Иначе
		
		ВидимостьПодразделенияГруппыСотрудниковСтраницы = Истина;
		Если Элементы.ФормаПоПодразделениям.Пометка Тогда
			ТекущаяСтраницаПодразделенияГруппыСотрудниковСтраницы = Элементы.ПодразделенияСтраница;
		Иначе
			ТекущаяСтраницаПодразделенияГруппыСотрудниковСтраницы = Элементы.ТаблицаГруппСотрудниковСтраница;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПодразделенияГруппыСотрудниковСтраницы",
			"ТекущаяСтраница",
			ТекущаяСтраницаПодразделенияГруппыСотрудниковСтраницы);
		
	КонецЕсли;
	
	ВидимостьПодразделенияСписка = Не ИспользоватьШтатноеРасписание;
	Если Не Элементы.ФормаПоПодразделениям.Пометка И Элементы.ФормаПоПодразделениям.Видимость Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, , "ОтборПоПодразделениям");
		
	Иначе
		
		Если Элементы.ФормаПоПодразделениям.Пометка
			И Не ИспользоватьШтатноеРасписание Тогда
			ВидимостьПодразделенияСписка = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокПодразделение",
		"Видимость",
		ВидимостьПодразделенияСписка);
	
	Если Не Элементы.ФормаПоГруппам.Пометка Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, , "ОтборПоГруппеСотрудников");
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПодразделенияГруппыСотрудниковСтраницы",
		"Видимость",
		ВидимостьПодразделенияГруппыСотрудниковСтраницы);
	
	Если СохранитьНастройки Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СписокСотрудников", "ВидВсеСотрудники", Элементы.ФормаВсеСотрудники.Пометка);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СписокСотрудников", "ВидПоПодразделениям", Элементы.ФормаПоПодразделениям.Пометка);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СписокСотрудников", "ВидПоГруппам", Элементы.ФормаПоГруппам.Пометка);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		
		МодульОрганизационнаяСтруктура = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		МодульОрганизационнаяСтруктура.СписокСотрудниковУстановитьОтображениеСписков(ЭтотОбъект, СохранитьНастройки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкуПоказыватьСотрудниковПодчиненныхПодразделений(ПоказыватьСотрудниковПодчиненныхПодразделений)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("СписокСотрудников", "ПоказыватьСотрудниковПодчиненныхПодразделений", ПоказыватьСотрудниковПодчиненныхПодразделений);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодходящийРодитель(Ссылка)
	Возврат Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ФормироватьАвтоматически");
КонецФункции

&НаСервере
Процедура ДобавитьСотрудниковВГруппу(СтрокаГруппы, Сотрудники)
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаГруппы, "ФормироватьАвтоматически") Тогда
		Возврат;
	КонецЕсли; 
	
	Набор = РегистрыСведений.СоставГруппСотрудников.СоздатьНаборЗаписей();
	Набор.Отбор.ГруппаСотрудников.Установить(СтрокаГруппы);
	
	Набор.Прочитать();
	СотрудникиНабора = Набор.ВыгрузитьКолонку("Сотрудник");
	
	ЗаписатьНабор = Ложь;
	Для каждого Сотрудник Из Сотрудники Цикл
		
		Если Не ЗначениеЗаполнено(Сотрудник)
			Или ТипЗнч(Сотрудник) <> Тип("СправочникСсылка.Сотрудники") Тогда
			
			Продолжить;
			
		КонецЕсли; 
		
		Если СотрудникиНабора.Найти(Сотрудник) = Неопределено Тогда
			
			ЗаписатьНабор = Истина;
			
			Запись = Набор.Добавить();
			Запись.ГруппаСотрудников = СтрокаГруппы;
			Запись.Сотрудник = Сотрудник;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Если ЗаписатьНабор Тогда
		Набор.Записать();
	КонецЕсли; 
	
КонецПроцедуры

#Область НапоминанияСотрудника

&НаКлиенте
Процедура ОткрытьФормуНапоминаниеОДнеРождения()

	МассивСотрудников = Новый Массив;
	
	Для каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		МассивСотрудников.Добавить(ВыделеннаяСтрока);
	КонецЦикла; 
	
	Если МассивСотрудников.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура("СписокПредметов", АдресСпискаСотрудниковНаСервере(МассивСотрудников, УникальныйИдентификатор));
	ОткрытьФорму("ОбщаяФорма.НапоминаниеОДнеРождения", ПараметрыОткрытияФормы, ЭтаФорма, УникальныйИдентификатор,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
 
&НаСервереБезКонтекста
Функция АдресСпискаСотрудниковНаСервере(МассивСотрудников, ИдентификаторФормы)
	Возврат ПоместитьВоВременноеХранилище(МассивСотрудников, ИдентификаторФормы);
КонецФункции

#КонецОбласти

#КонецОбласти
