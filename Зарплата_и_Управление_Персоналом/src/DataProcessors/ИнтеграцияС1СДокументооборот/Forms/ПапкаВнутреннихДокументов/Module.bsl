#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ID", ID);
	Тип = "DMInternalDocumentFolder";
	РодительТип = "DMInternalDocumentFolder";
	
	Параметры.Свойство("РодительID", РодительID);
	Параметры.Свойство("Родитель", Родитель);
	
	Если ЗначениеЗаполнено(ID) Тогда
		ЗаполнитьПоОбъектуXDTO(ПолучитьОбъектXDTO());
	Иначе
		ЗаполнитьПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗакрытиеСПараметром Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
		
	Иначе
		
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ЗакрытьСПараметром", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РодительОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(РодительТип, РодительID, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка(
		РодительТип, "Родитель", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РодительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Родитель", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РодительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			РодительТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РодительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			РодительТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Родитель", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка(
		ОтветственныйТип, "Ответственный", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Ответственный", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			ОтветственныйТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			ОтветственныйТип, ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Ответственный", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Не МожноЗаписать() Тогда
		Возврат;
	КонецЕсли;
	ЗаписатьНаСервере();
	ЗакрытьСПараметром();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьОбъект(Команда)
	
	Если Не МожноЗаписать() Тогда
		Возврат;
	КонецЕсли;
	ЗаписатьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция МожноЗаписать()
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ТекущийЭлемент = Элементы.Наименование;
		ПоказатьПредупреждение(, НСтр("ru = 'Не заполнено наименование.'"));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаполнитьИЗаписатьОбъектXDTO();
	ЗакрытьСПараметром();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСПараметром()
	
	Если ЗначениеЗаполнено(ID) Тогда
		Результат = Новый Структура;
		Результат.Вставить("ID", ID);
		Результат.Вставить("Тип", Тип);
		Результат.Вставить("Наименование", Наименование);
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	ЗакрытиеСПараметром = Истина;
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоУмолчанию()
	
	ДатаСоздания = ТекущаяДатаСеанса();
	
	ОтветственныйXDTO = ИнтеграцияС1СДокументооборот.ТекущийПользовательДокументооборота();
	Ответственный = ОтветственныйXDTO.name;
	ОтветственныйID = ОтветственныйXDTO.objectID.ID;
	ОтветственныйТип = ОтветственныйXDTO.objectID.type;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОбъектXDTO()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRetrieveRequest");
	СписокОбъектов = Запрос.objectIDs; // СписокXDTO
	ПолучаемыеПоля = Запрос.columnSet; // СписокXDTO
	
	Для Каждого РеквизитИСвойство Из РеквизитыИСвойства() Цикл
		ПолучаемыеПоля.Добавить(РеквизитИСвойство.Ключ);
	КонецЦикла;
	
	ОбъектИд = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ID, Тип);
	СписокОбъектов.Добавить(ОбъектИд);
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Возврат Результат.objects[0];
	
КонецФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ЗаполнитьПоОбъектуXDTO(ЗаписатьОбъектXDTO(ЗаполнитьОбъектXDTO()));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИЗаписатьОбъектXDTO()
	
	ЗаписатьОбъектXDTO(ЗаполнитьОбъектXDTO());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОбъектуXDTO(ОбъектXDTO)
	
	Наименование = ОбъектXDTO.name;
	ID = ОбъектXDTO.objectID.ID;
	Тип = ОбъектXDTO.objectID.type;
	
	ИнтеграцияС1СДокументооборот.ЗаполнитьФормуИзОбъектаXDTO(ЭтотОбъект,
		ОбъектXDTO,
		РеквизитыИСвойства());
	
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьНавигационнуюСсылку(ЭтотОбъект, ОбъектXDTO);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьОбъектXDTO()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, Тип);
	
	ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзФормы(ОбъектXDTO,
		ЭтотОбъект,
		РеквизитыИСвойства());
	
	ОбъектXDTO.name = Наименование;
	Если ЗначениеЗаполнено(ID) Тогда
		ОбъектXDTO.objectID = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ID, Тип);
	Иначе
		ОбъектXDTO.objectID = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, "", "");
	КонецЕсли;
	
	Возврат ОбъектXDTO;
	
КонецФункции

&НаСервере
Функция ЗаписатьОбъектXDTO(ОбъектXDTO)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Если ЗначениеЗаполнено(ОбъектXDTO.objectID.ID) Тогда
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMUpdateRequest");
		СписокОбъектов = Запрос.objects; // СписокXDTO
		
		СписокОбъектов.Добавить(ОбъектXDTO);
		
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		
		Возврат Результат.objects[0];
	Иначе
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMCreateRequest");
		Запрос.object = ОбъектXDTO;
		Результат = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);
		Возврат Результат.object;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыИСвойства()
	
	Результат = Новый Соответствие;
	Результат.Вставить("parent", "Родитель");
	Результат.Вставить("responsible", "Ответственный");
	Результат.Вставить("creationDate", "ДатаСоздания");
	Результат.Вставить("description", "Описание");
	Возврат Результат;
	
КонецФункции

#КонецОбласти