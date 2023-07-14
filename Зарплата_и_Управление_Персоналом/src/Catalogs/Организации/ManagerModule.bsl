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

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Префикс");
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ссылка)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// ЗарплатаКадры

// Используется для получения ссылки на регистрацию в налоговом органе организации.
//
// Параметры:
//  Организация             - СправочникСсылка.Организации  - организация, для которой нужно получить регистрацию.
//  ДатаАктуальности        - Дата                          - дата, на которую необходимо получить регистрацию в НО.
// 
// Возвращаемое значение:
//  СправочникСсылка.РегистрацииВНалоговомОргане - ссылка на существующую регистрацию, либо ПустаяСсылка().
//
Функция РегистрацияВНалоговомОргане(Организация, Знач ДатаАктуальности = Неопределено) Экспорт
	
	Возврат ЗарплатаКадры.РегистрацияВНалоговомОрганеОрганизации(Организация, ДатаАктуальности);

КонецФункции

// Конец ЗарплатаКадры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Использование нескольких организаций.

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//     СправочникСсылка.Организации - ссылка на организацию.
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Организация = Справочники.Организации.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	Возврат Организация;

КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//     Число - количество организаций.
//
Функция КоличествоОрганизаций() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Количество = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный
	|	И НЕ Организации.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Количество;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетОтчитывающихсяПоВзносамОрганизаций") Тогда
		
		ТолькоСамостоятельныеОрганизации = Ложь;
		Параметры.Свойство("ТолькоСамостоятельныеОрганизации", ТолькоСамостоятельныеОрганизации);
		ГоловнаяОрганизация = Неопределено;
		Параметры.Отбор.Свойство("ГоловнаяОрганизация", ГоловнаяОрганизация);
	
		Если ТолькоСамостоятельныеОрганизации = Истина И ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
			СтандартнаяОбработка = Ложь;
			ДанныеВыбора = УчетСтраховыхВзносов.СамостоятельныеПодразделенияОрганизации(ГоловнаяОрганизация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при переходе на версию конфигурации 2.1.3.16.
//
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформацииОрганизаций() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ЮрАдресОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ФактАдресОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 2;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ТелефонОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 3;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Факс");
	ПараметрыВида.Вид = "ФаксОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 4;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "EmailОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 5;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ПочтовыйАдресОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 6;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Другое");
	ПараметрыВида.Вид = "ДругаяИнформацияОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 7;
	МодульУправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры

// Вызывается при переходе на версию БСП 2.2.1.12.
//
Процедура ЗаполнитьКонстантуИспользоватьНесколькоОрганизаций() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") =
			ПолучитьФункциональнуюОпцию("НеИспользоватьНесколькоОрганизаций") Тогда
		// Опции должны иметь противоположные значения.
		// Если это не так, то значит в ИБ раньше не было этих опций - инициализируем их значения.
		Константы.ИспользоватьНесколькоОрганизаций.Установить(КоличествоОрганизаций() > 1);
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиПравилРегистрации

Процедура ЗарегистрироватьИзмененияПриОбработке(ИмяПланаОбмена, ПРО, Объект, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Выгрузка) Экспорт
	
	Если Объект.ЕстьОбособленныеПодразделения Тогда
		СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоГоловнымОрганизациям(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Объект.Ссылка);
	Иначе
		СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоОрганизациям(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияПриОбработкеДоп(ИмяПланаОбмена, ПРО, Объект, Ссылка, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш) Экспорт
	
	ЕстьОбособленныеПодразделения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ЕстьОбособленныеПодразделения");
	Если ЕстьОбособленныеПодразделения Тогда
		СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоГоловнымОрганизациям(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Ссылка);
	Иначе
		СинхронизацияДанныхЗарплатаКадры.ОграничитьРегистрациюОбъектаОтборомПоОрганизациям(ИмяПланаОбмена, Отказ, ТекстЗапроса, ПараметрыЗапроса, ИспользоватьКэш, Объект, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияПослеОбработки(ИмяПланаОбмена, ПРО, Объект, Отказ, Получатели, Выгрузка) Экспорт
	
	Если ЗначениеЗаполнено(Объект.ГоловнаяОрганизация) И ОбщегоНазначения.СсылкаСуществует(Объект.ГоловнаяОрганизация)
		И Объект.Ссылка <> Объект.ГоловнаяОрганизация Тогда
			
		ПланыОбмена.ЗарегистрироватьИзменения(Получатели, Объект.ГоловнаяОрганизация);
		СинхронизацияДанныхЗарплатаКадры.ЗарегистрироватьСвязанныеРегистрыСведенийОбъекта(ИмяПланаОбмена, Отказ,
			Объект.ГоловнаяОрганизация, Выгрузка, Получатели);
			
	КонецЕсли;
	
КонецПроцедуры

Функция ПринадлежностиОбъекта() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Ссылка");
КонецФункции

#КонецОбласти

Процедура ПриПолученииДанныхФайла(Объект) Экспорт
	
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.Организации") Тогда
		Если Объект.ЭтоНовый() Тогда
			Объект.УчетнаяЗаписьОбмена = Справочники.УчетныеЗаписиДокументооборота.ПустаяСсылка();
		Иначе
			Объект.УчетнаяЗаписьОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "УчетнаяЗаписьОбмена");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШаблоныСообщений

Процедура ПриПодготовкеШаблонаСообщения(РеквизитыОбъектаНазначения, Вложения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

Процедура ПриФормированииСообщения(Сообщение, Предмет, ПараметрыШаблона) Экспорт
	
КонецПроцедуры

Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

Процедура ПриЗаполненииПочтыПолучателейВСообщении(Получатели, Предмет) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
