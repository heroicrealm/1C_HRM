#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ВыполнятьПроверкуПередЗаписьюНабора")
		Или ДополнительныеСвойства.ВыполнятьПроверкуПередЗаписьюНабора Тогда
		
		Ошибки = Новый Массив;
		
		Записи = Выгрузить(, "ПлатежныйДокумент, Ведомость");
		Записи.Индексы.Добавить("ПлатежныйДокумент");
		
		Для Каждого ПлатежныйДокумент Из ОбщегоНазначения.ВыгрузитьКолонку(ЭтотОбъект, "ПлатежныйДокумент", Истина) Цикл
			ЗаписиПлатежногоДокумента = Записи.НайтиСтроки(Новый Структура("ПлатежныйДокумент", ПлатежныйДокумент));
			Ведомости = ОбщегоНазначения.ВыгрузитьКолонку(ЗаписиПлатежногоДокумента, "Ведомость"); 
			ОбменСБанкамиПоЗарплатнымПроектам.ПроверитьЗаполнениеПлатежногоДокумента(ПлатежныйДокумент, Ведомости, Ошибки);
		КонецЦикла;	
		
		Для каждого Ошибка Из Ошибки Цикл
			ОбщегоНазначения.СообщитьПользователю(Ошибка.ТекстСообщения, Ошибка.Ведомость, , , Отказ);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли