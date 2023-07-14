#Область ОписаниеПеременных

&НаКлиенте
Перем БылоНаименование, БылИдентификатор;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			// При копировании очищаем свойства, которые не могут быть продублированы.
			Объект.Идентификатор = СформироватьИдентификаторПоказателя(Объект.Идентификатор, Объект.Ссылка);
			Объект.ОтображатьВДокументахНачисления = Истина;
			Объект.ЗначениеРассчитываетсяАвтоматически = Ложь;
		КонецЕсли;
		
		ДополнитьФорму();
		
	КонецЕсли;
	
	Если Объект.Предопределенный Тогда
		УстановитьДоступностьПолейСлужебногоПоказателя();
	Иначе
		УстановитьРеквизитыПолейИспользованияЗначений(ЭтаФорма);
	КонецЕсли;
	
	УстановитьЗначениеРеквизитаЯвляетсяТарифнойСтавкой(ЭтаФорма);
	
	УстановитьРеквизитыПолейПоТипуПоказателя(ЭтаФорма);
	ЗаполнитьИнформациюОбИспользованииЗначений(ЭтаФорма);
	УстановитьДоступныеСпособыВвода(ЭтаФорма);	
	УстановитьВидимостьТочностиРассчитываемогоАвтоматическиПоказателя();
	
	Элементы.ЗначениеПоказателяСтраницы.ТекущаяСтраница = ?(Объект.ЗначениеРассчитываетсяАвтоматически, 
		Элементы.ЗначениеРассчитываетсяАвтоматическиСтраница, 
		Элементы.Дополнительно);

	Если ЭтоПоказательЗависимыйПоШкале(Объект) Тогда 
		ПодготовитьШкалуНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДополнитьФорму();

	ДанныеВРеквизиты();
	
	ИдентификаторПоНаименованию = ИдентификаторПоПредставлению(ТекущийОбъект.Наименование);
	ПредопределенныеПоказатели = ЗарплатаКадрыРасширенныйПовтИсп.ИменаПредопределенныхПоказателей();
	Если ПредопределенныеПоказатели.Найти(ИдентификаторПоНаименованию) <> Неопределено Тогда 
		ИдентификаторПолученПоПредставлению = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БылоНаименование = Объект.Наименование;
	БылИдентификатор = Объект.Идентификатор;
	
	ФорматнаяСтрока = ФорматнаяСтрокаЗначения(Объект.Точность);
	УстановитьФорматРедактированияЗначенияПоказателяШкалыОценки(ФорматнаяСтрока);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	РеквизитыВДанные(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЕстьРазделители = Ложь;
	Для Позиция = 1 По СтрДлина(Объект.Идентификатор) Цикл
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Объект.Идентификатор, Позиция)) Тогда
			ЕстьРазделители = Истина;
			Объект.Идентификатор = СтрЗаменить(Объект.Идентификатор, Сред(Объект.Идентификатор, Позиция, 1), "?");
		КонецЕсли;
	КонецЦикла;
	
	// Проверка заполнения шкалы оценки.
	Если Не ШкалаОценкиЗаполненаПравильно() Тогда 
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ОбработатьОтветОКорректировкеШкалыОценки", ЭтаФорма);
		ТекстВопроса = НСтр("ru = 'Обнаружены неверно заполненные интервалы шкалы. Скорректировать значения интервалов автоматически?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Медицина.ТарификационнаяОтчетностьУчрежденийФМБА") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ТарификационнаяОтчетностьУчрежденийФМБАКлиент");
		Модуль.ПоказательРасчетаЗарплатыПередЗаписью(ЭтотОбъект, Отказ);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДанныеВРеквизиты();
	ОбновитьПовторноИспользуемыеЗначения();
	СформироватьПредставлениеИнтервалаШкалыОценки(ШкалаОценки);
	УстановитьЗначениеРеквизитаЯвляетсяТарифнойСтавкой(ЭтаФорма);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Медицина.ТарификационнаяОтчетностьУчрежденийФМБА") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ТарификационнаяОтчетностьУчрежденийФМБА");
		Модуль.ПоказательРасчетаЗарплатыПослеЗаписи(ЭтотОбъект);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПоказателиРасчетаЗарплаты", Объект.Ссылка, ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ЯвляетсяТарифнойСтавкой И Не ЗначениеЗаполнено(Объект.ВидТарифнойСтавки) Тогда 
		ТекстСообщения = НСтр("ru = 'Поле ""Вид тарифной ставки"" не заполнено'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "ВидТарифнойСтавки", "Объект", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПоказателяПриИзменении(Элемент)
	
	УстановитьРеквизитыПолейПоТипуПоказателя(ЭтотОбъект);
	УстановитьРеквизитыПолейИспользованияЗначений(ЭтотОбъект);
	УстановитьЗначенияРеквизитовПоказателяТарификации(ЭтотОбъект);
	
	// Для показателей, зависящих по шкале от стажа или другого показателя.
	ЗаполнитьСвойстваПоказателейЗависимыхПоШкале();
	
КонецПроцедуры

&НаКлиенте
Процедура ТочностьПриИзменении(Элемент)
	ФорматнаяСтрока = ФорматнаяСтрокаЗначения(Объект.Точность);
	УстановитьФорматРедактированияЗначенияПоказателяШкалыОценки(ФорматнаяСтрока);
	Для каждого СтрокаШкалы Из ШкалаОценки Цикл
	    СтрокаШкалы.ЗначениеПоказателя = Формат(СтрокаШкалы.ЗначениеПоказателя, ФорматнаяСтрока);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ПрежнийИдентификатор = ИдентификаторПоПредставлению(БылоНаименование);
	
	Если Не ЗначениеЗаполнено(Объект.Идентификатор) 
		Или ПрежнийИдентификатор = Объект.Идентификатор
		Или ИдентификаторПолученПоПредставлению Тогда
		Объект.Идентификатор = ИдентификаторПоПредставлению(Объект.Наименование);
		ПредопределенныеПоказатели = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ИменаПредопределенныхПоказателей();
		Если Объект.ИмяПредопределенныхДанных <> Объект.Идентификатор И ПредопределенныеПоказатели.Найти(Объект.Идентификатор) <> Неопределено Тогда 
			Объект.Идентификатор = СформироватьИдентификаторПоказателя(Объект.Идентификатор, Объект.Ссылка);
			ИдентификаторПолученПоПредставлению = Истина;
		КонецЕсли;
		БылИдентификатор = Объект.Идентификатор;
	КонецЕсли;
	
	БылоНаименование = Объект.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	
	ПрежнееНаименование = ПредставлениеПоИдентификатору(БылИдентификатор);
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) 
		Или ПрежнееНаименование = Объект.Наименование 
		Или ИдентификаторПолученПоПредставлению Тогда
		Объект.Наименование = ПредставлениеПоИдентификатору(Объект.Идентификатор);
		БылоНаименование = Объект.Наименование;
	КонецЕсли;
	
	БылИдентификатор = Объект.Идентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	ЗаполнитьИнформациюОбИспользованииЗначений(ЭтаФорма);
	УстановитьДоступныеСпособыВвода(ЭтаФорма);
	УстановитьДоступностьФлажкаДопускаетсяНулевоеЗначение(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СпособПримененияПриИзменении(Элемент)
	ЗаполнитьИнформациюОбИспользованииЗначений(ЭтаФорма);
	УстановитьРеквизитыПолейИспользованияЗначений(ЭтаФорма);
	УстановитьДоступностьФлажкаДопускаетсяНулевоеЗначение(ЭтаФорма);
	УстановитьЗначенияРеквизитовПоказателяТарификации(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СпособВводаПриИзменении(Элемент)
	ЗаполнитьИнформациюОбИспользованииЗначений(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЯвляетсяТарифнойСтавкойПриИзменении(Элемент)
	
	УстановитьЗначенияРеквизитовТарифнойСтавки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура БазовыйПоказательПриИзменении(Элемент)
	
	ПодготовитьШкалуНаСервере();
	
КонецПроцедуры

#Область Подключаемый_ТарификационнаяОтчетностьУчрежденийФМБА

&НаКлиенте
Процедура Подключаемый_ЯвляетсяПоказателемТарификацииПриИзменении(Команда)
	
	УстановитьЗначенияРеквизитовПоказателяТарификации(ЭтотОбъект);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШкалаОценки

&НаКлиенте
Процедура ШкалаОценкиЗначениеОтПриИзменении(Элемент)
	
	СформироватьПредставлениеИнтервалаШкалыОценки(ШкалаОценки);
	
КонецПроцедуры

&НаКлиенте
Процедура ШкалаОценкиЗначениеДоПриИзменении(Элемент)
	
	СформироватьПредставлениеИнтервалаШкалыОценки(ШкалаОценки);
	
КонецПроцедуры

&НаКлиенте
Процедура ШкалаОценкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	УпорядочитьСтрокиШкалыОценки(ТекущийЭлемент.ТекущиеДанные);
	СкорректироватьСоседниеСтрокиШкалыОценки(ТекущийЭлемент.ТекущиеДанные);
	ДобавитьСтрокиШкалыОценки(ШкалаОценки);
	СкорректироватьИнтервалыШкалыОценки();
	
КонецПроцедуры

&НаКлиенте
Процедура ШкалаОценкиПослеУдаления(Элемент)
	
	ДобавитьСтрокиШкалыОценки(ШкалаОценки);
	СкорректироватьИнтервалыШкалыОценки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьДоступностьПолейСлужебногоПоказателя()
	
	// Если показатель служебный, 
	// то редактировать можно только отдельные поля.
	ДоступныеПоля = Новый Массив;
	ДоступныеПоля.Добавить(Элементы.Наименование);
	ДоступныеПоля.Добавить(Элементы.КраткоеНаименование);
	ДоступныеПоля.Добавить(Элементы.Точность);
	ДоступныеПоля.Добавить(Элементы.ТочностьРассчитываемогоАвтоматическиПоказателя);
	ДоступныеПоля.Добавить(Элементы.ДопускаетсяНулевоеЗначение);
	ДоступныеПоля.Добавить(Элементы.ВидСтажа);
	ДоступныеПоля.Добавить(Элементы.БазовыйПараметр);
	ДоступныеПоля.Добавить(Элементы.ШкалаОценкиЗначениеОт);
	ДоступныеПоля.Добавить(Элементы.ШкалаОценкиЗначениеДо);
	ДоступныеПоля.Добавить(Элементы.ШкалаОценкиЗначениеПоказателя);
	
	Для Каждого Элемент Из Элементы Цикл
		Если ДоступныеПоля.Найти(Элемент) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") 
			И Элемент.Вид <> ВидПоляФормы.ПолеНадписи Тогда
			Элемент.Доступность = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьТочностиРассчитываемогоАвтоматическиПоказателя()
	
	Видимость = Объект.Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.СтоимостьЧаса")
		Или Объект.Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.СтоимостьДня")
		Или Объект.Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.СтоимостьДняЧаса");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"ТочностьРассчитываемогоАвтоматическиПоказателя", "Видимость", Видимость);	
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьФлажкаДопускаетсяНулевоеЗначение(Форма)
	
	ЭтоПоказательДляСотрудника = Форма.Объект.НазначениеПоказателя = ПредопределенноеЗначение("Перечисление.НазначенияПоказателейРасчетаЗарплаты.ДляСотрудника");
	ЭтоПостоянныйПоказатель = Форма.Объект.СпособПримененияЗначений = ПредопределенноеЗначение("Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ДопускаетсяНулевоеЗначение", "Доступность", ЭтоПоказательДляСотрудника И ЭтоПостоянныйПоказатель);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРеквизитыПолейПоТипуПоказателя(Форма)
	
	Если Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа") Тогда
		Форма.Элементы.ИспользованиеПоказателяСтраницы.ТекущаяСтраница = Форма.Элементы.ИспользованиеПоказателейСтажСтраница;
		Форма.Элементы.БазовыйПараметрСтраницы.ТекущаяСтраница = Форма.Элементы.БазовыйПараметрСтажСтраница;
	ИначеЕсли Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтДругогоПоказателя") Тогда 
		Форма.Элементы.ИспользованиеПоказателяСтраницы.ТекущаяСтраница = Форма.Элементы.ИспользованиеПоказателейСтажСтраница;
		Форма.Элементы.БазовыйПараметрСтраницы.ТекущаяСтраница = Форма.Элементы.БазовыйПараметрПоказательСтраница;
	Иначе
		Форма.Элементы.ИспользованиеПоказателяСтраницы.ТекущаяСтраница = Форма.Элементы.ИспользованиеЗначенияСтраница;
		Форма.Элементы.Назначение.Доступность = Истина;
	КонецЕсли;
	
	Если Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.Денежный") 
		Или Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.Числовой") 
		Или Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтДругогоПоказателя")
		Или Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа") Тогда
		Форма.Элементы.Точность.Доступность = Истина;
	Иначе
		Форма.Элементы.Точность.Доступность = Ложь;
		Форма.Объект.Точность = 0;
	КонецЕсли;
	
	УстановитьЗначенияРеквизитовТарифнойСтавки(Форма);	

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРеквизитыПолейИспользованияЗначений(Форма)
	
	ДоступностьСпособаПрименения = Не Форма.Объект.ЗначениеРассчитываетсяАвтоматически;
	
	Форма.Элементы.СпособПрименения.Доступность = ДоступностьСпособаПрименения;
	ДоступностьСпособаВвода = ДоступностьСпособаПрименения
									И Форма.Объект.СпособПримененияЗначений = ПредопределенноеЗначение("Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Разовое");
	Форма.Элементы.СпособВводаДляСотрудника.Доступность = ДоступностьСпособаВвода;
	Форма.Элементы.СпособВводаСпособВводаДляОрганизацииПодразделения.Доступность = ДоступностьСпособаВвода;
									
	Если Форма.Объект.СпособПримененияЗначений = ПредопределенноеЗначение("Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное") Тогда
		Форма.Объект.СпособВводаЗначений = ПредопределенноеЗначение("Перечисление.СпособыВводаЗначенийПоказателейРасчетаЗарплаты.ВводитсяЕдиновременно");
	КонецЕсли;
									
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьИнформациюОбИспользованииЗначений(Форма)
	
	Перем ТекстИнфо;
	
	Если Форма.Объект.ЗначениеРассчитываетсяАвтоматически Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.Объект.СпособПримененияЗначений = ПредопределенноеЗначение("Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное") Тогда
		Если Форма.Объект.НазначениеПоказателя = ПредопределенноеЗначение("Перечисление.НазначенияПоказателейРасчетаЗарплаты.ДляСотрудника") Тогда
			ТекстИнфо = НСтр("ru = 'Вводится и изменяется в кадровых документах.'");
		ИначеЕсли Форма.Объект.НазначениеПоказателя = ПредопределенноеЗначение("Перечисление.НазначенияПоказателейРасчетаЗарплаты.ДляПодразделения") 
			Или Форма.Объект.НазначениеПоказателя = ПредопределенноеЗначение("Перечисление.НазначенияПоказателейРасчетаЗарплаты.ДляОрганизации") Тогда
			ТекстИнфо = НСтр("ru = 'Изменяется периодически при изменении обстоятельств.'");
		КонецЕсли;
	ИначеЕсли Форма.Объект.СпособПримененияЗначений = ПредопределенноеЗначение("Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Разовое") Тогда
		Если Форма.Объект.СпособВводаЗначений = ПредопределенноеЗначение("Перечисление.СпособыВводаЗначенийПоказателейРасчетаЗарплаты.ВводитсяЕдиновременно") Тогда
			ТекстИнфо = НСтр("ru = 'Вводится ежемесячно, при расчете используется введенное значение на месяц.'");
		ИначеЕсли Форма.Объект.СпособВводаЗначений = ПредопределенноеЗначение("Перечисление.СпособыВводаЗначенийПоказателейРасчетаЗарплаты.НакапливаетсяПоОтдельнымЗначениям") Тогда
			ТекстИнфо = НСтр("ru = 'Вводится ежемесячно, при расчете используется сумма всех значений за месяц.'");
		ИначеЕсли Форма.Объект.СпособВводаЗначений = ПредопределенноеЗначение("Перечисление.СпособыВводаЗначенийПоказателейРасчетаЗарплаты.ВводитсяПриРасчете") Тогда
			ТекстИнфо = НСтр("ru = 'Вводится непосредственно в расчетном документе (например, Премия), не распространяется на расчеты в других документах.'");
		КонецЕсли;
	КонецЕсли;
	
	Форма.ТекстИнфонадписиИспользованиеЗначений = ТекстИнфо;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступныеСпособыВвода(Форма)
	
	Если Форма.Объект.НазначениеПоказателя = ПредопределенноеЗначение("Перечисление.НазначенияПоказателейРасчетаЗарплаты.ДляСотрудника") Тогда
		Форма.Элементы.СпособВводаСтраницы.ТекущаяСтраница = Форма.Элементы.СпособВводаДляСотрудникаСтраница;
	Иначе	
		Форма.Элементы.СпособВводаСтраницы.ТекущаяСтраница = Форма.Элементы.СпособВводаДляОрганизацииПодразделенияСтраница;
		Если Форма.Объект.СпособВводаЗначений = ПредопределенноеЗначение("Перечисление.СпособыВводаЗначенийПоказателейРасчетаЗарплаты.ВводитсяПриРасчете") Тогда
			Форма.Объект.СпособВводаЗначений = ПредопределенноеЗначение("Перечисление.СпособыВводаЗначенийПоказателейРасчетаЗарплаты.ВводитсяЕдиновременно");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИдентификаторПоПредставлению(Знач Представление)
	
	Идентификатор = "";
	БылРазделитель = Ложь;
	Для НомСимвола = 1 По СтрДлина(Представление) Цикл
		Символ = Сред(Представление, НомСимвола, 1);
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ) 
			И ПустаяСтрока(Идентификатор) Тогда
			// цифры в начале пропускаем
			Продолжить;
		КонецЕсли;
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Символ)) Тогда
			БылРазделитель = Истина;
		Иначе
			Если БылРазделитель Тогда
				БылРазделитель = Ложь;
				Символ = ВРег(Символ);
			КонецЕсли;
			Идентификатор = Идентификатор + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Идентификатор;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеПоИдентификатору(Знач Идентификатор)
	
	Представление = "";
	БылВРег = Ложь;
	Для НомСимвола = 1 По СтрДлина(Идентификатор) Цикл
		Символ = Сред(Идентификатор, НомСимвола, 1);
		ЭтоВРег = Символ = ВРег(Символ);
		Если Не БылВРег И ЭтоВРег И Не НомСимвола = 1 Тогда
			Символ = " " + Символ;
		КонецЕсли;
		БылВРег = ЭтоВРег;
		Представление = Представление + Символ;
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьИдентификаторПоказателя(Идентификатор, Ссылка)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("КоличествоСимволов", СтрДлина(Идентификатор));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ПоказателиРасчетаЗарплаты.Идентификатор
	               |ИЗ
	               |	Справочник.ПоказателиРасчетаЗарплаты КАК ПоказателиРасчетаЗарплаты
	               |ГДЕ
	               |	ПОДСТРОКА(ПоказателиРасчетаЗарплаты.Идентификатор, 1, &КоличествоСимволов) = &Идентификатор
	               |	И ПоказателиРасчетаЗарплаты.Ссылка <> &Ссылка";
				   
	ТекущиеИдентификаторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Идентификатор");			   
	
	Сч = 1;
	Пока Истина Цикл 
		НовыйИдентификатор = Идентификатор + Сч;
		Если ТекущиеИдентификаторы.Найти(НовыйИдентификатор) = Неопределено Тогда 
			Возврат НовыйИдентификатор;
		КонецЕсли;
		Сч = Сч + 1;
	КонецЦикла;
	
КонецФункции
			   
&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьПредставлениеИнтервалаШкалыОценки(ТаблицаИнтервалов)
	
	Для Каждого ТекСтрока Из ТаблицаИнтервалов Цикл 
		
		Если ТекСтрока.ЗначениеОт = 0 И ТекСтрока.ЗначениеДо = 0 Тогда 
			ПредставлениеОт = НСтр("ru = 'от'");
			ПредставлениеДо = НСтр("ru = 'до'");
		ИначеЕсли ТекСтрока.ЗначениеОт = 0 И ТекСтрока.ЗначениеДо <> 0 Тогда
			ПредставлениеОт = "";
			ПредставлениеДо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'до %1'"), ТекСтрока.ЗначениеДо);
		ИначеЕсли ТекСтрока.ЗначениеОт <> 0 И ТекСтрока.ЗначениеДо = 0 Тогда
			ПредставлениеОт = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'свыше %1'"), ТекСтрока.ЗначениеОт);
			ПредставлениеДо = "";
		Иначе
			ПредставлениеОт = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'от %1'"), ТекСтрока.ЗначениеОт);
			ПредставлениеДо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'до %1'"), ТекСтрока.ЗначениеДо);
		КонецЕсли;
		
		ТекСтрока.ПредставлениеОт = ПредставлениеОт;	
		ТекСтрока.ПредставлениеДо = ПредставлениеДо;	
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УпорядочитьСтрокиШкалыОценки(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущаяПозиция = ШкалаОценки.Индекс(ТекущиеДанные);
	НоваяПозиция = 0;
	
	Для Каждого ТекСтрока Из ШкалаОценки Цикл 
		Если НоваяПозиция <> ТекущаяПозиция И ТекСтрока.ЗначениеОт >= ТекущиеДанные.ЗначениеОт Тогда 
			Прервать;
		КонецЕсли;
		НоваяПозиция = НоваяПозиция + 1;
	КонецЦикла;
	
	Сдвиг = ?(НоваяПозиция < ТекущаяПозиция, НоваяПозиция - ТекущаяПозиция, НоваяПозиция - ТекущаяПозиция - 1);
	ШкалаОценки.Сдвинуть(ТекущаяПозиция, Сдвиг);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьСтрокиШкалыОценки(ШкалаОценки)

	КоличествоСтрок = ШкалаОценки.Количество();
	Если КоличествоСтрок = 0 Тогда 
		ШкалаОценки.Добавить();
	ИначеЕсли ШкалаОценки[КоличествоСтрок-1].ЗначениеДо <> 0 
		И ШкалаОценки[КоличествоСтрок-1].ЗначениеДо > ШкалаОценки[КоличествоСтрок-1].ЗначениеОт Тогда  
		НоваяСтрока = ШкалаОценки.Добавить();
		НоваяСтрока.ЗначениеОт = ШкалаОценки[КоличествоСтрок-1].ЗначениеДо;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьСоседниеСтрокиШкалыОценки(ТекущиеДанные);

	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЗначениеДо <= ТекущиеДанные.ЗначениеОт Тогда
		ТекущиеДанные.ЗначениеДо = 0;
		Возврат;
	КонецЕсли;	
	
	КоличествоСтрок = ШкалаОценки.Количество();
	ИндексСтроки = ШкалаОценки.Индекс(ТекущиеДанные);
	
	Если ИндексСтроки = (КоличествоСтрок - 1) Тогда 
		Возврат;
	КонецЕсли;
	
	СледующаяСтрока = ШкалаОценки[ИндексСтроки+1];
	СледующаяСтрока.ЗначениеОт = ТекущиеДанные.ЗначениеДо;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветОКорректировкеШкалыОценки(Результат, Параметры) Экспорт

	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	СкорректироватьИнтервалыШкалыОценки();
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьИнтервалыШкалыОценки() 
	
	НижняяГраница = Неопределено;
	КоличествоСтрок = ШкалаОценки.Количество();
	
	Для Сч = 1 По КоличествоСтрок Цикл 
		
		ИндексСтроки = КоличествоСтрок - Сч;
		ТекСтрока = ШкалаОценки[ИндексСтроки];
		
		Если НижняяГраница <> Неопределено И НижняяГраница <> ТекСтрока.ЗначениеДо Тогда 
			ТекСтрока.ЗначениеДо = НижняяГраница;
		КонецЕсли;
		
		Если НижняяГраница = Неопределено И  ТекСтрока.ЗначениеОт = ТекСтрока.ЗначениеДо Тогда 
			ТекСтрока.ЗначениеДо = 0;
		КонецЕсли;
		
		Если ТекСтрока.ЗначениеОт > ТекСтрока.ЗначениеДо И ТекСтрока.ЗначениеДо <> 0 
			Или ТекСтрока.ЗначениеОт = ТекСтрока.ЗначениеДо И ТекСтрока.ЗначениеОт <> 0 Тогда
			ШкалаОценки.Удалить(ТекСтрока);
			Продолжить;
		КонецЕсли;
		
		НижняяГраница = ТекСтрока.ЗначениеОт;
		
	КонецЦикла;
	
	// В первой строке может быть нулевое значение До, только если это единственная строка.
	Пока ШкалаОценки.Количество() > 1 Цикл 
		Если ШкалаОценки[0].ЗначениеДо <> 0 Тогда 
			Прервать;
		КонецЕсли;
		ШкалаОценки.Удалить(0);
	КонецЦикла;
	
	СформироватьПредставлениеИнтервалаШкалыОценки(ШкалаОценки);
	
КонецПроцедуры

&НаКлиенте
Функция ШкалаОценкиЗаполненаПравильно()
	
	Отказ = Ложь;
	
	Если Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа")
		Или Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтДругогоПоказателя") Тогда 
		
		НижняяГраница = Неопределено;
		КоличествоСтрок = ШкалаОценки.Количество();
		
		Если КоличествоСтрок > 1 И ШкалаОценки[0].ЗначениеДо = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Значение ""До"" в строке 1 равно 0'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "ШкалаОценки[0].ЗначениеДо", , Отказ);
		КонецЕсли;
		
		Для Сч = 1 По КоличествоСтрок Цикл 
			
			ИндексСтроки = КоличествоСтрок - Сч;
			ТекСтрока = ШкалаОценки[ИндексСтроки];
			
			Если ТекСтрока.ЗначениеДо <= ТекСтрока.ЗначениеОт И ТекСтрока.ЗначениеДо <> 0 Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В строке %1 значение ""До"" меньше или равно значению ""От""'"), ИндексСтроки + 1);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "ШкалаОценки[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ЗначениеДо", , Отказ);
			КонецЕсли;
			
			Если НижняяГраница <> Неопределено И НижняяГраница <> ТекСтрока.ЗначениеДо Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Значение ""До"" строки %1 не равно значению ""От"" строки %2'"), ИндексСтроки + 1, ИндексСтроки + 2);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, "ШкалаОценки[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ЗначениеДо", , Отказ);
			КонецЕсли;
			
			НижняяГраница = ТекСтрока.ЗначениеОт;
			
		КонецЦикла;

	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Процедура ДанныеВРеквизиты()
	
	ШкалаОценки.Очистить();
	
	Если Объект.ТипПоказателя = Перечисления.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа
		Или Объект.ТипПоказателя = Перечисления.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтДругогоПоказателя Тогда 
		
		ЗначениеДоПредыдущее = 0;
		
		Для Каждого ТекСтрока Из Объект.ШкалаОценкиСтажа Цикл 
			
			НоваяСтрока = ШкалаОценки.Добавить();
			НоваяСтрока.ЗначениеОт = ЗначениеДоПредыдущее;
			НоваяСтрока.ЗначениеДо = ТекСтрока.ВерхняяГраницаИнтервалаСтажа;
			НоваяСтрока.ЗначениеПоказателя = ТекСтрока.ЗначениеПоказателя;
			
			ЗначениеДоПредыдущее = НоваяСтрока.ЗначениеДо;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Объект.ШкалаОценкиСтажа.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура РеквизитыВДанные(ТекущийОбъект)
	
	ТекущийОбъект.ШкалаОценкиСтажа.Очистить();
	
	Если ТекущийОбъект.ТипПоказателя = Перечисления.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа
		Или ТекущийОбъект.ТипПоказателя = Перечисления.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтДругогоПоказателя Тогда
		
		ПерваяСтрока = Истина;
		Для Каждого ТекСтрока Из ШкалаОценки Цикл
			
			Если ПерваяСтрока Тогда 
				ПерваяСтрока = Ложь;
				Если ТекСтрока.ЗначениеОт <> 0 Тогда 
					НоваяСтрока = ТекущийОбъект.ШкалаОценкиСтажа.Добавить();
					НоваяСтрока.ВерхняяГраницаИнтервалаСтажа = ТекСтрока.ЗначениеОт;
					НоваяСтрока.ЗначениеПоказателя = 0;
				КонецЕсли;
			КонецЕсли;
			
			НоваяСтрока = ТекущийОбъект.ШкалаОценкиСтажа.Добавить();
			НоваяСтрока.ВерхняяГраницаИнтервалаСтажа = ТекСтрока.ЗначениеДо;
			НоваяСтрока.ЗначениеПоказателя = ТекСтрока.ЗначениеПоказателя;

		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФорматРедактированияЗначенияПоказателяШкалыОценки(ФорматнаяСтрока)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ШкалаОценкиЗначениеПоказателя", "Формат", ФорматнаяСтрока);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ШкалаОценкиЗначениеПоказателя", "ФорматРедактирования", ФорматнаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьШкалуНаСервере()
	
	ДобавитьСтрокиШкалыОценки(ШкалаОценки);
	
	Если Объект.ТипПоказателя = Перечисления.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа Тогда 
		РеквизитыПоказателя = Новый Структура("Наименование, КраткоеНаименование, Точность", "", НСтр("ru = 'Стаж, мес.'"), 0); 
	ИначеЕсли Не ЗначениеЗаполнено(Объект.БазовыйПоказатель) Тогда 
		РеквизитыПоказателя = Новый Структура("Наименование, КраткоеНаименование, Точность", "", НСтр("ru = 'Базовый показатель'"), 4); 
	Иначе 
		РеквизитыПоказателя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.БазовыйПоказатель, "Наименование, КраткоеНаименование, Точность");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БазовыйПараметр", "Заголовок", 
		?(ЗначениеЗаполнено(РеквизитыПоказателя.КраткоеНаименование), РеквизитыПоказателя.КраткоеНаименование, РеквизитыПоказателя.Наименование));
	
	ФорматнаяСтрока = ФорматнаяСтрокаЗначения(РеквизитыПоказателя.Точность);
	Для Каждого СтрокаШкалы Из ШкалаОценки Цикл
	    СтрокаШкалы.ЗначениеОт = Формат(СтрокаШкалы.ЗначениеОт, ФорматнаяСтрока);
	    СтрокаШкалы.ЗначениеДо = Формат(СтрокаШкалы.ЗначениеДо, ФорматнаяСтрока);
	КонецЦикла;
	
	УстановитьФорматИнтервалаШкалыОценки(ЭтаФорма, ФорматнаяСтрока);
	
	СформироватьПредставлениеИнтервалаШкалыОценки(ШкалаОценки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ФорматнаяСтрокаЗначения(Точность)
	
	ФорматнаяСтрока = "ЧДЦ=%1";
	ФорматнаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ФорматнаяСтрока, Точность);
	Возврат ФорматнаяСтрока; 
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФорматИнтервалаШкалыОценки(Форма, ФорматнаяСтрока)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ШкалаОценкиЗначениеОт", "Формат", ФорматнаяСтрока);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ШкалаОценкиЗначениеОт", "ФорматРедактирования", ФорматнаяСтрока);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ШкалаОценкиЗначениеДо", "Формат", ФорматнаяСтрока);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ШкалаОценкиЗначениеДо", "ФорматРедактирования", ФорматнаяСтрока);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначенияРеквизитовТарифнойСтавки(Форма)
	
	ДенежныйПоказатель = Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.Денежный");
	
	Если Не ДенежныйПоказатель Тогда 
		Форма.ЯвляетсяТарифнойСтавкой = Ложь;
	КонецЕсли;	
	
	Если Не ДенежныйПоказатель Или Не Форма.ЯвляетсяТарифнойСтавкой Тогда 
		Форма.Объект.ВидТарифнойСтавки = Неопределено;
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ВидТарифнойСтавкиГруппа", "Доступность", ДенежныйПоказатель И Не Форма.Объект.Предопределенный);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ВидТарифнойСтавки", "Доступность", Форма.ЯвляетсяТарифнойСтавкой);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначениеРеквизитаЯвляетсяТарифнойСтавкой(Форма)
	
	ДенежныйПоказатель = Форма.Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.Денежный");
	Форма.ЯвляетсяТарифнойСтавкой = ДенежныйПоказатель И ЗначениеЗаполнено(Форма.Объект.ВидТарифнойСтавки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСвойстваПоказателейЗависимыхПоШкале()
	
	Объект.ОтображатьВДокументахНачисления = Истина;
	
	Если Не ЭтоПоказательЗависимыйПоШкале(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа") Тогда
		// Если это показатель, зависящий от стажа, то он имеет только постоянное использование.
		Если Объект.СпособПримененияЗначений <> ПредопределенноеЗначение("Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное") Тогда
			Объект.СпособПримененияЗначений = ПредопределенноеЗначение("Перечисление.СпособыПримененияЗначенийПоказателейРасчетаЗарплаты.Постоянное");
			ЗаполнитьИнформациюОбИспользованииЗначений(ЭтаФорма);
			УстановитьРеквизитыПолейИспользованияЗначений(ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ТипПоказателя = ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтДругогоПоказателя") Тогда
		Объект.ОтображатьВДокументахНачисления = Ложь;
	КонецЕсли;
	
	ПодготовитьШкалуНаСервере();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоПоказательЗависимыйПоШкале(Объект)
	
	ТипыПоказателей = Новый Массив;
	ТипыПоказателей.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтДругогоПоказателя"));
	ТипыПоказателей.Добавить(ПредопределенноеЗначение("Перечисление.ТипыПоказателейРасчетаЗарплаты.ЧисловойЗависящийОтСтажа"));
	
	Возврат ТипыПоказателей.Найти(Объект.ТипПоказателя) <> Неопределено;
	
КонецФункции

// Медицина.ТарификационнаяОтчетностьУчрежденийФМБА

&НаСервере
Процедура ДополнитьФорму()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Медицина.ТарификационнаяОтчетностьУчрежденийФМБА") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ТарификационнаяОтчетностьУчрежденийФМБА");
		Модуль.ГруппаСоответствиеДополнитьФорму(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначенияРеквизитовПоказателяТарификации(Форма)
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Медицина.ТарификационнаяОтчетностьУчрежденийФМБА") Тогда
		Модуль = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("ТарификационнаяОтчетностьУчрежденийФМБАКлиентСервер");
		Модуль.УстановитьЗначенияРеквизитовПоказателяТарификации(Форма);
	КонецЕсли; 

КонецПроцедуры

// Конец Медицина.ТарификационнаяОтчетностьУчрежденийФМБА

#КонецОбласти
