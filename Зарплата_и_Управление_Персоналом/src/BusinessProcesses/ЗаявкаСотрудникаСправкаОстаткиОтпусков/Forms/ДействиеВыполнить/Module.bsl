
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Ссылка = Объект.Ссылка;
	Если Ссылка.Пустая() Тогда
		ИнициализироватьФормуЗадачи();
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
	
	Если ЗначениеЗаполнено(Задание.УдалитьФайлОтвета) Тогда
		ВызватьИсключение НСтр("ru = 'Заявка не доступна до окончания обновления.'");
	КонецЕсли;

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
	Элементы.Содержание.Заголовок = ЗаданиеСодержание;
	
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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполненоВыполнить(Команда)
		
	ВыполненоВыполнитьНаСервере();
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Комментарий) Тогда
		Объект.РезультатВыполнения = ЭтотОбъект.Комментарий;
	Иначе
		Объект.РезультатВыполнения = НСтр("ru = 'Выполнен'");
	КонецЕсли;
	
	ЗаданиеВыполнено = Истина;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Отказать(Команда)
	
	Отказ = Ложь;
	ОтказатьНаСервере(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(ЭтотОбъект.Комментарий) Тогда
		Объект.РезультатВыполнения = ЭтотОбъект.Комментарий;
	Иначе
		Объект.РезультатВыполнения = НСтр("ru = 'Отказ'");
	КонецЕсли;
	
	ЗаданиеВыполнено = Ложь;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);
	УстановитьВидимостьКнопокДействий();
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
Процедура Подключаемый_ВыбратьФайлОтвета(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ЗавершениеВыбратьФайлОтвета", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = 
		НСтр("ru = 'Файлы MS Word (*.doc;*.docx)|*.doc;*.docx|Файлы PDF(*.pdf;*.PDF)|*.pdf;*.PDF|
			 |Архив (*.zip;*.rar;*.7z)|*.zip;*.rar;*.7z'");

	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;

	ФайловаяСистемаКлиент.ЗагрузитьФайл(Обработчик, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УдалитьФайлНажатие(Элемент)
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьПрисоединенныйФайлЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Справка будет удалена. Удалить?'"), РежимДиалогаВопрос.ДаНет);	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФайлНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ЭтотОбъект[Элемент.Имя]);	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФайл(Команда)
	СформироватьФайлНаСервере();
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

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СерверныеОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ШаблонОтветаПриИзмененииНаСервере()
	БизнесПроцессыЗаявокСотрудниковФормы.ПослеВыбораШаблона(ЭтотОбъект, ШаблонОтвета, Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СерверныеОбработчикиКомандФормы

&НаСервере
Процедура ВыполненоВыполнитьНаСервере()
	
	Если Не ЗначениеЗаполнено(ФайлОтвета()) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'К заявке не прикреплены файлы. Невозможно выполнить заявку без файлов.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыЗаявокСотрудниковФормы.ВыполнитьБизнесПроцессЗаявки(СостояниеЗапроса, Исполнитель);
	
КонецПроцедуры

&НаСервере
Процедура ОтказатьНаСервере(Отказ)
	
	Если ПустаяСтрока(Задание.ОтветПоЗаявке)
		 И Не КабинетСотрудника.ВерсияПриложенияМеньшеВерсии("3.0.2.19") Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнена причина отказа.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыЗаявокСотрудниковФормы.ОтказатьБизнесПроцессЗаявки(СостояниеЗапроса, Исполнитель);
	
	// Удаляем документ КЭДО справки с места работы.
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДокументКадровогоЭДО.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
	               |ГДЕ
	               |	ДокументКадровогоЭДО.ОснованиеДокумента = &ЗаявкаСотрудника
	               |	И ДокументКадровогоЭДО.КатегорияДокумента = ЗНАЧЕНИЕ(Перечисление.КатегорииДокументовКадровогоЭДО.СправкаСотруднику)
	               |	И ДокументКадровогоЭДО.ПометкаУдаления = ЛОЖЬ";
		
	Запрос.УстановитьПараметр("ЗаявкаСотрудника", Задание.Ссылка);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДокументКЭДООбъект = Выборка.Ссылка.ПолучитьОбъект();
	    ДокументКЭДООбъект.ПометкаУдаления = Истина;
		ДокументКЭДООбъект.ДополнительныеСвойства.Вставить("РазрешенаПометкаУдаления", Истина);
		ДокументКЭДООбъект.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещения

&НаКлиенте
Процедура УдалитьПрисоединенныйФайлЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьПрисоединенныйФайлЗавершениеНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область РаботаСФайлами

&НаСервере
Процедура СформироватьФайлНаСервере()
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ФизическоеЛицо", Задание.ФизическоеЛицо);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Сотрудник
		|ИЗ
		|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ТекущиеКадровыеДанныеСотрудников.Сотрудник = Сотрудники.Ссылка
		|ГДЕ
		|	Сотрудники.ФизическоеЛицо = &ФизическоеЛицо
		|	И ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
		СотрудникиФизическогоЛица = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
			
		ТабДок = ПечатнаяФормаСправкаОбОстаткахОтпусков(СотрудникиФизическогоЛица);
		Поток = Новый ПотокВПамяти();
		ТабДок.Записать(Поток, ТипФайлаТабличногоДокумента.PDF);
		ДвоичныеДанные =  Поток.ЗакрытьИПолучитьДвоичныеДанные();
		АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		
		ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла("Описание, ФайлОтвета");
		ПараметрыФайла.ВладелецФайлов = Задание.Ссылка;
		ПараметрыФайла.ИмяБезРасширения = НСтр("ru = 'Справка об остатках отпуска'");
		ПараметрыФайла.РасширениеБезТочки = "pdf";
		ПараметрыФайла.ВремяИзмененияУниверсальное = ТекущаяУниверсальнаяДата();
		ПараметрыФайла.Служебный = Истина;
		ПараметрыФайла.ФайлОтвета = Истина;
		ПараметрыФайла.Описание = НСтр("ru = 'Приложение к заявке:'") + " " + Строка(Задание.Ссылка);
		
		ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресХранилища);
		БизнесПроцессыЗаявокСотрудников.СоздатьИзменитьДокументКЭДОСправкаСотруднику(ПрисоединенныйФайл, Задание.Ссылка, Ложь);
		Если ИспользуетсяКадровыйЭДО Тогда
			РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.ЗарегистрироватьОбработкуФайлов(
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПрисоединенныйФайл),
				Перечисления.ДействияСФайламиДокументовКЭДО.ПередатьВКабинетСотрудников,
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Исполнитель));
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
				
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Заявка сотрудника справка об остатке отпусков.Ошибка формирования файла справки'",
									  ОбщегоНазначения.КодОсновногоЯзыка()),
       							 УровеньЖурналаРегистрации.Ошибка,
        						 ,
        						 ,
        						 ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось сформировать файл'"));
	КонецПопытки;
	
	ОтразитьФайлыОтвета();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПечатнаяФормаСправкаОбОстаткахОтпусков(МассивОбъектов)
	
	ДокРезультат = Новый ТабличныйДокумент;
	ДокРезультат.АвтоМасштаб = Истина;
	ОтчетОбъект = Отчеты.СправкаПоОтпускам.Создать();
	ОтчетОбъект.ИнициализироватьОтчет();
	ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(
		ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.СправкаПоОтпускам.Настройки);
	ЗарплатаКадрыОтчеты.ДобавитьЭлементОтбора(
		ОтчетОбъект.КомпоновщикНастроек.Настройки.Отбор,
		"Сотрудник",
		ВидСравненияКомпоновкиДанных.ВСписке,
		МассивОбъектов);
	ОтчетОбъект.СкомпоноватьРезультат(ДокРезультат);
	
	Возврат ДокРезультат;
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеВыбратьФайлОтвета(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Данные = ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение);
	Если Данные.Размер() > КабинетСотрудникаКлиент.МаксимальныйРазмерПринимаемогоФайла() Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Сервис не может принять файлы размером более 5Мб. Выберите другой файл.'"));
		Возврат;
	КонецЕсли;
	
	ЗавершениеВыбратьФайлОтветаНаСервере(ПомещенныйФайл);	
	
КонецПроцедуры

&НаСервере
Процедура ЗавершениеВыбратьФайлОтветаНаСервере(ПомещенныйФайл)
	
	СтруктураИмениФайла = БизнесПроцессыЗаявокСотрудниковФормы.СтруктураИмениФайла(ПомещенныйФайл.Имя);
	Если СтруктураИмениФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		АдресХранилища = ПомещенныйФайл.Хранение;
		
		ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла("Описание, ФайлОтвета");
		ПараметрыФайла.ВладелецФайлов = Задание.Ссылка;
		ПараметрыФайла.ИмяБезРасширения = СтруктураИмениФайла.ИмяФайлаОтветаБезРасширения;
		ПараметрыФайла.РасширениеБезТочки = СтруктураИмениФайла.РасширениеФайлаОтветаБезТочки;
		ПараметрыФайла.ВремяИзмененияУниверсальное = ТекущаяУниверсальнаяДата();
		ПараметрыФайла.Служебный = Истина;
		ПараметрыФайла.ФайлОтвета = Истина;
		ПараметрыФайла.Описание = НСтр("ru = 'Приложение к заявке:'") + " " + Строка(Задание.Ссылка);
		
		ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресХранилища);
		БизнесПроцессыЗаявокСотрудников.СоздатьИзменитьДокументКЭДОСправкаСотруднику(ПрисоединенныйФайл, Задание.Ссылка, Ложь);
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Заявка сотрудника справка об остатках отпусков.Ошибка прикрепления файла справки'",
									  ОбщегоНазначения.КодОсновногоЯзыка()),
       							 УровеньЖурналаРегистрации.Ошибка,
        						 ,
        						 ,
        						 ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось прикрепить файл'"));
	КонецПопытки;
	
	ОтразитьФайлыОтвета();
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрисоединенныйФайл(ПрисоединенныйФайл)
	БизнесПроцессыЗаявокСотрудниковКлиент.ОткрытьПрисоединенныйФайл(ЭтотОбъект, ПрисоединенныйФайл);	
КонецПроцедуры

&НаСервере
Процедура ОтразитьФайлыОтвета()
	
	ДобавляемыеРеквизиты = Новый Массив;
	ЗначенияРеквизитов = Новый Структура;

	ИмяГруппы = "ГруппаФайлОтвета";
	ИмяРеквизита = "ФайлОтвета";
	
	СтруктураРеквизита = БизнесПроцессыЗаявокСотрудниковФормы.НовыйСтруктураРеквизитаФайлаОтвета();
	СтруктураРеквизита.ИмяРеквизита						= ИмяРеквизита;
	СтруктураРеквизита.ИмяТаблицыПрисоединенногоФайла	= "ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы";
		
	ГруппаФайлОтвета = Элементы.Найти(ИмяГруппы);
	Если ГруппаФайлОтвета = Неопределено Тогда
		БизнесПроцессыЗаявокСотрудниковФормы.ДобавитьЭлементыФайлаОтвета(ЭтотОбъект,
																		 ИмяГруппы,
																		 СтруктураРеквизита,
																		 ДобавляемыеРеквизиты);
		ЭлементВыбратьФайлОтвета = Элементы["Выбрать" + ИмяРеквизита];																 
		ЭлементВыбратьФайлОтвета.Заголовок = НСтр("ru = 'Выбрать файл'");
		Элементы.Переместить(ЭлементВыбратьФайлОтвета, Элементы.ГруппаСформироватьИПодписатьФайлы);
	КонецЕсли;

	ФайлОтветаСсылка = ФайлОтвета();
	ФайлОтвета = Элементы[ИмяРеквизита];
	БизнесПроцессыЗаявокСотрудниковФормы.ЗаполнитьЭлементыФайлаОтвета(ЭтотОбъект,
																	  ФайлОтвета,
																	  ФайлОтветаСсылка,
																	  ИмяРеквизита,
																	  ЗначенияРеквизитов);
	Элементы[ИмяРеквизита + "Подписан"].Видимость = Ложь;																  
																	  
	Если ДобавляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	УстановитьВидимостьКнопокДействий();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьПрисоединенныйФайлЗавершениеНаСервере()
	
	ФайлОтветаОбъект = ФайлОтвета().ПолучитьОбъект();
	ФайлОтветаОбъект.ПометкаУдаления = Истина;
	ФайлОтветаОбъект.Записать();
	
	ОтразитьФайлыОтвета();
	
КонецПроцедуры

&НаСервере
Функция ФайлОтвета() 
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы КАК ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы
	               |ГДЕ
	               |	ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	               |	И ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.ФайлОтвета = ИСТИНА
	               |	И ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Задание.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.ЗаявкаСотрудникаСправкаОстаткиОтпусковПрисоединенныеФайлы.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ИнициализироватьФормуЗадачи()
	
	БизнесПроцессыЗаявокСотрудниковФормы.ИнициализироватьФормуЗадачи(ЭтотОбъект);
	ИспользуетсяКадровыйЭДО = ПолучитьФункциональнуюОпцию("ИспользуетсяКадровыйЭДОКабинетСотрудника");
	ОтразитьФайлыОтвета();
		
	Элементы.Содержание.Заголовок = ЗаданиеСодержание;
	Элементы.Содержание.Видимость = НЕ (ЗаданиеСодержание = "");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокДействий()
	
	БизнесПроцессыЗаявокСотрудниковФормы.УстановитьВидимостьКнопокДействий(ЭтотОбъект, Неопределено, Истина);
	
	Если Объект.Выполнена Тогда
		Элементы.СформироватьФайл.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ФайлПодготовлен = ЗначениеЗаполнено(ФайлОтвета());
	Элементы.СформироватьФайл.Доступность = Не ФайлПодготовлен;
	Элементы.Выполнено.Доступность = Элементы.Выполнено.Доступность И ФайлПодготовлен;
	
КонецПроцедуры

#КонецОбласти

