#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПриЗаписи(Отказ)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
	   Возврат;
	КонецЕсли; 	
	
	Если Значение Тогда
		
		Справочники.ВидыВыплатБывшимСотрудникам.СоздатьВидыВыплатБывшимСотрудникамПоНастройкам();
		
	Иначе
		
		Настройки = РегистрыСведений.НастройкиРасчетаЗарплатыРасширенный.СоздатьМенеджерЗаписи();
		Настройки.Прочитать();
		Настройки.ИспользоватьДоплатуДоСохраняемогоДенежногоСодержанияЗаДниБолезни = Ложь;
		Настройки.Записать();
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли