#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СокращенноеНаименованиеКонфигурации = ИнтеграцияС1СДокументооборот.СокращенноеНаименованиеКонфигурации();
	Если ЗначениеЗаполнено(СокращенноеНаименованиеКонфигурации) Тогда
		Элементы.ПравилаИнтеграцииПредставлениеОбъектаИС.Заголовок 
			= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Объект %1'"), СокращенноеНаименованиеКонфигурации);
	КонецЕсли;
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КоличествоОбъектов < 12 Тогда
		Для Каждого Элемент Из ДеревоОбъектов.ПолучитьЭлементы() Цикл
			Элементы.ДеревоОбъектов.Развернуть(Элемент.ПолучитьИдентификатор());
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтеграцияС1СДокументооборотом_ИзмененоПравило"
			Или ИмяСобытия = "ИнтеграцияС1СДокументооборотом_СозданоПравило" Тогда
		ЗаполнитьВДеревеПризнакВключена();
		УстановитьДоступностьКоманд(Элементы.ДеревоОбъектов.ТекущиеДанные);
		УстановитьОтборПравилИнтеграции(Элементы.ДеревоОбъектов.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОбъектов

&НаКлиенте
Процедура ДеревоОбъектовПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд(Элементы.ДеревоОбъектов.ТекущиеДанные);
	УстановитьОтборПравилИнтеграции(Элементы.ДеревоОбъектов.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПравилаИнтеграции

&НаКлиенте
Процедура ПравилаИнтеграцииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ДеревоОбъектов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаИС", ТекущиеДанные.ИмяТипаОбъекта);
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.ПравилаИнтеграции.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ФормаЭлемента",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаИнтеграцииПриИзменении(Элемент)
	
	ЗаполнитьВДеревеПризнакВключена();
	УстановитьДоступностьКоманд(Элементы.ДеревоОбъектов.ТекущиеДанные);
	УстановитьОтборПравилИнтеграции(Элементы.ДеревоОбъектов.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Настроить(Команда)
	
	Если Элементы.ДеревоОбъектов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоОбъектов.ТекущиеДанные;
	Если ТекущиеДанные.Включена Тогда
		Возврат;
	КонецЕсли;
	Если ТекущиеДанные.Автонастройка Тогда
		НастроитьАвтоматически(ТекущиеДанные);
	Иначе
		НастроитьВручную(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПереключитьПоказатьУдаленныеПравилаИнтеграции(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказатьУдаленныеПравилаИнтеграции.Пометка = ПоказыватьУдаленные;
	УстановитьОтборПравилИнтеграции(Элементы.ДеревоОбъектов.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет дерево и проставляет в нем признак Включена.
&НаСервере
Процедура ЗаполнитьДерево()
	
	КоличествоОбъектов = ЗаполнитьДеревоМетаданными();
	ЗаполнитьВДеревеПризнакВключена();

КонецПроцедуры

// Заполняет дерево объектами и подсистемами согласно метаданным.
//
&НаСервере
Функция ЗаполнитьДеревоМетаданными()
	
	Дерево = РеквизитФормыВЗначение("ДеревоОбъектов");
	Дерево.Строки.Очистить();
	
	// Преобразуем описание типов параметра команды в массив объектов метаданных.
	Типы = ИнтеграцияС1СДокументооборотПовтИсп.ТипыОбъектовПоддерживающихИнтеграцию();
	ОбъектыМетаданных = Новый СписокЗначений;
	Для Каждого Тип Из Типы Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		ОбъектыМетаданных.Добавить(ОбъектМетаданных, ОбъектМетаданных.Представление());
	КонецЦикла;
	ОбъектыМетаданных.СортироватьПоПредставлению();
	
	ОбъектыСАвтоматическойНастройкой = Новый ТаблицаЗначений;
	ОбъектыСАвтоматическойНастройкой.Колонки.Добавить("ИмяТипаОбъекта");
	ОбъектыСАвтоматическойНастройкой.Колонки.Добавить("ОписаниеВыполняемыхДействий");
	ИнтеграцияС1СДокументооборотПереопределяемый.ПриОпределенииОбъектовПоддерживающихАвтонастройку(ОбъектыСАвтоматическойНастройкой);
	
	ОбработатьПодсистемы(Метаданные.Подсистемы,
		Дерево.Строки,
		ОбъектыМетаданных,
		ОбъектыСАвтоматическойНастройкой,
		NULL,
		Истина);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоОбъектов");
	
	Возврат ОбъектыМетаданных.Количество();
	
КонецФункции

// Рекурсивно добавляет подсистемы из переданной коллекции, если они содержат указанные объекты
// метаданных, и возвращает Истина, если добавлена хотя бы одна.
//
&НаСервере
Функция ОбработатьПодсистемы(Подсистемы, СтрокиДерева, ОбъектыМетаданных, ОбъектыСАвтоматическойНастройкой,
	Автонастройка, ТолькоВключаемыеВКомандныйИнтерфейс = Ложь)
	
	Результат = Ложь;
	
	Для Каждого Подсистема Из Подсистемы Цикл
		
		Если СтрНачинаетсяС(Подсистема.Имя, "Удалить") Тогда
			Продолжить;
		КонецЕсли;
		
		Отказ = Ложь;
		Если ТолькоВключаемыеВКомандныйИнтерфейс
			И Не Подсистема.ВключатьВКомандныйИнтерфейс Тогда
			Отказ = Истина;
		КонецЕсли;
		
		ИнтеграцияС1СДокументооборотПереопределяемый.ПриДобавленииПодсистемыВДеревоИнтегрируемыхОбъектов(
			Подсистема,
			Отказ);
			
		Если Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПодсистемы = СтрокиДерева.Добавить();
		СтрокаПодсистемы.ИмяПодсистемы = Подсистема.Имя;
		СтрокаПодсистемы.ПредставлениеПодсистемы = Подсистема.Представление();
		СтрокаПодсистемы.ЭтоГруппа = Истина;
		СтрокаПодсистемы.Автонастройка = NULL;
		
		СтрокиПодсистемы = СтрокаПодсистемы.Строки;
		
		ПодсистемаНужна = ОбработатьПодсистемы(Подсистема.Подсистемы,
			СтрокиПодсистемы,
			ОбъектыМетаданных,
			ОбъектыСАвтоматическойНастройкой,
			СтрокаПодсистемы.Автонастройка);
		
		Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
			Если СтрНачинаетсяС(ОбъектМетаданных.Значение.Имя, "Удалить") Тогда
				Продолжить;
			КонецЕсли;
			Если Подсистема.Состав.Содержит(ОбъектМетаданных.Значение) Тогда
				ПодсистемаНужна = Истина;
				СтрокаОбъекта = СтрокиПодсистемы.Добавить();
				СтрокаОбъекта.ИмяТипаОбъекта = ОбъектМетаданных.Значение.ПолноеИмя();
				СтрокаОбъекта.ПредставлениеОбъекта = ОбъектМетаданных.Значение.Представление();
				СтрокаАвтонастройка = ОбъектыСАвтоматическойНастройкой.Найти(СтрокаОбъекта.ИмяТипаОбъекта, "ИмяТипаОбъекта");
				Если СтрокаАвтонастройка <> Неопределено Тогда
					СтрокаОбъекта.Автонастройка = Истина;
					СтрокаОбъекта.Подсказка = СтрокаАвтонастройка.ОписаниеВыполняемыхДействий;
				Иначе
					СтрокаОбъекта.Автонастройка = Ложь;
				КонецЕсли;
				Если СтрокаПодсистемы.Автонастройка = NULL Тогда
					СтрокаПодсистемы.Автонастройка = СтрокаОбъекта.Автонастройка;
				ИначеЕсли ТипЗнч(СтрокаПодсистемы.Автонастройка) = Тип("Булево")
					И СтрокаПодсистемы.Автонастройка <> СтрокаОбъекта.Автонастройка Тогда
					СтрокаПодсистемы.Автонастройка = Неопределено;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ПодсистемаНужна Тогда
			Результат = Истина;
			Если Автонастройка = NULL Тогда
				Автонастройка = СтрокаПодсистемы.Автонастройка;
			ИначеЕсли ТипЗнч(Автонастройка) = Тип("Булево")
				И Автонастройка <> СтрокаПодсистемы.Автонастройка Тогда
				Автонастройка = Неопределено;
			КонецЕсли;
		Иначе
			СтрокиДерева.Удалить(СтрокаПодсистемы);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Заполняет в дереве признак Включена согласно существованию подходящих правил в ИБ.
//
&НаСервере
Процедура ЗаполнитьВДеревеПризнакВключена()
	
	ЗапросТипыОбъектовСПравилами = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Правила.ТипОбъектаИС КАК ТипОбъектаИС
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом КАК Правила
		|ГДЕ
		|	НЕ Правила.ПометкаУдаления
		|	И Правила.ТипОбъектаДО <> """"
		|");
	ТипыОбъектов = ЗапросТипыОбъектовСПравилами.Выполнить().Выгрузить().
		ВыгрузитьКолонку("ТипОбъектаИС");
	
	ОбработатьСтрокиДерева(ДеревоОбъектов.ПолучитьЭлементы(), ТипыОбъектов);
	
КонецПроцедуры

// Рекурсивно обрабатывает строки дерева, устанавливая признак Включена согласно переданному массиву
// объектов, для которых найдены правила интеграции.
//
&НаСервере
Процедура ОбработатьСтрокиДерева(СтрокиДерева, ТипыОбъектов)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			ОбработатьСтрокиДерева(СтрокаДерева.ПолучитьЭлементы(), ТипыОбъектов);
			
		Иначе
			
			СтрокаДерева.Включена = 
				(ТипыОбъектов.Найти(СтрокаДерева.ИмяТипаОбъекта) <> Неопределено);
				
			Если СтрокаДерева.Включена Тогда
				СтрокаДерева.Картинка = БиблиотекаКартинок.ИнтеграцияВключена;
			ИначеЕсли СтрокаДерева.Автонастройка Тогда
				СтрокаДерева.Картинка = БиблиотекаКартинок.НастроитьИнтеграциюАвтоматически;
			Иначе
				СтрокаДерева.Картинка = Неопределено;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает доступность команд в зависимости от активной строки дерева.
//
&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные)
	
	Элементы.КонтекстНастроитьАвтоматически.Доступность = Ложь;
	Элементы.КонтекстНастроитьВручную.Доступность = Ложь;
	Элементы.Настроить.Доступность = Ложь;
	
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.СтраницыАвтоматическаяРучнаяНастройка.ТекущаяСтраница
			= Элементы.СтраницаПустая;
	
	ИначеЕсли ТекущиеДанные.ЭтоГруппа Тогда
		Элементы.СтраницыАвтоматическаяРучнаяНастройка.ТекущаяСтраница
			= Элементы.СтраницаПодсистема;
		Если ТекущиеДанные.Автонастройка = Истина Тогда
			Подсказка = НСтр("ru = 'Объекты подсистемы поддерживают автоматическую настройку интеграции.'");
		ИначеЕсли ТекущиеДанные.Автонастройка = Ложь Тогда
			Подсказка = НСтр("ru = 'Интеграция по объектам подсистемы настраивается вручную.'");
		Иначе
			Подсказка = НСтр("ru = 'Некоторые объекты подсистемы поддерживают автоматическую настройку интеграции.'");
		КонецЕсли;
	
	ИначеЕсли ТекущиеДанные.Включена Тогда
		Элементы.СтраницыАвтоматическаяРучнаяНастройка.ТекущаяСтраница
			= Элементы.СтраницаИнтеграцияНастроена;
	
	Иначе
		Элементы.Настроить.Доступность = Истина;
		Если ТекущиеДанные.Автонастройка = Истина Тогда
			Элементы.СтраницыАвтоматическаяРучнаяНастройка.ТекущаяСтраница
				= Элементы.СтраницаНастроитьАвтоматически;
			Элементы.КонтекстНастроитьАвтоматически.Доступность = Истина;
			Если ЗначениеЗаполнено(ТекущиеДанные.Подсказка) Тогда
				Подсказка = ТекущиеДанные.Подсказка;
			Иначе
				Подсказка = ОписаниеВыполняемыхДействийПоУмолчанию();
			КонецЕсли;
		
		Иначе // вручную
			Элементы.СтраницыАвтоматическаяРучнаяНастройка.ТекущаяСтраница
				= Элементы.СтраницаНастроитьВручную;
			Элементы.КонтекстНастроитьВручную.Доступность = Истина;
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает параметры отбора динамического списка правил интеграции.
//
&НаКлиенте
Процедура УстановитьОтборПравилИнтеграции(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено
		Или ТекущиеДанные.ЭтоГруппа Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ПравилаИнтеграции,
			"ТипОбъектаИС",
			Неопределено,
			Истина);
			
	Иначе
			
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ПравилаИнтеграции,
			"ТипОбъектаИС",
			ТекущиеДанные.ИмяТипаОбъекта,
			Истина);
			
	КонецЕсли;
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаИнтеграции,
			"ПометкаУдаления", Ложь,,,Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПравилаИнтеграции,
			"ПометкаУдаления", Ложь,,,Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеВыполняемыхДействийПоУмолчанию()
	
	Возврат НСтр("ru = 'Будет автоматически создано правило интеграции.
		|В 1С:Документообороте будет создан соответствующий вид документа.'");
	
КонецФункции

&НаКлиенте
Процедура НастроитьАвтоматически(ТекущиеДанные)
	
	ИмяТипаОбъекта = ТекущиеДанные.ИмяТипаОбъекта;
	ОписаниеВыполняемыхДействий = ТекущиеДанные.Подсказка;
	Если Не ЗначениеЗаполнено(ОписаниеВыполняемыхДействий) Тогда
		ОписаниеВыполняемыхДействий = ОписаниеВыполняемыхДействийПоУмолчанию();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьАвтоматическиПродолжение", ЭтотОбъект, ИмяТипаОбъекта);
	
	ТекстВопроса = ОписаниеВыполняемыхДействий
		+ ?(СтрЗаканчиваетсяНа(ОписаниеВыполняемыхДействий, "."), "", ".")
		+ Символы.ПС
		+ НСтр("ru = 'Продолжить?'");
		
	ИнтеграцияС1СДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВручную(ТекущиеДанные)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаИС", ТекущиеДанные.ИмяТипаОбъекта);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ФормаЭлемента",
		ПараметрыФормы,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьАвтоматическиПродолжение(Результат, ИмяТипаОбъекта) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиент.НачатьАвтоматическуюНастройкуИнтеграции(ИмяТипаОбъекта);
	
КонецПроцедуры

#КонецОбласти