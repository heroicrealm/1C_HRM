
#Область СлужебныйПрограммныйИнтерфейс

Процедура РасширеннаяПодсказкаНажатие(Форма, ИмяПоля, ОписаниеФормыОбъекта = Неопределено) Экспорт
	
	// Заполняем структуру по умолчанию.
	ЗаполнитьОписаниеФормыОбъектаДляОрганизации(ОписаниеФормыОбъекта);
	
	СтруктураОписание = ОписаниеПоИмениЭлемента(ИмяПоля, "РасширеннаяПодсказка");
	ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация = СтруктураОписание.ИмяРеквизитаОрганизация;
	
	ОписаниеПодписи = СтруктураИменРеквизитовПодписанта(Форма, СтруктураОписание.Ключ, ОписаниеФормыОбъекта);
	
	Организация = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация);
		
	СтандартнаяОбработка = Истина;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодписиДокументовОснованияПолномочий") Тогда
		
		ДатаСведений = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "Объект.Дата");
		
		МодульПодписиДокументовОснованияПолномочийКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодписиДокументовОснованияПолномочийКлиент");
		МодульПодписиДокументовОснованияПолномочийКлиент.ОткрытьФормуНастройкиОснованияПодписи(Форма, ИмяПоля, Организация, ОписаниеПодписи, СтандартнаяОбработка, ДатаСведений);
		
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		ОткрытьФормуВыбораДолжности(Форма, ИмяПоля, Организация, ОписаниеПодписи);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииПодписывающегоЛица(Форма, ИмяЭлемента, ОписаниеФормыОбъекта = Неопределено, ДатаСведений = Неопределено) Экспорт

	ЗаполнитьОписаниеФормыОбъектаДляОрганизации(ОписаниеФормыОбъекта);
	
	СтруктураОписание = ОписаниеПоИмениЭлемента(ИмяЭлемента);
	ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация = СтруктураОписание.ИмяРеквизитаОрганизация;
	ОписаниеФормыОбъекта.ИмяПосадочнойГруппы = ПодписиДокументовКлиентСервер.ИмяПосадочнойГруппыПоОрганизации(СтруктураОписание.ИмяРеквизитаОрганизация);
	
	Организация = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + ОписаниеФормыОбъекта.ИмяРеквизитаОрганизация);
		
	ДатаСведений = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + "Дата");
	
	СтруктураОписанияПодписанта = СтруктураИменРеквизитовПодписанта(Форма, СтруктураОписание.Ключ, ОписаниеФормыОбъекта);
	
	ФизическоеЛицо = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, СтруктураОписанияПодписанта.ФизическоеЛицо);
	
	// Заполняем реквизиты формы, связанные с основанием полномочий
	ДанныеФизическогоЛица = ПодписиДокументовВызовСервера.ОснованияПолномочийФизическихЛиц(Организация, ФизическоеЛицо, ДатаСведений).Получить(ФизическоеЛицо);
	ПодписиДокументовКлиентСервер.ЗаполнитьОснованияПолномочийВФорме(Форма, СтруктураОписанияПодписанта, ДанныеФизическогоЛица);
	
	ПодписиДокументовКлиентСервер.УстановитьПредставлениеПодписей(Форма, ОписаниеФормыОбъекта);
	ПодписиДокументовКлиентСервер.УстановитьЗаголовокГруппеПодписей(Форма, ОписаниеФормыОбъекта);
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		ОбработатьСменуПодписи(Форма, ОписаниеФормыОбъекта, СтруктураОписание, ФизическоеЛицо);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуВыбораДолжности(Форма, ИмяПоля, Организация, СтруктураОписанияПодписанта) Экспорт

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ИмяПоля", ИмяПоля);
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("ФизическоеЛицо",
		ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, СтруктураОписанияПодписанта.ФизическоеЛицо));
	ДополнительныеПараметры.Вставить("ОписаниеПолей", СтруктураОписанияПодписанта);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбновитьПредставлениеОснованияПодписиВФорме", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", 
		ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, СтруктураОписанияПодписанта.Должность));
	
	ОткрытьФорму("Справочник.Должности.ФормаВыбора", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор,,, ОповещениеОЗакрытии);

КонецПроцедуры

Функция ОписаниеПоИмениЭлемента(ИмяЭлементаФормы, Постфикс = "") Экспорт
	
	Описание = Новый Структура(
		"Ключ, 
		|ИмяРеквизитаОрганизация");
	
	Позиция = СтрНайти(ИмяЭлементаФормы, "Подписи") - 1;
	
	ИмяКлюча = Прав(ИмяЭлементаФормы, СтрДлина(ИмяЭлементаФормы) - (Позиция + 7));
	Если ЗначениеЗаполнено(Постфикс) Тогда
		ИмяКлюча = СтрЗаменить(ИмяКлюча, Постфикс, "");
	КонецЕсли;
	
	Описание.Ключ = ИмяКлюча;
	Описание.ИмяРеквизитаОрганизация = Лев(ИмяЭлементаФормы, Позиция);
	
	Возврат Описание;
	
КонецФункции

Функция СтруктураИменРеквизитовПодписанта(Форма, РольПодписанта, ОписаниеФормыОбъекта) Экспорт

	ОписаниеПолейПодписантов = ПодписиДокументовКлиентСервер.СоответствиеОписанийПодписейДокументаДляОрганизации(Форма, ОписаниеФормыОбъекта);
	Возврат ОписаниеПолейПодписантов.Получить(РольПодписанта);

КонецФункции

// Открывает форму редактирования настройки смены подписи
// 
Процедура ОткрытьФормуНастройкиСменыПодписи(Форма) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкаСменыПодписи");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик закрытия формы настройки.
//
Процедура ОбновитьПредставлениеОснованияПодписиВФорме(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено
		Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ИмяПоля = ДополнительныеПараметры.ИмяПоля;
	ОписаниеПолей = ДополнительныеПараметры.ОписаниеПолей;
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ОписаниеПолей.Должность, Результат);
	
	ПодписиДокументовКлиентСервер.УстановитьПредставлениеПодписи(Форма, ИмяПоля, ОписаниеПолей);
	
	ПодписиДокументовВызовСервера.ЗаписатьОснованияПолномочийОтветственныхЛиц(ДополнительныеПараметры.Организация, ДополнительныеПараметры.ФизическоеЛицо, Результат, Истина);
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьОписаниеФормыОбъектаДляОрганизации(ОписаниеФормыОбъекта = Неопределено)

	Если ОписаниеФормыОбъекта = Неопределено Тогда
		ОписаниеФормыОбъекта = ПодписиДокументовКлиентСервер.ОписаниеФормыОбъектаДляОрганизацииПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьСменуПодписи(Форма, ОписаниеФормыОбъекта, СтруктураОписание, ФизическоеЛицо)
	
	ОбъектСсылка = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, ОписаниеФормыОбъекта.ПрефиксФормыОбъект + "Ссылка");
	ВидДокумента = ТипЗнч(ОбъектСсылка);
	
	ЗначениеНастройкиСменыПодписи = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПользователя",
		"НастройкиСменыПодписи",
		ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ВызыватьДиалог);
		
	Если ЗначениеНастройкиСменыПодписи = ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ВызыватьДиалог Тогда
		
		СведенияОбОтветственныхРаботниках = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "СведенияОбОтветственныхРаботниках");
		СведенияОбОтветственныхРаботникахПоОрганизации = СведенияОбОтветственныхРаботниках.Получить(СтруктураОписание.ИмяРеквизитаОрганизация);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОписаниеФормыОбъекта", ОписаниеФормыОбъекта);
		ПараметрыФормы.Вставить("ИмяРеквизитаОрганизация", СтруктураОписание.ИмяРеквизитаОрганизация);
		ПараметрыФормы.Вставить("РольПодписанта", СтруктураОписание.Ключ);
		ПараметрыФормы.Вставить("ФизическоеЛицо", ФизическоеЛицо);
		ПараметрыФормы.Вставить("ВидДокумента", ВидДокумента);
		ПараметрыФормы.Вставить("ПредыдущийПодписант", СведенияОбОтветственныхРаботникахПоОрганизации[СтруктураОписание.Ключ]);
		
		ОткрытьФорму("ОбщаяФорма.СменаПодписи", ПараметрыФормы, Форма);
		
	Иначе
		
		СменаПодписантовВФорме = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "СменаПодписантов");
		Если ТипЗнч(СменаПодписантовВФорме) = Тип("ФиксированноеСоответствие") Тогда
			СменаПодписантов = Новый Соответствие(СменаПодписантовВФорме);
			СменаПодписантовПоОрганизации = СменаПодписантов.Получить(СтруктураОписание.ИмяРеквизитаОрганизация);
		Иначе
			СменаПодписантов = Новый Соответствие;
			СменаПодписантовПоОрганизации = Новый Соответствие;
		КонецЕсли;
		
		СменаПодписантовПоОрганизации.Вставить(СтруктураОписание.Ключ, ЗначениеНастройкиСменыПодписи);
		СменаПодписантов.Вставить(СтруктураОписание.ИмяРеквизитаОрганизация, СменаПодписантовПоОрганизации);
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "СменаПодписантов", Новый ФиксированноеСоответствие(СменаПодписантов));
		
		ПодписиДокументовКлиентСервер.ЗапомнитьПодписиДокументовВФорме(Форма, ОписаниеФормыОбъекта, Истина);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти