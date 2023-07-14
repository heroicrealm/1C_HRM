#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"СсылкаНаОбъект,Организация,ДатаДокументаОснования,ДатаПереименования,НаименованиеДокументаОснования,НомерДокументаОснования,Сведения,СерияДокументаОснования");
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПереименования) Тогда
		ДатаПереименования = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НаименованиеДокументаОснования) Тогда
		НаименованиеДокументаОснования = ЭлектронныеТрудовыеКнижкиВызовСервера.НаименованиеДокумента(Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если РазмерПорции = 0 Тогда
		РазмерПорции = 100;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаполнятьПорциямиПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаОснованияПриИзменении(Элемент)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаПриИзменении(Организация, "Переименование", НаименованиеДокументаОснования);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаОснованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаОснованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаОбработкаВыбора(
		НаименованиеДокументаОснования, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаОснованияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеВторогоДокументаОснованияПриИзменении(Элемент)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаПриИзменении(Организация, "Переименование", НаименованиеВторогоДокументаОснования);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеВторогоДокументаОснованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеВторогоДокументаОснованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаОбработкаВыбора(
		НаименованиеВторогоДокументаОснования, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеВторогоДокументаОснованияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Отказ = Ложь;
	ПроверкаДостаточностиЗаполнения(Отказ);
	Если Не Отказ Тогда
		Закрыть(АдресДанныхЗаполнения());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрироватьВторойДокументОснования(Команда)
	
	РегистрироватьВторойДокументОснования = Не РегистрироватьВторойДокументОснования;
	УстановитьДоступностьЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверкаДостаточностиЗаполнения(Отказ)
	
	Если Не ЗначениеЗаполнено(Сведения) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Сведения"".'"), , "Сведения", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НаименованиеДокументаОснования) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Наименование документа"".'"), , "НаименованиеДокументаОснования", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаДокументаОснования) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Дата документа"".'"), , "ДатаДокументаОснования", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерДокументаОснования) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Номер документа"".'"), , "НомерДокументаОснования", , Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПереименования) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Дата мероприятия"".'"), , "ДатаПереименования", , Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеВторогоДокументаОснования)
			Или ЗначениеЗаполнено(ДатаВторогоДокументаОснования)
			Или ЗначениеЗаполнено(СерияВторогоДокументаОснования)
			Или ЗначениеЗаполнено(НомерВторогоДокументаОснования) Тогда
		
		Если Не ЗначениеЗаполнено(НаименованиеВторогоДокументаОснования) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Наименование второго документа"".'"), , "НаименованиеВторогоДокументаОснования", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДатаВторогоДокументаОснования) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Дата второго документа"".'"), , "ДатаВторогоДокументаОснования", , Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НомерВторогоДокументаОснования) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Номер второго документа"".'"), , "НомерВторогоДокументаОснования", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(УправляемаяФорма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"РазмерПорции",
		"Доступность",
		УправляемаяФорма.ЗаполнятьПорциями);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ВторойДокументОснованиеГруппа",
		"Видимость",
		УправляемаяФорма.РегистрироватьВторойДокументОснования
			Или ЗначениеЗаполнено(УправляемаяФорма.НаименованиеВторогоДокументаОснования)
			Или ЗначениеЗаполнено(УправляемаяФорма.ДатаВторогоДокументаОснования)
			Или ЗначениеЗаполнено(УправляемаяФорма.СерияВторогоДокументаОснования)
			Или ЗначениеЗаполнено(УправляемаяФорма.НомерВторогоДокументаОснования));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ФормаРегистрироватьВторойДокументОснования",
		"Видимость",
		Не (УправляемаяФорма.РегистрироватьВторойДокументОснования
			Или ЗначениеЗаполнено(УправляемаяФорма.НаименованиеВторогоДокументаОснования)
			Или ЗначениеЗаполнено(УправляемаяФорма.ДатаВторогоДокументаОснования)
			Или ЗначениеЗаполнено(УправляемаяФорма.СерияВторогоДокументаОснования)
			Или ЗначениеЗаполнено(УправляемаяФорма.НомерВторогоДокументаОснования)));
	
КонецПроцедуры

&НаСервере
Функция АдресДанныхЗаполнения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаМероприятия", ДатаПереименования);
	Запрос.УстановитьПараметр("Регистратор", СсылкаНаОбъект);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Мероприятия.Сотрудник КАК Сотрудник
		|ИЗ
		|	РегистрСведений.МероприятияТрудовойДеятельности КАК Мероприятия
		|ГДЕ
		|	Мероприятия.Организация = &Организация
		|	И Мероприятия.ВидМероприятия = ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Переименование)
		|	И Мероприятия.ДатаМероприятия = &ДатаМероприятия
		|	И НЕ Мероприятия.Регистратор В (&Регистратор)";
	
	РанееПодобранные = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	
	ПараметрыПолучения = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолучения.Организация = Организация;
	ПараметрыПолучения.НачалоПериода = ДатаПереименования;
	ПараметрыПолучения.ОкончаниеПериода = ПараметрыПолучения.НачалоПериода;
	ПараметрыПолучения.КадровыеДанные = "ВидЗанятости,ФИОПолные";
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолучения);
	
	Запрос.УстановитьПараметр("РанееПодобранные", РанееПодобранные);
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиОрганизации.Период КАК ДатаМероприятия,
		|	СотрудникиОрганизации.Сотрудник КАК СотрудникЗаписи,
		|	СотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВЫБОР
		|		КОГДА СотрудникиОрганизации.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЯвляетсяСовместителем
		|ИЗ
		|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
		|ГДЕ
		|	НЕ СотрудникиОрганизации.Сотрудник В (&РанееПодобранные)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СотрудникиОрганизации.ФИОПолные,
		|	ЯвляетсяСовместителем";
	
	Если ЗаполнятьПорциями Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1", "ПЕРВЫЕ " + Формат(РазмерПорции, "ЧГ="));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1", "");
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеСотрудника = ЭлектронныеТрудовыеКнижки.ПустаяСтруктураЗаписиОТрудовойДеятельности();
		ЗаполнитьЗначенияСвойств(ДанныеСотрудника, Выборка);
		ДанныеСотрудника.ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Переименование;
		
		ЗаполнитьЗначенияСвойств(ДанныеСотрудника, ЭтотОбъект,
			"Сведения,НаименованиеДокументаОснования,ДатаДокументаОснования,СерияДокументаОснования,НомерДокументаОснования,"
			+ "НаименованиеВторогоДокументаОснования,ДатаВторогоДокументаОснования,СерияВторогоДокументаОснования,"
			+ "НомерВторогоДокументаОснования");
		
		ДанныеЗаполнения.Добавить(ДанныеСотрудника);
		
	КонецЦикла;
	
	Если ДанныеЗаполнения.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеЗаполнения, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
