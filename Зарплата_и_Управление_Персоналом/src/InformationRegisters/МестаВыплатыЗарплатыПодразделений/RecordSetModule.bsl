#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор.Организация.Использование = Ложь;
	Подразделения = ВыгрузитьКолонку("Подразделение");
	ОрганизацииПодразделений = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Подразделения, "Владелец");
	Для Каждого Запись Из ЭтотОбъект Цикл
		Запись.Организация = ОрганизацииПодразделений[Запись.Подразделение]
	КонецЦикла;	

	ВзаиморасчетыССотрудникамиРасширенный.МестаВыплатыЗарплатыПередЗаписью(ЭтотОбъект, Отказ, Замещение);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли