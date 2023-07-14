#Область ПрограммныйИнтерфейс

// Определяет возможность использования программы в режиме мобильного клиента.
// Может быть переопределен в расширении, которое предоставляет функциональность для работы мобильного клиента.
// 
// Возвращаемое значение:
// 	Булево - 
Функция РазрешенаРаботаМобильногоКлиента() Экспорт
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	ПроверитьРазрешениеРаботыМобильногоКлиента(Параметры);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьРазрешениеРаботыМобильногоКлиента(Параметры)
	
	Если ЭтоМобильныйКлиент() И Не РазрешенаРаботаМобильногоКлиента() Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("НачатьСообщениеЗапретаРаботыМобильногоКлиента", ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоМобильныйКлиент()

#Если МобильныйКлиент Тогда
	Возврат Истина;
#Иначе
	Возврат Ложь;
#КонецЕсли
	
КонецФункции

Процедура НачатьСообщениеЗапретаРаботыМобильногоКлиента(ОсновныеПараметры, ДополнительныеПараметры) Экспорт
	
	ПараметрыСообщения = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыСообщения.Заголовок = НСтр("ru = 'Мобильный клиент'");
	ПараметрыСообщения.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	ПараметрыСообщения.Картинка = БиблиотекаКартинок.Предупреждение32;
	ПараметрыСообщения.Таймаут = 10;
	ПараметрыСообщения.БлокироватьВесьИнтерфейс = Истина;
	
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(
		Новый ОписаниеОповещения("ЗавершитьСообщениеЗапретаРаботыМобильногоКлиента", ЭтотОбъект), 
		НСтр("ru = 'Использование мобильного клиента не поддерживается. 
			 |Работа системы будет завершена.'"), 
		РежимДиалогаВопрос.ОК, 
		ПараметрыСообщения);
		
КонецПроцедуры

Процедура ЗавершитьСообщениеЗапретаРаботыМобильногоКлиента(ОсновныеПараметры, ДополнительныеПараметры) Экспорт
	ЗавершитьРаботуСистемы(Ложь);
КонецПроцедуры

#КонецОбласти