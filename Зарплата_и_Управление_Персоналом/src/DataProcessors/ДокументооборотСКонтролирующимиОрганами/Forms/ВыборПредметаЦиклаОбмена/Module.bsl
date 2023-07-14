
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АдресТаблицыПредметовИзЦикловОбмена = Параметры.АдресТаблицыПредметовИзЦикловОбмена;
	ТаблицаПредметовИзХранилища = ПолучитьИзВременногоХранилища(АдресТаблицыПредметовИзЦикловОбмена);
	
	// Заполняем таблицу на основе таблицы из хранилища
	ИсходнаяТаблицаПредметов.Очистить();
	Для каждого СтрокаТаблицыПредметовИзХранилища Из ТаблицаПредметовИзХранилища Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицыПредметовИзХранилища.Предмет) Тогда 
			
			НоваяСтрока = ИсходнаяТаблицаПредметов.Добавить();
			
			// Для регламентированного отчета формируем представление по отдельному алгоритму
			Если ТипЗнч(СтрокаТаблицыПредметовИзХранилища.Предмет) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
				НоваяСтрока.ПредставлениеПредмета = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеДокументаРеглОтч(
					СтрокаТаблицыПредметовИзХранилища.Предмет);
			Иначе
				НоваяСтрока.ПредставлениеПредмета = СтрокаТаблицыПредметовИзХранилища.Предмет;
			КонецЕСли;
			
			// Заполнение остальных полей таблицы
			НоваяСтрока.Предмет 		= СтрокаТаблицыПредметовИзХранилища.Предмет;
			НоваяСтрока.Организация 	= СтрокаТаблицыПредметовИзХранилища.Организация;
			НоваяСтрока.ТипПредмета 	= СтрокаТаблицыПредметовИзХранилища.Предмет.Метаданные().Синоним;
			
		КонецЕсли;
	КонецЦикла;
	
	// Копируем исходную таблицу в таблицу с отборами
	ВосстановитьИсходноеСостояниеТаблицы();
	
	ТекущийОбъект = Параметры.ТекущийОбъект;
	
	СформироватьСписокВыбораТипов();
	СформироватьСписокВыбораОрганизаций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Устанавливаем текущую строку
	Если ЗначениеЗаполнено(ТекущийОбъект) Тогда
		
		НайденныеСтроки = ТаблицаПредметовСОтборами.НайтиСтроки(Новый Структура("Предмет", ТекущийОбъект));
		ИдентификаторСтроки = Неопределено;
		Если НайденныеСтроки.Количество() > 0 Тогда
			ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
		Если ИдентификаторСтроки <> Неопределено Тогда
			Элементы.ТаблицаПредметовСОтборами.ТекущаяСтрока = ИдентификаторСтроки;
			Организация = Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные.Организация;
			ТипПредмета = Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные.ТипПредмета; 
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьОтборыИСформироватьСпискиВыбора();
КонецПроцедуры

&НаКлиенте
Процедура ТипПредметаПриИзменении(Элемент)
	УстановитьОтборыИСформироватьСпискиВыбора();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	УстановитьОтборыИСформироватьСпискиВыбора();
КонецПроцедуры

&НаКлиенте
Процедура ТипПредметаОчистка(Элемент, СтандартнаяОбработка)
	УстановитьОтборыИСформироватьСпискиВыбора();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ТаблицаПредметовСОтборамиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные.Предмет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПредмет(Команда)
	
	Если Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные <> Неопределено Тогда
		Если Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные.Предмет <> Неопределено Тогда
			ПоказатьЗначение(, Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные.Предмет);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные = Неопределено Тогда
		Закрыть(Неопределено);
	Иначе
		Закрыть(Элементы.ТаблицаПредметовСОтборами.ТекущиеДанные.Предмет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьСписокВыбораТипов()
	
	// Формируем список
	Элементы.ТипПредмета.СписокВыбора.Очистить();
	Для каждого Строка Из ИсходнаяТаблицаПредметов Цикл
		Если Элементы.ТипПредмета.СписокВыбора.НайтиПоЗначению(Строка.ТипПредмета) = Неопределено Тогда
			Элементы.ТипПредмета.СписокВыбора.Добавить(Строка.ТипПредмета, Строка.ТипПредмета);
		КонецЕсли;
	КонецЦикла;
	
	// Если в списке типов кроме эл. представления и рег. отчетов есть другие виды отчетов, 
	// то вместо "Регламентированный отчет" выводим фразу "Прочие регламентированные отчеты"
	Если Элементы.ТипПредмета.СписокВыбора.НайтиПоЗначению("Электронные представления регламентированных отчетов") <> Неопределено 
		И Элементы.ТипПредмета.СписокВыбора.НайтиПоЗначению("Регламентированный отчет") <> Неопределено 
		И Элементы.ТипПредмета.СписокВыбора.Количество() > 2 
	Тогда
		
		ЭлементВыбора = Элементы.ТипПредмета.СписокВыбора.НайтиПоЗначению("Регламентированный отчет");
		
		Элементы.ТипПредмета.СписокВыбора.Удалить(ЭлементВыбора);
		Элементы.ТипПредмета.СписокВыбора.Добавить("Регламентированный отчет", "Прочие регламентированные отчеты");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокВыбораОрганизаций()
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		ОрганизацияПоУмолчанию = Модуль.ОрганизацияПоУмолчанию();
		
		Элементы.Организация.СписокВыбора.Добавить(ОрганизацияПоУмолчанию, ОрганизацияПоУмолчанию);
	Иначе
		Элементы.Организация.СписокВыбора.Очистить();
		Для каждого Строка Из ИсходнаяТаблицаПредметов Цикл
			Если Элементы.Организация.СписокВыбора.НайтиПоЗначению(Строка.Организация) = Неопределено Тогда
				Элементы.Организация.СписокВыбора.Добавить(Строка.Организация, Строка.Организация);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьИсходноеСостояниеТаблицы()
	
	ВременнаяТаблица = ИсходнаяТаблицаПредметов.Выгрузить();
	ЗначениеВРеквизитФормы(ВременнаяТаблица, "ТаблицаПредметовСОтборами");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборы()
	
	// Если не выбрана текущая строка, отбор не накладываем
	Если Элементы.ТаблицаПредметовСОтборами.ТекущаяСтрока = Неопределено Тогда
		ТекущаяСтрока = Неопределено;
	Иначе
		ТекущаяСтрока = ТаблицаПредметовСОтборами.НайтиПоИдентификатору(Элементы.ТаблицаПредметовСОтборами.ТекущаяСтрока);
	КонецЕсли;
	
	// Копируем исходную таблицу в таблицу с отборами
	ВосстановитьИсходноеСостояниеТаблицы();
	
	// Формируем отбор
	СтруктураОтбора = Новый Структура;
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураОтбора.Вставить("Организация", Организация);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТипПредмета) Тогда
		СтруктураОтбора.Вставить("ТипПредмета", ТипПредмета);
	КонецЕсли;
	
	// Накладываем отбор на таблицу
	Если СтруктураОтбора.Количество() <> 0 Тогда
		
		ВременнаяТаблица = ИсходнаяТаблицаПредметов.Выгрузить();
		НайденныеСтроки = ВременнаяТаблица.НайтиСтроки(СтруктураОтбора);
		ВременнаяТаблица = ВременнаяТаблица.Скопировать(НайденныеСтроки);
		
		ЗначениеВРеквизитФормы(ВременнаяТаблица, "ТаблицаПредметовСОтборами");
 		
	КонецЕсли;
	
	// Устанавливаем курсор на ту же строку, которая была активной до отбора
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущийПредмет = ТекущаяСтрока.Предмет;
		НайденныеСтроки = ТаблицаПредметовСОтборами.НайтиСтроки(Новый Структура("Предмет", ТекущийПредмет));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ИдентификаторСтроки = НайденныеСтроки[0].ПолучитьИдентификатор();
			Элементы.ТаблицаПредметовСОтборами.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыИСформироватьСпискиВыбора()
	УстановитьОтборы();
	СформироватьСписокВыбораОрганизаций();
	СформироватьСписокВыбораТипов();
КонецПроцедуры


#КонецОбласти
