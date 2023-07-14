
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	МногофункциональныеДокументыБЗКФормы.УстановитьВидимостьКомандыУтвердитьВСписке(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.УстановитьУсловноеОформлениеСпискаМногофункциональныхДокументов(ЭтаФорма);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументов = ОбщегоНазначения.ОбщийМодуль("УчетОригиналовПервичныхДокументов");
		МодульУчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект, Элементы.Список, Элементы.Ответственный);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.КоманднаяПанельФормы);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Список);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетОригиналовПервичныхДокументовКлиент");
		МодульУчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаСписка(ИмяСобытия, ЭтотОбъект, Элементы.Список);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещенияВФормеСписка(
		ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетОригиналовПервичныхДокументовКлиент");
		МодульУчетОригиналовПервичныхДокументовКлиент.СписокВыбор(Поле.Имя, ЭтотОбъект, Элементы.Список, СтандартнаяОбработка);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьКомандыУтвердитьВМногофункциональныхДокументах(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументов = ОбщегоНазначения.ОбщийМодуль("УчетОригиналовПервичныхДокументов");
		МодульУчетОригиналовПервичныхДокументов.ПриПолученииДанныхНаСервере(Строки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// КадровыйЭДО
	КадровыйЭДО.СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	// Конец КадровыйЭДО
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Утвердить(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.УтвердитьВыделенныеМногофункциональныеДокументы(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()
	
	ОбновитьКомандыСостоянияОригинала()
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыСостоянияОригинала()
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры
//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

// БлокировкаИзмененияОбъектов
&НаКлиенте
Процедура Подключаемый_РазблокироватьОбъекты(Команда)
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьОбъектыСписка(ЭтотОбъект, Список, Элементы.Список.ВыделенныеСтроки);
КонецПроцедуры
// Конец БлокировкаИзмененияОбъектов

#КонецОбласти
