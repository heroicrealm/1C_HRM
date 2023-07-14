#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
//
// Возвращаемое значение:
//  Массив из Строка - имена реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СтатистикаПерсоналаРасширенныйВызовСервера.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение классификатора.
Процедура НачальноеЗаполнение() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.Ссылка
	|ИЗ
	|	Справочник.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы КАК СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы");
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Code КАК СТРОКА(11)) КАК Код,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Name КАК СТРОКА(150)) КАК Наименование,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.CategoryCode КАК СТРОКА(3)) КАК КодКатегорииПерсонала,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.ReportForm КАК СТРОКА(50)) КАК ФормаМониторинга,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Comment КАК СТРОКА(300)) КАК Пояснение
	|ПОМЕСТИТЬ СтрокиОтчетностиТаблица
	|ИЗ
	|	&СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиОтчетностиТаблица.Код,
	|	СтрокиОтчетностиТаблица.Наименование,
	|	СтрокиОтчетностиТаблица.КодКатегорииПерсонала,
	|	СтрокиОтчетностиТаблица.ФормаМониторинга,
	|	СтрокиОтчетностиТаблица.Пояснение
	|ИЗ
	|	СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы КАК СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы
	|		ПО СтрокиОтчетностиТаблица.Код = СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.Код
	|ГДЕ
	|	СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.Ссылка ЕСТЬ NULL ");
	
	ТекстовыйДокумент = Справочники.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.ПолучитьМакет("СтрокиОтчетностиМониторинга");
	Таблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Запрос.УстановитьПараметр("СтрокиОтчетностиТаблица", Таблица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СправочникОбъект = Справочники.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.СоздатьЭлемент();
		СправочникОбъект.Код = СокрЛП(Выборка.Код);
		СправочникОбъект.Наименование = СокрЛП(Выборка.Наименование);
		СправочникОбъект.КодКатегорииПерсонала = СокрЛП(Выборка.КодКатегорииПерсонала);
		СправочникОбъект.Пояснение = СокрЛП(Выборка.Пояснение);
		
		Если СокрЛП(Выборка.ФормаМониторинга) = "ЗПЗдрав" Тогда
			СправочникОбъект.ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПЗдрав;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПКультура" Тогда
			СправочникОбъект.ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПКультура;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПНаука" Тогда
			СправочникОбъект.ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПНаука;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПОбразование" Тогда
			СправочникОбъект.ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПОбразование;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПСоц" Тогда
			СправочникОбъект.ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПСоц;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПФизическаяКультураИСпорт" Тогда
			СправочникОбъект.ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПФизическаяКультураИСпорт;
		КонецЕсли;
		
		СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьСтрокиПоЗПФизическаяКультураИСпорт() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Code КАК СТРОКА(11)) КАК Код,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Name КАК СТРОКА(150)) КАК Наименование,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.CategoryCode КАК СТРОКА(3)) КАК КодКатегорииПерсонала,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.ReportForm КАК СТРОКА(50)) КАК ФормаМониторинга,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Comment КАК СТРОКА(300)) КАК Пояснение
	|ПОМЕСТИТЬ СтрокиОтчетностиТаблица
	|ИЗ
	|	&СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|ГДЕ
	|	(ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.ReportForm КАК СТРОКА(50))) = ""ЗПФизическаяКультураИСпорт""
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиОтчетностиТаблица.Код КАК Код,
	|	СтрокиОтчетностиТаблица.Наименование КАК Наименование,
	|	СтрокиОтчетностиТаблица.КодКатегорииПерсонала КАК КодКатегорииПерсонала,
	|	СтрокиОтчетностиТаблица.ФормаМониторинга КАК ФормаМониторинга,
	|	СтрокиОтчетностиТаблица.Пояснение КАК Пояснение
	|ИЗ
	|	СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы КАК СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы
	|		ПО СтрокиОтчетностиТаблица.Код = СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.Код
	|ГДЕ
	|	СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.Ссылка ЕСТЬ NULL");
	
	ТекстовыйДокумент = Справочники.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.ПолучитьМакет("СтрокиОтчетностиМониторинга");
	Таблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Запрос.УстановитьПараметр("СтрокиОтчетностиТаблица", Таблица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СправочникОбъект = Справочники.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.СоздатьЭлемент();
		СправочникОбъект.Код = СокрЛП(Выборка.Код);
		СправочникОбъект.Наименование = СокрЛП(Выборка.Наименование);
		СправочникОбъект.КодКатегорииПерсонала = СокрЛП(Выборка.КодКатегорииПерсонала);
		СправочникОбъект.Пояснение = СокрЛП(Выборка.Пояснение);
		СправочникОбъект.ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПФизическаяКультураИСпорт;
		СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура выполняет обновление пояснений категорий.
Процедура ОбновлениеПояснений() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.Ссылка,
	|	СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.КодКатегорииПерсонала,
	|	СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.ФормаМониторинга,
	|	СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.Пояснение
	|ИЗ
	|	Справочник.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы КАК СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы");
	
	ТаблицаСправочника = Запрос.Выполнить().Выгрузить();

	Если ТаблицаСправочника.Количество() > 0 И ЗначениеЗаполнено(ТаблицаСправочника[0].Пояснение) Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.Name КАК СТРОКА(150)) КАК Наименование,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.CategoryCode КАК СТРОКА(3)) КАК КодКатегорииПерсонала,
	|	ВЫРАЗИТЬ(СтрокиОтчетностиТаблица.ReportForm КАК СТРОКА(50)) КАК ФормаМониторинга,
	|	СтрокиОтчетностиТаблица.Comment КАК Пояснение
	|ПОМЕСТИТЬ СтрокиОтчетностиТаблица
	|ИЗ
	|	&СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиОтчетностиТаблица.Наименование,
	|	СтрокиОтчетностиТаблица.КодКатегорииПерсонала,
	|	СтрокиОтчетностиТаблица.ФормаМониторинга,
	|	СтрокиОтчетностиТаблица.Пояснение
	|ИЗ
	|	СтрокиОтчетностиТаблица КАК СтрокиОтчетностиТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы КАК СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы
	|		ПО СтрокиОтчетностиТаблица.КодКатегорииПерсонала = СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.КодКатегорииПерсонала
	|			И СтрокиОтчетностиТаблица.ФормаМониторинга = СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.ФормаМониторинга");
	
	ТекстовыйДокумент = Справочники.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.ПолучитьМакет("СтрокиОтчетностиМониторинга");
	ТаблицаЯзыков = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Запрос.УстановитьПараметр("СтрокиОтчетностиТаблица", ТаблицаЯзыков);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если СокрЛП(Выборка.ФормаМониторинга) = "ЗПЗдрав" Тогда
			ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПЗдрав;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПКультура" Тогда
			ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПКультура;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПНаука" Тогда
			ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПНаука;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПОбразование" Тогда
			ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПОбразование;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПСоц" Тогда
			ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПСоц;
		ИначеЕсли СокрЛП(Выборка.ФормаМониторинга) = "ЗПФизическаяКультураИСпорт" Тогда
			ФормаМониторинга = Перечисления.ВидыФормМониторингаРаботниковСоциальнойСферы.ЗПФизическаяКультураИСпорт;
		Иначе
			Продолжить;
		КонецЕсли;
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("КодКатегорииПерсонала", Выборка.КодКатегорииПерсонала);
		СтруктураОтбора.Вставить("ФормаМониторинга", ФормаМониторинга);
		
		Для Каждого СтрокаСправочника Из ТаблицаСправочника.НайтиСтроки(СтруктураОтбора) Цикл
			СправочникОбъект = СтрокаСправочника.Ссылка.ПолучитьОбъект();
			СправочникОбъект.Наименование = СокрЛП(Выборка.Наименование);
			СправочникОбъект.Пояснение = СокрЛП(Выборка.Пояснение);				
			СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
			СправочникОбъект.Записать();
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
