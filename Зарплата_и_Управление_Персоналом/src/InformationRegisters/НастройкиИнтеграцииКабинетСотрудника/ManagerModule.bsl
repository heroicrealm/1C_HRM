#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция НастройкиИнтеграции() Экспорт
	
	Настройки = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	СтруктураНастроек = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(
							Настройки, Метаданные.РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника);
	
	Если Не ЗначениеЗаполнено(СтруктураНастроек.ВидКонтактнойИнформацииМобильныйТелефон) Тогда
		СтруктураНастроек.ВидКонтактнойИнформацииМобильныйТелефон = Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтруктураНастроек.ВидКонтактнойИнформацииАдресЭлектроннойПочты) Тогда
		СтруктураНастроек.ВидКонтактнойИнформацииАдресЭлектроннойПочты = Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтруктураНастроек.ДнейСохраненияПубликации) Тогда
		СтруктураНастроек.ДнейСохраненияПубликации = 5;
	КонецЕсли;
	
	Возврат СтруктураНастроек;

КонецФункции

Процедура СохранитьНовыеВидыКонтактнойИнформации(ВидКИМобильныйТелефон, ВидКИАдресЭлектроннойПочты) Экспорт

	Настройки = НастройкиИнтеграции();
	Настройки.ВидКонтактнойИнформацииМобильныйТелефон = ВидКИМобильныйТелефон;
	Настройки.ВидКонтактнойИнформацииАдресЭлектроннойПочты = ВидКИАдресЭлектроннойПочты;
	
	НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьНаборЗаписей();
	ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Настройки);
	НаборЗаписей.Записать();

КонецПроцедуры

Процедура СохранитьЗначениеИспользуетсяКадровыйЭДО(ИспользуетсяКадровыйЭДО) Экспорт

	Настройки = НастройкиИнтеграции();
	Настройки.ИспользуетсяКадровыйЭДО = ИспользуетсяКадровыйЭДО;
	
	НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьНаборЗаписей();
	ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Настройки);
	НаборЗаписей.ДополнительныеСвойства.Вставить("ОбновитьНастройкиФункциональностьСервиса");
	НаборЗаписей.Записать();

КонецПроцедуры

Процедура СохранитьЗначениеДнейСохраненияПубликации(ДнейСохраненияПубликации) Экспорт

	Настройки = НастройкиИнтеграции();
	Настройки.ДнейСохраненияПубликации = ДнейСохраненияПубликации;
	
	НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьНаборЗаписей();
	ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Настройки);
	НаборЗаписей.Записать();

КонецПроцедуры

Процедура СохранитьЗначениеПубликоватьСтруктуруЮридическихЛиц(НовоеЗначение) Экспорт

	Настройки = НастройкиИнтеграции();
	Настройки.ПубликоватьСтруктуруЮридическихЛиц = НовоеЗначение;
	
	НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьНаборЗаписей();
	ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Настройки);
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли

