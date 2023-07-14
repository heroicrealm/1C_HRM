#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ОткрытьПрисоединенныеФайлыБИД(
			ПараметрКоманды, 
			ПараметрыВыполненияКоманды) Тогда
	Иначе ОткрытьПрисоединенныеФайлыБСП(
			ПараметрКоманды, 
			ПараметрыВыполненияКоманды);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОткрытьПрисоединенныеФайлыБИД(ВладелецФайлов, ПараметрыВыполненияКоманды)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
	
		БИДКлиентПовтИсп = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияС1СДокументооборотКлиентПовтИсп");
		БИДВызовСервера  = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияС1СДокументооборотВызовСервера");
		ИмяФормы         = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ПрисоединенныеФайлы";
		
		Если БИДКлиентПовтИсп.ИспользоватьПрисоединенныеФайлы1СДокументооборота()
			И БИДВызовСервера.ИспользоватьПрисоединенныеФайлы1СДокументооборотаДляОбъекта(ВладелецФайлов) Тогда
			
			ОткрытьФорму(
				ИмяФормы,
				ПараметрыФормы(ВладелецФайлов, ПараметрыВыполненияКоманды),
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность,
				ПараметрыВыполненияКоманды.Окно);
				
			Возврат Истина	
		КонецЕсли;
	
	КонецЕсли;
	
	Возврат Ложь
	
КонецФункции

&НаКлиенте
Процедура ОткрытьПрисоединенныеФайлыБСП(ВладелецФайлов, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы",
		ПараметрыФормы(ВладелецФайлов, ПараметрыВыполненияКоманды),
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

&НаКлиенте
Функция ПараметрыФормы(ВладелецФайлов, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",  ВладелецФайлов);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ПараметрыВыполненияКоманды.Источник.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ПростаяФорма",   Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", СтрШаблон(НСтр("ru='Присоединенные файлы: %1'"), ВладелецФайлов));
	
	Возврат ПараметрыФормы
	
КонецФункции
	
#КонецОбласти

