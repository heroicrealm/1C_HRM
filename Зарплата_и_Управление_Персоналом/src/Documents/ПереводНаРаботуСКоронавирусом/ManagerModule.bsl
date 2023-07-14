#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ПереводНаРаботуСКоронавирусом;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ПереводНаРаботуСКоронавирусом);
	
КонецФункции

Процедура ЗаполнитьСотрудников(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПереводНаРаботуСКоронавирусомФизическиеЛица.Ссылка КАК Ссылка,
		|	ПереводНаРаботуСКоронавирусомФизическиеЛица.Ссылка.Организация КАК Организация,
		|	ПереводНаРаботуСКоронавирусомФизическиеЛица.Ссылка.НачалоПериода КАК ДатаНачала,
		|	ПереводНаРаботуСКоронавирусомФизическиеЛица.Ссылка.ОкончаниеПериода КАК ДатаОкончания,
		|	ПереводНаРаботуСКоронавирусомФизическиеЛица.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	Документ.ПереводНаРаботуСКоронавирусом.ФизическиеЛица КАК ПереводНаРаботуСКоронавирусомФизическиеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереводНаРаботуСКоронавирусом.Сотрудники КАК ПереводНаРаботуСКоронавирусомСотрудники
		|		ПО ПереводНаРаботуСКоронавирусомФизическиеЛица.Ссылка = ПереводНаРаботуСКоронавирусомСотрудники.Ссылка
		|ГДЕ
		|	ПереводНаРаботуСКоронавирусомСотрудники.Ссылка ЕСТЬ NULL
		|	И НЕ ПереводНаРаботуСКоронавирусомФизическиеЛица.ФизическоеЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыРаботыСКоронавирусом.Регистратор КАК Регистратор,
		|	ПериодыРаботыСКоронавирусом.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПериодыРаботыСКоронавирусом.ДатаНачала КАК ДатаНачала,
		|	ПериодыРаботыСКоронавирусом.ДатаОкончания КАК ДатаОкончания,
		|	ПериодыРаботыСКоронавирусом.Организация КАК Организация
		|ИЗ
		|	РегистрСведений.ПериодыРаботыСКоронавирусом КАК ПериодыРаботыСКоронавирусом
		|ГДЕ
		|	ПериодыРаботыСКоронавирусом.Сотрудник = ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Регистратор";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	Если РезультатЗапроса[0].Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеВыполнено = Ложь;
	ДанныеКОбработке = РезультатЗапроса[0].Выгрузить();
	ФизическиеЛица = ОбщегоНазначения.ВыгрузитьКолонку(ДанныеКОбработке, "ФизическоеЛицо", Истина);
	ПараметрыПолучения = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолучения.СписокФизическихЛиц = ФизическиеЛица;
	ПараметрыПолучения.КадровыеДанные = "Организация, Должность, ДолжностьПоШтатномуРасписанию";
	СотрудникиОрганизации = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолучения);
	СотрудникиОрганизации.Колонки.Добавить("ПолучательСтимулирующихВыплатФСС", Новый ОписаниеТипов("Булево"));
	КатегорииДолжностей = РегистрыСведений.КатегорииДолжностейПолучателейСтимулирующихВыплатФСС.КатегорииДолжностей();
	ОбщегоНазначенияБЗК.ДобавитьИндексКоллекции(СотрудникиОрганизации, "ФизическоеЛицо, Организация");
	СтруктураПоиска = Новый Структура("ФизическоеЛицо, Организация");
	
	ФизлицаОрганизация = ДанныеКОбработке.Скопировать(,"ФизическоеЛицо, Организация");
	Для каждого ФизлицоОрганизации Из ФизлицаОрганизация Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, ФизлицоОрганизации);
		СотрудникиФизЛицаОрганизаций = СотрудникиОрганизации.НайтиСтроки(СтруктураПоиска);
		Если СотрудникиФизЛицаОрганизаций.Количество() = 1 Тогда
			// однозначное соответствие - не смотрим на категорию
			СотрудникиФизЛицаОрганизаций[0].ПолучательСтимулирующихВыплатФСС = Истина;
		ИначеЕсли СотрудникиФизЛицаОрганизаций.Количество() > 1 Тогда
			ЕстьПолучательСтимулирующихВыплатФСС = Ложь;
			Для Каждого СотрудникФизЛицаОрганизаций Из СотрудникиФизЛицаОрганизаций Цикл
				// пытаемся понять для какого сотрудника заполнена категория
				КатегорияДолжности = КатегорииДолжностей[СотрудникФизЛицаОрганизаций.ДолжностьПоШтатномуРасписанию];
				Если НЕ ЗначениеЗаполнено(КатегорияДолжности) Тогда
					КатегорияДолжности = КатегорииДолжностей[СотрудникФизЛицаОрганизаций.Должность];
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(КатегорияДолжности) Тогда
					Продолжить;
				КонецЕсли;
				
				СотрудникФизЛицаОрганизаций.ПолучательСтимулирующихВыплатФСС = Истина;
				ЕстьПолучательСтимулирующихВыплатФСС = Истина;
			КонецЦикла;
			
			Если НЕ ЕстьПолучательСтимулирующихВыплатФСС Тогда
				// Не нашли ни одного сотрудника с категорией.
				// значит помечаем всех!
				Для Каждого СотрудникФизЛицаОрганизаций Из СотрудникиФизЛицаОрганизаций Цикл
					СотрудникФизЛицаОрганизаций.ПолучательСтимулирующихВыплатФСС = Истина;
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	СтруктураПоиска.Вставить("ПолучательСтимулирующихВыплатФСС", Истина);//ищем только тех у кого в должности задана категория получателя
	
	ВыборкаДокументов = РезультатЗапроса[0].Выбрать();
	Пока ВыборкаДокументов.СледующийПоЗначениюПоля("Ссылка") Цикл
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
			ПараметрыОбновления, ВыборкаДокументов.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", ВыборкаДокументов.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектДокумента = ВыборкаДокументов.Ссылка.ПолучитьОбъект();
		Пока ВыборкаДокументов.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ВыборкаДокументов);
			НайденныеСтроки = СотрудникиОрганизации.НайтиСтроки(СтруктураПоиска);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НоваяСтрока = ОбъектДокумента.Сотрудники.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДокументов);
				НоваяСтрока.Сотрудник = НайденнаяСтрока.Сотрудник;
			КонецЦикла;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
	КонецЦикла;
	
	ВыборкаРегистра = РезультатЗапроса[1].Выбрать();
	Пока ВыборкаРегистра.СледующийПоЗначениюПоля("Регистратор") Цикл
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
			ПараметрыОбновления,
			"РегистрыСведений.ПериодыРаботыСКоронавирусом.НаборЗаписей",
			"Регистратор",
			ВыборкаРегистра.Регистратор) Тогда
			
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ПериодыРаботыСКоронавирусом.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистра.Регистратор);
		Пока ВыборкаРегистра.Следующий() Цикл
			Если Не ЗначениеЗаполнено(ВыборкаРегистра.ФизическоеЛицо) Тогда
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ВыборкаРегистра);
			НайденныеСтроки = СотрудникиОрганизации.НайтиСтроки(СтруктураПоиска);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НоваяСтрока = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРегистра);
				НоваяСтрока.Сотрудник = НайденнаяСтрока.Сотрудник;
			КонецЦикла;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
	КонецЦикла;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли