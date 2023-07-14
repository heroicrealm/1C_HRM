#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы") Тогда
		
		Если Не ИспользоватьВедомостиДляВыплатыПрочихДоходов() И НельзяВыключитьИспользованиеВедомостей(ЭтотОбъект) Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя выключить использование ведомостей для регистрации незарплатных доходов, т.к. есть документы, оплата которых регистрируется ведомостями.'");
		КонецЕсли;
		
	Иначе
		ЭтотОбъект[0].ИспользоватьВедомостиДляВыплатыПрочихДоходов = Ложь;
	КонецЕсли;
		
	ЭтотОбъект[0].ИспользоватьВзаиморасчетыПоПрочимДоходам = ИспользоватьВедомостиДляВыплатыПрочихДоходов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИспользоватьВедомостиДляВыплатыПрочихДоходов()
	Возврат ЭтотОбъект[0].ИспользоватьВедомостиДляВыплатыПрочихДоходов
КонецФункции

Функция НельзяВыключитьИспользованиеВедомостей(НаборЗаписей)

	Если НаборЗаписей.ДополнительныеСвойства.Свойство("НеВыполнятьПроверкуВозможностиВыключенияНастроек") Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.НастройкиВзаиморасчетовПоПрочимДоходам.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	
	Если Не МенеджерЗаписи.Выбран() Или Не МенеджерЗаписи.ИспользоватьВедомостиДляВыплатыПрочихДоходов Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Взаиморасчеты.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентамиАкционерами КАК Взаиморасчеты
	|ГДЕ
	|	Взаиморасчеты.Регистратор ССЫЛКА Документ.ВыплатаБывшимСотрудникам
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Взаиморасчеты.НомерСтроки
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентамиАкционерами КАК Взаиморасчеты
	|ГДЕ
	|	Взаиморасчеты.Регистратор ССЫЛКА Документ.РегистрацияПрочихДоходов";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	НельзяВыключатьНастройку = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Дивиденды") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Дивиденды");
		НельзяВыключатьНастройку = Модуль.НельзяВыключитьИспользованиеВедомостей();	
	КонецЕсли;
	
	Возврат НельзяВыключатьНастройку;

КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли