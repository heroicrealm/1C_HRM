///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Выполняет загрузку данных из файла сообщения обмена.
//
// Параметры:
//   Отказ - Булево - флаг отказа; поднимается в случае возникновения ошибок при обработке сообщения обмена.
//   ЗагрузитьТолькоПараметры - Булево
//   СообщениеОбОшибке - Строка
// 
Процедура ВыполнитьЗагрузкуДанных(Отказ, Знач ЗагрузитьТолькоПараметры, СообщениеОбОшибке = "") Экспорт
	
	Если Не ЭтоУзелРаспределеннойИнформационнойБазы() Тогда
		// Обмен не по правилам конвертации не поддерживается.
		СообщениеОбОшибке = ОшибкаВидаОбменаДанными();
		ЗафиксироватьЗавершениеОбмена(Отказ, , ОшибкаВидаОбменаДанными());
		Возврат;
	КонецЕсли;
	
	ЗагрузитьМетаданные = ЗагрузитьТолькоПараметры
		И ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ()
		И (ОбменДаннымиСлужебный.ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском()
			Или Не ОбменДаннымиСлужебный.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"СообщениеПолученоИзКэша")
			Или ОбменДаннымиСлужебный.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"ЗагрузкаРасширений"));
					
	РезультатАнализаДанныхКЗагрузке = ОбменДаннымиСервер.РезультатАнализаДанныхКЗагрузке(ИмяФайлаСообщенияОбмена(), Ложь, Истина);
	РазмерФайлаСообщенияОбмена = РезультатАнализаДанныхКЗагрузке.РазмерФайлаСообщенияОбмена;
	КоличествоОбъектовКЗагрузке = РезультатАнализаДанныхКЗагрузке.КоличествоОбъектовКЗагрузке;
	
	// Установка параметров сеанса.
	ПараметрыСеансаСинхронизацииДанных = Новый Соответствие;
	УстановитьПривилегированныйРежим(Истина);
	Попытка
		ТекущийПараметрСеанса = ПараметрыСеанса.ПараметрыСеансаСинхронизацииДанных.Получить();
	Исключение
		ТекущийПараметрСеанса = Неопределено;
	КонецПопытки;
	
	Если ТипЗнч(ТекущийПараметрСеанса) = Тип("Соответствие") Тогда
		Для Каждого Элемент Из ТекущийПараметрСеанса Цикл
			ПараметрыСеансаСинхронизацииДанных.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыСеансаСинхронизацииДанных.Вставить(УзелИнформационнойБазы, 
						Новый Структура("РазмерФайлаСообщенияОбмена, КоличествоОбъектовКЗагрузке",
						РазмерФайлаСообщенияОбмена, КоличествоОбъектовКЗагрузке));
	ПараметрыСеанса.ПараметрыСеансаСинхронизацииДанных = Новый ХранилищеЗначения(ПараметрыСеансаСинхронизацииДанных);
	УстановитьПривилегированныйРежим(Ложь);
	
	ЧтениеXML = Новый ЧтениеXML;
	Попытка
		ЧтениеXML.ОткрытьФайл(ИмяФайлаСообщенияОбмена());
	Исключение
		// Ошибка открытия файла сообщения обмена.
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаОткрытияФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Истина);
	Попытка
		ПрочитатьФайлСообщенияОбмена(Отказ, ЧтениеXML, ЗагрузитьТолькоПараметры, ЗагрузитьМетаданные, СообщениеОбОшибке);
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
	Исключение
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
		ВызватьИсключение;
	КонецПопытки;
	
	ЧтениеXML.Закрыть();
КонецПроцедуры

// Выполняет выгрузку данных в файл сообщения обмена.
//
// Параметры:
//  Отказ - Булево - флаг отказа; поднимается в случае возникновения ошибок при обработке сообщения обмена.
//  СообщениеОбОшибке - Строка - текстовое описание ошибки выгрузки данных.
// 
Процедура ВыполнитьВыгрузкуДанных(Отказ, СообщениеОбОшибке = "") Экспорт
	
	Если Не ЭтоУзелРаспределеннойИнформационнойБазы() Тогда
		// Обмен не по правилам конвертации не поддерживается.
		СообщениеОбОшибке = ОшибкаВидаОбменаДанными();
		ЗафиксироватьЗавершениеОбмена(Отказ, , СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	ЗаписьXML = Новый ЗаписьXML;
	
	Попытка
		ЗаписьXML.ОткрытьФайл(ИмяФайлаСообщенияОбмена());
	Исключение
		// Ошибка открытия файла сообщения обмена.
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаОткрытияФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	ЗаписатьИзмененияВФайлСообщенияОбмена(Отказ, ЗаписьXML, СообщениеОбОшибке);
	
	ЗаписьXML.Закрыть();
	
КонецПроцедуры

// Устанавливает локальной переменной ПолеИмяФайлаСообщенияОбмена
// строку с полным именем файла сообщения обмена для загрузки или выгрузки данных.
// Как правило, файл сообщения обмена располагается 
// во временном каталоге пользователя операционной системы.
//
// Параметры:
//  ИмяФайла - Строка - полное имя файла сообщения обмена для выгрузки или загрузки данных.
// 
Процедура УстановитьИмяФайлаСообщенияОбмена(Знач ИмяФайла) Экспорт
	
	ПолеИмяФайлаСообщенияОбмена = ИмяФайла;
	
КонецПроцедуры

//

Процедура ПрочитатьФайлСообщенияОбмена(Отказ, ЧтениеXML, Знач ЗагрузитьТолькоПараметры, Знач ЗагрузитьМетаданные, СообщениеОбОшибке = "")
	
	ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	
	Попытка
		ЧтениеСообщения.НачатьЧтение(ЧтениеXML, ДопустимыйНомерСообщения.Больший);
	Исключение
		// Задан неизвестный план обмена;
		// указан узел, не входящий в план обмена;
		// номер сообщения не соответствует ожидаемому.
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаНачалаЧтенияФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	УзелОбщихДанных = Неопределено;
	НомерПринятого = ЧтениеСообщения.НомерПринятого;
	УзелОбмена = ЧтениеСообщения.Отправитель;
	
	Если ЗагрузитьТолькоПараметры Тогда
		
		Если ЗагрузитьМетаданные Тогда
				
			Попытка
				
				УстановитьПривилегированныйРежим(Истина);
				ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"ЗагрузкаПараметровРаботыПрограммы", Истина);
				УстановитьПривилегированныйРежим(Ложь);
				
				// Получаем изменения конфигурации, изменения данных игнорируем.
				ПланыОбмена.ПрочитатьИзменения(ЧтениеСообщения, КоличествоЭлементовВТранзакции);
				
				// Читаем приоритетные данные (предопределенные элементы, идентификаторы объектов метаданных).
				ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(ЧтениеСообщения, УзелОбщихДанных);
				
				// Сообщение считаем не принятым, для этого прерываем чтение.
				ЧтениеСообщения.ПрерватьЧтение();
				
				УстановитьПривилегированныйРежим(Истина);
				ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"ЗагрузкаПараметровРаботыПрограммы", Ложь);
				УстановитьПривилегированныйРежим(Ложь);
			Исключение
				УстановитьПривилегированныйРежим(Истина);
				ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"ЗагрузкаПараметровРаботыПрограммы", Ложь);
				УстановитьПривилегированныйРежим(Ложь);
				
				ЧтениеСообщения.ПрерватьЧтение();
				СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаЧтенияФайлаСообщенияОбмена());
				Возврат;
			КонецПопытки;
			
		Иначе
			
			Попытка
				
				// Пропускаем изменения конфигурации и изменения данных в сообщении обмена.
				ЧтениеСообщения.ЧтениеXML.Пропустить(); // <Changes>...</Changes>
				
				ЧтениеСообщения.ЧтениеXML.Прочитать(); // </Changes>
				
				// Читаем приоритетные данные (предопределенные элементы, идентификаторы объектов метаданных).
				ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(ЧтениеСообщения, УзелОбщихДанных);
				
				// Сообщение считаем не принятым, для этого прерываем чтение.
				ЧтениеСообщения.ПрерватьЧтение();
			Исключение
				ЧтениеСообщения.ПрерватьЧтение();
				СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаЧтенияФайлаСообщенияОбмена());
				Возврат
			КонецПопытки;
			
		КонецЕсли;
		
	Иначе
		
		Если ЕстьРасширениеВСообщениеОбмена(ЧтениеСообщения) Тогда
			ОбменДаннымиСлужебный.ВключитьЗагрузкуРасширенийИзменяющиеСтруктуруДанных();
		КонецЕсли;
		
		Попытка
				
			// Получаем изменения конфигурации и изменения данных из сообщения обмена.
			ПланыОбмена.ПрочитатьИзменения(ЧтениеСообщения, КоличествоЭлементовВТранзакции);
			
			// Читаем приоритетные данные (предопределенные элементы, идентификаторы объектов метаданных).
			ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(ЧтениеСообщения, УзелОбщихДанных);
			
			// Сообщение считаем принятым
			ЧтениеСообщения.ЗакончитьЧтение();
			
	        // Если сообщение обмена принято без ошибок, то нет необходимости в загрузке расширений
			ОбменДаннымиСлужебный.ОтключитьЗагрузкуРасширенийИзменяющихСтруктуруДанных();
						
		Исключение
			
			// Если расширения были изменены динамически, то есть необходимость только в перезагрузке сеанса, но не в обновлении
			Если Справочники.ВерсииРасширений.РасширенияИзмененыДинамически() Тогда
				ОбменДаннымиСлужебный.ОтключитьЗагрузкуРасширенийИзменяющихСтруктуруДанных();
			КонецЕсли;	
						
			ЧтениеСообщения.ПрерватьЧтение();
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаЧтенияФайлаСообщенияОбмена());
			Возврат
		КонецПопытки;
		
	КонецЕсли;
			
	// Запись общих данных узлов выполняется после чтения сообщения.
	Если УзелОбщихДанных <> Неопределено Тогда
		
		ГлавныйУзелСсылка  = ПланыОбмена.ГлавныйУзел();
		
		НачатьТранзакцию();
		Попытка
		    Блокировка = Новый БлокировкаДанных;
			
		    ЭлементБлокировки = Блокировка.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(ГлавныйУзелСсылка));
		    ЭлементБлокировки.УстановитьЗначение("Ссылка", ГлавныйУзелСсылка);
			
			Блокировка.Заблокировать();
			
			ОбщиеДанныеУзлов = ОбменДаннымиПовтИсп.ОбщиеДанныеУзлов(ГлавныйУзелСсылка);
			ТекущийУзел = ГлавныйУзелСсылка.ПолучитьОбъект();
			Если ОбменДаннымиСобытия.ДанныеРазличаются(ТекущийУзел, УзелОбщихДанных, ОбщиеДанныеУзлов) Тогда
				ОбменДаннымиСобытия.ЗаполнитьЗначенияСвойствОбъекта(ТекущийУзел, УзелОбщихДанных, ОбщиеДанныеУзлов);
				ТекущийУзел.Записать();
			КонецЕсли;

		    ЗафиксироватьТранзакцию();
		Исключение
		    ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
	РегистрыСведений.ИзмененияОбщихДанныхУзлов.УдалитьРегистрациюИзменений(УзелОбмена, НомерПринятого);
	
КонецПроцедуры

Процедура ЗаписатьИзмененияВФайлСообщенияОбмена(Отказ, ЗаписьXML, СообщениеОбОшибке = "")
	
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	
	Попытка
		ЗаписьСообщения.НачатьЗапись(ЗаписьXML, УзелИнформационнойБазы);
	Исключение
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаНачалаЗаписиФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	// Установка параметров сеанса.
	КоличествоОбъектовКВыгрузке = ОбменДаннымиСервер.РассчитатьКоличествоЗарегистрированныхОбъектов(УзелИнформационнойБазы);
	ПараметрыСеансаСинхронизацииДанных = Новый Соответствие;
	УстановитьПривилегированныйРежим(Истина);
	Попытка
		ТекущийПараметрСеанса = ПараметрыСеанса.ПараметрыСеансаСинхронизацииДанных.Получить();
	Исключение
		ТекущийПараметрСеанса = Неопределено;
	КонецПопытки;
	
	Если ТипЗнч(ТекущийПараметрСеанса) = Тип("Соответствие") Тогда
		Для Каждого Элемент Из ТекущийПараметрСеанса Цикл
			ПараметрыСеансаСинхронизацииДанных.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыСеансаСинхронизацииДанных.Вставить(УзелИнформационнойБазы, 
						Новый Структура("КоличествоОбъектовКВыгрузке",
						КоличествоОбъектовКВыгрузке));
	ПараметрыСеанса.ПараметрыСеансаСинхронизацииДанных = Новый ХранилищеЗначения(ПараметрыСеансаСинхронизацииДанных);
	УстановитьПривилегированныйРежим(Ложь);
	
	Попытка
		ОбменДаннымиСлужебный.ОчиститьПриоритетныеДанныеОбмена();
		
		// Записываем изменения конфигурации и изменения данных в сообщение обмена.
		ПланыОбмена.ЗаписатьИзменения(ЗаписьСообщения, КоличествоЭлементовВТранзакции);
		
		// Записываем приоритетные данные в конец сообщения обмена
		// (предопределенные элементы, идентификаторы объектов метаданных).
		ЗаписатьПриоритетныеИзмененияВСообщениеОбмена(ЗаписьСообщения);
		
		ЗаписьСообщения.ЗакончитьЗапись();
	Исключение
		ЗаписьСообщения.ПрерватьЗапись();
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗафиксироватьЗавершениеОбмена(Отказ, СообщениеОбОшибке, ОшибкаЗаписиФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Запись приоритетных данных в сообщение обмена.
// Например, предопределенных элементов и идентификаторов объектов метаданных.
//
Процедура ЗаписатьПриоритетныеИзмененияВСообщениеОбмена(Знач ЗаписьСообщения)
	
	// Записываем элемент <Parameters>
	ЗаписьСообщения.ЗаписьXML.ЗаписатьНачалоЭлемента("Parameters");
	
	Если ЗаписьСообщения.Получатель <> ПланыОбмена.ГлавныйУзел() Тогда
		
		// Выгружаем приоритетные данные обмена (предопределенные элементы).
		ПриоритетныеДанныеОбмена = ОбменДаннымиСлужебный.ПриоритетныеДанныеОбмена();
		
		Если ПриоритетныеДанныеОбмена.Количество() > 0 Тогда
			
			ВыборкаИзменений = ОбменДаннымиСервер.ВыбратьИзменения(
				ЗаписьСообщения.Получатель,
				ЗаписьСообщения.НомерСообщения,
				ПриоритетныеДанныеОбмена);
			
			НачатьТранзакцию();
			Попытка
				
				Пока ВыборкаИзменений.Следующий() Цикл
					
					ЗаписатьXML(ЗаписьСообщения.ЗаписьXML, ВыборкаИзменений.Получить());
					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
		КонецЕсли;
		
		Если Не СтандартныеПодсистемыПовтИсп.ОтключитьИдентификаторыОбъектовМетаданных() Тогда
			
			// Выгружаем справочник идентификаторов объектов метаданных.
			ВыборкаИзменений = ОбменДаннымиСервер.ВыбратьИзменения(
				ЗаписьСообщения.Получатель,
				ЗаписьСообщения.НомерСообщения,
				Метаданные.Справочники["ИдентификаторыОбъектовМетаданных"]);
			
			НачатьТранзакцию();
			Попытка
				
				Пока ВыборкаИзменений.Следующий() Цикл
					
					ЗаписатьXML(ЗаписьСообщения.ЗаписьXML, ВыборкаИзменений.Получить());
					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
		КонецЕсли;
		
		// Выгрузка общих данных узлов.
		ВыборкаИзмененийУзлов = РегистрыСведений.ИзмененияОбщихДанныхУзлов.ВыбратьИзменения(ЗаписьСообщения.Получатель, ЗаписьСообщения.НомерСообщения);
		
		Если ВыборкаИзмененийУзлов.Количество() <> 0 Тогда
			
			ОбщиеДанныеУзлов = ОбменДаннымиПовтИсп.ОбщиеДанныеУзлов(ЗаписьСообщения.Получатель);
			
			Если Не ПустаяСтрока(ОбщиеДанныеУзлов) Тогда
				
				ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(ЗаписьСообщения.Получатель);
				ОбщийУзел = ПланыОбмена[ИмяПланаОбмена].СоздатьУзел();
				ОбменДаннымиСобытия.ЗаполнитьЗначенияСвойствОбъекта(ОбщийУзел, ЗаписьСообщения.Получатель.ПолучитьОбъект(), ОбщиеДанныеУзлов);
				ЗаписатьXML(ЗаписьСообщения.ЗаписьXML, ОбщийУзел);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаписьСообщения.ЗаписьXML.ЗаписатьКонецЭлемента(); // Parameters
	
КонецПроцедуры

// Чтение приоритетных данных из сообщения обмена
// (предопределенные элементы, идентификаторы объектов метаданных).
//
Процедура ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(Знач ЧтениеСообщения, УзелОбщихДанных)
	
	Если ЧтениеСообщения.Отправитель = ПланыОбмена.ГлавныйУзел() Тогда
		
		ЧтениеСообщения.ЧтениеXML.Прочитать(); // <Parameters>
		
		НачатьТранзакцию();
		Попытка
			
			ДублиПредопределенных = "";
			Отказ = Ложь;
			ОписаниеОтказа = "";
			ОбъектыИдентификаторов = Новый Массив;
			ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(ЧтениеСообщения.Отправитель);
			ТипПланОбменаОбъект = Тип("ПланОбменаОбъект." + ИмяПланаОбмена);
			
			Если НайденыНеУникальныеЗаписи("Справочник.ИдентификаторыОбъектовМетаданных") Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонОшибкиНеУникальностиЗаписей(),
					НСтр("ru = 'Перед загрузкой идентификаторов объектов метаданных
					           |в справочнике найдены не уникальные записи.'"));
			КонецЕсли;
			
			Пока ВозможностьЧтенияXML(ЧтениеСообщения.ЧтениеXML) Цикл
				
				Данные = ПрочитатьXML(ЧтениеСообщения.ЧтениеXML);
				
				Данные.ОбменДанными.Загрузка = Истина;
				
				Если ТипЗнч(Данные) = ТипПланОбменаОбъект Тогда // Общие данные узлов
					
					УзелОбщихДанных = Данные;
					Продолжить;
					
				КонецЕсли;
				
				Данные.ОбменДанными.Отправитель = ЧтениеСообщения.Отправитель;
				Данные.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
				
				Если ТипЗнч(Данные) = Тип("СправочникОбъект.ИдентификаторыОбъектовМетаданных") Тогда
					ОбъектыИдентификаторов.Добавить(Данные);
					Продолжить;
					
				ИначеЕсли ТипЗнч(Данные) <> Тип("УдалениеОбъекта") Тогда // Это предопределенный элемент.
					
					Если Не Данные.Предопределенный Тогда
						Продолжить; // Обрабатываются только предопределенные.
					КонецЕсли;
					
				Иначе // Тип("УдалениеОбъекта")
					
					// 1. Ссылки идентификаторов удаляются независимо во всех узлах
					//    через механизм пометки удаления и удаления помеченных объектов.
					// 2. Удаление предопределенных не выгружается.
					Продолжить;
				КонецЕсли;
				
				ЗаписатьСсылкуПредопределенныхДанных(Данные);
				ДобавитьОписаниеДублейПредопределенного(Данные, ДублиПредопределенных, Отказ, ОписаниеОтказа);
			КонецЦикла;
			
			Если Отказ Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Загрузка приоритетных данных не выполнена.
					           |При загрузке предопределенных элементов найдены не уникальные записи.
					           |По следующим причинам продолжение невозможно.
					           |%1'"),
					ОписаниеОтказа);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДублиПредопределенных) Тогда
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Предопределенные элементы.Найдены не уникальные записи.'",
						ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'При загрузке предопределенных элементов найдены не уникальные записи.
						           |%1'"),
						ДублиПредопределенных));
			КонецЕсли;
			
			ОбновитьУдалениеПредопределенных();
			
			Если Не СтандартныеПодсистемыПовтИсп.ОтключитьИдентификаторыОбъектовМетаданных() Тогда
				Справочники.ИдентификаторыОбъектовМетаданных.ЗагрузитьДанныеВПодчиненныйУзел(ОбъектыИдентификаторов);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
		ЧтениеСообщения.ЧтениеXML.Прочитать(); // </Parameters>
		
	Иначе
		
		// Пропускаем параметры работы программы.
		ЧтениеСообщения.ЧтениеXML.Пропустить(); // <Parameters>...</Parameters>
		
		ЧтениеСообщения.ЧтениеXML.Прочитать(); // </Parameters>
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки = "", ОписаниеОшибкиКонтекста = "")
	
	Отказ = Истина;
	
	Комментарий = "[ОписаниеОшибкиКонтекста]: [ОписаниеОшибки]"; // Не локализуется
	
	Комментарий = СтрЗаменить(Комментарий, "[ОписаниеОшибкиКонтекста]", ОписаниеОшибкиКонтекста);
	Комментарий = СтрЗаменить(Комментарий, "[ОписаниеОшибки]", ОписаниеОшибки);
	
	ЗаписьЖурналаРегистрации(КлючСообщенияЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка,
		УзелИнформационнойБазы.Метаданные(), УзелИнформационнойБазы, Комментарий);
	
КонецПроцедуры

Функция ЭтоУзелРаспределеннойИнформационнойБазы()
	
	Возврат ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы);
	
КонецФункции

Процедура ЗаписатьСсылкуПредопределенныхДанных(Данные)
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Данные.Ссылка));
	Если МетаданныеОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Данные.Ссылка);
	
	Если Данные.ЭтоНовый() Тогда
		Если ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта) Тогда
			Если МетаданныеОбъекта.Иерархический
				И МетаданныеОбъекта.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов
				И Данные.ЭтоГруппа Тогда
				Объект = МенеджерОбъекта.СоздатьГруппу();
			Иначе
				Объект = МенеджерОбъекта.СоздатьЭлемент();
			КонецЕсли;
		ИначеЕсли ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеОбъекта) Тогда
			Если МетаданныеОбъекта.Иерархический
				И Данные.ЭтоГруппа Тогда
				Объект = МенеджерОбъекта.СоздатьГруппу();
			Иначе
				Объект = МенеджерОбъекта.СоздатьЭлемент();
			КонецЕсли;
		ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(МетаданныеОбъекта) Тогда
			Объект = МенеджерОбъекта.СоздатьСчет();
		ИначеЕсли ОбщегоНазначения.ЭтоПланВидовРасчета(МетаданныеОбъекта) Тогда
			Объект = МенеджерОбъекта.СоздатьВидРасчета();
		КонецЕсли;
	Иначе
		Объект = Данные.Ссылка.ПолучитьОбъект();
	КонецЕсли;
	
	Если Данные.ЭтоНовый() Тогда
		Объект.УстановитьСсылкуНового(Данные.ПолучитьСсылкуНового());
		Объект.ИмяПредопределенныхДанных = Данные.ИмяПредопределенныхДанных;
		Объект.ДополнительныеСвойства.Вставить("ПропуститьЗаписьВерсииОбъекта");
		Объект.ДополнительныеСвойства.Вставить("ЗагрузкаПриоритетныхДанных");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
	ИначеЕсли Объект.ИмяПредопределенныхДанных <> Данные.ИмяПредопределенныхДанных Тогда
		Объект.ИмяПредопределенныхДанных = Данные.ИмяПредопределенныхДанных;
		Объект.ДополнительныеСвойства.Вставить("ПропуститьЗаписьВерсииОбъекта");
		Объект.ДополнительныеСвойства.Вставить("ЗагрузкаПриоритетныхДанных");
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	Иначе
		// Если предопределенный элемент существует предварительная загрузка не требуется.
	КонецЕсли;
	
	Данные = Объект;
	
КонецПроцедуры

Процедура ДобавитьОписаниеДублейПредопределенного(ЗаписанныйОбъект, ДублиПредопределенных, Отказ, ОписаниеОтказа)
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(ЗаписанныйОбъект.Ссылка));
	Если МетаданныеОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Таблица = МетаданныеОбъекта.ПолноеИмя();
	ИмяПредопределенныхДанных = ЗаписанныйОбъект.ИмяПредопределенныхДанных;
	Ссылка = ЗаписанныйОбъект.Ссылка;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", ИмяПредопределенныхДанных);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Ссылка КАК Ссылка,
	|	ТекущаяТаблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	&ТекущаяТаблица КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", Таблица);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ИдентификаторыСсылокДублей = "";
	КоличествоДублей = 0;
	НайденныеСсылки = Новый Соответствие;
	ЗагружаемаяСсылкаНайдена = Ложь;
	
	Пока Выборка.Следующий() Цикл
		// Определение не уникальных записей, которые имеют отношение к предопределенным элементам.
		Если НайденныеСсылки.Получить(Выборка.Ссылка) = Неопределено Тогда
			НайденныеСсылки.Вставить(Выборка.Ссылка, 1);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибкиНеУникальностиЗаписей(),
				НСтр("ru = 'При загрузке предопределенных элементов найдены не уникальные записи.'"));
		КонецЕсли;
		// Определение дублей предопределенных элементов.
		Если Ссылка = Выборка.Ссылка И Не ЗагружаемаяСсылкаНайдена Тогда
			ЗагружаемаяСсылкаНайдена = Истина;
			Продолжить;
		КонецЕсли;
		КоличествоДублей = КоличествоДублей + 1;
		Если ЗначениеЗаполнено(ИдентификаторыСсылокДублей) Тогда
			ИдентификаторыСсылокДублей = ИдентификаторыСсылокДублей + ",";
		КонецЕсли;
		ИдентификаторыСсылокДублей = ИдентификаторыСсылокДублей
			+ Строка(Выборка.Ссылка.УникальныйИдентификатор());
	КонецЦикла;
	
	Если КоличествоДублей = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьВЖурнал = Истина;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
		
		Описание = "";
		МодульУправлениеДоступомСлужебный.ПриОбнаруженииНеУникальностиПредопределенного(
			ЗаписанныйОбъект, ЗаписатьВЖурнал, Отказ, Описание);
		
		Если ЗначениеЗаполнено(Описание) Тогда
			ОписаниеОтказа = ОписаниеОтказа + Символы.ПС + СокрЛП(Описание) + Символы.ПС;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаписатьВЖурнал Тогда
		Если КоличествоДублей = 1 Тогда
			Шаблон = НСтр("ru = '(загружаемая ссылка: %1, ссылка дубля: %2)'");
		Иначе
			Шаблон = НСтр("ru = '(загружаемая ссылка: %1, ссылки дублей: %2)'");
		КонецЕсли;
		ДублиПредопределенных = ДублиПредопределенных + Символы.ПС
			+ Таблица + "." + ИмяПредопределенныхДанных + Символы.ПС
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Шаблон,
				Строка(Ссылка.УникальныйИдентификатор()),
				ИдентификаторыСсылокДублей)
			+ Символы.ПС;
	КонецЕсли;
	
