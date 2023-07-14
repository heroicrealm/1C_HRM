#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
	ЗначениеВРеквизитФормы(Отчеты.РегламентированноеУведомлениеПолучениеПатента.ПолучитьТаблицуФорм(), "ТаблицаФорм");
	
	Элементы.Создать.Доступность = ЗначениеЗаполнено(Организация);
	
	СписокВыбора = Элементы.ПолеРедакцияФормы.СписокВыбора;
	СписокВыбора.Очистить();
	Для Каждого Стр Из ТаблицаФорм Цикл 
		СписокВыбора.Добавить(Стр.ИмяФормы, Стр.ОписаниеФормы);
		ПолеРедакцияФормы = Стр.ИмяФормы;
	КонецЦикла;
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Элементы.Создать.Доступность = ЗначениеЗаполнено(Организация);
КонецПроцедуры

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Создать(Команда)
	Попытка
		ПараметрыОткрытия = Новый Структура("Организация,ЗначениеКопирования", Организация, ЗначениеКопирования);
		ОткрытьФорму("Отчет.РегламентированноеУведомлениеПолучениеПатента.Форма."+ПолеРедакцияФормы, ПараметрыОткрытия, ВладелецФормы);
		Закрыть();
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не удалось создать заявление на получение патента для " + Организация);
	КонецПопытки;
КонецПроцедуры
#КонецОбласти