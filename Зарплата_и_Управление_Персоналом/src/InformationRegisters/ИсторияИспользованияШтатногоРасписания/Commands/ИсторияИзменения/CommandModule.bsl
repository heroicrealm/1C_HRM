
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ПозицияШтатногоРасписания", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.ИсторияИспользованияШтатногоРасписания.Форма.ИсторияИзменения", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти