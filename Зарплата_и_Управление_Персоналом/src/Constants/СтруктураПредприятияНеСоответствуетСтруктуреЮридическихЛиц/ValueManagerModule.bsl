#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗарплатаКадрыРасширенный.ЗначениеРаботаВХозрасчетнойОрганизации() = Ложь Тогда 
		Значение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизационнаяСтруктураСобытия.ОбновитьСтруктуруПредприятия();
	
	Если Значение = Истина Тогда
		
		ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы = Константы.ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы.Получить();
		Если Не ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы Тогда 
			ОбновлениеИнформационнойБазыЗарплатаКадрыРасширенный.УстановитьИспользованиеЗарплатаКадрыКорпоративнаяПодсистемы();
			ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы = Константы.ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы.Получить();
		КонецЕсли;
		
		Если ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы Тогда 
			ОрганизационнаяСтруктура.СоздатьУправленческуюОрганизацию();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли