#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Статья = Сред(Параметры.РеквизитыДляРедактирования, 1, 4);
	Часть = Сред(Параметры.РеквизитыДляРедактирования, 5, 4);
	Пункт = Сред(Параметры.РеквизитыДляРедактирования, 9, 4);
	Подпункт = Сред(Параметры.РеквизитыДляРедактирования, 13, 4);
	Абзац = Сред(Параметры.РеквизитыДляРедактирования, 17, 4);
	Иное = Сред(Параметры.РеквизитыДляРедактирования, 21, 4);
	Для Каждого Элт Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Абзац,Иное,Подпункт,Пункт,Статья,Часть", ",") Цикл 
		Пока СтрНачинаетсяС(ЭтотОбъект[Элт], "0") Цикл 
			ЭтотОбъект[Элт] = Сред(ЭтотОбъект[Элт], 2);
		КонецЦикла;
	КонецЦикла;
	
	ИмяОбласти = Параметры.ИмяОбласти;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	Закрыть(Новый Структура("Результат, ИмяОбласти", "", ИмяОбласти));
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	Результат = Прав("0000" + СокрЛП(Статья), 4) + Прав("0000" + СокрЛП(Часть), 4) + Прав("0000" + СокрЛП(Пункт), 4) 
			+ Прав("0000" + СокрЛП(Подпункт), 4) + Прав("0000" + СокрЛП(Абзац), 4) + Прав("0000" + СокрЛП(Иное), 4);
	Закрыть(Новый Структура("Результат, ИмяОбласти", Результат, ИмяОбласти));
КонецПроцедуры

#КонецОбласти