КонецПроцедуры

Функция НайденыНеУникальныеЗаписи(Таблица)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
	|
	|СГРУППИРОВАТЬ ПО
	|	ИдентификаторыОбъектовМетаданных.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(ИдентификаторыОбъектовМетаданных.Ссылка) > 1";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ШаблонОшибкиНеУникальностиЗаписей()
	Возврат
		НСтр("ru = 'Загрузка приоритетных данных не выполнена.
		           |%1
		           |Требуется исправление информационной базы.
		           |1. Откройте конфигуратор, перейдите в меню Администрирование,
		           |   выберите пункт ""Тестирование и исправление ..."".
		           |2. В открывшейся форме
		           |   - включите только пункт ""Проверка логической целостности информационной базы"";
		           |   - выберите вариант ""Тестирование и исправление"", а не ""Только тестирование"";
		           |   - нажмите Выполнить.
		           |3. После этого запустите 1С:Предприятие и выполните повторную синхронизацию данных.'");
КонецФункции

Процедура ОбновитьУдалениеПредопределенных()
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоллекцииМетаданных = Новый Массив;
	КоллекцииМетаданных.Добавить(Метаданные.Справочники);
	КоллекцииМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	КоллекцииМетаданных.Добавить(Метаданные.ПланыСчетов);
	КоллекцииМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	
	Для каждого Коллекция Из КоллекцииМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Коллекция Цикл
			Если ОбъектМетаданных = Метаданные.Справочники.ИдентификаторыОбъектовМетаданных Тогда
				Продолжить; // Обновляется в частном порядке в процедуре обновления идентификаторов.
			КонецЕсли;
			ОбновитьУдалениеПредопределенного(ОбъектМетаданных.ПолноеИмя());
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьУдалениеПредопределенного(Таблица)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Ссылка КАК Ссылка,
	|	ТекущаяТаблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	&ТекущаяТаблица КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.Предопределенный = ИСТИНА";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", Таблица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если СтрНачинаетсяС(Выборка.ИмяПредопределенныхДанных, "#") Тогда
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.ИмяПредопределенныхДанных = "";
			Объект.ПометкаУдаления = Истина;
			
			Объект.ДополнительныеСвойства.Вставить("ПропуститьЗаписьВерсииОбъекта");
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные функции-свойства.

Функция ИмяФайлаСообщенияОбмена()
	
	Если Не ЗначениеЗаполнено(ПолеИмяФайлаСообщенияОбмена) Тогда
		
		ПолеИмяФайлаСообщенияОбмена = "";
		
	КонецЕсли;
	
	Возврат ПолеИмяФайлаСообщенияОбмена;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Описания ошибок контекста выполнения.

Функция ОшибкаОткрытияФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка открытия файла сообщения обмена'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаНачалаЧтенияФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка при начале чтения файла сообщения обмена'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаНачалаЗаписиФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка при начале записи файла сообщения обмена'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаЧтенияФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка чтения файла сообщения обмена'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаЗаписиФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка записи данных в файл сообщения обмена'");
	
КонецФункции

Функция ОшибкаВидаОбменаДанными()
	
	Возврат НСтр("ru = 'Обмен не по правилам конвертации не поддерживается'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ЕстьРасширениеВСообщениеОбмена(ЧтениеСообщения)
	
	Если НЕ УзелИнформационнойБазы.Метаданные().ВключатьРасширенияКонфигурации 
		Или Не ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() 
		Или ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
		
	ФайлОбмена = Новый ЧтениеXML;
	
	ФайлОбмена.ОткрытьФайл(ЧтениеСообщения.ЧтениеXML.БазовыйURI);
	
	Пока ФайлОбмена.Прочитать() Цикл
		
		Если ФайлОбмена.Имя = "v8de:ConfigurationExtensions" Тогда
			
			Пока ФайлОбмена.Прочитать() Цикл
				
				Если ФайлОбмена.Имя = "v8md:Metadata" Или ФайлОбмена.Имя = "v8de:ConfigurationExtensionDeletion" Тогда	
					
					Возврат Истина;
					
				ИначеЕсли ФайлОбмена.ЛокальноеИмя = "v8de:ConfigurationExtensions" 
					И ФайлОбмена.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
					
					Возврат Ложь;	
					
				КонецЕсли;
				
			КонецЦикла;
			
		ИначеЕсли ФайлОбмена.Имя = "v8de:Data" Тогда
			
			Возврат Ложь;	
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли