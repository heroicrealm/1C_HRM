
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоОбособленноеПодразделение = Ложь;
	ЭтоФизическоеЛицо            = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда 
		
		Элементы.Владелец.ТолькоПросмотр = Истина;
		Элементы.Владелец.КнопкаОткрытия = Ложь;
		Элементы.Владелец.КнопкаВыбора = Ложь;
		Элементы.Владелец.АвтоОтметкаНезаполненного = Ложь;
		Элементы.Владелец.ЦветРамки = ЦветаСтиля.ЦветФонаФормы;
		Элементы.Владелец.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
		Элементы.Владелец.ЦветТекста = Новый Цвет(122, 87, 0);
		
		Если Объект.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено
			И Объект.Владелец.Метаданные().Реквизиты.Найти("ОбособленноеПодразделение")	<> Неопределено Тогда 
	
			РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец, "ЮридическоеФизическоеЛицо, ОбособленноеПодразделение");
			
			ЭтоОбособленноеПодразделение = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо
				И РеквизитыОрганизации.ОбособленноеПодразделение;
						
		КонецЕсли;
		
		ЭтоФизическоеЛицо = ЭтоФизическоеЛицо();
			
	КонецЕсли;
	
	Элементы.КПП.Видимость = НЕ ЭтоФизическоеЛицо;
	
	Если ЭтоОбособленноеПодразделение Тогда
		
		ГоловнаяОрганизация = РегламентированнаяОтчетность.ГоловнаяОрганизация(Объект.Владелец);
				
	Иначе
		
		Элементы.Владелец.Заголовок	= НСтр("ru = 'Организация'");
		Элементы.ГоловнаяОрганизация.Видимость = Ложь;
		Элементы.НаименованиеОбособленногоПодразделения.Видимость = Ложь;
		Элементы.ПодсказкаНаименованиеОбособленногоПодразделения.Видимость = Ложь;
	
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
				
		Элементы.Владелец.Видимость = Ложь;
		
	КонецЕсли;
		
	ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(Объект.Представитель), 1, 0);	
	
	Если ЭтоФизическоеЛицо Тогда
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Индивидуальный предприниматель'");
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Модифицированность = Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		Если ВыбранноеЗначение.Свойство("Представитель") Тогда
			ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(Объект.Представитель), 1, 0);
		КонецЕсли;
	
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОтчетностьПодписываетПредставитель = 1
		И НЕ ЗначениеЗаполнено(Объект.Представитель) Тогда
		
		ТекстСообщения = НСтр("ru = 'Заполните сведения о представителе'"); 
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ПредставлениеПредставителя",, Отказ);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("НовыйЭлемент", ТекущийОбъект.Ссылка.Пустая());
	
	Если ОтчетностьПодписываетПредставитель = 0 Тогда
		ТекущийОбъект.Представитель						= Неопределено;
		ТекущийОбъект.УполномоченноеЛицоПредставителя	= "";
		ТекущийОбъект.ДокументПредставителя				= "";
		ТекущийОбъект.Доверенность						= "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура("Ссылка, Владелец", Объект.Ссылка, Объект.Владелец);
	
	Оповестить("ИзмененаРегистрацияВНалоговомОргане", ПараметрОповещения);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КПППриИзменении(Элемент)

	Объект.Код	= Лев(СокрЛ(Объект.КПП), 4);

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)

	Если ПустаяСтрока(Объект.НаименованиеИФНС) Тогда
		
		НаименованиеИФНС = Объект.Наименование;
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='МИФНС'"),	НСтр("ru='Межрайонная инспекция федеральной налоговой службы'"));
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='ИФНС'"),	НСтр("ru='Инспекция федеральной налоговой службы'"));
		НаименованиеИФНС = СтрЗаменить(НаименованиеИФНС,	НСтр("ru='ФНС'"),	НСтр("ru='Федеральная налоговая служба'"));
		
		Объект.НаименованиеИФНС	= НаименованиеИФНС;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетностьПодписываетПредставительПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПредставителяНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначенияЗаполнения = Новый Структура("Владелец,Представитель,УполномоченноеЛицоПредставителя,ДокументПредставителя,Доверенность");
	ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, Объект);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.Форма.ФормаПредставителя", ПараметрыФормы, ЭтаФорма, КлючУникальности);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПоОКАТОПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КодПоОКАТО) Тогда
		
		ДлинаЗначения = СтрДлина(СокрЛП(Объект.КодПоОКАТО));
		
		Для Инд = ДлинаЗначения + 1 По 11 Цикл
			
			Объект.КодПоОКАТО = СокрЛП(Объект.КодПоОКАТО) + "0";
			
		КонецЦикла;
		
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Форма.ОтчетностьПодписываетПредставитель = 1 Тогда
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительГиперссылка;
	Иначе
		Форма.Элементы.ГруппаПредставлениеПредставителяСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПредставительНеВыбран;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Представитель) Тогда
		Форма.ПредставлениеПредставителя = НСтр("ru = 'Заполнить'");
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.ФизическиеЛица")
		ИЛИ НЕ ЗначениеЗаполнено(Объект.УполномоченноеЛицоПредставителя) Тогда
		Форма.ПредставлениеПредставителя = Объект.Представитель;
	ИначеЕсли ТипЗнч(Объект.Представитель) = Тип("СправочникСсылка.Контрагенты") Тогда
		Форма.ПредставлениеПредставителя = Объект.УполномоченноеЛицоПредставителя + " (" + Объект.Представитель + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
		
	Если ЭтоФизическоеЛицо() Тогда
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Индивидуальный предприниматель'");
		
	Иначе	
		
		Элементы.ОтчетностьПодписываетПредставитель.СписокВыбора[0].Представление = НСтр("ru='Руководитель'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЭтоФизическоеЛицо()
	
	Если Объект.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено
	   И Объект.Владелец.Метаданные().Реквизиты.Найти("ОбособленноеПодразделение") <> Неопределено Тогда 
		
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец, "ЮридическоеФизическоеЛицо, ОбособленноеПодразделение");
		
		Возврат РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти