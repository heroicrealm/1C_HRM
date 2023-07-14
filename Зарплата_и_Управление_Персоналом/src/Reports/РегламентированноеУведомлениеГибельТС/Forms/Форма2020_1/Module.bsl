
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	Параметры.Свойство("ЗаполнитьПриОткрытии", ЗаполнитьПриОткрытии);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОГибелиТранспортногоСредства;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2020_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления);
		ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	ИначеЕсли Параметры.Свойство("ПредставлениеXML") Тогда 
		Параметры.Свойство("РегистрацияВНалоговомОргане", Объект.РегистрацияВИФНС);
		Параметры.Свойство("Организация", Объект.Организация);
		ЗагрузитьИзXMLНаСервере(Новый Структура("Организация, РегистрацияВНалоговомОргане, ПредставлениеXML", 
								Объект.Организация, Объект.РегистрацияВИФНС, Параметры.ПредставлениеXML));
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = УведомлениеОСпецрежимахНалогообложения.ДополнитьЗаголовокУведомления(Заголовок, Объект.Организация);
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(ИдДляСвор);
	РучнойВвод = Ложь;
	ЦФБ = Новый Цвет(255, 255, 255);
	
	ЭтаФормаИмя = ЭтаФорма.ИмяФормы;
	Если СтрЧислоВхождений(ЭтаФормаИмя, "ВнешнийОтчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "ВнешнийОтчет.", "");
	ИначеЕсли СтрЧислоВхождений(ЭтаФормаИмя, "Отчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "Отчет.", "");
	КонецЕсли;
	ИДОтчета = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	ИДРедакцииОтчета = Сред(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") + 7);
	ПараметрыОтчета = Новый Структура("Организация, ДатаПодписи, РегистрацияВИФНС",
		Объект.Организация, Объект.ДатаПодписи, Объект.РегистрацияВИФНС);
	ПоказателиОтчета = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОПоказателяхОтчета(
		ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета);
		
	Если ТипЗнч(ПоказателиОтчета) = Тип("Структура")
		И ПоказателиОтчета.Количество() > 0 Тогда 
			
		Для Каждого КЗ Из ПоказателиОтчета Цикл 
			ЗаполняемыеРеквизиты.Добавить(КЗ.Ключ);
		КонецЦикла;
		ЕстьПодборИзКлассификатора = Истина;
	Иначе
		Элементы.ФормаЗаполнить.Видимость = Ложь;
	КонецЕсли;
	ЦветФонаАвто = Новый Цвет(230, 240, 220);
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	Если ЗаполнитьПриОткрытии Тогда 
		Заполнить(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Заполнить(Команда)
	Доступность = Ложь;
	РезультатВыполнения = ЗаполнитьАвтоНаСервере();
	Если НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьАвтоЗавершениеПослеЗаполнения", ЭтотОбъект);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется заполнение по данным информационной базы'");
		ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполнения, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАвтоЗавершениеПослеЗаполнения(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	Доступность = Истина;
	
	Если РезультатЗагрузки = Неопределено
		ИЛИ РезультатЗагрузки.Статус <> "Выполнено" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось выполнить автозаполнение...'"));
		Возврат;
	КонецЕсли;

	ЗагрузитьПодготовленныеДанные();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьАвтоНаСервере()
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", Объект.Организация);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ВидУведомления", Объект.ВидУведомления);
	ПараметрыОтчета.Вставить("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	ПараметрыОтчета.Вставить("ДатаПодписи", Объект.ДатаПодписи);
	Контейнер = Новый Структура();
	
	ОТУИД = Новый ОписаниеТипов("УникальныйИдентификатор");
	Для Каждого КЗ Из ДанныеМногостраничныхРазделов Цикл 
		ДанныеСтраницы = ОбщегоНазначения.СкопироватьРекурсивно(КЗ.Значение[0].Значение);
		ТЗСтр = Новый ТаблицаЗначений;
		Для Каждого Кол Из ДанныеСтраницы Цикл 
			ТЗСтр.Колонки.Добавить(Кол.Ключ, ?(ТипЗнч(Кол.Значение) = Тип("УникальныйИдентификатор"), ОТУИД, Неопределено))
		КонецЦикла;
		Контейнер.Вставить(КЗ.Ключ, ТЗСтр);
	КонецЦикла;
	
	Контейнер.Вставить("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	Контейнер.Вставить("ДатаПодписи", Объект.ДатаПодписи);
	
	ЭтаФормаИмя = ЭтаФорма.ИмяФормы;
	Если СтрЧислоВхождений(ЭтаФормаИмя, "ВнешнийОтчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "ВнешнийОтчет.", "");
	ИначеЕсли СтрЧислоВхождений(ЭтаФормаИмя, "Отчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "Отчет.", "");
	КонецЕсли;
	ИДОтчета = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	ИДРедакцииОтчета = Сред(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") + 7);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.ЗапуститьВФоне = Истина;
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("РегламентированнаяОтчетность.ЗаполнитьОтчетВФоне_Уведомления",
		Новый Структура("ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер", ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер),
		ПараметрыВыполненияВФоне);
	
	РезультатВыполнения.Вставить("ЗаданиеВыполнено", НРег(РезультатВыполнения.Статус) = "выполнено");
	АдресХранилища       = РезультатВыполнения.АдресРезультата;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	СтруктураДанных.Контейнер.Свойство("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	СтруктураДанных.Контейнер.Свойство("ДатаПодписи", Объект.ДатаПодписи);
	ДанныеУведомления.Титульная["КодНО"] = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
	ДанныеУведомления.Титульная["ДАТА_ПОДПИСИ"] = Объект.ДатаПодписи;
	
	Для Каждого КЗ Из ДанныеМногостраничныхРазделов Цикл 
		КЗ.Значение.Очистить();
	КонецЦикла;
	
	Для Каждого КЗ Из СтруктураДанных.Контейнер.Транспорт Цикл 
		СтруктураСтраницы = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КЗ);
		ДанныеМногостраничныхРазделов.Транспорт.Добавить(СтруктураСтраницы);
	КонецЦикла;
	
	Если СтруктураДанных.Контейнер.Транспорт.Количество() = 0 Тогда
		ДанныеМногостраничныхРазделов.Транспорт.Добавить(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтруктураДанных.Контейнер.Транспорт.Добавить()));
		ДанныеМногостраничныхРазделов.Транспорт[0].Значение.УИД = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	КорневойУровень.Удалить(1);
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Сведения о транспортных" + символы.ПС + "средствах";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	Для Каждого Стр Из ДанныеМногостраничныхРазделов.Транспорт Цикл 
		СтрРегТр = СтрРег.ПолучитьЭлементы().Добавить();
		СтрРегТр.Наименование = "Стр. " + (ДанныеМногостраничныхРазделов.Транспорт.Индекс(Стр) + 1);
		СтрРегТр.ИндексКартинки = 1;
		СтрРегТр.ИмяМакета = "Транспорт_2020";
		СтрРегТр.Многостраничность = Истина;
		СтрРегТр.Многострочность = Ложь;
		СтрРегТр.УИД = Стр.Значение.УИД;
		СтрРегТр.ИДНаименования = "Транспорт";
	КонецЦикла;
	
	ТекущееИДНаименования = "Титульная";
	ПоказатьТекущуюСтраницу("Титульная_2020", Неопределено);
	Модифицированность = Истина;
	Доступность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	ЗаполнитьНачальныеДанные();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	Если ЭтоЮЛ Тогда 
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
		ДанныеУведомленияТитульный.Вставить("НаимОрг", СведенияОбОрганизации.НаимЮЛПол);
		ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелОрганизации);
	Иначе
		СтрокаСведений = "ФИО,ИННФЛ,ТелДом";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННФЛ);
		ДанныеУведомленияТитульный.Вставить("НаимОрг", СведенияОбОрганизации.ФИО);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
		ДанныеУведомленияТитульный.Вставить("КПП", "");
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	ДанныеУведомленияТитульный.Вставить("КПП", Реквизиты.КПП);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	Иначе
		УстановитьПредставителяПоОрганизации();
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "1");
		ДанныеУведомленияТитульный.Вставить("НаимДок", "");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная_2020";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2020_1_Титульная";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Сведения о транспортных" + символы.ПС + "средствах";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "Транспорт_2020";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "Транспорт";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УИДТекущаяСтраница <> Элемент.ТекущиеДанные.УИД Тогда 
		ПредУИД = УИДТекущаяСтраница;
		
		УИДТекущаяСтраница = Элемент.ТекущиеДанные.УИД;
		ТекущееИДНаименования = Элемент.ТекущиеДанные.ИДНаименования;
		Если Не ЗначениеЗаполнено(ТекущееИДНаименования) Тогда 
			ТекущееИДНаименования = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].ИДНаименования;
			УИДТекущаяСтраница = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].УИД;
		КонецЕсли;
		
		Если Элемент.ТекущиеДанные.Многостраничность Тогда 
			ИмяМакета = УведомлениеОСпецрежимахНалогообложенияКлиент.ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
			ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД);
		Иначе 
			ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, ПредУИД);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД)
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("УправлениеСтраницами"));
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	СтрДанных = Неопределено;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
		Если Элт.Значение.УИД = УИДТекущаяСтраница Тогда 
			СтрДанных = Элт.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	НайденнаяСтрока = УведомлениеОСпецрежимахНалогообложения.НайтиСтрокуВДеревеПоУИД(ДеревоСтраниц.ПолучитьЭлементы(), УИДТекущаяСтраница);
	Если НайденнаяСтрока <> Неопределено
		И НайденнаяСтрока.ПолучитьРодителя().ПолучитьЭлементы().Количество() = 1 Тогда 
		
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницу.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Гиперссылка = Ложь;
		ПредставлениеУведомления.Области.УдалитьСтраницу.Гиперссылка = Ложь;
	КонецЕсли;
	РаскраситьАвтозаполняемыеЯчейки();
КонецПроцедуры

&НаСервере
Процедура РаскраситьАвтозаполняемыеЯчейки()
	Для Каждого Элт Из ЗаполняемыеРеквизиты Цикл 
		Обл = ПредставлениеУведомления.Области.Найти(Элт.Значение);
		Если Обл <> Неопределено Тогда 
			Обл.ЦветФона = ЦветФонаАвто;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, ПредУИД)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, ПредУИД);
	
	Если Не ЭтоЮЛ Тогда 
		ПредставлениеУведомления.Области["НаимОрг"].Защита = Истина;
		ПредставлениеУведомления.Области["НаимОрг"].ЦветФона = ЦФБ; 
	КонецЕсли;
	РаскраситьАвтозаполняемыеЯчейки();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	ПредставлениеУведомления.Области["КПП"].Значение = Реквизиты.КПП;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("КПП", ПредставлениеУведомления.Области["КПП"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
		ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
		КонецЕсли;
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", "");
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	Если ЭтоЮЛ Тогда 
		СтрокаСведений = "ФамилияРук,ИмяРук,ОтчествоРук";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		Объект.ПодписантФамилия = СведенияОбОрганизации.ФамилияРук;
		Объект.ПодписантИмя = СведенияОбОрганизации.ИмяРук;
		Объект.ПодписантОтчество = СведенияОбОрганизации.ОтчествоРук;
	Иначе
		СтрокаСведений = "ФамилияИП,ИмяИП,ОтчествоИП";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		Объект.ПодписантФамилия = СведенияОбОрганизации.ФамилияИП;
		Объект.ПодписантИмя = СведенияОбОрганизации.ИмяИП;
		Объект.ПодписантОтчество = СведенияОбОрганизации.ОтчествоИП;
	КонецЕсли;
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
	Если ЕстьОбласть Тогда 
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ДанныеМногостраничныхРазделов = СтруктураПараметров.ДанныеМногостраничныхРазделов;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	УдалениеСтраницы = Истина;
	УдалитьСтраницуНаСервере();
	УдалениеСтраницы = Ложь;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.КопироватьСтраницуУведомления(ЭтотОбъект, Истина);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтандартнаяОбработка И Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораПодписантаЗавершение", ЭтотОбъект, Неопределено);
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления",
																	"ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ОписаниеОповещения);
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "СкопироватьСтраницу") > 0 Тогда
		СкопироватьСтраницуНаСервере();
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
			
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина);
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		ОбработкаКодаНО(Область.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено И Результат <> КодВозвратаДиалога.Нет Тогда
		Результат.Свойство("Фамилия", Объект.ПодписантФамилия);
		Результат.Свойство("Имя", Объект.ПодписантИмя);
		Результат.Свойство("Отчество", Объект.ПодписантОтчество);
		Представление = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		Область = ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ");
		Область.Значение = Представление;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	СтруктураВыгрузки = Новый Структура("ТестВыгрузки,КодировкаВыгрузки", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки);
	СтруктураВыгрузки.Вставить("Данные", УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетДвоичныхДанных(Объект.ИмяОтчета, "TIFF_2020_1"));
	СтруктураВыгрузки.Вставить("ИмяФайла", "1150076_5.02000_02.tif");
	Возврат СтруктураВыгрузки;
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, "Открыть", Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзXML(ПараметрыЗагрузкиXML) Экспорт
	ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML);
	Элементы.ДеревоСтраниц.ТекущаяСтрока = ДеревоСтраниц.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML)
	ДеревоЗагрузки = УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЗагрузки(ПараметрыЗагрузкиXML.ПредставлениеXML);
	СхемаВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2020_1");
	УведомлениеОСпецрежимахНалогообложения.УстановитьОрганизациюПоПараметрамЗагрузки(ЭтотОбъект, ПараметрыЗагрузкиXML);
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьОбычныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМногостраничныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомление(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ЗагрузитьИзФайлаУведомление(ЭтотОбъект);
КонецПроцедуры
