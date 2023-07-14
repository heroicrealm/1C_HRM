#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДоступнаМультипредметность = ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("2.0.3.1");
	Элементы.СтраницыМультипредметность.ТекущаяСтраница = ?(ДоступнаМультипредметность, 
		Элементы.СтраницаДоступнаМультипредметность,
		Элементы.СтраницаНедоступнаМультипредметность);
	
	ТипПроцессаXDTO = "DMBusinessProcessConsideration";
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(ТипПроцессаXDTO, Параметры);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
	Если Параметры.Свойство("Шаблон") Тогда
		ШаблонID = Параметры.Шаблон.ID;
		ШаблонТип = Параметры.Шаблон.type;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотПереопределяемый.ДополнительнаяОбработкаФормыБизнесПроцесса(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
			Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотДокумент" И Источник = Элементы.ПредметПредставление Тогда 
		Предмет = Параметр.name;
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		Если Параметр.ID = ID Тогда
			ПеречитатьПроцесс();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГлавнаяЗадачаПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ГлавнаяЗадачаТип, ГлавнаяЗадачаID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДатаПриИзменении(Элемент)
	
	Если Срок = НачалоДня(Срок) Тогда
		Срок = КонецДня(Срок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
				"Исполнитель", "ОбъектАдресации", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ИсполнительНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",,
		ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ИсполнительНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Исполнитель);
	Результат.Свойство("ИсполнительID", ИсполнительID);
	Результат.Свойство("ИсполнительТип", ИсполнительТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", ДополнительныйОбъектАдресацииТип);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
		"Исполнитель", "ОбъектАдресации", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка(
		"DMBusinessProcessImportance", "Важность", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Важность", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Важность", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Автор", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Автор", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Автор", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьБизнесПроцесс(Команда)
	
	РезультатЗаписи = ЗаписатьОбъект();
	
	Если РезультатЗаписи Тогда
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Ложь);
		Заголовок = Представление;
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Бизнес-процесс ""%1"" сохранен.'"), Представление));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	
	РезультатЗапуска = ПодготовитьКПередачеИСтартоватьБизнесПроцесс();
	Если РезультатЗапуска Тогда 
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Истина);
		ТекстСостояния = НСтр("ru = 'Бизнес-процесс ""%Наименование%"" успешно запущен.'");
		ТекстСостояния = СтрЗаменить(ТекстСостояния,"%Наименование%", Представление);
		Состояние(ТекстСостояния);
		
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.НачатьВыборШаблонаБизнесПроцесса(Оповещение, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ОстановитьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрерватьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПродолжитьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПоШаблонуЗавершение(РезультатВыбораШаблона, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(РезультатВыбораШаблона) = Тип("Структура") Тогда
		ЗаполнитьКарточкуПоШаблону(РезультатВыбораШаблона);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКарточкуПоШаблону(ДанныеШаблона)
	
	РезультатЗаполнения = ИнтеграцияС1СДокументооборотВызовСервера.ЗаполнитьБизнесПроцессПоШаблону(
		ЭтотОбъект, ДанныеШаблона);
	ЗаполнитьФормуИзОбъектаXDTO(РезультатЗаполнения.object);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO)
	
	Если ОбъектXDTO.Установлено("objectID") Тогда
		ID = ОбъектXDTO.objectID.ID;
		Тип = ОбъектXDTO.objectID.type;
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьНавигационнуюСсылку(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьСтандартнуюШапкуБизнесПроцесса(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьВидимостьКомандИзмененияСостоянияПроцесса(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьИсполнителяВФорме(ЭтотОбъект, ОбъектXDTO);
	
	// Специфика рассмотрения.
	Резолюция = ОбъектXDTO.Resolution;
	
	// Возможно, изменение процесса запрещено его шаблоном.
	ЗапрещеноИзменение = Ложь;
	Если ОбъектXDTO.Свойства().Получить("blockedByTemplate") <> Неопределено Тогда
		ЗапрещеноИзменение = ОбъектXDTO.blockedByTemplate;
	КонецЕсли;
	Элементы.ИсполнительПредставление.ТолькоПросмотр = Элементы.ИсполнительПредставление.ТолькоПросмотр
		Или (ЗначениеЗаполнено(ИсполнительID) И ЗапрещеноИзменение);
	Элементы.СрокДата.ТолькоПросмотр = Элементы.СрокДата.ТолькоПросмотр
		Или (ЗначениеЗаполнено(Срок) И ЗапрещеноИзменение);
	Элементы.СрокВремя.ТолькоПросмотр = Элементы.СрокВремя.ТолькоПросмотр
		Или (ЗначениеЗаполнено(Срок) И ЗапрещеноИзменение);
		
КонецПроцедуры

&НаСервере
Функция СоздатьОбъект(Прокси, Тип)
	
	Возврат ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, Тип);
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИЗаписатьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	Если ЗначениеЗаполнено(ID) Тогда
		РезультатЗаписи = ИнтеграцияС1СДокументооборот.ЗаписатьОбъект(Прокси, ОбъектXDTO);
	Иначе
		РезультатСоздания = ИнтеграцияС1СДокументооборот.СоздатьНовыйОбъект(Прокси, ОбъектXDTO);
	КонецЕсли;
	
	Результат = ?(РезультатСоздания = Неопределено, РезультатЗаписи, РезультатСоздания);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);

	Если РезультатЗаписи <> Неопределено Тогда // запрос на запись возвращает список
		ОбъектXDTO = Результат.objects[0];
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьПредметыВФорме(ЭтотОбъект, ОбъектXDTO);
	Иначе // запрос на создание возвращает сам объект
		ОбъектXDTO = Результат.object;
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИСтартоватьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	
	РезультатЗапуска = ИнтеграцияС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, ОбъектXDTO);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, РезультатЗапуска);
	
	УстановитьСсылкуБизнесПроцесса(РезультатЗапуска.businessProcess);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьБизнесПроцесс(Прокси)
	
	ОбъектXDTO = Обработки.ИнтеграцияС1СДокументооборот.ПодготовитьШапкуБизнесПроцесса(
		Прокси, "DMBusinessProcessConsideration", ЭтотОбъект);
	
	// Специфика Рассмотрения
	
	ОбъектXDTO.resolution = Резолюция;
	
	// Исполнитель
	ИсполнительБП = СоздатьОбъект(Прокси, "DMBusinessProcessTaskExecutor");
	
	Если ИсполнительТип = "DMUser" Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, ЭтотОбъект,
			"Исполнитель", ИсполнительБП.user, "DMUser");
	Иначе
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, ЭтотОбъект,
			"Исполнитель", ИсполнительБП.role, "DMBusinessProcessExecutorRole");
		
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, ЭтотОбъект,
			"ОсновнойОбъектАдресации", ИсполнительБП.mainAddressingObject, "DMMainAddressingObject");
		
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, ЭтотОбъект,
			"ДополнительныйОбъектАдресации", ИсполнительБП.secondaryAddressingObject, "DMSecondaryAddressingObject");
	КонецЕсли;
	
	ОбъектXDTO.performer = ИсполнительБП;
	
	Возврат ОбъектXDTO;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьОбъект() Экспорт
	
	ПодготовитьКПередачеИЗаписатьБизнесПроцесс();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Ложь);
	Модифицированность = Ложь;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура УстановитьСсылкуБизнесПроцесса(ОбъектXDTO)
	
	ID = ОбъектXDTO.objectID.ID;
	Если ОбъектXDTO.objectID.Свойства().Получить("presentation") <> Неопределено Тогда
		Представление = ОбъектXDTO.objectID.presentation;
	Иначе
		Представление = ОбъектXDTO.name;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьОбъект();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПрограммноДобавленнуюКоманду(Команда)
	
	// Вызовем обработчик команды, которая добавлена программно при создании формы на сервере.
	ИнтеграцияС1СДокументооборотКлиентПереопределяемый.ВыполнитьПрограммноДобавленнуюКоманду(Команда, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметОсновной(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтотОбъект, "Основной", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметВспомогательный(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтотОбъект, "Вспомогательный", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредмет(Команда)
	
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Предметы.Удалить(ТекущиеДанные);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметЗавершение(ОписаниеПредмета, ПараметрыОбработчика) Экспорт
	
	Если ОписаниеПредмета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаПредмета = Предметы.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаПредмета, ОписаниеПредмета);
	СтрокаПредмета.Картинка = ИнтеграцияС1СДокументооборотКлиентСервер.
		НомерКартинкиПоРолиПредмета(СтрокаПредмета.РольПредмета);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет()
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
		
	Иначе
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
		ПараметрыОповещения.Вставить("Предмет", ТекущиеДанные.Предмет);
		ПараметрыОповещения.Вставить("ПредметID", ТекущиеДанные.ПредметID);
		ПараметрыОповещения.Вставить("ПредметТип", ТекущиеДанные.ПредметТип);
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ТекущиеДанные.ПредметТип, ТекущиеДанные.ПредметID);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьПроцесс()
	
	ПараметрыПолучения = Новый Структура("ID, type", ID, Тип);
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(Тип, ПараметрыПолучения);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
КонецПроцедуры

#КонецОбласти