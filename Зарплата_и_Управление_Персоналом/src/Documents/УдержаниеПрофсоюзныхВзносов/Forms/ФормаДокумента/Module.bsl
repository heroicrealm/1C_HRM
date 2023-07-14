
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, ДатаСобытия", 
			"Объект.Организация", "Объект.Ответственный", "Объект.ДатаНачала");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьУдержаниеВФормеДокументаПоРоли(
			ЭтаФорма, 
			Объект.Удержание, 
			Перечисления.КатегорииУдержаний.ПрофсоюзныеВзносы, 
			Новый Структура("СпособВыполненияУдержания", Перечисления.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете));
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьКонтрагентаВФормеДокументаПоУдержанию(ЭтотОбъект, "ПрофсоюзнаяОрганизация", Объект.Удержание);
		Если Не ЗначениеЗаполнено(Объект.Действие) Тогда
			Объект.Действие = Перечисления.ДействияСУдержаниями.Начать;
		КонецЕсли;
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
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

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РеквизитыВДанные(ТекущийОбъект);
	
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
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДанныеВРеквизиты();
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
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
	Оповестить("Запись_УдержаниеПрофсоюзныхВзносов", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыПоказателиДокумента" И Источник.ВладелецФормы = ЭтотОбъект Тогда
		Если Параметр.Показатели.Количество() > 0 Тогда 
			ОбработатьИзменениеПоказателейНаСервере(Параметр.Показатели);
		КонецЕсли;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
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
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УдержаниеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	УдержаниеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ДействиеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ДокументОснованиеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУдержания

&НаКлиенте
Процедура УдержанияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(Объект.Удержание) Тогда 
		ТекстСообщения = НСтр("ru = 'Не указано удержание.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Удержание", "Объект", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗарплатаКадрыРасширенныйКлиент.ВводНачисленийВШапкеПриНачалеРедактирования(ЭтотОбъект, "Удержания", НоваяСтрока);
	ЗарплатаКадрыРасширенныйКлиент.УстановитьОграничениеТипаПоТочностиПоказателя(Элементы.Удержания.ТекущиеДанные, ЭтотОбъект, "Удержания", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПослеУдаления(Элемент)
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияФизическоеЛицоПриИзменении(Элемент)
	
	УдержанияФизическоеЛицоПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПредставлениеРабочегоМестаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УдержанияПредставлениеРабочегоМестаНачалоВыбораНаСервере(Элементы.Удержания.ТекущиеДанные.ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПредставлениеРабочегоМестаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЗарплатаКадрыРасширенныйКлиент.РабочиеМестаУдержанийОбработкаВыбораРабочегоМеста(ЭтотОбъект, Элементы.Удержания.ТекущиеДанные, ВыбранноеЗначение, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подбор(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("ДатаПримененияОтбора", Объект.ДатаНачала);
	Отбор.Вставить("ВАрхиве", Ложь);
		
	Если МассивФизическихЛиц.Количество() > 0 Тогда 
		Отбор.Вставить("Ссылка", МассивФизическихЛиц);
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Отбор);
	
	КадровыйУчетКлиент.ВыбратьФизическихЛицОрганизации(Элементы.Удержания, Объект.Организация, Истина, , АдресСпискаПодобранныхСотрудников(), Истина, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоказатели(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Удержание) Тогда 
		ТекстСообщения = НСтр("ru = 'Не указано удержание.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Удержание");
		Возврат;
	КонецЕсли;
	
	МассивПоказателей = Новый Массив;
	ВидРасчетаИнфо = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ПолучитьИнформациюОВидеРасчета(Объект.Удержание);
	Для Каждого ОписаниеПоказателя Из ВидРасчетаИнфо.Показатели Цикл
		Если ОписаниеПоказателя.ЗапрашиватьПриВводе Тогда
			МассивПоказателей.Добавить(ОписаниеПоказателя.Показатель);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура("МассивПоказателей", МассивПоказателей);
	ОткрытьФорму("ОбщаяФорма.ГрупповоеЗаполнениеПоказателейДокументов", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

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
Процедура ПриПолученииДанныхНаСервере()

	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыУдержаний();
	ЗарплатаКадрыРасширенный.ВводНачисленийВШапкеДополнитьФорму(ЭтотОбъект, ОписаниеТаблицыВидовРасчета, 1);
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект, "УдержанияПредставлениеРабочегоМеста");

	ДанныеВРеквизиты();
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьПоказателей(Элементы, Объект.Удержание, "УдержанияПоказатели");
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьРазмера(Элементы, Объект.Удержание, "УдержанияРазмер");
	
	УстановитьСтраницуДействия();
	УстановитьДоступностьПоляДатаОкончания();
	УстановитьДоступностьДокументаОснования();
	УстановитьДоступностьПоляРазмер();
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
		
КонецПроцедуры

&НаСервере
Процедура УстановитьСтраницуДействия()
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьСтраницуДействия(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоляДатаОкончания()
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Изменить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ИзменитьГруппа);
	ИначеЕсли Объект.Действие = Перечисления.ДействияСУдержаниями.Прекратить Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьОтменитьГруппа", "ТекущаяСтраница", Элементы.ПрекратитьГруппа);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьДокументаОснования()
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Начать Тогда
		Объект.ДокументОснование = Неопределено;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументОснование", "Доступность", Ложь);
		Возврат;
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументОснование", "Доступность", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоляРазмер()
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьДоступностьПоляРазмер(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.ДокументОснование = Неопределено;
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект, "УдержанияПредставлениеРабочегоМеста");
	ЗарплатаКадрыРасширенный.УстановитьПредставленияРабочихМест(ЭтотОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура УдержаниеПриИзмененииНаСервере()
	
	Объект.ДокументОснование = Неопределено;
	Объект.ПрофсоюзнаяОрганизация = Неопределено;
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыУдержаний();
	ЗарплатаКадрыРасширенный.ВводНачисленийВШапкеВидРасчетаПриИзменении(ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1);
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьПоказателей(Элементы, Объект.Удержание, "УдержанияПоказатели");
	РасчетЗарплатыРасширенныйФормы.ДокументыПлановыхУдержанийУстановитьВидимостьРазмера(Элементы, Объект.Удержание, "УдержанияРазмер");
	
	УстановитьДоступностьДокументаОснования();
	
	Если Объект.Действие = Перечисления.ДействияСУдержаниями.Начать Тогда 
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьКонтрагентаВФормеДокументаПоУдержанию(ЭтотОбъект, "ПрофсоюзнаяОрганизация", Объект.Удержание);
	КонецЕсли;
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	
КонецПроцедуры

&НаСервере
Процедура ДействиеПриИзмененииНаСервере()
	
	УстановитьСтраницуДействия();
	УстановитьДоступностьДокументаОснования();
	УстановитьДоступностьПоляДатаОкончания();
	УстановитьДоступностьПоляРазмер();
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьРазмерПриПрекращенииУдержания(ЭтотОбъект, ОписаниеТаблицыУдержаний());
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	
	Объект.ПрофсоюзнаяОрганизация = Неопределено;
	
	Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ЗаполнитьМассивДоступныхФизическихЛиц();
		УстановитьПараметрыВыбораФизическихЛиц();
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	УдержаниеПрофсоюзныхВзносовУдержания.ФизическоеЛицо,
	               |	УдержаниеПрофсоюзныхВзносовУдержания.Размер,
	               |	УдержаниеПрофсоюзныхВзносовУдержания.ИдентификаторСтрокиВидаРасчета
	               |ИЗ
	               |	Документ.УдержаниеПрофсоюзныхВзносов.Удержания КАК УдержаниеПрофсоюзныхВзносовУдержания
	               |ГДЕ
	               |	УдержаниеПрофсоюзныхВзносовУдержания.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УдержаниеПрофсоюзныхВзносовПоказатели.Показатель,
	               |	УдержаниеПрофсоюзныхВзносовПоказатели.Значение,
	               |	УдержаниеПрофсоюзныхВзносовПоказатели.ИдентификаторСтрокиВидаРасчета
	               |ИЗ
	               |	Документ.УдержаниеПрофсоюзныхВзносов.Показатели КАК УдержаниеПрофсоюзныхВзносовПоказатели
	               |ГДЕ
	               |	УдержаниеПрофсоюзныхВзносовПоказатели.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УдержаниеПрофсоюзныхВзносов.ПрофсоюзнаяОрганизация,
	               |	УдержаниеПрофсоюзныхВзносов.Удержание
	               |ИЗ
	               |	Документ.УдержаниеПрофсоюзныхВзносов КАК УдержаниеПрофсоюзныхВзносов
	               |ГДЕ
	               |	УдержаниеПрофсоюзныхВзносов.Ссылка = &Ссылка";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатыЗапроса[0].Выбрать();			   
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(Объект.Удержания.Добавить(), Выборка);
	КонецЦикла;
	
	Выборка = РезультатыЗапроса[1].Выбрать();			   
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(Объект.Показатели.Добавить(), Выборка);
	КонецЦикла;
	
	Выборка = РезультатыЗапроса[2].Выбрать();			   
	Если Выборка.Следующий() Тогда  
		Объект.ПрофсоюзнаяОрганизация = Выборка.ПрофсоюзнаяОрганизация;
		Объект.Удержание = Выборка.Удержание;
	КонецЕсли;
	
	ДанныеВРеквизиты();
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьРазмерПриПрекращенииУдержания(ЭтотОбъект, ОписаниеТаблицыУдержаний());
	
	ЗаполнитьМассивДоступныхФизическихЛиц();
	УстановитьПараметрыВыбораФизическихЛиц();
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ЗарплатаКадрыРасширенный.УстановитьВидимостьПредставленияРабочегоМеста(ЭтотОбъект, "УдержанияПредставлениеРабочегоМеста");
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(ОбщегоНазначения.ВыгрузитьКолонку(Объект.Удержания, "ФизическоеЛицо"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОбработкаПодбораНаСервере(ВыбранныеФизическиеЛица)
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомОбработкаПодбораНаСервере(ЭтотОбъект, ВыбранныеФизическиеЛица);
	ЗарплатаКадрыРасширенный.УстановитьПредставленияРабочихМест(ЭтотОбъект);	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	ЗарплатаКадрыРасширенный.УстановитьПредставленияРабочихМест(ЭтотОбъект);	
	ЗарплатаКадрыРасширенный.ВводНачисленийДанныеВРеквизит(ЭтотОбъект, ОписаниеТаблицыУдержаний(), 1);
	
КонецПроцедуры

&НаСервере
Процедура РеквизитыВДанные(ТекущийОбъект)
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомРеквизитыВДанные(ЭтотОбъект, ТекущийОбъект, ОписаниеТаблицыУдержаний());
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьМассивДоступныхФизическихЛиц()
	
	ФизическиеЛица = Новый Массив;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда 
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	УдержаниеПрофсоюзныхВзносовУдержания.ФизическоеЛицо
		               |ИЗ
		               |	Документ.УдержаниеПрофсоюзныхВзносов.Удержания КАК УдержаниеПрофсоюзныхВзносовУдержания
		               |ГДЕ
		               |	УдержаниеПрофсоюзныхВзносовУдержания.Ссылка = &Ссылка";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			ФизическиеЛица.Добавить(Выборка.ФизическоеЛицо);
		КонецЦикла;
		
	КонецЕсли;
	
	МассивФизическихЛиц = Новый ФиксированныйМассив(ФизическиеЛица);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораФизическихЛиц()
	
	РасчетЗарплатыРасширенныйФормы.УдержанияСпискомУстановитьПараметрыВыбораФизическихЛиц(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыУдержаний()
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.ИмяТаблицы = "Удержания";
	ОписаниеТаблицы.ПутьКДанным = "Объект.Удержания";
	ОписаниеТаблицы.ИмяРеквизитаВидРасчета = "Удержание";
	ОписаниеТаблицы.СодержитПолеВидРасчета = Ложь;
	ОписаниеТаблицы.СодержитПолеСотрудник = Истина;
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "ФизическоеЛицо";
	ОписаниеТаблицы.ЭтоПлановыеНачисленияУдержания = Истина;
	
	Возврат ОписаниеТаблицы;	
	
КонецФункции	

&НаСервере
Процедура ОбработатьИзменениеПоказателейНаСервере(ЗначенияПоказателей)
	
	ВидРасчетаИнфо = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(Объект.Удержание);
	ФиксированнаяСумма = ЗначенияПоказателей[Справочники.ПоказателиРасчетаЗарплаты.ПустаяСсылка()];
	
	Для Каждого СтрокаСотрудника Из Объект.Удержания Цикл
		
		Если ФиксированнаяСумма = Неопределено Тогда
			
			МаксимальноеЧислоПоказателей = ВидРасчетаИнфо.КоличествоПостоянныхПоказателей;
			Для Сч = 1 По МаксимальноеЧислоПоказателей Цикл
				
				Показатель = СтрокаСотрудника["Показатель" + Сч];
				Если Не ЗначениеЗаполнено(Показатель) Тогда 
					Прервать;
				КонецЕсли;
				
				ЗначениеПоказателя = ЗначенияПоказателей[Показатель];
				Если ЗначениеПоказателя <> Неопределено Тогда 
					СтрокаСотрудника["Значение" + Сч] = ЗначениеПоказателя;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе 
			
			СтрокаСотрудника.Размер = ФиксированнаяСумма;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УдержанияФизическоеЛицоПриИзмененииНаСервере()
	
	ТекущиеДанные = Объект.Удержания.НайтиПоИдентификатору(Элементы.Удержания.ТекущаяСтрока);
	ЗарплатаКадрыРасширенный.РабочиеМестаУдержанийПриИзмененииФизическогоЛица(ЭтотОбъект, ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура УдержанияПредставлениеРабочегоМестаНачалоВыбораНаСервере(ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка) 
	
	ЗарплатаКадрыРасширенный.РабочиеМестаУдержанийНачалоВыбораРабочегоМеста(ЭтотОбъект, ФизическоеЛицо, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	МассивТаблиц = Новый Массив;
	МассивТаблиц.Добавить("Объект.Удержания");
	МассивТаблиц.Добавить("Объект.Показатели");
	
	Возврат МассивТаблиц;
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",			НСтр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Удержание",				НСтр("ru = 'удержания'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Действие",				НСтр("ru = 'действия'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "ДокументОснование",		НСтр("ru = 'основания'")));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецОбласти
