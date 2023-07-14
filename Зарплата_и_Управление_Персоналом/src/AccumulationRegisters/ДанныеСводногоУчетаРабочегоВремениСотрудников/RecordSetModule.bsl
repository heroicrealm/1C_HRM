#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетРабочегоВремениРасширенный.КонтрольИзмененияДанныхРегистровПередЗаписью(ЭтотОбъект);
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;	
	
	ОписаниеРегистра = РегистрыНакопления.ДанныеСводногоУчетаРабочегоВремениСотрудников.ОписаниеРегистра();
		
	УчетРабочегоВремениРасширенный.ЗаписатьПараметрыРегистрируемыхДанных(ЭтотОбъект, ОписаниеРегистра);
	
	ДанныеИзменены = Ложь;
	
	УчетРабочегоВремениРасширенный.КонтрольИзмененияДанныхРегистровПриЗаписи(ЭтотОбъект, ДанныеИзменены);
	
	Если ДанныеИзменены Тогда
		УчетРабочегоВремениРасширенный.РегистрРассчитанныхДанныхПриИзмененииИсточниковДанных(ЭтотОбъект);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак сформированности таблицы изменений
//
Функция ТаблицаИзменившихсяДанныхНабораСформирована() Экспорт
	Возврат УчетРабочегоВремениРасширенный.ТаблицаИзменившихсяДанныхНабораСформирована(ЭтотОбъект);
КонецФункции

// Возвращает таблицу изменений регистра
//
Функция ТаблицаИзменившихсяДанныхНабора() Экспорт
	Возврат УчетРабочегоВремениРасширенный.ТаблицаИзменившихсяДанныхНабора(ЭтотОбъект);
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли