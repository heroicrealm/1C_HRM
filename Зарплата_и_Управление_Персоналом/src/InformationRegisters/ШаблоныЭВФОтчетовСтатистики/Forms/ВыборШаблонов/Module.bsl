#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ПроверитьОбновления") Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
	// Получаем список актуальных шаблонов с веб-сервиса ТОГС.
	СвойстваМодуля = Неопределено;
	ИмяРегистра = СтрРазделить(ЭтотОбъект.ИмяФормы, ".")[1];
	ТаблицаСвойствШаблонов = РегистрыСведений[ИмяРегистра].СписокШаблоновСервисаВебСбора(СвойстваМодуля);
	Если ТаблицаСвойствШаблонов = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("ОКУД, Код");
	ДляДобавления = Новый Массив;
	Для Каждого Стр Из ТаблицаСвойствШаблонов Цикл 
		Если СтрДлина(Стр.ОКУД) = 6 Тогда 
			Отбор.ОКУД = "0" + Стр.ОКУД;
			Отбор.Код = Стр.Код;
			Если ТаблицаСвойствШаблонов.НайтиСтроки(Отбор).Количество() = 0 Тогда 
				ДляДобавления.Добавить(Стр);
			КонецЕсли;
		ИначеЕсли СтрДлина(Стр.ОКУД) = 7 И СтрНачинаетсяС(Стр.ОКУД, "0") Тогда 
			Отбор.ОКУД = Прав(Стр.ОКУД, 6);
			Отбор.Код = Стр.Код;
			Если ТаблицаСвойствШаблонов.НайтиСтроки(Отбор).Количество() = 0 Тогда 
				ДляДобавления.Добавить(Стр);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из ДляДобавления Цикл
		Если СтрДлина(Стр.ОКУД) = 6 Тогда 
			НовСтр = ТаблицаСвойствШаблонов.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, Стр);
			НовСтр.ОКУД = Прав(Стр.ОКУД, 6);
		Иначе
			НовСтр = ТаблицаСвойствШаблонов.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, Стр);
			НовСтр.ОКУД = "0" + Стр.ОКУД;
		КонецЕсли;
	КонецЦикла;
	
	// Устанавливаем адрес для загрузки OFF-line модуля подготовки отчетности с сайта ТОГС.
	АдресМодуляПодготовкиОтчетов = СвойстваМодуля.ПутьДляЗагрузки;
	Если ЗначениеЗаполнено(СвойстваМодуля.ВерсияМодуля) И ЗначениеЗаполнено(АдресМодуляПодготовкиОтчетов) Тогда
		Элементы.ЗагрузитьМодульПодготовкиОтчетов.Заголовок =
			Элементы.ЗагрузитьМодульПодготовкиОтчетов.Заголовок + " версии " + СвойстваМодуля.ВерсияМодуля;
		Элементы.ЗагрузитьМодульПодготовкиОтчетов.Видимость = Истина;
	КонецЕсли;
	
	// Формируем таблицу шаблонов существующих в ИБ и требующих обновления.
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаСвойствШаблонов.ИДОбъекта,
	               |	ВЫРАЗИТЬ(ТаблицаСвойствШаблонов.Код КАК СТРОКА(20)) КАК КодШаблона,
	               |	ВЫРАЗИТЬ(ТаблицаСвойствШаблонов.Шифр КАК СТРОКА(20)) КАК Шифр,
	               |	ТаблицаСвойствШаблонов.Версия
	               |ПОМЕСТИТЬ ТаблицаСвойствШаблонов
	               |ИЗ
	               |	&ТаблицаСвойствШаблонов КАК ТаблицаСвойствШаблонов
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ТаблицаСвойствШаблонов.ИДОбъекта,
	               |	ТаблицаСвойствШаблонов.КодШаблона,
	               |	ТаблицаСвойствШаблонов.Шифр,
	               |	ТаблицаСвойствШаблонов.Версия,
	               |	ШаблоныЭВФОтчетовСтатистики.Версия КАК ВерсияСохраненного
	               |ИЗ
	               |	РегистрСведений.ШаблоныЭВФОтчетовСтатистики КАК ШаблоныЭВФОтчетовСтатистики
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаСвойствШаблонов КАК ТаблицаСвойствШаблонов
	               |		ПО ШаблоныЭВФОтчетовСтатистики.КодШаблона = ТаблицаСвойствШаблонов.КодШаблона
	               |			И ШаблоныЭВФОтчетовСтатистики.Шифр = ТаблицаСвойствШаблонов.Шифр";
	
	Запрос.УстановитьПараметр("ТаблицаСвойствШаблонов", ТаблицаСвойствШаблонов);
	
	МаксимальныеВерсии = Новый Соответствие;
	
	ТаблицаОбновляемыхШаблонов = Запрос.Выполнить().Выгрузить();
	ТаблицаОбновляемыхШаблонов.Колонки.Добавить("ДатаВерсии", Новый ОписаниеТипов("Дата"));
	ТаблицаОбновляемыхШаблонов.Колонки.Добавить("ДатаВерсииСохраненного", Новый ОписаниеТипов("Дата"));
	
	Для Каждого СтрокаТаблицыОбновляемыхШаблонов Из ТаблицаОбновляемыхШаблонов Цикл
		СтрокаТаблицыОбновляемыхШаблонов.ДатаВерсии = ДатаВерсии(СтрокаТаблицыОбновляемыхШаблонов.Версия);
		СтрокаТаблицыОбновляемыхШаблонов.ДатаВерсииСохраненного = ДатаВерсии(СтрокаТаблицыОбновляемыхШаблонов.ВерсияСохраненного);
		
		КлючШаблона = СтрокаТаблицыОбновляемыхШаблонов.КодШаблона + "_" + СтрокаТаблицыОбновляемыхШаблонов.Шифр;
		СтрокаСМаксимальнойВерсией = МаксимальныеВерсии[КлючШаблона];
		Если СтрокаСМаксимальнойВерсией = Неопределено
		 ИЛИ СтрокаСМаксимальнойВерсией.ДатаВерсииСохраненного <= СтрокаТаблицыОбновляемыхШаблонов.ДатаВерсииСохраненного Тогда
			МаксимальныеВерсии.Вставить(КлючШаблона, СтрокаТаблицыОбновляемыхШаблонов);
		КонецЕсли;
	КонецЦикла;
	
	КоличествоСтрокТаблицы = ТаблицаОбновляемыхШаблонов.Количество();
	Для Смещение = 1 По КоличествоСтрокТаблицы Цикл
		СтрокаТаблицыОбновляемыхШаблонов = ТаблицаОбновляемыхШаблонов[КоличествоСтрокТаблицы - Смещение];
		КлючШаблона = СтрокаТаблицыОбновляемыхШаблонов.КодШаблона + "_" + СтрокаТаблицыОбновляемыхШаблонов.Шифр;
		
		СтрокаСМаксимальнойВерсией = МаксимальныеВерсии[КлючШаблона];
		Если СтрокаСМаксимальнойВерсией <> СтрокаТаблицыОбновляемыхШаблонов Тогда
			ТаблицаОбновляемыхШаблонов.Удалить(СтрокаТаблицыОбновляемыхШаблонов);
			Продолжить;
		КонецЕсли;
		
		ДатаВерсииНовогоШаблона = СтрокаТаблицыОбновляемыхШаблонов.ДатаВерсии;
		ДатаВерсииСохраненногоШаблона = СтрокаТаблицыОбновляемыхШаблонов.ДатаВерсииСохраненного;
		
		Если ДатаВерсииНовогоШаблона = ДатаВерсииСохраненногоШаблона Тогда
			СтрокаТаблицыОбновляемыхШаблонов.ВерсияСохраненного = "*="; // звездочка - для отбора в таблице
		ИначеЕсли ДатаВерсииНовогоШаблона > ДатаВерсииСохраненногоШаблона Тогда
			СтрокаТаблицыОбновляемыхШаблонов.ВерсияСохраненного = "*<"; // звездочка - для отбора в таблице
		Иначе
			ТаблицаОбновляемыхШаблонов.Удалить(СтрокаТаблицыОбновляемыхШаблонов);
		КонецЕсли;
	КонецЦикла;
	
	// Заполняем таблицу "СвойстваШаблонов" и назначаем признаки для обновления.
	НайденыСохраненныеВИБ = Ложь;
	ЕстьОбновленные = Ложь;
	СвойстваШаблонов.Очистить();
	Для Каждого СтрокаСвойствШаблона Из ТаблицаСвойствШаблонов Цикл
		СвойстваШаблона = СвойстваШаблонов.Добавить();
		
		ЗаполнитьЗначенияСвойств(СвойстваШаблона, СтрокаСвойствШаблона, , "Ключи");
		СвойстваШаблона.Ключи.ЗагрузитьЗначения(СтрокаСвойствШаблона.Ключи);
		
		СвойстваОбновляемогоШаблона = ТаблицаОбновляемыхШаблонов.Найти(СвойстваШаблона.ИДОбъекта, "ИДОбъекта");
		Если СвойстваОбновляемогоШаблона <> Неопределено Тогда
			СвойстваШаблона.Обновить = Лев(СвойстваОбновляемогоШаблона.ВерсияСохраненного, 2);
			СвойстваШаблона.Пометка = ?(СвойстваШаблона.Обновить = "*<", Истина, Ложь);
			НайденыСохраненныеВИБ = Истина;
			Если СвойстваШаблона.Обновить = "*=" Тогда
				ЕстьОбновленные = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Управляем начальным отображением таблицы шаблонов.
	Если НайденыСохраненныеВИБ Тогда
		Элементы.СвойстваШаблонов.ОтборСтрок = Новый ФиксированнаяСтруктура("Обновить", "*");
		Элементы.СвойстваШаблоновПоказатьСохраненныеШаблоны.Пометка = Истина;
		Если ЕстьОбновленные И НЕ ЗначениеЗаполнено(СвойстваШаблонов.НайтиСтроки(Новый Структура("Пометка", Истина))) Тогда
			Элементы.СвойстваШаблоновУстановитьФлажкиТолькоОбновления.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.СвойстваШаблоновУстановитьФлажкиТолькоОбновления.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СвойстваШаблоновПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваШаблоновПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.Имя = "СвойстваШаблонов"
		И Элемент.ТекущийЭлемент.Имя <> "СвойстваШаблоновПометка" Тогда
		
		Отказ = Истина;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СвойстваШаблоновПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМодульПодготовкиОтчетовНажатие(Элемент)
	
	Попытка
		
		ПерейтиПоНавигационнойСсылке(АдресМодуляПодготовкиОтчетов);
		
	Исключение
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не удалось перейти по ссылке!'"));
		
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Если ЗначениеЗаполнено(СвойстваШаблонов.НайтиСтроки(Новый Структура("Пометка", Истина))) Тогда
		
		ОбновитьВыбранныеШаблоны();
		
	Иначе
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не отмечены шаблоны для обновления или добавления'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьИлиСнятьФлажки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьИлиСнятьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажкиТолькоОбновления(Команда)
	
	УстановитьИлиСнятьФлажки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСохраненныеШаблоны(Команда)
	
	Если ЗначениеЗаполнено(Элементы.СвойстваШаблонов.ОтборСтрок) Тогда
		Элементы.СвойстваШаблонов.ОтборСтрок = Неопределено;
		Элементы.СвойстваШаблоновПоказатьСохраненныеШаблоны.Пометка = Ложь;
	Иначе
		Элементы.СвойстваШаблонов.ОтборСтрок = Новый ФиксированнаяСтруктура("Обновить", "*");
		Элементы.СвойстваШаблоновПоказатьСохраненныеШаблоны.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДатаВерсии(СтрДата)
	
	Разделители = "-.,/";
	
	ДлинаСтроки = СтрДлина(СтрДата);
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить("");
	
	Для НС = 1 По ДлинаСтроки Цикл
		Сим = Сред(СтрДата, НС, 1);
		Если СтрНайти(Разделители, Сим) > 0 Тогда
			МассивПолей.Добавить("");
		ИначеЕсли СтрНайти("0123456789", Сим) > 0 Тогда
			МассивПолей[МассивПолей.ВГраница()] = МассивПолей[МассивПолей.ВГраница()] + Сим;
		КонецЕсли;
	КонецЦикла;
	
	День  = Макс(1, Число("0" + СокрЛП(МассивПолей[0])));
	Месяц = Макс(1, Число("0" + ?(МассивПолей.ВГраница() < 1, "1", СокрЛП(МассивПолей[1]))));
	Год   = Макс(1, Число("0" + ?(МассивПолей.ВГраница() < 2, "1", СокрЛП(МассивПолей[2]))));
	
	Возврат Дата(Год, Месяц, День);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьВыбранныеШаблоны()
	
	ОтмеченныеСтроки = СвойстваШаблонов.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	СвойстваШаблоновОтбор.Очистить();
	
	Для Каждого СтрокаСвойствШаблонов Из ОтмеченныеСтроки Цикл
		
		ЗаполнитьЗначенияСвойств(СвойстваШаблоновОтбор.Добавить(), СтрокаСвойствШаблонов);
		
	КонецЦикла;
	
	Закрыть(СвойстваШаблоновОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИлиСнятьФлажки(Пометка = Неопределено)
	
	УстановленОтбор = ЗначениеЗаполнено(Элементы.СвойстваШаблонов.ОтборСтрок);
	
	Для Каждого Элемент Из СвойстваШаблонов Цикл
		
		Если Пометка = Неопределено Тогда
			Элемент.Пометка = (Элемент.Обновить = "*<");
		ИначеЕсли НЕ УстановленОтбор ИЛИ (УстановленОтбор И ЗначениеЗаполнено(Элемент.Обновить)) Тогда
			Элемент.Пометка = Пометка;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти