#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	РасчетЗарплатыРасширенныйВызовСервера.ДанныеДляРасчетаЗарплатыОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);	                                                                                 		
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта();
	ОписаниеСостава.ЗаполнятьФизическиеЛицаПоСотрудникам = Ложь;
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		,
		,
		"Сотрудник");
		
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		"ЗначенияПоказателей",
		,
		"Объект");
		
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		"ДанныеОВремениСводно",
		,
		"Сотрудник");
		
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		"ДанныеОВремениДетально",
		,
		"Сотрудник");
		
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		"ВыполненныеРаботы",
		,
		"Сотрудник");
		
	Возврат ОписаниеСостава;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

Функция КомандыПечатиФормы(Форма) Экспорт
	
	КомандыПечатиФормы = УправлениеПечатью.КомандыПечатиФормы(Форма.ИмяФормы);
	
	// Удалим печатные формы, которые не относятся к виду документа.
	МассивСтрокДляУдаления = Новый Массив;
	ДоступныеВнешниеПечатныеФорм = Справочники.ВидыДокументовВводДанныхДляРасчетаЗарплаты.ДоступныеВнешниеПечатныеФормы(Форма.Объект.ВидДокумента);
	Для Каждого КомандаПечати Из КомандыПечатиФормы Цикл
		Если КомандаПечати.МенеджерПечати <> "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДоступныеВнешниеПечатныеФорм.Найти(КомандаПечати.ДополнительныеПараметры.Ссылка) = Неопределено Тогда
			МассивСтрокДляУдаления.Добавить(КомандаПечати);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаДляУдаления Из МассивСтрокДляУдаления Цикл
		КомандыПечатиФормы.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	
	Возврат КомандыПечатиФормы;
	
КонецФункции

// Размещает команды печати на форме.
//
// Параметры:
//   Форма                            - ФормаКлиентскогоПриложения - форма, в которой необходимо разместить подменю Печать.
//   МестоРазмещенияКомандПоУмолчанию - ЭлементФормы - группа, в которую необходимо разместить подменю Печать,
//                                                     по умолчанию размещается в командную панель формы.
//   ОбъектыПечати                    - Массив - список объектов метаданных, для которых необходимо сформировать
//                                               объединенное подменю Печать.
Процедура ПриСозданииНаСервере(Форма, КомандыПечати, МестоРазмещенияКомандПоУмолчанию = Неопределено, ОбъектыПечати = Неопределено) Экспорт
	
	Если МестоРазмещенияКомандПоУмолчанию <> Неопределено Тогда
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МестоРазмещения) Тогда
				КомандаПечати.МестоРазмещения = МестоРазмещенияКомандПоУмолчанию.Имя;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если КомандыПечати.Колонки.Найти("ИмяКомандыНаФорме") = Неопределено Тогда
		КомандыПечати.Колонки.Добавить("ИмяКомандыНаФорме", Новый ОписаниеТипов("Строка"));
	КонецЕсли;
	
	ТаблицаКоманд = КомандыПечати.Скопировать(,"МестоРазмещения");
	ТаблицаКоманд.Свернуть("МестоРазмещения");
	МестаРазмещения = ТаблицаКоманд.ВыгрузитьКолонку("МестоРазмещения");
	
	Для Каждого МестоРазмещения Из МестаРазмещения Цикл
		НайденныеКоманды = КомандыПечати.НайтиСтроки(Новый Структура("МестоРазмещения,СкрытаФункциональнымиОпциями", МестоРазмещения, Ложь));
		
		ЭлементФормыДляРазмещения = Форма.Элементы.Найти(МестоРазмещения);
		Если ЭлементФормыДляРазмещения = Неопределено Тогда
			ЭлементФормыДляРазмещения = МестоРазмещенияКомандПоУмолчанию;
		КонецЕсли;
		
		Если НайденныеКоманды.Количество() > 0 Тогда
			ДобавитьКомандыПечатиДокумента(Форма, НайденныеКоманды, ЭлементФормыДляРазмещения);
		КонецЕсли;
	КонецЦикла;
	
	АдресКомандПечатиВоВременномХранилище = "АдресКомандПечатиВоВременномХранилище";
	КомандаФормы = Форма.Команды.Найти(АдресКомандПечатиВоВременномХранилище);
	Если КомандаФормы = Неопределено Тогда
		КомандаФормы = Форма.Команды.Добавить(АдресКомандПечатиВоВременномХранилище);
		КомандаФормы.Действие = ПоместитьВоВременноеХранилище(КомандыПечати, Форма.УникальныйИдентификатор);
	Иначе
		ОбщийСписокКомандПечатиФормы = ПолучитьИзВременногоХранилища(КомандаФормы.Действие);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			ЗаполнитьЗначенияСвойств(ОбщийСписокКомандПечатиФормы.Добавить(), КомандаПечати);
		КонецЦикла;
		КомандаФормы.Действие = ПоместитьВоВременноеХранилище(ОбщийСписокКомандПечатиФормы, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Создает подменю "Печать" на форме и добавляет в него команды печати.
// Если команда печати одна, то вместо подменю добавляется кнопка с названием печатной формы.
Процедура ДобавитьКомандыПечатиДокумента(Форма, КомандыПечати, Знач МестоРазмещенияКоманд = Неопределено)
	
	Если МестоРазмещенияКоманд = Неопределено Тогда
		МестоРазмещенияКоманд = Форма.КоманднаяПанель;
	КонецЕсли;
	
	ОднаКомандаПечати = КомандыПечати.Количество() = 1;
	Если МестоРазмещенияКоманд.Вид = ВидГруппыФормы.Подменю Тогда
		Если ОднаКомандаПечати Тогда
			МестоРазмещенияКоманд.Вид = ВидГруппыФормы.ГруппаКнопок;
		КонецЕсли;
	Иначе
		Если Не ОднаКомандаПечати Тогда
			ПодменюПечать = Форма.Элементы.Добавить(МестоРазмещенияКоманд.Имя + "ПодменюПечать", Тип("ГруппаФормы"), МестоРазмещенияКоманд);
			ПодменюПечать.Вид = ВидГруппыФормы.Подменю;
			ПодменюПечать.Заголовок = НСтр("ru = 'Печать'");
			ПодменюПечать.Картинка = БиблиотекаКартинок.Печать;
			
			МестоРазмещенияКоманд = ПодменюПечать;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ОписаниеКомандыПечати Из КомандыПечати Цикл
		НомерКоманды = ОписаниеКомандыПечати.Владелец().Индекс(ОписаниеКомандыПечати);
		ИмяКоманды = МестоРазмещенияКоманд.Имя + "КомандаПечати" + НомерКоманды;
		
		КомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
		КомандаФормы.Действие = "Подключаемый_ВыполнитьКомандуПечати";
		КомандаФормы.Заголовок = ОписаниеКомандыПечати.Представление;
		КомандаФормы.ИзменяетСохраняемыеДанные = Ложь;
		КомандаФормы.Отображение = ОтображениеКнопки.КартинкаИТекст;
		
		Если ЗначениеЗаполнено(ОписаниеКомандыПечати.Картинка) Тогда
			КомандаФормы.Картинка = ОписаниеКомандыПечати.Картинка;
		ИначеЕсли ОднаКомандаПечати Тогда
			КомандаФормы.Картинка = БиблиотекаКартинок.Печать;
		КонецЕсли;
		
		ОписаниеКомандыПечати.ИмяКомандыНаФорме = ИмяКоманды;
		
		НовыйЭлемент = Форма.Элементы.Добавить(МестоРазмещенияКоманд.Имя + ИмяКоманды, Тип("КнопкаФормы"), МестоРазмещенияКоманд);
		НовыйЭлемент.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		НовыйЭлемент.ИмяКоманды = ИмяКоманды;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

