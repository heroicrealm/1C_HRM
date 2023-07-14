#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьРегистр(Команда)
	
	ПерезаполнитьРегистрНаСервере();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерезаполнитьРегистрНаСервере()
	
	НачатьТранзакцию();
	
	Попытка
		НаборЗаписей = РегистрыСведений.ОсновныеСотрудникиФизическихЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать();
		
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Сотрудники.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Сотрудники КАК Сотрудники";
		
		МассивСотрудников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		КадровыйУчет.ОбновитьОсновныхСотрудниковФизическихЛицПоСотрудникам(МассивСотрудников);
		КадровыйУчет.ОбновитьОсновныхСотрудниковФизическихЛицСотрудниковПоДоговорамГПХ(МассивСотрудников);
		КадровыйУчет.ОбновитьОсновныхСотрудниковФизическихЛицПоТрудовымДоговорам(МассивСотрудников);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
