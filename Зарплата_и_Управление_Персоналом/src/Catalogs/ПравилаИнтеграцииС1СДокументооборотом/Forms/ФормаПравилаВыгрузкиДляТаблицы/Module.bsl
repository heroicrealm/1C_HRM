#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИмяРеквизитаОбъектаДО", ИмяРеквизитаОбъектаДО);
	Параметры.Свойство("ПредставлениеРеквизитаОбъектаДО", ПредставлениеРеквизитаОбъектаДО);
	Параметры.Свойство("Вариант", Вариант);
	Параметры.Свойство("ИмяРеквизитаОбъектаИС", ИмяРеквизитаОбъектаИС);
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("ТипОбъектаДО", ТипОбъектаДО);
	Параметры.Свойство("ТипОбъектаИС", ТипОбъектаИС);
	Параметры.Свойство("Обновлять", Обновлять);
	Параметры.Свойство("ВидДокументаДО", ВидДокументаДО);
	
	РеквизитОбъекта = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта");
	ВыражениеНаВстроенномЯзыке =
		ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке");
	РеквизитТаблицы = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.РеквизитТаблицы");
	НеЗаполнять = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ПустаяСсылка");
	
	Если Параметры.ЗаполненВШаблоне И Параметры.ШаблонЗапрещаетИзменение Тогда
		ШаблонЗапрещаетИзменение = Истина;
	Иначе
		ШаблонЗапрещаетИзменение = Ложь;
	КонецЕсли;
	
	Элементы.Обновлять.Видимость = ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяРеквизитаОбъектаИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьРеквизитОбъектаПотребителя();
	
КонецПроцедуры

&НаКлиенте
Процедура ВычисляемоеВыражениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьВычисляемоеВыражение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Вариант", Вариант);
	Результат.Вставить("ИмяРеквизитаОбъектаИС");
	Результат.Вставить("Пояснение");
	Результат.Вставить("ВычисляемоеВыражение");
	Результат.Вставить("Картинка");
	Результат.Вставить("Обновлять", Обновлять);
	
	Если Вариант = РеквизитОбъекта Тогда
		
		Результат.ИмяРеквизитаОбъектаИС = ИмяРеквизитаОбъектаИС;
		Результат.Картинка = 1;
		
	ИначеЕсли Вариант = РеквизитТаблицы Тогда
		
		Результат.Пояснение = НСтр("ru = 'Заполняется по правилам для отдельных реквизитов таблицы'");
		Результат.Картинка = 1;
		
	ИначеЕсли Вариант = ВыражениеНаВстроенномЯзыке Тогда
		
		Результат.ВычисляемоеВыражение = ВычисляемоеВыражение;
		Результат.Картинка = 3;
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаПотребителя()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта", ТипОбъектаИС);
	ПараметрыФормы.Вставить("ИмяРеквизитаОбъектаИС", ИмяРеквизитаОбъектаИС);
	ПараметрыФормы.Вставить("ПредставлениеРеквизитаОбъектаДО", ПредставлениеРеквизитаОбъектаДО);
	ПараметрыФормы.Вставить("ЭтоТаблица", Истина);
	
	ИмяФормыВыбора = "Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ВыборРеквизитаПотребителя";
	Оповещение = Новый ОписаниеОповещения("ВыбратьРеквизитОбъектаПотребителяЗавершение", ЭтотОбъект);
	
	ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаПотребителяЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда 
		Результат.Свойство("Имя", ИмяРеквизитаОбъектаИС);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражение();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВычисляемоеВыражение", ВычисляемоеВыражение);
	ПараметрыФормы.Вставить("ТипВыражения", "ПравилоВыгрузки");
	ПараметрыФормы.Вставить("ТипОбъектаДО", ТипОбъектаДО);
	ПараметрыФормы.Вставить("ТипОбъектаИС", ТипОбъектаИС);
	ПараметрыФормы.Вставить("ИмяРеквизитаОбъектаДО", ИмяРеквизитаОбъектаДО);
	ПараметрыФормы.Вставить("ЭтоТаблица", Истина);
	ПараметрыФормы.Вставить("ВидДокументаДО", ВидДокументаДО);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВычисляемоеВыражениеЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ВыражениеНаВстроенномЯзыке",
		ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражениеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда 
		ВычисляемоеВыражение = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ИмяРеквизитаОбъектаИС.Доступность = (Вариант = РеквизитОбъекта);
	Элементы.ИмяРеквизитаОбъектаИС.АвтоОтметкаНезаполненного = (Вариант = РеквизитОбъекта);
	Элементы.ИмяРеквизитаОбъектаИС.ОтметкаНезаполненного = (Вариант = РеквизитОбъекта) И Не ЗначениеЗаполнено(ИмяРеквизитаОбъектаИС);
	
	Элементы.ВычисляемоеВыражение.Доступность = (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.АвтоОтметкаНезаполненного = (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.ОтметкаНезаполненного = (Вариант = ВыражениеНаВстроенномЯзыке) И Не ЗначениеЗаполнено(ВычисляемоеВыражение);
	
	Элементы.Обновлять.Доступность = Не ШаблонЗапрещаетИзменение;
	Обновлять = Обновлять И Не ШаблонЗапрещаетИзменение;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Вариант = РеквизитОбъекта Тогда 
		ПроверяемыеРеквизиты.Добавить("ИмяРеквизитаОбъектаИС");
		
	ИначеЕсли Вариант = ВыражениеНаВстроенномЯзыке Тогда 
		ПроверяемыеРеквизиты.Добавить("ВычисляемоеВыражение");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти