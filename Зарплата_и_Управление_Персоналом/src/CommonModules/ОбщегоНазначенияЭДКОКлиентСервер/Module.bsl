////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность 
//             электронного документооборота с контролирующими органами". 
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

Функция ТекстовоеПредставлениеРазмераФайла(РазмерВБайтах, Разрядность = 0) Экспорт
	
	Размер = 0;
	РазмерВКилобайтах = Окр(РазмерВБайтах / 1024, Разрядность);
	Если РазмерВБайтах < 1024 Тогда
		Размер = РазмерВБайтах;
		Шаблон = НСтр("ru = '%1 Б'");
	ИначеЕсли РазмерВКилобайтах < 1000 Тогда
		Размер = РазмерВКилобайтах;
		Шаблон = НСтр("ru = '%1 КБ'");
	Иначе
		Размер = Окр(РазмерВКилобайтах / 1024, Разрядность);
		Шаблон = НСтр("ru = '%1 МБ'");
	КонецЕсли;
	
	Возврат СтрШаблон(Шаблон, Размер);
	
КонецФункции

Функция ЗаменитьНечитаемыеСимволы(ИсходнаяСтрока, ЗаменятьНа = "_") Экспорт
	
	Возврат ОбщегоНазначенияЭДКОКлиентСерверПовтИсп.ЗаменитьНечитаемыеСимволы(ИсходнаяСтрока, ЗаменятьНа);
	
КонецФункции

Функция ЗаменитьЗапрещенныеСимволыВИмениФайла(ИсходнаяСтрока, ЗаменятьНа = "_") Экспорт
	
	Возврат ОбщегоНазначенияЭДКОКлиентСерверПовтИсп.ЗаменитьЗапрещенныеСимволыВИмениФайла(ИсходнаяСтрока, ЗаменятьНа);
	
КонецФункции

Функция НовыйИдентификатор() Экспорт
	
	Возврат НРег(СтрЗаменить(Новый УникальныйИдентификатор, "-", ""));
	
КонецФункции

Функция УникальнаяСтрока(ИсходнаяУникальнаяСтрока, МаксимальнаяДлина) Экспорт
	
	Результат = ЗаменитьЗапрещенныеСимволыВИмениФайла(ИсходнаяУникальнаяСтрока);
	
	Если СтрДлина(Результат) > МаксимальнаяДлина Тогда
		ЗавершающийИдентификатор = НовыйИдентификатор();
		ДлинаИдентификатора = СтрДлина(ЗавершающийИдентификатор);
		Возврат Лев(Результат, МаксимальнаяДлина - ДлинаИдентификатора) + ЗавершающийИдентификатор;
	Иначе
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке) Экспорт
	
	Результат = ИнформацияОбОшибке;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			Результат = ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке.Причина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПриведеннаяВерсия(ПолнаяВерсия, КоличествоРазрядовВерсии) Экспорт
	
	Результат = "";
	КоличествоРазрядовРезультата = 0;
	
	РазрядыВерсии = СтрРазделить(ПолнаяВерсия, ".");
	Для каждого РазрядВерсии Из РазрядыВерсии Цикл
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(РазрядВерсии) Тогда
			Результат = Результат + ?(ЗначениеЗаполнено(Результат), ".", "") + РазрядВерсии;
			КоличествоРазрядовРезультата = КоличествоРазрядовРезультата + 1;
			Если КоличествоРазрядовРезультата >= КоличествоРазрядовВерсии Тогда
				Прервать;
			КонецЕсли;
			
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Пока КоличествоРазрядовРезультата < КоличествоРазрядовВерсии Цикл
			Результат = Результат + ".0";
			КоличествоРазрядовРезультата = КоличествоРазрядовРезультата + 1;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти