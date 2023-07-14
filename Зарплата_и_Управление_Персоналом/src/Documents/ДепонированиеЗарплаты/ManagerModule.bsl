
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать реестра депонированных сумм.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "РеестрДепонированныхСумм";
	КомандаПечати.Представление = УчетДепонированнойЗарплатыВнутренний.ОписаниеПечатиРеестраДепонированныхСумм().ПредставлениеКоманды;
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы 
//                                            (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение      - ссылка на объект;
//                                            представление - имя области в которой был выведен объект
//                                            (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов
//                                            (выходной параметр);
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ОписаниеПечатиРеестра = УчетДепонированнойЗарплатыВнутренний.ОписаниеПечатиРеестраДепонированныхСумм();
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеестрДепонированныхСумм") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"РеестрДепонированныхСумм", 
			ОписаниеПечатиРеестра.СинонимМакета, 
			РеестрДепонированныхСумм(МассивОбъектов, ОбъектыПечати, ОписаниеПечатиРеестра.ИмяМакета));
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Депоненты.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти
	
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	Возврат 
		ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(
			Метаданные.Документы.ДепонированиеЗарплаты);
	
КонецФункции

// АПК:299-выкл Используемость методов служебного API не контролируется
// АПК:581-выкл

// Проверяет есть ли документы по ведомости.
// 
// Параметры:
//	Ведомость - ДокументСсылка
//	Проведен  - Булево, Неопределено - если указано Неопределено, то проведенность не важна.
//
// Возвращаемое значение:
//	Булево - Истина - есть документ по ведомости.
//
Функция ЕстьПоВедомости(Ведомость, Проведен = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ведомость", Ведомость);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьДепонированияПоВедомости
	|ИЗ
	|	Документ.ДепонированиеЗарплаты КАК ДепонированиеЗарплаты
	|ГДЕ
	|	ДепонированиеЗарплаты.Ведомость = &Ведомость
	|	И НЕ ДепонированиеЗарплаты.ПометкаУдаления";
	Если Проведен <> Неопределено Тогда
		Схема = Новый СхемаЗапроса();
		Схема.УстановитьТекстЗапроса(Запрос.Текст);
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(
			?(Проведен, "ДепонированиеЗарплаты.Проведен", "НЕ ДепонированиеЗарплаты.Проведен"));
		Запрос.Текст = Схема.ПолучитьТекстЗапроса();
	КонецЕсли;
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

// Выбирает документы депонирования по ведомости.
// 
// Параметры:
//	Ведомость - ДокументСсылка
//	Проведен  - Булево, Неопределено - если указано Неопределено, то проведенность не важна.
//
// Возвращаемое значение:
//	Массив - документы по ведомости (ДокументСсылка.ДепонированиеЗарплаты).
//
Функция ВыбратьПоВедомости(Ведомость, Проведен = Неопределено, ТолькоРазрешенные = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ведомость", Ведомость);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДепонированиеЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ДепонированиеЗарплаты КАК ДепонированиеЗарплаты
	|ГДЕ
	|	ДепонированиеЗарплаты.Ведомость = &Ведомость
	|	И НЕ ДепонированиеЗарплаты.ПометкаУдаления";
	Если Проведен <> Неопределено Тогда
		Схема = Новый СхемаЗапроса();
		Схема.УстановитьТекстЗапроса(Запрос.Текст);
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(
			?(Проведен, "ДепонированиеЗарплаты.Проведен", "НЕ ДепонированиеЗарплаты.Проведен"));
		Запрос.Текст = Схема.ПолучитьТекстЗапроса();
	КонецЕсли;	
	ЗарплатаКадрыОбщиеНаборыДанных.УстановитьВыборкуТолькоРазрешенныхДанных(Запрос.Текст, ТолькоРазрешенные);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")
	
КонецФункции	

// Осуществляет поиск документов депонирования по ведомости.
// 
// Параметры:
//	Ведомость - ДокументСсылка
//	Проведен - Булево, Неопределено - если указано Неопределено, то проведенность не важна.
//
// Возвращаемое значение:
//	Массив - документы по ведомости (ДокументСсылка.ДепонированиеЗарплаты).
//
Функция НайтиПоВедомости(Ведомость, Проведен = Неопределено, ТолькоРазрешенные = Ложь) Экспорт
	
	ДокументыПоВедомости = ВыбратьПоВедомости(Ведомость, Проведен, ТолькоРазрешенные);
	
	Если ДокументыПоВедомости.Количество() = 0 Тогда
		Возврат ПустаяСсылка();
	Иначе	
		Возврат ДокументыПоВедомости[0];
	КонецЕсли;
	
КонецФункции	

// АПК:581-вкл
// АПК:299-вкл

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

Функция РеестрДепонированныхСумм(МассивОбъектов, ОбъектыПечати, ПутьКМакету)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеестрДепонированныхСумм";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы(ПутьКМакету);
	
	// получаем данные для печати
	ВыборкаШапок = ВыборкаДляПечатиШапки(МассивОбъектов);
	ВыборкаСтрок = ВыборкаДляПечатиТаблицы(МассивОбъектов);
	
	ДанныеПечати = УправлениеПечатьюБЗК.ПараметрыОбластейСтандартногоМакета(ПутьКМакету);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаШапок.Следующий() Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подсчитываем количество страниц документа - для корректного разбиения на страницы.
		ВсегоСтрокДокумента = ВыборкаСтрок.Количество();
		
		ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка			= Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвал 		= Макет.ПолучитьОбласть("Подвал");
		
		// Массив с двумя строками - для разбиения на страницы.
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		
		ОбщегоНазначенияБЗККлиентСервер.ОчиститьЗначенияСтруктуры(ДанныеПечати.ШапкаДокумента);
		ОбщегоНазначенияБЗККлиентСервер.ОчиститьЗначенияСтруктуры(ДанныеПечати.Подвал);
		
		// выводим данные о документе
		ЗаполнитьЗначенияСвойств(ДанныеПечати.ШапкаДокумента, ВыборкаШапок);
		ДанныеПечати.ШапкаДокумента.ДатаДокумента = Формат(ВыборкаШапок.Дата, "ДЛФ=D");
		ОбластьМакетаШапкаДокумента.Параметры.Заполнить(ДанныеПечати.ШапкаДокумента);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0; Итого = 0;
		// Выводим данные по строкам документа.
		ВыборкаСтрок.Сбросить();
		Пока ВыборкаСтрок.НайтиСледующий(ВыборкаШапок.Ссылка, "Ссылка") Цикл
			
			ОбщегоНазначенияБЗККлиентСервер.ОчиститьЗначенияСтруктуры(ДанныеПечати.Строка);
			
			ЗаполнитьЗначенияСвойств(ДанныеПечати.Строка, ВыборкаШапок);
			ЗаполнитьЗначенияСвойств(ДанныеПечати.Строка, ВыборкаСтрок);
			
			ДанныеПечати.Строка.ФизическоеЛицо = 
				СтрШаблон(
					НСтр("ru = '%1 %2 %3'"), 
					ВыборкаСтрок.Фамилия, 
					ВыборкаСтрок.Имя, 
					ВыборкаСтрок.Отчество);
				
			ОбластьМакетаСтрока.Параметры.Заполнить(ДанныеПечати.Строка);
				
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу.
			ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбщегоНазначенияБЗККлиентСервер.УстановитьЗначениеСвойства(
					ОбластьМакетаИтогПоСтранице.Параметры, "ИтогоНаСтранице", ИтогоНаСтранице); 
				
				ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ИтогоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			ИтогоНаСтранице = ИтогоНаСтранице + ВыборкаСтрок.Сумма;
			Итого = Итого + ВыборкаСтрок.Сумма;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбщегоНазначенияБЗККлиентСервер.УстановитьЗначениеСвойства(
				ОбластьМакетаИтогПоСтранице.Параметры, "ИтогоНаСтранице", ИтогоНаСтранице); 
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ДанныеПечати.Подвал, ВыборкаШапок);
		ДанныеПечати.Подвал.Итого = Итого;
		ОбластьМакетаПодвал.Параметры.Заполнить(ДанныеПечати.Подвал);
		
		// дополняем пустыми строками до конца страницы
		ОбщегоНазначенияБЗК.ОчиститьПараметрыТабличногоДокумента(ОбластьМакетаСтрока);
		ОбластиКонцаСтраницы = Новый Массив();
		ОбластиКонцаСтраницы.Добавить(ОбластьМакетаИтогПоСтранице);
		ОбластиКонцаСтраницы.Добавить(ОбластьМакетаПодвал);
		ОбщегоНазначенияБЗК.ДополнитьСтраницуТабличногоДокумента(
			ТабличныйДокумент, 
			ОбластьМакетаСтрока, 
			ОбластиКонцаСтраницы);  
		
		ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент, 
			НомерСтрокиНачало, 
			ОбъектыПечати, 
			ВыборкаШапок.Ссылка);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Выполняет запрос по указанным документам.
//
// Параметры: 
//  Депонирования - массив ДокументСсылка.ДепонированиеЗарплаты.
//
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса
//
Функция ВыборкаДляПечатиШапки(Депонирования)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Депонирования", Депонирования);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДепонированиеЗарплаты.Ссылка КАК Ссылка,
	|	ДепонированиеЗарплаты.Дата КАК Номер,
	|	ДепонированиеЗарплаты.Дата КАК Дата,
	|	ДепонированиеЗарплаты.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ДепонированиеЗарплаты.Организация.НаименованиеПолное КАК СТРОКА(300)) КАК НазваниеОрганизации,
	|	ВЫРАЗИТЬ(ДепонированиеЗарплаты.Организация.КодПоОКПО КАК СТРОКА(10)) КАК КодПоОКПО,
	|	ДепонированиеЗарплаты.Ведомость КАК Ведомость,
	|	ДепонированиеЗарплаты.Ведомость.Номер КАК НомерВедомости,
	|	ДепонированиеЗарплаты.Ведомость.Дата КАК ДатаВедомости,
	|	ДепонированиеЗарплаты.Ведомость.Подразделение КАК ПодразделениеВедомости,
	|	ДепонированиеЗарплаты.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
	|	ДепонированиеЗарплаты.Бухгалтер КАК Бухгалтер,
	|	ДепонированиеЗарплаты.Кассир КАК Кассир
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ДепонированиеЗарплаты КАК ДепонированиеЗарплаты
	|ГДЕ
	|	ДепонированиеЗарплаты.Ссылка В(&Депонирования)";

	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("ГлавныйБухгалтер");
	ИменаПолейОтветственныхЛиц.Добавить("Бухгалтер");
	ИменаПолейОтветственныхЛиц.Добавить("Кассир");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(
		Запрос.МенеджерВременныхТаблиц, 
		Ложь, 
		ИменаПолейОтветственныхЛиц, 
		"ВТДанныеДокументов");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Номер КАК Номер,
	|	ДанныеДокументов.Дата КАК Дата,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.НазваниеОрганизации КАК НазваниеОрганизации,
	|	ДанныеДокументов.КодПоОКПО КАК КодПоОКПО,
	|	ДанныеДокументов.Ведомость КАК Ведомость,
	|	ДанныеДокументов.НомерВедомости КАК НомерВедомости,
	|	ДанныеДокументов.ДатаВедомости КАК ДатаВедомости,
	|	ДанныеДокументов.ПодразделениеВедомости КАК ПодразделениеВедомости,
	|	ЕСТЬNULL(ВТФИОКассирПоследние.РасшифровкаПодписи, """") КАК Кассир,
	|	ЕСТЬNULL(ВТФИОГлавБухПоследние.РасшифровкаПодписи, """") КАК ГлавныйБухгалтер,
	|	ЕСТЬNULL(ВТФИОБухгалтерПоследние.РасшифровкаПодписи, """") КАК Бухгалтер
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОКассирПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОКассирПоследние.Ссылка
	|			И ДанныеДокументов.Кассир = ВТФИОКассирПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОГлавБухПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОГлавБухПоследние.Ссылка
	|			И ДанныеДокументов.ГлавныйБухгалтер = ВТФИОГлавБухПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОБухгалтерПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОБухгалтерПоследние.Ссылка
	|			И ДанныеДокументов.Бухгалтер = ВТФИОБухгалтерПоследние.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокументов.Организация,
	|	НАЧАЛОПЕРИОДА(ДанныеДокументов.Дата, ГОД),
	|	ДанныеДокументов.Номер";
	
	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

// Выполняет запрос по табличным частям указанных документов.
//
// Параметры: 
//  Депонирования - массив ДокументСсылка.ДепонированиеЗарплаты.
//
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса
//
Функция ВыборкаДляПечатиТаблицы(Депонирования)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Данные о депонированных суммах в разрезе сотрудников
	
	Запрос.УстановитьПараметр("Депонирования", Депонирования);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДепонированиеЗарплатыДепоненты.Ссылка КАК Ссылка,
	|	ДепонированиеЗарплатыДепоненты.Ссылка.Ведомость.Дата КАК ДатаВедомости,
	|	ДепонированиеЗарплатыДепоненты.НомерСтроки КАК НомерСтроки,
	|	ДепонированиеЗарплатыДепоненты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВзаиморасчетыССотрудниками.Сотрудник КАК Сотрудник,
	|	СУММА(ВзаиморасчетыССотрудниками.СуммаВзаиморасчетов) КАК Сумма
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ДепонированиеЗарплаты.Депоненты КАК ДепонированиеЗарплатыДепоненты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыССотрудниками КАК ВзаиморасчетыССотрудниками
	|		ПО (ВзаиморасчетыССотрудниками.ФизическоеЛицо = ДепонированиеЗарплатыДепоненты.ФизическоеЛицо)
	|			И (ВзаиморасчетыССотрудниками.Регистратор = ДепонированиеЗарплатыДепоненты.Ссылка.Ведомость)
	|ГДЕ
	|	ДепонированиеЗарплатыДепоненты.Ссылка В(&Депонирования)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДепонированиеЗарплатыДепоненты.Ссылка,
	|	ДепонированиеЗарплатыДепоненты.НомерСтроки,
	|	ДепонированиеЗарплатыДепоненты.ФизическоеЛицо,
	|	ВзаиморасчетыССотрудниками.Сотрудник,
	|	ДепонированиеЗарплатыДепоненты.Ссылка.Ведомость.Дата";
	
	Запрос.Выполнить();
	
	// Получаем кадровые данные сотрудников.
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокументов.Сотрудник КАК Сотрудник,
	|	ДанныеДокументов.ДатаВедомости КАК Период
	|ПОМЕСТИТЬ ВТСотрудникиИПериод
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов";
	Запрос.Выполнить();
	
	ОписательВТ = 
		КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
			Запрос.МенеджерВременныхТаблиц,
			"ВТСотрудникиИПериод");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(
		ОписательВТ, Истина, "Подразделение, ТабельныйНомер, Фамилия, Имя, Отчество");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.НомерСтроки КАК НомерСтроки,
	|	КадровыеДанныеСотрудников.Подразделение,
	|	КадровыеДанныеСотрудников.ТабельныйНомер,
	|	КадровыеДанныеСотрудников.Фамилия,
	|	КадровыеДанныеСотрудников.Имя,
	|	КадровыеДанныеСотрудников.Отчество,
	|	СУММА(ДанныеДокументов.Сумма) КАК Сумма
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.Ссылка,
	|	ДанныеДокументов.НомерСтроки,
	|	КадровыеДанныеСотрудников.Подразделение,
	|	КадровыеДанныеСотрудников.ТабельныйНомер,
	|	КадровыеДанныеСотрудников.Фамилия,
	|	КадровыеДанныеСотрудников.Имя,
	|	КадровыеДанныеСотрудников.Отчество
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки";

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
