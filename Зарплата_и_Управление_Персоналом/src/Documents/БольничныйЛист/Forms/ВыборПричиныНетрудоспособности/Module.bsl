#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗакрыватьПриВыборе = Истина;
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
	Параметры.Свойство("ДатаНачалаСобытия",             ДатаНачалаСобытия);
	Параметры.Свойство("НомерЛисткаНетрудоспособности", НомерЛН);
	Параметры.Свойство("КодПричиныНетрудоспособности",  КодПричины);
	Параметры.Свойство("ПричинаНетрудоспособности",     Причина);
	Параметры.Свойство("СлучайУходаЗаБольнымРебенком",  СлучайУхода);
	
	Если Не ЗначениеЗаполнено(КодПричины) И ЗначениеЗаполнено(Причина) Тогда
		КодПричины = Перечисления.ПричиныНетрудоспособности.КодПричины(
			Причина,
			СлучайУхода);
	КонецЕсли;
	Если ЗначениеЗаполнено(КодПричины) И Не ЗначениеЗаполнено(Причина) Тогда
		НаименьшийВозрастПоУходу = ОбменЛисткамиНетрудоспособностиФСС.НаименьшийВозрастПоУходу(Параметры);
		Причина = УчетПособийСоциальногоСтрахования.ПричинаНетрудоспособности(
			КодПричины,
			НаименьшийВозрастПоУходу);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		Элементы.ДатаНачалаСобытия.Видимость = Ложь;
		Элементы.ДатаНачалаСобытияНадпись.Заголовок = Элементы.ДатаНачалаСобытия.Заголовок + ": "
			+ Формат(ДатаНачалаСобытия, "ДЛФ=DD");
	Иначе
		Элементы.ДатаНачалаСобытияНадпись.Видимость = Ложь;
	КонецЕсли;
	
	// Загрузка причин нетрудоспособности и настройка высоты таблицы.
	ПричиныНетрудоспособности.Загрузить(Перечисления.ПричиныНетрудоспособности.ТаблицаВыбораКодовПричин());
	Элементы.ПричиныНетрудоспособности.ВысотаВСтрокахТаблицы = ПричиныНетрудоспособности.Количество();
	
	// Активация выбранной причины нетрудоспособности.
	УходЗаРебенком = Ложь;
	Фильтр = Новый Структура;
	Если ЗначениеЗаполнено(КодПричины) Тогда
		Фильтр.Вставить("КодПричины", КодПричины);
		Если КодПричины = "09" Тогда
			УходЗаРебенком = ЗначениеЗаполнено(Параметры.ПоУходуФИО1) Или ЗначениеЗаполнено(Параметры.ПоУходуФИО2);
			Фильтр.Вставить("УходЗаРебенком", УходЗаРебенком);
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Причина) Тогда
		Фильтр.Вставить("Причина", Причина);
		УходЗаРебенком = (Причина = Перечисления.ПричиныНетрудоспособности.ПоУходуЗаРебенком);
		Фильтр.Вставить("УходЗаРебенком", УходЗаРебенком);
	КонецЕсли;
	Если Фильтр.Количество() > 0 Тогда
		Найденные = ПричиныНетрудоспособности.НайтиСтроки(Фильтр);
		Если Найденные.Количество() > 0 Тогда
			ТекущаяСтрока = Найденные[0];
			Элементы.ПричиныНетрудоспособности.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
			ИдентификаторСтроки = Элементы.ПричиныНетрудоспособности.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	
	// Загрузка случаев ухода.
	СлучаиУхода.Загрузить(Перечисления.СлучаиУходаЗаБольнымиДетьми.ТаблицаВыбора(ДатаНачалаСобытия));
	
	// Загрузка свойств выбранного случая ухода.
	Если УходЗаРебенком И ЗначениеЗаполнено(СлучайУхода) Тогда
		Фильтр = Новый Структура;
		Фильтр.Вставить("СлучайУхода", СлучайУхода);
		Найденные = СлучаиУхода.НайтиСтроки(Фильтр);
		Если Найденные.Количество() > 0 Тогда
			ТекущаяСтрока      = Найденные[0];
			ПолныхЛетПо        = ТекущаяСтрока.ПолныхЛетПо;
			ЭтоСтационарЧислом = Число(ТекущаяСтрока.ЭтоСтационар);
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаНачалаСобытияПриИзменении(Элемент)
	ДатаНачалаСобытияПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПричиныНетрудоспособности

&НаКлиенте
Процедура ПричиныНетрудоспособностиПриАктивизацииСтроки(Элемент)
	Если ИдентификаторСтроки = Элементы.ПричиныНетрудоспособности.ТекущаяСтрока Тогда
		Возврат;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновитьВидимостьДоступностьОтложенно", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПричиныНетрудоспособностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(РезультатВыбора());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ОповеститьОВыборе(РезультатВыбора());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьВидимостьДоступностьОтложенно()
	ОбновитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьДоступность(Форма)
	Форма.ИдентификаторСтроки = Форма.Элементы.ПричиныНетрудоспособности.ТекущаяСтрока;
	Если Форма.ИдентификаторСтроки = Неопределено Тогда
		ТекущаяСтрока = Неопределено;
	Иначе
		ТекущаяСтрока = Форма.ПричиныНетрудоспособности.НайтиПоИдентификатору(Форма.ИдентификаторСтроки);
	КонецЕсли;
	УходЗаРебенком = ?(ТекущаяСтрока = Неопределено, Ложь, ТекущаяСтрока.УходЗаРебенком);
	Форма.Элементы.СведенияОРебенке.Видимость = УходЗаРебенком;
	Если УходЗаРебенком Тогда
		МинВозраст  = 0;
		МаксВозраст = 0;
		СписокВыбораВозрастов = Форма.Элементы.ПолныхЛетПо.СписокВыбора;
		СписокВыбораВозрастов.Очистить();
		Для Каждого СтрокаТаблицы Из Форма.СлучаиУхода Цикл
			Если СтрокаТаблицы.КодПричины <> ТекущаяСтрока.КодПричины Тогда
				Продолжить;
			КонецЕсли;
			Если МаксВозраст <> СтрокаТаблицы.ПолныхЛетПо Тогда
				МинВозраст  = СтрокаТаблицы.ПолныхЛетС;
				МаксВозраст = СтрокаТаблицы.ПолныхЛетПо;
				Если МинВозраст = МаксВозраст Тогда
					Представление = Формат(МинВозраст, "ЧН=; ЧГ=");
				Иначе
					Представление = Формат(МинВозраст, "ЧН=; ЧГ=") + "-" + Строка(МаксВозраст);
				КонецЕсли;
				СписокВыбораВозрастов.Добавить(МаксВозраст, Представление);
			КонецЕсли;
		КонецЦикла;
		Если СписокВыбораВозрастов.НайтиПоЗначению(Форма.ПолныхЛетПо) = Неопределено Тогда
			Форма.ПолныхЛетПо = 0;
		КонецЕсли;
		Если СписокВыбораВозрастов.Количество() = 1 Тогда
			Форма.ПолныхЛетПо = СписокВыбораВозрастов[0].Значение;
		КонецЕсли;
		Форма.Элементы.ГруппаПолныхЛетПо.Видимость = СписокВыбораВозрастов.Количество() > 1;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаСобытияПриИзмененииНаСервере()
	СлучаиУхода.Загрузить(Перечисления.СлучаиУходаЗаБольнымиДетьми.ТаблицаВыбора(ДатаНачалаСобытия));
	ИдентификаторСтроки = Неопределено;
	ОбновитьВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Функция РезультатВыбора()
	// Определение свойств выбранной причины нетрудоспособности.
	ТекущаяСтрока = Элементы.ПричиныНетрудоспособности.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		УходЗаРебенком = Ложь;
		КодПричины     = Неопределено;
		Причина        = Неопределено;
	Иначе
		УходЗаРебенком = ТекущаяСтрока.УходЗаРебенком;
		КодПричины     = ТекущаяСтрока.КодПричины;
		Причина        = ТекущаяСтрока.Причина;
	КонецЕсли;
	
	// Определение выбранного случая ухода за ребенком.
	СлучайУхода = Неопределено;
	Если УходЗаРебенком Тогда
		Фильтр = Новый Структура;
		Фильтр.Вставить("КодПричины",   КодПричины);
		Фильтр.Вставить("ПолныхЛетПо",  ПолныхЛетПо);
		Фильтр.Вставить("ЭтоСтационар", Булево(ЭтоСтационарЧислом));
		Найденные = ФормыБЗККлиентСервер.НайтиСтроки(СлучаиУхода, Фильтр);
		Если Найденные.Количество() > 0 Тогда
			СлучайУхода = Найденные[0].СлучайУхода;
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка структуры возвращаемого значения.
	Результат = Новый Структура;
	Результат.Вставить("КодПричиныНетрудоспособности", КодПричины);
	Результат.Вставить("ПричинаНетрудоспособности",    Причина);
	Результат.Вставить("СлучайУходаЗаБольнымРебенком", СлучайУхода);
	Результат.Вставить("ДатаНачалаСобытия",            ДатаНачалаСобытия);
	Возврат Результат;
КонецФункции

#КонецОбласти
