
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Ссылка = Объект.Ссылка;
	Если Ссылка.Пустая() Тогда
		ИнициализироватьФормуЗадачи();
		Элементы.Содержание.Заголовок = ЗаданиеСодержание;
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
			
	Если Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
			
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ПараметрыГиперссылки = МодульРаботаСФайлами.ГиперссылкаФайлов();
		ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
		ПараметрыГиперссылки.Владелец = "Объект.БизнесПроцесс";
		МодульРаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
			
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	БизнесПроцессыЗаявокСотрудниковФормы.ЗаписатьРеквизитыБизнесПроцесса(ЭтотОбъект, ТекущийОбъект);
	
	ВыполнитьЗадачу = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыЗаписи, "ВыполнитьЗадачу", Ложь);
	Если НЕ ВыполнитьЗадачу Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаданиеВыполнено И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отклоняется.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	Если ИмяСобытия = "Запись_Задание" Тогда
		Если (Источник = Объект.БизнесПроцесс ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
			И Источник.Найти(Объект.БизнесПроцесс) <> Неопределено)) Тогда
			Прочитать();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ЗаявкиСотрудниковЗаписанДокумент" Тогда
		Если (Источник = ЭтотОбъект) Тогда
			ЗаписанДокументОтсутствие(Параметр);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ШаблонОтветаЗаписанСправочник" Тогда
		Если (Источник = ЭтотОбъект) Тогда
			ШаблонОтвета = Параметр;
			Элементы.ШаблонОтвета.Видимость = Истина;
			ШаблонОтветаПриИзмененииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализироватьФормуЗадачи();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеФайлаОтветаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ФайлОтвета);	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлНажатие(Элемент)
	УдалитьПрисоединенныйФайл();	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФайлНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ЭтотОбъект[Элемент.Имя]);	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонОтветаПриИзменении(Элемент)
	ШаблонОтветаПриИзмененииНаСервере();	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаданиеОтсутствия

&НаКлиенте
Процедура ЗаданиеОтсутствияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ЗаданиеОтсутствияПриОкончанииРедактированияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеОтсутствияПослеУдаления(Элемент)
	ЗаданиеОтсутствияПриОкончанииРедактированияНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполненоВыполнить(Команда)
	Если ПодписыватьЗаявкиСотрудника
		 И ПричинаОтсутствияТребуетЭП(Задание.ПричинаОтсутствия) Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ВыполненоВыполнитьЗавершение");
	Иначе
		ВыполненоВыполнитьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отказать(Команда)
	
	Отказ = Ложь;
	ОтказатьНаСервере(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если ПодписыватьЗаявкиСотрудника
		 И ПричинаОтсутствияТребуетЭП(Задание.ПричинаОтсутствия) Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ОтказатьЗавершение");
	Иначе
		ОтказатьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	ПараметрыФормыДокумента = ПараметрыФормыДокумента();
	ОткрытьФормуСозданияДокумента(ПараметрыФормыДокумента.НаименованиеФормы,
								  ПараметрыФормыДокумента.ПараметрыЗаполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОформитьКомандировкуСовместителю(Команда)
	ОткрытьФормуСозданияДокумента("Документ.Командировка.ФормаОбъекта",
								  ПараметрыЗаполненияКомандировкиСовместителя());
КонецПроцедуры

&НаКлиенте
Процедура ОформитьОтпускБезОплатыСовместителю(Команда)
	ОткрытьФормуСозданияДокумента("Документ.ОтпускБезСохраненияОплаты.ФормаОбъекта",
								  ПараметрыЗаполненияОтпускаБезОплатыСовместителя());
КонецПроцедуры

&НаКлиенте
Процедура ОформитьОтпускСовместителю(Команда)
	ОткрытьФормуСозданияДокумента("Документ.Отпуск.ФормаОбъекта",
								  ПараметрыЗаполненияОтпускаСовместителя());
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	Прочитать();
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗадание(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	ПоказатьЗначение(,Объект.БизнесПроцесс);	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлОтвета(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ВыбратьФайлОтветаПослеПомещенияФайла", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Файлы MS Word (*.doc;*.docx)|*.doc;*.docx|Файлы PDF(*.pdf;*.PDF)|*.pdf;*.PDF'");

	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;

	ФайловаяСистемаКлиент.ЗагрузитьФайл(Обработчик, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьШаблонОтвета(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.СохранитьШаблонОтвета(ЭтотОбъект);
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	КонецЕсли;	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СерверныеОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ШаблонОтветаПриИзмененииНаСервере()
	БизнесПроцессыЗаявокСотрудниковФормы.ПослеВыбораШаблона(ЭтотОбъект, ШаблонОтвета, Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СерверныеОбработчикиСобытийТаблицыЗаданиеОтсутствия

&НаСервере
Процедура ЗаданиеОтсутствияПриОкончанииРедактированияНаСервере()
	ЗаданиеОбъект = РеквизитФормыВЗначение("Задание");
	ЗаданиеОбъект.Отсутствия.Очистить();
	Для каждого Запись Из Задание.Отсутствия Цикл
		Если НЕ ЗначениеЗаполнено(Запись.Отсутствие) Тогда
			Продолжить;
		КонецЕсли;
		НоваяЗапись = ЗаданиеОбъект.Отсутствия.Добавить();
		НоваяЗапись.Отсутствие = Запись.Отсутствие;
	КонецЦикла;
	ЗаданиеОбъект.Записать();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");
	УстановитьВидимостьКнопокДействий();
КонецПроцедуры

#КонецОбласти

#Область СерверныеОбработчикиКомандФормы

&НаСервере
Процедура ОтказатьНаСервере(Отказ)
	Если ПустаяСтрока(Задание.ОтветПоЗаявке)
		 И Не КабинетСотрудника.ВерсияПриложенияМеньшеВерсии("3.0.2.19") Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнена причина отказа.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещения

&НаКлиенте
Процедура ВыбратьФайлОтветаПослеПомещенияФайла(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыЗаявокСотрудниковКлиент.ВыбратьФайлОтветаПослеПомещенияФайла(ЭтотОбъект,
																			   ПомещенныйФайл,
																			   ДополнительныеПараметры);																		   
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	БизнесПроцессыЗаявокСотрудниковКлиент.ВыполненоВыполнитьЗавершение(ЭтотОбъект, Результат, ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	БизнесПроцессыЗаявокСотрудниковКлиент.ОтказатьЗавершение(ЭтотОбъект, Результат, ДополнительныеПараметры);
КонецПроцедуры	

#КонецОбласти

#Область ОткрытиеФормДокументов

&НаКлиенте
Процедура ОткрытьФормуСозданияДокумента(НаименованиеФормы, ПараметрыЗаполненияДокумента)
	Если НаименованиеФормы <> "" Тогда
		ОткрытьФорму(НаименованиеФормы, ПараметрыЗаполненияДокумента, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыДокумента()
	
	ПараметрыФормыДокумента = Новый Структура("НаименованиеФормы, ПараметрыЗаполнения");
	
	ПараметрыЗаполнения = Новый Структура;
	НаименованиеФормы = "";
	
	ПричиныОтсутствия = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника;
	ПричинаОтсутствия = Задание.ПричинаОтсутствия;
	Если  ПричинаОтсутствия = ПричиныОтсутствия.ЛичныеДела
		  ИЛИ ПричинаОтсутствия = ПричиныОтсутствия.Опоздание Тогда
		ЗаполнитьПараметрыЗаполненияПрогулНеявка(ПараметрыЗаполнения);
		НаименованиеФормы = "Документ.ПрогулНеявка.ФормаОбъекта";
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.Отгул Тогда
		ЗаполнитьПараметрыЗаполненияОтгул(ПараметрыЗаполнения);
		НаименованиеФормы = "Документ.Отгул.ФормаОбъекта";
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.ОтпускПоУходуЗаРебенком Тогда
		ЗаполнитьПараметрыЗаполненияОтпускПоУходу(ПараметрыЗаполнения);
		НаименованиеФормы = "Документ.ОтпускПоУходуЗаРебенком.ФормаОбъекта";
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.ДниУходаЗаДетьмиИнвалидами Тогда
		ЗаполнитьПараметрыЗаполненияУходЗаРебенком(ПараметрыЗаполнения);
		НаименованиеФормы = "Документ.ОплатаДнейУходаЗаДетьмиИнвалидами.ФормаОбъекта";
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.Командировка Тогда
		ЗаполнитьПараметрыЗаполненияКомандировка(ПараметрыЗаполнения);
		НаименованиеФормы = "Документ.Командировка.ФормаОбъекта";
	КонецЕсли;
	
	ПараметрыФормыДокумента.НаименованиеФормы = НаименованиеФормы;
	ПараметрыФормыДокумента.ПараметрыЗаполнения = ПараметрыЗаполнения;
	
	Возврат ПараметрыФормыДокумента;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияПрогулНеявка(ПараметрыЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "ЗаполнитьПоПараметрамЗаполнения");
	ДанныеЗаполнения.Вставить("ДатаНачала", ?(ЗначениеЗаполнено(Задание.ДатаНачалаОтсутствия), Задание.ДатаНачалаОтсутствия,
																							   Задание.ДатаОкончанияОтсутствия));
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	Если Задание.Организация.Пустая() Тогда
		ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиИнформационнойБазы(Истина, Задание.ФизическоеЛицо, Задание.ДатаНачалаОтсутствия);
		ОсновнойСотрудник = ОсновныеСотрудники[Задание.ФизическоеЛицо];
		ДанныеЗаполнения.Вставить("Сотрудник", ОсновнойСотрудник);
		КадровыеДанныеОсновногоСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОсновнойСотрудник, "Организация", Задание.ДатаНачалаОтсутствия);
		ОрганизацияОсновногоСотрудника = КадровыеДанныеОсновногоСотрудника.Найти(ОсновнойСотрудник).Организация;
		ДанныеЗаполнения.Вставить("Организация", ОрганизацияОсновногоСотрудника);
	Иначе
		ДанныеЗаполнения.Вставить("Организация", Задание.Организация);	
		ДанныеЗаполнения.Вставить("Сотрудник", КадровыйУчет.ОсновнойСотрудникФизическогоЛица(Задание.ФизическоеЛицо,
																			 			 	 Задание.Организация,
																			 			 	 Задание.ДатаНачалаОтсутствия));
	КонецЕсли;
	ЧасовОтсутствия = (Задание.ДатаОкончанияОтсутствия - Задание.ДатаНачалаОтсутствия)/3600;
	Если ЧасовОтсутствия < 23 Тогда
		ДанныеЗаполнения.Вставить("ОтсутствиеВТечениеЧастиСмены", Истина);
		ДанныеЗаполнения.Вставить("ЧасовОтсутствия", ЧасовОтсутствия);
	КонецЕсли;
	
	ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияОтгул(ПараметрыЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "ЗаполнитьПоПараметрамЗаполнения");
	ДанныеЗаполнения.Вставить("ДатаНачала", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	Если Задание.Организация.Пустая() Тогда
		ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиИнформационнойБазы(Истина, Задание.ФизическоеЛицо, Задание.ДатаНачалаОтсутствия);
		ОсновнойСотрудник = ОсновныеСотрудники[Задание.ФизическоеЛицо];
		ДанныеЗаполнения.Вставить("Сотрудник", ОсновнойСотрудник);
		КадровыеДанныеОсновногоСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОсновнойСотрудник, "Организация", Задание.ДатаНачалаОтсутствия);
		ОрганизацияОсновногоСотрудника = КадровыеДанныеОсновногоСотрудника.Найти(ОсновнойСотрудник).Организация;
		ДанныеЗаполнения.Вставить("Организация", ОрганизацияОсновногоСотрудника);
	Иначе
		ДанныеЗаполнения.Вставить("Организация", Задание.Организация);	
		ДанныеЗаполнения.Вставить("Сотрудник", КадровыйУчет.ОсновнойСотрудникФизическогоЛица(Задание.ФизическоеЛицо,
																			 			 	 Задание.Организация,
																			 			 	 Задание.ДатаНачалаОтсутствия));
	КонецЕсли;
	ДанныеЗаполнения.Вставить("КоличествоДнейОтгула",
							  УчетРабочегоВремениРасширенный.КоличествоДнейПоГрафикуРаботыСотрудника(ДанныеЗаполнения.Сотрудник,
							  																		 ДанныеЗаполнения.ДатаНачала,
																									 ДанныеЗаполнения.ДатаОкончания));																					 
	
	ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияОтпускПоУходу(ПараметрыЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	
	ДанныеЗаполнения.Вставить("Действие", "ЗаполнитьПоПараметрамЗаполнения");	
	ДанныеЗаполнения.Вставить("ДатаНачала", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	Если Задание.Организация.Пустая() Тогда
		ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиИнформационнойБазы(Истина, Задание.ФизическоеЛицо, Задание.ДатаНачалаОтсутствия);
		ОсновнойСотрудник = ОсновныеСотрудники[Задание.ФизическоеЛицо];
		КадровыеДанныеОсновногоСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОсновнойСотрудник, "Организация", Задание.ДатаНачалаОтсутствия);
		ОрганизацияОсновногоСотрудника = КадровыеДанныеОсновногоСотрудника.Найти(ОсновнойСотрудник).Организация;
		ДанныеЗаполнения.Вставить("Организация", ОрганизацияОсновногоСотрудника);
	Иначе
		ДанныеЗаполнения.Вставить("Организация", Задание.Организация);	
	КонецЕсли;
	ДанныеЗаполнения.Вставить("Сотрудник", Задание.ФизическоеЛицо);
	
	ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияУходЗаРебенком(ПараметрыЗаполнения)
	
	ДниУхода = Новый Массив;
	ДеньУхода = Задание.ДатаНачалаОтсутствия; 
	Пока ДеньУхода <= Задание.ДатаОкончанияОтсутствия Цикл
		ДниУхода.Добавить(Новый Структура("Дата", ДеньУхода));
		ДеньУхода = ДеньУхода + 86400;
	КонецЦикла;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "ЗаполнитьПоПараметрамЗаполнения");
	ДанныеЗаполнения.Вставить("ДатаНачала", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	ДанныеЗаполнения.Вставить("ДниУхода", ДниУхода);
	ДанныеЗаполнения.Вставить("ФизическоеЛицо", Задание.ФизическоеЛицо);
	Если Задание.Организация.Пустая() Тогда
		ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиИнформационнойБазы(Истина, Задание.ФизическоеЛицо, Задание.ДатаНачалаОтсутствия);
		ОсновнойСотрудник = ОсновныеСотрудники[Задание.ФизическоеЛицо];
		ДанныеЗаполнения.Вставить("Сотрудник", ОсновнойСотрудник);
		КадровыеДанныеОсновногоСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОсновнойСотрудник, "Организация", Задание.ДатаНачалаОтсутствия);
		ОрганизацияОсновногоСотрудника = КадровыеДанныеОсновногоСотрудника.Найти(ОсновнойСотрудник).Организация;
		ДанныеЗаполнения.Вставить("Организация", ОрганизацияОсновногоСотрудника);
	Иначе
		ДанныеЗаполнения.Вставить("Организация", Задание.Организация);	
		ДанныеЗаполнения.Вставить("Сотрудник", КадровыйУчет.ОсновнойСотрудникФизическогоЛица(Задание.ФизическоеЛицо,
																			 			 	 Задание.Организация,
																			 			 	 Задание.ДатаНачалаОтсутствия));
	КонецЕсли;
	
	ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияКомандировка(ПараметрыЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "Заполнить");	
	Если Задание.Организация.Пустая() Тогда
		ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиИнформационнойБазы(Истина, Задание.ФизическоеЛицо, Задание.ДатаНачалаОтсутствия);
		ОсновнойСотрудник = ОсновныеСотрудники[Задание.ФизическоеЛицо];
		ДанныеЗаполнения.Вставить("Сотрудник", ОсновнойСотрудник);
		КадровыеДанныеОсновногоСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОсновнойСотрудник, "Организация", Задание.ДатаНачалаОтсутствия);
		ОрганизацияОсновногоСотрудника = КадровыеДанныеОсновногоСотрудника.Найти(ОсновнойСотрудник).Организация;
		ДанныеЗаполнения.Вставить("Организация", ОрганизацияОсновногоСотрудника);
	Иначе
		ДанныеЗаполнения.Вставить("Организация", Задание.Организация);	
		ДанныеЗаполнения.Вставить("Сотрудник", КадровыйУчет.ОсновнойСотрудникФизическогоЛица(Задание.ФизическоеЛицо,
																			 			 	 Задание.Организация,
																			 			 	 Задание.ДатаНачалаОтсутствия));
	КонецЕсли;
	ДанныеЗаполнения.Вставить("ДатаНачала", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	ДанныеЗаполнения.Вставить("ЗаполнитьПоПараметрамЗаполнения", Истина);
	
	ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(ДругиеСотрудникиФизическогоЛица) Тогда
		УстановитьДругихСотрудниковФизическогоЛица(ДанныеЗаполнения.Организация, ДанныеЗаполнения.Сотрудник);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыЗаполненияКомандировкиСовместителя()
	
	Совместитель = СовместительСотрудника();
	
	Командировка = Задание.Отсутствия[0].Отсутствие;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "Заполнить");	
	ДанныеЗаполнения.Вставить("Организация", Совместитель.Организация);
	ДанныеЗаполнения.Вставить("Сотрудник", Совместитель.Сотрудник);
	ДанныеЗаполнения.Вставить("ДатаНачала", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	Если ТипЗнч(Командировка) = Тип("ДокументСсылка.Командировка") Тогда
		РеквизитыКомандировки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Командировка, "ВнутрисменнаяКомандировка, ДатаКомандировки,
																						 |ОплачиватьЧасов, МестоНазначения,
																 						 |ОрганизацияНазначения, КомандировкаЗаСчетСредств,
																 						 |ДнейВПути, Цель");
		ДанныеЗаполнения.Вставить("ОтсутствиеВТечениеЧастиСмены", РеквизитыКомандировки.ВнутрисменнаяКомандировка);
		ДанныеЗаполнения.Вставить("ДатаОтсутствия", РеквизитыКомандировки.ДатаКомандировки);
		ДанныеЗаполнения.Вставить("ЧасовОтпуска", РеквизитыКомандировки.ОплачиватьЧасов);
		ДанныеЗаполнения.Вставить("МестоНазначения", РеквизитыКомандировки.МестоНазначения);
		ДанныеЗаполнения.Вставить("ОрганизацияНазначения", РеквизитыКомандировки.ОрганизацияНазначения);
		ДанныеЗаполнения.Вставить("КомандировкаЗаСчетСредств", РеквизитыКомандировки.КомандировкаЗаСчетСредств);
		ДанныеЗаполнения.Вставить("ДнейВПути", РеквизитыКомандировки.ДнейВПути);
		ДанныеЗаполнения.Вставить("Цель", РеквизитыКомандировки.Цель);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ДанныеЗаполнения);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Функция ПараметрыЗаполненияОтпускаСовместителя()
	
	Совместитель = СовместительСотрудника();
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Ссылка", Неопределено);
	ДанныеЗаполнения.Вставить("Действие", "Заполнить");
	
	ДанныеЗаполнения.Вставить("Организация", Совместитель.Организация);
	ДанныеЗаполнения.Вставить("Сотрудник", Совместитель.Сотрудник);
	
	ДанныеОтпусков = Новый Массив();
	НоваяСтрокаОтпуска = ДанныеЗаполненияСтроки();
	НоваяСтрокаОтпуска.ВидОтпуска = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Основной");
	НоваяСтрокаОтпуска.ДатаНачала = Задание.ДатаНачалаОтсутствия;
	НоваяСтрокаОтпуска.ДатаОкончания = Задание.ДатаОкончанияОтсутствия;
	
	КоличествоДнейОтпуска = КоличествоДнейПоВидуОтпуска(Совместитель.Сотрудник, ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Основной"),
														Задание.ДатаНачалаОтсутствия, Задание.ДатаОкончанияОтсутствия);
	
	НоваяСтрокаОтпуска.КоличествоДней = КоличествоДнейОтпуска;
	ДанныеОтпусков.Добавить(НоваяСтрокаОтпуска);
	
	ДанныеЗаполнения.Вставить("ДанныеОтпусков", ДанныеОтпусков);
	
	ПараметрыФормы = Новый Структура("Основание", ДанныеЗаполнения);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Функция ПараметрыЗаполненияОтпускаБезОплатыСовместителя()
	
	Совместитель = СовместительСотрудника();
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "Заполнить");	
	ДанныеЗаполнения.Вставить("Организация", Совместитель.Организация);
	ДанныеЗаполнения.Вставить("Сотрудник", Совместитель.Сотрудник);
	ДанныеЗаполнения.Вставить("ДатаНачала", Задание.ДатаНачалаОтсутствия);
	ДанныеЗаполнения.Вставить("ДатаОкончания", Задание.ДатаОкончанияОтсутствия);
	
	Командировка = Задание.Отсутствия[0].Отсутствие;
	Если ТипЗнч(Командировка) = Тип("ДокументСсылка.Командировка") Тогда
		РеквизитыКомандировки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Командировка, "ВнутрисменнаяКомандировка, ДатаКомандировки,
																						 |ОплачиватьЧасов");
		ДанныеЗаполнения.Вставить("ОтсутствиеВТечениеЧастиСмены", РеквизитыКомандировки.ВнутрисменнаяКомандировка);
		ДанныеЗаполнения.Вставить("ДатаОтсутствия", РеквизитыКомандировки.ДатаКомандировки);
		ДанныеЗаполнения.Вставить("ЧасовОтпуска", РеквизитыКомандировки.ОплачиватьЧасов);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ДанныеЗаполнения);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДанныеЗаполненияСтроки()
	
	СтруктураОтпуска = Новый Структура;
		
	СтруктураОтпуска.Вставить("ВидОтпуска");
	СтруктураОтпуска.Вставить("ДатаНачала");
	СтруктураОтпуска.Вставить("ДатаОкончания");
	СтруктураОтпуска.Вставить("КоличествоДней");
	СтруктураОтпуска.Вставить("КоличествоДнейКомпенсации", 0);
	СтруктураОтпуска.Вставить("НачалоПериодаЗаКоторыйПредоставляетсяОтпуск", '00010101');
	СтруктураОтпуска.Вставить("КонецПериодаЗаКоторыйПредоставляетсяОтпуск", '00010101');
	СтруктураОтпуска.Вставить("Основание", "");
	СтруктураОтпуска.Вставить("ВидОтпускаПрежний", Неопределено);
	СтруктураОтпуска.Вставить("ИндексСтрокиДокумента", Неопределено);
	
	Возврат СтруктураОтпуска;
	
КонецФункции

&НаСервереБезКонтекста
Функция КоличествоДнейПоВидуОтпуска(Сотрудник, ВидОтпуска, ДатаНачала, ДатаОкончания)
	
	ОтпускВРабочихДняхПоДоговору = ОстаткиОтпусков.ОтпускСотрудникаВРабочихДняхПоДоговору(Сотрудник, ДатаНачала);
	
	ОписаниеВидаОтпуска = ОстаткиОтпусков.ОписаниеВидаОтпуска(ВидОтпуска, ОтпускВРабочихДняхПоДоговору);
	КоличествоДнейОсновногоОтпуска = УчетРабочегоВремениРасширенный.ДлительностьИнтервала(Сотрудник, ДатаНачала, ДатаОкончания, ОписаниеВидаОтпуска.СпособРасчетаПоКалендарнымДням, ОписаниеВидаОтпуска.ЕжегодныйОтпуск);
	
	Возврат КоличествоДнейОсновногоОтпуска;
	
КонецФункции

&НаСервере
Функция	СовместительСотрудника()
	
	Совместитель = Новый Структура;

	Если ДругиеСотрудникиФизическогоЛица.Количество() > 0 Тогда
		Совместитель.Вставить("Организация", ДругиеСотрудникиФизическогоЛица[0].Организация);
		Совместитель.Вставить("Сотрудник", ДругиеСотрудникиФизическогоЛица[0].Сотрудник);
	КонецЕсли;
	
	Возврат Совместитель;
	
КонецФункции

&НаСервере
Процедура УстановитьДругихСотрудниковФизическогоЛица(Организация, Сотрудник)
	
	Если Задание.ПричинаОтсутствия <> Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника.Командировка Тогда
		Возврат;
	КонецЕсли;	
	
	ДанныеДругихСотрудниковФизическогоЛица = Новый Массив;
	
	ДругиеСотрудники = КадровыйУчетРасширенный.ДругиеСотрудникиФизическогоЛица(
				Задание.ФизическоеЛицо, Организация, Сотрудник, Задание.ДатаНачалаОтсутствия, Задание.ДатаОкончанияОтсутствия);
				
	Если ДругиеСотрудники.Количество() > 0  Тогда
					
		КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ДругиеСотрудники, "Организация");
		
		Для каждого КадровыеДанныеСотрудника Из КадровыеДанныеСотрудников Цикл
			ДанныеДругогоСотрудникаФизическогоЛица = Новый Структура("Сотрудник, Организация", КадровыеДанныеСотрудника.Сотрудник, КадровыеДанныеСотрудника.Организация);
			ДанныеДругихСотрудниковФизическогоЛица.Добавить(Новый ФиксированнаяСтруктура(ДанныеДругогоСотрудникаФизическогоЛица));
		КонецЦикла;
		
	КонецЕсли;
				
	ДругиеСотрудникиФизическогоЛица = Новый ФиксированныйМассив(ДанныеДругихСотрудниковФизическогоЛица);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ИнициализироватьФормуЗадачи()
	
	БизнесПроцессыЗаявокСотрудниковФормы.ИнициализироватьФормуЗадачи(ЭтотОбъект, Элементы.ЗаданиеОтсутствия);
	УстановитьВидимостьКнопокДействий();
	
	Элементы.НачалоВремяОтсутствия.Видимость = Ложь;
	Элементы.ОкончаниеВремяОтсутствия.Видимость = Ложь;
	Если НачалоДня(Задание.ДатаНачалаОтсутствия) = НачалоДня(Задание.ДатаОкончанияОтсутствия) Тогда
		Элементы.ЗаданиеДатаОкончанияОтсутствия.Видимость = Ложь;
		Элементы.ЗаданиеДатаНачалаОтсутствия.Заголовок = НСтр("ru = 'Дата отсутствия'");
		Элементы.ЗаданиеДатаНачалаОтсутствия.Формат = НСтр("ru = 'ДФ=дд.ММ.гггг'");
		НачалоВремяОтсутствия = Формат(Задание.ДатаНачалаОтсутствия, НСтр("ru = 'ДФ=ЧЧ:мм'"));
		ОкончаниеВремяОтсутствия = Формат(Задание.ДатаОкончанияОтсутствия, НСтр("ru = 'ДФ=ЧЧ:мм'"));
		Если Задание.ДатаНачалаОтсутствия <> Задание.ДатаОкончанияОтсутствия И (НачалоВремяОтсутствия <> "00:00"
																				И ОкончаниеВремяОтсутствия <> "23:59") Тогда
			Элементы.НачалоВремяОтсутствия.Видимость = Истина;
			Элементы.ОкончаниеВремяОтсутствия.Видимость = Истина;
		КонецЕсли;
	ИначеЕсли НЕ ЗначениеЗаполнено(Задание.ДатаНачалаОтсутствия) Тогда
		Элементы.ЗаданиеДатаНачалаОтсутствия.Видимость = Ложь;
		Элементы.ЗаданиеДатаОкончанияОтсутствия.Заголовок = НСтр("ru = 'Дата отсутствия'");
		Элементы.ЗаданиеДатаОкончанияОтсутствия.Формат = НСтр("ru = 'ДФ=дд.ММ.гггг'");
		ОкончаниеВремяОтсутствия = Формат(Задание.ДатаОкончанияОтсутствия, НСтр("ru = 'ДФ=ЧЧ:мм'"));
		Элементы.ОкончаниеВремяОтсутствия.Видимость = Истина;
		Элементы.ОкончаниеВремяОтсутствия.Заголовок = НСтр("ru = 'До'");
	КонецЕсли;
	
	Элементы.ЗаданиеОтсутствияОтсутствие.ОграничениеТипа = ДоступныеТипыДокументов();
			
	Если Задание.Отсутствия.Количество() > 0 Тогда
		РеквизитыКомандировки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Задание.Отсутствия[0].Отсутствие, "Организация, Сотрудник");
		УстановитьДругихСотрудниковФизическогоЛица(РеквизитыКомандировки.Организация, РеквизитыКомандировки.Сотрудник);
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьВидимостьКнопокДействий()
	
	ПричинаОтсутствия = Задание.ПричинаОтсутствия;
	ПричиныОтсутствия = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника;
		
	БизнесПроцессыЗаявокСотрудниковФормы.УстановитьВидимостьКнопокДействий(ЭтотОбъект, Задание.Отсутствия);
	
	Если Объект.Выполнена Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Выполнено.Доступность = Элементы.Выполнено.Доступность ИЛИ Задание.ДействиеНеТребуется;
	Элементы.СоздатьДокумент.Доступность = Элементы.СоздатьДокумент.Доступность И (НЕ Задание.ДействиеНеТребуется);
	Элементы.ЗаданиеОтсутствия.Видимость = Элементы.ЗаданиеОтсутствия.Видимость И (НЕ Задание.ДействиеНеТребуется);
	Элементы.НеПредусмотренДокумент.Видимость = Задание.ДействиеНеТребуется;
	
	Если ПричинаОтсутствия = ПричиныОтсутствия.Командировка Тогда
		СозданДокумент = (Задание.Отсутствия.Количество() > 0);
		ЕстьСовместители = ЗначениеЗаполнено(ДругиеСотрудникиФизическогоЛица) И ДругиеСотрудникиФизическогоЛица.Количество() > 0;
		Элементы.СоздатьДокумент.Видимость = Элементы.СоздатьДокумент.Видимость И НЕ СозданДокумент;
		Элементы.ГруппаДополнительныеДокументыКомандировка.Видимость = СозданДокумент И ЕстьСовместители;
		
		Элементы.СоздатьДокумент.Доступность = Элементы.СоздатьДокумент.Доступность И ПолучитьФункциональнуюОпцию("ИспользоватьОплатуКомандировок");
		Элементы.Выполнено.Доступность = (НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОплатуКомандировок")) ИЛИ Элементы.Выполнено.Доступность;
		Элементы.ОтсутствияПоДругимМестамРаботыОформитьКомандировкуСовместителю.Доступность = ПолучитьФункциональнуюОпцию("ИспользоватьОплатуКомандировок");
		Элементы.ОтсутствияПоДругимМестамРаботыОформитьОтпускБезОплатыСовместителю.Доступность = ПолучитьФункциональнуюОпцию("ИспользоватьОтпускаБезОплаты");
		Элементы.ОтсутствияПоДругимМестамРаботыОформитьОтпускСовместителю.Доступность = ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчетРасширенная");
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.Отгул Тогда
		Элементы.СоздатьДокумент.Доступность = Элементы.СоздатьДокумент.Доступность И ПолучитьФункциональнуюОпцию("ИспользоватьОтгулы");
		Элементы.Выполнено.Доступность = (НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОтгулы")) ИЛИ Элементы.Выполнено.Доступность;
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.ДниУходаЗаДетьмиИнвалидами Тогда
		Элементы.СоздатьДокумент.Доступность = Элементы.СоздатьДокумент.Доступность И ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
		Элементы.Выполнено.Доступность = (НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная")) ИЛИ Элементы.Выполнено.Доступность;
	КонецЕсли;
									
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрисоединенныйФайл(ПрисоединенныйФайл)
	БизнесПроцессыЗаявокСотрудниковКлиент.ОткрытьПрисоединенныйФайл(ЭтотОбъект, ПрисоединенныйФайл);	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПрисоединенныйФайл()
	Модифицированность = Истина;
	ФайлОтвета = Неопределено;
	РасширениеФайлаОтветаБезТочки = "";
	ПредставлениеФайлаОтвета = "";
	АдресХранилищаФайлаОтвета = "";	
КонецПроцедуры

&НаСервере
Функция ДоступныеТипыДокументов()
	
	ДоступныеТипы = Новый Массив;
	
	ПричиныОтсутствия = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника;
	ПричинаОтсутствия = Задание.ПричинаОтсутствия;
	Если ПричинаОтсутствия = ПричиныОтсутствия.Командировка Тогда
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ПрогулНеявка"));
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.Командировка"));
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.Отпуск"));
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ОтпускБезСохраненияОплаты"));
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.ДниУходаЗаДетьмиИнвалидами Тогда
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ОплатаДнейУходаЗаДетьмиИнвалидами"));
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.ЛичныеДела Тогда
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ПрогулНеявка"));
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.ОтпускПоУходуЗаРебенком Тогда
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ОтпускПоУходуЗаРебенком"));
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.Отгул Тогда
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.Отгул"));
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.Опоздание Тогда
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ПрогулНеявка"));
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ОтпускБезСохраненияОплаты"));
		ДоступныеТипы.Добавить(Тип("ДокументСсылка.ДанныеДляРасчетаЗарплаты"));
	КонецЕсли;
	
	Возврат (Новый ОписаниеТипов(ДоступныеТипы));
	
КонецФункции

&НаКлиенте
Процедура ЗаписанДокументОтсутствие(Результат)
	
	Отсутствие = Неопределено;
	Если Результат <> Неопределено Тогда
		Отсутствие = Результат;
	КонецЕсли;
		
	Если Отсутствие = Неопределено ИЛИ Отсутствие.Пустая() Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписанДокументОтсутствиеНаСервере(Отсутствие);
	УстановитьВидимостьКнопокДействий();
			
КонецПроцедуры

&НаСервере
Процедура ЗаписанДокументОтсутствиеНаСервере(Отсутствие)
	ЗаданиеОбъект = РеквизитФормыВЗначение("Задание");
	Если ЗаданиеОбъект.Отсутствия.Найти(Отсутствие) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	НоваяЗапись = ЗаданиеОбъект.Отсутствия.Добавить();
	НоваяЗапись.Отсутствие = Отсутствие;
	ЗаданиеОбъект.Записать();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПричинаОтсутствияТребуетЭП(ПричинаОтсутствия)
	Если ПричинаОтсутствия = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника.ЛичныеДела
		 ИЛИ ПричинаОтсутствия = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника.Опоздание Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции

#КонецОбласти

