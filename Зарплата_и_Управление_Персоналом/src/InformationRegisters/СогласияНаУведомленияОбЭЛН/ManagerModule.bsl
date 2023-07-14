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

// СтандартныеПодсистемы.ТекущиеДела

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.СогласияНаУведомленияОбЭЛН;
	
	Если Не СЭДОФСС.ДоступенОбменЧерезСЭДО()
		Или Не ПолучитьФункциональнуюОпцию("ПолучатьУведомленияОбЭЛН")
		Или Не ПравоДоступа("Просмотр", МетаданныеРегистра) Тогда
		Возврат; // Нет прав.
	КонецЕсли;
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(МетаданныеРегистра.ПолноеИмя());
	Если Разделы.Количество() = 0 Тогда
		Возврат; // Некорректное внедрение.
	КонецЕсли;
	
	КоличествоТребованийПоОтключению = ТребованияПоОтключениюПодписокНаЭЛН().Количество();
	КоличествоТребованийПоВключению  = ТребованияПоВключениюПодписокНаЭЛН().Количество();
	
	Для Каждого Раздел Из Разделы Цикл
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = "ОтключениеПодпискиСЭДОФСС" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "_");
		Дело.ЕстьДела       = (КоличествоТребованийПоОтключению > 0);
		Дело.Важное         = Истина;
		Дело.Владелец       = Раздел;
		Дело.Представление  = НСтр("ru = 'Отключить подписку на уведомления об ЭЛН'");
		Дело.Количество     = КоличествоТребованийПоОтключению;
		Дело.Подсказка      = НСтр("ru = 'При увольнении или отзыве согласий сотрудников необходимо отключить подписку на уведомления ФСС об изменении состояний ЭЛН.'");
		Дело.ПараметрыФормы = Новый Структура("ВключитьПодписку, ЗаполнитьПоДаннымУчета, КлючУникальности", Ложь, Истина, "1");
		Дело.Форма          = "РегистрСведений.СогласияНаУведомленияОбЭЛН.Форма.ИзменениеСоставаПодписок";
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = "ВключениеПодпискиСЭДОФСС" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "_");
		Дело.ЕстьДела       = (КоличествоТребованийПоВключению > 0);
		Дело.Важное         = Ложь;
		Дело.Владелец       = Раздел;
		Дело.Представление  = НСтр("ru = 'Включить подписку на уведомления об ЭЛН'");
		Дело.Количество     = КоличествоТребованийПоВключению;
		Дело.Подсказка      = НСтр("ru = 'После подписания согласия можно включить подписку на уведомления ФСС об изменении состояний ЭЛН.'");
		Дело.ПараметрыФормы = Новый Структура("ВключитьПодписку, ЗаполнитьПоДаннымУчета, КлючУникальности", Истина, Истина, "2");
		Дело.Форма          = "РегистрСведений.СогласияНаУведомленияОбЭЛН.Форма.ИзменениеСоставаПодписок";
		
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ТекущиеДела

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

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
//   РегистрСведенийНаборЗаписей.СогласияНаУведомленияОбЭЛН - Если удалось установить блокировку
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
		И Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СогласияНаУведомленияОбЭЛН) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Недостаточно прав для изменения регистра ""%1"".'"),
			Метаданные.РегистрыСведений.СогласияНаУведомленияОбЭЛН.Представление());
	КонецЕсли;
	ЛокальнаяТранзакция = Не ТранзакцияАктивна();
	Если ЛокальнаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СогласияНаУведомленияОбЭЛН");
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
			НСтр("ru = 'Не удалось изменить сведения о действующих согласиях на уведомления %1 об ЭЛН %2 по причине: %3'"),
			Страхователь,
			ФизическоеЛицо,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.РегистрыСведений.СогласияНаУведомленияОбЭЛН,
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
//   НаборЗаписей - РегистрСведенийНаборЗаписей.СогласияНаУведомленияОбЭЛН
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
//   НаборЗаписей - РегистрСведенийНаборЗаписей.СогласияНаУведомленияОбЭЛН
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


#Область СлужебныеПроцедурыИФункции

// Возвращает таблицу физических лиц страхователей, по которым ожидается отключение подписок.
Функция ТребованияПоОтключениюПодписокНаЭЛН() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Подписки.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Подписки.Страхователь КАК Страхователь
	|ИЗ
	|	РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК Подписки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СогласияНаУведомленияОбЭЛН КАК Согласия
	|		ПО Подписки.ФизическоеЛицо = Согласия.ФизическоеЛицо
	|			И Подписки.Страхователь = Согласия.Страхователь
	|ГДЕ
	|	(Согласия.Состояние ЕСТЬ NULL
	|			ИЛИ Согласия.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСогласийНаУведомленияОбЭЛН.ПустаяСсылка)
	|			ИЛИ Согласия.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСогласийНаУведомленияОбЭЛН.ОжидаетПодписания)
	|			ИЛИ Согласия.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСогласийНаУведомленияОбЭЛН.НеПланируетсяПодписывать)
	|			ИЛИ Согласия.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСогласийНаУведомленияОбЭЛН.Отозвано)
	|				И Согласия.ДатаОтзываСогласия <= &НачалоТекущегоДня)
	|	И (Подписки.Действует
	|			ИЛИ Подписки.БудетДействовать
	|				И Подписки.ДатаОтправки > &ДатаНачалаАктуальности)";
	Запрос.УстановитьПараметр("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ДатаНачалаАктуальности", РегистрыСведений.ПодпискиНаУведомленияОбЭЛН.ДатаНачалаАктуальности());
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

// Возвращает таблицу физических лиц страхователей, по которым ожидается включение подписок.
Функция ТребованияПоВключениюПодписокНаЭЛН() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Согласия.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Согласия.Страхователь КАК Страхователь
	|ИЗ
	|	РегистрСведений.СогласияНаУведомленияОбЭЛН КАК Согласия
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодпискиНаУведомленияОбЭЛН КАК Подписки
	|		ПО Согласия.ФизическоеЛицо = Подписки.ФизическоеЛицо
	|			И Согласия.Страхователь = Подписки.Страхователь
	|ГДЕ
	|	Согласия.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСогласийНаУведомленияОбЭЛН.Подписано)
	|	И Согласия.ДатаОтзываСогласия = &МаксимальнаяДата
	|	И ВЫБОР
	|			КОГДА Подписки.Действует ЕСТЬ NULL
	|				ТОГДА ИСТИНА
	|			КОГДА Подписки.Действует = ЛОЖЬ
	|				ТОГДА Подписки.БудетДействовать = ЛОЖЬ
	|						ИЛИ Подписки.ДатаОтправки <= &ДатаНачалаАктуальности
	|			ИНАЧЕ Подписки.БудетДействовать = ЛОЖЬ
	|					И Подписки.ДатаОтправки > &ДатаНачалаАктуальности
	|		КОНЕЦ";
	МаксимальнаяДата = НачалоДня(ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата());
	Запрос.УстановитьПараметр("МаксимальнаяДата", МаксимальнаяДата);
	Запрос.УстановитьПараметр("ДатаНачалаАктуальности", РегистрыСведений.ПодпискиНаУведомленияОбЭЛН.ДатаНачалаАктуальности());
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Процедура ОбновитьПоФизическимЛицам(ФизическиеЛица) Экспорт
	Если ФизическиеЛица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СогласияНаУведомленияОбЭЛН.Страхователь КАК Страхователь,
	|	СогласияНаУведомленияОбЭЛН.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрСведений.СогласияНаУведомленияОбЭЛН КАК СогласияНаУведомленияОбЭЛН
	|ГДЕ
	|	СогласияНаУведомленияОбЭЛН.ФизическоеЛицо В(&ФизическиеЛица)
	|ИТОГИ ПО
	|	Страхователь";
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Для Каждого СтрокаСтрахователь Из Дерево.Строки Цикл
		Обновить(СтрокаСтрахователь.Страхователь, СтрокаСтрахователь.Строки.ВыгрузитьКолонку("Сотрудник"));
	КонецЦикла;
	
КонецПроцедуры

// Обновляет сведения о действующем согласии и отзыве для указанной организации и сотрудников.
//
// Возвращаемое значение:
//   Число - Количество обновленных записей регистра (пар Страхователь + ФизическоеЛицо).
//
Функция Обновить(Страхователь, Сотрудники) Экспорт
	Если Не ЗначениеЗаполнено(Страхователь) Тогда
		Возврат 0; // Для пустой организации нет согласий.
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Сотрудники = Неопределено Тогда
		ОрганизацииСтрахователя = СЭДОФСС.ОрганизацииСтрахователя(Страхователь);
		МассивСотрудников = СотрудникиОрганизацииВключаяУволенных(ОрганизацииСтрахователя);
	ИначеЕсли ТипЗнч(Сотрудники) = Тип("Массив") Тогда
		Если Сотрудники.Количество() = 0 Тогда
			Возврат 0;
		Иначе
			МассивСотрудников = Сотрудники;
		КонецЕсли;
	ИначеЕсли Не ЗначениеЗаполнено(Сотрудники) Тогда
		Возврат 0; // Для пустого сотрудника нет согласий.
	Иначе
		МассивСотрудников = Новый Массив;
		МассивСотрудников.Добавить(Сотрудники);
	КонецЕсли;
	
	// Для получения актуальной пары согласие-отзыв строится "срез последних" по согласиям и отзывам.
	// По каждому сотруднику выбирается последнее согласие и первый отзыв с даты последнего согласия.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КадровыеДанные.ДатаУвольнения КАК ДатаУвольнения,
	|	КадровыеДанные.ПриказОбУвольнении КАК ПриказОбУвольнении,
	|	КадровыеДанные.ФизическоеЛицо КАК ФизическоеЛицо,
	|	КадровыеДанные.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТКадровыеДанные
	|ИЗ
	|	&КадровыеДанные КАК КадровыеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КадровыеДанные.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Согласия.Сотрудник КАК Сотрудник,
	|	Согласия.Дата КАК Дата,
	|	Согласия.Ссылка КАК Ссылка,
	|	Согласия.Проведен КАК Проведен,
	|	Согласия.СотрудникПодписалСогласие КАК СотрудникПодписалСогласие,
	|	ВЫБОР
	|		КОГДА НЕ Согласия.Проведен
	|			ТОГДА &Состояние_ОжидаетПодписания
	|		КОГДА Согласия.СотрудникПодписалСогласие
	|			ТОГДА &Состояние_Подписано
	|		ИНАЧЕ &Состояние_НеПланируетсяПодписывать
	|	КОНЕЦ КАК СостояниеДокумента
	|ПОМЕСТИТЬ ВТВсеСогласия
	|ИЗ
	|	Документ.СогласиеНаУведомлениеОбЭЛН КАК Согласия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанные КАК КадровыеДанные
	|		ПО Согласия.ФизическоеЛицо = КадровыеДанные.ФизическоеЛицо
	|			И (Согласия.Страхователь = &Страхователь)
	|			И (НЕ Согласия.ПометкаУдаления)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследниеДатыСогласий.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПоследниеДатыСогласий.Дата КАК Дата,
	|	ПоследниеДатыСогласий.СостояниеДокумента КАК СостояниеДокумента,
	|	ВТВсеСогласия.Ссылка КАК Ссылка,
	|	ВТВсеСогласия.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТПоследниеСогласия
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТСогласия.ФизическоеЛицо КАК ФизическоеЛицо,
	|		МАКСИМУМ(ВТСогласия.Дата) КАК Дата,
	|		ВТСогласия.СостояниеДокумента КАК СостояниеДокумента
	|	ИЗ
	|		ВТВсеСогласия КАК ВТСогласия
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВТСогласия.ФизическоеЛицо,
	|		ВТСогласия.СостояниеДокумента) КАК ПоследниеДатыСогласий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВсеСогласия КАК ВТВсеСогласия
	|		ПО ПоследниеДатыСогласий.ФизическоеЛицо = ВТВсеСогласия.ФизическоеЛицо
	|			И ПоследниеДатыСогласий.Дата = ВТВсеСогласия.Дата
	|			И ПоследниеДатыСогласий.СостояниеДокумента = ВТВсеСогласия.СостояниеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ЕСТЬNULL(Подписанные.Сотрудник, ОжидающиеПодписания.Сотрудник), НеБудутПодписаны.Сотрудник) КАК Сотрудник,
	|	ЕСТЬNULL(ЕСТЬNULL(Подписанные.ФизическоеЛицо, ОжидающиеПодписания.ФизическоеЛицо), НеБудутПодписаны.ФизическоеЛицо) КАК ФизическоеЛицо,
	|	ЕСТЬNULL(Подписанные.Дата, &ПустаяДата) КАК ДатаПодписанного,
	|	ЕСТЬNULL(Подписанные.Ссылка, НЕОПРЕДЕЛЕНО) КАК СсылкаПодписанного,
	|	ЕСТЬNULL(ОжидающиеПодписания.Дата, &ПустаяДата) КАК ДатаОжидающегоПодписания,
	|	ЕСТЬNULL(ОжидающиеПодписания.Ссылка, НЕОПРЕДЕЛЕНО) КАК СсылкаОжидающегоПодписания,
	|	ЕСТЬNULL(НеБудутПодписаны.Дата, &ПустаяДата) КАК ДатаНеБудетПодписано,
	|	ЕСТЬNULL(НеБудутПодписаны.Ссылка, НЕОПРЕДЕЛЕНО) КАК СсылкаНеБудетПодписано
	|ПОМЕСТИТЬ ВТСогласия
	|ИЗ
	|	ВТПоследниеСогласия КАК Подписанные
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТПоследниеСогласия КАК ОжидающиеПодписания
	|		ПО Подписанные.ФизическоеЛицо = ОжидающиеПодписания.ФизическоеЛицо
	|			И (Подписанные.СостояниеДокумента = &Состояние_Подписано)
	|			И (ОжидающиеПодписания.СостояниеДокумента = &Состояние_ОжидаетПодписания)
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТВсеСогласия КАК НеБудутПодписаны
	|		ПО Подписанные.ФизическоеЛицо = НеБудутПодписаны.ФизическоеЛицо
	|			И (Подписанные.СостояниеДокумента = &Состояние_Подписано)
	|			И (НеБудутПодписаны.СостояниеДокумента = &Состояние_НеПланируетсяПодписывать)
	|ГДЕ
	|	ЕСТЬNULL(Подписанные.СостояниеДокумента, &Состояние_Подписано) = &Состояние_Подписано
	|	И ЕСТЬNULL(ОжидающиеПодписания.СостояниеДокумента, &Состояние_ОжидаетПодписания) = &Состояние_ОжидаетПодписания
	|	И ЕСТЬNULL(НеБудутПодписаны.СостояниеДокумента, &Состояние_НеПланируетсяПодписывать) = &Состояние_НеПланируетсяПодписывать
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеОтзывы.Дата КАК Дата,
	|	ВсеОтзывы.Ссылка КАК Ссылка,
	|	ВсеОтзывы.Сотрудник КАК Сотрудник,
	|	ВсеОтзывы.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТВсеОтзывы
	|ИЗ
	|	(ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(Увольнения.ДатаУвольнения, ДЕНЬ, 1), ДЕНЬ) КАК Дата,
	|		Увольнения.ПриказОбУвольнении КАК Ссылка,
	|		Увольнения.Сотрудник КАК Сотрудник,
	|		Увольнения.ФизическоеЛицо КАК ФизическоеЛицо
	|	ИЗ
	|		ВТКадровыеДанные КАК Увольнения
	|	ГДЕ
	|		НАЧАЛОПЕРИОДА(Увольнения.ДатаУвольнения, ДЕНЬ) > &ПустаяДата
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(ОтзывыСогласий.Дата, ДЕНЬ),
	|		ОтзывыСогласий.Ссылка,
	|		ОтзывыСогласий.Сотрудник,
	|		КадровыеДанные.ФизическоеЛицо
	|	ИЗ
	|		Документ.ОтзывСогласияНаУведомлениеОбЭЛН КАК ОтзывыСогласий
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТСогласия КАК ВТСогласия
	|			ПО ОтзывыСогласий.Сотрудник = ВТСогласия.Сотрудник
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанные КАК КадровыеДанные
	|			ПО ОтзывыСогласий.Сотрудник = КадровыеДанные.Сотрудник
	|	ГДЕ
	|		ОтзывыСогласий.Сотрудник В(&МассивСотрудников)
	|		И ОтзывыСогласий.Страхователь = &Страхователь
	|		И ОтзывыСогласий.Проведен
	|		И ОтзывыСогласий.Дата >= ЕСТЬNULL(ВТСогласия.ДатаПодписанного, &ПустаяДата)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(ВидыЗанятости.ДатаНачала, ДЕНЬ),
	|		ВидыЗанятости.РегистраторЗаписи,
	|		ВидыЗанятости.Сотрудник,
	|		ВидыЗанятости.ФизическоеЛицо
	|	ИЗ
	|		РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятости
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТСогласия КАК ВТСогласия
	|			ПО ВидыЗанятости.Сотрудник = ВТСогласия.Сотрудник
	|	ГДЕ
	|		ВидыЗанятости.Сотрудник В(&МассивСотрудников)
	|		И ВидыЗанятости.ВидЗанятости <> &ВидЗанятости_ОсновноеМестоРаботы
	|		И НАЧАЛОПЕРИОДА(ВидыЗанятости.ДатаНачала, ДЕНЬ) >= ЕСТЬNULL(ВТСогласия.ДатаПодписанного, &ПустаяДата)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(КадроваяИстория.ДатаНачала, ДЕНЬ),
	|		КадроваяИстория.РегистраторЗаписи,
	|		КадроваяИстория.Сотрудник,
	|		КадроваяИстория.ФизическоеЛицо
	|	ИЗ
	|		РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИстория
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТСогласия КАК ВТСогласия
	|			ПО КадроваяИстория.Сотрудник = ВТСогласия.Сотрудник
	|	ГДЕ
	|		КадроваяИстория.Сотрудник В(&МассивСотрудников)
	|		И НЕ КадроваяИстория.Организация В (&ОрганизацииСтрахователя)
	|		И НАЧАЛОПЕРИОДА(КадроваяИстория.ДатаНачала, ДЕНЬ) >= ЕСТЬNULL(ВТСогласия.ДатаПодписанного, &ПустаяДата)) КАК ВсеОтзывы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПервыеДатыОтзывовПослеПоследнихСогласий.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПервыеДатыОтзывовПослеПоследнихСогласий.Дата КАК Дата,
	|	ВТВсеОтзывы.Ссылка КАК Ссылка,
	|	ВТВсеОтзывы.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТОтзывы
	|ИЗ
	|	(ВЫБРАТЬ
	|		Отзывы.ФизическоеЛицо КАК ФизическоеЛицо,
	|		МИНИМУМ(Отзывы.Дата) КАК Дата,
	|		МИНИМУМ(Отзывы.Ссылка) КАК Ссылка
	|	ИЗ
	|		ВТВсеОтзывы КАК Отзывы
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Отзывы.ФизическоеЛицо) КАК ПервыеДатыОтзывовПослеПоследнихСогласий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВсеОтзывы КАК ВТВсеОтзывы
	|		ПО ПервыеДатыОтзывовПослеПоследнихСогласий.ФизическоеЛицо = ВТВсеОтзывы.ФизическоеЛицо
	|			И ПервыеДатыОтзывовПослеПоследнихСогласий.Дата = ВТВсеОтзывы.Дата
	|			И ПервыеДатыОтзывовПослеПоследнихСогласий.Ссылка = ВТВсеОтзывы.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТОтзывы.Сотрудник, ВТСогласия.Сотрудник) КАК Сотрудник,
	|	ЕСТЬNULL(ВТОтзывы.ФизическоеЛицо, ВТСогласия.ФизическоеЛицо) КАК ФизическоеЛицо,
	|	ЕСТЬNULL(ВТОтзывы.Дата, &МаксимальнаяДата) КАК ДатаОтзываСогласия,
	|	ЕСТЬNULL(ВТОтзывы.Ссылка, НЕОПРЕДЕЛЕНО) КАК ОснованиеОтзываСогласия,
	|	ЕСТЬNULL(ВТСогласия.ДатаОжидающегоПодписания, &ПустаяДата) КАК ДатаСогласия_ОжидаетПодписания,
	|	ЕСТЬNULL(ВТСогласия.ДатаПодписанного, &ПустаяДата) КАК ДатаСогласия_Подписано,
	|	ЕСТЬNULL(ВТСогласия.ДатаНеБудетПодписано, &ПустаяДата) КАК ДатаСогласия_НеПланируетсяПодписывать,
	|	ЕСТЬNULL(ВТСогласия.СсылкаОжидающегоПодписания, НЕОПРЕДЕЛЕНО) КАК СсылкаСогласия_ОжидаетПодписания,
	|	ЕСТЬNULL(ВТСогласия.СсылкаПодписанного, НЕОПРЕДЕЛЕНО) КАК СсылкаСогласия_Подписано,
	|	ЕСТЬNULL(ВТСогласия.СсылкаНеБудетПодписано, НЕОПРЕДЕЛЕНО) КАК СсылкаСогласия_НеПланируетсяПодписывать
	|ИЗ
	|	ВТСогласия КАК ВТСогласия
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТОтзывы КАК ВТОтзывы
	|		ПО ВТСогласия.Сотрудник = ВТОтзывы.Сотрудник";
	
	Поля = "Организация, ФизическоеЛицо, ДатаУвольнения, ПриказОбУвольнении";
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, МассивСотрудников, Поля);
	
	ПустаяДата = '00010101';
	МаксимальнаяДата = НачалоДня(ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата());
	
	Состояние_Отозвано                 = Перечисления.СостоянияСогласийНаУведомленияОбЭЛН.Отозвано;
	Состояние_Подписано                = Перечисления.СостоянияСогласийНаУведомленияОбЭЛН.Подписано;
	Состояние_ОжидаетПодписания        = Перечисления.СостоянияСогласийНаУведомленияОбЭЛН.ОжидаетПодписания;
	Состояние_НеПланируетсяПодписывать = Перечисления.СостоянияСогласийНаУведомленияОбЭЛН.НеПланируетсяПодписывать;
	ВидЗанятости_ОсновноеМестоРаботы   = Перечисления.ВидыЗанятости.ОсновноеМестоРаботы;
	
	Запрос.УстановитьПараметр("МассивСотрудников", МассивСотрудников);
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	Запрос.УстановитьПараметр("ОрганизацииСтрахователя", СЭДОФСС.ОрганизацииСтрахователя(Страхователь));
	Запрос.УстановитьПараметр("ПустаяДата", ПустаяДата);
	Запрос.УстановитьПараметр("МаксимальнаяДата", МаксимальнаяДата);
	Запрос.УстановитьПараметр("Состояние_Подписано", Состояние_Подписано);
	Запрос.УстановитьПараметр("Состояние_ОжидаетПодписания", Состояние_ОжидаетПодписания);
	Запрос.УстановитьПараметр("Состояние_НеПланируетсяПодписывать", Состояние_НеПланируетсяПодписывать);
	Запрос.УстановитьПараметр("ВидЗанятости_ОсновноеМестоРаботы", ВидЗанятости_ОсновноеМестоРаботы);
	Запрос.УстановитьПараметр("КадровыеДанные", КадровыеДанные);
	Количество = 0;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ДатаОтзываСогласия                    = НачалоДня(СтрокаТаблицы.ДатаОтзываСогласия);
		ДатаСогласия_Подписано                = НачалоДня(СтрокаТаблицы.ДатаСогласия_Подписано);
		ДатаСогласия_ОжидаетПодписания        = НачалоДня(СтрокаТаблицы.ДатаСогласия_ОжидаетПодписания);
		ДатаСогласия_НеПланируетсяПодписывать = НачалоДня(СтрокаТаблицы.ДатаСогласия_НеПланируетсяПодписывать);
		
		Если ТипЗнч(СтрокаТаблицы.ОснованиеОтзываСогласия) = Тип("ДокументСсылка.Увольнение")
			Или ТипЗнч(СтрокаТаблицы.ОснованиеОтзываСогласия) = Тип("ДокументСсылка.УвольнениеСписком") Тогда
			
			// Уничтожение согласий, введенных после увольнения.
			Если ДатаОтзываСогласия < ДатаСогласия_Подписано Тогда
				ДатаСогласия_Подписано = ПустаяДата;
			КонецЕсли;
			Если ДатаОтзываСогласия < ДатаСогласия_ОжидаетПодписания Тогда
				ДатаСогласия_ОжидаетПодписания = ПустаяДата;
			КонецЕсли;
			Если ДатаОтзываСогласия < ДатаСогласия_НеПланируетсяПодписывать Тогда
				ДатаСогласия_НеПланируетсяПодписывать = ПустаяДата;
			КонецЕсли;
			
		Иначе
			
			Если Не ЗначениеЗаполнено(ДатаОтзываСогласия) Тогда
				// Инициализация даты отзыва согласий.
				ДатаОтзываСогласия = МаксимальнаяДата;
			ИначеЕсли ДатаОтзываСогласия < ДатаСогласия_Подписано Тогда
				// После отзыва было еще одно согласие, которое "перебивает" отзыв.
				ДатаОтзываСогласия = МаксимальнаяДата;
				СтрокаТаблицы.ОснованиеОтзываСогласия = Неопределено;
			КонецЕсли;
			
		КонецЕсли;
		
		Набор = НачатьЗаписьНабора(Страхователь, СтрокаТаблицы.ФизическоеЛицо);
		Количество = Количество + 1;
		
		Если Не ЗначениеЗаполнено(ДатаСогласия_Подписано)
			И Не ЗначениеЗаполнено(ДатаСогласия_ОжидаетПодписания)
			И Не ЗначениеЗаполнено(ДатаСогласия_НеПланируетсяПодписывать) Тогда
			// Согласия не оформлялись.
			Набор.Очистить();
			ЗавершитьЗаписьНабора(Набор);
			Продолжить;
		КонецЕсли;
		
		Если Набор.Количество() = 0 Тогда
			Запись = Набор.Добавить();
		Иначе
			Запись = Набор[0];
		КонецЕсли;
		
		Запись.Страхователь            = Страхователь;
		Запись.ФизическоеЛицо          = СтрокаТаблицы.ФизическоеЛицо;
		Запись.ДатаОтзываСогласия      = ДатаОтзываСогласия;
		Запись.ОснованиеОтзываСогласия = СтрокаТаблицы.ОснованиеОтзываСогласия;
		Запись.Сотрудник               = СтрокаТаблицы.Сотрудник;
		
		Если Не ЗначениеЗаполнено(ДатаСогласия_Подписано) Тогда
			Запись.Подписано = Ложь;
			
			// Согласие не подписано.
			Если ДатаСогласия_ОжидаетПодписания >= ДатаСогласия_НеПланируетсяПодписывать Тогда
				Запись.Состояние    = Состояние_ОжидаетПодписания;
				Запись.Согласие     = СтрокаТаблицы.СсылкаСогласия_ОжидаетПодписания;
				Запись.ДатаСогласия = ДатаСогласия_ОжидаетПодписания;
			Иначе
				Запись.Состояние    = Состояние_НеПланируетсяПодписывать;
				Запись.Согласие     = СтрокаТаблицы.СсылкаСогласия_НеПланируетсяПодписывать;
				Запись.ДатаСогласия = ДатаСогласия_НеПланируетсяПодписывать;
			КонецЕсли;
			
		Иначе
			Запись.Подписано = Истина;
			
			Если ДатаОтзываСогласия = МаксимальнаяДата Тогда
				// Согласия подписано и не отозвано.
				Запись.Согласие     = СтрокаТаблицы.СсылкаСогласия_Подписано;
				Запись.Состояние    = Состояние_Подписано;
				Запись.ДатаСогласия = ДатаСогласия_Подписано;
				
			ИначеЕсли ДатаОтзываСогласия < ДатаСогласия_Подписано Тогда
				// После отзыва подписано еще одно согласие.
				Запись.Согласие     = СтрокаТаблицы.СсылкаСогласия_Подписано;
				Запись.Состояние    = Состояние_Подписано;
				Запись.ДатаСогласия = ДатаСогласия_Подписано;
				
			ИначеЕсли ДатаОтзываСогласия < ДатаСогласия_ОжидаетПодписания Тогда
				// После отзыва есть еще одно согласие, ожидающее подписания.
				Запись.Согласие     = СтрокаТаблицы.СсылкаСогласия_ОжидаетПодписания;
				Запись.Состояние    = Состояние_ОжидаетПодписания;
				Запись.ДатаСогласия = ДатаСогласия_ОжидаетПодписания;
				
			ИначеЕсли ДатаОтзываСогласия < ДатаСогласия_НеПланируетсяПодписывать Тогда
				// После отзыва есть еще одно согласие по которому зафиксирован отказ в подписании.
				Запись.Согласие     = СтрокаТаблицы.СсылкаСогласия_НеПланируетсяПодписывать;
				Запись.Состояние    = Состояние_НеПланируетсяПодписывать;
				Запись.ДатаСогласия = ДатаСогласия_НеПланируетсяПодписывать;
				
			Иначе
				// Согласия подписано и отозвано.
				Запись.Согласие     = СтрокаТаблицы.СсылкаСогласия_Подписано;
				Запись.Состояние    = Состояние_Отозвано;
				Запись.ДатаСогласия = ДатаСогласия_Подписано;
				
			КонецЕсли;
		КонецЕсли;
		
		ЗавершитьЗаписьНабора(Набор);
	КонецЦикла;
	
	// Обработка сотрудников, для которых согласий нет или они отмечены к удалению.
	Для Каждого СтрокаТаблицы Из КадровыеДанные Цикл
		Если Таблица.Найти(СтрокаТаблицы.ФизическоеЛицо, "ФизическоеЛицо") = Неопределено Тогда
			Набор = НачатьЗаписьНабора(Страхователь, СтрокаТаблицы.ФизическоеЛицо);
			Набор.Очистить();
			ЗавершитьЗаписьНабора(Набор);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Количество;
КонецФункции

// Возвращает список сотрудников которые когда-либо работали в организации.
Функция СотрудникиОрганизацииВключаяУволенных(Организации)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Таблица.Сотрудник КАК Сотрудник
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК Таблица
	|ГДЕ
	|	Таблица.Организация В(&Организации)";
	Запрос.УстановитьПараметр("Организации", Организации);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
КонецФункции

// Компонует запрос по регистру с указанными отборами.
Функция ЗапросСФильтрами(Страхователь, МассивСотрудников, СостоянияСогласий) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Согласия.Сотрудник КАК Сотрудник,
	|	Согласия.Согласие КАК Согласие
	|ИЗ
	|	РегистрСведений.СогласияНаУведомленияОбЭЛН КАК Согласия
	|ГДЕ
	|	Согласия.Сотрудник В(&МассивСотрудников)
	|	И Согласия.Страхователь = &Страхователь
	|	И Согласия.Состояние В(&СостоянияСогласий)";
	Запрос.УстановитьПараметр("МассивСотрудников", МассивСотрудников);
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	
	Если СостоянияСогласий = Неопределено Тогда
		НайтиИУдалитьСтроку(Запрос.Текст, "&СостоянияСогласий");
	Иначе
		Запрос.УстановитьПараметр("СостоянияСогласий", СостоянияСогласий);
	КонецЕсли;
	
	Возврат Запрос;
КонецФункции

Функция НайтиИУдалитьСтроку(Текст, ФрагментУдаляемойСтроки)
	НачалоФрагмента = СтрНайти(Текст, ФрагментУдаляемойСтроки);
	Если НачалоФрагмента = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	ОкончаниеФрагмента = НачалоФрагмента + СтрДлина(ФрагментУдаляемойСтроки);
	
	НачалоСтроки = СтрНайти(Текст, Символы.ПС, НаправлениеПоиска.СКонца, НачалоФрагмента);
	ОкончаниеСтроки = СтрНайти(Текст, Символы.ПС, НаправлениеПоиска.СНачала, ОкончаниеФрагмента - 1);
	
	Текст = ?(НачалоСтроки = 0, "", СокрП(Лев(Текст, НачалоСтроки))) + ?(ОкончаниеСтроки = 0, "", Сред(Текст, ОкончаниеСтроки));
	Возврат Истина;
КонецФункции

// Возвращает согласие и его отзыв, соответствующие указанной дате.
Функция ПолучитьПаруСогласиеИОтзывНаДату(Страхователь, ФизическоеЛицо, Дата, ИсключаемоеСогласие = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НАЧАЛОПЕРИОДА(ПоследнееСогласиеНаДату.Дата, ДЕНЬ) КАК ДатаСогласия,
	|	ПоследнееСогласиеНаДату.Проведен КАК Проведен,
	|	ПоследнееСогласиеНаДату.Ссылка КАК Согласие
	|ПОМЕСТИТЬ ПоследнееСогласиеНаДату
	|ИЗ
	|	Документ.СогласиеНаУведомлениеОбЭЛН КАК ПоследнееСогласиеНаДату
	|ГДЕ
	|	ПоследнееСогласиеНаДату.ФизическоеЛицо = &ФизическоеЛицо
	|	И ПоследнееСогласиеНаДату.Страхователь = &Страхователь
	|	И ПоследнееСогласиеНаДату.Дата <= &Дата
	|	И ПоследнееСогласиеНаДату.Проведен
	|	И ПоследнееСогласиеНаДату.СотрудникПодписалСогласие
	|	И ПоследнееСогласиеНаДату.Ссылка <> &ИсключаемоеСогласие
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаСогласия УБЫВ,
	|	Проведен УБЫВ,
	|	Согласие
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПоследнееСогласиеНаДату.Согласие КАК Согласие,
	|	ПоследнееСогласиеНаДату.ДатаСогласия КАК ДатаСогласия,
	|	ЕСТЬNULL(ОтзывСогласия.Ссылка, НЕОПРЕДЕЛЕНО) КАК Отзыв,
	|	ЕСТЬNULL(ОтзывСогласия.Дата, НЕОПРЕДЕЛЕНО) КАК ДатаОтзыва
	|ИЗ
	|	ПоследнееСогласиеНаДату КАК ПоследнееСогласиеНаДату
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтзывСогласияНаУведомлениеОбЭЛН КАК ОтзывСогласия
	|		ПО (ОтзывСогласия.ФизическоеЛицо = &ФизическоеЛицо)
	|			И (ОтзывСогласия.Страхователь = &Страхователь)
	|			И (ОтзывСогласия.Проведен)
	|			И (ОтзывСогласия.Дата >= ПоследнееСогласиеНаДату.ДатаСогласия)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтзыва";
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("Страхователь", Страхователь);
	Запрос.УстановитьПараметр("Дата", КонецДня(Дата));
	Запрос.УстановитьПараметр("ИсключаемоеСогласие", ИсключаемоеСогласие);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Таблица[0];
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецЕсли