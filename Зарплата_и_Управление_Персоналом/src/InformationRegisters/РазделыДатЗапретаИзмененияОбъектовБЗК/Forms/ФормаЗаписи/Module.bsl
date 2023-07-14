#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		Запись.Предопределенный = Ложь;
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	ЗаполнитьТипыЗначенийОбъектов();
	Если Не Запись.Предопределенный Тогда
		
		ЗаполнитьСписокВыбораТаблиц(Элементы.ТаблицаОбъекта.СписокВыбора, Метаданные.Документы);
		ЗаполнитьСписокВыбораТаблиц(Элементы.ТаблицаОбъекта.СписокВыбора, Метаданные.РегистрыНакопления);
		ЗаполнитьСписокВыбораТаблиц(Элементы.ТаблицаОбъекта.СписокВыбора, Метаданные.РегистрыРасчета);
		ЗаполнитьСписокВыбораТаблиц(Элементы.ТаблицаОбъекта.СписокВыбора, Метаданные.РегистрыСведений);
		
		Если ЗначениеЗаполнено(Таблица) Тогда
			ЗаполнитьСпискиВыбораПолей();
		Иначе
			Элементы.ПолеДаты.СписокВыбора.Добавить(Запись.ПолеДаты);
			Элементы.ПолеОбъекта.СписокВыбора.Добавить(Запись.ПолеОбъекта);
		КонецЕсли;
		
	Иначе
		Элементы.ТаблицаОбъекта.СписокВыбора.Добавить(Таблица);
		Элементы.ПолеДаты.СписокВыбора.Добавить(Запись.ПолеДаты);
		Элементы.ПолеОбъекта.СписокВыбора.Добавить(Запись.ПолеОбъекта);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РеквизитВДанные(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Тип("СтрокаГруппировкиДинамическогоСписка"));
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Запись");
	РеквизитВДанные(ТекущийОбъект);
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Запись");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РазделСсылкаПриИзменении(Элемент)
	
	РазделСсылкаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РазделСсылкаСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ПриВводеНаименованияНовогоРаздела", ЭтотОбъект);
	ПоказатьВводСтроки(Оповещение, Элемент.ТекстРедактирования, НСтр("ru = 'Введите название нового раздела'"), 150, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПриИзменении(Элемент)
	
	ЗаполнитьСпискиВыбораПолей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РеквизитВДанные(ТекущийОбъект)
	
	ТекущийОбъект.ОбъектМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.НайтиПоПолномуИмени(Таблица));
		
КонецПроцедуры

&НаКлиенте
Процедура ПриВводеНаименованияНовогоРаздела(НаименованиеРаздела, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(НаименованиеРаздела) Тогда
		ДобавитьРаздел(НаименованиеРаздела);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРаздел(НаименованиеРаздела)
	
	ИмяРаздела = ИмяРазделаПоНаименованию(НаименованиеРаздела);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Раздел", ИмяРаздела);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РазделыДатЗапретаИзмененияОбъектов.РазделСсылка КАК РазделСсылка
		|ИЗ
		|	РегистрСведений.РазделыДатЗапретаИзмененияОбъектовБЗК КАК РазделыДатЗапретаИзмененияОбъектов
		|ГДЕ
		|	РазделыДатЗапретаИзмененияОбъектов.Раздел = &Раздел";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'В базе данных зарегистрирован раздел с похожим именем (%1)'"),
			Выборка.РазделСсылка);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	НовыйРаздел = ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.СоздатьЭлемент();
	НовыйРаздел.Наименование = НаименованиеРаздела;
	НовыйРаздел.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
	НовыйРаздел.Записать();
	
	Запись.РазделСсылка = НовыйРаздел.Ссылка;
	Запись.Раздел = ИмяРаздела;
	ЗаполнитьТипыЗначенийОбъектов();
	
	// Очищение параметров сеанса, для обновления списка разделов
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	ОчищаемыеПараметры = Новый Массив;
	ОчищаемыеПараметры.Добавить("ДействующиеДатыЗапретаИзменения");
	ПараметрыСеанса.Очистить(ОчищаемыеПараметры);
	
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура РазделСсылкаПриИзмененииНаСервере()
	
	Если Не ЗначениеЗаполнено(Запись.РазделСсылка) Тогда
		Запись.Раздел = "";
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РазделСсылка", Запись.РазделСсылка);
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РазделыДатЗапретаИзмененияОбъектов.Раздел КАК Раздел
		|ИЗ
		|	РегистрСведений.РазделыДатЗапретаИзмененияОбъектовБЗК КАК РазделыДатЗапретаИзмененияОбъектов
		|ГДЕ
		|	РазделыДатЗапретаИзмененияОбъектов.РазделСсылка = &РазделСсылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Запись.Раздел = Выборка.Раздел;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.Раздел) Тогда
		Запись.Раздел = ИмяРазделаПоНаименованию(Строка(Запись.РазделСсылка));
	КонецЕсли;
	
	ЗаполнитьТипыЗначенийОбъектов();
	
КонецПроцедуры

&НаСервере
Функция ИмяРазделаПоНаименованию(Знач НаименованиеРаздела)
	СловаНаименования = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(НаименованиеРаздела);
	ЧастиИмени = Новый Массив;
	Для Каждого СловоНаименования Из СловаНаименования Цикл
		ЧастиИмени.Добавить(ВРег(Лев(СловоНаименования, 1)));
		Если СтрДлина(СловоНаименования) > 1 Тогда
			ЧастиИмени.Добавить(Сред(СловоНаименования, 2));
		КонецЕсли;
	КонецЦикла;
	Возврат СтрСоединить(ЧастиИмени);
КонецФункции

&НаСервере
Процедура УстановитьОтображениеЭлементов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДанныеЗаписиГруппа",
		"ТолькоПросмотр",
		Запись.Предопределенный);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораТаблиц(Список, КоллекцияОбъектовМетаданных)
	
	ИсточникиДанных = ДатыЗапретаИзмененияСлужебный.ИсточникиДанныхДляПроверкиЗапретаИзменения();
	Для Каждого ОбъектМетаданных Из КоллекцияОбъектовМетаданных Цикл
		
		Если ЗарплатаКадры.ЭтоОбъектЗарплатноКадровойБиблиотеки(ОбъектМетаданных.ПолноеИмя()) Тогда
			
			Если ИсточникиДанных.Получить(ОбъектМетаданных.ПолноеИмя()) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Список.Добавить(ОбъектМетаданных.ПолноеИмя());
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораПолей()
	
	Элементы.ПолеДаты.СписокВыбора.Очистить();
	Элементы.ПолеОбъекта.СписокВыбора.Очистить();
	
	Если Не ЗначениеЗаполнено(Таблица) Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(Таблица);
	Если МетаданныеОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСпискиВыбораПоМетаданным(Элементы.ПолеДаты.СписокВыбора, МетаданныеОбъекта, Новый ОписаниеТипов("Дата"), Ложь);
	ЗаполнитьСпискиВыбораПоМетаданным(Элементы.ПолеОбъекта.СписокВыбора, МетаданныеОбъекта, ТипыОбъектов, Истина);
	
	Если Не ЗначениеЗаполнено(Запись.ПолеДаты)
		И Элементы.ПолеДаты.СписокВыбора.Количество() > 0 Тогда
		
		Запись.ПолеДаты = Элементы.ПолеДаты.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораПоМетаданным(СписокВыбора, МетаданныеОбъекта, ТипРеквизитов, ЗаполнятьРеквизитыРеквизитов, ПутьКРеквизиту = "")
	
	ТаблицаМетаданных = МетаданныеОбъекта.ПолноеИмя();
	
	ЗаполнитьСпискиВыбораПоКоллекцииРеквизитов(СписокВыбора, МетаданныеОбъекта.СтандартныеРеквизиты, ТипРеквизитов, ЗаполнятьРеквизитыРеквизитов, ПутьКРеквизиту);
	ЗаполнитьСпискиВыбораПоКоллекцииРеквизитов(СписокВыбора, МетаданныеОбъекта.Реквизиты, ТипРеквизитов, ЗаполнятьРеквизитыРеквизитов, ПутьКРеквизиту);
	
	Если ПустаяСтрока(ПутьКРеквизиту) Тогда
		Если СтрНачинаетсяС(ТаблицаМетаданных, "Документ.") Тогда
			Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
				Если ТабличнаяЧасть.Имя = "ДополнительныеРеквизиты" Тогда
					Продолжить;
				КонецЕсли;
				ЗаполнитьСпискиВыбораПоКоллекцииРеквизитов(СписокВыбора, ТабличнаяЧасть.Реквизиты, ТипРеквизитов, ЗаполнятьРеквизитыРеквизитов, ТабличнаяЧасть.Имя);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если СтрНачинаетсяС(ТаблицаМетаданных, "РегистрНакопления.")
		Или СтрНачинаетсяС(ТаблицаМетаданных, "РегистрРасчета.")
		Или СтрНачинаетсяС(ТаблицаМетаданных, "РегистрСведений.") Тогда
		
		ЗаполнитьСпискиВыбораПоКоллекцииРеквизитов(СписокВыбора, МетаданныеОбъекта.Измерения, ТипРеквизитов, ЗаполнятьРеквизитыРеквизитов);
		ЗаполнитьСпискиВыбораПоКоллекцииРеквизитов(СписокВыбора, МетаданныеОбъекта.Ресурсы, ТипРеквизитов, ЗаполнятьРеквизитыРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораПоКоллекцииРеквизитов(СписокВыбора, КоллекцияРеквизитов, ТипРеквизитов, ЗаполнятьРеквизитыРеквизитов, ПутьКРеквизиту = "")
	
	Для Каждого Реквизит Из КоллекцияРеквизитов Цикл
		
		Если Реквизит.Имя = "Ссылка" Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТипЗначения Из ТипРеквизитов.Типы() Цикл
			
			Если Реквизит.Тип.СодержитТип(ТипЗначения) Тогда
				ДобавитьВСписокВыбораРеквизит(СписокВыбора, Реквизит.Имя, ПутьКРеквизиту)
			КонецЕсли;
			
			Если ЗаполнятьРеквизитыРеквизитов Тогда
				
				Для Каждого ТипРеквизита Из Реквизит.Тип.Типы() Цикл
					
					Если ОбщегоНазначения.ЭтоСсылка(ТипРеквизита) Тогда
						МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипРеквизита);
						
						Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта)
							Или ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда
							
							НовыйПутьКРеквизиту = ?(ПустаяСтрока(ПутьКРеквизиту), "", ПутьКРеквизиту + ".") + Реквизит.Имя;
							ЗаполнитьСпискиВыбораПоМетаданным(СписокВыбора, МетаданныеОбъекта, ТипРеквизитов, Ложь, НовыйПутьКРеквизиту);
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВСписокВыбораРеквизит(СписокВыбора, Знач ИмяРеквизита, Знач ПутьКРеквизиту)
	
	Если Не ПустаяСтрока(ПутьКРеквизиту) Тогда
		ИмяРеквизита = СтрШаблон("%1.%2",
			ПутьКРеквизиту, ИмяРеквизита);
	Иначе
		Представление = ИмяРеквизита;
	КонецЕсли;
	Если СписокВыбора.НайтиПоЗначению(ИмяРеквизита) = Неопределено Тогда
		СписокВыбора.Добавить(ИмяРеквизита, Представление);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыЗначенийОбъектов()
	
	Если ЗначениеЗаполнено(Запись.РазделСсылка) Тогда
		ТипыРаздела = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.РазделСсылка, "ТипЗначения");
	Иначе
		ТипыРаздела = Метаданные.ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Тип;
	КонецЕсли;
	
	МассивТипов = Новый Массив;
	Для Каждого ТипЗначения Из ТипыРаздела.Типы() Цикл
		
		Если ТипЗначения = Тип("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения") Тогда
			Продолжить;
		КонецЕсли;
		МассивТипов.Добавить(ТипЗначения);
		
	КонецЦикла;
	
	ТипыОбъектов = Новый ОписаниеТипов(МассивТипов);
	
	Если ТипыОбъектов.Типы().Количество() = 0 Тогда
		Запись.ПолеОбъекта = "";
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПолеОбъекта",
		"Доступность",
		ТипыОбъектов.Типы().Количество() > 0);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	Если ЗначениеЗаполнено(Запись.ОбъектМетаданных) Тогда
		Таблица = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ОбъектМетаданных, "ПолноеИмя");
	КонецЕсли;
	
	УстановитьОтображениеЭлементов();
	
КонецПроцедуры

#КонецОбласти
