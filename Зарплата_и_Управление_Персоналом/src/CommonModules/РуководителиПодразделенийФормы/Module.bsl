
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПодразделенияПриСозданииНаСервере(Форма) Экспорт 

	Если ПолучитьФункциональнуюОпцию("СтруктураПредприятияНеСоответствуетСтруктуреЮридическихЛиц") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МестоВСтруктуреПредприятия = ОрганизационнаяСтруктура.ПодразделениеВСтруктуреПредприятия(Форма.Объект.Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
	СтруктурнаяЕдиницаПриСозданииНаСервере(Форма, МестоВСтруктуреПредприятия);
	
КонецПроцедуры

Процедура СтруктураПредприятияПриСозданииНаСервере(Форма) Экспорт

	Если Не ПолучитьФункциональнуюОпцию("СтруктураПредприятияНеСоответствуетСтруктуреЮридическихЛиц") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктурнаяЕдиницаПриСозданииНаСервере(Форма, Форма.Объект.Ссылка);
		
КонецПроцедуры

Процедура ПодразделенияПриЗаписиНаСервере(Форма, ТекущийОбъект, Отказ, ПараметрыЗаписи) Экспорт

	Если ПолучитьФункциональнуюОпцию("СтруктураПредприятияНеСоответствуетСтруктуреЮридическихЛиц") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МестоВСтруктуреПредприятия = ОрганизационнаяСтруктура.ПодразделениеВСтруктуреПредприятия(ТекущийОбъект.Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
	РуководителиПодразделений.ЗаписатьПозициюРуководителя(МестоВСтруктуреПредприятия, Форма.ПозицияРуководителя);

КонецПроцедуры

Процедура СтруктураПредприятияПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

	Если Не ПолучитьФункциональнуюОпцию("СтруктураПредприятияНеСоответствуетСтруктуреЮридическихЛиц") Тогда
		Возврат;
	КонецЕсли;
	
	РуководителиПодразделений.ЗаписатьПозициюРуководителя(ТекущийОбъект.Ссылка, Форма.ПозицияРуководителя);

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСотрудникаРуководителя(Сотрудник, Позиция) Экспорт
	Сотрудник = РуководителиПодразделений.СотрудникНаПозицииРуководителя(Позиция);
КонецПроцедуры

Процедура СтруктурнаяЕдиницаПриСозданииНаСервере(Форма, Подразделение)

	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПозицииРуководителейПодразделений) Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьРеквизитыИЭлементыФормыРуководителейПодразделений(Форма);
	
	ЗаполнитьПозициюРуководителя(Форма, Подразделение);
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаполнитьСотрудникаРуководителя(Форма.СотрудникРуководитель, Форма.ПозицияРуководителя);
	УстановитьПривилегированныйРежим(Ложь);
	
	РуководителиПодразделенийКлиентСервер.УстановитьПодсказкуЭлементуРуководителя(Форма);
	
	УстановитьСвойстваЭлементовФормыРуководителейПодразделений(Форма);

КонецПроцедуры

Процедура ЗаполнитьПозициюРуководителя(Форма, Подразделение)
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Возврат;
	КонецЕсли;
	
	Форма.ПозицияРуководителя = РуководителиПодразделений.ПозицияРуководителя(Подразделение);
	
КонецПроцедуры

Процедура СоздатьРеквизитыИЭлементыФормыРуководителейПодразделений(Форма)

	СоздатьРеквизитыФормыРуководителейПодразделений(Форма);
	СоздатьЭлементыФормыРуководителейПодразделений(Форма);

КонецПроцедуры

Процедура СоздатьРеквизитыФормыРуководителейПодразделений(Форма)

	МассивРеквизитов = Новый Массив;
	
	// Описание реквизитов.
	
	РеквизитПозицияРуководителя = Новый РеквизитФормы("ПозицияРуководителя", Новый ОписаниеТипов("СправочникСсылка.ШтатноеРасписание"));
	РеквизитПозицияРуководителя.Заголовок = НСтр("ru = 'Руководитель'");
	РеквизитПозицияРуководителя.СохраняемыеДанные = Истина; 
	МассивРеквизитов.Добавить(РеквизитПозицияРуководителя);
	
	РеквизитСотрудникРуководитель = Новый РеквизитФормы("СотрудникРуководитель", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	МассивРеквизитов.Добавить(РеквизитСотрудникРуководитель);
	
	// Создание реквизитов.
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(Форма, МассивИменРеквизитовФормы);
	ЗарплатаКадры.ИзменитьРеквизитыФормы(Форма, МассивРеквизитов, МассивИменРеквизитовФормы);

КонецПроцедуры

Процедура СоздатьЭлементыФормыРуководителейПодразделений(Форма)

	ПосадочнаяГруппа = Форма.Элементы.Найти("РуководительПодразделенияГруппа");
	Если ПосадочнаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементПозицияРуководителя = Форма.Элементы.Найти("ПозицияРуководителя");
	Если ЭлементПозицияРуководителя <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементПозицияРуководителя = Форма.Элементы.Вставить("ПозицияРуководителя", Тип("ПолеФормы"), ПосадочнаяГруппа);
	ЭлементПозицияРуководителя.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементПозицияРуководителя.ПутьКДанным = "ПозицияРуководителя";
	ЭлементПозицияРуководителя.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	ЭлементПозицияРуководителя.РасширеннаяПодсказка.АвтоМаксимальнаяШирина = Ложь;
	ЭлементПозицияРуководителя.ПодсказкаВвода = НСтр("ru = 'Позиция, на которой работает руководитель этого подразделения.'");
	ЭлементПозицияРуководителя.УстановитьДействие("ПриИзменении", "Подключаемый_ПозицияРуководителяПриИзменении");

КонецПроцедуры

Процедура УстановитьСвойстваЭлементовФормыРуководителейПодразделений(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ПозицияРуководителя",
		"ТолькоПросмотр",
		Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПозицииРуководителейПодразделений));
		
	СкрытьЭлементыРуководителейДляОрганизации(Форма);
	
КонецПроцедуры

Процедура СкрытьЭлементыРуководителейДляОрганизации(Форма)

	Если ТипЗнч(Форма.Объект.Ссылка) <> Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Форма.Объект.Источник)
		ИЛИ ТипЗнч(Форма.Объект.Источник) <> Тип("СправочникСсылка.Организации") Тогда
		
		Возврат;
	КонецЕсли;
	
    ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ПозицияРуководителя",
		"Видимость",
		Ложь);

КонецПроцедуры

#КонецОбласти 