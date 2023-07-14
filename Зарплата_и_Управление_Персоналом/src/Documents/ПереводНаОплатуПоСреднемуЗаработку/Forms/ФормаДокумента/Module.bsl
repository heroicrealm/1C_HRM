
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Ключ.Пустая() Тогда  // форма нового
		ОграниченияНаУровнеЗаписей = Новый ФиксированнаяСтруктура("ЧтениеБезОграничений, ИзменениеБезОграничений, ИзменениеКадровыхДанных", Ложь, Ложь, Ложь);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма, ОписаниеДокумента(ЭтаФорма));
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если Параметры.Свойство("Сотрудник") И ЗначениеЗаполнено(Параметры.Сотрудник) Тогда 
			Объект.Сотрудник = Параметры.Сотрудник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			УстановитьИспользованиеСреднечасовогоЗаработка();
		КонецЕсли;
		
		// Заполнение нового документа.
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный",
		"Объект.Организация",
		"Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если Не ЗначениеЗаполнено(Объект.ДатаНачалаСобытия) Тогда
			Объект.ДатаНачалаСобытия = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.ПроцентОплаты) Тогда
			Объект.ПроцентОплаты = 100;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВФорме(ЭтотОбъект, "ВидРасчета");
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		ЗаполнитьПериодРасчетаСреднегоЗаработка();
		ОбновитьДанныеДляРасчетаСреднего();
		
	Иначе
		
		Если Параметры.Свойство("ВыполнитьПерезаполнениеСведенийОСреднемЗаработке") Тогда
			ОбновитьДанныеДляРасчетаСреднего();
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений И Объект.РазмерОплатыУтвержден Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьКомандПечатиМногофункциональногоДокумента(ЭтаФорма);
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	ЗаполнениеВыполнено = Ложь;
	
	УстановитьИспользованиеСреднечасовогоЗаработка();
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ЗаполнениеВыполнено Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("УдалитьПерерасчетыСреднегоЗаработка", Истина);
	КонецЕсли; 
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДанныеВРеквизиты();
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
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
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
	Оповестить("Запись_ПереводНаОплатуПоСреднемуЗаработку", Объект.Ссылка);
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРасчетаПриИзменении(Элемент)
	
	ВидРасчетаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	ДатаОкончанияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполненностьДанныхИнформационныйТекстОбработкаНавигационнойСсылки(Элемент, 
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УчетСреднегоЗаработкаКлиент.ПоказатьПричиныПерерасчетаСреднегоЗаработка(Объект.Ссылка, 
		СтандартнаяОбработка, НавигационнаяСсылкаФорматированнойСтроки);
	
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

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Сторнировать(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Сторнировать(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКСторно(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКСторно(ЭтотОбъект);
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура ОткрытьСреднийЗаработок(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьСреднийЗаработокЗавершение", ЭтотОбъект);
	УчетСреднегоЗаработкаКлиент.ОткрытьФормуВводаСреднегоЗаработкаОбщий(ПараметрыРедактированияСреднегоЗаработка(), ЭтаФорма, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСреднийЗаработокЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатРедактирования <> Неопределено Тогда
		ПеренестиДанныеУчетаСреднегоЗаработкаВДокумент(РезультатРедактирования);
	КонецЕсли;
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

#Область ИсправлениеДокументов

&НаКлиенте
Процедура УстановитьПоляИсправленияНаКлиенте() Экспорт
	
	УстановитьПоляИсправления(ЭтаФорма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПоляИсправления(Форма)

	ИсправлениеДокументовЗарплатаКадрыКлиентСервер.УстановитьПоляИсправления(Форма, "ПериодическиеСведения");
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	НачатьИнициализациюФормы();
	ЗарплатаКадрыРасширенный.ИзменитьРеквизитыФормы(ЭтаФорма);
	ЗавершитьИнициализациюФормы();
	
	РеквизитыКДобавлению.Очистить();
	РеквизитыКУдалению.Очистить();
	
КонецПроцедуры	

&НаСервере
Процедура НачатьИнициализациюФормы()
	
	УстановитьДоступностьРегистрацииНачислений();
	
	УстановитьПривилегированныйРежим(Истина);

	// обработка создания формы
	ДополнитьФорму(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьИнициализациюФормы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДополнитьФорму(Ложь);
	ДополнитьФорму();
	
	УстановитьВидимостьРасчетныхПолей();
	ЗаполнитьИнформациюЗаполненностиДанных();
	
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьФорму(ОтложенноеИзменение = Неопределено)
	
	Если ОтложенноеИзменение = Неопределено Тогда // Выполняем процедуры, не нуждающиеся в механизме отложенного создания.
		
		// Создание реквизитов.
		ЗарплатаКадрыРасширенный.МногофункциональныеДокументыДобавитьЭлементыФормы(ЭтаФорма, НСтр("ru='Размер оплаты утвержден'"), "РасчетчикГруппа", "РазмерОплатыУтвержден");
		
	Иначе
		
		Если ОтложенноеИзменение Тогда
			ДобавлятьЭлементыФормы = Ложь;
			ДобавлятьРеквизитыФормы = Истина;
		Иначе
			ДобавлятьЭлементыФормы = Истина;
			ДобавлятьРеквизитыФормы = Ложь;
		КонецЕсли;
		
		ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(
			ЭтаФорма, ДобавлятьЭлементыФормы, ДобавлятьРеквизитыФормы, ОтложенноеИзменение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеДляРасчетаСреднего()
	
	Если Не РасчетЗарплатыРасширенныйКлиентСервер.ФормаДокументаГотоваДляРасчетаЗарплаты(ЭтаФорма, ОписаниеДокумента(ЭтаФорма), Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	УчетСреднегоЗаработка.ОбновитьДанныеОбщегоСреднегоЗаработка(
			Новый Структура("ДанныеОНачислениях, ДанныеОВремени, ДанныеОбИндексации", 
				Объект.СреднийЗаработокОбщий, Объект.ОтработанноеВремяДляСреднегоОбщий, Объект.ДанныеОбИндексации), 
				Объект.ДатаНачалаСобытия, 
				Объект.ПериодРасчетаСреднегоЗаработкаНачало, 
				Объект.ПериодРасчетаСреднегоЗаработкаОкончание,
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник), , 
				Объект.Ссылка);
		
	ЗаполнитьИнформациюЗаполненностиДанных();
	РассчитатьСреднийЗаработок();
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьИнформациюЗаполненностиДанных()
	
	СтруктураИнфонадписи = УчетСреднегоЗаработка.ИнформацияОЗаполненностиДанныхСреднегоЗаработка(
		Объект.Ссылка,
		ЗаполнениеВыполнено,
		Объект.Сотрудник,
		Объект.ДатаНачалаСобытия,
	   	Объект.ПериодРасчетаСреднегоЗаработкаНачало, 
	    Объект.ПериодРасчетаСреднегоЗаработкаОкончание, 
		Объект.СреднийЗаработокОбщий, 
		Объект.ОтработанноеВремяДляСреднегоОбщий);
		
	ЗаполненностьДанныхИнформационныйТекст			= СтруктураИнфонадписи.Текст;
	Элементы.ЗаполненностьДанныхКартинка.Картинка	= СтруктураИнфонадписи.Картинка;
	ОбновитьИнформациюЗаполненностиДанных   		= Ложь;
	
КонецПроцедуры	

&НаСервере
Процедура РассчитатьСреднийЗаработок()
	
	ДополнительныеПараметры = УчетСреднегоЗаработкаКлиентСервер.ДополнительныеПараметрыРасчетаСреднегоЗаработка();
	ДополнительныеПараметры.Индексации = Объект.ДанныеОбИндексации;
	ДополнительныеПараметры.ДатаНачалаСобытия = Объект.ДатаНачалаСобытия;
	ДополнительныеПараметры.НачалоПериода = Объект.ПериодРасчетаСреднегоЗаработкаНачало;
	ДополнительныеПараметры.ОкончаниеПериода = Объект.ПериодРасчетаСреднегоЗаработкаОкончание;
	ДополнительныеПараметры.ПоЧасам = ИспользуетсяСреднечасовойЗаработок;
	
	Объект.СреднийЗаработок = УчетСреднегоЗаработкаКлиентСервер.СреднийЗаработокОбщий(Объект.СреднийЗаработокОбщий, Объект.ОтработанноеВремяДляСреднегоОбщий, ДополнительныеПараметры);
	
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
			ЗаполнитьТаблицуКоэффициентыРаспределенияСреднегоЗаработка();	
		КонецЕсли;
	
	ЗаполнениеВыполнено = Истина;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьТаблицуКоэффициентыРаспределенияСреднегоЗаработка()

	КоэффициентыРаспределения = УчетСреднегоЗаработка.КоэффициентыРаспределенияСреднегоЗаработкаДокумента(Объект, ОписаниеДокумента(ЭтаФорма));
	Объект.КоэффициентыРаспределенияСреднегоЗаработка.Загрузить(КоэффициентыРаспределения[Перечисления.СпособыРасчетаНачислений.ПустаяСсылка()]);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПериодРасчетаСреднегоЗаработка()
	
	Если Объект.ФиксПериодРасчетаСреднегоЗаработка Тогда
		// Период расчета среднего заработка установлен принудительно.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаНачалаСобытия) 
		Или Не ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Возврат;
	КонецЕсли;
	
	ПериодРасчетаСреднего = УчетСреднегоЗаработка.ПериодРасчетаОбщегоСреднегоЗаработкаСотрудника(Объект.ДатаНачалаСобытия, Объект.Сотрудник, Объект.ВидРасчета);
	
	Если НачалоМесяца(Объект.ПериодРасчетаСреднегоЗаработкаНачало) <> НачалоМесяца(ПериодРасчетаСреднего.ДатаНачала) 
		Или	НачалоМесяца(Объект.ПериодРасчетаСреднегоЗаработкаОкончание) <> НачалоМесяца(ПериодРасчетаСреднего.ДатаОкончания) Тогда
		Объект.ПериодРасчетаСреднегоЗаработкаНачало	= ПериодРасчетаСреднего.ДатаНачала;
		Объект.ПериодРасчетаСреднегоЗаработкаОкончание = ПериодРасчетаСреднего.ДатаОкончания;
		ОбновитьДанныеДляРасчетаСреднего();
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьИспользованиеСреднечасовогоЗаработка()
	
	ИспользуетсяСреднечасовойЗаработок = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если УчетРабочегоВремениРасширенный.СотрудникуПрименяетсяСуммированныйУчетРабочегоВремени(Объект.Сотрудник, Объект.ДатаНачалаСобытия) Тогда
		ИспользуетсяСреднечасовойЗаработок = Истина;
		Возврат;
	КонецЕсли;
	
	Если УчетСреднегоЗаработка.НачислениеИспользуетСреднечасовойЗаработок(Объект.ВидРасчета) Тогда
		ИспользуетсяСреднечасовойЗаработок = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеСреднегоЗаработка()
	
	Объект.СреднийЗаработокОбщий.Очистить();
	Объект.ОтработанноеВремяДляСреднегоОбщий.Очистить();
	Объект.ДанныеОбИндексации.Очистить();
	
	Объект.ПериодРасчетаСреднегоЗаработкаНачало = Неопределено;
	Объект.ПериодРасчетаСреднегоЗаработкаОкончание = Неопределено;
	Объект.ФиксПериодРасчетаСреднегоЗаработка = Ложь; 
	Объект.СреднийЗаработок = Неопределено;
	
	УстановитьПредупреждениеДокументНеРассчитан(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредупреждениеДокументНеРассчитан(Форма)
	
	Форма.ЗаполненностьДанныхИнформационныйТекст = УчетСреднегоЗаработкаКлиентСервер.ТекстПредупрежденияДокументНеРассчитан();
	Форма.Элементы.ЗаполненностьДанныхКартинка.Картинка = БиблиотекаКартинок.Предупреждение;
	Форма.ОбновитьИнформациюЗаполненностиДанных  = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыРедактированияСреднегоЗаработка()
	
	ПараметрыРедактирования = УчетСреднегоЗаработкаКлиентСервер.ПараметрыРедактированияОбщегоСреднегоЗаработкаПоДокументу();
	ПараметрыРедактирования.ДокументСсылка = Объект.Ссылка;
	ПараметрыРедактирования.Сотрудник = Объект.Сотрудник;
	ПараметрыРедактирования.Организация = Объект.Организация;
	ПараметрыРедактирования.ДатаНачалаСобытия = Объект.ДатаНачалаСобытия;
	ПараметрыРедактирования.Начисление = Объект.ВидРасчета;
	ПараметрыРедактирования.НачалоПериодаРасчета = Объект.ПериодРасчетаСреднегоЗаработкаНачало;
	ПараметрыРедактирования.ОкончаниеПериодаРасчета = Объект.ПериодРасчетаСреднегоЗаработкаОкончание; 
	ПараметрыРедактирования.ЭтоСреднечасовойЗаработок = ИспользуетсяСреднечасовойЗаработок;
	ПараметрыРедактирования.ФиксПериодРасчета = Объект.ФиксПериодРасчетаСреднегоЗаработка;
	
	УчетСреднегоЗаработка.ЗаполнитьТаблицыДанныхСреднегоЗаработкаПоДокументу(Объект, ПараметрыРедактирования);
	
	Возврат ПараметрыРедактирования;

КонецФункции

&НаСервере
Процедура ПеренестиДанныеУчетаСреднегоЗаработкаВДокумент(РезультатРедактирования)
	
	// Переносит данные учета среднего заработка (результат работы формы "калькулятора") 
	// в таблицы документа.
	
	Объект.СреднийЗаработокОбщий.Очистить();
	Объект.ОтработанноеВремяДляСреднегоОбщий.Очистить();
	Объект.ДанныеОбИндексации.Очистить();
	
	УчетСреднегоЗаработка.ЗаполнитьДанныеУчетаОбщегоСреднегоЗаработка(
		Объект.СреднийЗаработокОбщий, 
		Объект.ОтработанноеВремяДляСреднегоОбщий,
		Объект.ДанныеОбИндексации,
		РезультатРедактирования, 
		Модифицированность);
	
	Объект.ПериодРасчетаСреднегоЗаработкаНачало = РезультатРедактирования.НачалоПериодаРасчета;
	Объект.ПериодРасчетаСреднегоЗаработкаОкончание = РезультатРедактирования.ОкончаниеПериодаРасчета;
	Объект.ФиксПериодРасчетаСреднегоЗаработка = РезультатРедактирования.ФиксПериодРасчета;
	Объект.СреднийЗаработок = РезультатРедактирования.СреднийЗаработок;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
		ЗаполнитьТаблицуКоэффициентыРаспределенияСреднегоЗаработка();	
	КонецЕсли;
	
	ЗаполнитьИнформациюЗаполненностиДанных();
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	УстановитьПоляИсправления(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	ЗаполнитьДанныеФормыПоОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОчиститьДанныеСреднегоЗаработка();
	
	// Период расчета среднего возвращаем "умолчательный".
	Объект.ФиксПериодРасчетаСреднегоЗаработка = Ложь;
	
	ЗаполнитьПериодРасчетаСреднегоЗаработка();
	УстановитьИспользованиеСреднечасовогоЗаработка();
	ОбновитьДанныеДляРасчетаСреднего();
	
КонецПроцедуры

&НаСервере
Процедура ВидРасчетаПриИзмененииНаСервере()
	
	// Период расчета среднего возвращаем "умолчательный".
	Объект.ФиксПериодРасчетаСреднегоЗаработка = Ложь;
	
	ЗаполнитьПериодРасчетаСреднегоЗаработка();
	УстановитьИспользованиеСреднечасовогоЗаработка();
	ОбновитьДанныеДляРасчетаСреднего();
	
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	Объект.ДатаНачалаСобытия = Объект.ДатаНачала;
	
	ЗаполнитьПериодРасчетаСреднегоЗаработка();
	ОбновитьДанныеДляРасчетаСреднего();
	
КонецПроцедуры

&НаСервере
Процедура ДатаОкончанияПриИзмененииНаСервере()
	
	ЗаполнитьПериодРасчетаСреднегоЗаработка();
	ОбновитьДанныеДляРасчетаСреднего();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента(Форма)
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеРасчетногоДокумента();
	Описание.РегистрацияНачисленийДоступна = Форма.ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений;
	Описание.ЕстьОплатаПоСреднему = Истина;
	Описание.ЭтоСреднечасовойЗаработок = Форма.ИспользуетсяСреднечасовойЗаработок;
	
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента("Сотрудник", "Объект.Сотрудник"));
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента("Дата начала периода сохранения среднего заработка", "Объект.ДатаНачалаСобытия"));
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента("Дата начала", "Объект.ДатаНачала"));
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента("Вид расчета", "Объект.ВидРасчета"));
	Описание.ПроверяемыеПериоды.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеПроверяемогоПериода("Дата начала", "Объект.ДатаНачала", "Дата окончания", "Объект.ДатаОкончания"));
	
	Возврат Описание;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьРасчетныхПолей()
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("СреднийЗаработокИнфо");
	ИменаЭлементов.Добавить("ВидРасчета");
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейМногофункциональныхДокументов(ЭтаФорма, ИменаЭлементов);
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СреднийЗаработок", "ТолькоПросмотр", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьРегистрацииНачислений()
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(Объект);
	РегистрацияНачисленийДоступна = ПраваНаДокумент.ПолныеПраваПоРолям;
	ОграниченияНаУровнеЗаписей = Новый ФиксированнаяСтруктура(ПраваНаДокумент.ОграниченияНаУровнеЗаписей);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей()
	
	БылиОграничения = ОграниченияНаУровнеЗаписей;
	УстановитьДоступностьРегистрацииНачислений();
	
	Если БылиОграничения.ЧтениеБезОграничений <> ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений
		Или БылиОграничения.ИзменениеБезОграничений <> ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений
		Или БылиОграничения.ИзменениеКадровыхДанных <> ОграниченияНаУровнеЗаписей.ИзменениеКадровыхДанных Тогда 
		
		Объект.РазмерОплатыУтвержден = ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений;
		
		УстановитьВидимостьРасчетныхПолей();
		
		Если БылиОграничения.ЧтениеБезОграничений <> ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
			ЗарплатаКадрыРасширенный.УстановитьВидимостьКомандПечатиМногофункциональногоДокумента(ЭтаФорма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
