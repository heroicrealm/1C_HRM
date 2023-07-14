
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Параметры.Документ;
	ДокументID = Параметры.ДокументID;
	ДокументТип = Параметры.ДокументТип;
	
	ВидДокумента = Параметры.ВидДокумента;
	ВидДокументаID = Параметры.ВидДокументаID;
	ВидДокументаТип = Параметры.ВидДокументаТип;
	
	ВопросДеятельности = Параметры.ВопросДеятельности;
	ВопросДеятельностиID = Параметры.ВопросДеятельностиID;
	ВопросДеятельностиТип = Параметры.ВопросДеятельностиТип;
	
	Контрагент = Параметры.Контрагент;
	КонтрагентID = Параметры.КонтрагентID;
	КонтрагентТип = Параметры.КонтрагентТип;
	
	Организация = Параметры.Организация;
	ОрганизацияID = Параметры.ОрганизацияID;
	ОрганизацияТип = Параметры.ОрганизацияТип;
	
	Подразделение = Параметры.Подразделение;
	ПодразделениеID = Параметры.ПодразделениеID;
	ПодразделениеТип = Параметры.ПодразделениеТип;
	
	НоменклатураДел = Параметры.НоменклатураДел;
	НоменклатураДелID = Параметры.НоменклатураДелID;
	НоменклатураДелТип = Параметры.НоменклатураДелТип;
	НоменклатураДелГод = Параметры.НоменклатураДелГод;
	
	Если НоменклатураДелГод = 0 Тогда
		НоменклатураДелГод = Год(ТекущаяДатаСеанса());
	КонецЕсли;
	
	ОбновитьДанные();
	
	Элементы.Список.ОтборСтрок = Новый ФиксированнаяСтруктура(
		Новый Структура("РазделID, РазделТип", "БезРаздела", "БезРаздела"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьДелаЗаПриИзменении(Элемент)
	
	ОбновитьДанные();
	
	Для Каждого Строка Из Разделы.ПолучитьЭлементы() Цикл
		Элементы.Разделы.Развернуть(Строка.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРазделы

&НаКлиенте
Процедура РазделыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Строка = Элемент.ТекущиеДанные;
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяНоменклатураДел = Строка.Представление;
	ТекущаяНоменклатураДелID = Строка.ID;
	ТекущаяНоменклатураДелТип = Строка.Тип;
	ТекущаяНоменклатураДелГод = Строка.Год;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Выбрать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	Выбрать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Строка = Элементы.Разделы.ТекущиеДанные;
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("РазделID", ?(ЗначениеЗаполнено(Строка.ID), Строка.ID, "БезРаздела"));
	СтруктураПоиска.Вставить("РазделТип", ?(ЗначениеЗаполнено(Строка.Тип), Строка.Тип, "БезРаздела"));
	Элементы.Список.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать()
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("НоменклатураДел", ТекущаяНоменклатураДел);
	Результат.Вставить("НоменклатураДелID", ТекущаяНоменклатураДелID);
	Результат.Вставить("НоменклатураДелТип", ТекущаяНоменклатураДелТип);
	Результат.Вставить("НоменклатураДелГод", ТекущаяНоменклатураДелГод);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанные()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ПрочитатьДеревоРазделовВФорму(Прокси);
	ПрочитатьСписокНоменклатурыДелВФорму(Прокси);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДеревоРазделовВФорму(Прокси)
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetCaseFilesListSectionsTreeRequest");
	Запрос.year = НоменклатураДелГод;
	Запрос.company = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMOrganization");
	Запрос.company.name = Организация;
	Запрос.company.objectID = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.company.objectID.ID = ОрганизацияID;
	Запрос.company.objectID.type = ОрганизацияТип;
	Запрос.department = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMSubdivision");
	Запрос.department.name = Подразделение;
	Запрос.department.objectID = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.department.objectID.ID = ПодразделениеID;
	Запрос.department.objectID.type = ПодразделениеТип;
	РезультатДеревоРазделов = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, РезультатДеревоРазделов);
	
	ДеревоРазделов = РеквизитФормыВЗначение("Разделы");
	ДеревоРазделов.Строки.Очистить();
	
	Корень = ДеревоРазделов.Строки.Добавить();
	Корень.Наименование = НСтр("ru = 'Разделы'");
	Корень.ИндексКартинки = -1;
	
	ЗаполнитьДеревоРазделов(Корень, РезультатДеревоРазделов.caseFilesListSectionsTree);
	
	ЗначениеВРеквизитФормы(ДеревоРазделов, "Разделы");
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСписокНоменклатурыДелВФорму(Прокси)
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetCaseFilesCatalogRequest");
	
	Запрос.year = НоменклатураДелГод;
	
	Запрос.company = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMOrganization");
	Запрос.company.name = Организация;
	Запрос.company.objectID = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.company.objectID.ID = ОрганизацияID;
	Запрос.company.objectID.type = ОрганизацияТип;
	
	Запрос.department = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMSubdivision");
	Запрос.department.name = Подразделение;
	Запрос.department.objectID = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.department.objectID.ID = ПодразделениеID;
	Запрос.department.objectID.type = ПодразделениеТип;
	
	Запрос.documentType = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObject");
	Запрос.documentType.name = ВидДокумента;
	Запрос.documentType.objectID = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.documentType.objectID.ID = ВидДокументаID;
	Запрос.documentType.objectID.type = ВидДокументаТип;
	
	Запрос.correspondent = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMCorrespondent");
	Запрос.correspondent.name = Контрагент;
	Запрос.correspondent.objectID = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.correspondent.objectID.ID = КонтрагентID;
	Запрос.correspondent.objectID.type = КонтрагентТип;
	
	Запрос.activityMatter = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMActivityMatter");
	Запрос.activityMatter.name = ВопросДеятельности;
	Запрос.activityMatter.objectID = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	Запрос.activityMatter.objectID.ID = ВопросДеятельностиID;
	Запрос.activityMatter.objectID.type = ВопросДеятельностиТип;
	
	РезультатСписокНоменклатурыДел = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, РезультатСписокНоменклатурыДел);
	
	Таблица = РеквизитФормыВЗначение("Список");
	
	Таблица.Очистить();
	Для Каждого caseFilesCatalog Из РезультатСписокНоменклатурыДел.caseFilesCatalogs Цикл
		НовСтр = Таблица.Добавить();
		НовСтр.Наименование = caseFilesCatalog.name;
		НовСтр.Представление = caseFilesCatalog.objectID.presentation;
		НовСтр.Индекс = caseFilesCatalog.index;
		НовСтр.Год = caseFilesCatalog.year;
		НовСтр.ID = caseFilesCatalog.objectID.ID;
		НовСтр.Тип = caseFilesCatalog.objectID.type;
		Если ИнтеграцияС1СДокументооборот.СвойствоУстановлено(caseFilesCatalog, "section") Тогда
			НовСтр.РазделID = caseFilesCatalog.section.objectID.ID;
			НовСтр.РазделТип = caseFilesCatalog.section.objectID.type;
		Иначе
			НовСтр.РазделID = "БезРаздела";
			НовСтр.РазделТип = "БезРаздела";
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Таблица, "Список");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоРазделов(Дерево, caseFilesListSectionsTree)
	
	Для Каждого caseFilesListSectionsTreeElement Из caseFilesListSectionsTree Цикл
		НовыйЭлемент = Дерево.Строки.Добавить();
		НовыйЭлемент.Наименование = caseFilesListSectionsTreeElement.caseFilesListSection.name;
		НовыйЭлемент.ID = caseFilesListSectionsTreeElement.caseFilesListSection.objectID.ID;
		НовыйЭлемент.Тип = caseFilesListSectionsTreeElement.caseFilesListSection.objectID.type;
		НовыйЭлемент.ИндексКартинки = 0;
		Если ИнтеграцияС1СДокументооборот.СвойствоУстановлено(
				caseFilesListSectionsTreeElement, "caseFilesListSectionsTree") Тогда
			ЗаполнитьДеревоРазделов(НовыйЭлемент, caseFilesListSectionsTreeElement.caseFilesListSectionsTree)
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
