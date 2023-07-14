#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеРегистра() Экспорт
	ОписаниеРегистра = УчетРабочегоВремениРасширенный.ОписаниеРегистраДанныхУчетаВремени();
	
	ОписаниеРегистра.МетаданныеРегистра = Метаданные.РегистрыНакопления.ДанныеСводногоУчетаРабочегоВремениСотрудников;
	ОписаниеРегистра.ИмяПоляСотрудник = "Сотрудник";
	ОписаниеРегистра.ИмяПоляПериод = "Период";
	ОписаниеРегистра.ИмяПоляПериодРегистрации = "ПериодРегистрации";
	ОписаниеРегистра.ИмяПоляВидДанных = Неопределено;
	ОписаниеРегистра.ВидДанных = Перечисления.ВидыДанныхУчетаВремениСотрудников.СводныеДанные;
	ОписаниеРегистра.ИмяПоляПереходящаяЧастьПредыдущейСмены = Неопределено;
	
	Возврат ОписаниеРегистра;
КонецФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьОрганизацию(ПараметрыОбновления = Неопределено) Экспорт
	
	ПоследнийОбработанныйРегистратор = Неопределено;
	Пока Истина Цикл
		Запрос = ЗарплатаКадрыРасширенный.ЗапросПолученияРегистраторовДляОбработкиЗаполненияОрганизации("ДанныеСводногоУчетаРабочегоВремениСотрудников", ПоследнийОбработанныйРегистратор);
		
		Результат = Запрос.Выполнить();

		Если Результат.Пустой() Тогда
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
			Возврат;
		Иначе
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		КонецЕсли;
		
		Регистраторы = Результат.Выгрузить().ВыгрузитьКолонку("Регистратор");
		ОрганизацииДокументов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Регистраторы, "Организация");
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Период КАК Период,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Регистратор КАК Регистратор,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.НомерСтроки КАК НомерСтроки,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Активность КАК Активность,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Сотрудник КАК Сотрудник,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.ПериодРегистрации КАК ПериодРегистрации,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.ВидУчетаВремени КАК ВидУчетаВремени,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Дни КАК Дни,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Часы КАК Часы,
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Организация КАК Организация
			|ИЗ
			|	РегистрНакопления.ДанныеСводногоУчетаРабочегоВремениСотрудников КАК ДанныеСводногоУчетаРабочегоВремениСотрудников
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРегистраторы КАК ВТРегистраторы
			|		ПО ДанныеСводногоУчетаРабочегоВремениСотрудников.Регистратор = ВТРегистраторы.Регистратор
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДанныеСводногоУчетаРабочегоВремениСотрудников.Регистратор";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрНакопления.ДанныеСводногоУчетаРабочегоВремениСотрудников.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
				Продолжить;
			КонецЕсли;
			НаборЗаписей = РегистрыНакопления.ДанныеСводногоУчетаРабочегоВремениСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			Пока Выборка.Следующий() Цикл
				НоваяСтрока = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
				НоваяСтрока.Организация = ОрганизацииДокументов[Выборка.Регистратор];
				Если Не ЗначениеЗаполнено(НоваяСтрока.Организация) Тогда
					НоваяСтрока.Организация = Выборка.ГоловнаяОрганизация;
				КонецЕсли;
			КонецЦикла;
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			ПоследнийОбработанныйРегистратор = Выборка.Регистратор;
		КонецЦикла;
		Если ПараметрыОбновления <> Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли