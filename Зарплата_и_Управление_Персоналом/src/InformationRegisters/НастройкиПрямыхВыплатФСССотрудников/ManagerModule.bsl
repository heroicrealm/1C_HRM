#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ГоловнаяОрганизация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Редактирование

Функция ЗаписатьМенеджерЗаписи(МенеджерЗаписи) Экспорт
	Набор = НачатьЗаписьНабора(МенеджерЗаписи.ГоловнаяОрганизация, МенеджерЗаписи.ФизическоеЛицо);
	
	Если Набор = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
	Иначе
		Запись = Набор[0];
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		Запись,
		МенеджерЗаписи,
		"ФизическоеЛицо, ГоловнаяОрганизация, ОпределятьПоОрганизации, ОпределятьПоОсновномуМестуРаботы, Значение");
	
	// Настройки сотрудника взаимоисключающие.
	Если Запись.ОпределятьПоОрганизации Тогда
		Запись.ОпределятьПоОсновномуМестуРаботы = Ложь;
		Запись.Значение = Неопределено;
	ИначеЕсли Запись.ОпределятьПоОсновномуМестуРаботы Тогда
		Запись.Значение = Неопределено;
	ИначеЕсли Не ЗначениеЗаполнено(Запись.Значение) Тогда
		Запись.Значение = Неопределено;
	КонецЕсли;
	
	Запись.ДатаИзменения = ТекущаяДатаСеанса();
	Запись.Ответственный = Пользователи.АвторизованныйПользователь();
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
	
	ЗавершитьЗаписьНабора(Набор);
	
	Попытка
		МенеджерПодробностей = РегистрыСведений.НастройкиПрямыхВыплатФСССотрудниковПодробности;
		Таблица = СпособыПрямыхВыплатФСС.ОрганизацииФизическихЛиц(МенеджерЗаписи.ФизическоеЛицо);
		Таблица.Свернуть("Организация");
		Организации = Таблица.ВыгрузитьКолонку("Организация");
		Для Каждого Организация Из Организации Цикл
			МенеджерПодробностей.РассчитатьСпособыОпределяемыеАвтоматически(Организация, МенеджерЗаписи.ФизическоеЛицо);
		КонецЦикла;
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1: Не удалось обновить подробные сведения о способе прямых выплат выплат (используются для отображения в списке): %2'"),
			МенеджерЗаписи.ФизическоеЛицо,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		СпособыПрямыхВыплатФСС.ЗаписатьОшибку(
			Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников,
			МенеджерЗаписи.ФизическоеЛицо,
			ТекстСообщения);
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область НаборЗаписей

// АПК:581-выкл. Методы могут вызываться из расширений.
// АПК:299-выкл. Методы могут вызываться из расширений.
// АПК:326-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// АПК:325-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// Транзакция открывается в методе НачатьЗаписьНабора, закрывается в ЗавершитьЗаписьНабора, отменяется в ОтменитьЗаписьНабора.

// Транзакционный вариант (с управляемой блокировкой) получения набора записей, соответствующего значениям измерений.
//
// Параметры:
//   ГоловнаяОрганизация - ОпределяемыйТип.Организация     - Значение отбора по соответствующему измерению.
//   ФизическоеЛицо      - СправочникСсылка.ФизическиеЛица - Значение отбора по соответствующему измерению.
//
// Возвращаемое значение:
//   РегистрСведенийНаборЗаписей.НастройкиПрямыхВыплатФСССотрудников - Если удалось установить блокировку
//       и прочитать набор записей. При необходимости, открывает свою локальную транзакцию. Для закрытия транзакции
//       следует использовать одну из терминирующих процедур: ЗавершитьЗаписьНабора, либо ОтменитьЗаписьНабора.
//   Неопределено - Если не удалось установить блокировку и прочитать набор записей.
//       Вызывать процедуры ЗавершитьЗаписьНабора, ОтменитьЗаписьНабора не требуется,
//       поскольку если перед блокировкой функции потребовалось открыть локальную транзакцию,
//       то после неудачной блокировки локальная транзакция была отменена.
//
Функция НачатьЗаписьНабора(ГоловнаяОрганизация, ФизическоеЛицо) Экспорт
	Если Не ЗначениеЗаполнено(ГоловнаяОрганизация) Или Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПроверитьПраво(Истина);
	ЛокальнаяТранзакция = Не ТранзакцияАктивна();
	Если ЛокальнаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиПрямыхВыплатФСССотрудников");
		ЭлементБлокировки.УстановитьЗначение("ГоловнаяОрганизация", ГоловнаяОрганизация);
		ЭлементБлокировки.УстановитьЗначение("ФизическоеЛицо", ФизическоеЛицо);
		Блокировка.Заблокировать();
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ГоловнаяОрганизация.Установить(ГоловнаяОрганизация);
		НаборЗаписей.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо);
		НаборЗаписей.Прочитать();
		НаборЗаписей.ДополнительныеСвойства.Вставить("ЛокальнаяТранзакция", ЛокальнаяТранзакция);
	Исключение
		Если ЛокальнаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось изменить сведения о способе прямых выплат %1 физического лица %2 по причине: %3'"),
			ГоловнаяОрганизация,
			ФизическоеЛицо,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		СпособыПрямыхВыплатФСС.ЗаписатьОшибку(
			Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников,
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
//   НаборЗаписей - РегистрСведенийНаборЗаписей.НастройкиПрямыхВыплатФСССотрудников
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
//   НаборЗаписей - РегистрСведенийНаборЗаписей.НастройкиПрямыхВыплатФСССотрудников
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

#Область ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	Объект = Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников.ПолноеИмя();
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = Объект;
	НовыеСведения.ПоляРегистрации = "ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "ОпределятьПоОрганизации,ОпределятьПоОсновномуМестуРаботы,Значение";
	НовыеСведения.ОбластьДанных   = "ЛичныеДанные";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет наличие прав на регистр. Бросает исключение в случае отсутствия.
//
// Параметры:
//   Изменение - Булево - Истина, если необходимо проверить и чтение и изменение.
//       Ложь, если надо проверить только чтение.
//
Процедура ПроверитьПраво(Изменение)
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ИмяПрава = ?(Изменение, "Изменение", "Чтение");
		Если Не ПравоДоступа(ИмяПрава, Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников) Тогда
			ВызватьИсключение СтрШаблон(
				НСтр("ru = 'Недостаточно прав для изменения регистра ""%1"".'"),
				Метаданные.РегистрыСведений.НастройкиПрямыхВыплатФСССотрудников.Представление());
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли