#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПланыОбменаРИБ = Новый Массив;
	
	ПланыОбменаПодсистемы = Новый Массив;
	ОбменДаннымиПереопределяемый.ПолучитьПланыОбмена(ПланыОбменаПодсистемы);
	
	Для Каждого МетаданныеПланаОбмена Из ПланыОбменаПодсистемы Цикл
		Если Не МетаданныеПланаОбмена.РаспределеннаяИнформационнаяБаза Тогда
			Продолжить;
		КонецЕсли;
		ПланыОбменаРИБ.Добавить(МетаданныеПланаОбмена.Имя);
	КонецЦикла;
	
	Для Каждого ЗаписьНабора Из ЭтотОбъект Цикл
		// При установки связи зарегистрируем изменения по физическому лицу
		Для Каждого ИмяПланаОбмена Из ПланыОбменаРИБ Цикл
			Запрос = Новый Запрос;
			Запрос.Текст = "";
			ФизическоеЛицоОбъект = ЗаписьНабора.ФизическоеЛицо.ПолучитьОбъект();
			Если ФизическоеЛицоОбъект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СинхронизацияДанныхЗарплатаКадрыСервер.ОграничитьРегистрациюОбъектаОтборомПоОрганизациям(ИмяПланаОбмена, Отказ, Запрос.Текст, Запрос.Параметры, Истина, ФизическоеЛицоОбъект, ЗаписьНабора.Организация);
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "[УсловиеОтбораПоРеквизитуФлагу]", "");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "СвойствоОбъекта_", "");
			Запрос.УстановитьПараметр(ИмяПланаОбмена + "ЭтотУзел", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел());
			
			Если ПустаяСтрока(Запрос.Текст) Тогда
				Продолжить;
			КонецЕсли;
			Получатели = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
			
			Если Получатели.Количество() > 0 Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(Получатели, ЗаписьНабора.ФизическоеЛицо);
				СинхронизацияДанныхЗарплатаКадрыСервер.ЗарегистрироватьСвязанныеРегистрыСведенийОбъекта(ИмяПланаОбмена, Отказ, ЗаписьНабора.ФизическоеЛицо, Ложь, Получатели);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли