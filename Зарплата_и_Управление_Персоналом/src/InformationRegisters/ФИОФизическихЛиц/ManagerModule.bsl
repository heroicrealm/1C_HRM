
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

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

Процедура ЗаполнитьФИОСлужебные(ПараметрыОбновления) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ФИОФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	РегистрСведений.ФИОФизическихЛиц КАК ФИОФизическихЛиц
		|ГДЕ
		|	ФИОФизическихЛиц.ФИОСлужебные = """"
		|	И ФИОФизическихЛиц.Фамилия + ФИОФизическихЛиц.Имя + ФИОФизическихЛиц.Отчество <> """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрСведений.ФИОФизическихЛиц", "ФизическоеЛицо", Выборка.ФизическоеЛицо) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ФИОФизическихЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		НаборЗаписей.Прочитать();
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьИнициалы(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ФИОФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	РегистрСведений.ФИОФизическихЛиц КАК ФИОФизическихЛиц
		|ГДЕ
		|	ФИОФизическихЛиц.Инициалы = """"
		|	И ФИОФизическихЛиц.Имя <> """"";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	// АПК:1328-выкл Блокировку выполнит ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных
	Выборка = Запрос.Выполнить().Выбрать();
	// АПК:1328-вкл
	
	Если Выборка.Количество() = 0 Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПродолжитьОбработчик(ПараметрыОбновления);
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, "РегистрСведений.ФИОФизическихЛиц", "ФизическоеЛицо", Выборка.ФизическоеЛицо) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ФИОФизическихЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		НаборЗаписей.Прочитать();
		
		Для каждого Запись Из НаборЗаписей Цикл
			
			Если ПустаяСтрока(Запись.Инициалы) Тогда
				
				Если Не ПустаяСтрока(Запись.Имя) Тогда
					
					Запись.Инициалы = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ИнициалыПоИмениОтчеству(
						Запись.Имя, Запись.Отчество);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		// АПК:1327-выкл Блокировка выполнена ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		// АПК:1327-вкл
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
