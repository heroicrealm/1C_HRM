#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2018_1";
	Стр.КНД = "1150041";
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
	Возврат "Отчет.РегламентированноеУведомлениеОсвобождениеОтУплатыНДДДУС.Форма.Форма2018_1";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2018_1";
	Стр.ОписаниеФормы = "В соответствии с приказом ФНС России от 20.12.2018 № ММВ-7-3/829@";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2018_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2018_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2018_1" Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Электронный формат для данной формы не опубликован'"));
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2018_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2018_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2018_1" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2018_1(УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2018_1(СведенияОтправки)
	Префикс = "SR_UVOSVNALUGL";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2018_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		Данные.Объект.ИмяФормы, ТаблицаОшибок, ПолучитьТаблицуФорм());
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если Не ЗначениеЗаполнено(Титульная.ИНН) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.ИНН))
		Или СтрДлина(СокрЛП(Титульная.ИНН)) <> 10 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан ИНН", "Титульная", "ИНН"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КПП) 
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КПП))
		Или СтрДлина(СокрЛП(Титульная.КПП)) <> 9 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан КПП", "Титульная", "КПП"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Тогда 
		Если Не ЗначениеЗаполнено(Данные.ПодписантИмя) Или Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан подписант", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
		КонецЕсли;
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И Не ЗначениеЗаполнено(Титульная.НаимДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КодНО))
		Или СтрДлина(СокрЛП(Титульная.КодНО)) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации/ФИО физлица", "Титульная", "НаимОрг"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.ПоМесту) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код по месту", "Титульная", "ПоМесту"));
	Иначе
		Если (Сред(Титульная.КПП, 5, 2) = "50" И (Титульная.ПоМесту <> "213"))
			Или ((Сред(Титульная.КПП, 5, 2) = "33" Или Сред(Титульная.КПП, 5, 2) = "57") И (Титульная.ПоМесту <> "247")) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан код по месту", "Титульная", "ПоМесту"));
		КонецЕсли;
	КонецЕсли;
	
	ЕстьЗаполненные = Ложь;
	Для Каждого Элт Из Данные.ДанныеМногостраничныхРазделов.Свед Цикл 
		Свед = Элт.Значение;
		Если Не ЗначениеЗаполнено(Свед.НалПериод)
			И Не ЗначениеЗаполнено(Свед.ОКТМО)
			И Не ЗначениеЗаполнено(Свед.СерЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НомЛицНедр)
			И Не ЗначениеЗаполнено(Свед.ВидЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НаимУчНедр) Тогда 
			
			Продолжить;
		КонецЕсли;
		
		ЕстьЗаполненные = Истина;
		Если Не ЗначениеЗаполнено(Свед.НалПериод) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый период", "Свед", "НалПериод", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.ОКТМО) 
			Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Свед.ОКТМО)) 
			Или (Не (СтрДлина(СокрЛП(Свед.ОКТМО)) = 8 Или СтрДлина(СокрЛП(Свед.ОКТМО)) = 11)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно заполнен ОКТМО", "Свед", "ОКТМО", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.СерЛицНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана серия лицензии", "Свед", "СерЛицНедр", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.НомЛицНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан номер лицензии", "Свед", "НомЛицНедр", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.ВидЛицНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан вид лицензии", "Свед", "ВидЛицНедр", Свед.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Свед.НаимУчНедр) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование", "Свед", "НаимУчНедр", Свед.УИД));
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьЗаполненные Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнены сведения", "Свед", "ПрЗач", Данные.ДанныеМногостраничныхРазделов.Свед[0].Значение.УИД));
	КонецЕсли;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаДатВУведомлении(Данные, ТаблицаОшибок);
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2018_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2018_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2018_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2018_1(ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2018_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2018_1");
	ДополнитьПараметры_2018(ДанныеУведомления);
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ДополнитьПараметры_2018(Параметры)
	Если Параметры.ДанныеУведомления.Титульная.НомКорр = Неопределено Тогда 
		Параметры.ДанныеУведомления.Титульная.НомКорр = 0;
	КонецЕсли;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2018_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета,
		СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2018_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	НомКоррСтр = ?(ЗначениеЗаполнено(СтруктураПараметров.ДанныеУведомления.Титульная.НомКорр), "" + СтруктураПараметров.ДанныеУведомления.Титульная.НомКорр + "---", "0--");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(НомКоррСтр, "НомКорр", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	НомСтр = 2;
	НапечататьЛистыСвед(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП);
	Возврат Листы;
КонецФункции

Процедура НапечататьЛистыСвед(Объект, Листы, СтруктураПараметров, НомСтр, ИННКПП)
	Попытка
		МакетПФ = Отчеты.РегламентированноеУведомлениеОсвобождениеОтУплатыНДДДУС.ПолучитьМакет("Печать_Форма2018_1_Свед");
		ОТЧ = Новый ОписаниеТипов("Число");
	Исключение
		Возврат;
	КонецПопытки;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.Вывести(МакетПФ);
	ТекИнд = 1;
	Для Каждого Элт Из СтруктураПараметров.ДанныеМногостраничныхРазделов.Свед Цикл
		Свед = Элт.Значение;
		Если Не ЗначениеЗаполнено(Свед.НалПериод)
			И Не ЗначениеЗаполнено(Свед.ОКТМО)
			И Не ЗначениеЗаполнено(Свед.СерЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НомЛицНедр)
			И Не ЗначениеЗаполнено(Свед.ВидЛицНедр)
			И Не ЗначениеЗаполнено(Свед.НаимУчНедр) Тогда 
			
			Продолжить;
		КонецЕсли;
		
		ПФкс = "_" + ТекИнд;
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.НаимУчНедр, "НаимУчНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.НалПериод, "НалПериод" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.ОКТМО, "ОКТМО" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.СерЛицНедр, "СерЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.НомЛицНедр, "НомЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Свед.ВидЛицНедр, "ВидЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
		
		Если ТекИнд = 5 Тогда 
			ТекИнд = 1;
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
			ПечатнаяФорма.Вывести(МакетПФ);
			Продолжить;
		КонецЕсли;
		
		ТекИнд = ТекИнд + 1;
	КонецЦикла;
	
	Если ТекИнд <> 1 Тогда
		Пока ТекИнд <> 5 Цикл
			ПФкс = "_" + ТекИнд;
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "НаимУчНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "НалПериод" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "ОКТМО" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "СерЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "НомЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", "ВидЛицНедр" + ПФкс, ПечатнаяФорма.Области, "-");
			ТекИнд = ТекИнд + 1;
		КонецЦикла;
		
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
