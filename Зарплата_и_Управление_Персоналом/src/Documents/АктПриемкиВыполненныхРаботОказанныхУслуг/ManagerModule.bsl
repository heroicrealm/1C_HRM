#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акт приема-передачи выполненных работ (услуг).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_АктСдачиПриемкиВыполненныхРаботУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Акт приема-передачи выполненных работ (услуг)'");
	
	// Акт приема-передачи выполненных работ (услуг) (поэтапное закрытие).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_АктПоэтапнойСдачиПриемаВыполненныхРаботУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Акт приема-передачи выполненных работ (услуг) (поэтапное закрытие)'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДоговорыСотрудника(Организация, Сотрудник) Экспорт

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДоговорАвторскогоЗаказа", Строка(ТипЗнч(Документы.ДоговорАвторскогоЗаказа.ПустаяСсылка())));
	Запрос.УстановитьПараметр("ДоговорРаботыУслуги", Строка(ТипЗнч(Документы.ДоговорРаботыУслуги.ПустаяСсылка())));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорАвторскогоЗаказа.Ссылка КАК Договор,
	|	ДоговорАвторскогоЗаказа.Номер КАК Номер,
	|	ДоговорАвторскогоЗаказа.Дата КАК Дата,
	|	ДоговорАвторскогоЗаказа.ДатаНачала КАК ДатаНачала,
	|	ДоговорАвторскогоЗаказа.ДатаОкончания КАК ДатаОкончания,
	|	ДоговорАвторскогоЗаказа.Сумма КАК Сумма,
	|	ДоговорАвторскогоЗаказа.Подразделение КАК Подразделение,
	|	ДоговорАвторскогоЗаказа.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	&ДоговорАвторскогоЗаказа КАК ТипДокумента,
	|	ДоговорАвторскогоЗаказа.СтатьяФинансирования,
	|	ДоговорАвторскогоЗаказа.СтатьяРасходов
	|ИЗ
	|	Документ.ДоговорАвторскогоЗаказа КАК ДоговорАвторскогоЗаказа
	|ГДЕ
	|	ДоговорАвторскогоЗаказа.Проведен
	|	И ДоговорАвторскогоЗаказа.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот)
	|	И ДоговорАвторскогоЗаказа.Сотрудник = &Сотрудник
	|	И ДоговорАвторскогоЗаказа.Организация = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорРаботыУслуги.Ссылка,
	|	ДоговорРаботыУслуги.Номер,
	|	ДоговорРаботыУслуги.Дата,
	|	ДоговорРаботыУслуги.ДатаНачала,
	|	ДоговорРаботыУслуги.ДатаОкончания,
	|	ДоговорРаботыУслуги.Сумма,
	|	ДоговорРаботыУслуги.Подразделение,
	|	ДоговорРаботыУслуги.СпособОтраженияЗарплатыВБухучете,
	|	&ДоговорРаботыУслуги,
	|	ДоговорРаботыУслуги.СтатьяФинансирования,
	|	ДоговорРаботыУслуги.СтатьяРасходов
	|ИЗ
	|	Документ.ДоговорРаботыУслуги КАК ДоговорРаботыУслуги
	|ГДЕ
	|	ДоговорРаботыУслуги.Проведен
	|	И ДоговорРаботыУслуги.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот)
	|	И ДоговорРаботыУслуги.Сотрудник = &Сотрудник
	|	И ДоговорРаботыУслуги.Организация = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли