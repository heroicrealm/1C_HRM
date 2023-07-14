
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МесяцыКорректировки = Параметры.МесяцыКорректировки;
	Годы = Параметры.Годы;
	ГоловнаяОрганизация = Параметры.ГоловнаяОрганизация;
	ФизическоеЛицо = Параметры.ФизическоеЛицо;
	
	Для Каждого Строка Из Параметры.ПериодыОтсутствия Цикл
		НоваяСтрока = ПериодыОтсутствия.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ПериодыОтсутствия.Сортировать("Начало");
	
	ЗаполнитьИнформациюДоступностиПериодов();

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПредыдущееОкончание = Неопределено;
	Для Каждого Строка Из ПериодыОтсутствия Цикл
		// Не заполненные поля.
		Если Не ЗначениеЗаполнено(Строка.Начало) Тогда
			ТекстСообщения = НСтр("ru = 'Дата начала не заполнена.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "ПериодыОтсутствия[" + ПериодыОтсутствия.Индекс(Строка) + "].Начало", , Отказ);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Строка.Окончание) Тогда
			ТекстСообщения = НСтр("ru = 'Дата окончания не заполнена.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "ПериодыОтсутствия[" + ПериодыОтсутствия.Индекс(Строка) + "].Окончание", , Отказ);
		КонецЕсли;
		// Пересекающиеся периоды.
		Если ЗначениеЗаполнено(ПредыдущееОкончание) Тогда
			Если Строка.Начало <= ПредыдущееОкончание Тогда
				ТекстСообщения = НСтр("ru = 'Периоды отсутствия пересекаются.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "ПериодыОтсутствия[" + ПериодыОтсутствия.Индекс(Строка) + "].Начало", , Отказ);
			КонецЕсли;
		КонецЕсли;
		ПредыдущееОкончание = Строка.Окончание;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодыОтсутствияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ПериодыОтсутствия.ТекущиеДанные;
	
	Если ДанныеСтроки.ТолькоПросмотр = Истина Тогда
		Возврат;
	КонецЕсли;
	
	// Сразу при окончании редактирования проверяем:
	// - принадлежность к не редактируемым периодам,
	// - принадлежность к другому году.
	
	Если Не ЗначениеЗаполнено(ДанныеСтроки.Начало) Или Не ЗначениеЗаполнено(ДанныеСтроки.Окончание) Тогда
		// Не проверяем пустой период.
		Возврат;
	КонецЕсли;
	
	Если Годы.Найти(Год(ДанныеСтроки.Начало)) = Неопределено Или Годы.Найти(Год(ДанныеСтроки.Окончание)) = Неопределено  Тогда
		ТекстСообщения = НСтр("ru = 'Введенные даты не относятся к выбранным годам среднего заработка.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Если МесяцыКорректировки.Найти(НачалоМесяца(ДанныеСтроки.Начало)) = Неопределено
		Или МесяцыКорректировки.Найти(НачалоМесяца(ДанныеСтроки.Окончание)) = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Период относится к месяцу, редактирование данных которого недоступно.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Если ДанныеСтроки.Начало > ДанныеСтроки.Окончание  Тогда
		ТекстСообщения = НСтр("ru = 'Начало позже окончания.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодыОтсутствияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
		
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ВосстановитьПорядокСтрокКоллекцииПослеРедактирования(ПериодыОтсутствия, "Начало", Элемент.ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ПериодыОтсутствияНачалоПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ПериодыОтсутствия.ТекущиеДанные;
	ЗаполнитьКоличествоДней(ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодыОтсутствияОкончаниеПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ПериодыОтсутствия.ТекущиеДанные;
	ЗаполнитьКоличествоДней(ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодыОтсутствияПередУдалением(Элемент, Отказ)
	
	Если Элементы.ПериодыОтсутствия.ТекущиеДанные.ТолькоПросмотр Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодыОтсутствияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Копирование Тогда
		Элементы.ПериодыОтсутствия.ТекущиеДанные.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(РезультатРедактирования());
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВосстановитьПорядокСтрокКоллекцииПослеРедактирования(КоллекцияСтрок, ПолеУпорядочивания, ТекущаяСтрока)
	
	Если КоллекцияСтрок.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущаяСтрока[ПолеУпорядочивания]) <> Тип("Дата") 
		И Не ЗначениеЗаполнено(ТекущаяСтрока[ПолеУпорядочивания]) Тогда
		Возврат;
	КонецЕсли;
	
	ИндексИсходный = КоллекцияСтрок.Индекс(ТекущаяСтрока);
	ИндексРезультат = ИндексИсходный;
	
	// Выбираем направление, в котором нужно сдвинуть.
	Направление = 0;
	Если ИндексИсходный = 0 Тогда
		// вниз
		Направление = 1;
	КонецЕсли;
	Если ИндексИсходный = КоллекцияСтрок.Количество() - 1 Тогда
		// вверх
		Направление = -1;
	КонецЕсли;
	
	Если Направление = 0 Тогда
		Если КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] > КоллекцияСтрок[ИндексРезультат + 1][ПолеУпорядочивания] Тогда
			// вниз
			Направление = 1;
		КонецЕсли;
		Если КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] < КоллекцияСтрок[ИндексРезультат - 1][ПолеУпорядочивания] Тогда
			// вверх
			Направление = -1;
		КонецЕсли;
	КонецЕсли;
	
	Если Направление = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Направление = 1 Тогда
		// Сдвигать нужно пока значение в текущей строке больше, чем в следующей.
		Пока ИндексРезультат < КоллекцияСтрок.Количество() - 1 
			И КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] > КоллекцияСтрок[ИндексРезультат + 1][ПолеУпорядочивания] Цикл
			ИндексРезультат = ИндексРезультат + 1;
		КонецЦикла;
	Иначе
		// Сдвигать нужно пока значение в текущей строке меньше, чем в предыдущей.
		Пока ИндексРезультат > 0 
			И КоллекцияСтрок[ИндексИсходный][ПолеУпорядочивания] < КоллекцияСтрок[ИндексРезультат - 1][ПолеУпорядочивания] Цикл
			ИндексРезультат = ИндексРезультат - 1;
		КонецЦикла;
	КонецЕсли;
	
	КоллекцияСтрок.Сдвинуть(ИндексИсходный, ИндексРезультат - ИндексИсходный);
	
КонецПроцедуры

&НаКлиенте
Функция РезультатРедактирования()
	
	Результат = Новый Структура(
		"ФизическоеЛицо, 
		|ГоловнаяОрганизация, 
		|ПериодыОтсутствия");
		
	Результат.ФизическоеЛицо = ФизическоеЛицо;
	Результат.ГоловнаяОрганизация = ГоловнаяОрганизация;
	
	МассивСтрок = Новый Массив;
	Для Каждого Строка Из ПериодыОтсутствия Цикл
		ОписаниеСтроки = УчетПособийСоциальногоСтрахованияРасширенныйКлиентСервер.ОписаниеСтрокиПериодовДнейБолезниУходаЗаДетьми();
		ЗаполнитьЗначенияСвойств(ОписаниеСтроки, Строка);
		МассивСтрок.Добавить(ОписаниеСтроки);
	КонецЦикла;
	Результат.ПериодыОтсутствия = МассивСтрок;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьКоличествоДней(ДанныеСтроки)
	ДанныеСтроки.Дни = Макс((ДанныеСтроки.Окончание - ДанныеСтроки.Начало) / (24 * 3600) + 1, 0);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюДоступностиПериодов()
	
	Если МесяцыКорректировки.Количество() = 0 Тогда
		Элементы.ПериодыОтсутствия.Подсказка = НСтр("ru = 'Редактирование периодов недоступно.'");
		ТолькоПросмотр = Истина;
		Возврат;
	КонецЕсли;
	
	МинимальнаяДата	= Дата(1, 1, 1);
	МаксимальнаяДата = Дата(1, 1, 1);
	
	Для Каждого Месяц Из МесяцыКорректировки Цикл
		Если Не ЗначениеЗаполнено(МинимальнаяДата) Тогда
			МинимальнаяДата = Месяц;
		КонецЕсли;
		МинимальнаяДата		= Мин(МинимальнаяДата, Месяц);
		МаксимальнаяДата	= Макс(МаксимальнаяДата, Месяц);
	КонецЦикла;
	
	Элементы.ПериодыОтсутствия.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Редактирование периодов доступно с %1 по %2.'"), Формат(МинимальнаяДата, "ДЛФ=D"), Формат(КонецМесяца(МаксимальнаяДата), "ДЛФ=D"));
	
КонецПроцедуры

#КонецОбласти
