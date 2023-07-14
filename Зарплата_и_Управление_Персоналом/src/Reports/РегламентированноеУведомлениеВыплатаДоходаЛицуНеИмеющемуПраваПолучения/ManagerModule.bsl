#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
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
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2020_1";
	Стр.ОписаниеФормы = "Форма по письму ФНС России 20.04.2015 № ГД-4-3/6713@.";
	Стр.ДатаНачала = '20201001';
	Стр.ДатаКонца = '20991231';
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Электронный формат для данной формы не опубликован'"));
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Электронный формат для данной формы не опубликован'"));
	Возврат Неопределено;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2020_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2020_1(Объект);
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистовФорма2020_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета,
		СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2020_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета,
		СтруктураПараметров.ДанныеУведомления["Раздел12"], НомСтр, "Печать_Форма2020_1_Раздел12", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	НомСтр = 3;
	ПустаяСтруктура = Новый Структура;
	Для Каждого КЗ Из СтруктураПараметров.ДанныеМногостраничныхРазделов.Раздел3[0].Значение Цикл 
		ПустаяСтруктура.Вставить(КЗ.Ключ);
	КонецЦикла;
	
	МакетПФ = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_Форма2020_1_Раздел3");
	Инд = 0;
	Для Каждого Стр Из СтруктураПараметров.ДанныеМногостраничныхРазделов.Раздел3 Цикл 
		СтрРаздел3 = Стр.Значение;
		Инд = Инд + 1;
		ИндСтр = "_" + Формат(Инд, "ЧГ=");
		
		Для Каждого КЗ Из СтрРаздел3 Цикл 
			Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ + ИндСтр, МакетПФ.Области, "-");
			ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ + ИндСтр, МакетПФ.Области, "-");
			ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ + ИндСтр, МакетПФ.Области);
			ИначеЕсли КЗ.Значение = Неопределено Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ + ИндСтр, МакетПФ.Области, "-");
			КонецЕсли;
		КонецЦикла;
		
		Если Инд = 3 Тогда 
			Инд = 0;
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", МакетПФ.Области, "-");
			ПечатнаяФорма.Вывести(МакетПФ);
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
			МакетПФ = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_Форма2020_1_Раздел3");
			НомСтр = НомСтр + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Инд <> 0 Тогда 
		Пока Инд < 3 Цикл  
			Инд = Инд + 1;
			ИндСтр = "_" + Формат(Инд, "ЧГ=");
			Для Каждого КЗ Из ПустаяСтруктура Цикл
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ + ИндСтр, МакетПФ.Области, "-");
			КонецЦикла;
		КонецЦикла;
		
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧВН="), "НомСтр", МакетПФ.Области, "-");
		ПечатнаяФорма.Вывести(МакетПФ);
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	КонецЕсли;
	
	Возврат Листы;
КонецФункции
#КонецОбласти
#КонецЕсли
