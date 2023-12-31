////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентРасширенный: методы, обслуживающие работу формы сотрудника.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура НачатьВыборФотографии(Форма) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ТекстСообщения = НСтр("ru = 'Для загрузки фотографии рекомендуется установить расширение для веб-клиента 1С:Предприятие.'");
	Обработчик = Новый ОписаниеОповещения("ЗагрузитьФотографиюПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Обработчик, ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийФормыСотрудника

Процедура СотрудникиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	СотрудникиКлиентБазовый.СотрудникиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ДокументПриемНаРаботуПослеЗаписи" И Параметр.Сотрудник = Форма.СотрудникСсылка 
		ИЛИ ИмяСобытия = "ДокументДоговорРаботыУслугиПослеЗаписи" И Параметр.Сотрудник = Форма.СотрудникСсылка 
		ИЛИ ИмяСобытия = "ДокументДоговорАвторскогоЗаказаПослеЗаписи" И Параметр.Сотрудник = Форма.СотрудникСсылка
		ИЛИ ИмяСобытия = "ДокументНачальнаяШтатнаяРасстановкаПослеЗаписи" Тогда
		
		Форма.ПрочитатьДанныеСвязанныеСФизлицом();
		
	ИначеЕсли ИмяСобытия = "РедактированиеПроцентаСевернойНадбавки" 
		И Форма.ФизическоеЛицоСсылка = Источник Тогда
		
		Форма.ТекущийПроцентСевернойНадбавки = Параметр.ПроцентСевернойНадбавки;
		
	Иначе
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
			Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
			Модуль.ОбработкаОповещенияИзмененийДанныхСотрудников(Форма, ИмяСобытия, Параметр, Источник);
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура СотрудникиПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	
	СотрудникиКлиентБазовый.СотрудникиПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормыФизическогоЛица

Процедура ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	
	СотрудникиКлиентБазовый.ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
	
КонецПроцедуры

Процедура ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	СотрудникиКлиентБазовый.ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник); 
	
	Если ИмяСобытия = "ЗагруженаФотография" Тогда
		Форма.Модифицированность = Истина;
	КонецЕсли;

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала") Тогда
		МодульПодборПерсоналаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодборПерсоналаКлиент");
		МодульПодборПерсоналаКлиент.ФизическиеЛицаФормаЭлементаОбработкаОповещения(Форма, ИмяСобытия, Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормСотрудникаИФизическогоЛица
// Содержащих уникальные значения.

Процедура ФизическиеЛицаИННПриИзменении(Форма, Элемент) Экспорт
	
	СотрудникиКлиентБазовый.ФизическиеЛицаИННПриИзменении(Форма, Элемент);
	ПроверитьУникальностьФизическогоЛица(Форма, "ИНН");
	
КонецПроцедуры

Процедура ФизическиеЛицаСтраховойНомерПФРПриИзменении(Форма, Элемент) Экспорт
	
	СотрудникиКлиентБазовый.ФизическиеЛицаСтраховойНомерПФРПриИзменении(Форма, Элемент);
	ПроверитьУникальностьФизическогоЛица(Форма, "СтраховойНомерПФР");
	
КонецПроцедуры

Процедура ФизическиеЛицаАдресФотографииНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	НачатьВыборФотографии(Форма);
	
КонецПроцедуры

Процедура ЗагрузитьФотографиюПродолжение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Не Подключено Тогда
		// Веб-клиент без расширения для работы с файлами.
		ОповещениеФайла = Новый ОписаниеОповещения("ЗагрузитьФотографиюВебКлиентЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОповещениеФайла);
		Возврат;
	КонецЕсли;
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("ЗагрузитьФотографиюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	// Вариант для установленного расширения для работы с файлами.
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите фотографию'");
		
	НачатьПомещениеФайлов(ОповещениеЗавершения, , ДиалогОткрытияФайла, Истина, ДополнительныеПараметры.Форма.УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ЗагрузитьФотографиюВебКлиентЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		Фотография = Новый ОписаниеПередаваемогоФайла(ВыбранноеИмяФайла, Адрес);
	КонецЕсли;
	
	ЗагрузитьФотографиюЗавершение(Фотография, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ЗагрузитьФотографиюЗавершение(Фотография, ДополнительныеПараметры) Экспорт
	
	Если Фотография = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Фотография.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Форма.АдресФотографии = Фотография[0].Хранение;
	Оповестить("ЗагруженаФотография", Фотография[0].Хранение, Форма);
	
КонецПроцедуры  

Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Форма) Экспорт
	
	СотрудникиКлиентБазовый.ДокументыФизическихЛицВидДокументаПриИзменении(Форма);
	ПроверитьУникальностьФизическогоЛица(Форма, "Документ");
	
КонецПроцедуры

Процедура ДокументыФизическихЛицСерияПриИзменении(Форма, Элемент) Экспорт
	
	СотрудникиКлиентБазовый.ДокументыФизическихЛицСерияПриИзменении(Форма, Элемент);
	ПроверитьУникальностьФизическогоЛица(Форма, "Документ");
	
КонецПроцедуры

Процедура ДокументыФизическихЛицНомерПриИзменении(Форма, Элемент) Экспорт
	
	СотрудникиКлиентБазовый.ДокументыФизическихЛицНомерПриИзменении(Форма, Элемент);
	ПроверитьУникальностьФизическогоЛица(Форма, "Документ");
	
КонецПроцедуры

Процедура ПроверитьУникальностьФизическогоЛица(Форма, ПроверяемыеИдентификатор) Экспорт
	
	Если ПроверяемыеИдентификатор = "ИНН"
		И НЕ ЗначениеЗаполнено(Форма.ФизическоеЛицо.ИНН) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверяемыеИдентификатор = "СтраховойНомерПФР"
		И НЕ КадровыйУчетКлиентСервер.СНИЛСЗаполнен(Форма.ФизическоеЛицо.СтраховойНомерПФР) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверяемыеИдентификатор = "Документ"
		И (НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.ВидДокумента)
		ИЛИ НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.Номер)) Тогда
		Возврат;
	КонецЕсли;
	
	РезультатыПроверки = СотрудникиВызовСервераРасширенный.РезультатыПроверкиУникальностиФизическогоЛица(
		Форма.ФизическоеЛицоСсылка,
		?(ПроверяемыеИдентификатор = "ИНН", Форма.ФизическоеЛицо.ИНН, ""),
		?(ПроверяемыеИдентификатор = "СтраховойНомерПФР", Форма.ФизическоеЛицо.СтраховойНомерПФР, ""),
		?(ПроверяемыеИдентификатор = "Документ", Форма.ДокументыФизическихЛиц.ВидДокумента, ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка")),
		?(ПроверяемыеИдентификатор = "Документ", Форма.ДокументыФизическихЛиц.Серия, ""),
		?(ПроверяемыеИдентификатор = "Документ", Форма.ДокументыФизическихЛиц.Номер, ""));
	
	Если Форма.Параметры.Свойство("Ключ") Тогда
		ВедущийОбъект = Форма.Параметры.Ключ;
	Иначе
		ВедущийОбъект = Форма.ВладелецФормы.Параметры.Ключ;
	КонецЕсли;
	
	ВызовИзФормыСотрудника = ТипЗнч(ВедущийОбъект) = Тип("СправочникСсылка.Сотрудники");
	
	Если НЕ РезультатыПроверки.ФизическоеЛицоУникально Тогда
		
		ПараметрыОткрытия = СотрудникиКлиент.ПараметрыОткрытияФормыФизическиеЛицаСПохожимиДанными(РезультатыПроверки);
		Если РезультатыПроверки.ДанныеФизическихЛиц.Количество() > 0 И ВедущийОбъект.Пустая() Тогда
			
			ОписаниеПредметовПроверки = "";
			
			Если РезультатыПроверки.СообщенияПроверки.Количество() = 1 Тогда
				
				ОписаниеПредметовПроверки = РезультатыПроверки.СообщенияПроверки[0].ТекстСообщенияОбОшибке;
				
				Если РезультатыПроверки.ДанныеФизическихЛиц.Количество() > 1 Тогда
					
					ОписаниеПредметовПроверки = СтрЗаменить(ОписаниеПредметовПроверки,
						НСтр("ru = 'Найдена запись о человеке, имеющем такой же'"),
						НСтр("ru = 'Найдены записи о людях, имеющих такой же'"));
					
				КонецЕсли;
				
			Иначе
				
				Для каждого СообщениеПроверки Из РезультатыПроверки.СообщенияПроверки Цикл
					
					Если СообщениеПроверки.ИмяПоля = "ИНН" Тогда
						
						ОписаниеПредметовПроверки = ?(ПустаяСтрока(ОписаниеПредметовПроверки), "", ОписаниеПредметовПроверки + ", ") 
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='ИНН (%1)'"),
								Форма.ФизическоеЛицо.ИНН);
						
					ИначеЕсли СообщениеПроверки.ИмяПоля = "СтраховойНомерПФР" Тогда
						
						ОписаниеПредметовПроверки = ?(ПустаяСтрока(ОписаниеПредметовПроверки), "", ОписаниеПредметовПроверки + ", ")
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='СНИЛС (%1)'"),
								Форма.ФизическоеЛицо.СтраховойНомерПФР);
						
					Иначе
						
						ОписаниеПредметовПроверки = ?(ПустаяСтрока(ОписаниеПредметовПроверки), "", ОписаниеПредметовПроверки + ", ")
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='документом, удостоверяющим личность'"),
								Форма.ДокументыФизическихЛиц.ВидДокумента,
								?(ПустаяСтрока(Форма.ДокументыФизическихЛиц.Серия), "", Форма.ДокументыФизическихЛиц.Серия),
								Форма.ДокументыФизическихЛиц.Номер);
						
					КонецЕсли;
					
				КонецЦикла;
				
				Если РезультатыПроверки.ДанныеФизическихЛиц.Количество() = 1 Тогда
					
					ОписаниеПредметовПроверки = НСтр("ru='Найдена запись о человеке, имеющем такие же'")
						+ " " + ОписаниеПредметовПроверки;
					
				Иначе
						
					ОписаниеПредметовПроверки = НСтр("ru='Найдены записи о людях, имеющих такие же'")
						+ " " + ОписаниеПредметовПроверки;
						
				КонецЕсли;
				
			КонецЕсли;
			
			ПараметрыОткрытия.ТекстИнформационнойНадписи = ОписаниеПредметовПроверки + "."
				+ Символы.ПС + ПараметрыОткрытия.ТекстИнформационнойНадписи;
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Форма", Форма);
			ДополнительныеПараметры.Вставить("ВызовИзФормыСотрудника", ВызовИзФормыСотрудника);
			
			Оповещение = Новый ОписаниеОповещения("ПроверитьУникальностьФизическогоЛицаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФизическиеЛицаСПохожимиДанными", ПараметрыОткрытия, , , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Иначе
			
			ТекстПредупреждения = РезультатыПроверки.СообщенияПроверки[0].ТекстСообщенияОбОшибке;
			
			Если НЕ ВедущийОбъект.Пустая() 
				И РезультатыПроверки.ДоступнаРольСохранениеДанныхЗадвоенныхФизическихЛиц Тогда
				ТекстПредупреждения = ТекстПредупреждения + Символы.ПС + Символы.ПС
					+ НСтр("ru = 'Не рекомендуется записывать дублирующиеся личные данные.
						|Тем не менее, можно записать текущие личные данные, после чего принять меры для устранения проблемы.'");
			Иначе
				ТекстПредупреждения = ТекстПредупреждения + Символы.ПС + Символы.ПС
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Записать %1 с этими личными данными невозможно.
							|Внесите изменения или обратитесь к администратору информационной системы для устранения проблемы.'"),
						Форма.ФизическоеЛицо.ФИО);
			КонецЕсли;
			
			ПоказатьПредупреждение(, ТекстПредупреждения);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьУникальностьФизическогоЛицаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВыбора <> Неопределено Тогда
		
		Форма = ДополнительныеПараметры.Форма;
		ВызовИзФормыСотрудника = ДополнительныеПараметры.ВызовИзФормыСотрудника;
		
		Если ВызовИзФормыСотрудника Тогда
			
			СотрудникиКлиент.УстановитьФизическоеЛицоВФормеСотрудника(Форма, РезультатВыбора);
			
		Иначе
			
			Форма.Модифицированность = Ложь;
			Форма.Закрыть();
			
			ОткрытьФорму("Справочник.ФизическиеЛица.ФормаОбъекта", Новый Структура("Ключ", РезультатВыбора));
			
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры

Процедура ОбработатьСобытиеДополнительногоПоляФормыНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.ОбработатьСобытиеДополнительногоПоляФормыСотрудникаНажатие(Форма, Элемент, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
