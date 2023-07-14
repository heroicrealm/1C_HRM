#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - 
//   КлючВарианта - Строка, Неопределено - 
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.ФормироватьСразу = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьОтчет();
	ЗначениеВДанныеФормы(ЭтотОбъект, Форма.Отчет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();

	Попытка
		
		КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
		
		МигрирующиеОбъекты = Новый ТаблицаЗначений;
		МигрирующиеОбъекты.Колонки.Добавить("Объект", ОбщегоНазначения.ОписаниеТипаСтрока(0));
		МигрирующиеОбъекты.Колонки.Добавить("ИмяОбъекта", ОбщегоНазначения.ОписаниеТипаСтрока(0));
		МигрирующиеОбъекты.Колонки.Добавить("Подсистема", ОбщегоНазначения.ОписаниеТипаСтрока(0));
		
		СтандартнаяОбработка = Ложь;
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_МигрирующиеОбъектыРИБ";
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		ДокументРезультат.Очистить();
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
		
		Если КлючВарианта = "ОбъектыРегламентированногоУчета" Тогда
			
			Для Каждого ОбъектРегламентированногоУчета Из СинхронизацияДанныхЗарплатаКадрыСервер.ОбъектыРегламентированногоУчета() Цикл
				НоваяСтрока = МигрирующиеОбъекты.Добавить();
				НоваяСтрока.Объект = ОбъектРегламентированногоУчета;
			КонецЦикла;
			
		ИначеЕсли КлючВарианта = "ОбъектыУправленческогоУчета" Тогда
			
			Для Каждого ОбъектУправленческогоУчета Из СинхронизацияДанныхЗарплатаКадрыСервер.ОбъектыУправленческогоУчета() Цикл
				НоваяСтрока = МигрирующиеОбъекты.Добавить();
				НоваяСтрока.Объект = ОбъектУправленческогоУчета;
			КонецЦикла;
			
		КонецЕсли;
		
		МигрирующиеОбщиеОбъекты = МигрирующиеОбъекты.СкопироватьКолонки();
		Для Каждого ОбщийОбъект Из СинхронизацияДанныхЗарплатаКадрыСервер.ОбщиеОбъекты() Цикл
			НоваяСтрока = МигрирующиеОбщиеОбъекты.Добавить();
			НоваяСтрока.Объект = ОбщийОбъект;
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(МигрирующиеОбщиеОбъекты, МигрирующиеОбъекты);
		ЗаполнитьДанныеОбъектов(МигрирующиеОбъекты);
		МигрирующиеОбъекты.Колонки.Удалить("Объект");
		СтрокиДляУдаления = МигрирующиеОбъекты.НайтиСтроки(Новый Структура("Подсистема", ""));
		Для Каждого СтрокаДляУдаления Из  СтрокиДляУдаления Цикл
			МигрирующиеОбъекты.Удалить(СтрокаДляУдаления);
		КонецЦикла;
		
		ВнешнийНаборДанных = Новый Структура("МигрирующиеОбъекты", МигрирующиеОбъекты); 
		
		// Создадим и инициализируем процессор компоновки.
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных, ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		
		// Обозначим начало вывода
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
		ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
		ДопСвойства.Вставить("ОтчетПустой", ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновки));
		
	Исключение
		ВызватьИсключение НСтр("ru = 'В настройку отчета внесены критичные изменения. Отчет по мигрирующим объектам не будет сформирован.'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеОбъектов(МигрирующиеОбъекты)
	
	СоставПодсистем = СоставПодсистем();
	СоставПодсистем.Сортировать("ПолноеИмяОМ");
	
	Для каждого МигрирующийОбъект Из МигрирующиеОбъекты Цикл
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(МигрирующийОбъект.Объект);
		Если МетаданныеОбъекта = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		МигрирующийОбъект.ИмяОбъекта = МетаданныеОбъекта.Синоним;
		
		Элемент = СоставПодсистем.Найти(МетаданныеОбъекта.ПолноеИмя(), "ПолноеИмяОМ");
		Если Элемент <> Неопределено Тогда
			МигрирующийОбъект.Подсистема = Элемент.ПредставлениеРаздела;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Для внутреннего использования.
Функция СоставПодсистем()
	
	СоставПодсистем = Новый ТаблицаЗначений;
	СоставПодсистем.Колонки.Добавить("ПолноеИмяПодсистемы");
	СоставПодсистем.Колонки.Добавить("ПолноеИмяОМ");
	СоставПодсистем.Колонки.Добавить("ПредставлениеРаздела");
	
	Для Каждого Подсистема Из Метаданные.Подсистемы Цикл
		Если Подсистема.РасширениеКонфигурации() <> Неопределено
			Или Подсистема.Имя = "ПодключаемыеОтчетыИОбработки" Тогда
			Продолжить;
		КонецЕсли;
		Если Не Подсистема.ВключатьВКомандныйИнтерфейс Тогда
			Продолжить;
		КонецЕсли;
		
		ЗарегистрироватьСоставПодсистемы(СоставПодсистем, Подсистема, Подсистема.Представление());
	КонецЦикла;
	
	Возврат СоставПодсистем;
	
КонецФункции

// Для внутреннего использования.
Процедура ЗарегистрироватьСоставПодсистемы(СоставПодсистем, Подсистема, ПредставлениеРаздела)
	
	ПолноеИмяПодсистемы = Подсистема.ПолноеИмя();
	
	// Регистрация вложенных объектов.
	Для Каждого ОбъектМетаданных Из Подсистема.Состав Цикл
		СвязьОбъектаСПодсистемой = СоставПодсистем.Добавить();
		СвязьОбъектаСПодсистемой.ПолноеИмяПодсистемы = ПолноеИмяПодсистемы;
		СвязьОбъектаСПодсистемой.ПолноеИмяОМ = ОбъектМетаданных.ПолноеИмя();
		СвязьОбъектаСПодсистемой.ПредставлениеРаздела = ПредставлениеРаздела;
	КонецЦикла;
	
	// Регистрация вложенных подсистем.
	Для Каждого ВложеннаяПодсистема Из Подсистема.Подсистемы Цикл
		ЗарегистрироватьСоставПодсистемы(СоставПодсистем, ВложеннаяПодсистема, ПредставлениеРаздела);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли