#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Назначение) Тогда
		Назначение = Перечисления.НазначениеПрочихДоходовФизическихЛиц.ОбщегоНазначения;	
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ВыплатыБывшимВоеннослужащим") Тогда 
		МодульВыплатыБывшимВоеннослужащим = ОбщегоНазначения.ОбщийМодуль("ВыплатыБывшимВоеннослужащим");
		МодульВыплатыБывшимВоеннослужащим.ПередЗаписьюВидаПрочихДоходовФизическихЛиц(ЭтотОбъект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	КодДоходаНДФЛ				= Справочники.ВидыДоходовНДФЛ.ПустаяСсылка();
	КодДоходаСтраховыеВзносы	= Справочники.ВидыДоходовПоСтраховымВзносам.ПустаяСсылка();
	Назначение					= Перечисления.НазначениеПрочихДоходовФизическихЛиц.ОбщегоНазначения;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Обновляем кэш платформы для зачитывания актуальных настроек
	// используется в ОтражениеЗарплатыВУчетеПовтИсп.ТаблицаНачислениеУдержаниеВидОперации.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли