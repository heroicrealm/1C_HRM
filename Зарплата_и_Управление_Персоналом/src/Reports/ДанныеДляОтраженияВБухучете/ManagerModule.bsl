#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "БухучетЗарплаты");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Устаревшая форма. Рекомендуется использовать отчет ""Сведения для отражения зарплаты в бухучете"".'");
		
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "БухучетЗарплаты");
	Вариант.Размещение.Очистить();
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Зарплата, "СмТакже");	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли