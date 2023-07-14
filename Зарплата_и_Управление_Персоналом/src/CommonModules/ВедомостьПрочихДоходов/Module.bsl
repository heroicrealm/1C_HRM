#Область СлужебныеПроцедурыИФункции

Функция МожноЗаполнитьВыплаты(Ведомость) Экспорт
	
	ПравилаПроверки = Новый Структура;
	
	ПравилаПроверки.Вставить("Организация",			НСтр("ru='Не выбрана организация'"));
	ПравилаПроверки.Вставить("ПериодРегистрации",	НСтр("ru='Не задан период регистрации'"));
	ПравилаПроверки.Вставить("Дата",				НСтр("ru='Не задана дата документа'"));
	ПравилаПроверки.Вставить("СпособВыплаты",		НСтр("ru='Не указан способ выплаты'"));
	
	Если ПолучитьФункциональнуюОпцию("ПроверятьЗаполнениеФинансированияВВедомостях") Тогда
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Ведомость.Метаданные().Реквизиты.СтатьяФинансирования) Тогда
			ПравилаПроверки.Вставить("СтатьяФинансирования", НСтр("ru='Не указана статья финансирования'"));
		КонецЕсли;
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Ведомость.Метаданные().Реквизиты.СтатьяРасходов) Тогда
			ПравилаПроверки.Вставить("СтатьяРасходов",       НСтр("ru='Не указана статья расходов'"));
		КонецЕсли;
	КонецЕсли;	
	
	МожноЗаполнить = ЗарплатаКадры.СвойстваЗаполнены(Ведомость, ПравилаПроверки);

	Возврат МожноЗаполнить;

КонецФункции

Процедура ЗаполнитьВыплаты(Ведомость) Экспорт
	
	Ведомость.ЗаполнитьПоТаблицеВыплат(ЗапросОстатковВыплат(Ведомость).Выполнить().Выгрузить());
		
КонецПроцедуры

Процедура ДополнитьВыплаты(Ведомость, ФизическиеЛица) Экспорт
	
	Запрос = ЗапросОстатковВыплат(Ведомость, ФизическиеЛица);
	
	ТаблицаВыплат = Запрос.Выполнить().Выгрузить();
	ФизическиеЛицаСОстатками = ТаблицаВыплат.ВыгрузитьКолонку("ФизическоеЛицо");
	Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл
		Если ФизическиеЛицаСОстатками.Найти(ФизическоеЛицо) = Неопределено Тогда
			НоваяСтрока = ТаблицаВыплат.Добавить();
			НоваяСтрока.ФизическоеЛицо = ФизическоеЛицо;
		КонецЕсли;
	КонецЦикла;
	
	Ведомость.ДополнитьПоТаблицеВыплат(ТаблицаВыплат);
		
КонецПроцедуры

Функция ЗапросОстатковВыплат(Ведомость, ФизическиеЛица = Неопределено)

	Отбор = ВзаиморасчетыПоПрочимДоходам.ОтборЗапросаОстаткиВзаиморасчетовСКонтрагентамиАкционерам();
	
	Основания = Ведомость.Основания.ВыгрузитьКолонку("Документ");
	Если Основания.Количество() > 0 Тогда
		// указаны документы-основания, делаем отбор по ним
		Отбор.Основания = Основания; 
	Иначе
		// не указаны документы-основания, отбираем по виду документа
		Отбор.Основания = Перечисления.СпособыВыплатыПрочихДоходов.МетаданныеОснования(Ведомость.СпособВыплаты); 
	КонецЕсли;
	Отбор.ФизическиеЛица       = ФизическиеЛица;
	Отбор.СтатьяФинансирования = Ведомость.СтатьяФинансирования; 
	Отбор.СтатьяРасходов       = Ведомость.СтатьяРасходов;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Ведомость, "ВидДоходаИсполнительногоПроизводства") Тогда
		Отбор.ВидДохода        = Ведомость.ВидДоходаИсполнительногоПроизводства;
	КонецЕсли;	
	 
	Запрос = ВзаиморасчетыПоПрочимДоходам.ЗапросОстаткиВзаиморасчетовСКонтрагентамиАкционерами(
		Ведомость.Ссылка,
		КонецМесяца(Ведомость.ПериодРегистрации),
		Ведомость.Организация,
		Перечисления.СпособыВыплатыПрочихДоходов.СпособРасчетов(Ведомость.СпособВыплаты),
		Отбор);
	
	Возврат Запрос;

КонецФункции

Процедура ЗаполнитьПоТаблицеВыплат(Ведомость, ТаблицаВыплат) Экспорт
	
	// Группируем строки таблицы зарплат
	СгруппироватьТаблицуВыплат(Ведомость, ТаблицаВыплат);
	
	// Собираем состав
	Состав = СоставПоТаблицеВыплат(Ведомость, ТаблицаВыплат);
	
	// Убираем неположительные строки
	УдаляемыеСтрокиСостава = Новый Массив;
	Для Каждого СтрокаСостава Из Состав Цикл
		Если СтрокаСостава.КВыплате <= 0 Тогда
			УдаляемыеСтрокиСостава.Добавить(СтрокаСостава);
		КонецЕсли;	
	КонецЦикла;
	Для Каждого УдаляемаяСтрокаСостава Из УдаляемыеСтрокиСостава Цикл
		Состав.Удалить(УдаляемаяСтрокаСостава);
	КонецЦикла;
	
	// Заполняем табличные части ведомости сгруппированной зарплатой 
	ОчиститьСостав(Ведомость);
	ДополнитьСостав(Ведомость, Состав);
	
КонецПроцедуры

Процедура ДополнитьПоТаблицеВыплат(Ведомость, ТаблицаВыплат) Экспорт
	
	// Группируем строки таблицы зарплат
	СгруппироватьТаблицуВыплат(Ведомость, ТаблицаВыплат);
	
	// Собираем состав
	Состав = СоставПоТаблицеВыплат(Ведомость, ТаблицаВыплат);
	
	// Дополняем табличные части ведомости сгруппированной зарплатой 
	ДополнитьСостав(Ведомость, Состав);
	
КонецПроцедуры

Процедура СгруппироватьТаблицуВыплат(Ведомость, ТаблицаВыплат)

	ТаблицаВыплат.Колонки.Добавить("ИдентификаторСтроки", Ведомость.Метаданные().ТабличныеЧасти.Состав.Реквизиты.ИдентификаторСтроки.Тип);
	ТаблицаВыплат.Индексы.Добавить("ИдентификаторСтроки");
	
	// колонки группировки - это реквизиты ТЧ Состав, кроме идентификатора строки
	КолонкиГруппировки = КолонкиГруппировкиЗарплаты(Ведомость);
	
	// структура для отбора строк зарплаты, попадающих в группу
	ПараметрыОтбораГруппы = Новый Структура(КолонкиГруппировки);
	
	// выделяем группы таблицы зарплат
	Группы = ТаблицаВыплат.Скопировать(, КолонкиГруппировки);
	Группы.Свернуть(КолонкиГруппировки);
	
	// Группируем строки
	Для Каждого Группа Из Группы Цикл
		
		ЗаполнитьЗначенияСвойств(ПараметрыОтбораГруппы, Группа); 
		ВыплатыГруппы = ТаблицаВыплат.НайтиСтроки(ПараметрыОтбораГруппы);
		
		ИдентификаторСтроки = Новый УникальныйИдентификатор;
		
		Для Каждого СтрокаВыплаты Из ВыплатыГруппы Цикл
			СтрокаВыплаты.ИдентификаторСтроки = ИдентификаторСтроки;
		КонецЦикла;	
		
	КонецЦикла;
	
КонецПроцедуры

Функция СоставПоТаблицеВыплат(Ведомость, ТаблицаВыплат)
	
	// Получаем ключевые поля группировки зарплаты
	КолонкиГруппировки = КолонкиГруппировкиЗарплаты(Ведомость);
	
	// Создаем таблицу состава - ключевые поля и поле с массивом строк таблицы зарплат
	Состав = Ведомость.Состав.ВыгрузитьКолонки(КолонкиГруппировки +", ИдентификаторСтроки");
	Состав.Колонки.Добавить("КВыплате");
	Состав.Колонки.Добавить("СписокВыплат");
	
	// структура для отбора строк зарплаты, попадающих в строку состава
	ПараметрыОтбораГруппы = Новый Структура("ИдентификаторСтроки");
	
	// выделяем группы из таблицы зарплат
	ИдентификаторыГрупп = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ТаблицаВыплат.ВыгрузитьКолонку("ИдентификаторСтроки"));
	
	// создаем строки состава, помещая в них и строки таблицы зарплат
	Для Каждого ИдентификаторСтроки Из ИдентификаторыГрупп Цикл
		
		ПараметрыОтбораГруппы.ИдентификаторСтроки = ИдентификаторСтроки; 
		ВыплатаГруппы = ТаблицаВыплат.Скопировать(ПараметрыОтбораГруппы);
		
		СтрокаСостава = Состав.Добавить();
		СтрокаСостава.ИдентификаторСтроки = ИдентификаторСтроки;
		
		ЗаполнитьЗначенияСвойств(СтрокаСостава, ВыплатаГруппы[0], КолонкиГруппировки);
		СтрокаСостава.СписокВыплат = ВыплатаГруппы;
		СтрокаСостава.КВыплате = ВыплатаГруппы.Итог("КВыплате");
		
	КонецЦикла;
	
	// Получаем НДФЛ к удержанию (перечислению)
	НДФЛ = НДФЛПоТаблицеВыплат(Ведомость, ТаблицаВыплат);
	
	// Инициализируем колонку налога в таблице состава 		
	Состав.Колонки.Добавить("НДФЛ"); 
	Для Каждого СтрокаСостава Из Состав Цикл
		СтрокаСостава.НДФЛ = НДФЛ.СкопироватьКолонки()
	КонецЦикла;		
			
	// структура для отбора строк налога, попадающих в строку состава
	ПараметрыОтбораНДФЛ = Новый Структура("ФизическоеЛицо");
	
	// получаем список различных физлиц
	Физлица = ТаблицаВыплат.Скопировать(, "ФизическоеЛицо");
	Физлица.Свернуть("ФизическоеЛицо");
	Физлица = Физлица.ВыгрузитьКолонку("ФизическоеЛицо");
	
	// ищем строки состава для физлиц, помещая в них соответствующий налог
	Для Каждого Физлицо Из Физлица Цикл
		
		СтрокаСостава = Состав.Найти(Физлицо, "ФизическоеЛицо");
		Если СтрокаСостава = Неопределено Тогда
			Продолжить
		КонецЕсли;	
		
		ПараметрыОтбораНДФЛ.ФизическоеЛицо = Физлицо; 
		СтрокаСостава.НДФЛ = НДФЛ.Скопировать(ПараметрыОтбораНДФЛ);
		
	КонецЦикла;
	
	Возврат Состав;
	
КонецФункции

Процедура ОчиститьСостав(Ведомость)
	Ведомость.Состав.Очистить();
	Ведомость.Выплаты.Очистить();
	Ведомость.НДФЛ.Очистить();
КонецПроцедуры

Процедура ДополнитьСостав(Ведомость, Состав)
	
	Для Каждого СтрокаСостава Из Состав Цикл
		
		СтрокаТЧСостав = Ведомость.Состав.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧСостав, СтрокаСостава);

		Для Каждого СтрокаВыплаты Из СтрокаСостава.СписокВыплат Цикл
			СтрокаТЧСписокВыплат = Ведомость.Выплаты.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧСписокВыплат, СтрокаВыплаты);
			СтрокаТЧСписокВыплат.ИдентификаторСтроки = СтрокаСостава.ИдентификаторСтроки;
		КонецЦикла;
		
		Для Каждого СтрокаНДФЛ Из СтрокаСостава.НДФЛ Цикл
			СтрокаТЧНДФЛ = Ведомость.НДФЛ.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧНДФЛ, СтрокаНДФЛ);
			СтрокаТЧНДФЛ.ИдентификаторСтроки = СтрокаСостава.ИдентификаторСтроки;
		КонецЦикла;
		
	КонецЦикла
	
КонецПроцедуры

Функция КолонкиГруппировкиЗарплаты(Ведомость)
	
	// колонки группировки - это реквизиты ТЧ Состав, кроме идентификатора строки
	РеквизитыВыплаты = Ведомость.Метаданные().ТабличныеЧасти.Выплаты.Реквизиты;
	КолонкиГруппировки	= Новый Массив;
	Для Каждого РеквизитСостава Из Ведомость.Метаданные().ТабличныеЧасти.Состав.Реквизиты  Цикл
		Если РеквизитыВыплаты.Найти(РеквизитСостава.Имя) <> Неопределено Тогда
			КолонкиГруппировки.Добавить(РеквизитСостава.Имя);
		КонецЕсли	
	КонецЦикла;	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(КолонкиГруппировки, "ИдентификаторСтроки");
	
	Возврат СтрСоединить(КолонкиГруппировки, ", ")

КонецФункции

Процедура ОбработкаПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ПроверятьЗаполнениеФинансированияВВедомостях") Тогда
		
		ПоляСтатей = Новый Массив;
		ПоляСтатей.Добавить("СтатьяФинансирования");
		ПоляСтатей.Добавить("СтатьяРасходов");
		КолонкиСтатей = СтрСоединить(ПоляСтатей, ",");
		
		Для Каждого СтрокаСостава Из ДокументОбъект.Состав Цикл
			ВыплатаСтроки = ДокументОбъект.Выплаты.Выгрузить(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки), КолонкиСтатей);
			ОшибкаФинансированияСтроки = Ложь;
			Для Каждого ПолеСтатьи Из ПоляСтатей Цикл
				Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ДокументОбъект.Метаданные().Реквизиты[ПолеСтатьи]) 
					И ЗначениеЗаполнено(ДокументОбъект[ПолеСтатьи]) Тогда
					СтатьиСтроки = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВыплатаСтроки.ВыгрузитьКолонку(ПолеСтатьи));
					Если СтатьиСтроки.Количество() > 1 Или СтатьиСтроки[0] <> ДокументОбъект[ПолеСтатьи] Тогда
						ОшибкаФинансированияСтроки = Истина;
						Прервать;
					КонецЕсли	
				КонецЕсли;	
			КонецЦикла;	
			Если ОшибкаФинансированияСтроки Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru = 'У получателя %1 финансирование не совпадает с ведомостью'"), СтрокаСостава.ФизическоеЛицо), 
					ДокументОбъект, 
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Состав", СтрокаСостава.НомерСтроки, "ФизическоеЛицо"),,
					Отказ);
			КонецЕсли;	
		КонецЦикла;
		
	Иначе	
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("СтатьяФинансирования");
		ИсключаемыеРеквизиты.Добавить("СтатьяРасходов");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	КонецЕсли;	
	
	Для Каждого СтрокаСостава Из ДокументОбъект.Состав Цикл
		ЗарплатаСтроки = ДокументОбъект.Выплаты.Выгрузить(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки), "КВыплате");
		Если ЗарплатаСтроки.Итог("КВыплате") < 0 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'У получателя %1 указана отрицательная сумма к выплате'"), СтрокаСостава.ФизическоеЛицо), 
				ДокументОбъект, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Состав", СтрокаСостава.НомерСтроки, "ФизическоеЛицо"),,
				Отказ);
		КонецЕсли;	
	КонецЦикла;
	
	Если НачалоДня(ДокументОбъект.Дата) > ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(ДокументОбъект) Тогда
		ТекстОшибки = НСтр("ru = 'Дата выплаты не может быть меньше даты документа'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументОбъект, "ДатаВыплаты",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьВТСписокСотрудниковПоТаблицеВыплат(МенеджерВременныхТаблиц, ТаблицаВыплат, Ведомость)

	КолонкиГруппировокСписка =
		"ФизическоеЛицо, 
		|ДокументОснование, 
		|СтатьяФинансирования, 
		|СтатьяРасходов, 
		|ВидДоходаИсполнительногоПроизводства";
	
	СписокСотрудников = Ведомость.Выплаты.ВыгрузитьКолонки(СтрШаблон("%1, КВыплате", КолонкиГруппировокСписка));
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТаблицаВыплат, СписокСотрудников);
	СписокСотрудников.Свернуть(КолонкиГруппировокСписка, "КВыплате");
	СписокСотрудников.Колонки.КВыплате.Имя = "СуммаВыплаты";
	СписокСотрудников.Колонки.Добавить("ОкончательныйРасчет", Новый ОписаниеТипов("Булево"));
	СписокСотрудников.ЗаполнитьЗначения(Ложь, "ОкончательныйРасчет");
	
	ОписательВТ = 
		ВзаиморасчетыПоПрочимДоходам.ОписательВременныхТаблицДляСоздатьВТСостояниеВыплат(
			МенеджерВременныхТаблиц, СписокСотрудников);
	ВзаиморасчетыПоПрочимДоходам.СоздатьВТСостояниеВыплат(
		ОписательВТ, Истина, 
		Ведомость.Организация, Ведомость.ПериодРегистрации, 
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ведомость.Ссылка), 
		"ВТСписокСотрудников");
	
КонецПроцедуры

Процедура ПередЗаписью(ДокументОбъект, Отказ, РежимЗаписи) Экспорт
	
	Если ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(ДокументОбъект.Ссылка) Тогда
		
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='По ведомости %1 номер %2 от %3 произведены оплаты, изменения запрещены'"), 
				?(ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВедомостьПрочихДоходовВКассу"), НСтр("ru='в кассу'"), НСтр("ru='в банк'")), 
				ДокументОбъект.Номер, 
				Формат(ДокументОбъект.Дата, "ДЛФ=D"));
		ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке, ДокументОбъект);
		
		Отказ = Истина;
		
		Возврат
		
	КонецЕсли;
	
	// Очистка табличной части Зарплата от строк, не имеющих "родителя" в ТЧ Состав
	
	ПоляСостава	= Новый Массив;
	Для Каждого РеквизитСостава Из ДокументОбъект.Метаданные().ТабличныеЧасти.Состав.Реквизиты  Цикл
		ПоляСостава.Добавить(РеквизитСостава.Имя);
	КонецЦикла;	
	СписокСвойств = СтрСоединить(ПоляСостава, ", ");
	
	ЛишниеСтроки = Новый Массив;
	Для Каждого СтрокаВыплаты Из ДокументОбъект.Выплаты Цикл
		СтрокаСостава = ДокументОбъект.Состав.Найти(СтрокаВыплаты.ИдентификаторСтроки, "ИдентификаторСтроки");
		Если СтрокаСостава = Неопределено 
			Или СтрокаСостава.ФизическоеЛицо <> СтрокаВыплаты.ФизическоеЛицо Тогда
			ЛишниеСтроки.Добавить(СтрокаВыплаты);
		КонецЕсли	
	КонецЦикла;
	Для Каждого ЛишняяСтрока Из ЛишниеСтроки Цикл
		ДокументОбъект.Выплаты.Удалить(ЛишняяСтрока);
	КонецЦикла;	
	
	// Очистка табличной части НДФЛ от строк, не имеющих "родителя" в ТЧ Состав
	// Синхронизация общих реквизитов табличных частей Состав и НДФЛ.
	ЛишниеСтроки = Новый Массив;
	Для Каждого СтрокаНДФЛ Из ДокументОбъект.НДФЛ Цикл
		СтрокаСостава = ДокументОбъект.Состав.Найти(СтрокаНДФЛ.ИдентификаторСтроки, "ИдентификаторСтроки");
		Если СтрокаСостава = Неопределено Тогда
			ЛишниеСтроки.Добавить(СтрокаНДФЛ);
		Иначе	
			ЗаполнитьЗначенияСвойств(СтрокаНДФЛ, СтрокаСостава, "ФизическоеЛицо")
		КонецЕсли	
	КонецЦикла;
	Для Каждого ЛишняяСтрока Из ЛишниеСтроки Цикл
		ДокументОбъект.НДФЛ.Удалить(ЛишняяСтрока);
	КонецЦикла;	
	
	// Посчитать сумму документа и записать ее в соответствующий реквизит шапки.
	ДокументОбъект.СуммаПоДокументу = ДокументОбъект.Выплаты.Итог("КВыплате");
	
КонецПроцедуры

Процедура ОбновитьНДФЛ(Ведомость, Физлица) Экспорт
	
	// Выплаты физических лиц, для которых обновляется налог
	СтрокиВыплатФизлиц = Новый Массив;
	Для Каждого СтрокаВыплаты Из Ведомость.Выплаты Цикл
		Если Физлица.Найти(СтрокаВыплаты.ФизическоеЛицо) <> Неопределено Тогда
			СтрокиВыплатФизлиц.Добавить(СтрокаВыплаты);
		КонецЕсли
	КонецЦикла;	
	ТаблицаВыплат = 
		Ведомость.Выплаты.Выгрузить(
			СтрокиВыплатФизлиц,
			"ФизическоеЛицо, 
			|ДокументОснование, 
			|СтатьяФинансирования, 
			|СтатьяРасходов, 
			|ВидДоходаИсполнительногоПроизводства,
			|КВыплате");
	
	// Получаем НДФЛ к удержанию (перечислению)
	НДФЛ = НДФЛПоТаблицеВыплат(Ведомость, ТаблицаВыплат);
	
	ПараметрыОтбораНДФЛ = Новый Структура("ФизическоеЛицо");
	Для Каждого Физлицо Из Физлица Цикл
		
		ПараметрыОтбораНДФЛ.ФизическоеЛицо = ФизЛицо;
		
		// Определяем идентификатор строки состава, к которой будет привязан НДФЛ физического лица.
		ИдентификаторСтроки = Неопределено;
		СтрокаНДФЛ = Ведомость.НДФЛ.Найти(Физлицо, "ФизическоеЛицо");
		Если СтрокаНДФЛ = Неопределено Тогда
			СтрокаСостава = Ведомость.Состав.Найти(Физлицо, "ФизическоеЛицо");
			Если СтрокаСостава <> Неопределено Тогда
				ИдентификаторСтроки = СтрокаСостава.ИдентификаторСтроки
			КонецЕсли	
		Иначе
			ИдентификаторСтроки = СтрокаНДФЛ.ИдентификаторСтроки
		КонецЕсли;	
		
		Если ИдентификаторСтроки = Неопределено Тогда
			Продолжить
		КонецЕсли;	
		
		// Удаляем старый НДФЛ физического лица
		УдаляемыеСтроки = Ведомость.НДФЛ.НайтиСтроки(ПараметрыОтбораНДФЛ);
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			Ведомость.НДФЛ.Удалить(УдаляемаяСтрока)
		КонецЦикла;
		
		// Помещаем новый НДФЛ физического лица, привязывая его к строке состава
		НДФЛФизлица = НДФЛ.НайтиСтроки(ПараметрыОтбораНДФЛ);
		Для Каждого СтрокаНДФЛФизлица Из НДФЛФизлица Цикл
			ДобавляемаяСтрока = Ведомость.НДФЛ.Добавить();
			ЗаполнитьЗначенияСвойств(ДобавляемаяСтрока, СтрокаНДФЛФизлица);
			ДобавляемаяСтрока.ИдентификаторСтроки = ИдентификаторСтроки;
		КонецЦикла	
	КонецЦикла;
	
КонецПроцедуры

Функция НДФЛПоТаблицеВыплат(Ведомость, ТаблицаВыплат)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТСписокСотрудниковПоТаблицеВыплат(МенеджерВременныхТаблиц, ТаблицаВыплат, Ведомость);
	
	НДФЛ = 	
		УчетНДФЛ.РассчитатьУдержанныеНалоги(
			Ведомость.Ссылка, 
			Ведомость.Организация, 
			Ведомость.Дата, 
			МенеджерВременныхТаблиц, 
			Ведомость.ПериодРегистрации,
			Ложь,
			ТаблицаВыплат);
			
	ПараметрыРаспределения = ОтражениеЗарплатыВУчете.НовоеОписаниеПараметровРаспределенияНалогиКУдержанию();
	ПараметрыРаспределения.НДФЛПоСотрудникам      = Ложь;
	ПараметрыРаспределения.ИсключаемыйРегистратор = Ведомость.Ссылка;
	ПараметрыРаспределения.ДатаОперации           = Ведомость.Дата;
	ПараметрыРаспределения.ТаблицаВыплат          = ТаблицаВыплат;
	ЗаполнитьЗначенияСвойств(ПараметрыРаспределения.Финансирование, Ведомость);
	ВидыДохода = ТаблицаВыплат.Скопировать(, "ВидДоходаИсполнительногоПроизводства");
	ВидыДохода.Свернуть("ВидДоходаИсполнительногоПроизводства");
	ПараметрыРаспределения.Финансирование.ВидДоходаИсполнительногоПроизводства = 
		ВидыДохода.ВыгрузитьКолонку("ВидДоходаИсполнительногоПроизводства");
	
	НДФЛПоСтатьям = ОтражениеЗарплатыВУчете.НалогиКУдержаниюПоСтатьям(НДФЛ, ПараметрыРаспределения);
	
	// Сортируем НДФЛ для воспроизводимости результатов.
	КолонкиСортировки = 
	"ФизическоеЛицо,
	|МесяцНалоговогоПериода,
	|КатегорияДохода,
	|СтавкаНалогообложенияРезидента,
	|КодДохода,
	|Сумма,
	|СуммаСПревышения,
	|Подразделение,
	|ДокументОснование,
	|РегистрацияВНалоговомОргане,
	|СтатьяФинансирования,
	|СтатьяРасходов";
	НДФЛПоСтатьям.Сортировать(КолонкиСортировки, Новый СравнениеЗначений);
	
	Возврат НДФЛПоСтатьям;
	
КонецФункции

Процедура УстановитьВзыскания(Ведомость, ТаблицаВыплат) Экспорт
	
	// Получаем суммы, взысканные с указанных выплат
	Взыскания = ВзысканияПоИсполнительнымДокументам(ТаблицаВыплат);
	
	// Переносим взыскания в ведомость, связывая с первой строкой состава этого физлица.
	Для Каждого Физлицо Из ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаВыплат, "ФизическоеЛицо", Истина) Цикл
		СтрокаСостава  = Ведомость.Состав.Найти(Физлицо, "ФизическоеЛицо");
		Если СтрокаСостава = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
		Взыскание = Взыскания.Найти(Физлицо, "ФизическоеЛицо");
		Если Взыскание = Неопределено Тогда
			СтрокаСостава.ВзысканнаяСумма = 0;
		Иначе	
			СтрокаСостава.ВзысканнаяСумма = Взыскание.Сумма
		КонецЕсли	
	КонецЦикла;
	
КонецПроцедуры	

Функция ВзысканияПоИсполнительнымДокументам(ТаблицаВыплат)
	
	Разрезы  = "ФизическоеЛицо, ДокументОснование";
	КВыплате = "КВыплате";
	
	Выплаты = ТаблицаВыплат.Скопировать(, Разрезы +","+ КВыплате);
	Выплаты.Свернуть(Разрезы, КВыплате);
	
	// Отбрасываем задолженности (выплаты с отрицательной суммой)
	Задолженности = Новый Массив;
	Для Каждого Выплата Из Выплаты Цикл
		Если Выплата.КВыплате < 0 Тогда
			Задолженности.Добавить(Выплата)
		КонецЕсли	
	КонецЦикла;
	Для Каждого Задолженность Из Задолженности Цикл
		Выплаты.Удалить(Задолженность)
	КонецЦикла;	
		
	Взыскания = ИсполнительныеЛисты.УдержанныеСуммыФизическихЛицПоДокументам(Выплаты);
	
	Взыскания.Свернуть("ФизическоеЛицо", "Сумма");
	
	Возврат Взыскания
	
КонецФункции

Процедура ОбработкаПроведения(Ведомость, Отказ) Экспорт
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(Ведомость);
	
	ОписаниеКолонокВыплаты = НовоеОписаниеСоответствияКолонокДляТаблицыВыплаченногоДохода();
	ОписаниеКолонокВыплаты.Сумма = "КВыплате";
	
	Выплаты = НоваяТаблицаВыплаченногоДоходаПоТабличнойЧасти(
		Ведомость.Выплаты,
		ОписаниеКолонокВыплаты);
		
	ВзаиморасчетыПоПрочимДоходам.ЗарегистрироватьВыплаченныйДоход(
		Ведомость.Движения, 
		Отказ, 
		Ведомость.Организация, 
		Ведомость.ПериодРегистрации, 
		Выплаты,
		Перечисления.СпособыВыплатыПрочихДоходов.СпособРасчетов(Ведомость.СпособВыплаты));
	
	// Регистрация выдачи зарплаты.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		
		ЗарегистрироватьУдержанныеНалоги(Ведомость, Отказ);
		
		Если Ведомость.ПеречислениеНДФЛВыполнено Тогда
			ЗарегистрироватьПеречислениеНДФЛ(Ведомость, Отказ);
		КонецЕсли;
		
	КонецЕсли;

	
	Для Каждого НаборЗаписей Из Ведомость.Движения Цикл
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Записывать = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Создает новую таблицу значений для данных о выплаченных доходах по переданной табличной части.
//
// Параметры:
//		ТабличнаяЧасть - ТабличнаяЧасть - данные о выплаченных доходах.
//		ОписаниеСоответствияКолонок - Структура - см. НовоеОписаниеСоответствияКолонокДляТаблицыВыплаченнойЗарплаты.
//
// Возвращаемое значение:
//		ТаблицаЗначений - см. НоваяТаблицаВыплаченногоДохода().
//
Функция НоваяТаблицаВыплаченногоДоходаПоТабличнойЧасти(ТабличнаяЧасть, ОписаниеСоответствияКолонок)
	
	КолонкиТаблицыВыплаченногоДохода = КолонкиТаблицыВыплаченногоДохода();
	
	КолонкиВыгружаемые  = Новый Массив;
	КолонкиГруппировок  = Новый Массив;
	КолонкиСуммирования = Новый Массив;
	
	Для Каждого ОписаниеКолонки Из ОписаниеСоответствияКолонок Цикл
		Если КолонкиТаблицыВыплаченногоДохода.Все.Найти(ОписаниеКолонки.Ключ) = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'НоваяТаблицаВыплаченногоДоходаПоТабличнойЧасти: недопустимое имя колонки таблицы выплаченной зарплаты в описании соответствия колонок'")
		КонецЕсли;	
		КолонкиВыгружаемые.Добавить(ОписаниеКолонки.Значение);
		Если КолонкиТаблицыВыплаченногоДохода.Группировок.Найти(ОписаниеКолонки.Ключ) <> Неопределено Тогда
			КолонкиГруппировок.Добавить(ОписаниеКолонки.Значение);
		ИначеЕсли КолонкиТаблицыВыплаченногоДохода.Суммирования.Найти(ОписаниеКолонки.Ключ) <> Неопределено Тогда
			КолонкиСуммирования.Добавить(ОписаниеКолонки.Значение);
		КонецЕсли	
	КонецЦикла;	
	
	ТаблицаВыплаченногоДохода = ТабличнаяЧасть.Выгрузить(, СтрСоединить(КолонкиВыгружаемые, ", "));
	ТаблицаВыплаченногоДохода.Свернуть(СтрСоединить(КолонкиГруппировок, ", "), СтрСоединить(КолонкиСуммирования, ", "));
	
	Для Каждого ОписаниеКолонки Из ОписаниеСоответствияКолонок Цикл
		ТаблицаВыплаченногоДохода.Колонки[ОписаниеКолонки.Значение].Имя = ОписаниеКолонки.Ключ
	КонецЦикла;
	
	Возврат ТаблицаВыплаченногоДохода
	
КонецФункции

Функция КолонкиТаблицыВыплаченногоДохода()
	
	Колонки = Новый Структура;
	Колонки.Вставить("Все", Новый Массив);
	Колонки.Вставить("Группировок",  Новый Массив);
	Колонки.Вставить("Суммирования", Новый Массив);
	
	Для Каждого Колонка Из ВзаиморасчетыПоПрочимДоходам.НоваяТаблицаВыплаченногоДохода().Колонки Цикл
		Колонки.Все.Добавить(Колонка.Имя);
		Если Колонка.ТипЗначения.СодержитТип(Тип("Число")) Тогда
			Колонки.Суммирования.Добавить(Колонка.Имя)
		Иначе	
			Колонки.Группировок.Добавить(Колонка.Имя)
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Колонки
	
КонецФункции

// Создает описание соответствия колонок входной таблицы колонкам таблицы выплаченного дохода.
// Предназначена для использования в функциях- конструкторах. 
// см. НоваяТаблицаВыплаченногоДохода(), см. НоваяТаблицаВыплаченнойЗарплатыПоТабличнойЧасти().
//
// Возвращаемое значение:
//		Структура - Ключ содержит имя колонки таблицы выплаченной зарплаты, значение - имя колонки входной таблицы.
//
Функция НовоеОписаниеСоответствияКолонокДляТаблицыВыплаченногоДохода()
	
	ОписаниеСоответствияКолонок = Новый Структура;
	
	Для Каждого Колонка Из ВзаиморасчетыПоПрочимДоходам.НоваяТаблицаВыплаченногоДохода().Колонки Цикл
		ОписаниеСоответствияКолонок.Вставить(Колонка.Имя, Колонка.Имя)
	КонецЦикла;
	
	Возврат ОписаниеСоответствияКолонок
	
КонецФункции

Процедура ЗарегистрироватьУдержанныеНалоги(Ведомость, Отказ = Ложь)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТСписокСотрудниковПоТаблицеВыплат(МенеджерВременныхТаблиц, Ведомость.Выплаты, Ведомость);
	
	ЗапросНДФЛ = Новый Запрос;
	ЗапросНДФЛ.УстановитьПараметр("Ссылка", Ведомость.Ссылка);
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	// ФизическоеЛицо, СтавкаНалогообложенияРезидента, МесяцНалоговогоПериода, Подразделение, КодДохода, РегистрацияВНалоговомОргане, ВключатьВДекларациюПоНалогуНаПрибыль, ДокументОснование и др. поля
	|	*
	|ИЗ
	|	#ВедомостьНДФЛ КАК ВедомостьНДФЛ
	|ГДЕ
	|	ВедомостьНДФЛ.Ссылка = &Ссылка";
	ЗапросНДФЛ.Текст = СтрЗаменить(ТекстЗапроса, "#ВедомостьНДФЛ", Ведомость.Метаданные().ПолноеИмя() + ".НДФЛ");
	
	УчетФактическиПолученныхДоходов.СоздатьВТНалогУдержанный(МенеджерВременныхТаблиц, ЗапросНДФЛ, ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(Ведомость)); 
	
	ЗарегистрироватьУдержанныйНалогПоВременнымТаблицам(Ведомость, Отказ, Ведомость.Организация, Ведомость.Дата, ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(Ведомость), МенеджерВременныхТаблиц);
	
КонецПроцедуры

// Выполняет регистрацию удержанного налога
// Параметры:
//		Регистратор - ДокументОбъект
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - должен содержать временные таблицы 
//      	ВТСписокСотрудников и ВТНалогУдержанный, см. УчетНДФЛ.
//
Процедура ЗарегистрироватьУдержанныйНалогПоВременнымТаблицам(Регистратор, Отказ, Организация, ДатаОперации, ДатаВыплаты, МенеджерВременныхТаблиц)
	
	// Получение базы для распределения НДФЛ к перечислению из временной таблицы ВТНалогУдержанный,
	// всегда выполняется до вызова методов подсистемы НДФЛ.
	ДанныеДляДополнения = ОтражениеЗарплатыВУчете.ДанныеДляДополненияНДФЛУдержанногоСтатьями(МенеджерВременныхТаблиц);
	
	УчетФактическиПолученныхДоходов.ЗарегистрироватьНовуюДатуПолученияДохода(Регистратор.Ссылка, Регистратор.Движения, МенеджерВременныхТаблиц, ДатаВыплаты, ДатаОперации, Отказ, Истина);
	УчетНДФЛ.ВписатьСуммыВыплаченногоДоходаВУдержанныеНалоги(МенеджерВременныхТаблиц, Регистратор.Ссылка, ДатаВыплаты);	
	УчетНДФЛ.СформироватьУдержанныйНалогПоВременнойТаблице(Регистратор.Движения, Отказ, Организация, ДатаВыплаты, МенеджерВременныхТаблиц, , Истина);
	УчетНДФЛ.СформироватьНДФЛКПеречислению(Регистратор.Движения, Отказ);
	ОтражениеЗарплатыВУчете.ДополнитьНДФЛКПеречислениюСведениямиОРаспределенииПоСтатьям(Регистратор.Движения, ДанныеДляДополнения);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.РасчетыСБюджетомПоНДФЛ") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетыСБюджетомПоНДФЛ");
		Модуль.РасчетыСБюджетомПоНДФЛЗарегистрироватьНДФЛКПеречислению(Регистратор.Движения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьПеречислениеНДФЛ(Ведомость, Отказ = Ложь)
	
	УчетНДФЛРасширенный.ЗарегистрироватьНДФЛПеречисленныйПоПлатежномуДокументу(Ведомость.Движения, Отказ, Ведомость.Организация, ВедомостьПрочихДоходовКлиентСервер.ДатаВыплаты(Ведомость), Ведомость.ПеречислениеНДФЛРеквизиты);

	УчетНДФЛ.СформироватьНДФЛПеречисленный(Ведомость.Движения, Отказ);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.РасчетыСБюджетомПоНДФЛ") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетыСБюджетомПоНДФЛ");
		Модуль.РасчетыСБюджетомПоНДФЛЗарегистрироватьНДФЛПеречисленный(Ведомость.Движения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(Ведомость, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ЭтоДанныеЗаполненияВедомости(ДанныеЗаполнения) Тогда
		
		ЗаполнитьЗначенияСвойств(Ведомость, ДанныеЗаполнения.Шапка);
		Ведомость.Выплаты.Загрузить(ДанныеЗаполнения.Выплаты);
		
		СведенияОПодписях = ПодписиДокументов.СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(
			Ведомость.Метаданные(), 
			Ведомость.Организация);	
		ЗаполнитьЗначенияСвойств(Ведомость, СведенияОПодписях);
		
		Для Каждого Основание Из ДанныеЗаполнения.Основания Цикл
			СтрокаОснования = Ведомость.Основания.Добавить();
			СтрокаОснования.Документ = Основание;
		КонецЦикла;
		
		СтандартнаяОбработка = Ложь
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, используемую для заполнения ведомостей на выплату прочих доходов.
//
Функция ДанныеЗаполненияВедомости() Экспорт
	
	Шапка = Новый Структура;
	Шапка.Вставить("Дата");
	Шапка.Вставить("Организация");
	Шапка.Вставить("ПериодРегистрации");
	Шапка.Вставить("СпособВыплаты");
	Шапка.Вставить("ЗарплатныйПроект");
	
	Выплаты = Новый ТаблицаЗначений;
	Выплаты.Колонки.Добавить("ФизическоеЛицо");
	Выплаты.Колонки.Добавить("КВыплате");
	
	ДанныеЗаполненияВедомости = Новый Структура;
	
	ДанныеЗаполненияВедомости.Вставить("ЭтоДанныеЗаполненияВедомостиПрочихДоходов");
	ДанныеЗаполненияВедомости.Вставить("Шапка",		Шапка);
	ДанныеЗаполненияВедомости.Вставить("Выплаты",	Выплаты);
	
	ДанныеЗаполненияВедомости.Шапка.Вставить("ПеречислениеНДФЛВыполнено", Не ПолучитьФункциональнуюОпцию("ВестиРасчетыСБюджетомПоНДФЛ"));
	ДанныеЗаполненияВедомости.Шапка.Вставить("ПеречислениеНДФЛРеквизиты", "");
	
	ДанныеЗаполненияВедомости.Вставить("Основания", Новый Массив);

	Возврат ДанныеЗаполненияВедомости
	
КонецФункции

// Проверяет, являются ли переданные данные структурой, используемой для заполнения документа
// (см. функцию ДанныеЗаполнения).
//
Функция ЭтоДанныеЗаполненияВедомости(ДанныеЗаполнения)
	Возврат ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЭтоДанныеЗаполненияВедомостиПрочихДоходов") 
КонецФункции	

Функция ТекстЗапросаДанныеДляОплаты(ИмяТипа, ИмяПараметраВедомости = "Ведомости", ИмяПараметраФизическиеЛица = "ФизическиеЛица") Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВедомостьВыплаты.Ссылка КАК Ссылка,
	|	ВедомостьВыплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СУММА(ВедомостьВыплаты.КВыплате) КАК КВыплате,
	|	0 КАК ВзысканнаяСумма,
	|	0 КАК КомпенсацияЗаЗадержкуЗарплаты
	|ИЗ
	|	#ВедомостьВыплаты КАК ВедомостьВыплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	ВедомостьВыплаты.Ссылка,
	|	ВедомостьВыплаты.ФизическоеЛицо";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ВедомостьВыплаты", ИмяТипа + ".Выплаты");
	
	Схема = Новый СхемаЗапроса();
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	
	Если ЗначениеЗаполнено(ИмяПараметраВедомости) Тогда
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(СтрШаблон("ВедомостьВыплаты.Ссылка В(&%1)", ИмяПараметраВедомости));
	КонецЕсли;	
	Если ЗначениеЗаполнено(ИмяПараметраФизическиеЛица) Тогда
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(СтрШаблон("ВедомостьВыплаты.ФизическоеЛицо В (&%1)", ИмяПараметраФизическиеЛица));
	КонецЕсли;	
	
	ТекстЗапроса = Схема.ПолучитьТекстЗапроса();
	
	Возврат ТекстЗапроса;
	
КонецФункции	

Функция ТекстЗапросаДанныеДляОплатыБезналично(
	ИмяТипа, 
	ИмяПараметраВедомости = "Ведомости", 
	ИмяПараметраФизическиеЛица = "ФизическиеЛица") Экспорт
	
	ТекстЗапроса = 		
	"ВЫБРАТЬ
	|	ВедомостьСостав.Ссылка КАК Ссылка,
	|	ВедомостьСостав.ФизическоеЛицо КАК ФизическоеЛицо,
	|	0 КАК КВыплате,
	|	СУММА(ВедомостьСостав.ВзысканнаяСумма) КАК ВзысканнаяСумма,
	|	0 КАК КомпенсацияЗаЗадержкуЗарплаты
	|ИЗ
	|	#ВедомостьСостав КАК ВедомостьСостав
	|
	|СГРУППИРОВАТЬ ПО
	|	ВедомостьСостав.Ссылка,
	|	ВедомостьСостав.ФизическоеЛицо";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ВедомостьСостав",	ИмяТипа + ".Состав");
	
	Схема = Новый СхемаЗапроса();
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	
	Если ЗначениеЗаполнено(ИмяПараметраВедомости) Тогда
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(
			СтрШаблон("ВедомостьСостав.Ссылка В (&%1)", ИмяПараметраВедомости));
	КонецЕсли;	
	Если ЗначениеЗаполнено(ИмяПараметраФизическиеЛица) Тогда
		Схема.ПакетЗапросов[0].Операторы[0].Отбор.Добавить(
			СтрШаблон("ВедомостьСостав.ФизическоеЛицо В (&%1)", ИмяПараметраФизическиеЛица));
	КонецЕсли;	
	
	ТекстыПодзапросов = Новый Массив(2);
	ТекстыПодзапросов[0] = Схема.ПолучитьТекстЗапроса();
	ТекстыПодзапросов[1] = ТекстЗапросаДанныеДляОплаты(ИмяТипа, ИмяПараметраВедомости, ИмяПараметраФизическиеЛица);
			
	ТекстЗапросаДанныеДляОплаты	=
		СтрСоединить(
			ТекстыПодзапросов,
			Символы.ПС + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС + Символы.ПС);

	Возврат ТекстЗапросаДанныеДляОплаты		
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// Обслуживание обработки ПлатежиПоРезультатамРасчетаЗарплаты.

// Возвращает список проведенных ведомостей, у которых сумма к выплате не равна нулю.
//
// Параметры:
//		Организации - Массив - содержит ссылки на организации (СправочникСсылка.Организации)
//								по которым получается список ведомостей.
//		МесяцНачисления - Дата 
//		ШаблонСпискаВедомостей - ТаблицаЗначений, пустая таблица, используется как шаблон для выходных данных.
//
// Возвращаемое значение:
//		Структура
//			*Касса - таблица значений, колонки таблицы соответствуют таблице ШаблонСпискаВедомостей
//				** Организация 		- СправочникСсылка.Организации
//				** СпособВыплаты 	- ПеречислениеСсылка.СпособыВыплатыПрочихДоходов
//				** Сумма 			- Число
//				** Ведомость 		- Строка
//				** СтатьяФинансирования - СправочникСсылка.СтатьиФинансированияЗарплата
//				** СтатьяРасходов 		- СправочникСсылка.СтатьиРасходовЗарплата
//			*Банк - таблица значений
//				** Организация 		- СправочникСсылка.Организации
//				** МестоВыплаты 	- Строка или СправочникСсылка.ЗарплатныеПроекты или СправочникСсылка.КлассификаторБанков
//				** СпособВыплаты 	- ПеречислениеСсылка.СпособыВыплатыПрочихДоходов
//				** Сумма 			- Число
//				** Ведомость 		- Строка
//				** СтатьяФинансирования - СправочникСсылка.СтатьиФинансированияЗарплата
//				** СтатьяРасходов 		- СправочникСсылка.СтатьиРасходовЗарплата
//
Функция ВедомостиПоПрочимДоходамЗаМесяцДляПлатежейПоРезультатамРасчета(Организации, МесяцНачисления, ШаблонСпискаВедомостей) Экспорт
	
	ВедомостиЗаМесяц = Новый Структура("Касса,Банк");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.УстановитьПараметр("ПериодРегистрации", МесяцНачисления);
	Запрос.УстановитьПараметр("ЗарплатныйПроектНеУказан", "<" + НСтр("ru = 'Зарплатный проект не указан'") + ">");
	Запрос.УстановитьПараметр("БанкНеУказан", "<" + НСтр("ru = 'Банк не указан'") + ">");
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ведомость.Организация КАК Организация,
	|	Ведомость.СпособВыплаты КАК СпособВыплаты,
	|	Ведомость.СуммаПоДокументу КАК Сумма,
	|	ПРЕДСТАВЛЕНИЕ(Ведомость.Ссылка) КАК Ведомость,
	|	Ведомость.Дата КАК Дата,
	|	Ведомость.Ссылка КАК Ссылка,
	|	Ведомость.СтатьяФинансирования КАК СтатьяФинансирования,
	|	Ведомость.СтатьяРасходов КАК СтатьяРасходов
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВКассу КАК Ведомость
	|ГДЕ
	|	Ведомость.ПериодРегистрации = &ПериодРегистрации
	|	И Ведомость.Организация В(&Организации)
	|	И Ведомость.Проведен
	|	И Ведомость.СуммаПоДокументу <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация,
	|	СтатьяФинансирования,
	|	СтатьяРасходов,
	|	Дата,
	|	СпособВыплаты,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ведомость.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА Ведомость.ЗарплатныйПроект = ЗНАЧЕНИЕ(Справочник.ЗарплатныеПроекты.ПустаяСсылка)
	|			ТОГДА &ЗарплатныйПроектНеУказан
	|		ИНАЧЕ Ведомость.ЗарплатныйПроект
	|	КОНЕЦ КАК МестоВыплаты,
	|	Ведомость.СпособВыплаты КАК СпособВыплаты,
	|	Ведомость.СуммаПоДокументу КАК Сумма,
	|	ПРЕДСТАВЛЕНИЕ(Ведомость.Ссылка) КАК Ведомость,
	|	Ведомость.Дата КАК Дата,
	|	Ведомость.Ссылка КАК Ссылка,
	|	Ведомость.СтатьяФинансирования КАК СтатьяФинансирования,
	|	Ведомость.СтатьяРасходов КАК СтатьяРасходов
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк КАК Ведомость
	|ГДЕ
	|	Ведомость.ПериодРегистрации = &ПериодРегистрации
	|	И Ведомость.Организация В(&Организации)
	|	И Ведомость.Проведен
	|	И Ведомость.СуммаПоДокументу <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Ведомость.Организация,
	|	ВЫБОР
	|		КОГДА Ведомость.Банк = ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|			ТОГДА &БанкНеУказан
	|		ИНАЧЕ Ведомость.Банк
	|	КОНЕЦ,
	|	Ведомость.Ссылка.СпособВыплаты,
	|	Ведомость.СуммаПоДокументу,
	|	ПРЕДСТАВЛЕНИЕ(Ведомость.Ссылка),
	|	Ведомость.Дата,
	|	Ведомость.Ссылка,
	|	Ведомость.СтатьяФинансирования,
	|	Ведомость.СтатьяРасходов
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовПеречислением КАК Ведомость
	|ГДЕ
	|	Ведомость.ПериодРегистрации = &ПериодРегистрации
	|	И Ведомость.Организация В(&Организации)
	|	И Ведомость.Проведен
	|	И Ведомость.СуммаПоДокументу <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация,
	|	СтатьяФинансирования,
	|	СтатьяРасходов,
	|	Дата,
	|	МестоВыплаты,
	|	СпособВыплаты,
	|	Ссылка";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВедомостиКасса = ШаблонСпискаВедомостей.СкопироватьКолонки();
	Выборка = РезультатЗапроса[0].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ВедомостиКасса.Добавить(), Выборка);
	КонецЦикла;
	ВедомостиЗаМесяц.Касса = ВедомостиКасса;
	
	ВедомостиБанк = ШаблонСпискаВедомостей.СкопироватьКолонки();
	Выборка = РезультатЗапроса[1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ВедомостиБанк.Добавить(), Выборка);
	КонецЦикла;
	ВедомостиЗаМесяц.Банк = ВедомостиБанк;
	
	Возврат ВедомостиЗаМесяц;
	
КонецФункции

#КонецОбласти