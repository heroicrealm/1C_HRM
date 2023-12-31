#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	УправлениеШтатнымРасписанием.ЗаполнитьНаборыЗначенийДоступа(ЭтотОбъект, Таблица, Ложь);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	УправлениеШтатнымРасписанием.СинхронизироватьРеквизитыПозиций(ЭтотОбъект);
	
	УправлениеШтатнымРасписанием.ПроверитьВозможностьИзменитьШтатноеРасписание(
		Позиции.ВыгрузитьКолонку("ПозицияШтатногоРасписания"),
		МесяцИндексации,
		Ссылка,
		РежимЗаписи,
		Отказ,
		"МесяцСтрокой");
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеПроведения = ПолучитьДанныеДляПроведения();
	
	УправлениеШтатнымРасписанием.СформироватьДвиженияИсторииПозицийШтатногоРасписания(ЭтотОбъект, ДанныеПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьМесяца(Ссылка, МесяцИндексации, "Объект.МесяцИндексации", Отказ, НСтр("ru='Месяц индексации'"), , , Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Необходимо получить данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	
	МенеджерВременныхТаблиц = Неопределено;
	ДополненныеДанныеДокумента = Документы.ИндексацияШтатногоРасписания.ДополненныеДанныеДокумента(ЭтотОбъект, МенеджерВременныхТаблиц);
	
	ДанныеДляПроведения = Новый Структура("ИсторииИспользованияШтатногоРасписания,ИсторияНачисленийПоШтатномуРасписанию,ИсторияПоказателейПоШтатномуРасписанию");
	ДанныеДляПроведения.Вставить("ИсторииИспользованияШтатногоРасписания",	ДополненныеДанныеДокумента["РезультатЗапросаПозиций"].Выбрать());
	ДанныеДляПроведения.Вставить("ИсторияНачисленийПоШтатномуРасписанию",	ДополненныеДанныеДокумента["РезультатЗапросаНачислений"].Выбрать());
	ДанныеДляПроведения.Вставить("ИсторияПоказателейПоШтатномуРасписанию",	ДополненныеДанныеДокумента["РезультатЗапросаПоказателей"].Выбрать());
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		Модуль.ДополнитьДанныеДляПроведенияИндексацииЗаработка(МенеджерВременныхТаблиц, ДанныеДляПроведения);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура ЗаполнитьДокумент(СохранятьИсправления = Ложь) Экспорт
	
	Если СохранятьИсправления Тогда
		ОтредактированныеПоказатели = Показатели.Выгрузить();
		ОтредактированныеПоказатели.Колонки.Добавить("ПозицияШтатногоРасписания");
		
		ОтборПозиции = Новый Структура("ИдентификаторСтрокиПозиции");
		Для каждого ОтредактированныйПоказатель Из ОтредактированныеПоказатели Цикл
			ОтборПозиции.Вставить("ИдентификаторСтрокиПозиции", ОтредактированныйПоказатель.ИдентификаторСтрокиПозиции);  
			СтрокиПозиций = Позиции.НайтиСтроки(ОтборПозиции);
			Если СтрокиПозиций.Количество() <> 0 Тогда
				ОтредактированныйПоказатель.ПозицияШтатногоРасписания = СтрокиПозиций[0].ПозицияШтатногоРасписания;
			КонецЕсли;	
		КонецЦикла;
	Иначе
		ОтредактированныеПоказатели = Неопределено;
	КонецЕсли;
	
	Позиции.Очистить();
	Начисления.Очистить();
	Показатели.Очистить();

	Менеджер = Документы.ИндексацияШтатногоРасписания;
	  
	// Заполняем документ текущими данными попутно индексируя показатели и заполняя идентификаторы строк.
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ТекущиеДанныеПозиций = Менеджер.ТекущиеДанныеПозиций(ЭтотОбъект, МенеджерВременныхТаблиц);
	
	ВыборкаПозиций 		= ТекущиеДанныеПозиций["РезультатЗапросаПозиций"].Выбрать();
	ВыборкаНачислений 	= ТекущиеДанныеПозиций["РезультатЗапросаНачислений"].Выбрать();
	ВыборкаПоказателей 	= ТекущиеДанныеПозиций["РезультатЗапросаПоказателей"].Выбрать();
	
	ОтборПозиции 	= Новый Структура("ПозицияШтатногоРасписания");
	ОтборНачисления = Новый Структура("ИдентификаторСтрокиПозиции,Начисление");
	ОтборПоказателя = Новый Структура("ИдентификаторСтрокиПозиции,Показатель");
	
	ОписаниеОкругленияПоказателей = ИндексацияЗаработка.ОписаниеОкругленияПоказателей(ИндексируемыеПоказатели.Выгрузить(, "Показатель, СпособОкругления"));

	Пока ВыборкаПозиций.Следующий() Цикл
		
		ОтборПозиции.Вставить("ПозицияШтатногоРасписания", ВыборкаПозиций.ПозицияШтатногоРасписания);  
		
		СтрокиПозиций = Позиции.НайтиСтроки(ОтборПозиции);
		
		Если СтрокиПозиций.Количество() = 0 Тогда  
			НовыйИдентификаторПозиции = УправлениеШтатнымРасписанием.МаксимальныйИдентификаторСтроки(Позиции, "ИдентификаторСтрокиПозиции") + 1;
			СтрокаПозиции = Позиции.Добавить();
			СтрокаПозиции.ИдентификаторСтрокиПозиции = НовыйИдентификаторПозиции; 
		Иначе
			СтрокаПозиции = СтрокиПозиций[0];
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаПозиции, ВыборкаПозиций);
		
		ВыборкаНачислений.Сбросить();
		Пока ВыборкаНачислений.НайтиСледующий(ОтборПозиции) Цикл
			ОтборНачисления.Вставить("ИдентификаторСтрокиПозиции", 	СтрокаПозиции.ИдентификаторСтрокиПозиции);  
			ОтборНачисления.Вставить("Начисление", 					ВыборкаНачислений.Начисление);  
			
			СтрокиНачислений = Начисления.НайтиСтроки(ОтборНачисления);
			
			Если СтрокиНачислений.Количество() = 0 Тогда
				СтрокаНачисления = Начисления.Добавить();
				СтрокаНачисления.ИдентификаторСтрокиПозиции 	= СтрокаПозиции.ИдентификаторСтрокиПозиции; 
				СтрокаНачисления.ИдентификаторСтрокиВидаРасчета = УправлениеШтатнымРасписанием.МаксимальныйИдентификаторСтроки(Начисления, "ИдентификаторСтрокиВидаРасчета") + 1; 
			Иначе
				СтрокаНачисления = СтрокиНачислений[0];
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(СтрокаНачисления, ВыборкаНачислений);
			
		КонецЦикла;
		
		ВыборкаПоказателей.Сбросить();
		Пока ВыборкаПоказателей.НайтиСледующий(ОтборПозиции) Цикл
			
			ОписаниеОкругленияПоказателя = ОписаниеОкругленияПоказателей.Получить(ВыборкаПоказателей.Показатель);

			ОтборПоказателя.Вставить("ИдентификаторСтрокиПозиции", 	СтрокаПозиции.ИдентификаторСтрокиПозиции);  
			ОтборПоказателя.Вставить("Показатель", 					ВыборкаПоказателей.Показатель);  
			
			СтрокиПоказателей = Показатели.НайтиСтроки(ОтборПоказателя);
			
			Если СтрокиПоказателей.Количество() = 0 Тогда
				СтрокаПоказателя = Показатели.Добавить();
				СтрокаПоказателя.ИдентификаторСтрокиПозиции = СтрокаПозиции.ИдентификаторСтрокиПозиции; 
			Иначе
				СтрокаПоказателя = СтрокиПоказателей[0];
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(СтрокаПоказателя, ВыборкаПоказателей);
			
			СтрокаПоказателя.Значение 		= ИндексацияЗаработка.ИндексированноеЗначениеПоказателя(СтрокаПоказателя.Значение, 	КоэффициентИндексации, ОписаниеОкругленияПоказателя);
			СтрокаПоказателя.ЗначениеМин 	= ИндексацияЗаработка.ИндексированноеЗначениеПоказателя(СтрокаПоказателя.ЗначениеМин, 	КоэффициентИндексации, ОписаниеОкругленияПоказателя);
			СтрокаПоказателя.ЗначениеМакс 	= ИндексацияЗаработка.ИндексированноеЗначениеПоказателя(СтрокаПоказателя.ЗначениеМакс, КоэффициентИндексации, ОписаниеОкругленияПоказателя);
		КонецЦикла; 
	КонецЦикла;
	
	Если НЕ ОтредактированныеПоказатели = Неопределено Тогда
		Для каждого ОтредактированныйПоказатель Из ОтредактированныеПоказатели Цикл
			ОтборПозиции.Вставить("ПозицияШтатногоРасписания", ОтредактированныйПоказатель.ПозицияШтатногоРасписания);  
			СтрокиПозиций = Позиции.НайтиСтроки(ОтборПозиции);
			Если СтрокиПозиций.Количество() <> 0 Тогда
				ОтборПоказателя.Вставить("ИдентификаторСтрокиПозиции", СтрокиПозиций[0].ИдентификаторСтрокиПозиции);  
				ОтборПоказателя.Вставить("Показатель", ОтредактированныйПоказатель.Показатель);  
				
				СтрокиПоказателей = Показатели.НайтиСтроки(ОтборПоказателя);
				
				Если СтрокиПоказателей.Количество() <> 0 Тогда
					СтрокиПоказателей[0].Значение 		= ОтредактированныйПоказатель.Значение;
					СтрокиПоказателей[0].ЗначениеМин 	= ОтредактированныйПоказатель.ЗначениеМин;
					СтрокиПоказателей[0].ЗначениеМакс 	= ОтредактированныйПоказатель.ЗначениеМакс;
				КонецЕсли;
				
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;	
	
	Менеджер.ЗаполнитьФОТПозицийНачислений(ЭтотОбъект, МенеджерВременныхТаблиц);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли