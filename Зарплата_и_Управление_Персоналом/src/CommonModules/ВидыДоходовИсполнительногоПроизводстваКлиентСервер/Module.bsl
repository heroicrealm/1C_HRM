////////////////////////////////////////////////////////////////////////////////
// Ведомости на выплату зарплаты.
// Клиент-серверные процедуры и функции.
////////////////////////////////////////////////////////////////////////////////

// Код, доступный и на клиенте, и на сервере, не обязательно должен использоваться в обоих режимах
// АПК:558-выкл 

#Область СлужебныйПрограммныйИнтерфейс

// Для методов служебного API использование не контролируем          
// АПК:581-выкл 
// АПК:580-выкл 
// АПК:299-выкл

Функция ВидДоходаОбязателенДляБанков(Дата) Экспорт
	Возврат НачалоДня(Дата) >= ДатаНачалаПередачиВидаДоходаБанку();
КонецФункции

Функция ДатаНачалаПередачиВидаДоходаБанку() Экспорт 
	Возврат '20200601';
КонецФункции

Функция КодВидаДохода(ВидДохода) Экспорт
	Если ВидДохода = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ДоходыБезОграниченияВзысканий") Тогда
		Возврат ""
	ИначеЕсли ВидДохода = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения") Тогда	
		Возврат "1"
	ИначеЕсли ВидДохода = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииНеоблагаемые") Тогда	
		Возврат "2"
	ИначеЕсли ВидДохода = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииОблагаемые") Тогда	
		Возврат "3"
	Иначе
		Возврат Неопределено
	КонецЕсли	
КонецФункции

Процедура НастроитьПолеВидДоходаДляВыплатыЗарплаты(Форма, ИмяЭлемента = "ВидДоходаИсполнительногоПроизводства") Экспорт
	
	НастроитьПодсказкуПоляВидДохода(Форма, ИмяЭлемента);
	НастроитьСписокВыбораПоляВидДохода(Форма, ИмяЭлемента, ЗначенияВыбораВидаДоходаДляВыплатыЗарплаты());
		
КонецПроцедуры

Процедура НастроитьПолеВидДоходаДляВыплатыПрочихДоходов(Форма, ИмяЭлемента = "ВидДоходаИсполнительногоПроизводства") Экспорт
	
	НастроитьПодсказкуПоляВидДохода(Форма, ИмяЭлемента);
	НастроитьСписокВыбораПоляВидДохода(Форма, ИмяЭлемента, ЗначенияВыбораВидаДоходаДляВыплатыПрочихДоходов());
		
КонецПроцедуры

Процедура НастроитьКолонкуВидДоходаДляВыплатыЗарплаты(Форма, ИмяТаблицы, ИмяКолонки, ПутьКДаннымКолонки) Экспорт
	
	НастроитьУсловноеОформлениеКолонкиВидДохода(Форма, ИмяТаблицы, ИмяКолонки, ПутьКДаннымКолонки);
	НастроитьСписокВыбораПоляВидДохода(Форма, ИмяКолонки, ЗначенияВыбораВидаДоходаДляВыплатыЗарплаты());
	
КонецПроцедуры

Процедура НастроитьКолонкуВидДоходаДляВыплатыПрочихДоходов(Форма, ИмяТаблицы, ИмяКолонки, ПутьКДаннымКолонки) Экспорт
	
	НастроитьУсловноеОформлениеКолонкиВидДохода(Форма, ИмяТаблицы, ИмяКолонки, ПутьКДаннымКолонки);
	НастроитьСписокВыбораПоляВидДохода(Форма, ИмяКолонки, ЗначенияВыбораВидаДоходаДляВыплатыПрочихДоходов());
	
КонецПроцедуры

Процедура НастроитьПодсказкуПоляВидДохода(Форма, ИмяЭлемента) Экспорт
	
	// Подсказка
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма, 
		ИмяЭлемента, 
		РасширеннаяПодсказкаПоляВидДохода());
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, 
		ИмяЭлемента, 
		"ОтображениеПодсказки", 
		ОтображениеПодсказки.Кнопка);
		
КонецПроцедуры

// АПК:299-вкл
// АПК:580-вкл
// АПК:581-вкл

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьУсловноеОформлениеКолонкиВидДохода(Форма, ИмяТаблицы, ИмяКолонки, ПутьКДаннымКолонки)
	
	Для Каждого Значение Из ЗначенияВыбораВидаДоходаДляВыплатыЗарплаты() Цикл
		
		ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
		ЭлементОформления.Использование	= Истина;
		
		ОформляемоеПоле =  ЭлементОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонки); 
		ОформляемоеПоле.Использование = Истина;
	
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымКолонки);
		ЭлементОтбора.ПравоеЗначение = Значение;
		
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ПредставлениеДляСпискаВыбораПоляВидДохода(Значение));
		
	КонецЦикла
	
КонецПроцедуры

Процедура НастроитьСписокВыбораПоляВидДохода(Форма, ИмяЭлемента, ЗначенияВыбора)
	
	ПолеВидДохода = Форма.Элементы.Найти(ИмяЭлемента);
	Если ПолеВидДохода = Неопределено Тогда
		Возврат
	КонецЕсли;	

	ПолеВидДохода.РедактированиеТекста = Ложь;
	ПолеВидДохода.РежимВыбораИзСписка  = Истина;
	ПолеВидДохода.СписокВыбора.Очистить();
	Для Каждого Значение Из ЗначенияВыбора Цикл
		ПолеВидДохода.СписокВыбора.Добавить(Значение, ПредставлениеДляСпискаВыбораПоляВидДохода(Значение));
	КонецЦикла	
	
КонецПроцедуры

Функция РасширеннаяПодсказкаПоляВидДохода()
	
	Возврат
	СтрШаблон(
		НСтр("ru = 'Согласно Указанию Банка России от 14.10.2019 N 5286-У при перечислении доходов физическому лицу
		           |следует указывать код вида дохода для целей исполнительного производства (Федеральный закон от 02.10.2007 N 229-ФЗ):
		           |
		           |%1
		           |Заработная плата или иные доходы, в отношении которых ст. 99 установлены ограничения размеров удержания. 
		           |
		           |%2
		           |Доходы, на которые в соответствии с ч.1 ст. 101 не может быть обращено взыскание, за исключением доходов, 
		           |к которым в соответствии с ч. 2 ст. 101 ограничения по обращению взыскания не применяются.
		           |
		           |%3
		           |Доходы, к которым в соответствии с ч. 2 ст. 101 ограничения по обращению взыскания не применяются.
		           |
		           |%4
		           |Другие доходы, на которые может быть обращено взыскание без ограничений.
		           |Код вида дохода не указывается'"),
		ПредставлениеДляСпискаВыбораПоляВидДохода(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения")),
		ПредставлениеДляСпискаВыбораПоляВидДохода(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииНеоблагаемые")),
		ПредставлениеДляСпискаВыбораПоляВидДохода(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииОблагаемые")),
		ПредставлениеДляСпискаВыбораПоляВидДохода(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ДоходыБезОграниченияВзысканий")));
	
КонецФункции

Функция ЗначенияВыбораВидаДоходаДляВыплатыЗарплаты()
	ЗначенияВыбора = Новый Массив;
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения"));
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииНеоблагаемые"));
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииОблагаемые"));
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ДоходыБезОграниченияВзысканий"));
	Возврат ЗначенияВыбора;	
КонецФункции

Функция ЗначенияВыбораВидаДоходаДляВыплатыПрочихДоходов()
	ЗначенияВыбора = Новый Массив;
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ДоходыБезОграниченияВзысканий"));
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения"));
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииНеоблагаемые"));
	ЗначенияВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииОблагаемые"));
	Возврат ЗначенияВыбора;	
КонецФункции

Функция ПредставлениеДляСпискаВыбораПоляВидДохода(Значение)
	Если Значение = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ДоходыБезОграниченияВзысканий") Тогда
		Возврат СтрСоединить(Новый Массив(5), " ") + НСтр("ru = 'Доходы без ограничения взысканий'")
	ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения") Тогда	
		Возврат НСтр("ru = '1 - Заработная плата и иные доходы с ограничением взыскания'")
	ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииНеоблагаемые") Тогда	
		Возврат НСтр("ru = '2 - Доходы, на которые не может быть обращено взыскание (без оговорок)'")
	ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.ВидыДоходовИсполнительногоПроизводства.КомпенсацииОблагаемые") Тогда	
		Возврат НСтр("ru = '3 - Доходы, на которые не может быть обращено взыскание (с оговорками)'")
	Иначе
		Возврат ""
	КонецЕсли	
КонецФункции	

#КонецОбласти

// АПК:558-вкл