#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру для инициализации бизнес-процесса.
//	Возвращаемое значение:
//		Структура - структура используемая при создании заявки сотрудника.
Функция СтруктураИнициализацииЗаявки() Экспорт
	
	СтруктураИнициализации = БизнесПроцессыЗаявокСотрудников.СтруктураИнициализацииЗаявки();
	СтруктураИнициализации.Вставить("КомментарийСотрудника",	"");
	СтруктураИнициализации.Вставить("Организация",				Справочники.Организации.ПустаяСсылка());
	СтруктураИнициализации.Вставить("СпособРасчета", 			Перечисления.СпособыРасчетаУдержанийКабинетСотрудника.ПустаяСсылка());
	СтруктураИнициализации.Вставить("РазмерУдержанияПроцент", 	0);
	СтруктураИнициализации.Вставить("РазмерУдержанияСумма",		0);
	
	Возврат СтруктураИнициализации
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка -
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	Результат = Новый Массив;
	Результат.Добавить("Автор");
	Результат.Добавить("Важность");
	Результат.Добавить("Исполнитель");
	Результат.Добавить("ПроверитьВыполнение");
	Результат.Добавить("Проверяющий");
	Результат.Добавить("СрокИсполнения");
	Результат.Добавить("СрокПроверки");
	Возврат Результат;	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры:
//   ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
// Возвращаемое значение:
//   Структура   - структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", "БизнесПроцесс.ЗаявкаСотрудникаДобровольныеСтраховыеВзносы.Форма.Действие" + ТочкаМаршрутаБизнесПроцесса.Имя);
	Возврат Результат;	
КонецФункции

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - перенаправляемая задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	// АПК:1327-выкл Блокировка бизнес-процесса установлена ранее
	// в вызывающей функции БизнесПроцессыИЗадачиВызовСервера.ПеренаправитьЗадачи.
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
	БизнесПроцессОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) 
		+ БизнесПроцессОбъект.РезультатВыполнения;
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект.Записать();
	// АПК:1327-вкл	
КонецПроцедуры

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   БизнесПроцессСсылка - БизнесПроцессСсылка - бизнес-процесс, по которому сформирована задача ЗадачаСсылка.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	БизнесПроцессыЗаявокСотрудников.ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка,
																   БизнесПроцессСсылка,
																   ТочкаМаршрутаБизнесПроцесса);	
КонецПроцедуры	

// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Задание
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|ПО
	|	ИсполнителиЗадач.РольИсполнителя = Задание.Исполнитель
	|	И ИсполнителиЗадач.ОсновнойОбъектАдресации = Задание.ОсновнойОбъектАдресации
	|	И ИсполнителиЗадач.ДополнительныйОбъектАдресации = Задание.ДополнительныйОбъектАдресации
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ПроверяющиеЗадач
	|ПО
	|	ПроверяющиеЗадач.РольИсполнителя = Задание.Проверяющий
	|	И ПроверяющиеЗадач.ОсновнойОбъектАдресации = Задание.ОсновнойОбъектАдресацииПроверяющий
	|	И ПроверяющиеЗадач.ДополнительныйОбъектАдресации = Задание.ДополнительныйОбъектАдресацииПроверяющий
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)
	|	ИЛИ ЗначениеРазрешено(Исполнитель КРОМЕ Справочник.РолиИсполнителей)
	|	ИЛИ ЗначениеРазрешено(ИсполнителиЗадач.Исполнитель)
	|	ИЛИ ЗначениеРазрешено(Проверяющий КРОМЕ Справочник.РолиИсполнителей)
	|	ИЛИ ЗначениеРазрешено(ПроверяющиеЗадач.Исполнитель)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)";	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Команда = МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.БизнесПроцессы.Задание);
		Если Команда <> Неопределено Тогда
			Команда.ФункциональныеОпции = "ИспользоватьБизнесПроцессыИЗадачи";
		КонецЕсли;
		Возврат Команда;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает состояние элементов формы задачи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - где:
//   * Элементы - ВсеЭлементыФормы - где:
//    ** Предмет - РасширениеПоляФормыДляПоляНадписи - 
// 
Процедура УстановитьСостояниеЭлементовФормыЗадачи(Форма) Экспорт
	
	Если Форма.Элементы.Найти("РезультатВыполнения") <> Неопределено 
		И Форма.Элементы.Найти("ИсторияВыполнения") <> Неопределено Тогда
			Форма.Элементы.ИсторияВыполнения.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Форма.ЗаданиеРезультатВыполнения);
	КонецЕсли;
	
	Форма.Элементы.Предмет.Гиперссылка = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
	Форма.ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Форма.Объект.Предмет);	
	
КонецПроцедуры

Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)
	
	СтрокаФормат = "%1, %2 " + НСтр("ru = 'перенаправил(а) задачу'") + ":
		|%3
		|";
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, ЗадачаСсылка.ДатаИсполнения, ЗадачаСсылка.Исполнитель, Комментарий);
	Возврат Результат;
	
КонецФункции

#Область ОбработчикиОбновленияИнформационнойБазы

Процедура ЗаполнитьСодержимоеДокументаКадровогоЭДОЗаявокСотрудников(ПараметрыОбновления = Неопределено) Экспорт
	БизнесПроцессыЗаявокСотрудников.ЗаполнитьСодержимоеДокументаКадровогоЭДОЗаявокСотрудников(
		"БизнесПроцесс.ЗаявкаСотрудникаДобровольныеСтраховыеВзносы",
		ПараметрыОбновления);	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли