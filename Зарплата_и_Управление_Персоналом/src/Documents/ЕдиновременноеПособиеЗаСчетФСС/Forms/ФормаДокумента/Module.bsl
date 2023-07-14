
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// Заполнение нового документа.
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц, ДатаСобытия",
			"Объект.Организация",
			"Объект.Ответственный",
			"Объект.ПериодРегистрации",
			"Объект.ДатаСобытия");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если НЕ ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
			Объект.ПериодРегистрации  = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.ВидПособия) Тогда
			Если НЕ ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации) Тогда
				Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности;
				Объект.ПособиеНаПогребениеСотруднику = Ложь;
			Иначе
				Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью;
				Объект.ПособиеНаПогребениеСотруднику = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		ПриПолученииДанныхНаСервере();
		РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
		
		Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
			РассчитатьПособие();
		КонецЕсли;  
		
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйФормы.УстановитьДоступныеХарактерыВыплаты(Элементы);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
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

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение И ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ПослеЗаписиДокументЕдиновременноеПособиеЗаСчетФСС", Объект.ИсправленныйДокумент, ЭтаФорма);
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);
	
	Оповестить("Запись_ЕдиновременноеПособиеЗаСчетФСС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	ДанныеВРеквизит();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПослеЗаписиДокументЕдиновременноеПособиеЗаСчетФСС" И Параметр = Объект.Ссылка Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
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

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
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
Процедура ВидПособияЧисломПриИзменении(Элемент)
	ВидПособияЧисломПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьЭлементовВыплатПособия()
	ВидимостьЭлементов = (ВидПособияЧислом <> 2);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыплатаГруппа", "Видимость", ВидимостьЭлементов);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОбработкаСозданиеВедомостейНаВыплатуЗарплатыСоздатьВедомостиПоРасчетномуДокументу", "Видимость", ВидимостьЭлементов);
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ФизическоеЛицоПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.ВидПособия.Пустая() Тогда
		ПоказатьПредупреждение(, НСтр("ru='Сначала укажите вид пособия.'"));
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	ОбновитьЭлементыВыбораВидаПособияЧислом();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт

	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	ОбновитьЭлементыВыбораВидаПособияЧислом();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	ОбновитьЭлементыВыбораВидаПособияЧислом();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	ОбновитьЭлементыВыбораВидаПособияЧислом();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	ОбновитьЭлементыВыбораВидаПособияЧислом();
КонецПроцедуры

&НаКлиенте
Процедура ДатаСобытияПриИзменении(Элемент)
	ДатаСобытияПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПорядокВыплатыПриИзменении(Элемент)
	
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(ЭтотОбъект);
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура Рассчитать(Команда)
	  РассчитатьПособие(Истина);
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

	ИсправлениеДокументовЗарплатаКадрыКлиентСервер.УстановитьПоляИсправления(Форма);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	РасчетЗарплатыРасширенныйФормы.ПорядокВыплатыЗарплатыДополнитьФорму(ЭтаФорма);
	
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма);
	
	ДанныеВРеквизит();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизит()
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	
	ОбновитьЭлементыВыбораВидаПособияЧислом();
	ОбновитьВидимостьЭлементовВыплатПособия();
	
	ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма);
	УстановитьПоляИсправления(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыВыбораВидаПособияЧислом()
	ТаблицаВидовПособий = ТаблицаВидовПособий();
	
	Если ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации) Тогда
		ВключенныеПособия = ТаблицаВидовПособий.Скопировать(Новый Структура("ВидимостьКогдаОрганизацияУчастникПилотногоПроекта", Истина));
	Иначе
		ВключенныеПособия = ТаблицаВидовПособий.Скопировать(Новый Структура("ВидимостьКогдаОрганизацияНеУчастникПилотногоПроекта", Истина));
	КонецЕсли;
	ВключенныеПособия.Сортировать("ВидПособияЧислом");
	
	ВидПособияЧислом = -1;
	
	Элементы.ВидПособияЧислом.СписокВыбора.Очистить();
	Для Каждого СтрокаТаблицы Из ВключенныеПособия Цикл
		Элементы.ВидПособияЧислом.СписокВыбора.Добавить(СтрокаТаблицы.ВидПособияЧислом, СтрокаТаблицы.Представление);
		Если Объект.ВидПособия = СтрокаТаблицы.ВидПособия
			И Объект.ПособиеНаПогребениеСотруднику = СтрокаТаблицы.ПособиеНаПогребениеСотруднику Тогда
			ВидПособияЧислом = СтрокаТаблицы.ВидПособияЧислом;
		КонецЕсли;
	КонецЦикла;
	
	Если ВидПособияЧислом = -1 Тогда
		ВидПособияЧислом = ВключенныеПособия[0].ВидПособияЧислом;
		ВидПособияЧисломПриИзмененииНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура РассчитатьПособие(ВыводитьСообщения = Ложь)
	  
	Если НЕ ДокументЗаполненПравильно(ВыводитьСообщения) Тогда
		Объект.Начислено = 0;
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидПособия  = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью Тогда
	  ГосударственноеПособиеВТвердыхСуммах = "ВСвязиСоСмертью";
	ИначеЕсли Объект.ВидПособия  = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности Тогда	
	  ГосударственноеПособиеВТвердыхСуммах = "ПриПостановкеНаУчетВРанниеСрокиБеременности";
	ИначеЕсли Объект.ВидПособия  = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка Тогда	
		ГосударственноеПособиеВТвердыхСуммах = "ПриРожденииРебенка";
	КонецЕсли;
	
	// Районный коэффициент.
	КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеОсновногоСотрудникаФизическогоЛица(
		Объект.Организация,
		Объект.ФизическоеЛицо,
		"Организация,Подразделение,Территория",
		Объект.ДатаСобытия,
		Истина);
	Если КадровыеДанныеСотрудника <> Неопределено Тогда
		ОбъектРК = РасчетЗарплатыРасширенный.ИсточникРайонногоКоэффициентаРФ(КадровыеДанныеСотрудника);
		РайонныйКоэффициентРФНаНачалоСобытия = РасчетЗарплатыРасширенный.РайонныйКоэффициентРФ(ОбъектРК);
	Иначе
		РайонныйКоэффициентРФнаНачалоСобытия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "РайонныйКоэффициентРФ");
	КонецЕсли;
	
	Если Объект.ВидПособия <> Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью 
		И ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации) Тогда
		Объект.Начислено = 0;	
	Иначе
		Объект.Начислено = УчетПособийСоциальногоСтрахованияРасширенный.РазмерГосударственногоПособия(ГосударственноеПособиеВТвердыхСуммах, Объект.ДатаСобытия) * РайонныйКоэффициентРФнаНачалоСобытия; 	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ДокументЗаполненПравильно(ВыводитьСообщения = Истина)
	ТекстСообщения = "";
	СтруктураСообщений  = Новый Соответствие;
	ДокументЗаполненПравильно = Истина;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаСобытия) Тогда
		ТекстСообщения = НСтр("ru = 'Не указана дата выплаты пособия.'");
		СтруктураСообщений.Вставить("ДатаСобытия", ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидПособия) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан вид выплачиваемого пособия.'");
		СтруктураСообщений.Вставить("ВидПособия", ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан получатель пособия.'");
		СтруктураСообщений.Вставить("ФизическоеЛицо", ТекстСообщения);
	КонецЕсли;
	
	ДокументЗаполненПравильно = СтруктураСообщений.Количество() = 0;
	
	Если ВыводитьСообщения И НЕ ДокументЗаполненПравильно Тогда
		Для каждого Сообщение Из СтруктураСообщений Цикл
			ОбщегоНазначения.СообщитьПользователю(Сообщение.Значение,,"Объект" + ?(Сообщение.Ключ = "","",".") + Сообщение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДокументЗаполненПравильно;	
КонецФункции // ()

&НаСервере
Функция ОбновитьПараметрыВыбораФизическогоЛица()
	
	МассивПараметровВыбора = Новый Массив(); // Имя ПараметрыВыбора используется формой.
	
	Если Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью
		И Не Объект.ПособиеНаПогребениеСотруднику Тогда
		Параметр = Новый ПараметрВыбора("Отбор.Организация", Неопределено);
		МассивПараметровВыбора.Добавить(Параметр);
	Иначе
		Параметр = Новый ПараметрВыбора("Отбор.Организация", Объект.Организация);
		МассивПараметровВыбора.Добавить(Параметр);
		Параметр = Новый ПараметрВыбора("Отбор.ВидЗанятости", Перечисления.ВидыЗанятости.ОсновноеМестоРаботы);
		МассивПараметровВыбора.Добавить(Параметр);
	КонецЕсли;
	
	Элементы.ФизическоеЛицо.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "ФизическоеЛицо");
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	Объект.Начислено = 0;
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	
	ОбновитьЭлементыВыбораВидаПособияЧислом();
	
	РасчетЗарплатыРасширенныйФормы.ОбновитьПлановыеДатыВыплатыПоОрганизации(ЭтаФорма);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	
КонецПроцедуры

&НаСервере
Процедура ВидПособияЧисломПриИзмененииНаСервере()
	ТаблицаВидовПособий = ТаблицаВидовПособий();
	СтрокаТаблицы = ТаблицаВидовПособий.Найти(ВидПособияЧислом, "ВидПособияЧислом");
	
	Объект.ВидПособия = СтрокаТаблицы.ВидПособия;
	Объект.ПособиеНаПогребениеСотруднику = СтрокаТаблицы.ПособиеНаПогребениеСотруднику;
	
	ОбновитьВидимостьЭлементовВыплатПособия();
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	РассчитатьПособие();
КонецПроцедуры

&НаСервере
Процедура ДатаСобытияПриИзмененииНаСервере()
	РассчитатьПособие();
КонецПроцедуры

&НаСервере
Функция ТаблицаВидовПособий()
	// Чтение из кэша.
	Если ЗначениеЗаполнено(АдресТаблицыВидовПособий) Тогда
		Возврат ПолучитьИзВременногоХранилища(АдресТаблицыВидовПособий);
	КонецЕсли;
	
	// Инициализация кэша.
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ВидПособияЧислом", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ВидПособия");
	Таблица.Колонки.Добавить("Представление");
	Таблица.Колонки.Добавить("ПособиеНаПогребениеСотруднику", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("ВидимостьКогдаОрганизацияУчастникПилотногоПроекта", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("ВидимостьКогдаОрганизацияНеУчастникПилотногоПроекта", Новый ОписаниеТипов("Булево"));
	
	ОписаниеВида = Таблица.Добавить();
	ОписаниеВида.ВидПособияЧислом = 0;
	ОписаниеВида.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности;
	ОписаниеВида.ПособиеНаПогребениеСотруднику = Ложь;
	ОписаниеВида.ВидимостьКогдаОрганизацияУчастникПилотногоПроекта   = Ложь;
	ОписаниеВида.ВидимостьКогдаОрганизацияНеУчастникПилотногоПроекта = Истина;
	
	ОписаниеВида = Таблица.Добавить();
	ОписаниеВида.ВидПособияЧислом = 1;
	ОписаниеВида.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка;
	ОписаниеВида.ПособиеНаПогребениеСотруднику = Ложь;
	ОписаниеВида.ВидимостьКогдаОрганизацияУчастникПилотногоПроекта   = Ложь;
	ОписаниеВида.ВидимостьКогдаОрганизацияНеУчастникПилотногоПроекта = Истина;
	
	ОписаниеВида = Таблица.Добавить();
	ОписаниеВида.ВидПособияЧислом = 2;
	ОписаниеВида.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью;
	ОписаниеВида.ПособиеНаПогребениеСотруднику = Ложь;
	ОписаниеВида.ВидимостьКогдаОрганизацияУчастникПилотногоПроекта   = Истина;
	ОписаниеВида.ВидимостьКогдаОрганизацияНеУчастникПилотногоПроекта = Истина;
	
	ОписаниеВида = Таблица.Добавить();
	ОписаниеВида.ВидПособияЧислом = 3;
	ОписаниеВида.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью;
	ОписаниеВида.ПособиеНаПогребениеСотруднику = Истина;
	ОписаниеВида.ВидимостьКогдаОрганизацияУчастникПилотногоПроекта   = Истина;
	ОписаниеВида.ВидимостьКогдаОрганизацияНеУчастникПилотногоПроекта = Истина;
	
	// Заполнение представлений.
	СписокПредставлений = Элементы.ВидПособияЧислом.СписокВыбора;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Представление = СписокПредставлений.НайтиПоЗначению(СтрокаТаблицы.ВидПособияЧислом).Представление;
	КонецЦикла;
	
	// Сохранение в кэше.
	АдресТаблицыВидовПособий = ПоместитьВоВременноеХранилище(Таблица, УникальныйИдентификатор);
	
	Возврат Таблица;
КонецФункции

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере()
	РассчитатьПособие();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента()
	
	Возврат Новый Структура("МесяцНачисленияИмя,ПорядокВыплатыИмя,ПланируемаяДатаВыплатыИмя", "ПериодРегистрации", "ПорядокВыплаты", "ПланируемаяДатаВыплаты");
	
КонецФункции

#КонецОбласти
