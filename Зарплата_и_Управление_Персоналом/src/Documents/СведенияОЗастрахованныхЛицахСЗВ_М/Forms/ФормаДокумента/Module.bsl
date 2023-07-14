#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
		Объект.ОтчетныйПериод = Макс('20160401', Объект.ОтчетныйПериод);
		ПерсонифицированныйУчет.ЗаполнитьДанныеРуководителя(Объект);
		
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
		ПриПолученииДанныхНаСервере(ТекущийОбъект);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаПечатьПереопределенная;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
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
	
	// ПанельОтправкиВКонтролирующиеОрганы
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");
	// Конец ПанельОтправкиВКонтролирующиеОрганы
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Завершение отправки в контролирующий орган" 
		И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Ссылка = Объект.Ссылка Тогда
	    ПослеОтправкиВПФР();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
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
	
	// ПанельОтправкиВКонтролирующиеОрганы
	СохранитьСтатусОтправки(ЭтотОбъект, Объект.Ссылка);
	// Конец ПанельОтправкиВКонтролирующиеОрганы
	
	УстановитьДоступностьДанныхФормы();
	
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
	Оповестить("Запись_СведенияОЗастрахованныхЛицахСЗВ_М", ПараметрыЗаписи, Объект.Ссылка);
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
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ОтчетныйПериод", "ОтчетныйПериодПредставление", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ОтчетныйПериод", "ОтчетныйПериодПредставление");
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ОтчетныйПериод", "ОтчетныйПериодПредставление", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ФлагБлокировкиДокументаПриИзменении(Элемент)
	ФлагБлокировкиДокументаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	ИдентификаторыСтрок = Новый Массив;
	ИдентификаторыСтрок.Добавить(Элементы.Сотрудники.ТекущаяСтрока);	
	ЗаполнитьДанныеСотрудников(ИдентификаторыСтрок);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСтраховойНомерПФРПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПерсонифицированныйУчетКлиентСервер.УстановитьФорматСтраховогоНомераПФР(ТекущиеДанные.СтраховойНомерПФР);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторыСтрок = Новый Массив;
	
	Для Каждого Сотрудник Из ВыбранноеЗначение Цикл
		НоваяСтрока = Объект.Сотрудники.Добавить();
		НоваяСтрока.Сотрудник = Сотрудник;
		
		ИдентификаторыСтрок.Добавить(НоваяСтрока.ПолучитьИдентификатор());
	КонецЦикла;
	
	ЗаполнитьДанныеСотрудников(ИдентификаторыСтрок);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПерсонифицированныйУчетКлиент.ПодобратьФизическихЛиц(Элементы.Сотрудники, ОрганизацияДляПодбора, АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ОчиститьСообщения();	
	Отказ = Ложь;
	ЕстьКритичныеОшибки = Ложь;
	
	ПроверитьНаСервере(Отказ, ЕстьКритичныеОшибки);
	
	Если ЕстьКритичныеОшибки Тогда 
		ТекстПредупреждения = НСтр("ru = 'Не заполнены обязательные поля.'");
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;		
	
	ПроверкаСтороннимиПрограммами(Отказ);
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Оповещение = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуЗавершение(Результат, Команда) Экспорт
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

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект);	
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);			
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДискЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	Если ДанныеФайла <> Неопределено Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	Оповещение = Новый ОписаниеОповещения("ОтправитьВКонтролирующийОрганЗавершение", ЭтотОбъект);	
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрганЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ПФР");	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ПФР");	
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

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПФР"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьСтатусОтправки(Форма, Ссылка)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Форма", Форма);
	СтруктураПараметров.Вставить("СсылкаНаОбъект", Ссылка);
	
	ИнтерфейсыВзаимодействияБРО.СохранитьСтатусОтправки(СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ДанныеОбъектаВДанныеФормы(ТекущийОбъект);
	УстановитьДоступностьДанныхФормы();
	УстановитьСвойстваЭлементовФормы();
	ЗаполнитьОрганизациюДляПодбораСотрудников(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ДанныеОбъектаВДанныеФормы(ТекущийОбъект)
	
	ФлагБлокировкиДокумента = Объект.ДокументПринятВПФР;	
	ОтправленВПФР = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ОбъектОтправлялсяВКонтролирующиеОрганы(Объект.Ссылка);
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "Объект.ОтчетныйПериод", "ОтчетныйПериодПредставление");
	
КонецПроцедуры

&НаСервере
Процедура ПослеОтправкиВПФР()
	
	ОтправленВПФР = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ОбъектОтправлялсяВКонтролирующиеОрганы(Объект.Ссылка);
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьДанныхФормы()
	Если Объект.ДокументПринятВПФР Тогда  
		ТолькоПросмотр = Истина;	
	КонецЕсли;		
КонецПроцедуры

&НаСервере
Процедура  УстановитьСвойстваЭлементовФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "ТолькоПросмотр", ОтправленВПФР);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетныйПериодПредставление", "ТолькоПросмотр", ОтправленВПФР);
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	ЗапрашиваемыеЗначения.Вставить("ПредыдущийМесяц", "Объект.ОтчетныйПериод");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Объект.Ответственный");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.Сотрудники.Очистить();
	
	Объект.Руководитель = Справочники.ФизическиеЛица.ПустаяСсылка();
	Объект.ДолжностьРуководителя = Справочники.Должности.ПустаяСсылка();
	
	ПерсонифицированныйУчет.ЗаполнитьДанныеРуководителя(Объект);
	Объект.ОтчетныйПериод = Макс('20160401', Объект.ОтчетныйПериод);
	
	Объект.ИмяФайлаДляПФР = Документы.СведенияОЗастрахованныхЛицахСЗВ_М.ИмяФайла(Объект.Организация, Объект.Дата);
	
	ЗаполнитьОрганизациюДляПодбораСотрудников(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ФлагБлокировкиДокументаПриИзмененииНаСервере()
	Модифицированность = Истина;
	Объект.ДокументПринятВПФР = ФлагБлокировкиДокумента;
	Если Не ФлагБлокировкиДокумента Тогда
		ТолькоПросмотр = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	ДанныеДляЗаполнения = Документы.СведенияОЗастрахованныхЛицахСЗВ_М.ДанныеДляЗаполнения(Объект);	
	
	Объект.Сотрудники.Очистить();
	
	Объект.Сотрудники.Загрузить(ДанныеДляЗаполнения);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСотрудников(ИдентификаторыЗаполняемыхСтрок)
	ЗаполняемыеСтроки   = Новый Массив;
	СписокФизическихЛиц = Новый Массив;
	
	Для Каждого ИдентификаторСтроки Из ИдентификаторыЗаполняемыхСтрок Цикл
		ДанныеСтроки = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Если ДанныеСтроки <> Неопределено Тогда 	
			Если ЗначениеЗаполнено(ДанныеСтроки.Сотрудник) Тогда	
				ЗаполняемыеСтроки.Добавить(ДанныеСтроки);
				СписокФизическихЛиц.Добавить(ДанныеСтроки.Сотрудник);
			Иначе
				ЗаполнитьДанныеСтрокиПустымиЗначениями(ДанныеСтроки);	
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	
	ДанныеДляЗаполнения = Документы.СведенияОЗастрахованныхЛицахСЗВ_М.ДанныеФизическихЛицПоСпискуЗначений(СписокФизическихЛиц, Объект.Дата);
	ДанныеДляЗаполнения.Индексы.Добавить("Сотрудник");
	
	Для Каждого ЗаполняемаяСтрока Из ЗаполняемыеСтроки Цикл
		ДанныеПоФизическомуЛицу = ДанныеДляЗаполнения.НайтиСтроки(Новый Структура("Сотрудник", ЗаполняемаяСтрока.Сотрудник));
		
		Если ДанныеПоФизическомуЛицу.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(ЗаполняемаяСтрока, ДанныеПоФизическомуЛицу[0]);	
		Иначе
			ЗаполнитьДанныеСтрокиПустымиЗначениями(ЗаполняемаяСтрока);		
		КонецЕсли;		
	КонецЦикла;		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСтрокиПустымиЗначениями(ДанныеСтроки)
	ДанныеСтроки.Фамилия = "";
	ДанныеСтроки.Имя = "";
	ДанныеСтроки.Отчество = "";
	ДанныеСтроки.ИНН = "";
	ДанныеСтроки.СтраховойНомерПФР = "";
КонецПроцедуры	

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьОрганизациюДляПодбораСотрудников(ТекущийОбъект)
	ОрганизацияДляПодбора.Очистить();
	Если УчетСтраховыхВзносов.ОрганизацияОтчитываетсяПоВзносамСамостоятельно(ТекущийОбъект.Организация, ТекущийОбъект.ОтчетныйПериод) Тогда
		Для каждого Организация Из УчетСтраховыхВзносов.ОрганизацииДляКонсолидацииОтчетовПоВзносам(ТекущийОбъект.Организация, ТекущийОбъект.ОтчетныйПериод) Цикл
			ОрганизацияДляПодбора.Добавить(Организация)
		КонецЦикла;
	Иначе 	
		ОрганизацияДляПодбора.Добавить(ТекущийОбъект.Организация)
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаСервере(Отказ = Ложь, ЕстьКритичныеОшибки = Ложь)
		
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ПроверитьОбязательныеПоля(ЕстьКритичныеОшибки);	
	
	Если ЕстьКритичныеОшибки Тогда
		Возврат;
	КонецЕсли;	
	
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	Объект.ИмяФайлаДляПФР = Документы.СведенияОЗастрахованныхЛицахСЗВ_М.ИмяФайла(Объект.Организация, Объект.Дата);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействия(ОповещениеЗавершения = Неопределено)
	ОчиститьСообщения();
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Не Объект.Проведен Или Модифицированность Тогда 
		ТекстВопроса = НСтр("ru = 'Для выполнения команды необходимо предварительно провести документ. Выполнить проведение документа и продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияПродолжение", ЭтотОбъект, ДополнительныеПараметры);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияПродолжение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияПродолжение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если Не Объект.Проведен Или Модифицированность Тогда
		Если Не Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение)) Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Отказ = Ложь;
	ЕстьКритичныеОшибки = Ложь;
	
	ПроверитьНаСервере(Отказ, ЕстьКритичныеОшибки);	
	
	Если ЕстьКритичныеОшибки Тогда 
		ТекстПредупреждения = НСтр("ru = 'Не заполнены обязательные поля.'");
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;			
	
	Если Отказ Тогда 
		ТекстВопроса = НСтр("ru = 'В комплекте обнаружены ошибки.
							|Продолжить (не рекомендуется)?'");
							
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение.'"));
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);				
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммами(Отказ)
	
	Если Отказ Тогда
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой обнаружены ошибки.
		|Выполнить проверку сторонними программами?'")
	Иначе	
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой ошибок не обнаружено.
		|Выполнить проверку сторонними программами?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаСтороннимиПрограммамиЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммамиЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ПроверитьСтороннимиПрограммами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтороннимиПрограммами()
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ПроверяемыеОбъекты = Новый Массив;
	ПроверяемыеОбъекты.Добавить(Объект.Ссылка);
	
	ПараметрыОткрытия.Вставить("СсылкиНаПроверяемыеОбъекты", ПроверяемыеОбъекты);
	
	ОткрытьФорму("ОбщаяФорма.ПроверкаФайловОтчетностиПерсУчетаПФР", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);	
КонецФункции

#КонецОбласти
