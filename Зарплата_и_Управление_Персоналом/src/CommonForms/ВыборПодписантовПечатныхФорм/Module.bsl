#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Организации) Тогда
		
		Если ТипЗнч(Параметры.Организации) = Тип("СправочникСсылка.Организации") Тогда
			Организации.Добавить(Параметры.Организации);
		Иначе
			Организации.ЗагрузитьЗначения(Параметры.Организации);
		КонецЕсли;
		
	КонецЕсли;
	
	ПользователиДляВыбора = АктивныеПользователи();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Подписанты, "ПользователиДляВыбора", ПользователиДляВыбора, Истина);
	
	Элементы.Подписанты.ВыделенныеСтроки.Очистить();
	Если ТипЗнч(Параметры.ПодписантыПечатныхФорм) = Тип("ФиксированныйМассив") Тогда
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Элементы.Подписанты.ВыделенныеСтроки , Параметры.ПодписантыПечатныхФорм);
		ТолькоПодписантыССертификатами = Ложь;
		
	Иначе
		ТолькоПодписантыССертификатами = Истина;
	КонецЕсли;
	
	ПодписантыССертификатами = Новый ФиксированныйМассив(ПользователиССертификатамиПодписания(ПользователиДляВыбора));
	УстановитьОтборПоПодписантамСЭЦП(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодписантыОпределеныПриИзменении(Элемент)
	
	УстановитьОтборПоПодписантамСЭЦП(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АктивныеПользователи()
	
	ПользователиДляВыбора = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Пользователь
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	НЕ Пользователи.ПометкаУдаления
		|	И НЕ Пользователи.Недействителен
		|	И НЕ Пользователи.Служебный
		|	И Пользователи.Ссылка <> &ТекущийПользователь";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		Если Пользователи.ВходВПрограммуРазрешен(Выборка.Пользователь) Тогда
			ПользователиДляВыбора.Добавить(Выборка.Пользователь);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПользователиДляВыбора;
	
КонецФункции

&НаСервере
Функция ПользователиССертификатамиПодписания(СписокПользователей)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокПользователей", СписокПользователей);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователь КАК Пользователь
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
		|ГДЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователь В(&СписокПользователей)
		|	И НЕ СертификатыКлючейЭлектроннойПодписиИШифрования.ПометкаУдаления
		|	И СертификатыКлючейЭлектроннойПодписиИШифрования.Подписание
		|	И &ОтборПоОрганизации
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователь
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователи КАК СертификатыКлючейЭлектроннойПодписиИШифрования
		|ГДЕ
		|	СертификатыКлючейЭлектроннойПодписиИШифрования.Пользователь В(&СписокПользователей)
		|	И НЕ СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка.ПометкаУдаления
		|	И СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка.Подписание
		|	И &ОтборПоОрганизации";
	
	Если ЗначениеЗаполнено(Организации) Тогда
		
		Запрос.УстановитьПараметр("Организации", Организации);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоОрганизации",
			"(СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка.Организация В (&Организации)
				|			ИЛИ СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))");
		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоОрганизации", "(ИСТИНА)");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Пользователь");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПодписантамСЭЦП(УправляемаяФорма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		УправляемаяФорма.Подписанты, "Ссылка", УправляемаяФорма.ПодписантыССертификатами, ВидСравненияКомпоновкиДанных.ВСписке, ,
		УправляемаяФорма.ТолькоПодписантыССертификатами, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

#КонецОбласти
