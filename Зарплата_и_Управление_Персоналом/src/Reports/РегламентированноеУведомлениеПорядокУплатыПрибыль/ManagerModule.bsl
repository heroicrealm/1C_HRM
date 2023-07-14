#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2019_1";
	Стр.КНД = "1150082";
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
	Возврат "Отчет.РегламентированноеУведомлениеПорядокУплатыПрибыль.Форма.Форма2019_1";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2019_1";
	Стр.ОписаниеФормы = "В соответствии с письмом ФНС России от 26.12.2019 № СД-4-3/26867@";
	Стр.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеПорядокУплатыПрибыль;
	Стр.ПутьФормы = "Отчет.РегламентированноеУведомлениеПорядокУплатыПрибыль.Форма.Форма2019_1";
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2019_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2019_1" Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Электронный формат для данной формы не опубликован'"));
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2019_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2019_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2019_1" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2019_1(УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2019_1(СведенияОтправки)
	Префикс = "UT_IZMPORUPLNPORG";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2019_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		Данные.Объект.ИмяФормы, ТаблицаОшибок, ПолучитьТаблицуФорм());
	ОТЧ = Новый ОписаниеТипов("Число");
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если Не ЗначениеЗаполнено(Титульная.ИНН) 
		Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульная.ИНН, Истина, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан ИНН", "Титульная", "ИНН"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КПП) 
		Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Титульная.КПП, "") Тогда 
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
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации", "Титульная", "НаимОрг"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Титульная.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ)
		И (Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Или Не ЗначениеЗаполнено(Данные.ПодписантИмя))Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указаны фамилия/имя представителя", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДатаУвед) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата уведомления", "Титульная", "ДатаУвед"));
	КонецЕсли;
	
	Если СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("01,05,02,03,04,06,11,12,13,14,15", ",").Найти(Титульная.ПрПредУв) = Неопределено Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан признак причины подачи", "Титульная", "ПрПредУв"));
	КонецЕсли;
	Если СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("1,2,3,4", ",").Найти(Титульная.ПрУвед) = Неопределено Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан признак состава уведомления", "Титульная", "ПрУвед"));
	КонецЕсли;
	
	ЕстьПодчиненные = Ложь;
	Если Титульная.ПрУвед = "1" Или Титульная.ПрПредУв = "05" Тогда
		ПроверитьУведомление1(ТаблицаОшибок, Данные, ЕстьПодчиненные, ОТЧ);
		Если ЕстьПодчиненные = Ложь Тогда
			УИД = Данные.ДанныеМногостраничныхРазделов.Уведомление1_подр[0].Значение.УИД;
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана информация о подразделениях", "Уведомление1_подр", "КПП", УИД));
		КонецЕсли;
	ИначеЕсли Титульная.ПрУвед = "2" Или Титульная.ПрПредУв = "04" Или Титульная.ПрПредУв = "06" Тогда 
		ПроверитьУведомление2(ТаблицаОшибок, Данные, ЕстьПодчиненные, ОТЧ);
		Если ЕстьПодчиненные = Ложь Тогда
			УИД = Данные.ДанныеМногостраничныхРазделов.Уведомление2_подр[0].Значение.УИД;
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана информация о подразделениях", "Уведомление2_подр", "КПП", УИД));
		КонецЕсли;
	ИначеЕсли Титульная.ПрУвед = "3" Или Титульная.ПрПредУв = "04" Или Титульная.ПрПредУв = "06" Тогда
		ПроверитьУведомление3(ТаблицаОшибок, Данные, ОТЧ);
	ИначеЕсли Титульная.ПрУвед = "4" Тогда
		ПроверитьУведомление1(ТаблицаОшибок, Данные, ЕстьПодчиненные, ОТЧ);
		Если ЕстьПодчиненные = Ложь Тогда
			УИД = Данные.ДанныеМногостраничныхРазделов.Уведомление1_подр[0].Значение.УИД;
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана информация о подразделениях", "Уведомление1_подр", "КПП", УИД));
		КонецЕсли;
		ЕстьПодчиненные = Ложь;
		ПроверитьУведомление2(ТаблицаОшибок, Данные, ЕстьПодчиненные, ОТЧ);
		Если ЕстьПодчиненные = Ложь Тогда
			УИД = Данные.ДанныеМногостраничныхРазделов.Уведомление2_подр[0].Значение.УИД;
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана информация о подразделениях", "Уведомление2_подр", "КПП", УИД));
		КонецЕсли;
	КонецЕсли;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаДатВУведомлении(Данные, ТаблицаОшибок);
	Возврат ТаблицаОшибок;
КонецФункции

Процедура ПроверитьУведомление1(ТаблицаОшибок, Данные, ЕстьПодчиненные, ОТЧ)
	Уведомление1 = Данные.ДанныеУведомления.Уведомление1;
	
	Если Не ЗначениеЗаполнено(Уведомление1.КодРегион) Или СтрДлина(СокрЛП(Уведомление1.КодРегион)) <> 2 Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан субъект Российской Федерации в бюджет которого изменяется порядок уплаты налога", "Уведомление1", "КодРегион"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление1.ДатаИзмПорУпл) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата с которой изменяется порядок уплаты налога", "Уведомление1", "ДатаИзмПорУпл"));
	ИначеЕсли Год(Уведомление1.ДатаИзмПорУпл) < 2000 Или Год(Уведомление1.ДатаИзмПорУпл) > 2099 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указана дата с которой изменяется порядок уплаты налога", "Уведомление1", "ДатаИзмПорУпл"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление1.КПП) 
		Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Уведомление1.КПП, "") Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан /неправильно указан КПП", "Уведомление1", "КПП"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление1.НаимОтвОбПодр) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование ответственного обособленного подразделения", "Уведомление1", "НаимОтвОбПодр"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление1.ОКТМО) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код по ОКТМО по месту нахождения ответственного обособленного подразделения", "Уведомление1", "ОКТМО"));
	КонецЕсли;
	
	Для Каждого Стр Из Данные.ДанныеМногостраничныхРазделов.Уведомление1_подр Цикл 
		Подр = Стр.Значение;
		Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Подр) Тогда
			ЕстьПодчиненные = Истина;
			
			Если Не ЗначениеЗаполнено(Подр.КПП) 
				Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Подр.КПП, "") Тогда
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан /неправильно указан КПП", "Уведомление1_подр", "КПП", Подр.УИД));
			КонецЕсли;
			
			Если Подр.ПрОтмПредОтвОбПодр <> "0" И Подр.ПрОтмПредОтвОбПодр <> "1" Тогда
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан признак", "Уведомление1_подр", "ПрОтмПредОтвОбПодр", Подр.УИД));
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Подр.КварталАвПлат) И ОТЧ.ПривестиЗначение(Подр.КварталАвПлат) > 4 Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан квартал", "Уведомление1_подр", "КварталАвПлат", Подр.УИД));
			КонецЕсли;
			Если ЗначениеЗаполнено(Подр.ГодАвПлат) И ОТЧ.ПривестиЗначение(Подр.ГодАвПлат) < 2000 Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан год", "Уведомление1_подр", "ГодАвПлат", Подр.УИД));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьУведомление2(ТаблицаОшибок, Данные, ЕстьПодчиненные, ОТЧ)
	Уведомление2 = Данные.ДанныеУведомления.Уведомление2;
	
	Если Не ЗначениеЗаполнено(Уведомление2.КодРегион) Или СтрДлина(СокрЛП(Уведомление2.КодРегион)) <> 2 Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан субъект Российской Федерации в бюджет которого изменяется порядок уплаты налога", "Уведомление2", "КодРегион"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление2.ДатаИзмПорУпл) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата с которой изменяется порядок уплаты налога", "Уведомление2", "ДатаИзмПорУпл"));
	ИначеЕсли Год(Уведомление2.ДатаИзмПорУпл) < 2000 Или Год(Уведомление2.ДатаИзмПорУпл) > 2099 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указана дата с которой изменяется порядок уплаты налога", "Уведомление2", "ДатаИзмПорУпл"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление2.КППОтв) 
		Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Уведомление2.КППОтв, "") Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан /неправильно указан КПП", "Уведомление2", "КППОтв"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление2.НаимОтвОбПодр) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование ответственного обособленного подразделения", "Уведомление2", "НаимОтвОбПодр"));
	КонецЕсли;
	
	Для Каждого Стр Из Данные.ДанныеМногостраничныхРазделов.Уведомление2_подр Цикл 
		Подр = Стр.Значение;
		Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Подр) Тогда
			ЕстьПодчиненные = Истина;
			
			Если Не ЗначениеЗаполнено(Подр.КПП) 
				Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Подр.КПП, "") Тогда
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан /неправильно указан КПП", "Уведомление2_подр", "КПП", Подр.УИД));
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Подр.НаимОбПодр) Тогда
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование ответственного обособленного подразделения", "Уведомление2_подр", "НаимОбПодр", Подр.УИД));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьУведомление3(ТаблицаОшибок, Данные, ОТЧ)
	Уведомление3 = Данные.ДанныеУведомления.Уведомление3;
	
	Если Не ЗначениеЗаполнено(Уведомление3.КодРегион) Или СтрДлина(СокрЛП(Уведомление3.КодРегион)) <> 2 Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан субъект Российской Федерации в бюджет которого изменяется порядок уплаты налога", "Уведомление3", "КодРегион"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление3.ДатаИзмПорУпл) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата с которой изменяется порядок уплаты налога", "Уведомление3", "ДатаИзмПорУпл"));
	ИначеЕсли Год(Уведомление3.ДатаИзмПорУпл) < 2000 Или Год(Уведомление3.ДатаИзмПорУпл) > 2099 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указана дата с которой изменяется порядок уплаты налога", "Уведомление3", "ДатаИзмПорУпл"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление3.ИННЮЛ) 
		Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Уведомление3.ИННЮЛ, Истина, "") Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан ИНН", "Уведомление3", "ИННЮЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление3.КПП) 
		Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Уведомление3.КПП, "") Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан /неправильно указан КПП", "Уведомление3", "КПП"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление3.ОКТМО) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код по ОКТМО по месту нахождения ответственного обособленного подразделения", "Уведомление3", "ОКТМО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление3.НаимОтвОбПодр) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование ответственного обособленного подразделения", "Уведомление3", "НаимОтвОбПодр"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Уведомление3.ОКТМОГр) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код по ОКТМО по месту нахождения ответственного участника консолидированной группы налогоплательщиков", "Уведомление3", "ОКТМОГр"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Уведомление3.КварталАвПлат) И ОТЧ.ПривестиЗначение(Уведомление3.КварталАвПлат) > 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан квартал", "Уведомление3", "КварталАвПлат"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Уведомление3.ГодАвПлат) И ОТЧ.ПривестиЗначение(Уведомление3.ГодАвПлат) < 2000 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан год", "Уведомление3", "ГодАвПлат"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Уведомление3.Квартал) И ОТЧ.ПривестиЗначение(Уведомление3.Квартал) > 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан квартал", "Уведомление3", "Квартал"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Уведомление3.Год) И ОТЧ.ПривестиЗначение(Уведомление3.Год) < 2000 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан год", "Уведомление3", "Год"));
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("ПрУвед", Данные.ДанныеУведомления.Титульная.ПрУвед);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2019_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2019_1(ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2019_1");
	ДополнитьПараметры_2019(ДанныеУведомления);
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ДополнитьПараметры_2019(Параметры)
	Уведомление3 = Параметры.ДанныеУведомления.Уведомление3;
	
	Если ЗначениеЗаполнено(Уведомление3.КварталАвПлат) Тогда 
		Уведомление3.КварталАвПлат = Прав(СокрЛП("00" + Уведомление3.КварталАвПлат), 2);
	Иначе
		Уведомление3.КварталАвПлат = "";
	КонецЕсли;
	Если ЗначениеЗаполнено(Уведомление3.Квартал) Тогда 
		Уведомление3.Квартал = Прав(СокрЛП("00" + Уведомление3.Квартал), 2);
	Иначе
		Уведомление3.Квартал = "";
	КонецЕсли;
	Если ЗначениеЗаполнено(Уведомление3.ГодАвПлат) Тогда 
		Уведомление3.ГодАвПлат = Прав(СокрЛП("0000" + Уведомление3.ГодАвПлат), 4);
	Иначе
		Уведомление3.ГодАвПлат = "";
	КонецЕсли;
	Если ЗначениеЗаполнено(Уведомление3.Год) Тогда 
		Уведомление3.Год = Прав(СокрЛП("0000" + Уведомление3.Год), 4);
	Иначе
		Уведомление3.Год = "";
	КонецЕсли;
	
	Для Каждого Элт Из Параметры.ДанныеМногостраничныхРазделов.Уведомление1_подр Цикл 
		Уведомление1 =  Элт.Значение;
		Если ЗначениеЗаполнено(Уведомление1.КварталАвПлат) Тогда 
			Уведомление1.КварталАвПлат = Формат(Уведомление1.КварталАвПлат, "ЧЦ=2; ЧВН=; ЧГ=");
		Иначе
			Уведомление1.КварталАвПлат = "";
		КонецЕсли;
		Если ЗначениеЗаполнено(Уведомление1.ГодАвПлат) Тогда 
			Уведомление1.ГодАвПлат = Формат(Уведомление1.ГодАвПлат, "ЧЦ=4; ЧВН=; ЧГ=");
		Иначе
			Уведомление1.ГодАвПлат = "";
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ДополнитьСтраницу(СтруктураДанныхСтраницы, ПечатнаяФорма, ИндексПечати)
	Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ + ИндексПечати, ПечатнаяФорма.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ + ИндексПечати, ПечатнаяФорма.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ + ИндексПечати, ПечатнаяФорма.Области);
		ИначеЕсли КЗ.Значение = Неопределено Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ + ИндексПечати, ПечатнаяФорма.Области, "-");
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура НапечататьУведомление12(ТипУв, ПечатнаяФорма, ИННКПП, НомСтр, СтруктураПараметров, Листы, Объект)
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру("РегламентированноеУведомлениеПорядокУплатыПрибыль",
		СтруктураПараметров.ДанныеУведомления["Уведомление" + ТипУв], НомСтр, "Печать_Форма2019_1_Уведомление" + ТипУв, ПечатнаяФорма, ИННКПП);
	Инд = 1;
	Подр = Неопределено;
	ВыведеныПодр = Ложь;
	Для Каждого Стр Из СтруктураПараметров.ДанныеМногостраничныхРазделов["Уведомление" + ТипУв + "_подр"] Цикл 
		Подр = Стр.Значение;
		Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Подр) Тогда
			ВыведеныПодр = Истина;
			ДополнитьСтраницу(Подр, ПечатнаяФорма, "_" + Инд);
			Инд = Инд + 1;
			Если Инд = 3 Тогда 
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
				Инд = 1;
				УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру("РегламентированноеУведомлениеПорядокУплатыПрибыль", 
					СтруктураПараметров.ДанныеУведомления["Уведомление" + ТипУв], НомСтр, "Печать_Форма2019_1_Уведомление" + ТипУв, ПечатнаяФорма, ИННКПП);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Инд = 2 Тогда
		Подр = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Подр);
		Для Каждого КЗ Из Подр Цикл 
			Подр[КЗ.Ключ] = Неопределено;
		КонецЦикла;
		ДополнитьСтраницу(Подр, ПечатнаяФорма, "_2");
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	ИначеЕсли Не ВыведеныПодр Тогда
		Подр = СтруктураПараметров.ДанныеМногостраничныхРазделов["Уведомление" + ТипУв + "_подр"][0].Значение;
		ДополнитьСтраницу(Подр, ПечатнаяФорма, "_1");
		ДополнитьСтраницу(Подр, ПечатнаяФорма, "_2");
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	ИначеЕсли Инд = 1 Тогда
		НомСтр = НомСтр - 1;
	КонецЕсли;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2019_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ДополнитьПараметры_2019(СтруктураПараметров);
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Титульная"],
		НомСтр, "Печать_Форма2019_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	НомСтр = 1;
	Если СтруктураПараметров.ДанныеУведомления.Титульная.ПрУвед = "1" Тогда
		НапечататьУведомление12(1, ПечатнаяФорма, ИННКПП, НомСтр, СтруктураПараметров, Листы, Объект);
	ИначеЕсли СтруктураПараметров.ДанныеУведомления.Титульная.ПрУвед = "2" Тогда
		НапечататьУведомление12(2, ПечатнаяФорма, ИННКПП, НомСтр, СтруктураПараметров, Листы, Объект);
	ИначеЕсли СтруктураПараметров.ДанныеУведомления.Титульная.ПрУвед = "3" Тогда 
		УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета, СтруктураПараметров.ДанныеУведомления["Уведомление3"],
			НомСтр, "Печать_Форма2019_1_Уведомление3", ПечатнаяФорма, ИННКПП);
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	ИначеЕсли СтруктураПараметров.ДанныеУведомления.Титульная.ПрУвед = "4" Тогда
		НапечататьУведомление12(1, ПечатнаяФорма, ИННКПП, НомСтр, СтруктураПараметров, Листы, Объект);
		НапечататьУведомление12(2, ПечатнаяФорма, ИННКПП, НомСтр, СтруктураПараметров, Листы, Объект);
	КонецЕсли;
	
	Возврат Листы;
КонецФункции

#КонецОбласти
#КонецЕсли
