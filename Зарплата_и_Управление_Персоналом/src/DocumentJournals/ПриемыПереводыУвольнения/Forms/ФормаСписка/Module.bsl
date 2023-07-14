#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформлениеСписка();
	
	МногофункциональныеДокументыБЗКФормы.УстановитьВидимостьКомандыУтвердитьВСписке(ЭтотОбъект);
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник'"));
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "Подразделение",
		Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"), НСтр("ru = 'Подразделение'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
	
	ЗарплатаКадрыРасширенный.СформироватьПодменюСоздатьФормыСпискаДокументов(ЭтаФорма, "ЖурналДокументов.ПриемыПереводыУвольнения");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.КоманднаяПанельФормы);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Список);
	// Конец КадровыйЭДО
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументов = ОбщегоНазначения.ОбщийМодуль("УчетОригиналовПервичныхДокументов");
		МодульУчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект, Элементы.Список, Элементы.Комментарий);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КадровыйУчет.ДистанционнаяРабота") Тогда
		Если ИмяСобытия = "Запись_ПриемНаРаботу" Тогда
			ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
		ИначеЕсли ИмяСобытия = "Запись_ПриемНаРаботуСписком" Тогда
			ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
		ИначеЕсли ИмяСобытия = "Запись_КадровыйПеревод" Тогда
			ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
		ИначеЕсли ИмяСобытия = "Запись_КадровыйПереводСписком" Тогда
			ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещенияВФормеСписка(
		ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетОригиналовПервичныхДокументовКлиент");
		МодульУчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаСписка(ИмяСобытия, ЭтотОбъект, Элементы.Список);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьКомандыУтвердитьВМногофункциональныхДокументах(ЭтаФорма);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
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
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// КадровыйЭДО
	КадровыйЭДО.СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	// Конец КадровыйЭДО
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументов = ОбщегоНазначения.ОбщийМодуль("УчетОригиналовПервичныхДокументов");
		МодульУчетОригиналовПервичныхДокументов.ПриПолученииДанныхНаСервере(Строки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
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
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Утвердить(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.УтвердитьВыделенныеМногофункциональныеДокументы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, КомандыСозданияДокументов.Получить(Команда.Имя).ПолноеИмя);
	
	ЗарплатаКадрыРасширенныйКлиент.СоздатьДокументПоОписанию(ЭтаФорма, Команда.Имя, ПараметрыОткрытия.ЗначенияЗаполнения);
	
КонецПроцедуры

// БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура Подключаемый_РазблокироватьОбъекты(Команда)
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьОбъектыСписка(ЭтотОбъект, Список, Элементы.Список.ВыделенныеСтроки);
КонецПроцедуры

// Конец БлокировкаИзмененияОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамИзСписка(ЭтотОбъект, "Список", Поле, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетОригиналовПервичныхДокументовКлиент");
		МодульУчетОригиналовПервичныхДокументовКлиент.СписокВыбор(Поле.Имя, ЭтотОбъект, Элементы.Список, СтандартнаяОбработка);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

&НаСервере
Процедура УстановитьУсловноеОформлениеСписка()
	
	ЗарплатаКадрыРасширенный.УстановитьУсловноеОформлениеСпискаМногофункциональныхДокументов(ЭтотОбъект);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПозиций") Или Не ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		Возврат;
	КонецЕсли;
	
	УсловноеОформлениеКД = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	УсловноеОформлениеКД.ИдентификаторПользовательскойНастройки = "ОсновноеОформление";

	ТекущийШрифт = Элементы.Список.Шрифт;
	
	ЖирныйШрифт = Новый Шрифт(ТекущийШрифт,,,Истина);
	
	ЭлементОформления = УсловноеОформлениеКД.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru='Выделять бронирование.'");
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("БронированиеПозиции");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Проведен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("БронированиеПозиции");
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", ЖирныйШрифт);
			
КонецПроцедуры

&НаСервере
Процедура НастроитьДинамическийСписокНаСервере(ОписаниеМодификации) Экспорт
	ЗарплатаКадрыРасширенный.НастроитьДинамическийСписокПоОписаниюМодификации(ЭтаФорма, ОписаниеМодификации);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрМодификацииВыбор(Элемент, ИмяПараметра, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ПараметрМодификацииОбработкаНавигационнойСсылки(
		ЭтотОбъект, Элемент.Родитель.Имя, ИмяПараметра);
	
КонецПроцедуры

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

#КонецОбласти
