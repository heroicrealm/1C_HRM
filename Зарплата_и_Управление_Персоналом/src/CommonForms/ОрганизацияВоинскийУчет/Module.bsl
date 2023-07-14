
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "ОрганизацияСсылка");
	
	РасчетныйГод = Год(ТекущаяДатаСеанса());
	
	ПрочитатьДанные();
	
	Элементы.ПотребностьВСпециалистахНаПериодМобилизацииКатегорияДолжности.СписокВыбора.Добавить(Перечисления.КатегорииДолжностейДляВоинскогоУчета.Руководители, НСтр("ru = 'Руководители'"));
	Элементы.ПотребностьВСпециалистахНаПериодМобилизацииКатегорияДолжности.СписокВыбора.Добавить(Перечисления.КатегорииДолжностейДляВоинскогоУчета.Специалисты, НСтр("ru = 'Специалисты'"));
	Элементы.ПотребностьВСпециалистахНаПериодМобилизацииКатегорияДолжности.СписокВыбора.Добавить(Перечисления.КатегорииДолжностейДляВоинскогоУчета.ДругиеСлужащие, НСтр("ru = 'Другие служащие'"));
	Элементы.ПотребностьВСпециалистахНаПериодМобилизацииКатегорияДолжности.СписокВыбора.Добавить(Перечисления.КатегорииДолжностейДляВоинскогоУчета.Рабочие, НСтр("ru = 'Рабочие'"));
	Элементы.ПотребностьВСпециалистахНаПериодМобилизацииКатегорияДолжности.СписокВыбора.Добавить(Перечисления.КатегорииДолжностейДляУчетаЗабронированных.Водители, НСтр("ru = 'Водители (из числа рабочих)'"));
	
	НаименованиеОрганизации = "";
	Параметры.Свойство("Заголовок", Заголовок);
	
	ИспользоватьБронирование = ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеГраждан");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаЗаписатьИЗакрыть", "Видимость", ИспользоватьБронирование);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОтмена", "Видимость", ИспользоватьБронирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасчетныйГодПриИзменении(Элемент)
	
	ПотребностьВСпециалистахУстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПотребностьВСпециалистахНаПериодМобилизации

&НаКлиенте
Процедура ПотребностьВСпециалистахНаПериодМобилизацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		
		Элемент.ТекущиеДанные.Организация = ОрганизацияСсылка;
		Элемент.ТекущиеДанные.Год 		  = РасчетныйГод;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перечитать(Команда)
	
	ПрочитатьДанные();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриказОбОрганизацииВоинскогоУчета(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьФормВоинскогоУчета", "ПФ_MXL_ПриказОбОрганизацииВоинскогоУчета", 
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОрганизацияСсылка), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланРаботыПоОсуществлениюВоинскогоУчета(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьФормВоинскогоУчета", "ПФ_MXL_ПланРаботыПоОсуществлениюВоинскогоУчета", 
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОрганизацияСсылка), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьДанныеНаСервере();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПотребностьВСпециалистахУстановитьОтбор()

	Элементы.ПотребностьВСпециалистахНаПериодМобилизации.ОтборСтрок = Новый ФиксированнаяСтруктура("Год", РасчетныйГод);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанные()
	
	ТаблицаЗаписей = ТаблицаЗаписейРегистраПотребностьВСпециалистахНаПериодМобилизации();
	
	ПотребностьВСпециалистахНаПериодМобилизации.Загрузить(ТаблицаЗаписей);
	
	ПотребностьВСпециалистахУстановитьОтбор();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеНаСервере()
	
	ТаблицаЗаписейФормы = ПотребностьВСпециалистахНаПериодМобилизации.Выгрузить();
	ТаблицаЗаписейФормы.Колонки.Удалить("ИсходныйНомерСтроки");
	
	ТаблицаЗаписейБазыДанных = ТаблицаЗаписейРегистраПотребностьВСпециалистахНаПериодМобилизации();
	
	Если НЕ ОбщегоНазначения.КоллекцииИдентичны(ТаблицаЗаписейФормы, ТаблицаЗаписейБазыДанных) Тогда
		
		НаборЗаписей = РегистрыСведений.ПотребностьВСпециалистахНаПериодМобилизации.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Организация.Значение = ОрганизацияСсылка;
		НаборЗаписей.Отбор.Организация.Использование = Истина;
		
		НаборЗаписей.Загрузить(ТаблицаЗаписейФормы);
		
		НаборЗаписей.Записать();
		
	КонецЕсли; 
		
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Функция ТаблицаЗаписейРегистраПотребностьВСпециалистахНаПериодМобилизации()
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ПотребностьВСпециалистахНаПериодМобилизации.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Организация.Значение = ОрганизацияСсылка;
	НаборЗаписей.Отбор.Организация.Использование = Истина;
	
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	СохранитьДанныеНаСервере();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
