#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Движения.Найти("ДанныеОВремениДляРасчетаСреднегоОбщий") <> Неопределено Тогда
		Движения.ДанныеОВремениДляРасчетаСреднегоОбщий.ДополнительныеСвойства.Вставить("ИсключаемыйРегистратор", Ссылка);
	КонецЕсли;
	
	УправлениеШтатнымРасписанием.ПроверитьВозможностьИзменитьШтатноеРасписание(
		Движения.ИсторияИспользованияШтатногоРасписания.ВыгрузитьКолонку("ПозицияШтатногоРасписания"),
		ПериодРегистрации,
		Ссылка,
		РежимЗаписи,
		Отказ,
		"МесяцНачисленияСтрокой");

	Если Не ЭтоНовый() И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл
		Движение.Прочитать();
		Движение.УстановитьАктивность(ФлагАктивности);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли