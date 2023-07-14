
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	

#Область СлужебныеПроцедурыИФункции

Функция ИнформацияОРабочемВремениСмен(СписокСмен) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСмен", СписокСмен);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СменыРаботыСотрудниковРасписание.Ссылка КАК Смена,
	|	СменыРаботыСотрудниковРасписание.ВидВремени КАК ВидВремени,
	|	ЛОЖЬ КАК ПереходящаяЧастьСмены,
	|	СменыРаботыСотрудниковРасписание.Часы - СменыРаботыСотрудниковРасписание.ПереходящиеЧасы КАК Часов
	|ИЗ
	|	Справочник.СменыРаботыСотрудников.Расписание КАК СменыРаботыСотрудниковРасписание
	|ГДЕ
	|	СменыРаботыСотрудниковРасписание.Ссылка В(&СписокСмен)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СменыРаботыСотрудниковРасписание.Ссылка,
	|	СменыРаботыСотрудниковРасписание.ВидВремени,
	|	ИСТИНА,
	|	СменыРаботыСотрудниковРасписание.ПереходящиеЧасы
	|ИЗ
	|	Справочник.СменыРаботыСотрудников.Расписание КАК СменыРаботыСотрудниковРасписание
	|ГДЕ
	|	СменыРаботыСотрудниковРасписание.Ссылка В(&СписокСмен)
	|	И СменыРаботыСотрудниковРасписание.ПереходящиеЧасы <> 0";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции	

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если Параметры.Свойство("РежимРаботы") Тогда
		СтандартнаяОбработка = Ложь;
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	РежимыРаботыСотрудниковСмены.Смена.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.РежимыРаботыСотрудников.Смены КАК РежимыРаботыСотрудниковСмены
			|ГДЕ
			|	РежимыРаботыСотрудниковСмены.Ссылка = &РежимРаботы
			|	И РежимыРаботыСотрудниковСмены.Смена.Наименование ПОДОБНО &СтрокаПоиска";
		Запрос.УстановитьПараметр("РежимРаботы", Параметры.РежимРаботы);
		Запрос.УстановитьПараметр("СтрокаПоиска", "%"+ Параметры.СтрокаПоиска + "%");
		Выборка = Запрос.Выполнить().Выбрать();
		
		СписокСмен = Новый СписокЗначений;
		
		Пока Выборка.Следующий() Цикл
			СписокСмен.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
		ДанныеВыбора = СписокСмен;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли

