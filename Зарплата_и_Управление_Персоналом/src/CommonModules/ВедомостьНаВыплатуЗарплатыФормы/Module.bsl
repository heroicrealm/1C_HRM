////////////////////////////////////////////////////////////////////////////////
// Ведомости на выплату зарплаты.
// Серверные процедуры и функции форм.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ФормаСписка

// Устанавливает условное оформление формы списка ведомостей.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, которая создается.
//
Процедура УстановитьУсловноеОформлениеФормыСписка(Форма) Экспорт
	
	Если Форма.Элементы.Список.РежимВыбора Тогда
		Возврат
	КонецЕсли;	

	ЭлементОформления = Форма.Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование	= Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЕстьОплаты");
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры	

#КонецОбласти

#Область ФормаДокумента

#Область ОбработчикиСобытийФормы

// Обработчик события ПриСозданииНаСервере.
// 	Устанавливает первоначальные значения реквизитов объекта.
//	Инициализирует реквизиты формы.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, которая создается.
// 	Отказ - Булево - признак отказа от создания формы.
// 	СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
// 	ЗначенияДляЗаполнения - структура с дополнительными заполняемыми реквизитами.
//		Имя элемента структуры идентифицирует значение, которое необходимо заполнить.
//		Значение элемента структуры - путь к реквизиту формы, значение которого необходимо заполнить.
//		Необязательный параметр.
//		По умолчанию заполняются:
//			ПериодРегистрации
//			Организация
//			Подразделение
//			Ответственный
//			ГлавныйБухгалтер
//			Руководитель
//			ДолжностьРуководителя
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Первоначальное заполнение объекта.
	Если Форма.Параметры.Ключ.Пустая() Тогда
		
		Форма.ЗаполнитьПервоначальныеЗначения();
		Форма.ПриПолученииДанныхНаСервере(Форма.РеквизитФормыВЗначение("Объект"));
		
	КонецЕсли;
	
	// Для ведомостей из "старого" учета скрываем часть полей.
	Если Форма.Объект.ВводНачальныхДанных Тогда
		
		ОбщегоНазначенияБЗККлиентСервер.УстановитьСвойствоЭлементовФормы(
			Форма,
			"Подразделение,
			|Ответственный,
			|ВыплачиватьГруппа,
			|Заполнить,
			|Подобрать,
			|ОбновитьНДФЛ,
			|ПодписиГруппа",
			"Видимость",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы, 
			"ВводНачальныхДанных", 
			"Видимость", 
			Истина);
		
	КонецЕсли;	
	
КонецПроцедуры

// Обработчик события ПриЧтенииНаСервере.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, которая создается.
// 	ТекущийОбъект - читаемый объект.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	Форма.ПриПолученииДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

// Обработчик события ОбработкаПроверкиЗаполненияНаСервере.
// 	Инициирует проверку заполнения объекта.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие.
//	Отказ - булево - признак отказа от записи 
//	ПроверяемыеРеквизиты - массив - пути к реквизитам, для которых будет выполнена проверка заполнения.
//	
Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	ТекущийОбъект = Форма.РеквизитФормыВЗначение("Объект");
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Форма.ОбработатьСообщенияПользователю();
		Отказ = Истина
	КонецЕсли;	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");
КонецПроцедуры

// Обработчик события ПослеЗаписиНаСервере.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие.
// 	ТекущийОбъект - ДокументОбъект - записываемый объект.
//	ПараметрыЗаписи - структура - параметры записи.
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	Форма.ПриПолученииДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Серверная часть обработчика события изменения способа выплаты формы документа.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения.
//
Процедура СпособВыплатыПриИзмененииНаСервере(Форма) Экспорт
	
	Если Форма.Объект.СпособВыплаты <> Форма.СпособВыплаты.Ссылка Тогда
		НовыйСпособВыплаты = Форма.Объект.СпособВыплаты.ПолучитьОбъект();
		Форма.ЗначениеВРеквизитФормы(НовыйСпособВыплаты, "СпособВыплаты");
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

Процедура СоставОбработкаВыбораНаСервере(Форма, Знач ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		ВыбранныеФизЛица = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	Иначе
		ВыбранныеФизЛица = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВыбранноеЗначение)
	КонецЕсли;
	
	ФизическиеЛица = Новый Массив;
	Для Каждого ФизическоеЛицо Из ВыбранныеФизЛица Цикл
		
		СтрокиФизЛица = Форма.Объект.Состав.НайтиСтроки(Новый Структура("ФизическоеЛицо", ФизическоеЛицо));
		
		Если СтрокиФизЛица.Количество() = 0 Тогда
			ФизическиеЛица.Добавить(ФизическоеЛицо)
		КонецЕсли;
		
	КонецЦикла;
	
	Если ФизическиеЛица.Количество() > 0 Тогда
		ДополнитьНаСервере(Форма, ФизическиеЛица);
	КонецЕсли;
	
КонецПроцедуры	

Процедура СоставПриИзмененииНаСервере(Форма) Экспорт
	
	// Из Состав в Зарплата переносятся значения имеющихся в Зарплата реквизитов
	
	РеквизитыЗарплата = Форма.Объект.Ссылка.Метаданные().ТабличныеЧасти.Зарплата.Реквизиты;
	ПоляСостава	= Новый Массив;
	Для Каждого РеквизитСостава Из Форма.Объект.Ссылка.Метаданные().ТабличныеЧасти.Состав.Реквизиты Цикл
		Если РеквизитыЗарплата.Найти(РеквизитСостава.Имя) <> Неопределено Тогда
			ПоляСостава.Добавить(РеквизитСостава.Имя);
		КонецЕсли	
	КонецЦикла;	
	СписокСвойств = СтрСоединить(ПоляСостава, ", ");
	
	СтрокаСостава = Форма.Объект.Состав.НайтиПоИдентификатору(Форма.Элементы.Состав.ТекущаяСтрока);
	ИзменяемыеСтроки = Форма.Объект.Зарплата.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки));
	Для Каждого СтрокаЗарплаты Из ИзменяемыеСтроки Цикл
		ЗаполнитьЗначенияСвойств(СтрокаЗарплаты, СтрокаСостава, СписокСвойств)
	КонецЦикла;	
	
КонецПроцедуры	

Процедура СоставПослеУдаленияНаСервере(Форма) Экспорт
	
	Для Каждого ИдентификаторСтроки Из Форма.ИдентификаторыСтрок Цикл
		
		ПараметрыОтбора = Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки);
		
		УдаляемыеСтроки = Форма.Объект.Зарплата.НайтиСтроки(ПараметрыОтбора);
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			Форма.Объект.Зарплата.Удалить(УдаляемаяСтрока);
		КонецЦикла;	
		
		УдаляемыеСтроки = Форма.Объект.НДФЛ.НайтиСтроки(ПараметрыОтбора);
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			Форма.Объект.НДФЛ.Удалить(УдаляемаяСтрока);
		КонецЦикла;	
		
	КонецЦикла;
	
	УстановитьИтогНДФЛ(Форма);
	
КонецПроцедуры	

Процедура СоставКВыплатеПриИзмененииНаСервере(Форма) Экспорт
	
	СтрокаСостава = Форма.Объект.Состав.НайтиПоИдентификатору(Форма.Элементы.Состав.ТекущаяСтрока);
	ЗарплатаСтрокиСостава = Форма.Объект.Зарплата.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки));
	
	ЗарплатаКадры.РазнестиСуммуПоБазе(СтрокаСостава.КВыплатеСумма, ЗарплатаСтрокиСостава, "КВыплате");
	
КонецПроцедуры	

#КонецОбласти

// Вызывается при создании формы новой ведомости.
// Выполняет заполнение первоначальных значений реквизитов ведомости в форме.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения.
//
Процедура ЗаполнитьПервоначальныеЗначения(Форма) Экспорт
	
	ЗначенияДляЗаполнения = Новый Структура;
	ЗначенияДляЗаполнения.Вставить("МесяцРасчета",  "Объект.ПериодРегистрации");
	ЗначенияДляЗаполнения.Вставить("Организация",   "Объект.Организация");
	ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
	ЗначенияДляЗаполнения.Вставить("Ответственный", "Объект.Ответственный");
	
	ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(Форма, ЗначенияДляЗаполнения);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.СпособВыплаты", Справочники.СпособыВыплатыЗарплаты.ПоУмолчанию(), Истина);
	
	Форма.ЗначениеВРеквизитФормы(Форма.Объект.СпособВыплаты.ПолучитьОбъект(), "СпособВыплаты");
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.Округление", Форма.СпособВыплаты.Округление, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "Объект.Округление", Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию(), Истина);
	
КонецПроцедуры

// Вызывается при получении формой данных объекта.
// 	Приспосабливаем форму к редактируемым данным.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения.
//	ТекущийОбъект - Объект, который будет прочитан, ДокументОбъект. 
//
Процедура ПриПолученииДанныхНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	СпособВыплаты = ?(ЗначениеЗаполнено(Форма.Объект.СпособВыплаты), 
		Форма.Объект.СпособВыплаты.ПолучитьОбъект(), 
		Неопределено);
	Если СпособВыплаты <> Неопределено Тогда
		Форма.ЗначениеВРеквизитФормы(СпособВыплаты, "СпособВыплаты");
	КонецЕсли;	
	
	Для Каждого СтрокаСостава Из Форма.Объект.Состав Цикл
		Форма.ПриПолученииДанныхСтрокиСостава(СтрокаСостава);
	КонецЦикла;
	
	Форма.УстановитьДоступностьЭлементов();
	Форма.УстановитьПредставлениеОплаты();
	УстановитьИтогНДФЛ(Форма);
	
	ОписаниеКлючевыхРеквизитов = Форма.КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов();
	ТаблицыОчищаемыеПриИзменении = Форма.КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении();
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(Форма, , ОписаниеКлючевыхРеквизитов, ТаблицыОчищаемыеПриИзменении);
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(Форма, ОписаниеКлючевыхРеквизитов);
	
КонецПроцедуры

Процедура ПриПолученииДанныхСтрокиСостава(Форма, СтрокаСостава) Экспорт
	ПриПолученииДанныхСтрокиСоставаКВыплате(Форма, СтрокаСостава);
	ПриПолученииДанныхСтрокиСоставаНДФЛ(Форма, СтрокаСостава);
КонецПроцедуры

Процедура ПриПолученииДанныхСтрокиСоставаКВыплате(Форма, СтрокаСостава) 
	
	ПериодРегистрацииВедомости = Форма.Объект.ПериодРегистрации;
	
	СтрокиЗарплатыРаботника = Форма.Объект.Зарплата.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки));
	
	СтрокаСостава.КВыплатеСумма = Форма.Объект.Зарплата.Выгрузить(СтрокиЗарплатыРаботника, "КВыплате").Итог("КВыплате");;
	
	РабочиеМеста = Форма.Объект.Зарплата.Выгрузить(СтрокиЗарплатыРаботника, "Сотрудник, Подразделение");
	РабочиеМеста.Свернуть("Сотрудник, Подразделение");
	РасшифровкаРабочихМест = "";
	Если РабочиеМеста.Количество() > 1 Тогда
		РасшифровкаРабочихМест = НРег(ЧислоПрописью(РабочиеМеста.Количество(),,НСтр("ru = 'рабочее место, рабочих места, рабочих мест, с, ,,,,0'")));;
	КонецЕсли;
	
	ПериодыВзаиморасчетов = Форма.Объект.Зарплата.Выгрузить(СтрокиЗарплатыРаботника, "ПериодВзаиморасчетов");
	ПериодыВзаиморасчетов.Свернуть("ПериодВзаиморасчетов");
	РасшифровкаПериодов = "";
	Если ПериодыВзаиморасчетов.Количество() = 1 И ПериодыВзаиморасчетов.Найти(ПериодРегистрацииВедомости) <> Неопределено Тогда
		// Единственный период, совпадающий с периодом ведомости - комментировать нечего
	ИначеЕсли ПериодыВзаиморасчетов.Количество() = 1 Тогда
		// Единственный период, не совпадающий с периодом ведомости
		ПредставлениеПериода = НРег(ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(ПериодыВзаиморасчетов[0].ПериодВзаиморасчетов));
		РасшифровкаПериодов = СтрШаблон(НСтр("ru = 'за %1'"), ПредставлениеПериода);
	Иначе
		// Периодов несколько, есть отличающиеся от периода ведомости
		ПериодыВзаиморасчетов.Сортировать("ПериодВзаиморасчетов");
		ПредставлениеПериодов = "";
		Для Индекс = 0 По ПериодыВзаиморасчетов.Количество()-1 Цикл
			
			// период ведомости в комментарий не включаем
			Если ПериодыВзаиморасчетов[Индекс].ПериодВзаиморасчетов = ПериодРегистрацииВедомости Тогда
				Продолжить
			КонецЕсли;
			
			Если Индекс = 3 Тогда
				ПредставлениеПериодов = ПредставлениеПериодов + "...";
				Прервать
			ИначеЕсли Индекс > 0 Тогда
				ПредставлениеПериодов = ПредставлениеПериодов + ", ";
			КонецЕсли;

			ПредставлениеПериодов = ПредставлениеПериодов + НРег(ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(ПериодыВзаиморасчетов[Индекс].ПериодВзаиморасчетов));
			
		КонецЦикла;	
		
		РасшифровкаПериодов = СтрШаблон(НСтр("ru = 'в т.ч. за %1'"), ПредставлениеПериодов);
		
	КонецЕсли;	
	
	СтрокаСостава.КВыплатеРасшифровка = "";
	Если ЗначениеЗаполнено(РасшифровкаПериодов) Тогда
		СтрокаСостава.КВыплатеРасшифровка = СтрокаСостава.КВыплатеРасшифровка + РасшифровкаПериодов
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РасшифровкаРабочихМест) Тогда
		СтрокаСостава.КВыплатеРасшифровка = 
			СтрокаСостава.КВыплатеРасшифровка
			+ ?(ЗначениеЗаполнено(СтрокаСостава.КВыплатеРасшифровка), "; "+Символы.ПС, "")
			+ РасшифровкаРабочихМест;
	КонецЕсли;

КонецПроцедуры	

Процедура ПриПолученииДанныхСтрокиСоставаНДФЛ(Форма, СтрокаСостава)
	
	ВыплачиваетсяАванс = Форма.СпособВыплаты.ХарактерВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс;
	ВыплачиваетсяЗарплата = Форма.СпособВыплаты.ХарактерВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
	
	ОсновныеКатегории = Новый Массив;
	ОснованияАванса = Новый Соответствие;
	Если ВыплачиваетсяАванс Тогда
		ОсновныеКатегории = Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда();
		ОснованияАванса = РасчетЗарплаты.ТипыДокументовНачисленияАванса();
	ИначеЕсли ВыплачиваетсяЗарплата Тогда
		ОсновныеКатегории = Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда();
	Иначе	
		ОсновныеКатегории = Перечисления.КатегорииДоходовНДФЛ.Прочие();
	КонецЕсли;	
		
	СтрокиНДФЛРаботника = Форма.Объект.НДФЛ.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки));
	
	СтрокаСостава.НДФЛСумма = 0;
	СтрокаСостава.НДФЛРасшифровка = "";
	
	ТипыОснований    = Новый Массив;
	КатегорииДоходов = Новый Массив;
	Для Каждого СтрокаНДФЛРаботника Из СтрокиНДФЛРаботника Цикл
		
		СтрокаСостава.НДФЛСумма = СтрокаСостава.НДФЛСумма + СтрокаНДФЛРаботника.Сумма + СтрокаНДФЛРаботника.СуммаСПревышения;
		
		ТипОснования = ТипЗнч(СтрокаНДФЛРаботника.ДокументОснование);
		Если ВыплачиваетсяАванс И ЗначениеЗаполнено(СтрокаНДФЛРаботника.ДокументОснование) И ОснованияАванса[ТипОснования] = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				ТипыОснований,
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипОснования),
				Истина);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(СтрокаНДФЛРаботника.КатегорияДохода) Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				КатегорииДоходов,
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаНДФЛРаботника.КатегорияДохода),
				Истина);
		КонецЕсли	
		
	КонецЦикла;
	
	РасшифровкаКатегорий = "";
	РасшифровкаОснований = "";
	
	ПрочиеКатегории = ОбщегоНазначенияКлиентСервер.РазностьМассивов(КатегорииДоходов, ОсновныеКатегории);
	Если ПрочиеКатегории.Количество() > 3 Тогда
		ВыводимыеКатегории = ОбщегоНазначенияБЗККлиентСервер.СрезМассива(ПрочиеКатегории, 0, 2);
		РасшифровкаКатегорий = СтрШаблон(НСтр("ru = 'в т.ч. %1 ...'"), СтрСоединить(ВыводимыеКатегории, ", "));
	ИначеЕсли ПрочиеКатегории.Количество() > 0 Тогда	
		Шаблон = ?(КатегорииДоходов.Количество() > ПрочиеКатегории.Количество(), НСтр("ru = 'в т.ч. %1'"), НСтр("ru = '%1'")); 
		РасшифровкаКатегорий = СтрШаблон(Шаблон, СтрСоединить(ПрочиеКатегории, ", "));
	КонецЕсли;
	
	Если ВыплачиваетсяАванс И ТипыОснований.Количество() > 0 Тогда
		
		ВыводимыеОснования = Новый Массив;
		Для Каждого ТипОснования Из ОбщегоНазначенияБЗККлиентСервер.СрезМассива(ТипыОснований, 0, 2) Цикл
			МетаданныеОснования = Метаданные.НайтиПоТипу(ТипОснования);
			ПредставлениеОснования = МетаданныеОснования.ПредставлениеОбъекта;
			Если ПустаяСтрока(ПредставлениеОснования) Тогда
				ПредставлениеОснования = МетаданныеОснования.Представление();
			КонецЕсли;
			ВыводимыеОснования.Добавить(ПредставлениеОснования);
		КонецЦикла;	
			
		Если ТипыОснований.Количество() > 3 Тогда
			ШаблонОснований = НСтр("ru = 'за %1 ...'");
		Иначе
			ШаблонОснований = НСтр("ru = 'за %1.'");
		КонецЕсли;
		
		РасшифровкаОснований = СтрШаблон(ШаблонОснований, СтрСоединить(ВыводимыеОснования, ", "));
		
	КонецЕсли;	
	
	НДФЛРасшифровка = Новый Массив;
	Если ЗначениеЗаполнено(РасшифровкаКатегорий) Тогда
		НДФЛРасшифровка.Добавить(НРег(РасшифровкаКатегорий))
	КонецЕсли;
	Если ЗначениеЗаполнено(РасшифровкаОснований) Тогда
		НДФЛРасшифровка.Добавить(НРег(РасшифровкаОснований))
	КонецЕсли;
	СтрокаСостава.НДФЛРасшифровка = СтрСоединить(НДФЛРасшифровка, "; "+Символы.ПС);
	
КонецПроцедуры	

// Обработка сообщений пользователю для форм ведомостей.
// 	Привязывает сообщения объекта к полям формы.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения.
//
Процедура ОбработатьСообщенияПользователю(Форма) Экспорт
	
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	
	Для Каждого Сообщение Из Сообщения Цикл
		Если СтрНайти(Сообщение.Поле, "ПериодРегистрации") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПериодРегистрацииСтрокой";
		КонецЕсли;
		Если СтрНайти(Сообщение.Поле, "Округление") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПараметрыРасчетаИнфо";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает доступность элементов формы ведомости.
// 	Документ ввода начальных остатков, или по ведомость, по которой есть выплаты
//	доступны только для просмотра.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения.
//
Процедура УстановитьДоступностьЭлементов(Форма) Экспорт
	
	Форма.ТолькоПросмотр = 
		ЗначениеЗаполнено(Форма.Объект.Ссылка) 
		И (ДатыЗапретаИзменения.ИзменениеЗапрещено(Форма.Объект.Ссылка.Метаданные().ПолноеИмя(), Форма.Объект.Ссылка) 
			ИЛИ Форма.Объект.ВводНачальныхДанных 
			ИЛИ ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(Форма.Объект.Ссылка)
			ИЛИ Не ОбменСБанкамиПоЗарплатнымПроектам.ДоступностьПлатежногоДокумента(Форма.Объект.Ссылка));
	
КонецПроцедуры

Процедура УстановитьПредставлениеОплаты(Форма) Экспорт
	
	ЕстьОплаты  = ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(Форма.Объект.Ссылка);
	СписокОплат = СписокОплат(Форма);
	                            
	Форма.ОплатыСписок        = СписокОплат;
	Форма.ОплатыПредставление = ПредставлениеОплаты(ЕстьОплаты, СписокОплат)
	
КонецПроцедуры

Процедура УстановитьИтогНДФЛ(Форма)
	
	Форма.ИтогНДФЛ = Форма.Объект.НДФЛ.Итог("Сумма") + Форма.Объект.НДФЛ.Итог("СуммаСПревышения");
	
КонецПроцедуры

Функция СписокОплат(Форма)
	
	СписокОплат = Новый СписокЗначений;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ОплатаВедомостейНаВыплатуЗарплаты) Тогда
		Возврат СписокОплат
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ведомость", Форма.Объект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ОплатаВедомостей.Регистратор КАК Регистратор,
	|	ОплатаВедомостей.ФизическоеЛицо КАК ФизЛицо
	|ИЗ
	|	РегистрСведений.ОплатаВедомостейНаВыплатуЗарплаты КАК ОплатаВедомостей
	|ГДЕ
	|	ОплатаВедомостей.Ведомость = &Ведомость
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	ФизЛицо";
	
	Оплаты = Запрос.Выполнить().Выгрузить();
	Оплаты.Индексы.Добавить("Регистратор");
	
	Регистраторы = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Оплаты.ВыгрузитьКолонку("Регистратор"));
	РеквизитыРегистратора = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Регистраторы, "Номер, Дата");
	
	ШаблонПредставления = НСтр("ru = '%1 №%2 от %3 - %4'");
	Для Каждого Регистратор Из Регистраторы Цикл
		
		ФизЛица = Оплаты.Скопировать(Новый Структура("Регистратор", Регистратор), "ФизЛицо").ВыгрузитьКолонку("ФизЛицо");
		
		Представление = 
			СтрШаблон(
				ШаблонПредставления,
				Регистратор.Метаданные().Представление(),
				РеквизитыРегистратора[Регистратор].Номер, 
				Формат(РеквизитыРегистратора[Регистратор].Дата, "ДЛФ=Д"),
				ЗарплатаКадры.КраткийСоставФизЛиц(ФизЛица, РеквизитыРегистратора[Регистратор].Дата));
		
		СписокОплат.Добавить(Регистратор, Представление);
		
	КонецЦикла;	
	
	Возврат СписокОплат
	
КонецФункции	

Функция ПредставлениеОплаты(ЕстьОплаты, СписокОплат)  
	
	Если Не ЕстьОплаты Тогда
		
		ПредставлениеОплаты = Новый ФорматированнаяСтрока(НСтр("ru = 'Выплаты по ведомости не выполнялись'"));
	
	ИначеЕсли ЕстьОплаты И СписокОплат.Количество() = 0 Тогда
		
		ПредставлениеОплаты = Новый ФорматированнаяСтрока(НСтр("ru = 'По ведомости выполнялись выплаты'"));
		
	ИначеЕсли СписокОплат.Количество() = 1 Тогда	
		
		ПредставлениеДокумента = 
			НРег(Лев(СписокОплат[0].Представление, 1))
			+ Сред(СписокОплат[0].Представление, 2, СтрНайти(СписокОплат[0].Представление, " - ") - 2);
			
		ПредставлениеОплаты = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Выплата по ведомости выполнена документом'"),
			" ",
			Новый ФорматированнаяСтрока(ПредставлениеДокумента, , , , "ссылка"));
		
	Иначе
		
		ПредставлениеОплаты = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Выплаты по ведомости:'"),
			" ",
			Новый ФорматированнаяСтрока(
				НРег(ЧислоПрописью(СписокОплат.Количество(),,НСтр("ru = 'документ, документа, документов, м, ,,,,0'"))),
				, , , "ссылка"));
				
	КонецЕсли;	
	
	Возврат ПредставлениеОплаты
	
КонецФункции

Процедура ЗаполнитьНаСервере(Форма) Экспорт
	
	МенеджерВедомости = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Форма.Объект.Ссылка);
	ПараметрыЗаполнения = МенеджерВедомости.ПараметрыЗаполненияПоОбъекту(Форма.Объект);
	
	Зарплата = ВедомостьНаВыплатуЗарплаты.ЗарплатаКВыплате(
		ПараметрыЗаполнения.ОписаниеОперации,
		ПараметрыЗаполнения.ОтборСотрудников,
		ПараметрыЗаполнения.ПараметрыРасчетаЗарплаты,
		ПараметрыЗаполнения.Финансирование,
		Форма.Объект.Ссылка);
		
	НДФЛ = ВедомостьНаВыплатуЗарплаты.НалогиКУдержанию(
		Зарплата, 
		ПараметрыЗаполнения.ОписаниеОперации, 
		ПараметрыЗаполнения.ПараметрыРасчетаНДФЛ, 
		ПараметрыЗаполнения.Финансирование,
		Форма.Объект.Ссылка);

	Ведомость = Форма.РеквизитФормыВЗначение("Объект");
	
	Ведомость.ЗагрузитьВыплаты(Зарплата, НДФЛ);
	
	Форма.ОбработатьСообщенияПользователю();
	
	Форма.ЗначениеВРеквизитФормы(Ведомость, "Объект");
	
	Форма.ПриПолученииДанныхНаСервере(Ведомость);	
	
КонецПроцедуры

Процедура ДополнитьНаСервере(Форма, ФизическиеЛица)
	
	МенеджерВедомости = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Форма.Объект.Ссылка);
	ПараметрыЗаполнения = МенеджерВедомости.ПараметрыЗаполненияПоОбъекту(Форма.Объект);
	ПараметрыЗаполнения.ПараметрыРасчетаЗарплаты.ТолькоПоложительные = Ложь;
	
	Зарплата = ВедомостьНаВыплатуЗарплаты.ЗарплатаКВыплатеФизическихЛиц(
		ФизическиеЛица,
		ПараметрыЗаполнения.ОписаниеОперации,
		ПараметрыЗаполнения.ОтборСотрудников,
		ПараметрыЗаполнения.ПараметрыРасчетаЗарплаты,
		ПараметрыЗаполнения.Финансирование,
		Форма.Объект.Ссылка);
		
	НДФЛ = ВедомостьНаВыплатуЗарплаты.НалогиКУдержанию(
		Зарплата, 
		ПараметрыЗаполнения.ОписаниеОперации, 
		ПараметрыЗаполнения.ПараметрыРасчетаНДФЛ, 
		ПараметрыЗаполнения.Финансирование,
		Форма.Объект.Ссылка);
		
	Ведомость = Форма.РеквизитФормыВЗначение("Объект");
	
	Ведомость.ДобавитьВыплаты(Зарплата, НДФЛ);
	
	Форма.ОбработатьСообщенияПользователю();
	
	Форма.ЗначениеВРеквизитФормы(Ведомость, "Объект");
	
	Форма.ПриПолученииДанныхНаСервере(Ведомость);	
	
КонецПроцедуры

Процедура ОбновитьНДФЛНаСервере(Форма, ИдентификаторыСтрок) Экспорт
	
	// Физические лица, для которых обновляется налог
	ФизическиеЛица = Новый Массив;
	Для Каждого ИдентификаторСтроки Из ИдентификаторыСтрок Цикл
		СтрокаСостава = Форма.Объект.Состав.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаСостава <> Неопределено Тогда
			ФизическиеЛица.Добавить(СтрокаСостава.ФизическоеЛицо);
		КонецЕсли	
	КонецЦикла;	

	// Зарплата физических лиц, для которых обновляется налог
	СтрокиЗарплатыФизлиц = Новый Массив;
	Для Каждого СтрокаЗарплаты Из Форма.Объект.Зарплата Цикл
		Если ФизическиеЛица.Найти(СтрокаЗарплаты.ФизическоеЛицо) <> Неопределено Тогда
			СтрокиЗарплатыФизлиц.Добавить(СтрокаЗарплаты);
		КонецЕсли
	КонецЦикла;	
	Зарплата = 
		Форма.Объект.Зарплата.Выгрузить(
			СтрокиЗарплатыФизлиц,
			"ФизическоеЛицо,
			|ДокументОснование, 
			|СтатьяФинансирования, 
			|СтатьяРасходов,
			|ВидДоходаИсполнительногоПроизводства,
			|КВыплате,
			|Сотрудник,
			|ПериодВзаиморасчетов,
			|Подразделение");
	
	МенеджерВедомости = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Форма.Объект.Ссылка);
	ПараметрыЗаполнения = МенеджерВедомости.ПараметрыЗаполненияПоОбъекту(Форма.Объект);
	
	НДФЛ = ВедомостьНаВыплатуЗарплаты.НалогиКУдержанию(
		Зарплата, 
		ПараметрыЗаполнения.ОписаниеОперации, 
		ПараметрыЗаполнения.ПараметрыРасчетаНДФЛ, 
		ПараметрыЗаполнения.Финансирование,
		Форма.Объект.Ссылка);
		
	Ведомость = Форма.РеквизитФормыВЗначение("Объект");
	
	Ведомость.УстановитьНДФЛ(НДФЛ, ФизическиеЛица);
	
	Форма.ОбработатьСообщенияПользователю();
	
	Форма.ЗначениеВРеквизитФормы(Ведомость, "Объект");
	
	Форма.ПриПолученииДанныхНаСервере(Ведомость);	
	
КонецПроцедуры

Функция АдресСпискаПодобранныхСотрудников(Форма) Экспорт
	Возврат ПоместитьВоВременноеХранилище(Форма.Объект.Состав.Выгрузить(,"ФизическоеЛицо").ВыгрузитьКолонку("ФизическоеЛицо"), Форма.УникальныйИдентификатор);
КонецФункции

Процедура РедактироватьЗарплатуСтрокиЗавершениеНаСервере(Форма, РезультатыРедактирования) Экспорт
	
	ИдентификаторСтроки	= РезультатыРедактирования.ИдентификаторСтроки;
	
	СтрокиСостава = Форма.Объект.Состав.НайтиСтроки(Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки));
	Если СтрокиСостава.Количество() <> 0 Тогда
		СтрокаСостава  = СтрокиСостава[0]
	Иначе
		Возврат
	КонецЕсли;	

	ЗарплатаСтроки	= ПолучитьИзВременногоХранилища(РезультатыРедактирования.АдресВХранилищеЗарплатыПоСтроке);
	
	УдаляемыеСтроки = Форма.Объект.Зарплата.НайтиСтроки(Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки));
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		Форма.Объект.Зарплата.Удалить(УдаляемаяСтрока);
	КонецЦикла;	
	
	ПоляСостава	= Новый Массив;
	Для Каждого РеквизитСостава Из Форма.Объект.Ссылка.Метаданные().ТабличныеЧасти.Состав.Реквизиты  Цикл
		Если ЗарплатаСтроки.Колонки.Найти(РеквизитСостава.Имя) = Неопределено Тогда
			ЗарплатаСтроки.Колонки.Добавить(РеквизитСостава.Имя, РеквизитСостава.Тип);
		КонецЕсли;	
		ПоляСостава.Добавить(РеквизитСостава.Имя);
	КонецЦикла;	
	СписокСвойств = СтрСоединить(ПоляСостава, ", ");
	
	Для Каждого СтрокаЗарплаты Из ЗарплатаСтроки Цикл
		ЗаполнитьЗначенияСвойств(СтрокаЗарплаты, СтрокаСостава, СписокСвойств)
	КонецЦикла;	
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ЗарплатаСтроки, Форма.Объект.Зарплата);

	Форма.ПриПолученииДанныхСтрокиСостава(СтрокаСостава);
		
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура РедактироватьНДФЛСтрокиЗавершениеНаСервере(Форма, РезультатыРедактирования) Экспорт
	
	ИдентификаторСтроки	= РезультатыРедактирования.ИдентификаторСтроки;
	НДФЛСтроки	= ПолучитьИзВременногоХранилища(РезультатыРедактирования.АдресВХранилищеНДФЛПоСтроке);
	
	УдаляемыеСтроки = Форма.Объект.НДФЛ.НайтиСтроки(Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки));
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		Форма.Объект.НДФЛ.Удалить(УдаляемаяСтрока);
	КонецЦикла;	
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НДФЛСтроки, Форма.Объект.НДФЛ);
	
	СтрокиСостава = Форма.Объект.Состав.НайтиСтроки(Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки));
	Если СтрокиСостава.Количество() <> 0 Тогда
		Форма.ПриПолученииДанныхСтрокиСостава(СтрокиСостава[0]);
	КонецЕсли;	
	
	УстановитьИтогНДФЛ(Форма);
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

Функция АдресВХранилищеЗарплатыПоСтроке(Форма, ИдентификаторСтроки) Экспорт
	Возврат ПоместитьВоВременноеХранилище(Форма.Объект.Зарплата.Выгрузить(Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки)), Форма.УникальныйИдентификатор);
КонецФункции	

Функция АдресВХранилищеНДФЛПоСтроке(Форма, ИдентификаторСтроки) Экспорт
	Возврат ПоместитьВоВременноеХранилище(Форма.Объект.НДФЛ.Выгрузить(Новый Структура("ИдентификаторСтроки", ИдентификаторСтроки)), Форма.УникальныйИдентификатор);
КонецФункции	

#Область КлючевыеРеквизитыЗаполненияФормы

// Возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Состав");
	Массив.Добавить("Объект.Зарплата");
	Массив.Добавить("Объект.НДФЛ");
	Возврат Массив
КонецФункции 

// Возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	НСтр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение", НСтр("ru = 'подразделения'")));
	Возврат Массив
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти
