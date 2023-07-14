#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Отказ = Отказ ИЛИ НЕ МожноЗаполнитьЗатраты();
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПериодРегистрации");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ПереносЗатратНаПерсоналМеждуСтатьями.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполнение документа

Функция МожноЗаполнитьЗатраты() Экспорт
	
	ПравилаПроверки = Новый Структура;
	
	ПравилаПроверки.Вставить("Организация",			НСтр("ru='Не выбрана организация'"));
	ПравилаПроверки.Вставить("ПериодРегистрации",	НСтр("ru='Не указан месяц начисления'"));
	
	МожноЗаполнитьЗатраты = 
		ЗарплатаКадры.СвойстваЗаполнены(ЭтотОбъект, ПравилаПроверки);
		
	Возврат МожноЗаполнитьЗатраты 
	
КонецФункции

Процедура ЗаполнитьЗатраты() Экспорт
	
	Сотрудники			= СотрудникиПоШапкеДокумента();
	ЗатратыНаСотрудников= ЗатратыНаСотрудников(Сотрудники);
	
	Затраты.Очистить();
	Переносы.Очистить();
	ПоместитьЗатратыНаСотрудниковВТЧ(ЗатратыНаСотрудников);

КонецПроцедуры	

Функция СотрудникиПоШапкеДокумента()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОтложенноеПроведениеДокументов") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОтражениеДокументовВУчетеСтраховыхВзносов");
		Модуль.ОтразитьДокументыВУчетеСтраховыхВзносов(Организация);
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	// Получаем всех работавших в организации в периоде регистрации.
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 					= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.ОтбиратьПоГоловнойОрганизации 	= Ложь;
	ПараметрыПолученияСотрудниковОрганизаций.Подразделение 					= Подразделение;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода 		=  НачалоМесяца(ПериодРегистрации);
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	=  КонецМесяца(ПериодРегистрации);
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоТрудовымДоговорам = Истина;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ = Неопределено;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодработки") Тогда
		ПараметрыПолученияСотрудниковОрганизаций.ПодработкиРаботниковПоТрудовымДоговорам = Истина;
	КонецЕсли;	
	КадровыйУчетРасширенный.ПрименитьОтборПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(ПараметрыПолученияСотрудниковОрганизаций);
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(
		МенеджерВременныхТаблиц, Истина, 
		ПараметрыПолученияСотрудниковОрганизаций, 
		"ВТСотрудникиПоМестуРаботы");
		
	// Отбираем сотрудников, у которых в бухучете встречается заданная статья финансирования.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ПериодРегистрации", ПериодРегистрации);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БухучетНачисленияУдержания.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрНакопления.БухучетНачисленияУдержанияПоСотрудникам КАК БухучетНачисленияУдержания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиПоМестуРаботы КАК СотрудникиПоМестуРаботы
	|		ПО БухучетНачисленияУдержания.Сотрудник = СотрудникиПоМестуРаботы.Сотрудник
	|ГДЕ
	|	БухучетНачисленияУдержания.Период = &ПериодРегистрации
	|	И &ОтборПоСтатьеФинансирования
	|	И БухучетНачисленияУдержания.ГруппаНачисленияУдержанияВыплаты = ЗНАЧЕНИЕ(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
	|	И НЕ БухучетНачисленияУдержания.ДанныеМежрасчетногоПериода
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СтраховыеВзносы.Сотрудник
	|ИЗ
	|	РегистрНакопления.СтраховыеВзносыПоФизическимЛицам КАК СтраховыеВзносы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиПоМестуРаботы КАК СотрудникиПоМестуРаботы
	|		ПО СтраховыеВзносы.Сотрудник = СотрудникиПоМестуРаботы.Сотрудник
	|ГДЕ
	|	СтраховыеВзносы.Период = &ПериодРегистрации
	|	И &ОтборПоСтатьеФинансирования";
	Если ЗначениеЗаполнено(СтатьяФинансирования) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоСтатьеФинансирования", "СтатьяФинансирования = &СтатьяФинансирования");
		Запрос.УстановитьПараметр("СтатьяФинансирования", СтатьяФинансирования);
	Иначе		
		Запрос.УстановитьПараметр("ОтборПоСтатьеФинансирования", Истина);
	КонецЕсли;	
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	
КонецФункции	

Функция ЗатратыНаСотрудников(Сотрудники)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ПараметрыДокумента = Новый Структура("Организация,Ссылка,ПериодРегистрации",Организация,Ссылка,ПериодРегистрации);
	Документы.ПереносЗатратНаПерсоналМеждуСтатьями.ЗарегистрированныеДанныеПоСотрудникам(ПараметрыДокумента, МенеджерВременныхТаблиц, Сотрудники);
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Затраты.Сотрудник КАК Сотрудник,
	|	Затраты.Подразделение КАК Подразделение,
	|	Затраты.Начисление КАК Начисление,
	|	Затраты.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	Затраты.СтатьяРасходов КАК СтатьяРасходов,
	|	Затраты.СтатьяФинансирования КАК СтатьяФинансирования,
	|	СУММА(0) КАК СтраховыеВзносы,
	|	СУММА(Затраты.Зарплата) КАК Зарплата
	|ИЗ
	|	(ВЫБРАТЬ
	|		Начисления.Сотрудник КАК Сотрудник,
	|		Начисления.Подразделение КАК Подразделение,
	|		Начисления.Начисление КАК Начисление,
	|		Начисления.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|		Начисления.СтатьяРасходов КАК СтатьяРасходов,
	|		Начисления.СтатьяФинансирования КАК СтатьяФинансирования,
	|		Начисления.Сумма КАК Зарплата,
	|		&НулевыеСуммы КАК СуммыИзРегистра
	|	ИЗ
	|		ВТНачисления КАК Начисления
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СтраховыеВзносы.Сотрудник,
	|		СтраховыеВзносы.Подразделение,
	|		СтраховыеВзносы.Начисление,
	|		СтраховыеВзносы.СпособОтраженияЗарплатыВБухучете,
	|		СтраховыеВзносы.СтатьяРасходов,
	|		СтраховыеВзносы.СтатьяФинансирования,
	|		0,
	|		&СуммыИзРегистра
	|	ИЗ
	|		ВТВзносы КАК СтраховыеВзносы) КАК Затраты
	|
	|СГРУППИРОВАТЬ ПО
	|	Затраты.СтатьяФинансирования,
	|	Затраты.СтатьяРасходов,
	|	Затраты.СпособОтраженияЗарплатыВБухучете,
	|	Затраты.Подразделение,
	|	Затраты.Сотрудник,
	|	Затраты.Начисление
	|
	|ИМЕЮЩИЕ
	|	(СУММА(Затраты.Зарплата) <> 0
	|		ИЛИ &Условие)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Подразделение,
	|	СтатьяФинансирования,
	|	Начисление,
	|	СпособОтраженияЗарплатыВБухучете,
	|	СтатьяРасходов";
	
	НулевыеСуммы = СтрЗаменить(УчетСтраховыхВзносов.ОтражаемыеВУчетеВзносы(Истина, "0 КАК "), ".", "");
	СуммыИзРегистра = УчетСтраховыхВзносов.ОтражаемыеВУчетеВзносы(Истина, "СтраховыеВзносы");
	ТекстПолейВзносов = "";
	Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(УчетСтраховыхВзносов.ОтражаемыеВУчетеВзносы(Истина)) Цикл
		ТекстПолейВзносов = ТекстПолейВзносов + "СУММА(Затраты." + ИмяПоля + ") КАК " + ИмяПоля + "," + Символы.ПС;
	КонецЦикла;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&НулевыеСуммы КАК СуммыИзРегистра", НулевыеСуммы);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&СуммыИзРегистра", СуммыИзРегистра);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "СУММА(0) КАК СтраховыеВзносы,", ТекстПолейВзносов);
	Условие = СтрЗаменить(УчетСтраховыхВзносов.ОтражаемыеВУчетеВзносы(Истина, "СУММА(Затраты"), ",", ") <> 0 ИЛИ ") + ") <> 0";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", Условие);
	Возврат Запрос.Выполнить();
	
КонецФункции	

Процедура ПоместитьЗатратыНаСотрудниковВТЧ(ЗатратыНаСотрудников)
	
	Выборка = ЗатратыНаСотрудников.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Выборка.Начисление) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаЗатрат = Затраты.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЗатрат, Выборка);
		СтрокаЗатрат.ИдентификаторСтрокиЗатрат = Новый УникальныйИдентификатор;
		
		СтрокаЗатрат.Сумма = 0;
		Для Каждого РеквизитДетализацииЗатрат Из Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыДетализацииЗатрат() Цикл
			СтрокаЗатрат.Сумма = СтрокаЗатрат.Сумма + СтрокаЗатрат[РеквизитДетализацииЗатрат]
		КонецЦикла;	
		
	КонецЦикла	
	
КонецПроцедуры	

Процедура ДополнитьЗатраты(Сотрудники) Экспорт
	
	ЗатратыНаСотрудников= ЗатратыНаСотрудников(Сотрудники);
	ПоместитьЗатратыНаСотрудниковВТЧ(ЗатратыНаСотрудников);
	
КонецПроцедуры	

// Перенос затрат

Процедура ПеренестиЗатраты(ПереносимыеСтроки, Финансирование, Сумма) Экспорт
	
	ОстатокСуммы = Сумма;
	Для Каждого ПереносимаяСтрока Из ПереносимыеСтроки Цикл
		
		ПеренесеннаяСумма = 0;
		
		СтрокаЗатрат = Затраты.Найти(ПереносимаяСтрока, "ИдентификаторСтрокиЗатрат");
		Если СтрокаЗатрат <> Неопределено Тогда
			// это строка затрат
			ПеренесеннаяСумма = ПеренестиЗатратыСтрокиЗатрат(СтрокаЗатрат, Финансирование, ОстатокСуммы);
		КонецЕсли;	
		
		СтрокаПереноса = Переносы.Найти(ПереносимаяСтрока, "ИдентификаторСтрокиПереноса");
		Если СтрокаПереноса <> Неопределено Тогда
			// это строка переноса
			ПеренесеннаяСумма = ПеренестиЗатратыСтрокиПереноса(СтрокаПереноса, Финансирование, ОстатокСуммы);
		КонецЕсли;
		
		ОстатокСуммы = ОстатокСуммы - ПеренесеннаяСумма;
		Если ОстатокСуммы = 0 Тогда
			Прервать;
		КонецЕсли;	
		
	КонецЦикла;
	
	// образовавшиеся пустые переносы удаляем
	Для Каждого ПустаяСтрока Из Переносы.НайтиСтроки(Новый Структура("Сумма", 0)) Цикл
		Переносы.Удалить(ПустаяСтрока);
	КонецЦикла;
	
КонецПроцедуры	

Функция ПеренестиЗатратыСтрокиЗатрат(СтрокаЗатрат, Финансирование, Сумма)
	
	СуммаПоложительная = (Сумма>0);
	
	ПараметрыОтбораПереносов = Новый Структура;
	ПараметрыОтбораПереносов.Вставить("ИдентификаторСтрокиЗатрат", СтрокаЗатрат.ИдентификаторСтрокиЗатрат);
	ПараметрыОтбораПереносов.Вставить("СтатьяФинансирования", Финансирование.СтатьяФинансирования);
	
	ПереносыСтрокиЗатратПоСтатьеФинансирования = Переносы.НайтиСтроки(ПараметрыОтбораПереносов);
	
	Если СтрокаЗатрат.СтатьяФинансирования = Финансирование.СтатьяФинансирования Тогда
		// Возврат затрат на исходную статью
		// ищем перенос этой затраты по указанной статье и уменьшаем его сумму.
		Если ПереносыСтрокиЗатратПоСтатьеФинансирования.Количество() = 0 Тогда
			Возврат 0; // переносов строки затрат на указанную статью не было, "возвращать" на затраты нечего
		КонецЕсли;	
		СтрокаПереноса = ПереносыСтрокиЗатратПоСтатьеФинансирования[0];
		Если СуммаПоложительная Тогда
			ПереносимаяСумма = Мин(СтрокаЗатрат.Сумма, СтрокаПереноса.Сумма, Сумма);
		Иначе
			ПереносимаяСумма = Макс(СтрокаЗатрат.Сумма, СтрокаПереноса.Сумма, Сумма);
		КонецЕсли;
		СтрокаПереноса.Сумма = СтрокаПереноса.Сумма - ПереносимаяСумма;
	Иначе
		// Перенос затрат на другую статью
		// создаем перенос этой затраты по указанной статье на заданную сумму.
		Если ПереносыСтрокиЗатратПоСтатьеФинансирования.Количество() = 0 Тогда
			СтрокаПереноса = Переносы.Добавить();
			СтрокаПереноса.ИдентификаторСтрокиПереноса = Новый УникальныйИдентификатор;
			ЗаполнитьЗначенияСвойств(СтрокаПереноса, ПараметрыОтбораПереносов);
			ЗаполнитьЗначенияСвойств(СтрокаПереноса, СтрокаЗатрат, СтрСоединить(Документы.ПереносЗатратНаПерсоналМеждуСтатьями.РеквизитыФинансированияЗатрат(), ", "));
			ЗаполнитьЗначенияСвойств(СтрокаПереноса, Финансирование);
		Иначе	
			СтрокаПереноса = ПереносыСтрокиЗатратПоСтатьеФинансирования[0];
		КонецЕсли;
		Если СуммаПоложительная Тогда
			ПереносимаяСумма = Мин(СтрокаЗатрат.Сумма, Сумма);
		Иначе
			ПереносимаяСумма = Макс(СтрокаЗатрат.Сумма, Сумма);
		КонецЕсли;
		СтрокаПереноса.Сумма = СтрокаПереноса.Сумма + ПереносимаяСумма;
	КонецЕсли;	
	
	Возврат ПереносимаяСумма
	
КонецФункции

Функция ПеренестиЗатратыСтрокиПереноса(СтрокаПереноса, Финансирование, Сумма)
	
	СуммаПоложительная = (Сумма>0);
	
	СтрокаЗатрат = Затраты.Найти(СтрокаПереноса.ИдентификаторСтрокиЗатрат, "ИдентификаторСтрокиЗатрат");
	
	Если СтрокаПереноса.СтатьяФинансирования = Финансирование.СтатьяФинансирования Тогда
		// перенос на ту же самую статью - ничего делать не надо
		Возврат 0;
	ИначеЕсли СтрокаЗатрат.СтатьяФинансирования = Финансирование.СтатьяФинансирования Тогда
		// Возврат затрат на исходную статью
		// уменьшаем сумму текущего переноса.
		Если СуммаПоложительная Тогда
			ПереносимаяСумма = Мин(СтрокаЗатрат.Сумма, СтрокаПереноса.Сумма, Сумма);
		Иначе
			ПереносимаяСумма = Макс(СтрокаЗатрат.Сумма, СтрокаПереноса.Сумма, Сумма);
		КонецЕсли;
		СтрокаПереноса.Сумма = СтрокаПереноса.Сумма - ПереносимаяСумма;
	Иначе
		// Перенос затрат на другую статью
		// создаем перенос этой затраты по указанной статье на заданную сумму
		// уменьшаем сумму текущего переноса.
		
		ПараметрыОтбораПереносов = Новый Структура;
		ПараметрыОтбораПереносов.Вставить("ИдентификаторСтрокиЗатрат", СтрокаЗатрат.ИдентификаторСтрокиЗатрат);
		ПараметрыОтбораПереносов.Вставить("СтатьяФинансирования", Финансирование.СтатьяФинансирования);
	
		ПереносыСтрокиЗатратПоСтатье = Переносы.НайтиСтроки(ПараметрыОтбораПереносов);
		
		Если ПереносыСтрокиЗатратПоСтатье.Количество() = 0 Тогда
			СтрокаПереносаПоСтатье = Переносы.Добавить();
			СтрокаПереноса.ИдентификаторСтрокиПереноса = Новый УникальныйИдентификатор;
			ЗаполнитьЗначенияСвойств(СтрокаПереноса, Финансирование);
			ЗаполнитьЗначенияСвойств(СтрокаПереноса, ПараметрыОтбораПереносов);
		Иначе	
			СтрокаПереносаПоСтатье = ПереносыСтрокиЗатратПоСтатье[0];
		КонецЕсли;	
		
		Если СуммаПоложительная Тогда
			ПереносимаяСумма = Мин(СтрокаПереноса.Сумма, Сумма);
		Иначе
			ПереносимаяСумма = Макс(СтрокаПереноса.Сумма, Сумма);
		КонецЕсли;
		СтрокаПереноса.Сумма = СтрокаПереноса.Сумма - ПереносимаяСумма;
		СтрокаПереносаПоСтатье.Сумма = СтрокаПереноса.Сумма + ПереносимаяСумма;
	КонецЕсли;	
	
	Возврат ПереносимаяСумма
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли