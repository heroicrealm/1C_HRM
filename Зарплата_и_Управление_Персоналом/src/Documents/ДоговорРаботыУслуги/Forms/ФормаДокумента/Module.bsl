
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ = Документы.ДоговорРаботыУслуги.ПустаяСсылка() Тогда
		
		Объект.СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ОднократноВКонцеСрока;
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			КадровыйУчетРасширенный.УстановитьРольДоговорникСотруднику(Объект.Сотрудник);
		КонецЕсли;
		Объект.СпособРасчетовСФизическимиЛицами = УчетНачисленнойЗарплатыРасширенный.ПорядокУчетаДоговоровГПХ();
		ЗаполнитьДанныеФормыПоОрганизации();
		УстановитьФункциональныеОпцииФормы();
		
	КонецЕсли;
	
	УстановитьПараметрСпискаАктов();
	
	УстановитьВидимостьВводаНаОснованииАкта(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьДоступностьЗакладкиАктов(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьВидимостьДатыДвиженийПФР();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Распределяется = Объект.ОтношениеКЕНВД = Перечисления.ОтношениеКЕНВДЗатратНаЗарплату.ОпределяетсяЕжемесячноПроцентом;
	Если Распределяется Тогда
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВД;
	Иначе
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВДПустая;
	КонецЕсли;
	
	Если Объект.СпособОплаты = Перечисления.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот Тогда
		Элементы.СтраницыВычеты.ТекущаяСтраница = Элементы.СтраницаВычетПоАкту;
	Иначе
		Элементы.СтраницыВычеты.ТекущаяСтраница = Элементы.СтраницаВычет;
	КонецЕсли;
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыОбъекта(ЭтотОбъект, Отказ, СтандартнаяОбработка, Объект);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьДоступностьЭлементаРазмерПлатежа();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УстановитьФункциональныеОпцииФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриЧтенииНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриЧтенииНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, Объект);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВычетИнфоНадпись()
	Если Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот") Тогда
		Элементы.СтраницыВычеты.ТекущаяСтраница = Элементы.СтраницаВычетПоАкту;
	Иначе
		Элементы.СтраницыВычеты.ТекущаяСтраница = Элементы.СтраницаВычет;
	КонецЕсли;
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
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СинхронизацияДанныхЗарплатаКадры.ЗапуститьОтложеннуюОбработкуЗаполненияДанныхПоФизическимЛицам(ТекущийОбъект);
	СинхронизацияДанныхЗарплатаКадры.ЗапуститьОтложеннуюОбработкуЗаполненияДанныхПоСотрудникам(ТекущийОбъект);
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПослеЗаписиНаСервереФормыОбъекта(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Объект);
	// Конец КадровыйЭДО
	
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
	СтруктураПараметровОповещения = Новый Структура;
	СтруктураПараметровОповещения.Вставить("Проведен",          Объект.Проведен);
	СтруктураПараметровОповещения.Вставить("ПомеченНаУдаление", Объект.ПометкаУдаления);
	СтруктураПараметровОповещения.Вставить("Результат",         Объект.Ссылка);
	СтруктураПараметровОповещения.Вставить("Ответственный",     Объект.Ответственный);
	СтруктураПараметровОповещения.Вставить("ДатаДокумента",     Объект.Дата);
	СтруктураПараметровОповещения.Вставить("НомерДокумента",    Объект.Номер);
	СтруктураПараметровОповещения.Вставить("Сотрудник",         Объект.Сотрудник);
	Оповестить("ДокументДоговорРаботыУслугиПослеЗаписи", СтруктураПараметровОповещения, ЭтаФорма);
	Оповестить("Запись_ДоговорРаботыУслуги", ПараметрыЗаписи, Объект.Ссылка);
	
	УстановитьДоступностьЗакладкиАктов(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьПараметрСпискаАктов();
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
	ОбработатьИзменениеОрганизацииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ОбработатьИзменениеДатыДокументаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	Если СотрудникПрежний <> Объект.Сотрудник Тогда
		НовыеНастройкиБухучета = Неопределено;
		ОбработатьИзменениеСотрудникаНаСервереБезКонтекста(Объект.Сотрудник, НовыеНастройкиБухучета);
		ЗаполнитьЗначенияСвойств(Объект, НовыеНастройкиБухучета);
		ОбработатьИзменениеОтношениеКЕНВД();
		СотрудникПрежний = Объект.Сотрудник;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьИзменениеСотрудникаНаСервереБезКонтекста(Сотрудник, НастройкиБухучета)
	КадровыйУчетРасширенный.УстановитьРольДоговорникСотруднику(Сотрудник);
	
	НастройкиБухучета = Новый Структура("Подразделение, Территория, СтатьяФинансирования, СтатьяРасходов, СпособОтраженияЗарплатыВБухучете, ОтношениеКЕНВД");
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, "ТекущееПодразделение, ТекущаяТерритория");
	Если КадровыеДанные.Количество()>0 Тогда
		НастройкиБухучета.Подразделение = КадровыеДанные[0].ТекущееПодразделение;
		НастройкиБухучета.Территория    = КадровыеДанные[0].ТекущаяТерритория;
	КонецЕсли;
	БухучетСотрудника = ОтражениеЗарплатыВБухучетеРасширенный.НастройкаБухучетаЗарплатыСотрудника(Сотрудник, ТекущаяДатаСеанса());
	ЗаполнитьЗначенияСвойств(НастройкиБухучета, БухучетСотрудника);
КонецПроцедуры

&НаКлиенте
Процедура ОтношениеКЕНВДПриИзменении(Элемент)
	ОбработатьИзменениеОтношениеКЕНВД();
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеОтношениеКЕНВД()
	Если Не ПолучитьФункциональнуюОпциюФормы("ПлательщикЕНВДЗарплатаКадры") Тогда
		Возврат;
	КонецЕсли;
	
	Распределяется = Объект.ОтношениеКЕНВД = ПредопределенноеЗначение("Перечисление.ОтношениеКЕНВДЗатратНаЗарплату.ОпределяетсяЕжемесячноПроцентом");
	Если Объект.СуммаЕНВД <> 0 И Не Распределяется Тогда
		Объект.СуммаЕНВД = 0;
	КонецЕсли;
	Если Распределяется Тогда
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВД;
	Иначе
		Элементы.СтраницыЕНВД.ТекущаяСтраница = Элементы.СтраницаЕНВДПустая;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СуммаЕНВДПриИзменении(Элемент)
	ПроверитьСуммуЕНВД();
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	ПроверитьСуммуЕНВД();
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСуммуЕНВД()
	Если Объект.СуммаЕНВД > Объект.Сумма Тогда
		ТекстПредупреждения = НСтр("ru = 'Сумма ЕНВД не может превышать общей суммы вознаграждения по договору.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Объект.СуммаЕНВД = 0;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАкт(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Основание", Объект.Ссылка);
	
	ОткрытьФорму("Документ.АктПриемкиВыполненныхРаботОказанныхУслуг.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// БлокировкаИзмененияОбъектов
&НаКлиенте
Процедура Подключаемый_РазблокироватьФормуОбъекта(Команда)
	
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьФормуОбъекта(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры
// Конец БлокировкаИзмененияОбъектов

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

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
	ОбновитьПодключаемыеКоманды(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

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

// ЗарплатаКадрыПодсистемы.ПодписиДокументов
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент)
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент)
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

&НаКлиенте
Процедура ВариантОплатыПриИзменении(Элемент)
	Если Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот") И Объект.СуммаВычета <> 0 Тогда
		Объект.СуммаВычета = 0;
	КонецЕсли;
	ОбновитьВычетИнфоНадпись();
	УстановитьВидимостьВводаНаОснованииАкта(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьДоступностьЗакладкиАктов(ЭтаФорма, Объект.СпособОплаты);
	
	УстановитьДоступностьЭлементаРазмерПлатежа();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьВводаНаОснованииАкта(Форма, СпособОплаты)
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаСоздатьНаОсновании.ПодчиненныеЭлементы,
		"ФормаДокументАктПриемкиВыполненныхРаботОказанныхУслугСоздатьНаОсновании",
		"Доступность",
		СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот"));
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЗакладкиАктов(Форма, СпособОплаты)
	АктыДоступны = ЗначениеЗаполнено(Форма.Объект.Ссылка) И СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаАкты",
		"Доступность",
		АктыДоступны);
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОрганизацииНаСервере()
	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеДатыДокументаНаСервере()
	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, НачалоДня(Объект.Дата));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
	РасчетЗарплатыРасширенный.ПриОпределенииПараметровФлажкаНеОблагаетсяНДФЛ(Элементы.Найти("НеОблагаетсяНДФЛ"));
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементаРазмерПлатежа()
	Элементы.РазмерПлатежа.Доступность = Объект.СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами");
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрСпискаАктов()
	Акты.Параметры.УстановитьЗначениеПараметра("Договор", Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДатыДвиженийПФР()
	
	Если ЗначениеЗаполнено(Объект.ДатаНачалаПФР) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"НачалоДвиженийПФРКартинкаРасширеннаяПодсказка",
			"Заголовок",
			СтрШаблон("Дата начала движений ПФР - %1", ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(Объект.ДатаНачалаПФР)));
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НачалоДвиженийПФРГруппа",
		"Видимость",
		ЗначениеЗаполнено(Объект.ДатаНачалаПФР));
	
КонецПроцедуры

// КадровыйЭДО
&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПодключаемыеКоманды(УправляемаяФорма)
	
	КадровыйЭДОКлиентСервер.ОбновитьКоманды(УправляемаяФорма, УправляемаяФорма.Объект, Истина);
	
КонецПроцедуры
// Конец КадровыйЭДО

#КонецОбласти
