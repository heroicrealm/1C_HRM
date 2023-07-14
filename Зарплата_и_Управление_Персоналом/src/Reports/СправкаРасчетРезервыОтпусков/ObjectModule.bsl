#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	Отказ = Ложь;
	ПередКомпоновкойМакета(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиОтчета);
	
	ПослеКомпоновкиМакета(МакетКомпоновки);
	
	// Создадим и инициализируем процессор компоновки.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	// Обозначим начало вывода
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	ОтчетПустой = ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновки);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

Процедура ПередКомпоновкойМакета(Отказ)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КлючВариантаОтчета"));
	Если ЗначениеПараметра <> Неопределено Тогда
		КлючВариантаОтчета = ЗначениеПараметра.Значение;
		Если НЕ ЗначениеЗаполнено(КлючВариантаОтчета) Тогда
			КлючВариантаОтчета = "СправкаРасчетРезервыОтпусков";
		КонецЕсли;
	Иначе
		КлючВариантаОтчета = "СправкаРасчетРезервыОтпусков";
	КонецЕсли;
	
	СправкаРасчет  = Ложь;
	ОстаткиОбороты = Ложь;
	ПоСотрудникам  = Ложь;
	Если КлючВариантаОтчета = "ОстаткиОборотыРезервовОтпусков" Тогда
		ОстаткиОбороты = Истина;
	ИначеЕсли КлючВариантаОтчета = "СправкаРасчетРезервыОтпусков" Тогда
		СправкаРасчет = Истина;
	ИначеЕсли КлючВариантаОтчета = "РезервыОтпусковПоСотрудникам" Тогда
		ПоСотрудникам = Истина;
	КонецЕсли;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	Организация = ЗначениеПараметра.Значение;
	
	ПоказательНУ = Ложь;
	ПоказательБУ = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Показатель"));
	Если ЗначениеПараметра.Значение = Истина Тогда
		ПоказательНУ = Истина;
		ПоказательБУ = Ложь;
	КонецЕсли;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	НачалоПериода = ЗначениеПараметра.Значение.ДатаНачала;
	КонецПериода  = ЗначениеПараметра.Значение.ДатаОкончания;
	
	НастройкиРезервовОтпусков = РезервОтпусков.НастройкиРезервовОтпусков(Организация, КонецПериода);
	МетодНачисленияРезерваОтпусков = НастройкиРезервовОтпусков.МетодНачисленияРезерваОтпусков;
	НормативныйМетод  = МетодНачисленияРезерваОтпусков = Перечисления.МетодыНачисленияРезервовОтпусков.НормативныйМетод;
	МетодОбязательств = МетодНачисленияРезерваОтпусков = Перечисления.МетодыНачисленияРезервовОтпусков.МетодОбязательств;
	ФормироватьРезервОтпусковБУ = НастройкиРезервовОтпусков.ФормироватьРезервОтпусковБУ;
	ФормироватьРезервОтпусковНУ = НастройкиРезервовОтпусков.ФормироватьРезервОтпусковНУ;
	
	Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
		Если СправкаРасчет Тогда
			Если НачалоМесяца(НачалоПериода) <> НачалоМесяца(КонецПериода) 
				ИЛИ НачалоМесяца(НачалоПериода) <> НачалоПериода
				ИЛИ КонецМесяца(КонецПериода) <> КонецПериода Тогда
				ТекстОшибки = НСтр("ru = 'В качестве периода следует указать целый месяц'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ФормироватьРезервОтпусковБУ
		И ПоказательБУ Тогда
		ТекстОшибки = НСтр("ru = 'В бухгалтерском учете оценочные обязательства не начисляются'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Если НЕ ФормироватьРезервОтпусковНУ
		И ПоказательНУ Тогда
		ТекстОшибки = НСтр("ru = 'В налоговом учете резервы не формируются'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Инвентаризация = КонецДня(КонецПериода) = КонецГода(КонецПериода);
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметра.Значение = НачалоПериода;
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметра.Значение = КонецПериода;
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериодаОстатков"));
	ЗначениеПараметра.Значение = Макс(КонецДня(НачалоПериода-1), НачалоГода(НачалоПериода));
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериодаОстатков"));
	ЗначениеПараметра.Значение = НачалоГода(НачалоПериода);
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Инвентаризация"));
	ЗначениеПараметра.Значение = Инвентаризация; 
	ЗначениеПараметра.Использование = Истина;
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИгнорироватьОборот"));
	ЗначениеПараметра.Значение = НачалоГода(НачалоПериода) = НачалоДня(Макс(КонецДня(НачалоПериода-1), НачалоГода(НачалоПериода)));
	ЗначениеПараметра.Использование = Истина;
	
	ПоддержкаПБУ18 = Истина;
	РезервОтпусковПереопределяемый.ПолучитьЗначениеНастройкиПоддержкаПБУ18(Организация, КонецПериода, ПоддержкаПБУ18);
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПоддержкаПБУ18"));
	ЗначениеПараметра.Значение = ПоддержкаПБУ18; 
	ЗначениеПараметра.Использование = Истина;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
	
	Таблица = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"РезервыОтпусков");
	
	МассивНазванийГруппировок = Новый Массив;
	Если ОстаткиОбороты Тогда
		МассивНазванийГруппировок.Добавить("ГруппировкаТипОценочногоОбязательства");
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
			МассивНазванийГруппировок.Добавить("ГруппировкаСтатьяФинансирования");
		КонецЕсли;
	ИначеЕсли ПоСотрудникам Тогда
		МассивНазванийГруппировок.Добавить("ГруппировкаСотрудник");
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
			МассивНазванийГруппировок.Добавить("ГруппировкаСтатьяФинансированияСотрудник");
		КонецЕсли;
	Иначе
		МассивНазванийГруппировок.Добавить("ГруппировкаФизическоеЛицо");
	КонецЕсли;
	
	МассивГруппировок = Новый Массив;
	
	Если ПоказательНУ Тогда
		Показатель = "НУ";
		Если ОстаткиОбороты Тогда
			СуффиксГруппировки = "ОстаткиОбороты";
		ИначеЕсли ПоСотрудникам Тогда
			СуффиксГруппировки = "";
		Иначе
			Если Инвентаризация Тогда
				СуффиксГруппировки = "МО";
			Иначе
				СуффиксГруппировки = "";
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Показатель = "БУ";
		Если ОстаткиОбороты Тогда
			СуффиксГруппировки = "ОстаткиОбороты";
		ИначеЕсли ПоСотрудникам Тогда
			СуффиксГруппировки = "";
		Иначе
			Если Инвентаризация
				ИЛИ МетодОбязательств Тогда
				СуффиксГруппировки = "МО";
			Иначе
				СуффиксГруппировки = "";
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ИмяГруппировки Из МассивНазванийГруппировок Цикл
		ИсходнаяГруппировка     = НайтиПоИмени(Таблица.Строки,ИмяГруппировки);
		Если ИсходнаяГруппировка = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяГруппировки          = ИмяГруппировки + Показатель + СуффиксГруппировки;
		ИсходнаяГруппировка.Имя = ИмяГруппировки;
		МассивГруппировок.Добавить(ИсходнаяГруппировка);
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить(Показатель);
	
	Для Каждого Группировка Из МассивГруппировок Цикл
		Группировка.Использование = Истина;
	КонецЦикла;
	
	МассивПоказателейРасчета = Новый Массив;
	
	Если СправкаРасчет Тогда
		Если Инвентаризация
			ИЛИ (ПоказательБУ И МетодОбязательств) Тогда
			МассивПоказателейРасчета.Добавить("ОстатокОтпуска");
			МассивПоказателейРасчета.Добавить("ОтпускАвансом");
			МассивПоказателейРасчета.Добавить("ОстатокОтпускаРасчетный");
			МассивПоказателейРасчета.Добавить("СреднийЗаработок");
			МассивПоказателейРасчета.Добавить("ТекущаяСтавкаСтраховыхВзносов");
			МассивПоказателейРасчета.Добавить("ТекущаяСтавкаФССНесчастныеСлучаи");
		Иначе
			МассивПоказателейРасчета.Добавить("ФОТ");
			МассивПоказателейРасчета.Добавить("СтраховыеВзносы");
			МассивПоказателейРасчета.Добавить("ФССНесчастныеСлучаи");
			МассивПоказателейРасчета.Добавить("НормативОтчисленийВРезервОтпусков");
		КонецЕсли;
		
		МассивПоказателейРасчета.Добавить("СуммаРезерваИсчислено" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовИсчислено" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиИсчислено" + Показатель);

		Если (ПоказательНУ И Инвентаризация)
			ИЛИ
			(ПоказательБУ И (Инвентаризация ИЛИ МетодОбязательств)) Тогда
			
			МассивПоказателейРасчета.Добавить("СуммаРезерваНакоплено" + Показатель);
			МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовНакоплено" + Показатель);
			МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиНакоплено" + Показатель);
		КонецЕсли;
		
		МассивПоказателейРасчета.Добавить("СуммаРезерва" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносов" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаи" + Показатель);
		
	ИначеЕсли ОстаткиОбороты Тогда
		
		МассивПоказателейРасчета.Добавить("НачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("Расход" + Показатель);
		МассивПоказателейРасчета.Добавить("Приход" + Показатель);
		МассивПоказателейРасчета.Добавить("КонечныйОстаток" + Показатель);
		
	ИначеЕсли ПоСотрудникам Тогда
		
		// Остатки на начало
		МассивПоказателейРасчета.Добавить("СуммаРезерваНачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовНачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиНачальныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваНачальныйОстатокВсего" + Показатель);
		
		// Выбыло
		МассивПоказателейРасчета.Добавить("СуммаРезерваРасход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовРасход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиРасход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваРасходВсего" + Показатель);
		
		// Начислено
		МассивПоказателейРасчета.Добавить("СуммаРезерваПриход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовПриход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиПриход" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваПриходВсего" + Показатель);
		
		// Остатки на конец
		МассивПоказателейРасчета.Добавить("СуммаРезерваКонечныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваСтраховыхВзносовКонечныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваФССНесчастныеСлучаиКонечныйОстаток" + Показатель);
		МассивПоказателейРасчета.Добавить("СуммаРезерваКонечныйОстатокВсего" + Показатель);
		
	КонецЕсли;
	
	Номер = 0;
	
	Для Каждого Группировка Из МассивГруппировок Цикл
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ОтчетыСервер.ДобавитьВыбранноеПоле(Группа, СтрЗаменить(МассивНазванийГруппировок[Номер], "Группировка", ""));
		
		Для Каждого ИмяПоказателя Из МассивПоказателейРасчета Цикл
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ОтчетыСервер.ДобавитьВыбранноеПоле(Группа, ИмяПоказателя);
		КонецЦикла;
		
		Номер = Номер + 1;
		
	КонецЦикла;
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных)));
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(МакетКомпоновки)
	
	ЗначениеПараметра = МакетКомпоновки.ЗначенияПараметров.Найти("КлючВариантаОтчета");
	Если ЗначениеПараметра <> Неопределено Тогда
		КлючВариантаОтчета = ЗначениеПараметра.Значение;
		Если НЕ ЗначениеЗаполнено(КлючВариантаОтчета) Тогда
			КлючВариантаОтчета = "СправкаРасчетРезервыОтпусков";
		КонецЕсли;
	Иначе
		КлючВариантаОтчета = "СправкаРасчетРезервыОтпусков";
	КонецЕсли;
	
	Если КлючВариантаОтчета = "ОстаткиОборотыРезервовОтпусков"
		ИЛИ КлючВариантаОтчета = "РезервыОтпусковПоСотрудникам" Тогда
		Возврат;
	КонецЕсли;
	
	// Удаление итоговых строк в группировке
	Для Каждого ЧастьМакета Из МакетКомпоновки.Тело Цикл 
		Если ТипЗнч(ЧастьМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			Если ЧастьМакета.Строки.Количество() <> 0 Тогда
				ИтогиГруппировкиТаблица = ЧастьМакета.Строки[0].Тело[0];
				ЧастьМакета.Строки[0].Тело.Удалить(ИтогиГруппировкиТаблица);
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	Настройки.Вставить("РазрешеноМенятьВарианты",    Истина);
	Настройки.Вставить("РазрешеноИзменятьСтруктуру", Ложь);
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> КлючВарианта Тогда
		
		МассивУдаляемыхСхем = Новый Массив;
		Если КлючВарианта = "ОстаткиОборотыРезервовОтпусков" Тогда
			МассивУдаляемыхСхем.Добавить("НаборДанных");
			МассивУдаляемыхСхем.Добавить("НаборДанныхПоСотрудникам");
		ИначеЕсли КлючВарианта = "РезервыОтпусковПоСотрудникам" Тогда
			МассивУдаляемыхСхем.Добавить("НаборДанных");
			МассивУдаляемыхСхем.Добавить("НаборДанныхОстаткиОбороты");
		Иначе
			МассивУдаляемыхСхем.Добавить("НаборДанныхОстаткиОбороты");
			МассивУдаляемыхСхем.Добавить("НаборДанныхПоСотрудникам");
		КонецЕсли;
		
		Для Каждого ИмяУдаляемойСхемы Из МассивУдаляемыхСхем Цикл
			УдаляемаяСхема = СхемаКомпоновкиДанных.НаборыДанных.Найти(ИмяУдаляемойСхемы);
			Если УдаляемаяСхема <> Неопределено Тогда
				СхемаКомпоновкиДанных.НаборыДанных.Удалить(УдаляемаяСхема);
			КонецЕсли;
		КонецЦикла;
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КлючСхемы = КлючВарианта;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли