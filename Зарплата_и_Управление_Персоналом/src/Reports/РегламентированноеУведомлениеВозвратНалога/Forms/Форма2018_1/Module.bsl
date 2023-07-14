&НаКлиенте
Перем ЦФЖ;

&НаКлиенте
Перем ЦФБ;

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
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2018_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	ИначеЕсли Параметры.Свойство("ПредставлениеXML") Тогда 
		Параметры.Свойство("РегистрацияВНалоговомОргане", Объект.РегистрацияВИФНС);
		Параметры.Свойство("Организация", Объект.Организация);
		ЗагрузитьИзXMLНаСервере(Новый Структура("Организация, РегистрацияВНалоговомОргане, ПредставлениеXML", 
								Объект.Организация, Объект.РегистрацияВИФНС, Параметры.ПредставлениеXML));
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = УведомлениеОСпецрежимахНалогообложения.ДополнитьЗаголовокУведомления(Заголовок, Объект.Организация);
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЦФЖ = Новый Цвет(255, 255, 192);
	ЦФБ = Новый Цвет(255, 255, 255);
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	РучнойВвод = Ложь;
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
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная_2018"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.НаимЮЛПол);
		ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелОрганизации);
	Иначе
		СтрокаСведений = "ИННФЛ,ФИО,ТелДом";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННФЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.ФИО);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
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
	Стр001.ИмяМакета = "Титульная_2018";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная_2018";
	Стр001.МакетыПФ = "Печать_Форма2018_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Сведения о"+символы.ПС+"счете в банке";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Лист001_2018";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист001_2018";
	Стр001.МакетыПФ = "Печать_Форма2018_1_Лист001";
	
	Если Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		Стр001 = КорневойУровень.Добавить();
		Стр001.Наименование = "Сведения о физическом"+символы.ПС+"лице, не являющимся"+символы.ПС+"индивидуальным предпринимателем";
		Стр001.ИндексКартинки = 1;
		Стр001.ИмяМакета = "Лист002_2018";
		Стр001.Многостраничность = Ложь;
		Стр001.Многострочность = Ложь;
		Стр001.УИД = Новый УникальныйИдентификатор;
		Стр001.ИДНаименования = "Лист002_2018";
		Стр001.МакетыПФ = "Печать_Форма2018_1_Лист002";
	КонецЕсли;
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
		
		ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета);
		Если ТекущееИДНаименования = "Лист001_2018" Тогда 
			ОбработкаПрПолучатель();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	ИначеЕсли Область.Имя = "ФамилияПолучатель" Или Область.Имя = "ИмяПолучатель" Или Область.Имя = "ОтчествоПолучатель" Тогда
		ПредставлениеУведомления.Области.Л0107.Значение = ПредставлениеУведомления.Области.ФамилияПолучатель.Значение + " "
		+ ПредставлениеУведомления.Области.ИмяПолучатель.Значение + " " + ПредставлениеУведомления.Области.ОтчествоПолучатель.Значение;
		ДанныеУведомления.Лист001_2018.Л0107 = ПредставлениеУведомления.Области.Л0107.Значение;
	ИначеЕсли Область.Имя = "НаимОргЛицСч" Тогда
		ПредставлениеУведомления.Области.Л0107.Значение = ПредставлениеУведомления.Области.НаимОргЛицСч.Значение;
		ДанныеУведомления.Лист001_2018.Л0107 = ПредставлениеУведомления.Области.НаимОргЛицСч.Значение;
	ИначеЕсли Область.Имя = "ПрПолучатель" Тогда
		ОбработкаПрПолучатель();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	ПредставлениеУведомления.Области["КПП"].Значение = Реквизиты.КПП;
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная_2018"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("КПП", ПредставлениеУведомления.Области["КПП"].Значение);
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная_2018"];
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		СведенияОПредставителе = РегламентированнаяОтчетностьВызовСервера.ПолучитьПоКодамСведенияОПредставителе(
			Объект.Организация, 
			ДанныеУведомленияТитульный["КодНО"], 
			ДанныеУведомленияТитульный["КПП"]);
		
		Если ЗначениеЗаполнено(СведенияОПредставителе.НаименованиеОрганизацииПредставителя) Тогда 
			ПодписантСтр = СведенияОПредставителе.ФИОПредставителя;
			ФИО = РегламентированнаяОтчетность.РазложитьФИО(СведенияОПредставителе.ФИОПредставителя);
			Объект.ПодписантФамилия = СокрЛП(ФИО.Фамилия);
			Объект.ПодписантИмя = СокрЛП(ФИО.Имя);
			Объект.ПодписантОтчество = СокрЛП(ФИО.Отчество);
		Иначе
			ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
			Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
			Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
			Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
			ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		КонецЕсли;
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
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная_2018"];
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
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтандартнаяОбработка И Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораПодписантаЗавершение", ЭтотОбъект, Неопределено);
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления",
																	"ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ОписаниеОповещения);
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
			
	Если СтандартнаяОбработка Тогда 
		ПредставлениеУведомленияВыборИзСписка(Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		ОбработкаКодаНО(Область.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыборИзСписка(Область, СтандартнаяОбработка) Экспорт 
	Строки = СпискиВыбора.НайтиСтроки(Новый Структура("ИДНаименования,ИмяПоля", ТекущееИДНаименования, Область.Имя));
	Если Строки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ЗагружаемыеКоды.Очистить();
	Для Каждого Стр Из Строки Цикл 
		НовСтр = ЗагружаемыеКоды.Добавить();
		НовСтр.Код = Стр.Код;
		НовСтр.Название = Стр.Наименование;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          "Выбор кода");
	ПараметрыФормы.Вставить("ТаблицаЗначений",    ЗагружаемыеКоды);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", Область.Значение));
	
	ДополнительныеПараметры = Новый Структура("Область", Область);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаСпискаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСпискаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Область = ДополнительныеПараметры.Область;
	Область.Значение = РезультатВыбора.Код;
	ПриИзмененииСодержимогоОбластиВыборИзСписка(Область);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСодержимогоОбластиВыборИзСписка(Область) Экспорт
	ОбластьИмя = Область.Имя;
	Модифицированность = Истина;
	Если ОбластьИмя = "ПрПолучатель" Тогда 
		ОбработкаПрПолучатель();
	КонецЕсли;
	
	Если ДанныеУведомления.Свойство(ТекущееИДНаименования)
		И ДанныеУведомления[ТекущееИДНаименования].Свойство(ОбластьИмя) Тогда 
		
		ДанныеУведомления[ТекущееИДНаименования].Вставить(ОбластьИмя, Область.Значение);
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПрПолучатель()
	Если ПредставлениеУведомления.Области.ПрПолучатель.Значение = "1" Тогда 
		ПредставлениеУведомления.Области.Л0107.Защита = Ложь;
		ПредставлениеУведомления.Области.ФамилияПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ФамилияПолучатель.Значение = "";
		ПредставлениеУведомления.Области.ИмяПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ИмяПолучатель.Значение = "";
		ПредставлениеУведомления.Области.ОтчествоПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ОтчествоПолучатель.Значение = "";
		ПредставлениеУведомления.Области.НаимОргЛицСч.Защита = Истина;
		ПредставлениеУведомления.Области.НаимОргЛицСч.Значение = "";
		ПредставлениеУведомления.Области.КБК.Защита = Истина;
		ПредставлениеУведомления.Области.КБК.Значение = "";
		ПредставлениеУведомления.Области.СчетПолучателя.Защита = Истина;
		ПредставлениеУведомления.Области.СчетПолучателя.Значение = "";
	ИначеЕсли ПредставлениеУведомления.Области.ПрПолучатель.Значение = "2" Тогда 
		ПредставлениеУведомления.Области.Л0107.Защита = Истина;
		ПредставлениеУведомления.Области.ФамилияПолучатель.Защита = Ложь;
		ПредставлениеУведомления.Области.ИмяПолучатель.Защита = Ложь;
		ПредставлениеУведомления.Области.ОтчествоПолучатель.Защита = Ложь;
		ПредставлениеУведомления.Области.НаимОргЛицСч.Защита = Истина;
		ПредставлениеУведомления.Области.НаимОргЛицСч.Значение = "";
		ПредставлениеУведомления.Области.КБК.Защита = Истина;
		ПредставлениеУведомления.Области.КБК.Значение = "";
		ПредставлениеУведомления.Области.СчетПолучателя.Защита = Истина;
		ПредставлениеУведомления.Области.СчетПолучателя.Значение = "";
	ИначеЕсли ПредставлениеУведомления.Области.ПрПолучатель.Значение = "3" Тогда 
		ПредставлениеУведомления.Области.Л0107.Защита = Истина;
		ПредставлениеУведомления.Области.ФамилияПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ФамилияПолучатель.Значение = "";
		ПредставлениеУведомления.Области.ИмяПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ИмяПолучатель.Значение = "";
		ПредставлениеУведомления.Области.ОтчествоПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ОтчествоПолучатель.Значение = "";
		ПредставлениеУведомления.Области.НаимОргЛицСч.Защита = Ложь;
		ПредставлениеУведомления.Области.КБК.Защита = Ложь;
		ПредставлениеУведомления.Области.СчетПолучателя.Защита = Ложь;
	Иначе
		ПредставлениеУведомления.Области.Л0107.Защита = Истина;
		ПредставлениеУведомления.Области.Л0107.Значение = "";
		ПредставлениеУведомления.Области.ФамилияПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ФамилияПолучатель.Значение = "";
		ПредставлениеУведомления.Области.ИмяПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ИмяПолучатель.Значение = "";
		ПредставлениеУведомления.Области.ОтчествоПолучатель.Защита = Истина;
		ПредставлениеУведомления.Области.ОтчествоПолучатель.Значение = "";
		ПредставлениеУведомления.Области.НаимОргЛицСч.Защита = Истина;
		ПредставлениеУведомления.Области.НаимОргЛицСч.Значение = "";
		ПредставлениеУведомления.Области.КБК.Защита = Истина;
		ПредставлениеУведомления.Области.КБК.Значение = "";
		ПредставлениеУведомления.Области.СчетПолучателя.Защита = Истина;
		ПредставлениеУведомления.Области.СчетПолучателя.Значение = "";
	КонецЕсли;
	
	ДанныеУведомления.Лист001_2018.ФамилияПолучатель = ПредставлениеУведомления.Области.ФамилияПолучатель.Значение;
	ДанныеУведомления.Лист001_2018.ИмяПолучатель = ПредставлениеУведомления.Области.ИмяПолучатель.Значение;
	ДанныеУведомления.Лист001_2018.ОтчествоПолучатель = ПредставлениеУведомления.Области.ОтчествоПолучатель.Значение;
	ДанныеУведомления.Лист001_2018.Л0107 = ПредставлениеУведомления.Области.Л0107.Значение;
	ДанныеУведомления.Лист001_2018.КБК = ПредставлениеУведомления.Области.КБК.Значение;
	ДанныеУведомления.Лист001_2018.СчетПолучателя = ПредставлениеУведомления.Области.СчетПолучателя.Значение;
	ДанныеУведомления.Лист001_2018.НаимОргЛицСч = ПредставлениеУведомления.Области.НаимОргЛицСч.Значение;
	
	ПредставлениеУведомления.Области.ФамилияПолучатель.ЦветФона = ?(ПредставлениеУведомления.Области.ФамилияПолучатель.Защита, ЦФБ, ЦФЖ);
	ПредставлениеУведомления.Области.ИмяПолучатель.ЦветФона = ?(ПредставлениеУведомления.Области.ИмяПолучатель.Защита, ЦФБ, ЦФЖ);
	ПредставлениеУведомления.Области.ОтчествоПолучатель.ЦветФона = ?(ПредставлениеУведомления.Области.ОтчествоПолучатель.Защита, ЦФБ, ЦФЖ);
	ПредставлениеУведомления.Области.НаимОргЛицСч.ЦветФона = ?(ПредставлениеУведомления.Области.НаимОргЛицСч.Защита, ЦФБ, ЦФЖ);
	ПредставлениеУведомления.Области.КБК.ЦветФона = ?(ПредставлениеУведомления.Области.КБК.Защита, ЦФБ, ЦФЖ);
	ПредставлениеУведомления.Области.СчетПолучателя.ЦветФона = ?(ПредставлениеУведомления.Области.СчетПолучателя.Защита, ЦФБ, ЦФЖ);
	ПредставлениеУведомления.Области.Л0107.ЦветФона = ?(ПредставлениеУведомления.Области.Л0107.Защита, ЦФБ, ЦФЖ);
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
	Если Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УведомлениеОбъект = Объект.Ссылка.ПолучитьОбъект();
		Если УведомлениеОбъект.Заблокирован() Тогда 
			УведомлениеОбъект.Разблокировать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
	КонецЕсли;
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
	СтруктураВыгрузки.Вставить("Данные", УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетДвоичныхДанных(Объект.ИмяОтчета, "TIFF_2018_1"));
	СтруктураВыгрузки.Вставить("ИмяФайла", "1150058_5.02000_02.tif");
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
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибок не обнаружено");
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
Функция ПолучитьТаблицуОсобыхПолей()
	ТаблицаОсобыхПолейВВыгрузке = УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПутейВВыгрузке();
	
	НовСтр = ТаблицаОсобыхПолейВВыгрузке.Добавить();
	НовСтр.ПутьXML = "Файл/Документ/ЗВИУН/НомерСтНК";
	
	НовСтр = ТаблицаОсобыхПолейВВыгрузке.Добавить();
	НовСтр.ПутьXML = "Файл/Документ/ЗВИУН/ИзлУплНал/НалПериод";
	
	Возврат ТаблицаОсобыхПолейВВыгрузке;
КонецФункции

&НаСервере
Процедура ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML)
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТаблицаОсобыхПолейВВыгрузке", ПолучитьТаблицуОсобыхПолей());
	
	ДеревоЗагрузки = УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЗагрузки(ПараметрыЗагрузкиXML.ПредставлениеXML);
	СхемаВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2018_1");
	УведомлениеОСпецрежимахНалогообложения.УстановитьОрганизациюПоПараметрамЗагрузки(ЭтотОбъект, ПараметрыЗагрузкиXML);
	
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьОбычныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	Если Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		ДанныеУведомления.Титульная_2018.Наименование = УведомлениеОСпецрежимахНалогообложения.ПолучитьНаименованиеИПИзВыгрузки(ДеревоЗагрузки);
	КонецЕсли;
	
	Если ДанныеУведомления.Лист001_2018.ПрПолучатель = "2" Тогда 
		ДанныеУведомления.Лист001_2018.Л0107 = ДанныеУведомления.Лист001_2018.ФамилияПолучатель + " "
		+ ДанныеУведомления.Лист001_2018.ИмяПолучатель + " " + ДанныеУведомления.Лист001_2018.ОтчествоПолучатель;
	ИначеЕсли ДанныеУведомления.Лист001_2018.ПрПолучатель = "3" Тогда 
		ДанныеУведомления.Лист001_2018.Л0107 = ДанныеУведомления.Лист001_2018.НаимОргЛицСч;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОсобаяОбработкаЭлементов(Путь, СтрЗагружаемоеЗначение, Страница) Экспорт 
	Если Путь = "Файл/Документ/ЗВИУН/НомерСтНК" Тогда 
		ИндексТочки = СтрНайти(СтрЗагружаемоеЗначение.ЗначениеЭлемента, ".");
		Если ИндексТочки = 0 Тогда
			Страница.Пункт = СтрЗагружаемоеЗначение.ЗначениеЭлемента;
		Иначе
			Страница.Пункт = Лев(СтрЗагружаемоеЗначение.ЗначениеЭлемента, ИндексТочки - 1);
			Страница.Подпункт = Сред(СтрЗагружаемоеЗначение.ЗначениеЭлемента, ИндексТочки + 1);
		КонецЕсли;
	ИначеЕсли Путь = "Файл/Документ/ЗВИУН/ИзлУплНал/НалПериод" Тогда
		Если СтрДлина(СтрЗагружаемоеЗначение.ЗначениеЭлемента) = 10 Тогда
			Страница.КодПериода = Лев(СтрЗагружаемоеЗначение.ЗначениеЭлемента, 2);
			Страница.Месяц = Сред(СтрЗагружаемоеЗначение.ЗначениеЭлемента, 4, 2);
			Страница.Год = Прав(СтрЗагружаемоеЗначение.ЗначениеЭлемента, 4);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомление(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ЗагрузитьИзФайлаУведомление(ЭтотОбъект);
КонецПроцедуры
