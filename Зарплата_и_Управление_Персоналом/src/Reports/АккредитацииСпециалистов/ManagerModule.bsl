#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АккредитацииЗаПериод");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Аккредитации специалистов, полученные за указанный период.'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПросроченныеАккредитации");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Аккредитации специалистов, срок действия которых истекает в указанном периоде.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ДействующиеАккредитации");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Аккредитации специалистов, действующие в течение всего указанного периода.'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СотрудникиБезАккредитации");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сотрудники, которые не имеют действующей аккредитации на дату окончания указанного периода.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли