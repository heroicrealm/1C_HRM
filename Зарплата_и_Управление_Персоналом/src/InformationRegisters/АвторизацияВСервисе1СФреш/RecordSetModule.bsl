#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ДополнительныеСвойства.Свойство("Пароль") Тогда
		КлючБезопасногоХранилища = РегистрыСведений.АвторизацияВСервисе1СФреш.ВладелецБезопасногоХранилища(Отбор.Пользователь.Значение);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(КлючБезопасногоХранилища, ДополнительныеСвойства.Пароль);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли
