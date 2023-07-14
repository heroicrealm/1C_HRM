#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеДляПодбораСотрудников КАК Т2
	|	ПО Т2.ФизическоеЛицо = Т.ФизическоеЛицо
	|		И Т2.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы)
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т.ФизическоеЛицо)
	|	И (ЗначениеРазрешено(Т.Страхователь) ИЛИ ЗначениеРазрешено(Т2.Филиал))";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область НаборЗаписей

// АПК:581-выкл. Методы могут вызываться из расширений.
// АПК:299-выкл. Методы могут вызываться из расширений.
// АПК:326-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// АПК:325-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// Транзакция открывается в методе НачатьЗаписьНабора, закрывается в ЗавершитьЗаписьНабора, отменяется в ОтменитьЗаписьНабора.

// Транзакционный вариант (с управляемой блокировкой) получения набора записей, соответствующего значениям измерений.
//
// Параметры:
//   Страхователь   - ОпределяемыйТип.Организация     - Значение отбора по соответствующему измерению.
//   ФизическоеЛицо - СправочникСсылка.ФизическиеЛица - Значение отбора по соответствующему измерению.
//
// Возвращаемое значение:
//   РегистрСведенийНаборЗаписей.ПодпискиНаУведомленияОбЭЛН - Если удалось установить блокировку
//       и прочитать набор записей. При необходимости, открывает свою локальную транзакцию. Для закрытия транзакции
//       следует использовать одну из терминирующих процедур: ЗавершитьЗаписьНабора, либо ОтменитьЗаписьНабора.
//   Неопределено - Если не удалось установить блокировку и прочитать набор записей.
//       Вызывать процедуры ЗавершитьЗаписьНабора, ОтменитьЗаписьНабора не требуется,
//       поскольку если перед блокировкой функции потребовалось открыть локальную транзакцию,
//       то после неудачной блокировки локальная транзакция была отменена.
//
Функция НачатьЗаписьНабора(Страхователь, ФизическоеЛицо) Экспорт
	Если Не ЗначениеЗаполнено(Страхователь) Или Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПолныеПраваИлиПривилегированныйРежим = Пользователи.ЭтоПолноправныйПользователь();
	Если Не ПолныеПраваИлиПривилегированныйРежим
		И Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПодпискиНаУведомленияОбЭЛН) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Недостаточно прав для изменения регистра ""%1"".'"),
			Метаданные.РегистрыСведений.ПодпискиНаУведомленияОбЭЛН.Представление());
	КонецЕсли;
	ЛокальнаяТранзакция = Не ТранзакцияАктивна();
	Если ЛокальнаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПодпискиНаУведомленияОбЭЛН");
		ЭлементБлокировки.УстановитьЗначение("Страхователь", Страхователь);
		ЭлементБлокировки.УстановитьЗначение("ФизическоеЛицо", ФизическоеЛицо);
		Блокировка.Заблокировать();
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Страхователь.Установить(Страхователь);
		НаборЗаписей.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо);
		НаборЗаписей.Прочитать();
		НаборЗаписей.ДополнительныеСвойства.Вставить("ЛокальнаяТранзакция", ЛокальнаяТранзакция);
	Исключение
		Если ЛокальнаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось изменить сведения о подписках на уведомления %1 об ЭЛН %2 по причине: %3'"),
			Страхователь,
			ФизическоеЛицо,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.РегистрыСведений.ПодпискиНаУведомленияОбЭЛН,
			ФизическоеЛицо,
			ТекстСообщения);
		НаборЗаписей = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат НаборЗаписей;
КонецФункции

// Записывает набор и фиксирует локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.ПодпискиНаУведомленияОбЭЛН
//
Процедура ЗавершитьЗаписьНабора(НаборЗаписей) Экспорт
	НаборЗаписей.Записать(Истина);
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Отменяет запись набора и отменяет локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.ПодпискиНаУведомленияОбЭЛН
//
Процедура ОтменитьЗаписьНабора(НаборЗаписей) Экспорт
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ОтменитьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// АПК:326-вкл.
// АПК:325-вкл.
// АПК:299-вкл.
// АПК:581-вкл.

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция СотрудникиСДействующейПодпиской(Организация, Сотрудники) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Страхователь = СЭДОФСС.СтраховательОрганизации(Организация);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Ссылка В(&Сотрудники)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Подписки.Страхователь КАК Страхователь,
	|	Подписки.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК Подписки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТФизическиеЛица КАК ВТФизическиеЛица
	|		ПО Подписки.ФизическоеЛицо = ВТФизическиеЛица.ФизическоеЛицо
	|			И (Подписки.Страхователь = &Страхователь)
	|			И (Подписки.Действует)";
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция КоличествоОжидаемыхСообщений(Страхователь) Экспорт
	Если Не ЗначениеЗаполнено(Страхователь) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	1 КАК Поле1
	|ИЗ
	|	РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК Подписки
	|ГДЕ
	|	Подписки.Страхователь = &Страхователь
	|	И Подписки.ДатаОтправки > &ДатаНачалаАктуальности";
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	Запрос.УстановитьПараметр("ДатаНачалаАктуальности", ДатаНачалаАктуальности());
	
	Возврат Запрос.Выполнить().Выбрать().Количество();
КонецФункции

Функция ДатаНачалаАктуальности() Экспорт
	Возврат НачалоДня(ДобавитьМесяц(ТекущаяДатаСеанса(), -1));
КонецФункции

Функция ДатаОтправкиЗагруженногоСообщения() Экспорт
	Возврат '00010101';
КонецФункции

#Область СообщенияФСС

Процедура ПослеОтправкиЗапросаНаИзменениеПодписки(Страхователь, ФизическиеЛица, ДатаОтправки, БудетДействовать, ИдентификаторЗапроса) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл
		Набор = НачатьЗаписьНабора(Страхователь, ФизическоеЛицо);
		
		Если Набор.Количество() = 0 Тогда
			Запись = Набор.Добавить();
			Запись.Страхователь   = Страхователь;
			Запись.ФизическоеЛицо = ФизическоеЛицо;
		Иначе
			Запись = Набор[0];
		КонецЕсли;
		
		Запись.ДатаОтправки         = ДатаОтправки;
		Запись.БудетДействовать     = БудетДействовать;
		Запись.ИдентификаторЗапроса = ИдентификаторЗапроса;
		Запись.ТекстОшибки          = "";
		
		ЗавершитьЗаписьНабора(Набор);
	КонецЦикла;
КонецПроцедуры

Процедура ПослеРасшифровкиСообщенияОбИзмененииПодписки(Страхователь, ИдентификаторОтвета, ТекстXML, Результат) Экспорт
	// Пример:
	// <subscriptionRecipientResponse xmlns="http://www.fss.ru/integration/types/eln/event/v01" xmlns:ns2="http://www.fss.ru/integration/types/common/v01">
	//	<resultList>
	//		<result>
	//			<snils>00000060003</snils>
	//			<status>ERROR</status>
	//			<error>
	//				<ns2:code>E_ELN_0011</ns2:code>
	//				<ns2:message>Данный застрахованный уже прикреплен к страхователю 2019122401</ns2:message>
	//			</error>
	//		</result>
	//	</resultList>
	//</subscriptionRecipientResponse>
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураDOM = СериализацияБЗК.СтруктураDOM(ТекстXML);
	НераспределенныеОшибки = Новый Массив;
	ОтключитьНедействующиеПодпискиДругихСтрахователей = Ложь;
	
	РезультатXPath = СериализацияБЗК.ВычислитьВыражениеXPath(СтруктураDOM, "//*[local-name() = 'snils']/..");
	Пока Истина Цикл
		ЭлементDOM = РезультатXPath.ПолучитьСледующий();
		Если ЭлементDOM = Неопределено Тогда
			Прервать;
		КонецЕсли;
		ФрагментXML = СериализацияБЗК.ОбъектDOMВСтрокуXML(ЭлементDOM);
		УзелResult = СериализацияБЗК.ОбъектXDTOИзСтрокиXML(ФрагментXML);
		
		РеквизитыResult = ОбщегоНазначенияБЗК.ЗначенияСвойств(УзелResult, "snils, status, error");
		ТипРезультата = ВРег(СокрЛП(Строка(РеквизитыResult.Status)));
		СНИЛС = УчетПособийСоциальногоСтрахованияКлиентСервер.СНИЛСВФорматеИБ(РеквизитыResult.SNILS);
		
		Успех = Ложь;
		Ошибки = Новый Массив;
		Если ТипРезультата = "1" Или ТипРезультата = "SUCCESS" Тогда
			Успех = Истина;
		ИначеЕсли ТипРезультата = "2" Или ТипРезультата = "ERROR" Тогда
			Если РеквизитыResult.Error <> Неопределено Тогда
				РеквизитыError = ОбщегоНазначенияБЗК.ЗначенияСвойств(РеквизитыResult.Error, "code, message");
				Ошибки.Добавить(НСтр("ru = 'Ответ ФСС:'") + Символы.ПС + СокрЛП(РеквизитыError.Code + " " + РеквизитыError.Message));
			Иначе
				Ошибки.Добавить(СтрШаблон(
					НСтр("ru = 'Значение поля %1 = ""%2"", что свидетельствует об ошибке, однако текст ошибки пустой.'"),
					"status",
					ТипРезультата));
			КонецЕсли;
		Иначе
			Ошибки.Добавить(СтрШаблон(НСтр("ru = 'Неизвестное значение поля %1: %2.'"), "status", ТипРезультата));
		КонецЕсли;
		
		// Поиск физического лица по СНИЛСу.
		РезультатПоиска = ФизическиеЛицаЗарплатаКадры.ФизическоеЛицоПоСНИЛСИлиФИО(СНИЛС, "", "", "");
		ФизическоеЛицо = РезультатПоиска.ФизическоеЛицо;
		Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			Ошибки.Добавить(РезультатПоиска.ТекстОшибки);
			Ошибки.Добавить(НСтр("ru = 'Фрагмент XML:'") + Символы.ПС + ФрагментXML);
			НераспределенныеОшибки.Добавить(СтрСоединить(Ошибки, Символы.ПС));
			Продолжить;
		КонецЕсли;
		
		// Организация подписки может не совпадать с текущей организацией сотрудника
		// из-за лага между отправкой сообщения и приемом ответа.
		Набор = НачатьЗаписьНабора(Страхователь, ФизическоеЛицо);
		Если Набор.Количество() = 0 Тогда
			Запись = Набор.Добавить();
		Иначе
			Запись = Набор[0];
		КонецЕсли;
		
		Запись.Страхователь        = Страхователь;
		Запись.ФизическоеЛицо      = ФизическоеЛицо;
		Запись.ИдентификаторОтвета = ИдентификаторОтвета;
		Запись.ДатаОтправки        = ДатаОтправкиЗагруженногоСообщения();
		
		Если Успех Тогда
			// Этот флажок следует получать из ФСС, но формат типов документов 1.8 не подразумевает его передачу.
			Запись.Действует = Запись.БудетДействовать;
		КонецЕсли;
		
		Если Ошибки.Количество() > 0 Тогда
			Ошибки.Добавить(НСтр("ru = 'Фрагмент XML:'") + Символы.ПС + ФрагментXML);
			Запись.ТекстОшибки = СтрСоединить(Ошибки, Символы.ПС);
		Иначе
			Запись.ТекстОшибки = "";
		КонецЕсли;
		
		ЗавершитьЗаписьНабора(Набор);
		
		// Отключение недействующих записей.
		// Эту механику желательно выполнять независимо в каждом узле.
		Если Успех И Запись.Действует Тогда
			ОтключитьНедействующиеПодпискиДругихСтрахователей = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Результат.Обработано = Истина;
	
	Если ОтключитьНедействующиеПодпискиДругихСтрахователей Тогда
		Попытка
			ОтключитьНедействующиеПодпискиДругихСтрахователей(Страхователь);
		Исключение
			Текст = СтрШаблон(
				НСтр("ru = 'Ошибка при отключении недействующих подписок: %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			НераспределенныеОшибки.Добавить(Текст);
		КонецПопытки;
	КонецЕсли;
	
	Если НераспределенныеОшибки.Количество() > 0 Тогда
		НераспределенныеОшибки.Добавить(Символы.ПС + Символы.ПС + НСтр("ru = 'Текст XML:'") + Символы.ПС + ТекстXML);
		СЭДОФСС.ОшибкаОбработки(Результат, ИдентификаторОтвета, СтрСоединить(НераспределенныеОшибки, Символы.ПС));
		
		ТекстЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В процедуре %1 получено сообщение %2 для %3, при разборе которого обнаружены ошибки:
				|%4'"),
			"ПослеРасшифровкиСообщенияОбИзмененииПодписки",
			ИдентификаторОтвета,
			Страхователь,
			Результат.ОписаниеОшибки);
		ЗаписьЖурналаРегистрации(
			СЭДОФССРасширенный.ИмяСобытияЖурнала(),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.ВходящиеСообщенияСЭДОФСС,
			,
			ТекстЖурнала);
		
		СообщенияБЗК.СообщитьОПроблеме(Результат.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеПолученияОшибокСообщенияОбИзмененииПодпискиФизическогоЛица(Страхователь, ИдентификаторЗапроса, ТекстОшибки, Результат) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодпискиНаУведомленияОбЭЛН.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПодпискиНаУведомленияОбЭЛН.Страхователь КАК Страхователь
	|ИЗ
	|	РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК ПодпискиНаУведомленияОбЭЛН
	|ГДЕ
	|	ПодпискиНаУведомленияОбЭЛН.ИдентификаторЗапроса = &ИдентификаторЗапроса";
	Запрос.УстановитьПараметр("ИдентификаторЗапроса", ИдентификаторЗапроса);
	
	КоличествоОбработано = 0;
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если ЗаписатьОшибкуЛогическогоКонтроля(СтрокаТаблицы.Страхователь, СтрокаТаблицы.ФизическоеЛицо, ТекстОшибки) Тогда
			КоличествоОбработано = КоличествоОбработано + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоОбработано > 0 И КоличествоОбработано = Таблица.Количество() Тогда
		Результат.Обработано = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ПослеПолученияОшибокСообщенияОбИзмененииПодпискиСтрахователя(Страхователь, ТекстОшибки, Результат) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодпискиНаУведомленияОбЭЛН.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПодпискиНаУведомленияОбЭЛН.Страхователь КАК Страхователь
	|ИЗ
	|	РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК ПодпискиНаУведомленияОбЭЛН
	|ГДЕ
	|	ПодпискиНаУведомленияОбЭЛН.Страхователь = &Страхователь
	|	И ПодпискиНаУведомленияОбЭЛН.Действует <> ПодпискиНаУведомленияОбЭЛН.БудетДействовать";
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЗаписатьОшибкуЛогическогоКонтроля(СтрокаТаблицы.Страхователь, СтрокаТаблицы.ФизическоеЛицо, ТекстОшибки)
	КонецЦикла;
	
	// Флажок "Результат.Обработано" не включается, т.к. подписку страхователя обслуживают механизмы БРО.
КонецПроцедуры

Функция ЗаписатьОшибкуЛогическогоКонтроля(Страхователь, ФизическоеЛицо, ТекстОшибки)
	Набор = НачатьЗаписьНабора(Страхователь, ФизическоеЛицо);
	Если Набор.Количество() = 0 Тогда
		ОтменитьЗаписьНабора(Набор);
		Возврат Ложь;
	КонецЕсли;
	Запись = Набор[0];
	Если СтрНайти(Запись.ТекстОшибки, ТекстОшибки) > 0 Тогда
		ОтменитьЗаписьНабора(Набор);
		Возврат Истина;
	КонецЕсли;
	Запись.ДатаОтправки = ДатаОтправкиЗагруженногоСообщения();
	Запись.ТекстОшибки  = СокрЛ(
		Запись.ТекстОшибки
		+ Символы.ПС
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'От ФСС %1 получена информация об ошибках логического контроля:'"),
			Строка(ТекущаяДатаСеанса()))
		+ Символы.ПС
		+ СокрЛП(ТекстОшибки));
	ЗавершитьЗаписьНабора(Набор);
	Возврат Истина;
КонецФункции

Процедура ОтключитьНедействующиеПодпискиДругихСтрахователей(Страхователь) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтарыеПодписки.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СтарыеПодписки.Страхователь КАК Страхователь
	|ИЗ
	|	РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК НовыеПодписки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК СтарыеПодписки
	|		ПО (НовыеПодписки.Страхователь = &Страхователь)
	|			И (НовыеПодписки.Действует)
	|			И НовыеПодписки.ФизическоеЛицо = СтарыеПодписки.ФизическоеЛицо
	|			И НовыеПодписки.Страхователь <> СтарыеПодписки.Страхователь
	|			И (СтарыеПодписки.Действует)
	|			И НовыеПодписки.ДатаОтправки >= СтарыеПодписки.ДатаОтправки";
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Набор = НачатьЗаписьНабора(СтрокаТаблицы.Страхователь, СтрокаТаблицы.ФизическоеЛицо);
		Если Набор.Количество() = 0 Тогда
			ОтменитьЗаписьНабора(Набор);
		Иначе
			Запись = Набор[0];
			Запись.Действует = Ложь;
			ЗавершитьЗаписьНабора(Набор);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли