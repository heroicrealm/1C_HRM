#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ, Замещение)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Регистратор = Отбор.Регистратор.Значение;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Запись.ДокументОснование = Регистратор;
	КонецЦикла;
	
	РегистрыСведений.ПериодыДействияДоговоровГражданскоПравовогоХарактера.ОбновляемыеСотрудникиПередЗаписью(ЭтотОбъект);
	
	// Обновление доступа к сотрудникам по организациям
	РегистрыСведений.ПериодыДействияДоговоровГражданскоПравовогоХарактера.ОрганизацииСотрудниковПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновляемыеСотрудники") Тогда
		КадровыйУчет.ОбновитьДанныеДляПодбораДоговорниковГПХ(ДополнительныеСвойства.ОбновляемыеСотрудники);
		КадровыйУчет.ОбновитьОсновныхСотрудниковФизическихЛицСотрудниковПоДоговорамГПХ(ДополнительныеСвойства.ОбновляемыеСотрудники);
	КонецЕсли;
	
	// Обновление доступа к сотрудникам по организациям
	ТаблицаАнализаИзменений = РегистрыСведений.ПериодыДействияДоговоровГражданскоПравовогоХарактера.ТаблицаАнализаИзменений(ЭтотОбъект);
	Если ТаблицаАнализаИзменений.Количество() > 0 Тогда
		КадровыйУчет.ОбработатьИзменениеОрганизацийВНабореПоТаблицеИзменений(ТаблицаАнализаИзменений);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли