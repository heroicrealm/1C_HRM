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

// Процедура заполняет интервальный регистр сведений КадроваяИсторияСотрудниковИнтервальный.
//
Процедура ЗаполнитьИнтервальныйРегистр(ПараметрыОбновления = Неопределено) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистры.ПеренестиВозвратныйРегистрВИнтервальныйРегистрСведений(
		Метаданные.РегистрыСведений.КадроваяИсторияСотрудников.Имя, ПараметрыОбновления);
	
КонецПроцедуры

// Вызывается для формирования интервального регистра из обработчиков обновления основного.
// В передаваемом МенеджерВременныхТаблиц должна быть создана временная таблица ВТОтборДляПереформирования
// с колонкой Сотрудник.
//
Процедура ОбновитьДвиженияИнтервальногоРегистра(МенеджерВременныхТаблиц) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистры.ОбновитьДвиженияИнтервальногоРегистра(
		Метаданные.РегистрыСведений.КадроваяИсторияСотрудников.Имя, МенеджерВременныхТаблиц);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеИнтервальногоРегистра() Экспорт
	
	ОписаниеИнтервальногоРегистра = ЗарплатаКадрыПериодическиеРегистры.ОписаниеИнтервальногоРегистра();
	
	ОписаниеИнтервальногоРегистра.ПараметрыНаследованияРесурсов = ПараметрыНаследованияРесурсов();
	ОписаниеИнтервальногоРегистра.ОсновноеИзмерение = "Сотрудник";
	ОписаниеИнтервальногоРегистра.ИзмеренияРасчета = "Сотрудник";
	
	Возврат ОписаниеИнтервальногоРегистра;
	
КонецФункции

Функция ПараметрыНаследованияРесурсов() Экспорт
	
	ПараметрыРесурсов = ЗарплатаКадрыПериодическиеРегистры.ПараметрыНаследованияРесурсов(Метаданные.РегистрыСведений.КадроваяИсторияСотрудников.Имя);
	Для Каждого КлючИЗначение Из ПараметрыРесурсов Цикл
	
		Ресурс = КлючИЗначение.Ключ;
		Наследование = КлючИЗначение.Значение;
		
		Если Ресурс = "ВидСобытия" Тогда
			Наследование.ПравилоНаследования = "Фиксированное";
			Наследование.Значение = Перечисления.ВидыКадровыхСобытий.Увольнение;
		Иначе
			Наследование.ПравилоНаследования = "Наследование";
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПараметрыРесурсов;
	
КонецФункции

Процедура ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПередЗаписью(Объект) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПередЗаписью(Объект);
	
КонецПроцедуры

Процедура ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПриЗаписи(Объект) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПриЗаписи(Объект);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда.МедицинскиеОсмотры") Тогда
		МодульМедицинскиеОсмотры = ОбщегоНазначения.ОбщийМодуль("МедицинскиеОсмотры");
		МодульМедицинскиеОсмотры.ЗаполнитьТаблицуОбновленияКадровойИсторииДляМедосмотров(Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
