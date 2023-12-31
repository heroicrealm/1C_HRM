
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВФорме(ЭтотОбъект, "ВидРасчета", , , , , Истина);
		Если Параметры.ЗначенияЗаполнения.Свойство("Организация") 
			И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Организация) Тогда
			Объект.Организация = Параметры.ЗначенияЗаполнения.Организация;
		КонецЕсли;
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Ответственный",	"Объект.Ответственный");
		ЗначенияДляЗаполнения.Вставить("Организация",	"Объект.Организация");
		ЗначенияДляЗаполнения.Вставить("Месяц",			"Объект.ПериодРегистрации");
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли; 
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПериодыОплаченныеДоНачалаЭксплуатации", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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
	
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры
	
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыРасширенныйКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ЗарплатаКадрыРасширенныйКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	НастроитьОтображениеПодразделений();
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникПриИзменении(Элемент)
	ДополнитьСтрокуРасчета(Элементы.Начисления.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаНачалаПриИзменении(Элемент)
	ДополнитьСтрокуРасчета(Элементы.Начисления.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаОкончанияПриИзменении(Элемент)
	ДополнитьСтрокуРасчета(Элементы.Начисления.ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыОткрытия.Вставить("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников());
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ГоловнаяОрганизация", Объект.Организация);
	
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора", ПараметрыОткрытия, Элементы.Начисления, Истина);
		
КонецПроцедуры

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

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект)
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере()

	ИспользуетсяРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
	
	УстановитьПараметрыВыбораВидуПериода();
	
	УстановитьФункциональныеОпцииФормы();
	
	// заполним предупреждения
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораВидуПериода()
	
	ДопустимыеЗначенияВвода = Новый Массив;
	
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.Работа"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускОсновной"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ДополнительныйОтпуск"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ДополнительныйОтпускНеоплачиваемый"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускУчебныйОплачиваемый"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускУчебныйНеоплачиваемый"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускНеоплачиваемыйПоРазрешениюРаботодателя"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускНеоплачиваемыйПоЗаконодательству"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.Командировка"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтсутствиеССохранениемОплаты"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускПоБеременностиИРодам"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускНаСанаторноКурортноеЛечение"));
	
	ПараметрыВыбораВидуПериода = Новый Массив;
	Для каждого ПараметрВыбора Из Элементы.НачисленияВидПериода.ПараметрыВыбора Цикл
		Если ПараметрВыбора.Имя = "Отбор.Ссылка" Тогда
			Продолжить;
		КонецЕсли;
		ПараметрыВыбораВидуПериода.Добавить(ПараметрВыбора);
	КонецЦикла; 
	
	ПараметрыВыбораВидуПериода.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(ДопустимыеЗначенияВвода)));
	
	Элементы.НачисленияВидПериода.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораВидуПериода);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеПодразделений()
	
	Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям")
		И ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ВидимостьПодразделенийВТабличнойЧасти = Ложь;
	Иначе
		ВидимостьПодразделенийВТабличнойЧасти = Истина;
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СотрудникиПодразделение",
		"Видимость",
		ВидимостьПодразделенийВТабличнойЧасти);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Организация",	"Объект.Организация");
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли;
		
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
		
		
		НастроитьОтображениеПодразделений();
		
	КонецЕсли;
		
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	Возврат ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура СотрудникиОбработкаВыбораНаСервере(ВыбранныеСотрудники)

	Если ТипЗнч(ВыбранныеСотрудники) = Тип("Массив") Тогда
		СписокСотрудников = ВыбранныеСотрудники;
	Иначе
		СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныеСотрудники);
	КонецЕсли;
	
	Для каждого Сотрудник Из СписокСотрудников Цикл
		
		Если Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли; 
		
		НоваяСтрокаСотрудников = Объект.Начисления.Добавить();
		НоваяСтрокаСотрудников.Сотрудник = Сотрудник;
		НоваяСтрокаСотрудников.ДатаНачала = Объект.ПериодРегистрации;
		НоваяСтрокаСотрудников.ДатаОкончания = Объект.ПериодРегистрации;
		
		ДополнитьСтрокуНаСервере(НоваяСтрокаСотрудников.ПолучитьИдентификатор(), ОписаниеТаблицыНачислений(), Истина, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьСтрокуРасчета(ТекущиеДанные)

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Сотрудник)
		ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.ДатаНачала)
		ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.ДатаОкончания) Тогда
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйКлиент.ДополнитьСтрокуРасчета(ЭтаФорма, ОписаниеТаблицыНачислений(), Истина, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ДополнитьСтроку(ИдентификаторСтроки, ОписаниеТаблицы, ЗаполнятьСведенияСотрудников, ЗаполнятьЗначенияПоказателей) Экспорт
	ДополнитьСтрокуНаСервере(ИдентификаторСтроки, ОписаниеТаблицы, ЗаполнятьСведенияСотрудников, ЗаполнятьЗначенияПоказателей)
КонецПроцедуры

&НаСервере
Процедура ДополнитьСтрокуНаСервере(ИдентификаторСтроки, ОписаниеТаблицы, ЗаполнятьСведенияСотрудников, ЗаполнятьЗначенияПоказателей)

	РасчетЗарплатыРасширенныйФормы.ДополнитьСтрокуРасчета(
		ЭтаФорма,
		ОписаниеДокумента(ЭтотОбъект),
		ИдентификаторСтроки,
		ОписаниеТаблицыНачислений(),
		ЗаполнятьСведенияСотрудников,
		ЗаполнятьЗначенияПоказателей);
	
КонецПроцедуры

// Описания документа, таблиц документа, панелей документа.
&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента(Форма)
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеРасчетногоДокумента();
	
	Описание.НачисленияИмя = "Начисления";
	Описание.НачисленияКоманднаяПанельИмя = "НачисленияКоманднаяПанельГруппа";
	Описание.ВидНачисленияВШапке = Истина;
	Описание.ВидНачисленияИмя = "ВидРасчета";
	Описание.МесяцНачисленияИмя = "ПериодРегистрации";
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента(НСтр("ru = 'Месяц начисления'"), "МесяцНачисленияСтрокой"));
	
	Возврат Описание;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	Описание.СодержитПолеСотрудник = Истина;
	Описание.ИмяРеквизитаСотрудник = "Сотрудник";
	Описание.СодержитПолеВидРасчета = Ложь;
	Описание.ИмяРеквизитаВидРасчета = "ВидРасчета";
	Описание.ИмяРеквизитаПериод = "ПериодРегистрации";
	Описание.ОтменятьВсеИсправления	= Истина;
	Описание.ОтображатьПоляРаспределенияРезультатов	= Ложь;
	
	Возврат Описание;
	
КонецФункции

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить("Объект.Начисления");
	Массив.Добавить("Объект.ФизическиеЛица");
	Возврат Массив;
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	НСтр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение",	НСтр("ru = 'подразделения'")));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецОбласти
