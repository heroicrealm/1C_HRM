#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// АПК:299-выкл - горизонтальный механизм без непосредственных вызовов
Процедура ОбновитьЗависимыеДанныеПослеЗагрузкиОбменаДанными(ЗависимыеДанные) Экспорт
	
	Если ЗависимыеДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ФизическиеЛица = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ЗависимыеДанные Цикл
		Для Каждого НаборЗаписей Из СтрокаТаблицы.ВедущиеДанные Цикл
			ФизическоеЛицоНабораЗаписей = ОбщегоНазначения.ВыгрузитьКолонку(НаборЗаписей, "ФизическоеЛицо");
			Если Не ЗначениеЗаполнено(ФизическоеЛицоНабораЗаписей) Тогда
				ЗаполнитьВторичныеДанныеЛичныеВычеты();
				ЗаполнитьВторичныеДанныеВычетыНаДетей();
				Возврат;
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ФизическиеЛица, ФизическоеЛицоНабораЗаписей, Истина);
		КонецЦикла;
	КонецЦикла;

	ЗаполнитьВторичныеДанныеЛичныеВычеты(ФизическиеЛица);
	ЗаполнитьВторичныеДанныеВычетыНаДетей(ФизическиеЛица);
		
КонецПроцедуры
// АПК:299-вкл 

Процедура ЗаполнитьВторичныеДанныеВычетыНаДетей(ФизическиеЛица = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписываемыйНабор = РегистрыСведений.СтандартныеВычетыПоНДФЛВторичный.СоздатьНаборЗаписей();
	ЗаписываемыйНабор.Отбор.ЛичныйВычет.Установить(Ложь);
	ЗаписываемыйНабор.ОбменДанными.Загрузка = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаписиРегистра.МесяцРегистрации КАК МесяцРегистрации,
	|	ЗаписиРегистра.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗаписиРегистра.КодВычета КАК КодВычета,
	|	ЗаписиРегистра.ДатаДействия КАК ДатаДействия,
	|	ЗаписиРегистра.КоличествоДетей КАК Количество,
	|	ЗаписиРегистра.ДействуетДо КАК ДействуетДо,
	|	ЗаписиРегистра.КоличествоДетейПоОкончании КАК КоличествоПоОкончании,
	|	ЛОЖЬ КАК ВычетЛичный,
	|	ЗаписиРегистра.Основание КАК Основание
	|ИЗ
	|	РегистрСведений.СтандартныеВычетыНаДетейНДФЛ КАК ЗаписиРегистра
	|ГДЕ
	|	&ФизическиеЛица
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизическоеЛицо,
	|	МесяцРегистрации,
	|	КодВычета,
	|	ДатаДействия";
	
	Если ФизическиеЛица = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФизическиеЛица", "(ИСТИНА)");
		// Очищаем набор перед заполнением
		ЗаписываемыйНабор.Записать();
	ИначеЕсли ФизическиеЛица.Количество() = 1 Тогда
		Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическиеЛица[0]);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФизическиеЛица", "ЗаписиРегистра.ФизическоеЛицо = &ФизическоеЛицо");
	Иначе
		Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФизическиеЛица", "ЗаписиРегистра.ФизическоеЛицо В(&ФизическиеЛица)");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 И ФизическиеЛица <> Неопределено Тогда
		Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл
			ЗаписываемыйНабор.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо);
			ЗаписываемыйНабор.Записать();
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	НаборВычетовНаДетей = РегистрыСведений.СтандартныеВычетыПоНДФЛВторичный.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	
	Пока Выборка.СледующийПоЗначениюПоля("ФизическоеЛицо") Цикл
		
		ЗаписываемыйНабор.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		
		ОкончанияПериодовРегистрации = Новый Соответствие;
		ПредыдущаяЗаписьЛичныйВычет = Неопределено;
		ПредыдущийПериодРегистрации = Неопределено;
		
		Пока Выборка.СледующийПоЗначениюПоля("МесяцРегистрации") Цикл
			Если ПредыдущийПериодРегистрации <> Неопределено Тогда
				ОкончанияПериодовРегистрации.Вставить(ПредыдущийПериодРегистрации, Выборка.МесяцРегистрации - 1);
			КонецЕсли;
			
			НаборВычетовНаДетей.Очистить();
			УсловныеЗаписи = Новый Массив;
			
			Пока Выборка.СледующийПоЗначениюПоля("КодВычета") Цикл
				УсловныеЗаписи.Очистить();
				Пока Выборка.Следующий() Цикл
					// Удалим условные записи, в случае если их дата начала, больше чем дата текущей записи.
					ИндексПоследнейУсловнойЗаписи = УсловныеЗаписи.Количество() - 1;
					Для Сч = 0 По ИндексПоследнейУсловнойЗаписи Цикл
						УсловнаяЗапись = УсловныеЗаписи[ИндексПоследнейУсловнойЗаписи - Сч];
						Если УсловнаяЗапись.ДатаНачала >= Выборка.ДатаДействия Тогда
							НаборВычетовНаДетей.Удалить(УсловнаяЗапись);
							УсловныеЗаписи.Удалить(ИндексПоследнейУсловнойЗаписи - Сч);
						КонецЕсли;
					КонецЦикла;
					
					Запись = НаборВычетовНаДетей.Добавить();
					Запись.ФизическоеЛицо = Выборка.ФизическоеЛицо;
					Запись.ПериодРегистрацииНачало = Выборка.МесяцРегистрации;
					Запись.ДатаНачала = Выборка.ДатаДействия;
					Запись.КодВычета = Выборка.КодВычета;
					Запись.Количество = Выборка.Количество;
					Запись.Основание = Выборка.Основание;
					
					// Добавим условные записи
					Если ЗначениеЗаполнено(Выборка.ДействуетДо) Тогда
						Запись = НаборВычетовНаДетей.Добавить();
						Запись.ФизическоеЛицо = Выборка.ФизическоеЛицо;
						Запись.ПериодРегистрацииНачало = Выборка.МесяцРегистрации;
						Запись.ДатаНачала = КонецМесяца(Выборка.ДействуетДо) + 1;
						Запись.КодВычета = Выборка.КодВычета;
						Запись.Количество = Выборка.КоличествоПоОкончании;
						Запись.Основание = Выборка.Основание;
						
						УсловныеЗаписи.Добавить(Запись);
					КонецЕсли;
				КонецЦикла;
				
				ИндексПоследнийЗаписи = НаборВычетовНаДетей.Количество() - 1;
				// заполним даты окончания в наборе 
				СледующаяЗапись = Неопределено;
				Для Сч = 0 По ИндексПоследнийЗаписи Цикл
					СтрокаНабора = НаборВычетовНаДетей[ИндексПоследнийЗаписи - Сч];
					Если СтрокаНабора.КодВычета <> Выборка.КодВычета Тогда
						Прервать;
					ИначеЕсли СледующаяЗапись <> Неопределено Тогда
						СтрокаНабора.ДатаОкончания = СледующаяЗапись.ДатаНачала - 1;
					Иначе
						СтрокаНабора.ДатаОкончания = ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата()
					КонецЕсли;
					СледующаяЗапись = СтрокаНабора;
				КонецЦикла;
			КонецЦикла;
			
			НаборВычетовНаДетей.ЗаполнитьЗначения(Выборка.МесяцРегистрации, "ПериодРегистрацииНачало");
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НаборВычетовНаДетей, ЗаписываемыйНабор);
			
			ПредыдущийПериодРегистрации = Выборка.МесяцРегистрации;
		КонецЦикла;
		
		Если ПредыдущаяЗаписьЛичныйВычет <> Неопределено Тогда
			ПредыдущаяЗаписьЛичныйВычет.ДатаОкончания = ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата();
		КонецЕсли;
		
		Если ПредыдущийПериодРегистрации <> Неопределено Тогда
			ОкончанияПериодовРегистрации.Вставить(ПредыдущийПериодРегистрации, ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата());
		КонецЕсли;
		
		Для Каждого ЗаписьНабора Из ЗаписываемыйНабор Цикл
			ЗаписьНабора.ПериодРегистрацииОкончание = ОкончанияПериодовРегистрации[ЗаписьНабора.ПериодРегистрацииНачало];
		КонецЦикла;
		
		ЗаписываемыйНабор.Записать();
		ЗаписываемыйНабор.Очистить();
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВторичныеДанныеЛичныеВычеты(ФизическиеЛица = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписываемыйНабор = РегистрыСведений.СтандартныеВычетыПоНДФЛВторичный.СоздатьНаборЗаписей();
	ЗаписываемыйНабор.Отбор.ЛичныйВычет.Установить(Истина);
	ЗаписываемыйНабор.ОбменДанными.Загрузка = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаписиРегистра.Период КАК МесяцРегистрации,
	|	ЗаписиРегистра.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗаписиРегистра.КодВычетаЛичный КАК КодВычета,
	|	ЗаписиРегистра.Период КАК ДатаДействия,
	|	1 КАК Количество,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
	|	0 КАК КоличествоПоОкончании,
	|	ИСТИНА КАК ВычетЛичный,
	|	ЗаписиРегистра.Основание КАК Основание
	|ИЗ
	|	РегистрСведений.СтандартныеВычетыФизическихЛицНДФЛ КАК ЗаписиРегистра
	|ГДЕ
	|	&ФизическиеЛица
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизическоеЛицо,
	|	МесяцРегистрации,
	|	КодВычета,
	|	ДатаДействия";
	
	Если ФизическиеЛица = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФизическиеЛица", "(ИСТИНА)");
		// Очищаем набор перед заполнением
		ЗаписываемыйНабор.Записать();
	ИначеЕсли ФизическиеЛица.Количество() = 1 Тогда
		Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическиеЛица[0]);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФизическиеЛица", "ЗаписиРегистра.ФизическоеЛицо = &ФизическоеЛицо");
	Иначе
		Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ФизическиеЛица", "ЗаписиРегистра.ФизическоеЛицо В(&ФизическиеЛица)");
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 И ФизическиеЛица <> Неопределено Тогда
		Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл
			ЗаписываемыйНабор.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо);
			ЗаписываемыйНабор.Записать();
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Пока Выборка.СледующийПоЗначениюПоля("ФизическоеЛицо") Цикл
		
		ЗаписываемыйНабор.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		
		ОкончанияПериодовРегистрации = Новый Соответствие;
		ПредыдущаяЗаписьЛичныйВычет = Неопределено;
		ПредыдущийПериодРегистрации = Неопределено;
		
		Пока Выборка.СледующийПоЗначениюПоля("МесяцРегистрации") Цикл
			Пока Выборка.Следующий() Цикл
				Если ПредыдущийПериодРегистрации <> Неопределено Тогда
					ОкончанияПериодовРегистрации.Вставить(ПредыдущийПериодРегистрации, Выборка.МесяцРегистрации - 1);
				КонецЕсли;
				
				Если ПредыдущаяЗаписьЛичныйВычет <> Неопределено Тогда
					ПредыдущаяЗаписьЛичныйВычет.ДатаОкончания = Выборка.ДатаДействия;
				КонецЕсли;
				
				Запись = ЗаписываемыйНабор.Добавить();
				Запись.ФизическоеЛицо = Выборка.ФизическоеЛицо;
				Запись.ПериодРегистрацииНачало = Выборка.МесяцРегистрации;
				Запись.ДатаНачала = Выборка.ДатаДействия;
				Запись.КодВычета = Выборка.КодВычета;
				Запись.Количество = 1;
				Запись.ЛичныйВычет = Истина;
				Запись.Основание = Выборка.Основание;
				
				ПредыдущаяЗаписьЛичныйВычет = Запись;
			КонецЦикла;
			
			ПредыдущийПериодРегистрации = Выборка.МесяцРегистрации;
		КонецЦикла;
		
		Если ПредыдущаяЗаписьЛичныйВычет <> Неопределено Тогда
			ПредыдущаяЗаписьЛичныйВычет.ДатаОкончания = ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата();
		КонецЕсли;
		
		Если ПредыдущийПериодРегистрации <> Неопределено Тогда
			ОкончанияПериодовРегистрации.Вставить(ПредыдущийПериодРегистрации, ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата());
		КонецЕсли;
		
		Для Каждого ЗаписьНабора Из ЗаписываемыйНабор Цикл
			ЗаписьНабора.ПериодРегистрацииОкончание = ОкончанияПериодовРегистрации[ЗаписьНабора.ПериодРегистрацииНачало];
		КонецЦикла;
		
		ЗаписываемыйНабор.Записать();
		ЗаписываемыйНабор.Очистить();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли