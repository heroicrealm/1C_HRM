#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Мероприятия.Сотрудник, NULL КАК ИСТИНА)
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
	
	МетаданныеДокумента = Метаданные.Документы.РегистрацияТрудовойДеятельности;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведенияДокумента(СсылкаНаДокумент) Экспорт
	
	ДанныеДляПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СсылкаНаДокумент", СсылкаНаДокумент);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РегистрацияТрудовойДеятельностиМероприятия.Ссылка КАК Ссылка,
		|	РегистрацияТрудовойДеятельностиМероприятия.Сотрудник КАК ФизическоеЛицо,
		|	РегистрацияТрудовойДеятельностиМероприятия.Ссылка.Организация КАК Организация,
		|	РегистрацияТрудовойДеятельностиМероприятия.ИдМероприятия КАК ИдМероприятия,
		|	ВЫБОР
		|		КОГДА РегистрацияТрудовойДеятельностиМероприятия.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Отменено,
		|	РегистрацияТрудовойДеятельностиМероприятия.СотрудникЗаписи КАК Сотрудник,
		|	РегистрацияТрудовойДеятельностиМероприятия.ДатаМероприятия КАК ДатаМероприятия,
		|	РегистрацияТрудовойДеятельностиМероприятия.ВидМероприятия КАК ВидМероприятия,
		|	РегистрацияТрудовойДеятельностиМероприятия.Сведения КАК Сведения,
		|	РегистрацияТрудовойДеятельностиМероприятия.Подразделение КАК Подразделение,
		|	РегистрацияТрудовойДеятельностиМероприятия.Должность КАК Должность,
		|	РегистрацияТрудовойДеятельностиМероприятия.РазрядКатегория КАК РазрядКатегория,
		|	РегистрацияТрудовойДеятельностиМероприятия.КодПоРееструДолжностей КАК КодПоРееструДолжностей,
		|	РегистрацияТрудовойДеятельностиМероприятия.ТрудоваяФункция КАК ТрудоваяФункция,
		|	РегистрацияТрудовойДеятельностиМероприятия.НаименованиеДокументаОснования КАК НаименованиеДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.ДатаДокументаОснования КАК ДатаДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.СерияДокументаОснования КАК СерияДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.НомерДокументаОснования КАК НомерДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.НаименованиеВторогоДокументаОснования КАК НаименованиеВторогоДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.ДатаВторогоДокументаОснования КАК ДатаВторогоДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.СерияВторогоДокументаОснования КАК СерияВторогоДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.НомерВторогоДокументаОснования КАК НомерВторогоДокументаОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОснованиеУвольнения КАК ОснованиеУвольнения,
		|	РегистрацияТрудовойДеятельностиМероприятия.ДатаС КАК ДатаС,
		|	РегистрацияТрудовойДеятельностиМероприятия.ДатаПо КАК ДатаПо,
		|	РегистрацияТрудовойДеятельностиМероприятия.ДатаОтмены КАК ДатаОтмены,
		|	РегистрацияТрудовойДеятельностиМероприятия.ЯвляетсяСовместителем КАК ЯвляетсяСовместителем,
		|	РегистрацияТрудовойДеятельностиМероприятия.ПредставлениеДолжности КАК ПредставлениеДолжности,
		|	РегистрацияТрудовойДеятельностиМероприятия.ПредставлениеПодразделения КАК ПредставлениеПодразделения,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОснованиеУвольненияТекстОснования КАК ОснованиеУвольненияТекстОснования,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОснованиеУвольненияСтатья КАК ОснованиеУвольненияСтатья,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОснованиеУвольненияЧасть КАК ОснованиеУвольненияЧасть,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОснованиеУвольненияПункт КАК ОснованиеУвольненияПункт,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОснованиеУвольненияПодпункт КАК ОснованиеУвольненияПодпункт,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОснованиеУвольненияАбзац КАК ОснованиеУвольненияАбзац,
		|	РегистрацияТрудовойДеятельностиМероприятия.КодПоОКЗ КАК КодПоОКЗ,
		|	РегистрацияТрудовойДеятельностиМероприятия.ТерриториальныеУсловия КАК ТерриториальныеУсловия,
		|	РегистрацияТрудовойДеятельностиМероприятия.ОписаниеДолжности КАК ОписаниеДолжности,
		|	РегистрацияТрудовойДеятельностиМероприятия.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.РегистрацияТрудовойДеятельности.Мероприятия КАК РегистрацияТрудовойДеятельностиМероприятия
		|ГДЕ
		|	РегистрацияТрудовойДеятельностиМероприятия.Ссылка В(&СсылкаНаДокумент)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	НомерСтроки";
	
	ДвиженияДокумента = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДвиженияДокумента.Добавить(ЭлектронныеТрудовыеКнижки.ЗаписьДвиженияМероприятияТрудовойДеятельности(Выборка, Ложь));
	КонецЦикла;
	
	ДанныеДляПроведения.Вставить("МероприятияТрудовойДеятельности", ДвиженияДокумента);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

Функция ДанныеДляПроведенияМероприятияТрудовойДеятельностиСЗВТД(СсылкаНаДокумент)
	
	ДанныеДляПроведения = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	Запрос.УстановитьПараметр("ПустойИдентификатор", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник КАК ФизическоеЛицо,
		|	ТаблицаДокумента.ДатаМероприятия КАК ДатаМероприятия,
		|	ТаблицаДокумента.ВидМероприятия КАК ВидМероприятия,
		|	ТаблицаДокумента.Сведения КАК Сведения,
		|	ТаблицаДокумента.Должность КАК Должность,
		|	ТаблицаДокумента.КодПоРееструДолжностей КАК КодПоРееструДолжностей,
		|	ТаблицаДокумента.РазрядКатегория КАК РазрядКатегория,
		|	ТаблицаДокумента.Подразделение КАК Подразделение,
		|	ТаблицаДокумента.ТрудоваяФункция КАК ТрудоваяФункция,
		|	ТаблицаДокумента.НаименованиеДокументаОснования КАК НаименованиеДокументаОснования,
		|	ТаблицаДокумента.ДатаДокументаОснования КАК ДатаДокументаОснования,
		|	ТаблицаДокумента.НомерДокументаОснования КАК НомерДокументаОснования,
		|	ТаблицаДокумента.СерияДокументаОснования КАК СерияДокументаОснования,
		|	ТаблицаДокумента.НаименованиеВторогоДокументаОснования КАК НаименованиеВторогоДокументаОснования,
		|	ТаблицаДокумента.ДатаВторогоДокументаОснования КАК ДатаВторогоДокументаОснования,
		|	ТаблицаДокумента.НомерВторогоДокументаОснования КАК НомерВторогоДокументаОснования,
		|	ТаблицаДокумента.СерияВторогоДокументаОснования КАК СерияВторогоДокументаОснования,
		|	ТаблицаДокумента.ОснованиеУвольнения КАК ОснованиеУвольнения,
		|	ТаблицаДокумента.ДатаС КАК ДатаС,
		|	ТаблицаДокумента.ДатаПо КАК ДатаПо,
		|	ТаблицаДокумента.ДатаОтмены КАК ДатаОтмены,
		|	ТаблицаДокумента.ИдМероприятия КАК ИдМероприятия,
		|	ТаблицаДокумента.СотрудникЗаписи КАК Сотрудник,
		|	ВЫБОР
		|		КОГДА ТаблицаДокумента.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Отменено,
		|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
		|	ТаблицаДокумента.ЯвляетсяСовместителем КАК ЯвляетсяСовместителем,
		|	ТаблицаДокумента.ПредставлениеДолжности КАК ПредставлениеДолжности,
		|	ТаблицаДокумента.ПредставлениеПодразделения КАК ПредставлениеПодразделения,
		|	ТаблицаДокумента.ОснованиеУвольненияТекстОснования КАК ОснованиеУвольненияТекстОснования,
		|	ТаблицаДокумента.ОснованиеУвольненияСтатья КАК ОснованиеУвольненияСтатья,
		|	ТаблицаДокумента.ОснованиеУвольненияЧасть КАК ОснованиеУвольненияЧасть,
		|	ТаблицаДокумента.ОснованиеУвольненияПункт КАК ОснованиеУвольненияПункт,
		|	ТаблицаДокумента.ОснованиеУвольненияПодпункт КАК ОснованиеУвольненияПодпункт,
		|	ТаблицаДокумента.ОснованиеУвольненияАбзац КАК ОснованиеУвольненияАбзац,
		|	ТаблицаДокумента.КодПоОКЗ КАК КодПоОКЗ,
		|	ТаблицаДокумента.ТерриториальныеУсловия КАК ТерриториальныеУсловия,
		|	ТаблицаДокумента.ОписаниеДолжности КАК ОписаниеДолжности
		|ИЗ
		|	Документ.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.Мероприятия КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК Мероприятия
		|		ПО ТаблицаДокумента.Сотрудник = Мероприятия.ФизическоеЛицо
		|			И ТаблицаДокумента.СотрудникЗаписи = Мероприятия.Сотрудник
		|			И ТаблицаДокумента.Ссылка.Организация = Мероприятия.Организация
		|			И ТаблицаДокумента.ИдМероприятия = Мероприятия.ИдМероприятия
		|			И (ВЫБОР
		|				КОГДА ТаблицаДокумента.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1)
		|					ТОГДА ЛОЖЬ
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ = Мероприятия.Отменено)
		|			И (НЕ Мероприятия.Регистратор В (&Ссылка))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельностиПрочие КАК МероприятияПрочие
		|		ПО ТаблицаДокумента.Сотрудник = МероприятияПрочие.ФизическоеЛицо
		|			И ТаблицаДокумента.СотрудникЗаписи = МероприятияПрочие.Сотрудник
		|			И ТаблицаДокумента.Ссылка.Организация = МероприятияПрочие.Организация
		|			И ТаблицаДокумента.ИдМероприятия = МероприятияПрочие.ИдМероприятия
		|			И (ВЫБОР
		|				КОГДА ТаблицаДокумента.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1)
		|					ТОГДА ЛОЖЬ
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ = МероприятияПрочие.Отменено)
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В(&Ссылка)
		|	И Мероприятия.ИдМероприятия ЕСТЬ NULL
		|	И МероприятияПрочие.ИдМероприятия ЕСТЬ NULL
		|	И ТаблицаДокумента.Ссылка.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ДвиженияДокумента = Новый Массив;
		ДанныеДляПроведения.Вставить(Выборка.Ссылка, ДвиженияДокумента);
		
		Пока Выборка.Следующий() Цикл
			Запись = ЭлектронныеТрудовыеКнижки.ЗаписьДвиженияМероприятияТрудовойДеятельности(Выборка, Ложь);
			ДвиженияДокумента.Добавить(Запись);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СформироватьНаборыЗаписейМероприятияТрудовойДеятельности(МероприятияТрудовойДеятельности, ПараметрыОбновления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ПараметрыОбновления = Неопределено Тогда
		МассивОбновленных = Новый Массив;
	Иначе
		
		Если ПараметрыОбновления.Свойство("МассивОбновленных") Тогда
			МассивОбновленных = ПараметрыОбновления.МассивОбновленных;
		Иначе
			МассивОбновленных = Новый Массив;
			ПараметрыОбновления.Вставить("МассивОбновленных", МассивОбновленных);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОбновленных", МассивОбновленных);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Ссылка.ДокументПринятВПФР КАК ДокументПринятВПФР
		|ИЗ
		|	Документ.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.Мероприятия КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК Мероприятия
		|		ПО ТаблицаДокумента.Ссылка.Организация = Мероприятия.Организация
		|			И ТаблицаДокумента.ИдМероприятия = Мероприятия.ИдМероприятия
		|			И (ВЫБОР
		|				КОГДА ТаблицаДокумента.ДатаОтмены = ДАТАВРЕМЯ(1, 1, 1)
		|					ТОГДА ЛОЖЬ
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ = Мероприятия.Отменено)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельностиПрочие КАК МероприятияПрочие
		|		ПО ТаблицаДокумента.Ссылка.Организация = МероприятияПрочие.Организация
		|			И ТаблицаДокумента.ИдМероприятия = МероприятияПрочие.ИдМероприятия
		|ГДЕ
		|	НЕ ТаблицаДокумента.Ссылка В (&МассивОбновленных)
		|	И ТаблицаДокумента.Ссылка.Проведен
		|	И ЕСТЬNULL(Мероприятия.ИдМероприятия, МероприятияПрочие.ИдМероприятия) ЕСТЬ NULL
		|	И НЕ ТаблицаДокумента.Ссылка.Организация.ИНН ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументПринятВПФР УБЫВ";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	ОбрабатываемыеДокументы = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	РеквизитыОбновляемыхДокументов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ОбрабатываемыеДокументы, "Дата,Организация,Ответственный,Комментарий");
	
	ДанныеДляПроведенияДокументов = ДанныеДляПроведенияМероприятияТрудовойДеятельностиСЗВТД(ОбрабатываемыеДокументы);
	Для Каждого Регистратор Из ОбрабатываемыеДокументы Цикл
		
		МассивОбновленных.Добавить(Регистратор);
		ДанныеДляПроведения = ДанныеДляПроведенияДокументов.Получить(Регистратор);
		Если ДанныеДляПроведения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект = Документы.РегистрацияТрудовойДеятельности.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(ДокументОбъект, РеквизитыОбновляемыхДокументов.Получить(Регистратор));
		
		Для Каждого СтрокаДанных Из ДанныеДляПроведения Цикл
			
			СтрокаМероприятия = ДокументОбъект.Мероприятия.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаМероприятия, СтрокаДанных);
			СтрокаМероприятия.Сотрудник = СтрокаДанных.ФизическоеЛицо;
			СтрокаМероприятия.СотрудникЗаписи = СтрокаДанных.Сотрудник;
			Если ЗначениеЗаполнено(СтрокаДанных.Сотрудник) Тогда
				СтрокаМероприятия.СотрудникЗаписи = СтрокаДанных.Сотрудник;
			Иначе
				СтрокаМероприятия.СотрудникЗаписи = КадровыйУчет.ОсновнойСотрудникФизическогоЛица(
					СтрокаМероприятия.Сотрудник, ДокументОбъект.Организация, СтрокаМероприятия.ДатаМероприятия);
			КонецЕсли;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Истина, Истина, РежимЗаписиДокумента.Запись);
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, , , РежимЗаписиДокумента.Проведение);
		Исключение
			
			ИнформацияОшибки = ИнформацияОбОшибке();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Электронные трудовые книжки'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				ДокументОбъект.Метаданные(),
				ДокументОбъект.Ссылка,
				ПодробноеПредставлениеОшибки(ИнформацияОшибки));
			
		КонецПопытки;
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтменитьЗадвоенныеМероприятияКадровыхПриказов(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДатаНачалаУчета", ЭлектронныеТрудовыеКнижки.ДатаНачалаУчета());
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Мероприятия.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Мероприятия.Организация КАК Организация,
		|	Мероприятия.ИдМероприятия КАК ИдМероприятия,
		|	Мероприятия.Отменено КАК Отменено,
		|	Мероприятия.ВидМероприятия КАК ВидМероприятия,
		|	Мероприятия.ДатаМероприятия КАК ДатаМероприятия,
		|	Мероприятия.ЯвляетсяСовместителем КАК ЯвляетсяСовместителем,
		|	Мероприятия.Регистратор КАК Регистратор,
		|	Мероприятия.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТМероприятияКадровыхПриказов
		|ИЗ
		|	РегистрСведений.МероприятияТрудовойДеятельности КАК Мероприятия
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельностиПереданные КАК МероприятияПереданные
		|		ПО Мероприятия.Организация = МероприятияПереданные.Организация
		|			И Мероприятия.ИдМероприятия = МероприятияПереданные.ИдМероприятия
		|			И Мероприятия.Отменено = МероприятияПереданные.Отменено
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК МероприятияОтмененные
		|		ПО Мероприятия.Организация = МероприятияОтмененные.Организация
		|			И Мероприятия.ИдМероприятия = МероприятияОтмененные.ИдМероприятия
		|			И (МероприятияОтмененные.Отменено)
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(Мероприятия.Регистратор) <> ТИП(Документ.РегистрацияТрудовойДеятельности)
		|	И Мероприятия.ВидМероприятия В (ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Прием), ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Перевод), ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение))
		|	И НЕ Мероприятия.Отменено
		|	И МероприятияПереданные.ИдМероприятия ЕСТЬ NULL
		|	И МероприятияОтмененные.ИдМероприятия ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Мероприятия.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Мероприятия.Организация КАК Организация,
		|	Мероприятия.ИдМероприятия КАК ИдМероприятия,
		|	Мероприятия.Отменено КАК Отменено,
		|	Мероприятия.ВидМероприятия КАК ВидМероприятия,
		|	Мероприятия.ДатаМероприятия КАК ДатаМероприятия,
		|	Мероприятия.ЯвляетсяСовместителем КАК ЯвляетсяСовместителем,
		|	Мероприятия.Регистратор КАК Регистратор,
		|	Мероприятия.Сотрудник КАК Сотрудник,
		|	МероприятияПереданные.Регистратор.ОтчетныйПериод КАК РегистраторОтчетныйПериод
		|ПОМЕСТИТЬ ВТМероприятияРегистрацийТрудовойДеятельности
		|ИЗ
		|	РегистрСведений.МероприятияТрудовойДеятельности КАК Мероприятия
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельностиПереданные КАК МероприятияПереданные
		|		ПО Мероприятия.Организация = МероприятияПереданные.Организация
		|			И Мероприятия.ИдМероприятия = МероприятияПереданные.ИдМероприятия
		|			И Мероприятия.Отменено = МероприятияПереданные.Отменено
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК МероприятияОтмененные
		|		ПО Мероприятия.Организация = МероприятияОтмененные.Организация
		|			И Мероприятия.ИдМероприятия = МероприятияОтмененные.ИдМероприятия
		|			И (МероприятияОтмененные.Отменено)
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(Мероприятия.Регистратор) = ТИП(Документ.РегистрацияТрудовойДеятельности)
		|	И Мероприятия.ВидМероприятия В (ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Прием), ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Перевод), ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Увольнение))
		|	И НЕ Мероприятия.Отменено
		|	И НЕ МероприятияПереданные.ИдМероприятия ЕСТЬ NULL
		|	И МероприятияОтмененные.ИдМероприятия ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1000
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА КОНЕЦПЕРИОДА(МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод, МЕСЯЦ) > &ТекущаяДата
		|				ТОГДА &ТекущаяДата
		|			ИНАЧЕ КОНЕЦПЕРИОДА(ВЫБОР
		|						КОГДА МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод < &ДатаНачалаУчета
		|							ТОГДА &ДатаНачалаУчета
		|						ИНАЧЕ МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод
		|					КОНЕЦ, МЕСЯЦ)
		|		КОНЕЦ) КАК ДатаОтменыМероприятия,
		|	КОНЕЦПЕРИОДА(ВЫБОР
		|			КОГДА КОНЕЦПЕРИОДА(МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод, МЕСЯЦ) > &ТекущаяДата
		|				ТОГДА &ТекущаяДата
		|			ИНАЧЕ КОНЕЦПЕРИОДА(ВЫБОР
		|						КОГДА МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод < &ДатаНачалаУчета
		|							ТОГДА &ДатаНачалаУчета
		|						ИНАЧЕ МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод
		|					КОНЕЦ, МЕСЯЦ)
		|		КОНЕЦ, МЕСЯЦ) КАК Месяц,
		|	МероприятияКадровыхПриказов.Организация КАК Организация,
		|	МероприятияКадровыхПриказов.ИдМероприятия КАК ИдМероприятия,
		|	МероприятияКадровыхПриказов.Отменено КАК Отменено
		|ПОМЕСТИТЬ ВТЗакрываемыеМероприятия
		|ИЗ
		|	ВТМероприятияКадровыхПриказов КАК МероприятияКадровыхПриказов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМероприятияРегистрацийТрудовойДеятельности КАК МероприятияРегистрацийТрудовойДеятельности
		|		ПО МероприятияКадровыхПриказов.ФизическоеЛицо = МероприятияРегистрацийТрудовойДеятельности.ФизическоеЛицо
		|			И МероприятияКадровыхПриказов.Организация = МероприятияРегистрацийТрудовойДеятельности.Организация
		|			И МероприятияКадровыхПриказов.Отменено = МероприятияРегистрацийТрудовойДеятельности.Отменено
		|			И МероприятияКадровыхПриказов.ВидМероприятия = МероприятияРегистрацийТрудовойДеятельности.ВидМероприятия
		|			И МероприятияКадровыхПриказов.ДатаМероприятия = МероприятияРегистрацийТрудовойДеятельности.ДатаМероприятия
		|			И МероприятияКадровыхПриказов.ЯвляетсяСовместителем = МероприятияРегистрацийТрудовойДеятельности.ЯвляетсяСовместителем
		|			И МероприятияКадровыхПриказов.Сотрудник = МероприятияРегистрацийТрудовойДеятельности.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	МероприятияКадровыхПриказов.Организация,
		|	МероприятияКадровыхПриказов.ИдМероприятия,
		|	МероприятияКадровыхПриказов.Отменено,
		|	КОНЕЦПЕРИОДА(ВЫБОР
		|			КОГДА КОНЕЦПЕРИОДА(МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод, МЕСЯЦ) > &ТекущаяДата
		|				ТОГДА &ТекущаяДата
		|			ИНАЧЕ КОНЕЦПЕРИОДА(ВЫБОР
		|						КОГДА МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод < &ДатаНачалаУчета
		|							ТОГДА &ДатаНачалаУчета
		|						ИНАЧЕ МероприятияРегистрацийТрудовойДеятельности.РегистраторОтчетныйПериод
		|					КОНЕЦ, МЕСЯЦ)
		|		КОНЕЦ, МЕСЯЦ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗакрываемыеМероприятия.ИдМероприятия КАК ИдМероприятия
		|ИЗ
		|	ВТЗакрываемыеМероприятия КАК ЗакрываемыеМероприятия";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗакрываемыеМероприятия.Месяц КАК Месяц,
		|	ЗакрываемыеМероприятия.ДатаОтменыМероприятия КАК ДатаОтменыМероприятия,
		|	Мероприятия.Регистратор КАК Регистратор,
		|	Мероприятия.НомерСтроки КАК НомерСтроки,
		|	Мероприятия.Активность КАК Активность,
		|	Мероприятия.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Мероприятия.Организация КАК Организация,
		|	Мероприятия.ИдМероприятия КАК ИдМероприятия,
		|	Мероприятия.Отменено КАК Отменено,
		|	Мероприятия.Сотрудник КАК Сотрудник,
		|	Мероприятия.ДатаМероприятия КАК ДатаМероприятия,
		|	Мероприятия.ВидМероприятия КАК ВидМероприятия,
		|	Мероприятия.Сведения КАК Сведения,
		|	Мероприятия.Подразделение КАК Подразделение,
		|	Мероприятия.Должность КАК Должность,
		|	Мероприятия.РазрядКатегория КАК РазрядКатегория,
		|	Мероприятия.КодПоРееструДолжностей КАК КодПоРееструДолжностей,
		|	Мероприятия.ТрудоваяФункция КАК ТрудоваяФункция,
		|	Мероприятия.НаименованиеДокументаОснования КАК НаименованиеДокументаОснования,
		|	Мероприятия.ДатаДокументаОснования КАК ДатаДокументаОснования,
		|	Мероприятия.СерияДокументаОснования КАК СерияДокументаОснования,
		|	Мероприятия.НомерДокументаОснования КАК НомерДокументаОснования,
		|	Мероприятия.НаименованиеВторогоДокументаОснования КАК НаименованиеВторогоДокументаОснования,
		|	Мероприятия.ДатаВторогоДокументаОснования КАК ДатаВторогоДокументаОснования,
		|	Мероприятия.СерияВторогоДокументаОснования КАК СерияВторогоДокументаОснования,
		|	Мероприятия.НомерВторогоДокументаОснования КАК НомерВторогоДокументаОснования,
		|	Мероприятия.ОснованиеУвольнения КАК ОснованиеУвольнения,
		|	Мероприятия.ДатаС КАК ДатаС,
		|	Мероприятия.ДатаПо КАК ДатаПо,
		|	Мероприятия.ДатаОтмены КАК ДатаОтмены,
		|	Мероприятия.ЯвляетсяСовместителем КАК ЯвляетсяСовместителем,
		|	Мероприятия.ПредставлениеДолжности КАК ПредставлениеДолжности,
		|	Мероприятия.ПредставлениеПодразделения КАК ПредставлениеПодразделения,
		|	Мероприятия.ОснованиеУвольненияТекстОснования КАК ОснованиеУвольненияТекстОснования,
		|	Мероприятия.ОснованиеУвольненияСтатья КАК ОснованиеУвольненияСтатья,
		|	Мероприятия.ОснованиеУвольненияЧасть КАК ОснованиеУвольненияЧасть,
		|	Мероприятия.ОснованиеУвольненияПункт КАК ОснованиеУвольненияПункт,
		|	Мероприятия.ОснованиеУвольненияПодпункт КАК ОснованиеУвольненияПодпункт,
		|	Мероприятия.ОснованиеУвольненияАбзац КАК ОснованиеУвольненияАбзац,
		|	Мероприятия.КодПоОКЗ КАК КодПоОКЗ,
		|	Мероприятия.ТерриториальныеУсловия КАК ТерриториальныеУсловия,
		|	Мероприятия.ОписаниеДолжности КАК ОписаниеДолжности
		|ИЗ
		|	ВТЗакрываемыеМероприятия КАК ЗакрываемыеМероприятия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК Мероприятия
		|		ПО ЗакрываемыеМероприятия.Организация = Мероприятия.Организация
		|			И ЗакрываемыеМероприятия.ИдМероприятия = Мероприятия.ИдМероприятия
		|			И ЗакрываемыеМероприятия.Отменено = Мероприятия.Отменено
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗакрываемыеМероприятия.Месяц,
		|	Организация,
		|	ФизическоеЛицо,
		|	ДатаМероприятия,
		|	ВидМероприятия,
		|	Отменено";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Месяц") Цикл
		
		Пока Выборка.СледующийПоЗначениюПоля("Организация") Цикл
			
			ДокументОбъект = Документы.РегистрацияТрудовойДеятельности.СоздатьДокумент();
			ДокументОбъект.Организация = Выборка.Организация;
			ДокументОбъект.Дата = Выборка.ДатаОтменыМероприятия;
			
			Пока Выборка.Следующий() Цикл
				
				СтрокаМероприятия = ДокументОбъект.Мероприятия.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаМероприятия, Выборка);
				СтрокаМероприятия.Сотрудник = Выборка.ФизическоеЛицо;
				СтрокаМероприятия.СотрудникЗаписи = Выборка.Сотрудник;
				СтрокаМероприятия.ДатаОтмены = Выборка.ДатаОтменыМероприятия;
				
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Истина, Истина, РежимЗаписиДокумента.Запись);
			Попытка
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, , , РежимЗаписиДокумента.Проведение);
			Исключение
				
				ИнформацияОшибки = ИнформацияОбОшибке();
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Электронные трудовые книжки'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					ДокументОбъект.Метаданные(),
					ДокументОбъект.Ссылка,
					ПодробноеПредставлениеОшибки(ИнформацияОшибки));
				
			КонецПопытки;
			
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли