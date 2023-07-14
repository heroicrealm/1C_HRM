#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ПериодДействия", ПериодДействия);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("Подразделение", Подразделение);
	Параметры.Свойство("ГруппироватьПоДокументамНачисления", ГруппироватьПоДокументамНачисления);
	
	Если Параметры.Свойство("Сотрудники") Тогда
		
		Если Не ПустаяСтрока(Параметры.Сотрудники) Тогда
			Сотрудники.ЗагрузитьЗначения(ПолучитьИзВременногоХранилища(Параметры.Сотрудники));
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьПерерасчетыЗарплаты();
	
	Заголовок = НСтр("ru='Перерасчеты за'") + " " + Формат(ПериодДействия, "ДФ='ММММ гггг'");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДокументыНачисления",
		"Видимость",
		ГруппироватьПоДокументамНачисления);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыНачисления

&НаКлиенте
Процедура ДокументыНачисленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Значение) Тогда
		
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыНачисленияПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		
		ОтборСтрокТаблицыЗарплата = Новый Структура;
		ОтборСтрокТаблицыЗарплата.Вставить("ДокументНачисления", Элемент.ТекущиеДанные.Значение);
		Элементы.ТаблицаЗарплата.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрокТаблицыЗарплата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЗарплата

&НаКлиенте
Процедура ТаблицаЗарплатаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаЗарплата.ТекущиеДанные <> Неопределено Тогда
		
		Если Поле.Имя = "ТаблицаЗарплатаПричина" Тогда
			ОткрытьПричиныПерерасчетаЗарплаты(Элемент);
		ИначеЕсли Поле.Имя = "ТаблицаЗарплатаСотрудник" Тогда
			ПоказатьЗначение( , Элемент.ТекущиеДанные.Сотрудник);
		Иначе
			
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("Сотрудник", Элементы.ТаблицаЗарплата.ТекущиеДанные.Сотрудник);
			ПараметрыОткрытия.Вставить("ПериодДействия", Элементы.ТаблицаЗарплата.ТекущиеДанные.Период);
			
			ОткрытьФорму("Обработка.УправлениеПерерасчетами.Форма.ПодробнееОПерерасчетах", ПараметрыОткрытия, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьПричиныПерерасчетаЗарплаты(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.Причина.Количество() > 0 Тогда
		
		Если ТекущиеДанные.Причина.Количество() = 1 Тогда
			ОткрытьПричиныПерерасчетаЗарплатыЗавершение(ТекущиеДанные.Причина[0]);
		Иначе
			
			Оповещение = Новый ОписаниеОповещения("ОткрытьПричиныПерерасчетаЗарплатыЗавершение", ЭтотОбъект);
			ПоказатьВыборИзСписка(Оповещение, ТекущиеДанные.Причина, Элемент);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПричиныПерерасчетаЗарплатыЗавершение(Результат, ДополнительныеСвойства = Неопределено) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОткрытьФормуОбъекта(Результат.Значение);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОбъекта(СсылкаНаОбъект, ПараметрыОткрытия = Неопределено)
	
	Если ПараметрыОткрытия = Неопределено Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", СсылкаНаОбъект);
	КонецЕсли; 
	
	ОткрытьФорму(ИмяОбъектаМетаданных(СсылкаНаОбъект) + ".ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяОбъектаМетаданных(Ссылка)
	
	Возврат Ссылка.Метаданные().ПолноеИмя();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПерерасчетыЗарплаты()
	
	ТаблицаЗарплата.Очистить();
	ДокументыНачисления.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", ПериодДействия);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаПерерасчетов.Организация,
		|	ТаблицаПерерасчетов.Сотрудник КАК Сотрудник,
		|	ТаблицаПерерасчетов.ФизическоеЛицо,
		|	ТаблицаПерерасчетов.ПериодДействия КАК ПериодДействия,
		|	ТаблицаПерерасчетов.Основание КАК Основание,
		|	ТаблицаПерерасчетов.ДокументНачисления КАК ДокументНачисления,
		|	ИСТИНА КАК ПерерасчетНачислений,
		|	ЛОЖЬ КАК ПерерасчетЛьгот,
		|	ЛОЖЬ КАК ПерерасчетУдержаний
		|ПОМЕСТИТЬ ВТПерерасчеты
		|ИЗ
		|	РегистрСведений.ПерерасчетЗарплаты КАК ТаблицаПерерасчетов
		|ГДЕ
		|	ТаблицаПерерасчетов.Организация = &Организация
		|	И ТаблицаПерерасчетов.ПериодДействия = &Период
		|	И &ОтборПоСотрудникам
		|	И &ОтборПоПодразделению
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаПерерасчетов.Организация,
		|	NULL,
		|	ТаблицаПерерасчетов.ФизическоеЛицо,
		|	ТаблицаПерерасчетов.ПериодДействия,
		|	ТаблицаПерерасчетов.Основание,
		|	ТаблицаПерерасчетов.ДокументНачисления,
		|	ЛОЖЬ,
		|	ЛОЖЬ,
		|	ИСТИНА
		|ИЗ
		|	РегистрСведений.ПерерасчетУдержаний КАК ТаблицаПерерасчетов
		|ГДЕ
		|	ТаблицаПерерасчетов.Организация = &Организация
		|	И ТаблицаПерерасчетов.ПериодДействия = &Период
		|	И &ОтборУдержанийПоСотрудникам
		|	И &ОтборПоПодразделению";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		
		ДополнительныеУсловия = "ТаблицаПерерасчетов.ПериодДействия = &Период
			|	И &ОтборПоСотрудникам
			|	И &ОтборПоПодразделению";
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.ДобавитьОбъединениеСПерерасчетамиЛьгот(Запрос.Текст, ДополнительныеУсловия);
		
	КонецЕсли;
	
	Если Сотрудники.Количество() > 0 Тогда
		
		Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоСотрудникам", "ТаблицаПерерасчетов.Сотрудник В (&Сотрудники)");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборУдержанийПоСотрудникам",
			"ТаблицаПерерасчетов.ФизическоеЛицо В (
			|		ВЫБРАТЬ
			|			Сотрудники.ФизическоеЛицо
			|		ИЗ
			|			Справочник.Сотрудники КАК Сотрудники
			|		ГДЕ
			|			Сотрудники.Ссылка В (&Сотрудники))");
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоСотрудникам", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборУдержанийПоСотрудникам", "");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоПодразделению", "ТаблицаПерерасчетов.ДокументНачисления.Подразделение = &Подразделение");
		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоПодразделению", "");
	КонецЕсли;
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПерерасчетЗарплаты.Организация КАК Организация,
		|	ЕСТЬNULL(МАКСИМУМ(ПерерасчетЗарплаты.Сотрудник), МАКСИМУМ(ДанныеСотрудников.Сотрудник)) КАК Сотрудник,
		|	ЕСТЬNULL(МАКСИМУМ(ПерерасчетЗарплаты.Сотрудник.Наименование), МАКСИМУМ(ДанныеСотрудников.Сотрудник.Наименование)) КАК НаименованиеСотрудника,
		|	ПерерасчетЗарплаты.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПерерасчетЗарплаты.ПериодДействия КАК ПериодДействия,
		|	ПерерасчетЗарплаты.Основание КАК Основание,
		|	ПерерасчетЗарплаты.ДокументНачисления КАК ДокументНачисления,
		|	МАКСИМУМ(ПерерасчетЗарплаты.ПерерасчетНачислений) КАК ПерерасчетНачислений,
		|	МАКСИМУМ(ПерерасчетЗарплаты.ПерерасчетЛьгот) КАК ПерерасчетЛьгот,
		|	МАКСИМУМ(ПерерасчетЗарплаты.ПерерасчетУдержаний) КАК ПерерасчетУдержаний
		|ИЗ
		|	ВТПерерасчеты КАК ПерерасчетЗарплаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ДанныеСотрудников
		|		ПО ПерерасчетЗарплаты.ФизическоеЛицо = ДанныеСотрудников.ФизическоеЛицо
		|			И ПерерасчетЗарплаты.Организация.ГоловнаяОрганизация = ДанныеСотрудников.ГоловнаяОрганизация
		|			И (ПерерасчетЗарплаты.ПериодДействия МЕЖДУ ДанныеСотрудников.ДатаНачала И ДанныеСотрудников.ДатаОкончания)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПерерасчетЗарплаты.Организация,
		|	ПерерасчетЗарплаты.ФизическоеЛицо,
		|	ПерерасчетЗарплаты.ПериодДействия,
		|	ПерерасчетЗарплаты.Основание,
		|	ПерерасчетЗарплаты.ДокументНачисления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЕСТЬNULL(МАКСИМУМ(ПерерасчетЗарплаты.Сотрудник.Наименование), МАКСИМУМ(ДанныеСотрудников.Сотрудник.Наименование)),
		|	ПерерасчетЗарплаты.ПериодДействия,
		|	ПерерасчетЗарплаты.ДокументНачисления,
		|	ПерерасчетЗарплаты.Основание";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Сотрудник") Цикл
			
			Пока Выборка.СледующийПоЗначениюПоля("ПериодДействия") Цикл
				
				Пока Выборка.СледующийПоЗначениюПоля("ДокументНачисления") Цикл
					
					НоваяСтрока = ТаблицаЗарплата.Добавить();
					НоваяСтрока.Сотрудник = Выборка.Сотрудник;
					НоваяСтрока.ФизическоеЛицо = Выборка.ФизическоеЛицо;
					НоваяСтрока.Период = Выборка.ПериодДействия;
					НоваяСтрока.ДокументНачисления = Выборка.ДокументНачисления;
					
					Пока Выборка.Следующий() Цикл
						
						ПерерасчетЗарплаты.ДобавитьПричинуПерерасчета(НоваяСтрока.Причина, Выборка.Основание);
						
						Если Выборка.ПерерасчетНачислений Тогда
							НоваяСтрока.ПерерасчетНачислений = Истина;
						КонецЕсли;
						
						Если Выборка.ПерерасчетЛьгот Тогда
							НоваяСтрока.ПерерасчетЛьгот = Истина;
						КонецЕсли;
						
						Если Выборка.ПерерасчетУдержаний Тогда
							НоваяСтрока.ПерерасчетУдержаний = Истина;
						КонецЕсли;
					
					КонецЦикла;
					
					НоваяСтрока.ПричинаНеизвестна = НоваяСтрока.Причина.Количество() = 0;
					
					Если ДокументыНачисления.НайтиПоЗначению(НоваяСтрока.ДокументНачисления) = Неопределено Тогда
						ДокументыНачисления.Добавить(НоваяСтрока.ДокументНачисления);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
