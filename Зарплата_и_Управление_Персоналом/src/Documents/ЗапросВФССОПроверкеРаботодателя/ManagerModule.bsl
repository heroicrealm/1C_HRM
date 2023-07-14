
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_Запрос";
	КомандаПечати.Представление = НСтр("ru = 'Запрос'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Вызывается при печати документа.
//
// Параметры:
//   См. одноименные параметры процедуры УправлениеПечатьюПереопределяемый.ПриПечати.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	МассивДопустимыхОбъектов = Новый Массив;
	Для каждого ДопустимыйОбъект Из МассивОбъектов Цикл
		Если ТипЗнч(ДопустимыйОбъект) = Тип("ДокументСсылка.ЗапросВФССОПроверкеРаботодателя") Тогда
			МассивДопустимыхОбъектов.Добавить(ДопустимыйОбъект);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивДопустимыхОбъектов.Количество() > 0 Тогда
		НапечататьМакет(МассивДопустимыхОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, "ПФ_MXL_Запрос", НСтр("ru = 'Запрос'"));
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область МеханизмФиксацииИзменений

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксируемыеРеквизиты());
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура НапечататьМакет(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ИмяМакета, Синоним)
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, ИмяМакета) Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, "ПФ_MXL_Запрос", НСтр("ru = 'Запрос'"), ПечатьЗапроса(МассивОбъектов, ОбъектыПечати, ИмяМакета));
	КонецЕсли;
	
КонецПроцедуры    

Функция ПечатьЗапроса(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗапросВФССОПроверкеРаботодателя";
	ТабДокумент.ПолеСлева = 0;
	ТабДокумент.ПолеСправа = 0;
	
	// запоминаем области макета
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗапросВФССОПроверкеРаботодателя." + ИмяМакета);
	ОбластьМакетаШапка	= Макет.ПолучитьОбласть("Шапка"); // Шапка документа.
	ОбластьМакетаПодвал	= Макет.ПолучитьОбласть("Подвал");// Подвал документа
	ОбластьМакета 		= Макет.ПолучитьОбласть("Страхователь"); 
	ПустаяОбластьМакета = Макет.ПолучитьОбласть("ПустойСтрахователь"); 

	// получаем данные для печати
	ВыборкаДляШапкиИПодвала = СформироватьЗапросДляПечати(МассивОбъектов).Выбрать();
	ВыборкаСтрок = СформироватьЗапросПоСтрахователи(МассивОбъектов).Выбрать();
	
	Отказ = Ложь; 
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаДляШапкиИПодвала.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;

		ПроверитьЗаполнениеШапки(ВыборкаДляШапкиИПодвала, Отказ);
		
		ОбластьМакетаШапка.Параметры.Заполнить(ВыборкаДляШапкиИПодвала); // Шапка документа.
		
		ОбластьМакетаШапка.Параметры.АдресОрганизации = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(
			ВыборкаДляШапкиИПодвала.АдресОрганизации);
		
		ОбластьМакетаШапка.Параметры.НазваниеОрганизации = СокрЛП(ОбластьМакетаШапка.Параметры.НазваниеОрганизации);
		ОбластьМакетаШапка.Параметры.НаименованиеТерриториальногоОрганаФСС = СокрЛП(ОбластьМакетаШапка.Параметры.НаименованиеТерриториальногоОрганаФСС);
		ОбластьМакетаШапка.Параметры.ВидПособия = НРег(ОбластьМакетаШапка.Параметры.ВидПособия);
		
		Если ЗначениеЗаполнено(ВыборкаДляШапкиИПодвала.Адрес) Тогда
			СведенияОбАдресе = КонтактнаяИнформацияБЗК.СведенияОбАдресеСТипами(ВыборкаДляШапкиИПодвала.Адрес);
			Поля = "Индекс, Регион, Район, Город, НаселенныйПункт, Улица, Дом, Корпус, Квартира";
			ДанныеАдреса = КонтактнаяИнформацияБЗК.СвернутьСведенияОбАдресе(СведенияОбАдресе, Поля);
			ЗаполнитьЗначенияСвойств(ОбластьМакетаШапка.Параметры, ДанныеАдреса);
		КонецЕсли;
				
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДляШапкиИПодвала); // Для подвала
		
		СписокФизлиц = Новый Массив;
		СписокФизлиц.Добавить(ВыборкаДляШапкиИПодвала.Руководитель);
				
		КадровыеДанныеФизическихЛиц = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, СписокФизлиц, "ИОФамилия");
		
		ДанныеРуководителя = КадровыеДанныеФизическихЛиц.Найти(ВыборкаДляШапкиИПодвала.Руководитель, "ФизическоеЛицо");
		Если НЕ ДанныеРуководителя = Неопределено Тогда
		   ОбластьМакетаПодвал.Параметры["ФИОРуководителя"] = ДанныеРуководителя.ИОФамилия;
		КонецЕсли;
				
		ТабДокумент.Вывести(ОбластьМакетаШапка); // Шапка документа.
		
		ВыведеноСтрок = 0;
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаДляШапкиИПодвала.Ссылка);
		
		Пока ВыборкаСтрок.НайтиСледующий(СтруктураПоиска) Цикл
			
			ПроверитьЗаполнениеСтрокиСтрахователи(ВыборкаСтрок, Отказ);
			
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрок);
			ОбластьМакета.Параметры.СтраховательНаименование = СокрЛП(ОбластьМакета.Параметры.СтраховательНаименование);
			ОбластьМакета.Параметры.НаименованиеТерриториальногоОрганаФСС = СокрЛП(ОбластьМакета.Параметры.НаименованиеТерриториальногоОрганаФСС);
	        ОбластьМакета.Параметры.ВыведеноСтрок = ВыведеноСтрок;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		Пока ВыведеноСтрок < 3 Цикл
			ВыведеноСтрок = ВыведеноСтрок + 1;
			ПустаяОбластьМакета.Параметры.ВыведеноСтрок = ВыведеноСтрок;
			ПустаяОбластьМакета.Параметры.ПериодРаботыС = '00010101';
			ПустаяОбластьМакета.Параметры.ПериодРаботыПо = '00010101';
	    	ТабДокумент.Вывести(ПустаяОбластьМакета);
		КонецЦикла;

		ТабДокумент.Вывести(ОбластьМакетаПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДляШапкиИПодвала.Ссылка);
				
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат Новый ТабличныйДокумент;
	Иначе
		Возврат ТабДокумент;
	КонецЕсли;

КонецФункции

Функция СформироватьЗапросДляПечати(МассивОбъектов)
		
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса.
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ЗапросВФССОПроверкеРаботодателя";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "Дата";
	ОписаниеИсточникаДанных.СписокСсылок = МассивОбъектов;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокументЗапрос.Дата,
	|	ДокументЗапрос.Номер,
	|	ДокументЗапрос.Организация,
	|	ДокументЗапрос.Ссылка,
	|	ДокументЗапрос.Сотрудник,
	|	ДокументЗапрос.Руководитель,
	|	Должности.Наименование КАК Должность,
	|	ДокументЗапрос.РегистрационныйНомерФСС,
	|	ДокументЗапрос.ДополнительныйКодФСС,
	|	ДокументЗапрос.КодПодчиненностиФСС,
	|	ДокументЗапрос.НаименованиеТерриториальногоОрганаФСС,
	|	ДокументЗапрос.СтраховойНомерПФР,
	|	ДокументЗапрос.Фамилия + "" "" + ДокументЗапрос.Имя + "" "" + ДокументЗапрос.Отчество КАК ФИО,
	|	Организации.НаименованиеПолное КАК НазваниеОрганизации,
	|	Организации.ИНН КАК ИНН,
	|	Организации.КПП КАК КПП,
	|	ДокументЗапрос.Адрес,
	|	ДокументЗапрос.АдресОрганизации,
	|	ДокументЗапрос.ВидПособия
	|ИЗ
	|	Документ.ЗапросВФССОПроверкеРаботодателя КАК ДокументЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК Организации
	|		ПО ДокументЗапрос.Организация = Организации.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должности КАК Должности
	|		ПО ДокументЗапрос.ДолжностьРуководителя = Должности.Ссылка
	|ГДЕ
	|	ДокументЗапрос.Ссылка В(&МассивОбъектов)";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

Функция СформироватьЗапросПоСтрахователи(МассивОбъектов) 

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Страхователи.НомерСтроки,
	|	Страхователи.Страхователь,
	|	Страхователи.ПериодРаботыПо,
	|	Страхователи.ПериодРаботыС,
	|	Страхователи.РегистрационныйНомерФСС,
	|	Страхователи.ДополнительныйКодФСС,
	|	Страхователи.КодПодчиненностиФСС,
	|	Страхователи.НаименованиеТерриториальногоОрганаФСС,
	|	Страхователи.ИНН,
	|	Страхователи.КПП,
	|	Страхователи.Ссылка
	|ПОМЕСТИТЬ ВТСтрокиДокумента
	|ИЗ
	|	Документ.ЗапросВФССОПроверкеРаботодателя.Страхователи КАК Страхователи
	|ГДЕ
	|	Страхователи.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Страхователи.НомерСтроки,
	|	ПовторныеСтроки.НомерСтроки КАК НомерПовторнойСтроки,
	|	Страхователи.Страхователь КАК Страхователь,
	|	Страхователи.Страхователь.НаименованиеПолное КАК СтраховательНаименование,
	|	Страхователи.ПериодРаботыПо,
	|	Страхователи.ПериодРаботыС,
	|	Страхователи.РегистрационныйНомерФСС,
	|	Страхователи.ДополнительныйКодФСС,
	|	Страхователи.КодПодчиненностиФСС,
	|	Страхователи.НаименованиеТерриториальногоОрганаФСС,
	|	Страхователи.ИНН,
	|	Страхователи.КПП,
	|	Страхователи.Ссылка
	|ИЗ
	|	ВТСтрокиДокумента КАК Страхователи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСтрокиДокумента КАК ПовторныеСтроки
	|		ПО Страхователи.НомерСтроки < ПовторныеСтроки.НомерСтроки
	|			И Страхователи.Страхователь = ПовторныеСтроки.Страхователь
	|			И Страхователи.Ссылка = ПовторныеСтроки.Ссылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоНачислениям()

Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ)

	//  Организация
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указана организация'"), , , , Отказ);
	КонецЕсли;
	
	// Сотрудник
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Сотрудник) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран сотрудник'"), , , , Отказ);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ФИО) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указано ФИО сотрудника'"), , , , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ВидПособия) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указан вид пособия'"), , , , Отказ);
	КонецЕсли;
	
	//  ФСС
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.НаименованиеТерриториальногоОрганаФСС) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указано наименование территориального органа ФСС'"), , , , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.РегистрационныйНомерФСС) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не указан регистрационный номер в ФСС'"), , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()    

Процедура ПроверитьЗаполнениеСтрокиСтрахователи(ВыборкаПоСтрокамДокумента, Отказ) 

	СтрокаНачалаСообщенияОбОшибке =
		НСтр("ru = 'В строке номер'") + " " + СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) + " " + НСтр("ru = 'табл. части ""Страхователи"":'") + " ";
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Страхователь) Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке + НСтр("ru = 'не указан страхователь'"), , , , Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ПериодРаботыПо) Или НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ПериодРаботыС) Или ВыборкаПоСтрокамДокумента.ПериодРаботыС > ВыборкаПоСтрокамДокумента.ПериодРаботыПо Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке +  НСтр("ru = 'неверно указан период работы у страхователя'"), , , , Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.РегистрационныйНомерФСС) Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке +  НСтр("ru = 'не указан регистрационный номер в ФСС'"), , , , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.НаименованиеТерриториальногоОрганаФСС) Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке +  НСтр("ru = 'не указано наименование территориального органа ФСС'"), , , , Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.НомерПовторнойСтроки) Тогда
		ОбщегоНазначения.СообщитьПользователю(СтрокаНачалаСообщенияОбОшибке +  НСтр("ru = 'указанный страхователь повторяется в строке'") + " " + ВыборкаПоСтрокамДокумента.НомерПовторнойСтроки, , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиСтрахователи()

#Область МеханизмФиксацииИзменений

Функция ФиксируемыеРеквизиты()
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты организации.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "Организация";
	Шаблон.ИмяГруппы           = "РеквизитыОрганизации";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НаименованиеТерриториальногоОрганаФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресОрганизации");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РегистрационныйНомерФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДополнительныйКодФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПодчиненностиФСС");
	
	// Роль подписанта Руководитель.
	Шаблон.ОснованиеЗаполнения = "Организация";
	Шаблон.ИмяГруппы           = "Руководитель";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Руководитель");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьРуководителя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиРуководителя");
	
	// Реквизиты сотрудника.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "Сотрудник";
	Шаблон.ИмяГруппы           = "ФИОСотрудника";
	Шаблон.ФиксацияГруппы      = Истина;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Фамилия");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Имя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Отчество");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "Сотрудник";
	Шаблон.ИмяГруппы           = "РеквизитыСотрудника";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СтраховойНомерПФР");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Адрес");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли