#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЦветФонаУспешнойОперацииБЗК = ЦветаСтиля.ЦветФонаУспешнойОперацииБЗК;
	ЦветФонаПредупрежденияБЗК   = ЦветаСтиля.ЦветФонаПредупрежденияБЗК;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		УстановитьОтображениеПоляВладелец(ЗначениеЗаполнено(Объект.Владелец));
		СформироватьАвтоНаименование(ЭтаФорма);
		
	КонецЕсли;
	
	БанкНеВыбран = НСтр("ru = '<заполняется автоматически после ввода БИК>'");
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	ОбработатьВыборБанка(ЭтотОбъект, Истина);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	ОбновитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьОтображениеПоляВладелец(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_БанковскиеСчетаКонтрагентов", Объект.Ссылка, Объект.Ссылка);
	Если ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерСчетаПриИзменении(Элемент)
	
	Объект.НомерСчета = СокрЛП(Объект.НомерСчета);
	
	УстановитьНаименованиеСчета(ЭтотОбъект, Истина);
	ОбновитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВыбораБанка();
	
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РеквизитыБанка       = Неопределено;
	Объект.Банк          = Неопределено;
	ОбработатьВыборБанка(ЭтотОбъект);
	ОбновитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Объект.Банк = ВыбранноеЗначение;
	ОбработатьВыборБанка(ЭтотОбъект);
	ОбновитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	НайденныйБанк = НайтиБанкВКлассификатореПоБИКу(СокрЛП(Текст));
	Если НайденныйБанк <> Неопределено Тогда
		Объект.Банк = НайденныйБанк;
		ОбработатьВыборБанка(ЭтотОбъект);
		ОбновитьВидимостьДоступность(ЭтотОбъект);
	Иначе
		ПредложитьСтандартныйВыбор(СокрЛП(Текст), Элемент.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанкНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Банк) Тогда
		ОткрытьФорму("Справочник.КлассификаторБанков.ФормаОбъекта", Новый Структура("Ключ", Объект.Банк), ЭтотОбъект);
	Иначе
		ОткрытьФормуВыбораБанка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстНазначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.КомментарийНачалоВыбора(
		ЭтотОбъект,
		Элемент,
		ДанныеВыбора,
		СтандартнаяОбработка,
		"Объект.ТекстНазначения",
		НСтр("ru = 'Назначение платежа'"));
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ВсеБанки(Команда)
	
	ОткрытьФормуВыбораБанка();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиБанк(Команда)
	
	НайденныйБанк = НайтиБанкВКлассификатореПоБИКу(СокрЛП(БИКБанка));
	
	Если НайденныйБанк = Неопределено Тогда
		ПредложитьСтандартныйВыбор(СокрЛП(БИКБанка), "БИКБанка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства
	
&НаКлиенте
Функция НайтиБанкВКлассификатореПоБИКу(ТекстДляПоиска)
	
	Если ПустаяСтрока(ТекстДляПоиска) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НайденныйБанк = ПолучитьБанкПоБИКу(ТекстДляПоиска);
	Если НайденныйБанк = Неопределено Тогда
		Возврат НайденныйБанк;
	КонецЕсли;
	
	Элементы.ДеятельностьБанкаПрекращена.Видимость = НайденныйБанк.ДеятельностьПрекращена;
	
	Возврат НайденныйБанк.Банк;
	
КонецФункции

&НаКлиенте
Процедура ПредложитьСтандартныйВыбор(ТекстДляПоиска, Поле)
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Банк с БИК ""%1"" не найден в справочнике банков'"), ТекстДляПоиска);
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Выбрать",     НСтр("ru = 'Выбрать из списка'"));
	Если НЕ РазделениеВключено Тогда
		Кнопки.Добавить("Создать", НСтр("ru = 'Создать банк'"));
	КонецЕсли;
	Кнопки.Добавить("Продолжить",  НСтр("ru = 'Продолжить ввод'"));
	Кнопки.Добавить("Отменить",    НСтр("ru = 'Отменить ввод'"));
	
	ДополнительныеПараметры   = Новый Структура("Поле, ТекстДляПоиска", Поле, ТекстДляПоиска);
	ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ПредложитьСтандартныйВыборЗавершение",
		ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВопрос(
		ОписаниеОповещенияВопрос,
		ТекстВопроса,
		Кнопки,,
		"Выбрать",
		НСтр("ru = 'Банк не найден'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьСтандартныйВыборЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = "Выбрать" Тогда
		
		ОткрытьФормуВыбораБанка();
		
	ИначеЕсли Ответ = "Создать" Тогда
		
		ПараметрыФормы = Новый Структура("Код, РучноеИзменение", СокрЛП(ДополнительныеПараметры.ТекстДляПоиска), Истина);
		ОткрытьФорму("Справочник.КлассификаторБанков.ФормаОбъекта",
			ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли Ответ = "Отменить" Тогда
		Если ЗначениеЗаполнено(Объект.Банк) Тогда
			ЭтотОбъект[ДополнительныеПараметры.Поле] = РеквизитыБанка.Код;
		Иначе
			ЭтотОбъект[ДополнительныеПараметры.Поле] = "";
		КонецЕсли;
		
	Иначе
		ТекущийЭлемент = Элементы[ДополнительныеПараметры.Поле];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеПоляВладелец(Значение)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Владелец",
		"ТолькоПросмотр",
		Значение);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьАвтоНаименование(Форма, Знач Текст = "")
	
	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;
	
	Элементы.Наименование.СписокВыбора.Очистить();
	НомерСчетаТекущий = СокрЛП(Объект.НомерСчета);
	
	СтрокаНаименования = "";
	Если ЗначениеЗаполнено(Форма.БИКБанка) Тогда
		СтрокаНаименования = Строка(Форма.БИКБанка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Банк) Тогда
		СтрокаНаименования = ?(ПустаяСтрока(СтрокаНаименования), "", СтрокаНаименования + ", ") + СокрЛП(Форма.Банк);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Объект.НомерСчета) Тогда
		СтрокаНаименования = ?(ПустаяСтрока(СтрокаНаименования), "", СтрокаНаименования + ", ") + СокрЛП(Форма.Объект.НомерСчета);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтрокаНаименования) Тогда
		Элементы.Наименование.СписокВыбора.Добавить(СокрЛП(СтрокаНаименования));
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Текст) И Элементы.Наименование.СписокВыбора.НайтиПоЗначению(Текст) = Неопределено Тогда
		Элементы.Наименование.СписокВыбора.Добавить(СокрЛП(Текст));
	КонецЕсли;
	
	Возврат СтрокаНаименования;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьБанкПоБИКу(БИК)
	
	Если НЕ ЗначениеЗаполнено(БИК) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("БИК", БИК);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторБанков.Ссылка КАК Ссылка,
	|	КлассификаторБанков.ДеятельностьПрекращена
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|ГДЕ
	|	КлассификаторБанков.Код = &БИК";
		
	НайденныйБанк = Неопределено;
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		НайденныйБанк = Новый Структура("Банк, ДеятельностьПрекращена", Выборка.Ссылка, Выборка.ДеятельностьПрекращена);
	КонецЕсли;
	
	Возврат НайденныйБанк
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораБанка()
	
	ПараметрыФормы = Новый Структура(
		"ТекущаяСтрока, ПараметрВыборГруппИЭлементов",
		Объект.Банк, ИспользованиеГруппИЭлементов.Элементы);
		
	ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", ПараметрыФормы, Элементы.БИКБанка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьВыборБанка(Форма, ВызватьУправлениеФормой = Истина)
	
	Форма.РеквизитыБанка				= ПолучитьРеквизитыБанка(Форма.Объект.Банк);
	Форма.БИКБанка						= Форма.РеквизитыБанка.Код;
	Форма.Элементы.ДеятельностьБанкаПрекращена.Видимость = Форма.РеквизитыБанка.ДеятельностьПрекращена;
	
	Если ВызватьУправлениеФормой Тогда
		УправлениеФормой(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект		= Форма.Объект;
	Элементы	= Форма.Элементы;
	
	Если ЗначениеЗаполнено(Объект.Банк) Тогда
		Форма.Банк = Форма.РеквизитыБанка.Наименование + " " + Форма.РеквизитыБанка.Город;
		Элементы.СтраницыБанк.ТекущаяСтраница = Элементы.СтраницаБанк;
	Иначе
		Форма.Банк = "";
		Элементы.СтраницыБанк.ТекущаяСтраница = Элементы.СтраницаБанкНеВыбран;
	КонецЕсли;
	
	УстановитьНаименованиеСчета(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНаименованиеСчета(Форма, ИзменениеНомераСчета = Ложь)
	
	Объект = Форма.Объект;
	
	Если ПустаяСтрока(Объект.Наименование) ИЛИ Объект.Наименование = Форма.АвтоНаименование Тогда
		Форма.АвтоНаименование  = СформироватьАвтоНаименование(Форма);
		Если НЕ ПустаяСтрока(Форма.АвтоНаименование) И Форма.АвтоНаименование <> Объект.Наименование Тогда
			Объект.Наименование = Форма.АвтоНаименование;
		КонецЕсли;
	Иначе
		Если ИзменениеНомераСчета И НЕ ПустаяСтрока(Форма.НомерСчетаТекущий) Тогда
			Объект.Наименование = СтрЗаменить(Объект.Наименование, Форма.НомерСчетаТекущий, СокрЛП(Объект.НомерСчета));
		КонецЕсли;
		
		Форма.АвтоНаименование = СформироватьАвтоНаименование(Форма, Объект.Наименование);
	КонецЕсли;
	
	Форма.НомерСчетаТекущий = СокрЛП(Объект.НомерСчета);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыБанка(Знач Банк)
	
	ИменаРеквизитов = "Код, Наименование, КоррСчет, Город, ДеятельностьПрекращена";
	Если ЗначениеЗаполнено(Банк) Тогда
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Банк, ИменаРеквизитов);
	Иначе
		СтруктураРеквизитов = Новый Структура(ИменаРеквизитов);
		СтруктураРеквизитов.Код = "";
		СтруктураРеквизитов.Наименование = "";
		СтруктураРеквизитов.КоррСчет = "";
		СтруктураРеквизитов.ДеятельностьПрекращена = Ложь;
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьДоступность(Форма)
	
	РезультатПроверки = ПроверкиБЗККлиентСервер.РезультатПроверкиНомераСчета(
		Форма.Объект.НомерСчета,
		Форма.БИКБанка,
		Форма.РеквизитыБанка.КоррСчет);
	Форма.Элементы.РезультатПроверкиНомераСчета.Заголовок = РезультатПроверки.Пояснение;
	Если РезультатПроверки.Успех Тогда
		Форма.Элементы.РезультатПроверкиНомераСчета.ЦветФона = Форма.ЦветФонаУспешнойОперацииБЗК;
	Иначе
		Форма.Элементы.РезультатПроверкиНомераСчета.ЦветФона = Форма.ЦветФонаПредупрежденияБЗК;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

