#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СправкаОСреднемЗаработке2019");
	НастройкиВарианта.Описание = НСтр("ru = 'Справка о среднем заработке за последние три месяца по последнему месту работы (службы) (2019)'");
	НастройкиВарианта.Включен = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьКомандуПечати(КомандыПечати, ИдентификаторыПФ = Неопределено) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ПечатнаяФормаСправкаОСреднемЗаработке) Тогда
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаСправкаОСреднемЗаработке";
		КомандаПечати.Идентификатор = ИдентификаторПечатнойФормыПФ_MXL_СправкаОСреднемЗаработке2019();
		КомандаПечати.Представление = НСтр("ru = 'Справка для пособия по безработице'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ДополнительныеПараметры.Вставить("РеквизитыДетализации", "РаботаСотрудник");
		
		Если ИдентификаторыПФ <> Неопределено Тогда
			ЗарплатаКадры.ДобавитьИдентификаторКомандыДляПечатиВПакетномРежиме(ИдентификаторыПФ, КомандаПечати);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИдентификаторПечатнойФормыПФ_MXL_СправкаОСреднемЗаработке2019()
	Возврат "ПФ_MXL_СправкаОСреднемЗаработке2019";
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, СписокСотрудников = Неопределено) Экспорт
	
	РабочаяДатаПользователя = ОбщегоНазначения.РабочаяДатаПользователя();
	Если ЗначениеЗаполнено(РабочаяДатаПользователя) И РабочаяДатаПользователя < '20190111' Тогда
		
		Обработки.ПечатьКадровыхПриказов.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		Возврат;
		
	КонецЕсли;
	
	Если СписокСотрудников <> Неопределено Тогда
		
		СписокОтборов = Новый Массив;
		
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
			СписокОтборов, "Работа.Сотрудник", ВидСравненияКомпоновкиДанных.ВСписке, СписокСотрудников);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Отбор", СписокОтборов);
		
	Иначе
		ДополнительныеПараметры = Неопределено;
	КонецЕсли;
	
	ЗарплатаКадрыОтчеты.ВывестиВКоллекциюПечатнуюФорму("Отчет.ПечатнаяФормаСправкаОСреднемЗаработке",
		МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, ВнешниеНаборыДанных(), ДополнительныеПараметры);
	
КонецПроцедуры

Процедура Сформировать(ДокументРезультат, РезультатКомпоновки, ОбъектыПечати = Неопределено, ПараметрыПечати = Неопределено) Экспорт
	
	Если РезультатКомпоновки.ОтчетПустой Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыДатаСправки = Новый Структура("ПараметрыДанныхДатаСправки", ОбщегоНазначения.ТекущаяДатаПользователя());
	
	ОбъектОтчета = Отчеты.ПечатнаяФормаСправкаОСреднемЗаработке.Создать();
	КомпоновщикНастроекКД = Новый КомпоновщикНастроекКомпоновкиДанных;
	ЗарплатаКадрыОтчеты.ЗагрузитьНастройкиВКомпоновщикКД(КомпоновщикНастроекКД, ОбъектОтчета, "СправкаОСреднемЗаработке2019");
	
	ПараметрДатаСправки = ЗарплатаКадрыОтчеты.НайтиПараметр(КомпоновщикНастроекКД, "ДатаСправки");
	Если ПараметрДатаСправки <> Неопределено Тогда
		
		Если ПараметрДатаСправки.Использование
			И ТипЗнч(ПараметрДатаСправки.Значение) = Тип("Дата") Тогда
			
			ПараметрыДатаСправки.ПараметрыДанныхДатаСправки = ПараметрДатаСправки.Значение;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыДатаСправки.ПараметрыДанныхДатаСправки < '20210925' Тогда
		ТекстПояснения =
			НСтр("ru = 'Расчет среднего заработка производится в соответствии с Порядком исчисления среднего заработка для определения размера пособия по безработице и стипендии, выплачиваемой гражданам в период профессиональной подготовки, переподготовки и повышения квалификации по направлению органов службы занятости. (Постановление Министерства труда и социального развития Российской Федерации от 12 августа 2003 года № 62).'");
	Иначе
		ТекстПояснения =
			НСтр("ru = 'Расчет среднего заработка производится в соответствии с Порядком исчисления среднего заработка для определения размера пособия по безработице и стипендии, выплачиваемой гражданам в период профессиональной подготовки, переподготовки и повышения квалификации по направлению органов службы занятости. (Постановление Правительства РФ от 14.09.2021 N 1552 ""Об утверждении Правил исчисления среднего заработка по последнему месту работы (службы)"").'");
	КонецЕсли;
	ПараметрыДатаСправки.Вставить("ТекстПояснения", ТекстПояснения);
	
	ДокументРезультат.КлючПараметровПечати = "ПараметрыПечати_СправкаОСреднемЗаработке2019";
	ДокументРезультат.ОриентацияСтраницы= ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	КадровыеДанные = Новый ТаблицаЗначений;
	КадровыеДанные.Колонки.Добавить("ГоловнаяОрганизация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	КадровыеДанные.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	КадровыеДанные.Колонки.Добавить("ДатаПриема", Новый ОписаниеТипов("Дата"));
	КадровыеДанные.Колонки.Добавить("ДатаУвольнения", Новый ОписаниеТипов("Дата"));
	КадровыеДанные.Колонки.Добавить("ПриказОбУвольнении", Документы.ТипВсеСсылки());
	КадровыеДанные.Колонки.Добавить("СуммированныйУчетРабочегоВремени", Новый ОписаниеТипов("Булево"));
	
	СуммированныйУчетРабочегоВремениИспользуется =
		РезультатКомпоновки.ДанныеОтчета.Колонки.Найти("РаботаГрафикРаботыСуммированныйУчетРабочегоВремени") <> Неопределено;
	
	ЕдинственнаяГоловнаяОрганизация = Неопределено;
	Для Каждого ДанныеНаПечать Из РезультатКомпоновки.ДанныеОтчета.Строки Цикл
		
		Для Каждого ДанныеДетальныхЗаписей Из ДанныеНаПечать.Строки Цикл
			
			Если Не ЗначениеЗаполнено(ДанныеДетальныхЗаписей.РаботаДатаУвольнения) Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = КадровыеДанные.Добавить();
			
			Если ДанныеДетальныхЗаписей.Владелец().Колонки.Найти("РаботаСотрудникГоловнаяОрганизация") <> Неопределено Тогда
				НоваяСтрока.ГоловнаяОрганизация = ДанныеДетальныхЗаписей.РаботаСотрудникГоловнаяОрганизация;
			Иначе
				Если ЕдинственнаяГоловнаяОрганизация = Неопределено Тогда
					ЕдинственнаяГоловнаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеДетальныхЗаписей.РаботаСотрудник, "ГоловнаяОрганизация");
				КонецЕсли;
				НоваяСтрока.ГоловнаяОрганизация = ЕдинственнаяГоловнаяОрганизация;
			КонецЕсли;
			
			НоваяСтрока.Сотрудник = ДанныеДетальныхЗаписей.РаботаСотрудник;
			НоваяСтрока.ДатаПриема = ДанныеДетальныхЗаписей.РаботаДатаПриема;
			НоваяСтрока.ДатаУвольнения = ДанныеДетальныхЗаписей.РаботаДатаУвольнения;
			НоваяСтрока.ПриказОбУвольнении = ДанныеДетальныхЗаписей.РаботаПриказОбУвольнении;
			Если СуммированныйУчетРабочегоВремениИспользуется Тогда
				НоваяСтрока.СуммированныйУчетРабочегоВремени = ДанныеДетальныхЗаписей.РаботаГрафикРаботыСуммированныйУчетРабочегоВремени;
			КонецЕсли;
			
		КонецЦикла
		
	КонецЦикла;
	
	СведенияОСреднемЗаработке = КадровыйУчетВнутренний.СведенияОСреднемЗаработкеДляСправкиПоБезработице(КадровыеДанные);
	
	Для Каждого ДанныеНаПечать Из РезультатКомпоновки.ДанныеОтчета.Строки Цикл
		
		ПерваяСтрокаПечатнойФормы = ДокументРезультат.ВысотаТаблицы + 1;
		
		Для Каждого ДанныеДетальныхЗаписей Из ДанныеНаПечать.Строки Цикл
			
			НомерСтрокиНачалаОбласти = ДокументРезультат.ВысотаТаблицы + 1;
			
			Если Не ЗначениеЗаполнено(ДанныеДетальныхЗаписей.РаботаДатаУвольнения) Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(НСтр("ru='Сотрудник %1 еще не уволен.'"), ДанныеДетальныхЗаписей.РаботаСотрудник));
				
				Продолжить;
				
			КонецЕсли;
			
			Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ДанныеПолучаемыеНаХоду = Новый Структура("СреднийЗаработок,СреднийЗаработокПрописью,ДанныеГрафикаПолногоРабочегоДня,ДанныеГрафикаСокращенногоРабочегоДня");
			
			ШаблонОписанияГрафика = НСтр("ru='%1 часовой рабочий день (смена), %2 дневная неделя (часовая неделя)'");
			
			ДанныеПолучаемыеНаХоду.ДанныеГрафикаПолногоРабочегоДня = СтрШаблон(ШаблонОписанияГрафика,
				ДанныеДетальныхЗаписей.РаботаГрафикРаботыЧасовВДеньПредставление, ДанныеДетальныхЗаписей.РаботаГрафикРаботыДнейВНеделюПредставление);
			
			ДанныеПолучаемыеНаХоду.ДанныеГрафикаСокращенногоРабочегоДня = СтрШаблон(ШаблонОписанияГрафика,
				ДанныеДетальныхЗаписей.РаботаГрафикРаботыЧасовВДеньСокращенныйПредставление, ДанныеДетальныхЗаписей.РаботаГрафикРаботыДнейВНеделюСокращенныйПредставление);
			
			КадровыйУчет.ОписаниеГрафикаРаботыДляСправкиПоБезработице(ДанныеДетальныхЗаписей,
				ШаблонОписанияГрафика,
				СуммированныйУчетРабочегоВремениИспользуется,
				ДанныеПолучаемыеНаХоду);
			
			СреднийЗаработок = СведенияОСреднемЗаработке.Получить(ДанныеДетальныхЗаписей.РаботаСотрудник);
			
			Если ЗначениеЗаполнено(СреднийЗаработок) Тогда
				
				ДанныеПолучаемыеНаХоду.СреднийЗаработок = ЗарплатаКадрыОтчеты.ТарифнаяСтавкаНаПечать(СреднийЗаработок, Истина);
				
				ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
				ДанныеПолучаемыеНаХоду.СреднийЗаработокПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(
					Окр(СреднийЗаработок, 2), ВалютаУчета);
				
			КонецЕсли;
			
			ДанныеПользовательскихПолей = ЗарплатаКадрыОтчеты.ЗначенияЗаполненияПользовательскихПолей(РезультатКомпоновки.ИдентификаторыМакета, ДанныеДетальныхЗаписей);
			
			ЗарплатаКадрыОтчеты.ВывестиВДокументРезультатОбластиМакета(
				ДокументРезультат,
				РезультатКомпоновки.МакетПечатнойФормы,
				"Бланк",
				ДанныеНаПечать,
				ДанныеДетальныхЗаписей,
				ДанныеПользовательскихПолей,
				ДанныеПолучаемыеНаХоду,
				ПараметрыДатаСправки);
			
			КадровыйЭДО.ЗадатьДетальнуюОбластьПечати(ПараметрыПечати, ДокументРезультат, ИдентификаторПечатнойФормыПФ_MXL_СправкаОСреднемЗаработке2019(),
				НомерСтрокиНачалаОбласти, ДанныеДетальныхЗаписей, ДанныеНаПечать.СсылкаНаОбъект);
			
		КонецЦикла;
		
		Если ОбъектыПечати <> Неопределено И ПерваяСтрокаПечатнойФормы < ДокументРезультат.ВысотаТаблицы Тогда
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, ПерваяСтрокаПечатнойФормы, ОбъектыПечати, ДанныеНаПечать.СсылкаНаОбъект);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВнешниеНаборыДанных() Экспорт
	
	ВнешниеНаборы = Новый Структура;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешниеНаборы.Вставить("ДанныеОрганизаций", ДанныеОрганизаций());
	ВнешниеНаборы.Вставить("ДанныеГрафиковРаботы", КадровыйУчет.ДанныеГрафиковРаботыДляСправкиОСреднемЗаработке());
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ВнешниеНаборы;
	
КонецФункции

Функция ДанныеОрганизаций()
	
	ТаблицаДанныхОрганизаций = Новый ТаблицаЗначений;
	
	ТаблицаДанныхОрганизаций.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("ТелефонОрганизации", Новый ОписаниеТипов("Строка"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("Руководитель", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаДанныхОрганизаций.Колонки.Добавить("ГлавныйБухгалтер", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	АдресаОрганизаций = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресаОрганизаций(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаСведенияОбОрганизациях = ТаблицаДанныхОрганизаций.Добавить();
		НоваяСтрокаСведенияОбОрганизациях.Организация = Выборка.Организация;
		
		Сведения = Новый СписокЗначений;
		Сведения.Добавить("", "ТелОрганизации");
		
		ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Выборка.Организация, ТекущаяДатаСеанса(), Сведения);
		
		Если ОргСведения.Свойство("ТелОрганизации") Тогда
			НоваяСтрокаСведенияОбОрганизациях.ТелефонОрганизации = ОргСведения.ТелОрганизации;
		КонецЕсли;
		
		ОтветственныеЛицаОрганизации = ЗарплатаКадры.ОтветственныеЛицаОрганизации(Выборка.Организация, "Руководитель,ГлавныйБухгалтер", ТекущаяДатаСеанса());
		НоваяСтрокаСведенияОбОрганизациях.Руководитель = ОтветственныеЛицаОрганизации.Руководитель;
		НоваяСтрокаСведенияОбОрганизациях.ГлавныйБухгалтер = ОтветственныеЛицаОрганизации.ГлавныйБухгалтер;
		
	КонецЦикла;
	
	Возврат ТаблицаДанныхОрганизаций;
	
КонецФункции

#КонецОбласти

#КонецЕсли