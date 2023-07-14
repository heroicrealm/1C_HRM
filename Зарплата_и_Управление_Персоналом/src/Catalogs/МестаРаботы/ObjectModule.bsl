#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Начисления", Начисления.Выгрузить());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Начисления.НомерСтроки,
		|	Начисления.Начисление,
		|	Начисления.ИдентификаторСтрокиВидаРасчета
		|ПОМЕСТИТЬ ВТНачисления
		|ИЗ
		|	&Начисления КАК Начисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(Начисления.НомерСтроки) КАК НомерСтроки,
		|	Начисления.Начисление
		|ИЗ
		|	ВТНачисления КАК Начисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНачисления КАК НачисленияДубли
		|		ПО Начисления.Начисление = НачисленияДубли.Начисление
		|			И Начисления.НомерСтроки > НачисленияДубли.НомерСтроки
		|
		|СГРУППИРОВАТЬ ПО
		|	Начисления.Начисление
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В строке %1 повторяется начисление'") + " %2.",
				Выборка.НомерСтроки,
				Выборка.Начисление);
				
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Начисления[" + (Выборка.НомерСтроки - 1) + "].Начисление", "Объект", Отказ);
			
		КонецЦикла;
		
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли