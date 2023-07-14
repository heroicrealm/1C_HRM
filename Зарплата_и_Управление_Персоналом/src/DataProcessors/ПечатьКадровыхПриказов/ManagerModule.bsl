#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СправкаОСреднемЗаработке2019") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_СправкаОСреднемЗаработке2019", НСтр("ru='Справка о среднем заработке для определения размера пособия по безработице'"),
			ТабличныйДокументСправкаОСреднемЗаработкеДляПособияПоБезработице(УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьКадровыхПриказов.ПФ_MXL_СправкаОСреднемЗаработкеДляПособияПоБезработице"),
				МассивОбъектов, ОбъектыПечати, ПараметрыВывода), ,
			"Обработка.ПечатьКадровыхПриказов.ПФ_MXL_СправкаОСреднемЗаработкеДляПособияПоБезработице");
	КонецЕсли;
	
КонецПроцедуры

#Область СправкаОСреднемЗаработкеДляПособияПоБезработице

Функция ТабличныйДокументСправкаОСреднемЗаработкеДляПособияПоБезработице(Макет, МассивОбъектов, ОбъектыПечати, ПараметрыВывода)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ДанныеСправок = КадровыйУчет.ДанныеСправокОСреднемЗаработкеДляПособияПоБезработице(МассивОбъектов);
	Для Каждого ДанныеСправки Из ДанныеСправок Цикл
		
		НачалоСправки = ДокументРезультат.ВысотаТаблицы + 1;
		
		Если МассивОбъектов.Количество() = 1
			И ЗначениеЗаполнено(ДанныеСправки.EMail) Тогда
			
			ПараметрыВывода.ПараметрыОтправки.Получатель = ДанныеСправки.EMail;
			ПараметрыВывода.ПараметрыОтправки.Тема = НСтр("ru='Справка о среднем заработке для определения размера пособия по безработице'");
			
			Если ЗначениеЗаполнено(ДанныеСправки.ДатаСправки) Тогда
				
				ПараметрыВывода.ПараметрыОтправки.Тема = ПараметрыВывода.ПараметрыОтправки.Тема
					+ " " + НСтр("ru='от'") + " " + Формат(ДанныеСправки.ДатаСправки, "ДЛФ=DD");
				
			КонецЕсли;
			
		КонецЕсли;
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ОбластьШапка.Параметры.Заполнить(ДанныеСправки);
		ДокументРезультат.Вывести(ОбластьШапка);
		
		ПериодовНаПолномРабочемДне = ДанныеСправки.ПериодыРаботы.НайтиСтроки(Новый Структура("ПериодРаботыСПолнымРабочимДнем", Истина)).Количество();
		Если ПериодовНаПолномРабочемДне = 0 Тогда
			
			ОбластьПериодРаботыНаПолномГрафике = Макет.ПолучитьОбласть("ПериодРаботыНаПолномГрафике");
			ДокументРезультат.Вывести(ОбластьПериодРаботыНаПолномГрафике);
			
		КонецЕсли;
		
		ВывестиОбластьПериодаРаботыНаНеПолномГрафике = Истина;
		Для Каждого ПериодРаботы Из ДанныеСправки.ПериодыРаботы Цикл
			
			Если ПериодРаботы.ПериодРаботыСПолнымРабочимДнем Тогда
				ОбластьПериодРаботы = Макет.ПолучитьОбласть("ПериодРаботыНаПолномГрафике");
			Иначе
				ОбластьПериодРаботы = Макет.ПолучитьОбласть("ПериодРаботыНаНеПолномГрафике");
				ВывестиОбластьПериодаРаботыНаНеПолномГрафике = Ложь;
			КонецЕсли;
			
			ОбластьПериодРаботы.Параметры.Заполнить(ПериодРаботы);
			ДокументРезультат.Вывести(ОбластьПериодРаботы);
			
		КонецЦикла;
		
		Если ВывестиОбластьПериодаРаботыНаНеПолномГрафике Тогда
			
			ОбластьПериодРаботыНаНеПолномГрафике = Макет.ПолучитьОбласть("ПериодРаботыНаНеПолномГрафике");
			ДокументРезультат.Вывести(ОбластьПериодРаботыНаНеПолномГрафике);
			
		КонецЕсли;
		
		ОбластьТело = Макет.ПолучитьОбласть("Тело");
		ДокументРезультат.Вывести(ОбластьТело);
		
		Для Каждого ПериодНеРаботы Из ДанныеСправки.ПериодыНеРаботы Цикл
			
			ОбластьПериодНеРаботы = Макет.ПолучитьОбласть("ПериодНеРаботы");
			ОбластьПериодНеРаботы.Параметры.Заполнить(ПериодНеРаботы);
			ДокументРезультат.Вывести(ОбластьПериодНеРаботы);
			
		КонецЦикла;
		
		Если ДанныеСправки.ПериодыНеРаботы.Количество() < 7 Тогда
			
			ОбластьПериодНеРаботы = Макет.ПолучитьОбласть("ПериодНеРаботы");
			Для НомерОбласти = ДанныеСправки.ПериодыНеРаботы.Количество() + 1 По 7 Цикл
				ДокументРезультат.Вывести(ОбластьПериодНеРаботы);
			КонецЦикла;
			
		КонецЕсли;
		
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		ОбластьПодвал.Параметры.Заполнить(ДанныеСправки);
		ДокументРезультат.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НачалоСправки, ОбъектыПечати, ДанныеСправки.Сотрудник);
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли