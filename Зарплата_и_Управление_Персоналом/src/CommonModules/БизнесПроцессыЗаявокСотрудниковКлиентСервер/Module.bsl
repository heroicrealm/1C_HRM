#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановитьСвойстваЭлементовФормы(Форма) Экспорт
	
	Если Форма.ТолькоПросмотр Тогда
		Форма.Элементы.ФормаОстановить.Видимость               = Ложь;
		Форма.Элементы.ФормаЗаписатьИЗакрыть.Видимость         = Ложь;
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Видимость = Ложь;
		Форма.Элементы.ФормаЗаписать.Видимость                 = Ложь;
		Форма.Элементы.ФормаПродолжить.Видимость               = Ложь;
	Иначе
		ОбъектСтартован = ОбъектСтартован(Форма);
		
		Форма.Элементы.СрокИсполненияВремя.Видимость             = Форма.ИспользоватьДатуИВремяВСрокахЗадач;
		Форма.Элементы.Дата.Формат                               = ?(Форма.ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
		Форма.Элементы.Предмет.Гиперссылка                       = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
		Форма.Элементы.ФормаСтартИЗакрыть.Видимость              = Не ОбъектСтартован;
		Форма.Элементы.ФормаСтартИЗакрыть.КнопкаПоУмолчанию      = Не ОбъектСтартован;
		Форма.Элементы.ФормаСтарт.Видимость                      = Не ОбъектСтартован;
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Видимость   = Не ОбъектСтартован;
		Форма.Элементы.ФормаЗаписатьИЗакрыть.Видимость           = ?(Форма.Объект.Завершен, Ложь, ОбъектСтартован);
		Форма.Элементы.ФормаЗаписать.Видимость                   = НЕ Форма.Объект.Завершен;
		Форма.Элементы.ФормаЗаписатьИЗакрыть.КнопкаПоУмолчанию   = ОбъектСтартован;
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Доступность = Не Форма.Объект.Стартован;
		
	КонецЕсли;
	
	Форма.Элементы.ГруппаСостояние.Видимость = Форма.Объект.Завершен Или ОбъектСтартован(Форма);
	
КонецПроцедуры

// Принимает размер в байтах.
// Возвращает строку, например: 7.2 Кбайт, 35 Кбайт, 5.5 Мбайт, 12 Мбайт
Функция РазмерФайлаСтрокой(Размер) Экспорт
	
	Если Размер = 0 Тогда
		Возврат "-";
	ИначеЕсли Размер < 1024 * 10 Тогда // < 10 Кб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Кб'"),
			Формат(Макс(1, Окр(Размер / 1024, 1, 1)), "ЧГ=0"));
	ИначеЕсли Размер < 1024 * 1024 Тогда // < 1 Мб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Кб'"),
			Формат(Цел(Размер / 1024), "ЧГ=0"));
	ИначеЕсли Размер < 1024 * 1024 * 10 Тогда // < 10 Мб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Мб'"),
			Формат(Окр(Размер / 1024 / 1024, 1, 1), "ЧГ=0"));
	Иначе // >= 10 Мб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Мб'"),
			Формат(Цел(Размер / 1024 / 1024), "ЧГ=0"));
	КонецЕсли;
	
КонецФункции

Функция СообщениеОСтатусеЗадания(Форма) Экспорт
	
	ТекстСостояния = "";
	
	Если Форма.Объект.Завершен Тогда
		ДатаЗавершенияСтрокой = ?(Форма.ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(Форма.Объект.ДатаЗавершения, "ДЛФ=DT"), Формат(Форма.Объект.ДатаЗавершения, "ДЛФ=D"));
		СтрокаТекста = ?(Форма.Объект.Выполнено, 
			НСтр("ru = 'Задание выполнено %1.'"), 
			НСтр("ru = 'Задание отменено %1.'"));
		ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаТекста, ДатаЗавершенияСтрокой);
		
		Для каждого Элемент Из Форма.Элементы Цикл
			Если ТипЗнч(Элемент) <> Тип("ПолеФормы") И ТипЗнч(Элемент) <> Тип("ГруппаФормы") Тогда
				Продолжить;
			КонецЕсли;
			Элемент.ТолькоПросмотр = Истина;
		КонецЦикла;
		
	ИначеЕсли Форма.Объект.Стартован Тогда
		ТекстСостояния = ?(Форма.ИзменятьЗаданияЗаднимЧислом, 
			НСтр("ru = 'Изменения формулировки, важности, автора, а также перенос сроков исполнения и проверки задания вступят в силу немедленно для ранее выданной задачи.'"),
			НСтр("ru = 'Изменения формулировки, важности, автора, а также перенос сроков исполнения и проверки задания не будут отражены в ранее выданной задаче.'"));
	ИначеЕсли Форма.Отложен Тогда
		ДатаОтложенногоСтартаСтрокой = ?(Форма.ИспользоватьДатуИВремяВСрокахЗадач, 
			Формат(Форма.ДатаОтложенногоСтарта, "ДЛФ=DT"), Формат(Форма.ДатаОтложенногоСтарта, "ДЛФ=D"));
		ТекстСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Задание будет запущено <a href=""ОткрытьНастройкуОтложенногоСтарта"">%1</a>'"),
				ДатаОтложенногоСтартаСтрокой);
	КонецЕсли;
	
	Возврат ТекстСостояния;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбъектСтартован(Форма)
	Возврат Форма.Объект.Стартован ИЛИ Форма.Отложен;
КонецФункции

Функция ПолучитьЭлементы(Дерево, ДеревоФормы = Ложь) Экспорт
	
	Элементы = Новый Массив;
	Если ДеревоФормы Тогда
		Для каждого Элемент Из Дерево.ПолучитьЭлементы() Цикл
			Элементы.Добавить(Элемент);
			Для каждого ДочернийЭлемент Из ПолучитьЭлементы(Элемент, ДеревоФормы) Цикл
				Элементы.Добавить(ДочернийЭлемент);
			КонецЦикла;
		КонецЦикла;
	Иначе
		Для каждого Элемент Из Дерево.Строки Цикл
			Элементы.Добавить(Элемент);
			Для каждого ДочернийЭлемент Из ПолучитьЭлементы(Элемент) Цикл
				Элементы.Добавить(ДочернийЭлемент);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Элементы;
	
КонецФункции

#КонецОбласти


