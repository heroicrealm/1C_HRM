#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры["Наименование"];
	ID = Параметры.ID;
	Тип = Параметры.Тип;
	
	Внес = Параметры.Внес;
	ВнесТип = Параметры.ВнесТип;
	ВнесID = Параметры.ВнесID;
	
	СогласующееЛицо = Параметры.СогласующееЛицо;
	СогласующееЛицоТип = Параметры.СогласующееЛицоТип;
	СогласующееЛицоID = Параметры.СогласующееЛицоID;
	
	Если ЗначениеЗаполнено(ВнесID)
		И СогласующееЛицоID <> ВнесID Тогда
		Элементы.СогласующееЛицо.Подсказка = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Внес: %1'"),
				Внес);
	КонецЕсли;
	
	Результат = Параметры.Результат;
	РезультатТип = Параметры.РезультатТип;
	РезультатID = Параметры.РезультатID;
	
	Дата = Параметры.Дата;
	Комментарий = Параметры.Комментарий;
	
КонецПроцедуры

#КонецОбласти