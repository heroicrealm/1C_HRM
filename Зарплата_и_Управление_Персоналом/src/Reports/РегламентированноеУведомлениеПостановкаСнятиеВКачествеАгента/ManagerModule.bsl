#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2017_1";
	Стр.КНД = "1111620";
	Стр.ВерсияФормата = "5.01";
	
	Возврат Результат;
КонецФункции

Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента.Форма.Форма2017_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2017_1";
	Стр.ОписаниеФормы = "Форму уведомления о контролируемых иностранных компаниях в соответствии с приказом ФНС России от 20.03.2017 № ММВ-7-14/222@";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2017_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2017_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2017_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2017_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2017_1" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2017_1(УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(СведенияОтправки)
	Префикс = "UT_POSTSNNALAG";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2017_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		Данные.Объект.ИмяФормы, ТаблицаОшибок, ПолучитьТаблицуФорм());
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если Не ЗначениеЗаполнено(Титульная.ИННЮЛ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН на титульном листе", "Титульная", "ИННЮЛ"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.ИННЮЛ)) <> 10 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН на титульном листе", "Титульная", "ИННЮЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КПП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан КПП на титульном листе", "Титульная", "КПП"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.КПП)) <> 9 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП на титульном листе", "Титульная", "КПП"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ОГРН) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ОГРН на титульном листе", "Титульная", "ОГРН"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.ОГРН)) <> 13 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ОГРН на титульном листе", "Титульная", "ОГРН"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "Титульная", "КодНО"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.КодНО)) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации", "Титульная", "НаимОрг"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПрПодп) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПрПодп"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КоличНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано количество налоговых органов", "Титульная", "КоличНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПрПост) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак", "Титульная", "ПрПост"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.Фамилия) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана фамилия подписанта", "Титульная", "Фамилия"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Имя) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано имя подписанта", "Титульная", "Имя"));
	КонецЕсли;
	Если Титульная.ПрПодп = "2" И (Не ЗначениеЗаполнено(Титульная.НаимДок)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ подписанта", "Титульная", "НаимДок"));
	КонецЕсли;
	
	ПрПост = Титульная.ПрПост;
	Для Каждого ДопЛист Из Данные.ДанныеМногостраничныхРазделов.СведМО Цикл 
		ДопЛистЗначение = ДопЛист.Значение;
		Если Не ЗначениеЗаполнено(ДопЛистЗначение.КодНО) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код налогового органа на доп.странице", "СведМО", "КодНО", ДопЛистЗначение.УИД));
		ИначеЕсли СтрДлина(СокрЛП(ДопЛистЗначение.КодНО)) <> 4 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан код налогового органа на доп.странице", "СведМО", "КодНО", ДопЛистЗначение.УИД));
		КонецЕсли;
		Если (ПрПост = "2" Или ПрПост = "3") И (Не ЗначениеЗаполнено(ДопЛистЗначение.КПП)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан КПП на доп.странице", "СведМО", "КПП", ДопЛистЗначение.УИД));
		ИначеЕсли (ПрПост = "2" Или ПрПост = "3") И (СтрДлина(СокрЛП(ДопЛистЗначение.КПП)) <> 9) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП на доп.странице", "СведМО", "КПП", ДопЛистЗначение.УИД));
		КонецЕсли;
		Если ПрПост = "3" И Не ЗначениеЗаполнено(ДопЛистЗначение.ПрИзм) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак на доп.странице", "СведМО", "ПрИзм", ДопЛистЗначение.УИД));
		КонецЕсли;
		
		Если ПрПост = "3" Или ПрПост = "1" Тогда 
			ДопСтроки = Данные.ДанныеДопСтрокБД.МнгСтр.НайтиСтроки(Новый Структура("УИД", ДопЛистЗначение.УИД));
			ИндДС = 0;
			Для Каждого ДопСтрока Из ДопСтроки Цикл 
				ИндДС = ИндДС + 1;
				Если Не ЗначениеЗаполнено(ДопСтрока.ОКТМО) Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано ОКТМО", "СведМО", "ОКТМО___" + ИндДС, ДопЛистЗначение.УИД));
				ИначеЕсли СтрДлина(СокрЛП(ДопСтрока.ОКТМО)) <> 8 И СтрДлина(СокрЛП(ДопСтрока.ОКТМО)) <> 11 Тогда 
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указано ОКТМО", "СведМО", "ОКТМО___" + ИндДС, ДопЛистЗначение.УИД));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаДатВУведомлении(Данные, ТаблицаОшибок);
	Возврат ТаблицаОшибок;
КонецФункции

Процедура Проверить_Форма2017_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);;
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("КодНО", Данные.ДанныеУведомления.Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Данные.ДанныеУведомления.Титульная.ПрПодп);
	ОсновныеСведения.Вставить("ИННТитул", Данные.ДанныеУведомления.Титульная.ИННЮЛ);
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.Титульная.ИННЮЛ);
	ОсновныеСведения.Вставить("ПрПост", Данные.ДанныеУведомления.Титульная.ПрПост);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2017_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2017_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2017_1(ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2017_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2017_1");
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ПоложитьВОбласти(Макет, Данные)
	ЗначОбл = Неопределено;
	Для Каждого Обл Из Макет.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник И Обл.СодержитЗначение = Истина Тогда 
			Если Данные.Свойство(Обл.Имя, ЗначОбл) Тогда 
				Обл.Значение = ЗначОбл;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2017_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИННЮЛ", СтруктураПараметров.ДанныеУведомления.Титульная.ИННЮЛ);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 1;
	МакетПФ = Отчеты.РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента.ПолучитьМакет("Печать_Форма2017_1_Титульная");
	ПоложитьВОбласти(МакетПФ, СтруктураПараметров.ДанныеУведомления.Титульная);
	ПечатнаяФорма.Вывести(МакетПФ);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	НомСтр = НомСтр + 1;
	
	ТекЧастьСведМО = 1;
	МакетПФ = Отчеты.РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента.ПолучитьМакет("Печать_Форма2017_1_СведМО");
	ПоложитьВОбласти(МакетПФ, ИННКПП);
	Для Каждого Л1 Из СтруктураПараметров.ДанныеМногостраничныхРазделов.СведМО Цикл 
		Если Не ЗначениеЗаполнено(Л1.Значение.КПП) Тогда 
			Прервать;
		КонецЕсли;
		
		Если ТекЧастьСведМО = 4 Тогда
			МакетПФ.Области["НомСтр"].Значение = Формат(НомСтр, "ЧЦ=4; ЧВН=; ЧГ=");
			ПечатнаяФорма.Вывести(МакетПФ);
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			МакетПФ = Отчеты.РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента.ПолучитьМакет("Печать_Форма2017_1_СведМО");
			ПоложитьВОбласти(МакетПФ, ИННКПП);
			НомСтр = НомСтр + 1;
			ТекЧастьСведМО = 1;
		КонецЕсли;
		
		МакетПФ.Области["КПП_"+ТекЧастьСведМО].Значение = Л1.Значение.КПП;
		МакетПФ.Области["КодНО_"+ТекЧастьСведМО].Значение = Л1.Значение.КодНО;
		МакетПФ.Области["ПрИзм_"+ТекЧастьСведМО].Значение = Л1.Значение.ПрИзм;
		
		ДопСтроки = СтруктураПараметров.ДанныеДопСтрокБД.МнгСтр.НайтиСтроки(Новый Структура("УИД", Л1.Значение.УИД));
		Инд = ДопСтроки.ВГраница();
		Пока Инд >= 0 Цикл 
			Если Не ЗначениеЗаполнено(ДопСтроки[Инд].ОКТМО) Тогда 
				ДопСтроки.Удалить(Инд);
			КонецЕсли;
			Инд = Инд - 1;
		КонецЦикла;
		
		ПорНомДопСтр = 1;
		Для Каждого Стр Из ДопСтроки Цикл
			Если ПорНомДопСтр = 11 Тогда
				ПорНомДопСтр = 1;
				ТекЧастьСведМО = ТекЧастьСведМО + 1;
				Если ТекЧастьСведМО = 4 Тогда
					МакетПФ.Области["НомСтр"].Значение = Формат(НомСтр, "ЧЦ=4; ЧВН=; ЧГ=");
					ПечатнаяФорма.Вывести(МакетПФ);
					УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
					ТекЧастьСведМО = 1;
					МакетПФ = Отчеты.РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента.ПолучитьМакет("Печать_Форма2017_1_СведМО");
					ПоложитьВОбласти(МакетПФ, ИННКПП);
					НомСтр = НомСтр + 1;
				КонецЕсли;
				МакетПФ.Области["КПП_"+ТекЧастьСведМО].Значение = Л1.Значение.КПП;
				МакетПФ.Области["КодНО_"+ТекЧастьСведМО].Значение = Л1.Значение.КодНО;
				МакетПФ.Области["ПрИзм_"+ТекЧастьСведМО].Значение = Л1.Значение.ПрИзм;
			КонецЕсли;
			МакетПФ.Области["ОКТМО_"+ТекЧастьСведМО+"_"+ПорНомДопСтр].Значение = Стр.ОКТМО;
			ПорНомДопСтр = ПорНомДопСтр + 1;
		КонецЦикла;
		
		ТекЧастьСведМО = ТекЧастьСведМО + 1;
	КонецЦикла;
	
	МакетПФ.Области["НомСтр"].Значение = Формат(НомСтр, "ЧЦ=4; ЧВН=; ЧГ=");
	ПечатнаяФорма.Вывести(МакетПФ);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	Возврат Листы;
КонецФункции

Функция СформироватьПустоеДеревоСтраниц_2017(ДанныеОтчета)
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ИндексКартинки", Новый ОписаниеТипов("Число"));
	Дерево.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("УИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Дерево.Колонки.Добавить("ИмяМакета", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Многостраничность", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Многострочность", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("ИДНаименования", Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("МногострочныеЧасти", Новый ОписаниеТипов("СписокЗначений"));
	Дерево.Колонки.Добавить("МакетыПФ", Новый ОписаниеТипов("Строка"));
	
	Стр001 = Дерево.Строки.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2017_1_Титульная";
	Стр001.МногострочныеЧасти = Новый СписокЗначений;
	
	СтрРег = Дерево.Строки.Добавить();
	СтрРег.Наименование = "Сведения о муниципальных" + Символы.ПС + "образованиях";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	СтрРег.МногострочныеЧасти = Новый СписокЗначений;
	
	Инд = 0;
	Для Каждого СтрСвед Из ДанныеОтчета.ДанныеМногостраничныхРазделов.СведенияМО Цикл 
		Инд = Инд + 1;
		СтрРег0 = СтрРег.Строки.Добавить();
		СтрРег0.Наименование = "Стр. " + Формат(Инд, "ЧГ=");
		СтрРег0.ИндексКартинки = 1;
		СтрРег0.ИмяМакета = "СведМО";
		СтрРег0.Многостраничность = Истина;
		СтрРег0.Многострочность = Истина;
		СтрРег0.УИД = Новый УникальныйИдентификатор;
		СтрРег0.ИДНаименования = "СведМО";
		СтрРег0.МногострочныеЧасти = Новый СписокЗначений;
		СтрРег0.МногострочныеЧасти.Добавить("МнгСтр");
	КонецЦикла;
	
	Возврат Дерево;
КонецФункции

Процедура КонвертироватьНаСервере_2017(РегОтчет)
	Попытка
		РО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегОтчет, "КодНалоговогоОргана,ДанныеОтчета,ДатаПодписи,Организация,Дата");
		ДанныеОтчета = РО.ДанныеОтчета.Получить();
		
		Уведомление = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
		Уведомление.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПостановкаСнятиеВКачествеНалоговогоАгента;
		Уведомление.Организация = РО.Организация;
		Уведомление.ИмяОтчета = "РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента";
		Уведомление.ИмяФормы = "Форма2017_1";
		Уведомление.ПодписантФамилия = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.Фамилия;
		Уведомление.ПодписантИмя = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.Имя;
		Уведомление.ПодписантОтчество = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.Отчество;
		Уведомление.ДатаПодписи = ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный.ДатаДок;
		Уведомление.Дата = ТекущаяДатаСеанса();
		
		ТЗМнгСтр = Новый ТаблицаЗначений;
		ТЗМнгСтр.Колонки.Добавить("ОКТМО", Новый ОписаниеТипов("Строка"));
		ТЗМнгСтр.Колонки.Добавить("УИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
		ДанныеУведомления = Новый Структура;
		ДанныеМногостраничныхРазделов = Новый Структура("СведМО", Новый СписокЗначений);
		ИдентификаторыОбычныхСтраниц = Новый Структура;
		ДанныеДопСтрокБД = Новый Структура("МнгСтр", ТЗМнгСтр);
		Титульный = Новый Структура;
		Для Каждого КЗ Из ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный Цикл 
			Титульный.Вставить(КЗ.Ключ, КЗ.Значение);
		КонецЦикла;
		Титульный.Вставить("УИД", Новый УникальныйИдентификатор);
		ДанныеУведомления.Вставить("Титульная", Титульный);
		ИдентификаторыОбычныхСтраниц.Вставить("Титульная", Титульный.УИД);
		
		Уведомление.РегистрацияВИФНС = УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьРегистрациюВИФНСПоКоду(Титульный.КодНО, РО.Организация);
		ДеревоСтраницУведомления = СформироватьПустоеДеревоСтраниц_2017(ДанныеОтчета);
		
		СтрокиУИД = ДеревоСтраницУведомления.Строки[ДеревоСтраницУведомления.Строки.Количество() - 1].Строки;
		Инд = 0;
		Для Каждого СтрСвед Из ДанныеОтчета.ДанныеМногостраничныхРазделов.СведенияМО Цикл 
			УИД = СтрокиУИД[Инд].УИД;
			СтрСведСтр = Новый Структура("КПП, КодНО, ПрИзм, УИД");
			СтрСведСтр.КПП = СтрСвед.Данные.КППМО;
			СтрСведСтр.КодНО = СтрСвед.Данные.КодНОМО;
			СтрСведСтр.ПрИзм = СтрСвед.Данные.ПрИзм;
			СтрСведСтр.УИД = УИД;
			Для Каждого ДС Из СтрСвед.ДанныеДопСтрок Цикл 
				НовСтр = ДанныеДопСтрокБД.МнгСтр.Добавить();
				НовСтр.УИД = УИД;
				НовСтр.ОКТМО = ДС.П000100001003;
			КонецЦикла;
			ДанныеМногостраничныхРазделов.СведМО.Добавить(СтрСведСтр);
			Инд = Инд + 1;
		КонецЦикла;
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ДеревоСтраниц", ДеревоСтраницУведомления);
		СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
		СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", Ложь);
		СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
		СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
		СтруктураПараметров.Вставить("ДанныеДопСтрокБД", ДанныеДопСтрокБД);
		Уведомление.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Уведомление);
		
		ЗаписьСоответствия = РегистрыСведений["СоответствиеРегОтчетовУведомлениям"].СоздатьМенеджерЗаписи();
		ЗаписьСоответствия.РегОтчет = РегОтчет.Ссылка;
		ЗаписьСоответствия.Прочитать();
		ЗаписьСоответствия.РегОтчет = РегОтчет.Ссылка;
		ЗаписьСоответствия.Уведомление = Уведомление.Ссылка;
		ЗаписьСоответствия.Записать(Истина);
	Исключение
	КонецПопытки;
КонецПроцедуры

Процедура КонвертацияИзРегламентированногоОтчета(ВыборкаСтрока) Экспорт
	Попытка
		Если ВыборкаСтрока.ВыбраннаяФорма = "ФормаОтчета2017Кв1" Тогда
			КонвертироватьНаСервере_2017(ВыборкаСтрока.Ссылка);
		КонецЕсли;
	Исключение
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
