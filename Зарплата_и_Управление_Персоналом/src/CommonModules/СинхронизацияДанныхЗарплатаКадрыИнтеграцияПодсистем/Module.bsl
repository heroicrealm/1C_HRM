////////////////////////////////////////////////////////////////////////////////
// Подсистема "Синхронизация данных".
// Серверные процедуры, обслуживающие правила регистрации объектов.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет заполнение соответствия зависимых данных от ведущих данных
// Зависимые данные не мигрируют по узлам, а пересчитываются по ведущим данным в каждом узле.
//
// Параметры:
//		ЗависимыеДанные - ТаблицаЗначений:
//			* ВедущиеМетаданные - ОбъектМетаданных - Метаданные ведущих данных
//			* ЗависимыеМетаданные - ОбъектМетаданных - Метаданные зависимых данных
//
Процедура ЗаполнитьТаблицуЗависимыхДанных(ЗависимыеДанные) Экспорт
	
	ЗарплатаКадрыРасширенный.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	КадровыйУчетРасширенный.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	РасчетЗарплатыРасширенный.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	УчетСтраховыхВзносовРасширенный.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	УчетНДФЛРасширенный.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда.МедицинскиеОсмотры") Тогда
		МодульМедицинскиеОсмотры = ОбщегоНазначения.ОбщийМодуль("МедицинскиеОсмотры");
		МодульМедицинскиеОсмотры.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КадровыйУчет.ДистанционнаяРабота") Тогда
		МодульДистанционнаяРабота = ОбщегоНазначения.ОбщийМодуль("ДистанционнаяРабота");
		МодульДистанционнаяРабота.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПоискФизическихЛиц") Тогда
		МодульПоискФизическихЛиц = ОбщегоНазначения.ОбщийМодуль("ПоискФизическихЛиц");
		МодульПоискФизическихЛиц.ПриЗаполненииТаблицыЗависимыхДанныхДляОбмена(ЗависимыеДанные);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет заполнение списка объектов, при изменении которых требуется зарегистрировать изменение
// организации или структурного подразделения для сотрудников и физических лиц
//
// Параметры:
//		ДанныеРегистрации - ТаблицаЗначений:
//			* ВедущиеМетаданные - ОбъектМетаданных - Метаданные объекта, при изменении которого
//					требуется изменение организации или структурного подразделения
//					сотрудника или физического лица
//
Процедура ЗаполнитьТаблицуДанныхРегистрации(ДанныеРегистрации) Экспорт
	
	КадровыйУчетРасширенный.ПриЗаполненииТаблицыОбъектовРегистрирующихЗависимыеОбъекты(ДанныеРегистрации);
	ЗарплатаКадрыРасширенный.ПриЗаполненииТаблицыОбъектовРегистрирующихЗависимыеОбъекты(ДанныеРегистрации);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("КадровыйУчетВоеннослужащих");
		МодульПодсистемы.ПриЗаполненииТаблицыОбъектовРегистрирующихЗависимыеОбъекты(ДанныеРегистрации);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Подработки") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("Подработки");
		МодульПодсистемы.ПриЗаполненииТаблицыОбъектовРегистрирующихЗависимыеОбъекты(ДанныеРегистрации);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Дивиденды") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("Дивиденды");
		МодульПодсистемы.ПриЗаполненииТаблицыОбъектовРегистрирующихЗависимыеОбъекты(ДанныеРегистрации);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("КадровыеРешения");
		МодульПодсистемы.ПриЗаполненииТаблицыОбъектовРегистрирующихЗависимыеОбъекты(ДанныеРегистрации);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет начальное заполнение данных после создания узла РИБ.
// Вызывается в момент первого запуска подчиненного узла РИБ (в том числе АРМ).
//
// Параметры:
//  ПараметрыОбновления	 - Структура - используется при вызове из обработчика обновления.
//
Процедура ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзлаРИБ(ПараметрыОбновления = Неопределено) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистрыРасширенный.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла(ПараметрыОбновления);
	КадровыйУчетРасширенный.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла(ПараметрыОбновления);
	ПлановыеНачисленияСотрудников.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла(ПараметрыОбновления);
	УчетСтраховыхВзносовРасширенный.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла();
	УчетНДФЛРасширенный.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда.МедицинскиеОсмотры") Тогда
		МодульМедицинскиеОсмотры = ОбщегоНазначения.ОбщийМодуль("МедицинскиеОсмотры");
		МодульМедицинскиеОсмотры.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла();
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КадровыйУчет.ДистанционнаяРабота") Тогда
		МодульДистанционнаяРабота = ОбщегоНазначения.ОбщийМодуль("ДистанционнаяРабота");
		МодульДистанционнаяРабота.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла(ПараметрыОбновления);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПоискФизическихЛиц") Тогда
		МодульПоискФизическихЛиц = ОбщегоНазначения.ОбщийМодуль("ПоискФизическихЛиц");
		МодульПоискФизическихЛиц.ЗаполнитьЗависимыеДанныеПослеСозданияНовогоУзла(ПараметрыОбновления);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


