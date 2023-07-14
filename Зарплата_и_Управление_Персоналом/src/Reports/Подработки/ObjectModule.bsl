#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ЭлементОформления = НастройкиОтчета.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Формат", УправлениеШтатнымРасписанием.ФорматКоличестваСтавок());
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("КоличествоСтавок");
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра <> Неопределено Тогда
		Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("СтандартныйПериод") Тогда
			
			ЗначениеПараметра.Использование = Истина;
			
			Если ЗначениеПараметра.Значение.ДатаНачала = '00010101' Тогда
				ЗначениеПараметра.Значение.ДатаОкончания = НачалоГода(ТекущаяДатаСеанса());
			
			КонецЕсли;
			
			Если ЗначениеПараметра.Значение.ДатаОкончания < ЗначениеПараметра.Значение.ДатаНачала Тогда
                ЗначениеПараметра.Значение.ДатаОкончания = КонецГода(ЗначениеПараметра.Значение.ДатаНачала);
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	// Создадим и инициализируем процессор компоновки.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	// Обозначим начало вывода
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	ДопСвойства.Вставить("ОтчетПустой", ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновки));
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> КлючВарианта Тогда
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КлючСхемы = КлючВарианта;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли