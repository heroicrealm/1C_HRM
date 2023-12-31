#Область СлужебныйПрограммныйИнтерфейс

Функция ОграниченияПоВозрастуПредставление(ВозрастОт, ВозрастДо, ИсключаяДатуОт, ВключаяДатуДо) Экспорт

	ЕстьВозрастОт = ЗначениеЗаполнено(ВозрастОт) И ВозрастОт>0;
	ЕстьВозрастДо = ЗначениеЗаполнено(ВозрастДо) И ВозрастДо>0;
	
	Если ЕстьВозрастОт И ЕстьВозрастДо И ВозрастДо<=ВозрастОт Тогда 
		Шаблон = НСтр("ru = 'Возраст ""до"" должен быть больше ""от""'");
	ИначеЕсли ЕстьВозрастОт И ЕстьВозрастДо Тогда
		Если ИсключаяДатуОт И ВключаяДатуДо Тогда 
			Шаблон = НСтр("ru = 'От %1 (+) до %2 (+)'");
		ИначеЕсли Не ИсключаяДатуОт И ВключаяДатуДо Тогда 
			Шаблон = НСтр("ru = 'От %1 до %2 (+)'");
		ИначеЕсли ИсключаяДатуОт И Не ВключаяДатуДо Тогда 
			Шаблон = НСтр("ru = 'От %1 (+) до %2'");
		Иначе 
			Шаблон = НСтр("ru = 'От %1 до %2'");
		КонецЕсли;
	ИначеЕсли Не ЕстьВозрастОт И ЕстьВозрастДо Тогда
		Если ВключаяДатуДо Тогда 
			Шаблон = НСтр("ru = 'До %2 (+)'");
		Иначе 
			Шаблон = НСтр("ru = 'До %2'");
		КонецЕсли;
	ИначеЕсли ЕстьВозрастОт И Не ЕстьВозрастДо Тогда
		Если ИсключаяДатуОт Тогда 
			Шаблон = НСтр("ru = 'От %1 (+)'");
		Иначе 
			Шаблон = НСтр("ru = 'От %1'");
		КонецЕсли;
	ИначеЕсли Не ЕстьВозрастОт И Не ЕстьВозрастДо Тогда
		Шаблон = НСтр("ru = 'Без ограничений'");
	Иначе
		Шаблон = НСтр("ru = 'Возрастные ограничения заданы с ошибкой'");
	КонецЕсли;
	
	ВозрастОтСтрокой = ВозрастПоМесяцамСтрокой(ВозрастОт);
	ВозрастДоСтрокой = ВозрастПоМесяцамСтрокой(ВозрастДо);
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ВозрастОтСтрокой, ВозрастДоСтрокой);

КонецФункции

Функция РасчетРазмераВыплатыПредставление(СпособРасчета, ПрожиточныйМинимум, Размер, Коэффициент) Экспорт
		
	Если СпособРасчета=ПредопределенноеЗначение("Перечисление.СпособыРасчетаВыплатПоДоговорамОпеки.КоэффициентНаПрожиточныйМинимум") Тогда 
		Шаблон = НСтр("ru = '%1 с коэффициентом %2'");
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ПрожиточныйМинимум, Коэффициент);
	ИначеЕсли СпособРасчета=ПредопределенноеЗначение("Перечисление.СпособыРасчетаВыплатПоДоговорамОпеки.КоэффициентНаМРОТ") Тогда 
		Шаблон = НСтр("ru = 'МРОТ с коэффициентом %1'");
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Коэффициент);
	ИначеЕсли СпособРасчета=ПредопределенноеЗначение("Перечисление.СпособыРасчетаВыплатПоДоговорамОпеки.ФиксированныйРазмер") Тогда 
		Шаблон = НСтр("ru = 'Фиксированный размер %1 руб.'");
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Формат(Размер, "ЧДЦ=2"));
	Иначе
		Возврат НСтр("ru = 'Способ расчета не задан'");
	КонецЕсли;
	
КонецФункции

Функция ВозрастНаДатуРасчета(ДатаРождения, ДатаРасчета) Экспорт
	ВозрастНаДатуРасчета = Неопределено;
	Если ЗначениеЗаполнено(ДатаРождения) И ЗначениеЗаполнено(ДатаРасчета) Тогда 
		Поправка = ?((День(ДатаРождения) - День(ДатаРасчета) > 0), -1, 0);
		МесяцРождения = Месяц(ДатаРождения);
		МесяцНачалаВыплат = Месяц(ДатаРасчета);
		ЛетМеждуДатами = Год(ДатаРасчета) - Год(ДатаРождения);
		ВозрастНаДатуРасчета = ЛетМеждуДатами * 12 - МесяцРождения + МесяцНачалаВыплат + Поправка;
	КонецЕсли;
	Возврат ВозрастНаДатуРасчета;
КонецФункции	
	
Процедура ОбновитьФормуОсобенностиПредприятияПоНастройкам(Форма) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
		"УчитыватьВозрастРебенкаПриВыплатахПоДоговорамОпеки", "Доступность", Форма.ИспользоватьВыплатыПоДоговорамОпеки);
	
	Если Не Форма.ИспользоватьВыплатыПоДоговорамОпеки Тогда 
		Форма.УчитыватьВозрастРебенкаПриВыплатахПоДоговорамОпеки = Ложь;
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВозрастПоМесяцамСтрокой(КоличествоМесяцев)
	ВозрастСтрокой = "";
	Если ЗначениеЗаполнено(КоличествоМесяцев) И КоличествоМесяцев>0 Тогда
		ЛетСтрокой = "";
		МесяцевСтрокой = "";
		Месяцев = КоличествоМесяцев % 12;
		Лет = Цел(КоличествоМесяцев / 12);
		Если Месяцев>0 Тогда 
			МесяцевСтрокой = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(НСтр("ru=';%1 месяца;;%1 месяцев;%1 месяцев;'"), Месяцев);
		КонецЕсли;
		Если Лет>0 Тогда 
			ЛетСтрокой = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(НСтр("ru=';%1 года;;%1 лет;%1 лет;'"), Лет);
		КонецЕсли;
		ВозрастСтрокой = ЛетСтрокой + " " + МесяцевСтрокой;
		ВозрастСтрокой = СокрЛП(ВозрастСтрокой);
	КонецЕсли;
	Возврат ВозрастСтрокой;
КонецФункции

#КонецОбласти

