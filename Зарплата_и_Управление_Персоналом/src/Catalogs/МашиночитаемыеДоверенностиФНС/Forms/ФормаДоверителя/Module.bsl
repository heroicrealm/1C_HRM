
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Параметры.СтруктураДанных;
	
	Если СтруктураДанных.Свойство("ТолькоПросмотрФормы") И СтруктураДанных.ТолькоПросмотрФормы Тогда
		Элементы.ДоверительЮЛ_РоссийскаяОрганизация.ТолькоПросмотр 	= Истина;
		Элементы.ДоверительЮЛ_НаимОрг.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительЮЛ_ИНН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_КПП.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_ОГРН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_СтрРег.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительЮЛ_Адр.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_НаимРегОрг.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительЮЛ_РегНомер.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительЮЛ_КодНПРег.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительФЛ_ФИО.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительФЛ_Удостоверение.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительФЛ_ИНН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительФЛ_Гражданство.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительФЛ_ДатаРождения.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительФЛ_Пол.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительФЛ_МестоРожд.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительФЛ_ОГРН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительФЛ_СНИЛС.ТолькоПросмотр 					= Истина;
		Элементы.ФормаКнопкаСохранить.Доступность 					= Ложь;
	КонецЕсли;
	
	Доверитель_ЮридическоеЛицо = (СтруктураДанных = Неопределено ИЛИ СтруктураДанных.Доверитель_ЮридическоеЛицо);
	ДоверительЮЛ_РоссийскаяОрганизация = (СтруктураДанных = Неопределено
		ИЛИ СтруктураДанных.ДоверительЮЛ_РоссийскаяОрганизация);
	
	Если СтруктураДанных <> Неопределено Тогда
		ДоверительЮЛ_НаимОрг 				= СтруктураДанных.ДоверительЮЛ_НаимОрг;
		ДоверительЮЛ_ИНН 					= СтруктураДанных.ДоверительЮЛ_ИНН;
		ДоверительЮЛ_КПП 					= СтруктураДанных.ДоверительЮЛ_КПП;
		ДоверительЮЛ_ОГРН 					= СтруктураДанных.ДоверительЮЛ_ОГРН;
		ДоверительЮЛ_СтрРег 				= СтруктураДанных.ДоверительЮЛ_СтрРег;
		ДоверительЮЛ_НаимРегОрг 			= СтруктураДанных.ДоверительЮЛ_НаимРегОрг;
		ДоверительЮЛ_РегНомер 				= СтруктураДанных.ДоверительЮЛ_РегНомер;
		ДоверительЮЛ_КодНПРег 				= СтруктураДанных.ДоверительЮЛ_КодНПРег;
		ДоверительЮЛ_Адр 					= СтруктураДанных.ДоверительЮЛ_Адр;
		ДоверительЮЛ_АдрВЛатТранскрипции 	= СтруктураДанных.ДоверительЮЛ_АдрВЛатТранскрипции;
		ДоверительЮЛ_АдрXML 				= СтруктураДанных.ДоверительЮЛ_АдрXML;
		ДоверительФЛ_Фамилия 				= СтруктураДанных.ДоверительФЛ_Фамилия;
		ДоверительФЛ_Имя 					= СтруктураДанных.ДоверительФЛ_Имя;
		ДоверительФЛ_Отчество 				= СтруктураДанных.ДоверительФЛ_Отчество;
		ДоверительФЛ_ФИО 					= СтруктураДанных.ДоверительФЛ_ФИО;
		ДоверительФЛ_ВидДок 				= СтруктураДанных.ДоверительФЛ_ВидДок;
		ДоверительФЛ_СерДок 				= СтруктураДанных.ДоверительФЛ_СерДок;
		ДоверительФЛ_НомДок 				= СтруктураДанных.ДоверительФЛ_НомДок;
		ДоверительФЛ_ДатаДок 				= СтруктураДанных.ДоверительФЛ_ДатаДок;
		ДоверительФЛ_ВыдДок 				= СтруктураДанных.ДоверительФЛ_ВыдДок;
		ДоверительФЛ_КодВыдДок 				= СтруктураДанных.ДоверительФЛ_КодВыдДок;
		ДоверительФЛ_Удостоверение 			= СтруктураДанных.ДоверительФЛ_Удостоверение;
		ДоверительФЛ_ИНН 					= СтруктураДанных.ДоверительФЛ_ИНН;
		ДоверительФЛ_ОГРН 					= СтруктураДанных.ДоверительФЛ_ОГРН;
		ДоверительФЛ_СНИЛС 					= СтруктураДанных.ДоверительФЛ_СНИЛС;
		ДоверительФЛ_Гражданство 			= СтруктураДанных.ДоверительФЛ_Гражданство;
		ДоверительФЛ_Пол 					= СтруктураДанных.ДоверительФЛ_Пол;
		ДоверительФЛ_ДатаРождения 			= СтруктураДанных.ДоверительФЛ_ДатаРождения;
		ДоверительФЛ_МестоРожд 				= СтруктураДанных.ДоверительФЛ_МестоРожд;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоверительЮЛ_ИностраннаяОрганизацияПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЮЛ_АдрНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ Доверитель_ЮридическоеЛицо ИЛИ (НЕ ДоверительЮЛ_РоссийскаяОрганизация
		И ДоверительЮЛ_АдрВЛатТранскрипции) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоверительЮЛ_АдрНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации"), ДоверительЮЛ_АдрXML);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЮЛ_АдрОчистка(Элемент, СтандартнаяОбработка)
	
	ДоверительЮЛ_АдрXML = "";
	ДоверительЮЛ_Адр = "";
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЮЛ_АдрВЛатТранскрипцииПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ФормаВводаФИО = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ФормаВводаФИО");
	
	ФормаВводаФИО.Фамилия 	= ДоверительФЛ_Фамилия;
	ФормаВводаФИО.Имя 		= ДоверительФЛ_Имя;
	ФормаВводаФИО.Отчество 	= ДоверительФЛ_Отчество;
	
	ФормаВводаФИО.ОписаниеОповещенияОЗакрытии =
		Новый ОписаниеОповещения("ДоверительФЛ_ФИОНачалоВыбораЗавершение", ЭтотОбъект);
	ФормаВводаФИО.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаВводаФИО.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ДоверительФЛ_Фамилия 	= "";
	ДоверительФЛ_Имя 		= "";
	ДоверительФЛ_Отчество 	= "";
	
	ДоверительФЛ_ФИО = "";
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостоверениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ДокументВид", 				ДоверительФЛ_ВидДок);
	СтруктураДанных.Вставить("ДокументСерия", 				ДоверительФЛ_СерДок);
	СтруктураДанных.Вставить("ДокументНомер", 				ДоверительФЛ_НомДок);
	СтруктураДанных.Вставить("ДокументДатаВыдачи", 			ДоверительФЛ_ДатаДок);
	СтруктураДанных.Вставить("ДокументКемВыдан", 			ДоверительФЛ_ВыдДок);
	СтруктураДанных.Вставить("ДокументКодПодразделения", 	ДоверительФЛ_КодВыдДок);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоверительФЛ_УдостоверениеНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.МашиночитаемыеДоверенностиФНС.Форма.ФормаВводаУдостоверения",
		Новый Структура("СтруктураДанных", СтруктураДанных),
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостоверениеОчистка(Элемент, СтандартнаяОбработка)
	
	ДоверительФЛ_ВидДок 	= ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка");
	ДоверительФЛ_СерДок 	= "";
	ДоверительФЛ_НомДок 	= "";
	ДоверительФЛ_ДатаДок 	= Неопределено;
	ДоверительФЛ_ВыдДок 	= "";
	ДоверительФЛ_КодВыдДок 	= "";
	
	ДоверительФЛ_Удостоверение = "";
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ДоверительЮЛ_РоссийскаяОрганизация", 	ДоверительЮЛ_РоссийскаяОрганизация);
	СтруктураДанных.Вставить("ДоверительЮЛ_НаимОрг", 				ДоверительЮЛ_НаимОрг);
	СтруктураДанных.Вставить("ДоверительЮЛ_ИНН", 					ДоверительЮЛ_ИНН);
	СтруктураДанных.Вставить("ДоверительЮЛ_КПП", 					ДоверительЮЛ_КПП);
	СтруктураДанных.Вставить("ДоверительЮЛ_ОГРН", 					ДоверительЮЛ_ОГРН);
	СтруктураДанных.Вставить("ДоверительЮЛ_СтрРег", 				ДоверительЮЛ_СтрРег);
	СтруктураДанных.Вставить("ДоверительЮЛ_НаимРегОрг", 			ДоверительЮЛ_НаимРегОрг);
	СтруктураДанных.Вставить("ДоверительЮЛ_РегНомер", 				ДоверительЮЛ_РегНомер);
	СтруктураДанных.Вставить("ДоверительЮЛ_КодНПРег", 				ДоверительЮЛ_КодНПРег);
	СтруктураДанных.Вставить("ДоверительЮЛ_Адр", 					ДоверительЮЛ_Адр);
	СтруктураДанных.Вставить("ДоверительЮЛ_АдрВЛатТранскрипции", 	ДоверительЮЛ_АдрВЛатТранскрипции);
	СтруктураДанных.Вставить("ДоверительЮЛ_АдрXML", 				ДоверительЮЛ_АдрXML);
	СтруктураДанных.Вставить("ДоверительФЛ_Фамилия", 				ДоверительФЛ_Фамилия);
	СтруктураДанных.Вставить("ДоверительФЛ_Имя", 					ДоверительФЛ_Имя);
	СтруктураДанных.Вставить("ДоверительФЛ_Отчество", 				ДоверительФЛ_Отчество);
	СтруктураДанных.Вставить("ДоверительФЛ_ФИО", 					ДоверительФЛ_ФИО);
	СтруктураДанных.Вставить("ДоверительФЛ_ВидДок", 				ДоверительФЛ_ВидДок);
	СтруктураДанных.Вставить("ДоверительФЛ_СерДок", 				ДоверительФЛ_СерДок);
	СтруктураДанных.Вставить("ДоверительФЛ_НомДок", 				ДоверительФЛ_НомДок);
	СтруктураДанных.Вставить("ДоверительФЛ_ДатаДок", 				ДоверительФЛ_ДатаДок);
	СтруктураДанных.Вставить("ДоверительФЛ_ВыдДок", 				ДоверительФЛ_ВыдДок);
	СтруктураДанных.Вставить("ДоверительФЛ_КодВыдДок", 				ДоверительФЛ_КодВыдДок);
	СтруктураДанных.Вставить("ДоверительФЛ_ИНН", 					ДоверительФЛ_ИНН);
	СтруктураДанных.Вставить("ДоверительФЛ_ОГРН", 					ДоверительФЛ_ОГРН);
	СтруктураДанных.Вставить("ДоверительФЛ_СНИЛС", 					ДоверительФЛ_СНИЛС);
	СтруктураДанных.Вставить("ДоверительФЛ_Гражданство", 			ДоверительФЛ_Гражданство);
	СтруктураДанных.Вставить("ДоверительФЛ_Пол", 					ДоверительФЛ_Пол);
	СтруктураДанных.Вставить("ДоверительФЛ_ДатаРождения", 			ДоверительФЛ_ДатаРождения);
	СтруктураДанных.Вставить("ДоверительФЛ_МестоРожд", 				ДоверительФЛ_МестоРожд);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ГруппаЛевая.Видимость = Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ГруппаПравая.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо
		ИЛИ НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ГруппаПравая.Заголовок = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация,
		НСтр("ru = 'Руководитель обособленного подразделения'"), НСтр("ru = 'Индивидуальный предприниматель'"));
	
	Форма.Элементы.ДоверительЮЛ_НаимОрг.ПоложениеЗаголовка = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация,
		ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Авто);
	Форма.Элементы.ДоверительЮЛ_Адр.ПоложениеЗаголовка = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация,
		ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Авто);
	Форма.Элементы.ДоверительЮЛ_Адр.КнопкаВыбора = Форма.Доверитель_ЮридическоеЛицо
		И (Форма.ДоверительЮЛ_РоссийскаяОрганизация ИЛИ НЕ Форма.ДоверительЮЛ_АдрВЛатТранскрипции);
	Форма.Элементы.ДоверительЮЛ_АдрВЛатТранскрипции.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительЮЛ_ОГРН.Видимость = Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительЮЛ_СтрРег.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительЮЛ_НаимРегОрг.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительЮЛ_РегНомер.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительЮЛ_КодНПРег.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	
	Форма.Элементы.ДоверительФЛ_ФИО.ПоложениеЗаголовка = ?(Форма.Доверитель_ЮридическоеЛицо,
		ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Авто);
	Форма.Элементы.ДоверительФЛ_Удостоверение.ПоложениеЗаголовка = ?(Форма.Доверитель_ЮридическоеЛицо,
		ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Авто);
	Форма.Элементы.ДоверительФЛ_СНИЛС.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_ОГРН.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_Удостоверение.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_Пол.Видимость = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительФЛ_ИНН.АвтоОтметкаНезаполненного = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_ИНН.АвтоВыборНезаполненного = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_ДатаРождения.АвтоОтметкаНезаполненного = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительФЛ_ДатаРождения.АвтоВыборНезаполненного = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительФЛ_Гражданство.АвтоОтметкаНезаполненного = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительФЛ_Гражданство.АвтоВыборНезаполненного = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительФЛ_Гражданство.Подсказка = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация,
		НСтр("ru = 'Незаполненность поля означает лицо без гражданства'"), "");
	Форма.Элементы.ДоверительФЛ_Гражданство.ОтображениеПодсказки = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация, ОтображениеПодсказки.Кнопка, ОтображениеПодсказки.Авто);
	
КонецПроцедуры

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если Доверитель_ЮридическоеЛицо Тогда
		Если НЕ ЗначениеЗаполнено(ДоверительЮЛ_НаимОрг) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано наименование организации.'"),,
				"ДоверительЮЛ_НаимОрг",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительЮЛ_ИНН) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан ИНН организации.'"),, "ДоверительЮЛ_ИНН",,
				Отказ);
		ИначеЕсли НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(
			ДоверительЮЛ_ИНН, Ложь) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ИНН организации.'"),,
				"ДоверительЮЛ_ИНН",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительЮЛ_КПП) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан КПП организации.'"),, "ДоверительЮЛ_КПП",,
				Отказ);
		ИначеЕсли СтрДлина(ДоверительЮЛ_КПП) <> 9 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный КПП организации.'"),,
				"ДоверительЮЛ_КПП",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительЮЛ_Адр) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан адрес организации.'"),, "ДоверительЮЛ_Адр",,
				Отказ);
		КонецЕсли;
		
		Если ДоверительЮЛ_РоссийскаяОрганизация Тогда
			Если НЕ ЗначениеЗаполнено(ДоверительЮЛ_ОГРН) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан ОГРН организации.'"),, "ДоверительЮЛ_ОГРН",,
					Отказ);
			ИначеЕсли СтрДлина(ДоверительЮЛ_ОГРН) <> 13 Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ОГРН организации.'"),,
					"ДоверительЮЛ_ОГРН",, Отказ);
			КонецЕсли;
			
		Иначе
			Если НЕ ЗначениеЗаполнено(ДоверительЮЛ_СтрРег) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана страна регистрации организации.'"),,
					"ДоверительЮЛ_СтрРег",, Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДоверительЮЛ_РегНомер) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан регистрационный номер организации.'"),,
					"ДоверительЮЛ_РегНомер",, Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДоверительФЛ_Фамилия) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Не задана фамилия руководителя обособленного подразделения.'"),,
					"ДоверительФЛ_ФИО",, Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДоверительФЛ_Имя) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Не задано имя руководителя обособленного подразделения.'"),,
					"ДоверительФЛ_ФИО",, Отказ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДоверительФЛ_ИНН) И НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(
				ДоверительФЛ_ИНН, Истина) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ИНН руководителя обособленного подразделения.'"),,
					"ДоверительЮЛ_ИНН",, Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДоверительФЛ_Пол) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан пол руководителя обособленного подразделения.'"),,
					"ДоверительФЛ_Пол",, Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДоверительФЛ_ДатаРождения) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Не задана дата рождения руководителя обособленного подразделения.'"),,
					"ДоверительФЛ_ДатаРождения",, Отказ);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_Фамилия) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не задана фамилия.'"),, "ДоверительФЛ_ФИО",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_Имя) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				НСтр("ru = 'Не задано имя.'"),, "ДоверительФЛ_ФИО",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_ВидДок) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан вид документа.'"),, "ДоверительФЛ_Удостоверение",,
				Отказ);
		КонецЕсли;
		
		КодВидаДокумента = ДокументооборотСКОВызовСервера.ПолучитьКодВидаДокументаФизическогоЛица(ДоверительФЛ_ВидДок);
		Если ЗначениеЗаполнено(КодВидаДокумента) И КодВидаДокумента <> "07" И КодВидаДокумента <> "10"
			И КодВидаДокумента <> "11" И КодВидаДокумента <> "12" И КодВидаДокумента <> "13" И КодВидаДокумента <> "15"
			И КодВидаДокумента <> "19" И КодВидаДокумента <> "21" И КодВидаДокумента <> "24" Тогда
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Вид документа не поддерживается.'"),,
				"ДоверительФЛ_Удостоверение",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СокрЛП(ДоверительФЛ_СерДок) + СокрЛП(ДоверительФЛ_НомДок)) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заданы серия и номер документа.'"),,
				"ДоверительФЛ_Удостоверение",, Отказ);
		КонецЕсли;
		
		Если СтрДлина(СокрЛП(ДоверительФЛ_СерДок) + СокрЛП(ДоверительФЛ_НомДок)) > 25 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Длина серии и номера документа больше 25 символов.'"),,
				"ДоверительФЛ_Удостоверение",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_ДатаДок) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задана дата выдачи документа.'"),,
				"ДоверительФЛ_Удостоверение",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_КодВыдДок) И КодВидаДокумента = "21" Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано наименование органа, выдавшего документ.'"),,
				"ДоверительФЛ_Удостоверение",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_ИНН) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан ИНН.'"),, "ДоверительЮЛ_ИНН",,
				Отказ);
		ИначеЕсли НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(
			ДоверительФЛ_ИНН, Истина) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ИНН.'"),,
				"ДоверительЮЛ_ИНН",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_ОГРН) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан ОГРНИП.'"),,
				"ДоверительФЛ_ОГРН",, Отказ);
		ИначеЕсли СтрДлина(ДоверительФЛ_ОГРН) <> 15 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ОГРНИП.'"),,
				"ДоверительФЛ_ОГРН",, Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДоверительФЛ_СНИЛС) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан СНИЛС.'"),,
				"ДоверительФЛ_СНИЛС",, Отказ);
		ИначеЕсли СтрДлина(ДоверительФЛ_СНИЛС) <> 14 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный СНИЛС.'"),,
				"ДоверительФЛ_СНИЛС",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаКлиенте
Процедура ДоверительЮЛ_АдрНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДоверительЮЛ_АдрXML = Результат.КонтактнаяИнформация;
	ДоверительЮЛ_Адр = ДокументооборотСКОВызовСервера.ПредставлениеКонтактнойИнформации(Результат.КонтактнаяИнформация);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_ФИОНачалоВыбораЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатРедактирования) Тогда
		Возврат;
	КонецЕсли;
	
	ДоверительФЛ_Фамилия 	= РезультатРедактирования.Фамилия;
	ДоверительФЛ_Имя 		= РезультатРедактирования.Имя;
	ДоверительФЛ_Отчество 	= РезультатРедактирования.Отчество;
	
	ДоверительФЛ_ФИО = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеФИО(РезультатРедактирования);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостоверениеНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатВыбора) Тогда
		Возврат;
	КонецЕсли;
	
	ДоверительФЛ_ВидДок 	= РезультатВыбора.ДокументВид;
	ДоверительФЛ_СерДок 	= РезультатВыбора.ДокументСерия;
	ДоверительФЛ_НомДок 	= РезультатВыбора.ДокументНомер;
	ДоверительФЛ_ДатаДок 	= РезультатВыбора.ДокументДатаВыдачи;
	ДоверительФЛ_ВыдДок 	= РезультатВыбора.ДокументКемВыдан;
	ДоверительФЛ_КодВыдДок 	= РезультатВыбора.ДокументКодПодразделения;
	
	ДоверительФЛ_Удостоверение = ДокументооборотСКОКлиентСервер.ПолучитьПредставлениеУдостоверение(РезультатВыбора);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
