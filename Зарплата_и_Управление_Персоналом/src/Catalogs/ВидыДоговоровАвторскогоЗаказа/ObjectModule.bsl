#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.ПустаяСсылка();
	КодДоходаСтраховыеВзносы = Справочники.ВидыДоходовПоСтраховымВзносам.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли