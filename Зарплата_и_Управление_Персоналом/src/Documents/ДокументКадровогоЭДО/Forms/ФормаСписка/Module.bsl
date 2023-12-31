#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КомандыФормыГруппа;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
	ЗапрещенныеРасширения = РаботаСФайламиСлужебный.СписокЗапрещенныхРасширений();
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	ПоказыватьРеквизитыПериодаИПубликации = Ложь;
	Если Параметры.РасчетныеЛисты Тогда
		
		СкрытьПодменюВыбораВидаСписка();
		ПоказыватьРеквизитыПериодаИПубликации = Истина;
		Заголовок = НСтр("ru = 'Документы кадрового ЭДО (расчетные листки)'");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "КатегорияДокумента", Перечисления.КатегорииДокументовКадровогоЭДО.РасчетныйЛисток, ВидСравненияКомпоновкиДанных.Равно, ,
			Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	ИначеЕсли Параметры.ДокументыНаПодпись Тогда
		СкрытьПодменюВыбораВидаСписка();
		УстановитьВидСписка(ЭтотОбъект, Команды.НаПодпись);
	Иначе
		УстановитьВидСписка(ЭтотОбъект, Команды.ВсеДокументы);
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СодержимоеДокументов", КадровыйЭДО.ДоступныеСодержанияДокументовПользователя(Пользователи.ТекущийПользователь()), Истина);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Период",
		"Видимость",
		ПоказыватьРеквизитыПериодаИПубликации);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаПубликации",
		"Видимость",
		ПоказыватьРеквизитыПериодаИПубликации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновленыДанныеДокументовКЭДО" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки, ИспользуютсяСтандартныеНастройки)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Если Строки.Количество() > 0 Тогда
		
		ЭлектронныеДокументы = Новый Массив;
		СтрокиЭлектронныхДокументов = Новый Соответствие;
		Для Каждого СтрокаСписка Из Строки Цикл
			ЭлектронныеДокументы.Добавить(СтрокаСписка.Значение.Данные.ЭлектронныйДокумент);
			СтрокиЭлектронныхДокументов.Вставить(СтрокаСписка.Значение.Данные.ЭлектронныйДокумент, СтрокаСписка);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Исполнитель", Пользователи.ТекущийПользователь());
		Запрос.УстановитьПараметр("ПрисоединенныеФайлы", ЭлектронныеДокументы);
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ТаблицаРегистра.ПрисоединенныйФайл КАК ПрисоединенныйФайл
			|ИЗ
			|	РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
			|ГДЕ
			|	ТаблицаРегистра.ПрисоединенныйФайл В(&ПрисоединенныеФайлы)
			|	И ТаблицаРегистра.Исполнитель = &Исполнитель
			|	И ТаблицаРегистра.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать)";
		
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		
		Пока Выборка.Следующий() Цикл
			СтрокаСписка = СтрокиЭлектронныхДокументов.Получить(Выборка.ПрисоединенныйФайл);
			Если СтрокаСписка <> Неопределено Тогда
				СтрокаСписка.Значение.Данные.ОжидаетПодписания = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Запрос.УстановитьПараметр("ДокументыКЭДО", ОбщегоНазначения.ВыгрузитьКолонку(Строки, "Ключ"));
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПодписиДокументовКЭДО.Объект КАК Объект,
			|	ПодписиДокументовКЭДО.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ПодписиДокументовКЭДО.Отпечаток КАК Отпечаток,
			|	ПодписиДокументовКЭДО.ДатаПодписи КАК ДатаПодписи
			|ПОМЕСТИТЬ ВТПодписи
			|ИЗ
			|	РегистрСведений.ПодписиДокументовКЭДО КАК ПодписиДокументовКЭДО
			|ГДЕ
			|	ПодписиДокументовКЭДО.Объект В(&ДокументыКЭДО)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДокументКадровогоЭДОВнешниеПодписанты.Ссылка КАК Ссылка,
			|	ДокументКадровогоЭДОВнешниеПодписанты.ФизическоеЛицо КАК ФизическоеЛицо
			|ПОМЕСТИТЬ ВТПодписанты
			|ИЗ
			|	Документ.ДокументКадровогоЭДО.ВнешниеПодписанты КАК ДокументКадровогоЭДОВнешниеПодписанты
			|ГДЕ
			|	ДокументКадровогоЭДОВнешниеПодписанты.Ссылка В(&ДокументыКЭДО)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Подписанты.Ссылка КАК Ссылка,
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Подписанты.ФизическоеЛицо) КАК КоличествоПодписантов,
			|	СУММА(ВЫБОР
			|			КОГДА ЕСТЬNULL(Подписи.Отпечаток, """") <> """"
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК КоличествоУНЭПУКЭП,
			|	СУММА(ВЫБОР
			|			КОГДА ЕСТЬNULL(Подписи.Отпечаток, НЕОПРЕДЕЛЕНО) = """"
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК КоличествоБезУНЭПУКЭП,
			|	СУММА(ВЫБОР
			|			КОГДА Подписи.ФизическоеЛицо ЕСТЬ NULL
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК КоличествоНеОзнакомленных
			|ИЗ
			|	ВТПодписанты КАК Подписанты
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПодписи КАК Подписи
			|		ПО Подписанты.Ссылка = Подписи.Объект
			|			И Подписанты.ФизическоеЛицо = Подписи.ФизическоеЛицо
			|
			|СГРУППИРОВАТЬ ПО
			|	Подписанты.Ссылка";
		
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		
		Пока Выборка.Следующий() Цикл
			СтрокаСписка = Строки.Получить(Выборка.Ссылка);
			Если СтрокаСписка <> Неопределено Тогда
				Если Выборка.КоличествоНеОзнакомленных > 0
					И Выборка.КоличествоУНЭПУКЭП = 0
					И Выборка.КоличествоБезУНЭПУКЭП = 0 Тогда
					
					ПодписанСотрудниками = СтрШаблон(
						НСтр("ru = 'Не подписано (%1)'"),
						Выборка.КоличествоНеОзнакомленных);
				ИначеЕсли Выборка.КоличествоУНЭПУКЭП > 0
					И Выборка.КоличествоБезУНЭПУКЭП = 0
					И Выборка.КоличествоНеОзнакомленных = 0 Тогда
					
					ПодписанСотрудниками = СтрШаблон(
						НСтр("ru = 'Подписано ЭП (%1)'"),
						Выборка.КоличествоУНЭПУКЭП);
				ИначеЕсли Выборка.КоличествоБезУНЭПУКЭП > 0
					И Выборка.КоличествоУНЭПУКЭП = 0
					И Выборка.КоличествоНеОзнакомленных = 0 Тогда
					
					ПодписанСотрудниками = СтрШаблон(
						НСтр("ru = 'Требуется собственноручная подпись (%1)'"),
						Выборка.КоличествоБезУНЭПУКЭП);
				ИначеЕсли Выборка.КоличествоУНЭПУКЭП > 0
					И Выборка.КоличествоБезУНЭПУКЭП > 0
					И Выборка.КоличествоНеОзнакомленных = 0 Тогда
					
					ПодписанСотрудниками = СтрШаблон(
						НСтр("ru = 'Подписано ЭП (%1), требуется собственноручная подпись (%2)'"),
						Выборка.КоличествоУНЭПУКЭП,
						Выборка.КоличествоБезУНЭПУКЭП);
				ИначеЕсли Выборка.КоличествоУНЭПУКЭП > 0
					И Выборка.КоличествоНеОзнакомленных > 0
					И Выборка.КоличествоБезУНЭПУКЭП = 0 Тогда
					
					ПодписанСотрудниками = СтрШаблон(
						НСтр("ru = 'Подписано ЭП (%1), не подписано (%2)'"),
						Выборка.КоличествоУНЭПУКЭП,
						Выборка.КоличествоНеОзнакомленных);
				ИначеЕсли Выборка.КоличествоБезУНЭПУКЭП > 0
					И Выборка.КоличествоНеОзнакомленных > 0
					И Выборка.КоличествоУНЭПУКЭП = 0 Тогда
					
					ПодписанСотрудниками = СтрШаблон(
						НСтр("ru = 'Требуется собственноручная подпись (%1), не подписано (%2)'"),
						Выборка.КоличествоБезУНЭПУКЭП,
						Выборка.КоличествоНеОзнакомленных);
				ИначеЕсли Выборка.КоличествоУНЭПУКЭП = 0
					И Выборка.КоличествоБезУНЭПУКЭП = 0
					И Выборка.КоличествоНеОзнакомленных = 0 Тогда
					
					ПодписанСотрудниками = НСтр("ru = 'Подписи не требуются'");
				Иначе
					ПодписанСотрудниками = СтрШаблон(
						НСтр("ru = 'Подписано ЭП (%1), требуется собственноручная подпись (%2), не подписано (%3)'"),
						Выборка.КоличествоУНЭПУКЭП,
						Выборка.КоличествоБезУНЭПУКЭП,
						Выборка.КоличествоНеОзнакомленных);
				КонецЕсли;
				Если Выборка.КоличествоПодписантов = 1 Тогда
					СтрокаСписка.Данные.ПодписанСотрудниками = СтрЗаменить(ПодписанСотрудниками, " (1)", "");
				Иначе
					СтрокаСписка.Данные.ПодписанСотрудниками = ПодписанСотрудниками;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Просмотреть(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(
			ТекущиеДанные.ЭлектронныйДокумент, УникальныйИдентификатор, Ложь);
		
		Если ЗапрещенныеРасширения.НайтиПоЗначению(ДанныеФайла.Расширение) <> Неопределено Тогда
			ДополнительныеПараметры = Новый Структура("ЭлектронныйДокумент", ТекущиеДанные.ЭлектронныйДокумент);
			Оповещение = Новый ОписаниеОповещения("ОткрытьЭлектронныйДокументПослеПодтверждения", ЭтотОбъект);
			ПараметрыФормы = Новый Структура("Ключ", "ПередОткрытиемФайла");
			ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", ПараметрыФормы, , , , , Оповещение);
			Возврат;
		КонецЕсли;
		
		ОткрытьЭлектронныйДокумент(ТекущиеДанные.ЭлектронныйДокумент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеДокументы(Команда)
	
	УстановитьВидСписка(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НаПодпись(Команда)
	
	УстановитьВидСписка(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписанные(Команда)
	
	УстановитьВидСписка(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкрытьПодменюВыбораВидаСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВидСпискаПодменю",
		"Видимость",
		Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидСписка(УправляемаяФорма, Команда)
	
	Элементы = УправляемаяФорма.Элементы;
	Команды = УправляемаяФорма.Команды;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		УправляемаяФорма.Список, "Исполнители", УправляемаяФорма.ТекущийПользователь,
		Команда = Команды.НаПодпись);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		УправляемаяФорма.Список, "Подписанты", УправляемаяФорма.ТекущийПользователь,
		Команда = Команды.Подписанные);
	
	Если Команда = Команды.ВсеДокументы Тогда
		УправляемаяФорма.Заголовок = НСтр("ru = 'Документы кадрового ЭДО'");
		УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, Элементы.ВсеДокументы);
	ИначеЕсли Команда = Команды.НаПодпись Тогда
		УправляемаяФорма.Заголовок = НСтр("ru = 'Документы кадрового ЭДО (на подпись)'");
		УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, Элементы.НаПодпись);
	ИначеЕсли Команда = Команды.Подписанные Тогда
		УправляемаяФорма.Заголовок = НСтр("ru = 'Документы кадрового ЭДО (подписанные)'");
		УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, Элементы.Подписанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлектронныйДокумент(ЭлектронныйДокумент)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(
		ЭлектронныйДокумент, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование		= Истина;
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("Список.ЭлектронныйДокумент");
	ЭлементОтбора.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.ПравоеЗначение	= Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Список.ОснованиеДокумента"));
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЭлектронныйДокумент");
	ОформляемоеПоле.Использование = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПометкуВидаСпискаСписка(УправляемаяФорма, ВыбранныйВидСписка)
	
	Элементы = УправляемаяФорма.Элементы;
	Для Каждого ПодчиненныйЭлемент Из Элементы.ВидСпискаПодменю.ПодчиненныеЭлементы Цикл
		ПодчиненныйЭлемент.Пометка = ПодчиненныйЭлемент = ВыбранныйВидСписка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлектронныйДокументПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат = "Продолжить" Тогда
		ОткрытьЭлектронныйДокумент(ДополнительныеПараметры.ЭлектронныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
