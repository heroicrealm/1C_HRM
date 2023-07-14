#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьВторичныеДанные(ФизическиеЛица = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписываемыйНабор = РегистрыСведений.СтатусФизическихЛицКакНалогоплательщиковНДФЛВторичный.СоздатьНаборЗаписей();
	ЗаписываемыйНабор.ОбменДанными.Загрузка = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Период КАК Период,
	|	СтатусФизическихЛицКакНалогоплательщиковНДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СтатусФизическихЛицКакНалогоплательщиковНДФЛ.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.СтатусФизическихЛицКакНалогоплательщиковНДФЛ КАК СтатусФизическихЛицКакНалогоплательщиковНДФЛ
	|ГДЕ
	|	&УсловиеПоФизическомуЛицу
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизическоеЛицо,
	|	Период";
	
	Если ФизическиеЛица = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоФизическомуЛицу", "ИСТИНА");
		ЗаписываемыйНабор.Записать();
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоФизическомуЛицу",
			"СтатусФизическихЛицКакНалогоплательщиковНДФЛ.ФизическоеЛицо В (&ФизическиеЛица)");
		Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	КонецЕсли;
	
	// АПК:1328-выкл Заполнение вторичных данных вызывается из записи набора первичных данных.
	Результат = Запрос.Выполнить();
	// АПК:1328-вкл
		
	Если Результат.Пустой() И ФизическиеЛица <> Неопределено Тогда
		Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл
			ЗаписываемыйНабор.Отбор.ФизическоеЛицо.Установить(ФизическоеЛицо);
			ЗаписываемыйНабор.Записать();
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ФизическоеЛицо") Цикл
		ЗаписываемыйНабор.Отбор.ФизическоеЛицо.Установить(Выборка.ФизическоеЛицо);
		ВторичныеДанные = ВторичныеДанныеФизическогоЛица(Выборка);
		ЗаписываемыйНабор.Загрузить(ВторичныеДанные);
		ЗаписываемыйНабор.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Пересчитывает зависимые данные после загрузки сообщения обмена
//
// Параметры:
//		ЗависимыеДанные - ТаблицаЗначений:
//			* ВедущиеМетаданные - ОбъектМетаданных - Метаданные ведущих данных
//			* ЗависимыеМетаданные - ОбъектМетаданных - Метаданные текущего объекта
//			* ВедущиеДанные - Массив объектов, заполненный при загрузке сообщения обмена
//				по этим объектам требуется обновить зависимые данные
//
// АПК:299-выкл - горизонтальный механизм без непосредственных вызовов
Процедура ОбновитьЗависимыеДанныеПослеЗагрузкиОбменаДанными(ЗависимыеДанные) Экспорт
	
	Если ЗависимыеДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ФизическиеЛица = Новый Массив;
	
	Для Каждого СтрокаТаблицы Из ЗависимыеДанные Цикл
		Для Каждого НаборЗаписей Из СтрокаТаблицы.ВедущиеДанные Цикл
			ФизическоеЛицоНабораЗаписей = НаборЗаписей.Отбор.ФизическоеЛицо.Значение;
			Если Не ЗначениеЗаполнено(ФизическоеЛицоНабораЗаписей) Тогда
				ЗаполнитьВторичныеДанные();
				Возврат; // При пустом физическом лице, хотя бы в одном наборе записей 
				         // будут заполнены вторичные данные по всем физическим лицам.
			КонецЕсли;
			ФизическиеЛица.Добавить(ФизическоеЛицоНабораЗаписей);
		КонецЦикла
	КонецЦикла;
	
	ЗаполнитьВторичныеДанные(ФизическиеЛица);
	
КонецПроцедуры
// АПК:299-вкл 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВторичныеДанныеФизическогоЛица(ВыборкаПервичногоРегистра)
	
	ДатаЗакона285ФЗ = УчетНДФЛ.ДатаЗакона285ФЗ();
	ДатаИзмененияИсчисленияДляИностранцев = УчетНДФЛ.ДатаИзмененияПорядкаИсчисленияНалогаДляИностранцев();
	
	ДатыИзмененияЗаконодательства = Новый ТаблицаЗначений;
	ДатыИзмененияЗаконодательства.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ДатыИзмененияЗаконодательства.Добавить().Дата = ДатаЗакона285ФЗ; 
	ДатыИзмененияЗаконодательства.Добавить().Дата = ДатаИзмененияИсчисленияДляИностранцев;
	ДатыИзмененияЗаконодательства.Сортировать("Дата");

	ВторичныеДанные = РегистрыСведений.СтатусФизическихЛицКакНалогоплательщиковНДФЛВторичный.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	
	Если ВыборкаПервичногоРегистра.Количество() = 0 Тогда
		Возврат ВторичныеДанные;
	КонецЕсли;
	
	ИзмененияЗаконодательства = ДатыИзмененияЗаконодательства.Скопировать();
	УчтенныеИзмененияЗаконодательства = Новый Массив;
	ДобавляемыеПериоды = ВторичныеДанные.Скопировать();
	
	Пока ВыборкаПервичногоРегистра.Следующий() Цикл
		Если ВторичныеДанные.Количество() > 0 Тогда
			// выполним разбиение с учетом дат изменения законодательства
			ПоследняяЗапись = ВторичныеДанные[ВторичныеДанные.Количество() - 1];
			
			Для Каждого ДатаИзмененияЗаконодательства Из ИзмененияЗаконодательства Цикл
				Если ДатаИзмененияЗаконодательства.Дата < ВыборкаПервичногоРегистра.Период 
					И ДатаИзмененияЗаконодательства.Дата > ПоследняяЗапись.ДатаНачала Тогда
					
					Запись = ВторичныеДанные.Добавить();
					Запись.ДатаНачала = ДатаИзмененияЗаконодательства.Дата;
					Запись.ФизическоеЛицо = ВыборкаПервичногоРегистра.ФизическоеЛицо;
					Запись.Статус = ПоследняяЗапись.Статус;
					
					УчтенныеИзмененияЗаконодательства.Добавить(ДатаИзмененияЗаконодательства);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Запись = ВторичныеДанные.Добавить();
		Запись.ДатаНачала = ВыборкаПервичногоРегистра.Период;
		Запись.ФизическоеЛицо = ВыборкаПервичногоРегистра.ФизическоеЛицо;
		Запись.Статус = ВыборкаПервичногоРегистра.Статус;
		
		Для Каждого ДатаИзмененияЗаконодательства Из УчтенныеИзмененияЗаконодательства Цикл
			ИзмененияЗаконодательства.Удалить(ДатаИзмененияЗаконодательства);
		КонецЦикла;
		УчтенныеИзмененияЗаконодательства.Очистить();
	КонецЦикла;
	
	Если ВторичныеДанные.Количество() > 0 Тогда
		// выполним разбиение с учетом дат изменения законодательства
		ПоследняяЗапись = ВторичныеДанные[ВторичныеДанные.Количество() - 1];
		Для Каждого ДатаИзмененияЗаконодательства Из ИзмененияЗаконодательства Цикл
			Если ДатаИзмененияЗаконодательства.Дата > ПоследняяЗапись.ДатаНачала Тогда
				ПоследняяЗапись = ВторичныеДанные[ВторичныеДанные.Количество() - 1];
				
				Запись = ВторичныеДанные.Добавить();
				Запись.ДатаНачала = ДатаИзмененияЗаконодательства.Дата;
				Запись.ФизическоеЛицо = ВыборкаПервичногоРегистра.ФизическоеЛицо;
				Запись.Статус = ПоследняяЗапись.Статус;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ВторичныеДанные.Сортировать("ДатаНачала");
	
	Если ВторичныеДанные.Количество() > 0 Тогда 
		ПерваяЗапись = ВторичныеДанные[0];
		Если ПерваяЗапись.ДатаНачала > НачалоГода(ПерваяЗапись.ДатаНачала) Тогда
			Запись = ВторичныеДанные.Добавить();
			Запись.ДатаНачала = НачалоГода(ПерваяЗапись.ДатаНачала);
			Запись.ФизическоеЛицо = ПерваяЗапись.ФизическоеЛицо;
			Запись.Статус = Справочники.СтатусыНалогоплательщиковПоНДФЛ.Резидент;
			ВторичныеДанные.Сортировать("ДатаНачала");
		КонецЕсли;
	КонецЕсли;
	
	ПредыдущаяЗапись = Неопределено;
	Для Каждого ЗаписьНабора Из ВторичныеДанные Цикл
		НовыйПериод = Неопределено;
		Если ПредыдущаяЗапись <> Неопределено Тогда
			Если НачалоГода(ЗаписьНабора.ДатаНачала) <> НачалоГода(ПредыдущаяЗапись.ДатаНачала)
				И НачалоГода(ЗаписьНабора.ДатаНачала) <> ЗаписьНабора.ДатаНачала Тогда
				ПредыдущаяЗапись.ДатаОкончания = НачалоГода(ЗаписьНабора.ДатаНачала) - 1;
				
				НовыйПериод = ДобавляемыеПериоды.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйПериод, ПредыдущаяЗапись);
				НовыйПериод.ДатаНачала = НачалоГода(ЗаписьНабора.ДатаНачала);
				НовыйПериод.ДатаОкончания = ЗаписьНабора.ДатаНачала - 1;
				НовыйПериод.Год = НовыйПериод.ДатаНачала;
				
				ПредыдущаяЗапись = НовыйПериод;
				
			КонецЕсли;
			
			Если ЗаписьНабора.ДатаНачала <> НачалоМесяца(ЗаписьНабора.ДатаНачала) 
				И Месяц(ЗаписьНабора.ДатаНачала) <> 1 Тогда
				ПредыдущаяЗапись.ДатаОкончания = НачалоМесяца(ЗаписьНабора.ДатаНачала) - 1;
				
				НовыйПериод = ДобавляемыеПериоды.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйПериод, ПредыдущаяЗапись);
				НовыйПериод.ДатаНачала = НачалоМесяца(ЗаписьНабора.ДатаНачала);
				НовыйПериод.ДатаОкончания = ЗаписьНабора.ДатаНачала - 1;
				НовыйПериод.Год = НачалоГода(НовыйПериод.ДатаНачала);
			Иначе
				ПредыдущаяЗапись.ДатаОкончания = ЗаписьНабора.ДатаНачала - 1;
			КонецЕсли;
		КонецЕсли;
		
		ПредыдущаяЗапись = ЗаписьНабора;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДобавляемыеПериоды, ВторичныеДанные);
	ВторичныеДанные.Сортировать("ДатаНачала");
	
	Если ВторичныеДанные.Количество() > 0  Тогда
		ВторичныеДанные[ВторичныеДанные.Количество() - 1].ДатаОкончания = ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата();
	КонецЕсли;
	
	// рассчитаем значения на конец отчетных периодов
	ПредыдущаяЗапись = Неопределено;
	ЗаписиЗаГод = Новый Массив;
	РесурсыРегистра = 
	"РезидентРФНаКонецКвартала1,
	|РезидентРФНаКонецКвартала2,
	|РезидентРФНаКонецКвартала3,
	|РезидентРФНаКонецГода,
	|СтатусНаКонецКвартала1,
	|СтатусНаКонецКвартала2,
	|СтатусНаКонецКвартала3,
	|СтатусНаКонецГода";
	ЗначенияРесурсов = Новый Структура(РесурсыРегистра);
	Для Каждого ЗаписьНабора Из ВторичныеДанные Цикл
		
		РезидентРФНаКонецМесяца = ЗаписьНабора.Статус <> Справочники.СтатусыНалогоплательщиковПоНДФЛ.Нерезидент;
		Если ЗаписьНабора.ДатаНачала < ДатаЗакона285ФЗ Тогда
			РезидентРФНаКонецМесяца = Не (ЗаписьНабора.Статус = Справочники.СтатусыНалогоплательщиковПоНДФЛ.Нерезидент Или ЗаписьНабора.Статус = Справочники.СтатусыНалогоплательщиковПоНДФЛ.Беженцы);
		КонецЕсли;
		ЗаписьНабора.РезидентРФНаКонецМесяца = РезидентРФНаКонецМесяца;
		
		ЗаписьНабора.Год = НачалоГода(ЗаписьНабора.ДатаНачала);
		
		Если ПредыдущаяЗапись <> Неопределено И ПредыдущаяЗапись.Год <> ЗаписьНабора.Год Тогда
			Для Каждого ЗаписьЗаГод Из ЗаписиЗаГод Цикл
				ЗаполнитьЗначенияСвойств(ЗаписьЗаГод, ЗначенияРесурсов, РесурсыРегистра);
			КонецЦикла;
			
			ЗначенияРесурсов = Новый Структура(РесурсыРегистра);
			ЗаписиЗаГод = Новый Массив;
		КонецЕсли;
		
		Для ОтчетныйПериод = 1 По 4 Цикл
			ИмяРесурсаСтатус = ?(ОтчетныйПериод = 4, "СтатусНаКонецГода", "СтатусНаКонецКвартала" + ОтчетныйПериод);
			ИмяРесурсаРезидент = ?(ОтчетныйПериод = 4, "РезидентРФНаКонецГода", "РезидентРФНаКонецКвартала"  + ОтчетныйПериод);
			НачалоКвартала = ДобавитьМесяц(ЗаписьНабора.Год, (ОтчетныйПериод-1) * 3);
			ОкончаниеКвартала = КонецКвартала(НачалоКвартала);
			
			Если (ЗаписьНабора.ДатаНачала >= НачалоКвартала И ЗаписьНабора.ДатаНачала <= ОкончаниеКвартала) 
				Или (ЗаписьНабора.ДатаНачала < НачалоКвартала И ЗаписьНабора.ДатаОкончания > ОкончаниеКвартала) 
				Или (ЗаписьНабора.ДатаОкончания >= НачалоКвартала И ЗаписьНабора.ДатаОкончания <= ОкончаниеКвартала) Тогда
				ЗначенияРесурсов[ИмяРесурсаРезидент] = ЗаписьНабора.РезидентРФНаКонецМесяца;
				ЗначенияРесурсов[ИмяРесурсаСтатус] = ЗаписьНабора.Статус;
			КонецЕсли;
		КонецЦикла;
		
		ЗаписиЗаГод.Добавить(ЗаписьНабора);
		
		ПредыдущаяЗапись = ЗаписьНабора;
	КонецЦикла;
	Если ЗаписиЗаГод.Количество() > 0 Тогда
		Для Каждого ЗаписьЗаГод Из ЗаписиЗаГод Цикл
			ЗаполнитьЗначенияСвойств(ЗаписьЗаГод, ЗначенияРесурсов, РесурсыРегистра);
		КонецЦикла;
	КонецЕсли;
	
	// рассчитаем ресурс ПрименяетсяСтавкаПункта1Статьи224НК
	Для Каждого ЗаписьНабора Из ВторичныеДанные Цикл
		Если ЗаписьНабора.ДатаНачала < ДатаИзмененияИсчисленияДляИностранцев Тогда
			ЗаписьНабора.ПрименяетсяСтавкаПункта1Статьи224НК = ЗаписьНабора.РезидентРФНаКонецМесяца Или ЗаписьНабора.РезидентРФНаКонецГода;
		ИначеЕсли ЗаписьНабора.СтатусНаКонецГода = Справочники.СтатусыНалогоплательщиковПоНДФЛ.Резидент Тогда
			ЗаписьНабора.ПрименяетсяСтавкаПункта1Статьи224НК = Истина;
		ИначеЕсли ЗаписьНабора.Статус = Справочники.СтатусыНалогоплательщиковПоНДФЛ.Резидент
			Или ЗаписьНабора.Статус = Справочники.СтатусыНалогоплательщиковПоНДФЛ.ГражданинСтраныЕАЭС Тогда
			
			ЗаписьНабора.ПрименяетсяСтавкаПункта1Статьи224НК = Истина;
		Иначе
			ЗаписьНабора.ПрименяетсяСтавкаПункта1Статьи224НК = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВторичныеДанные;
	
КонецФункции

#КонецОбласти

#КонецЕсли