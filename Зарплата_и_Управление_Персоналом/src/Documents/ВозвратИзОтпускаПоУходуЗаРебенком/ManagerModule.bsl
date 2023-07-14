#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
	УправлениеШтатнымРасписанием.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
	
	Возврат Истина;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Сотрудник)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Описание - возвращает описание разделов данных, которые содержит документ
// 
// Возвращаемое значение:
// 	Соответствие - описание разделов данных документов -
//	 *Ключ - Строка - имя раздела. Одно из значений структуры 
//		возвращаемой методом см. МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных
//   *Значение - см. МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных - описание раздела
//
Функция ОписаниеРазделовДанных() Экспорт
	ВсеРазделы = МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных();
	
	ОписаниеРазделовДанных = Новый Соответствие();
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.КадровыеДанные, ОписаниеРаздела);	
	ОписаниеРаздела.РеквизитСостояние = "Проведен";
	ОписаниеРаздела.РеквизитОтветсвенный = "Ответственный";
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.ПлановыеНачисления, ОписаниеРаздела);
	ОписаниеРаздела.РеквизитСостояние = "НачисленияУтверждены";	
	ОписаниеРаздела.ТребуетсяУтверждениеПриПроведении = Истина;
	ОписаниеРаздела.СообщениеДокументНеУтвержден =  НСтр("ru = '%1 - ежемесячные начисления не установлены.'");
	
	Возврат ОписаниеРазделовДанных;
КонецФункции

// Описание - возвращает структуру со значениями по которым будут проверяться права на разделы документа
// 				 
// Параметры:
//  ДокументОбъект - ДокументОбъект.ВозвратИзОтпускаПоУходуЗаРебенком, ДанныеФормыСтруктура - объект или данные формы, 
//					отображающие данные документа, для которого нужно получить данные
//
// Возвращаемое значение:
// 	Структура -  см. НовыйЗначенияДоступа - значения доступа по которым будут проверяться права на документ
//
Функция ЗначенияДоступа(ДокументОбъект) Экспорт
	Возврат МногофункциональныеДокументыБЗК.ЗначенияДоступаПоСоставуДокумента(
		ДокументОбъект, 
		ДокументОбъект.Организация);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке("Сотрудник", "ОсновнойСотрудник");
КонецФункции

// Описывает реквизит документы, в котором хранится ссылка на кадровое решение. 
Функция ОписаниеРеквизитаКадровогоРешения() Экспорт
	Возврат Метаданные.Документы.ВозвратИзОтпускаПоУходуЗаРебенком.Реквизиты.Решение;
КонецФункции

#Область УчетПособий

// Возникает при заполнении документа УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком на основании текущего документа.
Процедура ЗаполнитьУведомлениеОПрекращенииОтпускаПоУходуЗаРебенкомПоОснованию(ВозвратИзОтпускаСсылка, РеквизитыУведомления) Экспорт
	РеквизитыВозврата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВозвратИзОтпускаСсылка, "Организация, ОсновнойСотрудник, Дата, Номер, ДатаВозврата");
	
	РеквизитыУведомления.Вставить("ТипПриказа", Перечисления.ОснованияПрекращенияПособийПоУходу.ПриказОДосрочномВыходеНаРаботу);
	РеквизитыУведомления.Вставить("Организация", РеквизитыВозврата.Организация);
	РеквизитыУведомления.Вставить("Сотрудник", РеквизитыВозврата.ОсновнойСотрудник);
	РеквизитыУведомления.Вставить("ДатаПриказа", РеквизитыВозврата.Дата);
	РеквизитыУведомления.Вставить("НомерПриказа", РеквизитыВозврата.Номер);
	РеквизитыУведомления.Вставить("ДатаПрекращенияОплаты", РеквизитыВозврата.ДатаВозврата);
КонецПроцедуры

#КонецОбласти

Функция СвойстваИсправляемогоДокумента(ДокументСсылка) Экспорт
	
	Реквизиты = ИсправлениеДокументовЗарплатаКадры.РеквизитыИсправляемогоДокумента();
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, Реквизиты);
	
КонецФункции

Функция ПараметрыИсправляемогоДокумента(ДокументСсылка) Экспорт
	
	Возврат ИсправлениеДокументовЗарплатаКадры.ПараметрыИсправляемогоДокумента(ДокументСсылка,
		СвойстваИсправляемогоДокумента(ДокументСсылка));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ВозвратИзОтпускаПоУходуЗаРебенком);
	
КонецФункции	

Процедура РассчитатьФОТПоДокументу(ДокументОбъект) Экспорт
	
	Если НЕ ДокументОбъект.ИзменитьНачисления Тогда
		Возврат;
	КонецЕсли; 
	
	// Подготовка к расчету ФОТ
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	ИзвестныеКадровыеДанные = ПлановыеНачисленияСотрудников.СоздатьТаблицаКадровыхДанных();
	
	КадровыеДанныеСотрудника = ИзвестныеКадровыеДанные.Добавить();
	КадровыеДанныеСотрудника.Сотрудник = ДокументОбъект.ОсновнойСотрудник;
	КадровыеДанныеСотрудника.Период = ДокументОбъект.ДатаВозврата;
	КадровыеДанныеСотрудника.Организация = ДокументОбъект.Организация;     	
	
	ТаблицаСотрудников = ДокументОбъект.Начисления.Выгрузить(, "РабочееМесто");
	ТаблицаСотрудников.Свернуть("РабочееМесто");
	
	Для Каждого СтрокаТаблицыСотрудников Из ТаблицаСотрудников Цикл
		
		НачисленияСотрудника = ДокументОбъект.Начисления.НайтиСтроки(Новый Структура("РабочееМесто", СтрокаТаблицыСотрудников.РабочееМесто));
		
		Для Каждого СтрокаНачисления Из НачисленияСотрудника Цикл
			
			ДанныеНачисления = ТаблицаНачислений.Добавить();
			ДанныеНачисления.Сотрудник = ДокументОбъект.ОсновнойСотрудник;
			ДанныеНачисления.Период = ДокументОбъект.ДатаВозврата;
			ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
			ДанныеНачисления.Размер = СтрокаНачисления.Размер;
			ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
									
			ПоказателиНачисления = ДокументОбъект.Показатели.НайтиСтроки(Новый Структура("ИдентификаторСтрокиВидаРасчета", СтрокаНачисления.ИдентификаторСтрокиВидаРасчета));
			Для Каждого СтрокаПоказателя Из ПоказателиНачисления Цикл
				ДанныеПоказателя = ТаблицаПоказателей.Добавить();
				ДанныеПоказателя.Сотрудник = ДокументОбъект.ОсновнойСотрудник;
				ДанныеПоказателя.Период = ДокументОбъект.ДатаВозврата;
				ДанныеПоказателя.Показатель = СтрокаПоказателя.Показатель;
				ДанныеПоказателя.Значение = СтрокаПоказателя.Значение;
				ДанныеПоказателя.ДокументОснование = СтрокаНачисления.ДокументОснование;
			КонецЦикла;
			
		КонецЦикла;
				
	КонецЦикла;
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей, ИзвестныеКадровыеДанные);
			
	Для Каждого ОписаниеНачисления Из РассчитанныеДанные.ПлановыйФОТ Цикл
		
		Отбор = Новый Структура("РабочееМесто, Начисление, ДокументОснование", 
		СтрокаТаблицыСотрудников.РабочееМесто, ОписаниеНачисления.Начисление, ОписаниеНачисления.ДокументОснование);
		СтрокиДокумента = ДокументОбъект.Начисления.НайтиСтроки(Отбор);
		
		Если СтрокиДокумента.Количество() > 0 Тогда
			СтрокиДокумента[0].Размер = ОписаниеНачисления.ВкладВФОТ;
		КонецЕсли; 
		
	КонецЦикла;      
	
	РасчетЗарплатыРасширенный.ЗаполнитьФОТВДвиженияхЗагружаемогоДокумента(ДокументОбъект.Движения.ПлановыеНачисления, ДокументОбъект.Начисления, "РабочееМесто");
	
КонецПроцедуры

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ОсновнойСотрудник,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаНачалаПФР
	|ИЗ
	|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
	|ГДЕ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка В(&МассивСсылок)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу); 
		
		ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
		ОписаниеПериода.Сотрудник = Выборка.ОсновнойСотрудник;	
		ОписаниеПериода.ДатаНачалаПериода = Макс(Выборка.ДатаВозврата, Выборка.ДатаНачалаПФР);
		ОписаниеПериода.ДатаНачалаСобытия = Выборка.ДатаВозврата;
		ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;

		РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
		
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);
		
	КонецЦикла;	
		
	Возврат ДанныеДляРегистрацииВУчете;
															
КонецФункции	

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОВыходеНаРаботуИзОтпускаПоУходуЗаРебенком";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о выходе на работу до окончания отпуска по уходу за ребенком'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОПрекращенииОтпускаПоУходуЗаРебенком";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о прекращении отпуска в связи с уходом в отпуск по беременности и родам'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

#КонецОбласти

// Функция возвращает структуру с описанием данного вида документа.
//
Функция ОписаниеДокумента() Экспорт 

	ОписаниеДокумента = ЗарплатаКадрыРасширенныйКлиентСервер.СтруктураОписанияДокумента();
	
	ОписаниеДокумента.КраткоеНазваниеИменительныйПадеж	 = НСтр("ru = 'возврат'");
	ОписаниеДокумента.КраткоеНазваниеРодительныйПадеж	 = НСтр("ru = 'возврата'");
	ОписаниеДокумента.ИмяРеквизитаСотрудник				 = "ОсновнойСотрудник";
	ОписаниеДокумента.ИмяРеквизитаОтсутствующийСотрудник = "ОсновнойСотрудник";
	ОписаниеДокумента.ИмяРеквизитаДатаНачалаСобытия		 = "ДатаВозврата";
	ОписаниеДокумента.ИмяРеквизитаДокументОснование	 = "ДокументОснование";
	
	Возврат ОписаниеДокумента;

КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента, "ДатаВозврата");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка КАК Ссылка,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Дата КАК Дата
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеВыполнено = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, Выборка.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", Выборка.Ссылка) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Ссылка);
			МенеджерДокумента.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента);
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбновлениеВыполнено);
	
КонецПроцедуры

Процедура ЗаполнитьДвиженияЗанятостьПозицийШтатногоРасписания(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ПараметрыОбновления = Неопределено Тогда
		МассивОбновленных = Новый Массив;
	Иначе
		
		Если ПараметрыОбновления.Свойство("МассивОбновленных") Тогда
			МассивОбновленных = ПараметрыОбновления.МассивОбновленных;
		Иначе
			МассивОбновленных = Новый Массив;
			ПараметрыОбновления.Вставить("МассивОбновленных", МассивОбновленных);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОбновленных", МассивОбновленных);
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ТаблицаДокумента.Ссылка КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторыКОбновлению
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|		ПО ТаблицаДокумента.ОсновнойСотрудник = КадроваяИсторияСотрудников.Сотрудник
		|			И (КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаВозврата, ДЕНЬ) >= КадроваяИсторияСотрудников.Период)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятостьПозицийШтатногоРасписания КАК ЗанятостьПозицийШтатногоРасписания
		|		ПО ТаблицаДокумента.Ссылка = ЗанятостьПозицийШтатногоРасписания.Регистратор
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ТаблицаДокументаИсправления
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятостьПозицийШтатногоРасписанияИспр КАК ЗанятостьПозицийШтатногоРасписанияИспр
		|			ПО ТаблицаДокументаИсправления.Ссылка = ЗанятостьПозицийШтатногоРасписанияИспр.РегистраторИзмерение
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаДокументаИсправления.ИсправленныйДокумент
		|			И (ТаблицаДокументаИсправления.Проведен)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтпускПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
		|		ПО ТаблицаДокумента.ДокументОснование = ОтпускПоУходуЗаРебенком.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.Проведен
		|	И ОтпускПоУходуЗаРебенком.ОсвобождатьСтавку
		|	И ЗанятостьПозицийШтатногоРасписания.Регистратор ЕСТЬ NULL
		|	И ЗанятостьПозицийШтатногоРасписанияИспр.РегистраторИзмерение ЕСТЬ NULL
		|	И НЕ КадроваяИсторияСотрудников.Сотрудник ЕСТЬ NULL
		|	И НЕ ТаблицаДокумента.Ссылка В (&МассивОбновленных)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	РегистраторыКОбновлению.Регистратор КАК Регистратор
		|ИЗ
		|	ВТРегистраторыКОбновлению КАК РегистраторыКОбновлению";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПродолжитьОбработчик(ПараметрыОбновления);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Регистратор,
		|	ТаблицаДокумента.ДатаВозврата КАК ДатаНачала,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаОкончания,
		|	ТаблицаДокументаИсправления.Ссылка КАК РегистраторИзмерение,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник КАК ФизическоеЛицо
		|ИЗ
		|	ВТРегистраторыКОбновлению КАК РегистраторыКОбновлению
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ТаблицаДокумента
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ТаблицаДокументаИсправления
		|			ПО ТаблицаДокумента.Ссылка = ТаблицаДокументаИсправления.ИсправленныйДокумент
		|				И (ТаблицаДокументаИсправления.Проведен)
		|		ПО РегистраторыКОбновлению.Регистратор = ТаблицаДокумента.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала,
		|	Регистратор";
	
	МассивРегистраторов = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("ДатаНачала") Цикл
		
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			МассивОбновленных.Добавить(Выборка.Регистратор);
			Если ЗначениеЗаполнено(Выборка.РегистраторИзмерение) Тогда
				
				Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрСведений.ЗанятостьПозицийШтатногоРасписанияИспр", "РегистраторИзмерение", Выборка.РегистраторИзмерение) Тогда
					Продолжить;
				КонецЕсли;
				
			Иначе
				
				МассивРегистраторов.Добавить(Выборка.Регистратор);
				
				Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрСведений.ЗанятостьПозицийШтатногоРасписания.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			Сотрудники = КадровыйУчетРасширенный.МассивСотрудников(Выборка.ФизическоеЛицо, Выборка.Организация, Выборка.ДатаНачала);
			
			ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект();
			
			ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(
				ДокументОбъект.Движения,
				КадровыйУчетРасширенный.ТаблицаСотрудникиДатыСобытия(Сотрудники, Выборка.ДатаНачала),
				Выборка.Регистратор);
			
			СформироватьДвиженияВозвратаВременноОсвобожденныхПозиции(
				ДокументОбъект.Движения, Сотрудники, Выборка.ДатаНачала);
			
			ЗарплатаКадрыРасширенныйСобытия.УстановитьСдвигПериодаРегистраСПериодичностьюСекунда(
				ДокументОбъект.Движения.ЗанятостьПозицийШтатногоРасписания, Ложь, Истина);
			
			Если ЗначениеЗаполнено(Выборка.РегистраторИзмерение) Тогда
				
				НаборЗаписей = РегистрыСведений.ЗанятостьПозицийШтатногоРасписанияИспр.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.РегистраторИзмерение.Установить(Выборка.РегистраторИзмерение);
				
				Для Каждого Запись Из ДокументОбъект.Движения.ЗанятостьПозицийШтатногоРасписания Цикл
					
					НоваяЗапись = НаборЗаписей.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяЗапись, Запись);
					
					НоваяЗапись.ПериодИзмерение = Запись.Период;
					НоваяЗапись.РегистраторИзмерение = Выборка.РегистраторИзмерение;
					
				КонецЦикла;
				
			Иначе
				НаборЗаписей = ДокументОбъект.Движения.ЗанятостьПозицийШтатногоРасписания;
			КонецЕсли;
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЦикла;
	
	РегистрыСведений.ЗанятостьПозицийШтатногоРасписания.СформироватьДвиженияИнтервальногоРегистраПоМассивуРегистраторов(
		МассивРегистраторов, ПараметрыОбновления);
	
КонецПроцедуры

Процедура СформироватьДвиженияВозвратаВременноОсвобожденныхПозиции(Движения, Сотрудники, ДатаВозврата)
	
	СотрудникиПериоды = КадровыйУчетРасширенный.ТаблицаЗначенийСотрудникиПериоды(Сотрудники, ДатаВозврата);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыПостроения = КадровыйУчетРасширенный.ПараметрыПостроенияСрезовЗанятостиПозицийШтатногоРасписания(Движения);
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(СотрудникиПериоды, "Сотрудник");
	ОписаниеФильтра.СоответствиеИзмеренийРегистраИзмерениямФильтра.Вставить("Период","ДатаНачала");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"КадроваяИсторияСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Ложь,
		ОписаниеФильтра,
		ПараметрыПостроения);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадроваяИсторияСотрудников.Период КАК Период,
		|	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник,
		|	КадроваяИсторияСотрудников.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	КадроваяИсторияСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОснование,
		|	КадроваяИсторияСотрудников.ДолжностьПоШтатномуРасписанию КАК ПозицияШтатногоРасписания,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиПозицийШтатногоРасписания.Занята) КАК ВидЗанятостиПозиции,
		|	КадроваяИсторияСотрудников.КоличествоСтавок КАК КоличествоСтавок,
		|	КадроваяИсторияСотрудников.Сотрудник КАК ЗамещаемыйСотрудник
		|ИЗ
		|	ВТКадроваяИсторияСотрудниковСрезПоследних КАК КадроваяИсторияСотрудников";
	
	КадровыйУчетРасширенный.СформироватьДвиженияЗанятостьПозицийШтатногоРасписания(Движения, Запрос.Выполнить().Выгрузить())
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли