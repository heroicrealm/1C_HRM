#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка,
				"ДокументРассчитан", 
				"Начисления,
				|НачисленияПерерасчет,
				|НачисленияПерерасчетНулевыеСторно,
				|НДФЛ,
				|ПримененныеВычетыНаДетейИИмущественные,
				|РаспределениеРезультатовНачислений,
				|РаспределениеРезультатовУдержаний,
				|Удержания");
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;

		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПоПараметрамЗаполнения" Тогда
			ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения);
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПослеПереноса" Тогда
			ЗаполнитьПослеПереноса(ДанныеЗаполнения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);	

	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		
		Если ДокументРассчитан Тогда
			
			ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
			
			ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок);
			
			ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
			ПроверитьПериодДействияНачислений(Отказ);
			
			// Проверка корректности распределения по источникам финансирования
			ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
			
			ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
				ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
			
			// Проверка корректности распределения по территориям и условиям труда
			ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
			
			РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
				ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, Отказ);
	
	УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПерерасчетЗарплаты.УдалитьПерерасчетыПоРегистратору(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСотрудникаВТаблицахНачислений();
	
	ПредставлениеПериода = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ПредставлениеПериодаДляДнейУхода(ДниУхода);
	
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокумент(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетСреднегоЗаработка.ЗаписатьДатуНачалаСобытия(Ссылка, Сотрудник, ДатаНачалаСобытия);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокументПриКопировании(ЭтотОбъект, ОбъектКопирования.Ссылка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаЗаполненияДокумента

Функция ДокументГотовКРасчету(ВыводитьСообщения = Истина) Экспорт
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);
	
	ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, Истина);                                                                        
		
	КонтейнерСодержитОшибки = Ложь;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, КонтейнерСодержитОшибки);
	
	Если Не ВыводитьСообщения Тогда
		
		ПолучитьСообщенияПользователю(Истина);		
		
	КонецЕсли;
	
	Возврат Не КонтейнерСодержитОшибки;	
	
КонецФункции

Процедура ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок)
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан период регистрации.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПериодРегистрации", ТекстСообщения, "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" обязательно к заполнению.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Организация", ТекстСообщения, "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Сотрудник"" обязательно к заполнению.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Сотрудник", ТекстСообщения, "");
	КонецЕсли;
	
	Если ДниУхода.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не указаны дни ухода за детьми-инвалидами.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДниУхода", ТекстСообщения, "");
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, ПроверкаПередРасчетом = Ложь)
	
	Если Не ДокументРассчитан И Не ПроверкаПередРасчетом Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВидРасчета) 
		И Не ПолучитьФункциональнуюОпцию("ВыбиратьВидНачисленияОплатыДнейУходаЗаДетьмиИнвалидами") Тогда
		ТекстСообщения = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ТекстСообщенияНеЗаполненВидРасчета();
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ВидРасчета", ТекстСообщения, "");
	КонецЕсли;
	
	ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом)
	
	МассивНачисленийДокумента = Новый Массив;
	
	Если НЕ ПроверкаПередРасчетом Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, Начисления.ВыгрузитьКолонку("Начисление"), Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, НачисленияПерерасчет.ВыгрузитьКолонку("Начисление"), Истина);
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.ДатаВыплатыОбязательнаКЗаполнению(ПорядокВыплаты, МассивНачисленийДокумента)
		И Не ЗначениеЗаполнено(ПланируемаяДатаВыплаты) Тогда
		ТекстСообщения = НСтр("ru = 'Дата выплаты обязательна к заполнению при выплате в межрасчет.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПланируемаяДатаВыплаты", ТекстСообщения, "");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru = 'Перерасчет прошлого периода'")));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", НСтр("ru = 'Удержания'"), "Удержание"));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты)
	
	Если ПроверяемыеРеквизиты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудник");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДниУхода");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидРасчета");
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьСотрудникаВТаблицахНачислений()
	
	ТаблицыНачислений = Новый Массив;
	ТаблицыНачислений.Добавить(Начисления);
	ТаблицыНачислений.Добавить(НачисленияПерерасчет);
	ТаблицыНачислений.Добавить(НачисленияПерерасчетНулевыеСторно);
	
	Для Каждого ТаблицаНачислений Из ТаблицыНачислений Цикл
		Для Каждого СтрокаТаблицы Из ТаблицаНачислений Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Сотрудник) Тогда
				СтрокаТаблицы.Сотрудник = Сотрудник;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПослеПереноса(ДанныеЗаполнения)

	Если ЗначениеЗаполнено(ДатаНачала) Тогда
		
		Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
			ДатаОкончания = ДатаНачала;
		КонецЕсли;
		
		ОчереднаяДата = ДатаНачала;
		Пока ОчереднаяДата <= ДатаОкончания Цикл
			НоваяСтрока = ДниУхода.Добавить();
	        НоваяСтрока.Дата = ОчереднаяДата;
			ОчереднаяДата = ОчереднаяДата + 86400;
		КонецЦикла;
		
	КонецЕсли;
	
	ПериодРасчетаСреднего = УчетСреднегоЗаработка.ПериодРасчетаОбщегоСреднегоЗаработкаСотрудника(ДатаНачалаСобытия, Сотрудник);
	ПериодРасчетаСреднегоЗаработкаНачало	= ПериодРасчетаСреднего.ДатаНачала;
	ПериодРасчетаСреднегоЗаработкаОкончание = ПериодРасчетаСреднего.ДатаОкончания;
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
	ЗапрашиваемыеЗначения.Вставить("ГлавныйБухгалтер", "ГлавныйБухгалтер");
	ЗапрашиваемыеЗначения.Вставить("Бухгалтер", "Бухгалтер");
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));

КонецПроцедуры

Процедура ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ЗаполняемыеЗначения = Новый Структура(
		"ПериодРегистрации, 
		|Ответственный");
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ТекущаяДатаСеанса());
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаполняемыеЗначения);
	
	Если ДанныеЗаполнения.Свойство("ДниУхода") Тогда
		Для каждого ДеньУхода Из ДанныеЗаполнения.ДниУхода Цикл
			НовыйДеньУхода = ДниУхода.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйДеньУхода, ДеньУхода);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли