
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Модифицированность = Ложь;
	
	СтруктураДокумента = Новый Структура;
	СтруктураДокумента.Вставить("Серия",       СокрЛП(Серия));
	СтруктураДокумента.Вставить("Номер",       СокрЛП(Номер));
	СтруктураДокумента.Вставить("ДатаВыдачи",  ДатаВыдачи);
	СтруктураДокумента.Вставить("КемВыдан",    СокрЛП(КемВыдан));
	СтруктураДокумента.Вставить("ДействуетС",  ДействуетС);
	СтруктураДокумента.Вставить("ДействуетПо", ДействуетПо);
	
	Закрыть(СтруктураДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Серия       = Параметры.СтруктураДокумента.Серия;
	Номер       = Параметры.СтруктураДокумента.Номер;
	ДатаВыдачи  = Параметры.СтруктураДокумента.ДатаВыдачи;
	КемВыдан    = Параметры.СтруктураДокумента.КемВыдан;
	ДействуетС  = Параметры.СтруктураДокумента.ДействуетС;
	ДействуетПо = Параметры.СтруктураДокумента.ДействуетПо;
	
КонецПроцедуры

#КонецОбласти