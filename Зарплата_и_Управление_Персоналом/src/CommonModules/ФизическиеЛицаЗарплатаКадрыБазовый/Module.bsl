////////////////////////////////////////////////////////////////////////////////
// ФизическиеЛицаЗарплатаКадрыБазовый: методы, дополняющие функциональность 
// 		справочника ФизическиеЛица.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьДанныеФизическогоЛица(ДанныеФизическогоЛица, ПравилаПроверки, Ошибки, Отказ, НомерСтроки) Экспорт
	
	Для каждого ПравилоПроверки Из ПравилаПроверки Цикл
		
		Если ПравилоПроверки.ПравилоПроверки = "ФИО" Тогда
			
			ПроверитьФИО(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "Пол" Тогда
			
			ПроверитьПол(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "ИНН" Тогда
			
			ПроверитьИНН(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "СНИЛС" Тогда
			
			ПроверитьСНИЛС(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "ДатаРождения" Тогда
			
			ПроверитьДатуРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "МестоРождения" Тогда
			
			ПроверитьМестоРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "УдостоверениеЛичности" Тогда
			
			ПроверитьУдостоверениеЛичности(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки, 
				Ложь);
				
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "УдостоверениеЛичностиИностранногоГражданина" Тогда
			
			ПроверитьУдостоверениеЛичности(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки, 
				Истина);
			
		ИначеЕсли ПравилоПроверки.ПравилоПроверки = "Адрес" Тогда
			
			ПроверитьАдрес(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки);
			
		Иначе
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не найдено правило проверки данных физического лица ""%1""'"),
				ПравилоПроверки.ПравилоПроверки);
				
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает структуру, описывающую ошибку проверки данных физического лица.
//
// Возвращаемое значение:
//		Структура, содержащая ключи:
//			ТекстОшибки
//			ПолеФормы
//			НомерСтроки
//
Функция ОписаниеОшибкиЗаполненияДанныхФизическогоЛица()
	
	Возврат Новый Структура("ТекстОшибки, ПолеФормы, НомерСтроки");
	
КонецФункции

// Добавляет ошибку в коллекцию ошибок проверки данных физического лица, устанавливает в Истина признак Отказ.
//
//	Параметры:
//		Ошибки - Соответствие, если передано Неопределено - будет создано соответствие.
//				Ключ соответствия - ФизическоеЛицо
//		ФизическоеЛицо,
//		ТекстОшибки,
//		Отказ,
//		ПолеФормы - Строка, имя поля формы к которому относится ошибка.
//		НомерСтроки - Число, номер строки в многострочном документе.
//
Процедура ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(Ошибки, ФизическоеЛицо, ТекстОшибки, Отказ, ПолеФормы = "", НомерСтроки = Неопределено)
	
	Если Ошибки = Неопределено Тогда
		Ошибки = Новый Соответствие;
	КонецЕсли;
	
	КоллекцияОшибок = Ошибки.Получить(ФизическоеЛицо);
	Если КоллекцияОшибок = Неопределено Тогда
		КоллекцияОшибок = Новый Массив;
	КонецЕсли; 
	
	ОшибкаЗаполненияДанных = ОписаниеОшибкиЗаполненияДанныхФизическогоЛица();
	
	ОшибкаЗаполненияДанных.ТекстОшибки = ТекстОшибки;
	ОшибкаЗаполненияДанных.ПолеФормы = ПолеФормы;
	ОшибкаЗаполненияДанных.НомерСтроки = НомерСтроки;
	
	КоллекцияОшибок.Добавить(ОшибкаЗаполненияДанных);
	
	Ошибки.Вставить(ФизическоеЛицо, КоллекцияОшибок);
	
	Отказ = Истина;
	
КонецПроцедуры	

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Перем Организация;
	Перем Подразделение;
	
	Параметры.Отбор.Свойство("Организация", Организация);
	Параметры.Отбор.Свойство("Подразделение", Подразделение);
	
	Если Не Параметры.Свойство("ВыборГруппИЭлементов")
		Или Не ЗначениеЗаполнено(Параметры.ВыборГруппИЭлементов) Тогда
		
		ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
		
	Иначе
		ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
	КонецЕсли;
	
	Если Параметры.Свойство("СтрокаПоиска") 
		И НЕ ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		УстановитьПривилегированныйРежим(Истина);
		ФизическиеЛицаЗарплатаКадры.СоздатьВТПрежниеФИО(Запрос.МенеджерВременныхТаблиц, Ложь, Параметры.СтрокаПоиска);
		УстановитьПривилегированныйРежим(Ложь);
		
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ПрежниеФИО.ФИО + ВЫБОР
			|		КОГДА ФизическиеЛица.УточнениеНаименования = """"
			|			ТОГДА """"
			|		ИНАЧЕ "" "" + ФизическиеЛица.УточнениеНаименования
			|	КОНЕЦ КАК ФИО,
			|	ФизическиеЛица.Наименование КАК ФИОТекущее,
			|	ПрежниеФИО.ФизическоеЛицо КАК ФизическоеЛицо,
			|	МАКСИМУМ(ПрежниеФИО.Период) КАК Период,
			|	ФизическиеЛица.Код КАК Код,
			|	ФизическиеЛица.Фамилия КАК Фамилия,
			|	ФизическиеЛица.Имя КАК Имя,
			|	ФизическиеЛица.Отчество КАК Отчество,
			|	ФизическиеЛица.Инициалы КАК Инициалы,
			|	ЛОЖЬ КАК ЭтоГруппа
			|ПОМЕСТИТЬ ВТВсеСовпадения
			|ИЗ
			|	ВТПрежниеФИО КАК ПрежниеФИО
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
			|		ПО ПрежниеФИО.ФизическоеЛицо = ФизическиеЛица.Ссылка
			|			И (НЕ ФизическиеЛица.ЭтоГруппа)
			|
			|СГРУППИРОВАТЬ ПО
			|	ПрежниеФИО.ФИО,
			|	ПрежниеФИО.ФизическоеЛицо,
			|	ФизическиеЛица.Наименование,
			|	ФизическиеЛица.Код,
			|	ФизическиеЛица.Фамилия,
			|	ФизическиеЛица.Имя,
			|	ФизическиеЛица.Отчество,
			|	ФизическиеЛица.Инициалы,
			|	ФизическиеЛица.УточнениеНаименования
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ФизическиеЛица.Наименование,
			|	ФизическиеЛица.Наименование,
			|	ФизическиеЛица.Ссылка,
			|	ВЫРАЗИТЬ(NULL КАК ДАТА),
			|	ФизическиеЛица.Код,
			|	ФизическиеЛица.Фамилия,
			|	ФизическиеЛица.Имя,
			|	ФизическиеЛица.Отчество,
			|	ФизическиеЛица.Инициалы,
			|	ФизическиеЛица.ЭтоГруппа
			|ИЗ
			|	Справочник.ФизическиеЛица КАК ФизическиеЛица
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПрежниеФИО КАК ПрежниеФИО
			|		ПО ФизическиеЛица.Ссылка = ПрежниеФИО.ФизическоеЛицо
			|ГДЕ
			|	ПрежниеФИО.ФизическоеЛицо ЕСТЬ NULL
			|	И ФизическиеЛица.Наименование ПОДОБНО &СтрокаПоиска
			|	И НЕ ФизическиеЛица.ЭтоГруппа
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВсеСовпадения.ФИО КАК ФИО,
			|	ВсеСовпадения.ФИОТекущее КАК ФИОТекущее,
			|	ВсеСовпадения.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ВсеСовпадения.Период КАК Период,
			|	ВсеСовпадения.Код КАК Код,
			|	ВсеСовпадения.Фамилия КАК Фамилия,
			|	ВсеСовпадения.Имя КАК Имя,
			|	ВсеСовпадения.Инициалы КАК Инициалы,
			|	ВсеСовпадения.Отчество КАК Отчество,
			|	ВсеСовпадения.ЭтоГруппа КАК ЭтоГруппа
			|ИЗ
			|	ВТВсеСовпадения КАК ВсеСовпадения
			|
			|УПОРЯДОЧИТЬ ПО
			|	ФИО";
		
		Если ВыборГруппИЭлементов <> ИспользованиеГруппИЭлементов.Элементы Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "И НЕ ФизическиеЛица.ЭтоГруппа", "");
		КонецЕсли;
		
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			
			ДанныеВыбора = Новый СписокЗначений;
			СтандартнаяОбработка = Ложь;
			ДлинаСтрокиПоиска = СтрДлина(Параметры.СтрокаПоиска);
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Представление = Новый ФорматированнаяСтрока(
					Новый ФорматированнаяСтрока(
						Лев(Выборка.ФИО, ДлинаСтрокиПоиска),
						Новый Шрифт( , , Истина),
						WebЦвета.Зеленый),
					Сред(Выборка.ФИО, ДлинаСтрокиПоиска + 1));
					
				Если Не Выборка.ЭтоГруппа И ЗначениеЗаполнено(Выборка.Период) Тогда
					
					Если ЗначениеЗаполнено(Выборка.Фамилия) Тогда
						ФИОТекущее = Новый Структура("Фамилия,Имя,Отчество,Инициалы");
						ЗаполнитьЗначенияСвойств(ФИОТекущее, Выборка);
					Иначе
						ФИОТекущее = Выборка.ФИОТекущее;
					КонецЕсли;
					
					Представление = Новый ФорматированнаяСтрока(
						Представление,
						" (" + ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИОТекущее) + " " 
							+ НСтр("ru='с'") + " " + Формат(Выборка.Период, "ДЛФ=D") + " (" + Выборка.Код + "))");
							
				Иначе
					
					Представление = Новый ФорматированнаяСтрока(
						Представление,
						" (" + Выборка.Код + ")");
					
				КонецЕсли;
				
				ДанныеВыбора.Добавить(Выборка.ФизическоеЛицо, Представление);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Организация <> НеОпределено Или Подразделение <> НеОпределено Тогда
		
		// Если есть отбор по организации или подразделению - отрабатываем особенным образом.
		
		Запрос = Новый Запрос;
		
		ДатаНачалаОтбора = Неопределено;
		ДатаОкончанияОтбора = Неопределено;
		
		Если Параметры.Отбор.Свойство("ДатаПримененияОтбора") Тогда
			
			Если ЗначениеЗаполнено(Параметры.Отбор.ДатаПримененияОтбора) Тогда
				
				ДатаНачалаОтбора = НачалоДня(Параметры.Отбор.ДатаПримененияОтбора);
				ДатаОкончанияОтбора = КонецДня(Параметры.Отбор.ДатаПримененияОтбора);
				
			КонецЕсли;
			
			Параметры.Отбор.Удалить("ДатаПримененияОтбора");
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДатаНачалаОтбора) И Параметры.Отбор.Свойство("МесяцПримененияОтбора") Тогда
			
			Если ЗначениеЗаполнено(Параметры.Отбор.МесяцПримененияОтбора) Тогда
				
				ДатаНачалаОтбора = НачалоМесяца(Параметры.Отбор.МесяцПримененияОтбора);
				ДатаОкончанияОтбора = КонецМесяца(Параметры.Отбор.МесяцПримененияОтбора);
				
			КонецЕсли;
			
			Параметры.Отбор.Удалить("МесяцПримененияОтбора");
			
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
			
			Запрос.УстановитьПараметр("МаксимальнаяДатаНачалоДня", НачалоДня(ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата()));
		
			ЗапросТекст =
				"ВЫБРАТЬ *
				|ИЗ
				|	Справочник.ФизическиеЛица КАК ФизическиеЛица
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
				|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
				|			ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
				|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
				|			ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = КадроваяИсторияСотрудниковИнтервальный.Сотрудник
				|				И КадроваяИсторияСотрудниковИнтервальный.ДатаНачала В
				|					(ВЫБРАТЬ ПЕРВЫЕ 1
				|						Т.ДатаНачала
				|					ИЗ
				|						РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК Т
				|					ГДЕ
				|						ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
				|						И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания
				|					УПОРЯДОЧИТЬ ПО
				|						Т.ДатаНачала УБЫВ)
				|		ПО ФизическиеЛица.Ссылка = ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо
				|ГДЕ
				|	НЕ ФизическиеЛица.ЭтоГруппа
				|	И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания = &МаксимальнаяДатаНачалоДня
				|	И КадроваяИсторияСотрудниковИнтервальный.Организация = &Организация
				|	И КадроваяИсторияСотрудниковИнтервальный.Подразделение = &Подразделение
				|	И &ДополнительноеУсловие";
			
			ОрганизацияСписком = ТипЗнч(Организация) = Тип("Массив") ИЛИ ТипЗнч(Организация) = Тип("СписокЗначений");
			Если Организация = НеОпределено ИЛИ ОрганизацияСписком И Организация.Количество() = 0 Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "КадроваяИсторияСотрудниковИнтервальный.Организация = &Организация
					|	И ", "");
				
			ИначеЕсли ОрганизацияСписком Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "КадроваяИсторияСотрудниковИнтервальный.Организация = &Организация
					|	И ", "КадроваяИсторияСотрудниковИнтервальный.Организация В (&Организация)
					|	И ");
				
			КонецЕсли;
			
			ПодразделениеСписком = ТипЗнч(Подразделение) = Тип("Массив") ИЛИ ТипЗнч(Подразделение) = Тип("СписокЗначений");
			Если Подразделение = НеОпределено ИЛИ ПодразделениеСписком И Подразделение.Количество() = 0 Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "КадроваяИсторияСотрудниковИнтервальный.Подразделение = &Подразделение
					|	И ", "");
				
			ИначеЕсли ПодразделениеСписком Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "КадроваяИсторияСотрудниковИнтервальный.Подразделение = &Подразделение
					|	И ", "КадроваяИсторияСотрудниковИнтервальный.Подразделение В (&Подразделение)
					|	И ");
				
			КонецЕсли;
			
		Иначе
			
			ЗапросТекст = 
				"ВЫБРАТЬ *
				|ИЗ
				|	Справочник.ФизическиеЛица КАК ФизическиеЛица
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
				|		ПО ФизическиеЛица.Ссылка = ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо
				|			И (ТекущиеКадровыеДанныеСотрудников.ОсновноеРабочееМестоВОрганизации)
				|ГДЕ
				|	НЕ ФизическиеЛица.ЭтоГруппа
				|	И ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = &Организация
				|	И ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение = &Подразделение
				|	И &ДополнительноеУсловие";
			
			ОрганизацияСписком = ТипЗнч(Организация) = Тип("Массив") ИЛИ ТипЗнч(Организация) = Тип("СписокЗначений");
			Если Организация = НеОпределено ИЛИ ОрганизацияСписком И Организация.Количество() = 0 Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = &Организация
					|	И ", "");
				
			ИначеЕсли ОрганизацияСписком Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация = &Организация
					|	И ", "ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация В (&Организация)
					|	И ");
				
			КонецЕсли;
			
			ПодразделениеСписком = ТипЗнч(Подразделение) = Тип("Массив") ИЛИ ТипЗнч(Подразделение) = Тип("СписокЗначений");
			Если Подразделение = НеОпределено ИЛИ ПодразделениеСписком И Подразделение.Количество() = 0 Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение = &Подразделение
					|	И ", "");
				
			ИначеЕсли ПодразделениеСписком Тогда
				
				ЗапросТекст = СтрЗаменить(ЗапросТекст, "ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение = &Подразделение
					|	И ", "ТекущиеКадровыеДанныеСотрудников.ТекущееПодразделение В (&Подразделение)
					|	И ");
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаНачалаОтбора) Тогда
			
			ЗапросТекст = ЗапросТекст + Символы.ПС + "
				|	И ТекущиеКадровыеДанныеСотрудников.ДатаПриема <= &ДатаОкончанияОтбора
				|   И (ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения >= &ДатаНачалаОтбора
				|		ИЛИ ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1))";
			
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("ВАрхиве") Тогда
			ЗапросТекст = ЗапросТекст + Символы.ПС + "	И ТекущиеКадровыеДанныеСотрудников.Сотрудник.ВАрхиве = " + ?(Параметры.Отбор.ВАрхиве = Истина, "ИСТИНА", "ЛОЖЬ");
		КонецЕсли; 
		
		Запрос.Текст = ЗапросТекст;
		
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		
		Если ЗначениеЗаполнено(ДатаНачалаОтбора) Тогда
			
			Запрос.УстановитьПараметр("ДатаНачалаОтбора", ДатаНачалаОтбора);
			Запрос.УстановитьПараметр("ДатаОкончанияОтбора", ДатаОкончанияОтбора);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеВыбора) И ДанныеВыбора.Количество() > 0 Тогда
			ИспользоватьДанныеВыбора = Истина;
		Иначе
			ИспользоватьДанныеВыбора = Ложь;
		КонецЕсли; 
		
		СтандартнаяОбработка = Ложь;
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеВыбора) И ДанныеВыбора.Количество() > 0 Тогда
		
		ИспользоватьДанныеВыбора = Истина;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ *
			|ИЗ
			|	Справочник.ФизическиеЛица КАК ФизическиеЛица
			|ГДЕ
			|
			|	НЕ ФизическиеЛица.ЭтоГруппа
			|	И &ДополнительноеУсловие";
		
		Если Не Параметры.Свойство("ВыборГруппИЭлементов")
			Или Параметры.ВыборГруппИЭлементов <> ИспользованиеГруппИЭлементов.Элементы Тогда
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "НЕ ФизическиеЛица.ЭтоГруппа", "(ИСТИНА)");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не СтандартнаяОбработка Тогда
		ЗарплатаКадры.ЗаполнитьДанныеВыбораСправочника(ДанныеВыбора, Метаданные.Справочники.ФизическиеЛица, Параметры, Запрос, "ФизическиеЛица", ИспользоватьДанныеВыбора);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты")
			ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
			
			Если Параметры.Свойство("Отбор") Тогда
				
				ОрганизацияОтбора = Неопределено;
				Если Параметры.Отбор.Свойство("Организация", ОрганизацияОтбора)
					ИЛИ Параметры.Отбор.Свойство("ГоловнаяОрганизация", ОрганизацияОтбора) Тогда
					
					Если ТипЗнч(ОрганизацияОтбора) = Тип("СправочникСсылка.Организации") Тогда
						СтандартнаяОбработка = Ложь;
						ВыбраннаяФорма = "ФормаВыбораСотрудников";
					ИначеЕсли ТипЗнч(ОрганизацияОтбора) = Тип("СписокЗначений") И ОрганизацияОтбора.Количество() > 0 Тогда
						Если ТипЗнч(ОрганизацияОтбора[0].Значение) = Тип("СправочникСсылка.Организации") Тогда
							СтандартнаяОбработка = Ложь;
							ВыбраннаяФорма = "ФормаВыбораСотрудников";
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверка данных физических лиц.

Процедура ПроверитьФИО(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	ТекстОшибки = "";
	
	Фамилия = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	Имя = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымИмя];
	Отчество = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымОтчество];
	
	ФИО = Фамилия + " " + Имя + " " + Отчество;
	Если ПустаяСтрока(Фамилия) ИЛИ ПустаяСтрока(Имя) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудник %1: не указаны фамилия и имя'"),
			ДанныеФизическогоЛица.Наименование);
				
	ИначеЕсли ПустаяСтрока(Имя) Тогда
			
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудник %1: не указано имя'"),
			ДанныеФизическогоЛица.Наименование);
		
	Иначе
		
		СтранаГражданства = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымСтраныГражданства];
		
		Если СтранаГражданства = Справочники.СтраныМира.Россия Тогда
			
			Если НЕ СтроковыеФункцииКлиентСерверРФ.ТолькоКириллицаВСтроке(ФИО, Ложь, "-. 0123456789") Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник %1: ФИО физического лица должно быть введено русскими буквами'"),
					ДанныеФизическогоЛица.Наименование);
				
			КонецЕсли;
			
		Иначе
			
			Если НЕ СтроковыеФункцииКлиентСерверРФ.ТолькоКириллицаВСтроке(ФИО, Ложь, "-. 0123456789")
				И НЕ СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(ФИО, Ложь, "-. 0123456789") Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник %1: ФИО физического лица нерезидента должно быть введено только русскими или только латинскими буквами.'"),
					ДанныеФизическогоЛица.Наименование);

			КонецЕсли;	
			
		КонецЕсли;

	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
			
	КонецЕсли; 
		
КонецПроцедуры

Процедура ПроверитьИНН(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
			
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным]) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: не заполнено поле ""%2""'"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента) + " ";		
			
		КонецЕсли; 
		
	ИначеЕсли НЕ РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным], Ложь, ТекстСообщения) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудник %1: %2'"),
			ДанныеФизическогоЛица.Наименование,
			ТекстСообщения) + " ";
		
	КонецЕсли;	
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
			
	КонецЕсли; 
		
КонецПроцедуры	

Процедура ПроверитьСНИЛС(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
			
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным]) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: не заполнено поле ""%2""'"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента) + " ";		
			
		КонецЕсли; 
		
	ИначеЕсли НЕ РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным], ТекстСообщения) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудник %1: %2'"),
			ДанныеФизическогоЛица.Наименование,
			ТекстСообщения) + " ";
		
	КонецЕсли;	
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
			
	КонецЕсли; 
		
КонецПроцедуры	

Процедура ПроверитьДатуРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным]) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: не заполнено поле ""%2""'"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента) + " ";
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным] > ПравилоПроверки.ДатаПроверки Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: указанная %2 (%3) не может быть больше даты проверки сведений (%4)'"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента,
				ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным],
				ПравилоПроверки.ДатаПроверки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстСообщения,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьМестоРождения(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
		
		МестоРождения = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
		МестоРождения = СокрЛП(СтрЗаменить(МестоРождения, ",", ""));
		
		Если ПустаяСтрока(МестоРождения) 
			ИЛИ МестоРождения = "0" Тогда
				
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: не заполнено поле %2'"), 
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента);
																				
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДанным,
				НомерСтроки);
			
		КонецЕсли;	
		
	КонецЕсли; 
	
КонецПроцедуры	

Процедура ПроверитьУдостоверениеЛичности(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки, 
	ТолькоДляИностранныхГраждан = Ложь)
	
	ВидДокумента = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	
	Если НЕ ЗначениеЗаполнено(ВидДокумента) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='Сотрудник %1: Не указан вид документа, удостоверяющего личность'"),
							ДанныеФизическогоЛица.Наименование);
			
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДанным,
				НомерСтроки);
				
		КонецЕсли;
		
	Иначе
		
		Если ПравилоПроверки.ПроверятьДопустимыеВидыДокументовФНС Тогда
			ДопустимыеВидыДокументовФНС = ЗарплатаКадрыПовтИсп.ВидыДокументовУдостоверяющихЛичностьФНС(ТолькоДляИностранныхГраждан);
			
			Если ДопустимыеВидыДокументовФНС.Найти(ВидДокумента) = Неопределено Тогда
				ШаблонТекстаОшибки = НСтр("ru = 'Указан недопустимый вид документа, удостоверяющего личность. Коды допустимых документов: %1.'");
				ДопустимыеКодыТекст = ?(ТолькоДляИностранныхГраждан,
				                        УчетНДФЛ.КодыДопустимыхДокументовУдостоверяющихЛичностьИностранныхГраждан(),
										УчетНДФЛ.КодыДопустимыхДокументовУдостоверяющихЛичность());
				ШаблонТекстаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаОшибки, ДопустимыеКодыТекст);
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник %1: %2.'"),
					ДанныеФизическогоЛица.Наименование,
					ШаблонТекстаОшибки);
					
					
				ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
					Ошибки,
					ДанныеФизическогоЛица.ФизическоеЛицо,
					ТекстОшибки,
					Отказ,
					ПравилоПроверки.ПутьКДанным,
					НомерСтроки);
	
			КонецЕсли;
		КонецЕсли;	
		
		ТекстОшибки = "";
		СерияДокумента = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымСерииДокумента];
		Если НЕ ДокументыФизическихЛицКлиентСервер.СерияДокументаУказанаПравильно(ВидДокумента, СерияДокумента, ТекстОшибки) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: %2.'"),
				ДанныеФизическогоЛица.Наименование,
				ТекстОшибки);
			
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымСерииДокумента,
				НомерСтроки);
				
		КонецЕсли;
		
		ТекстОшибки = "";
		НомерДокумента = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымНомераДокумента];
		Если НЕ ДокументыФизическихЛицКлиентСервер.НомерДокументаУказанПравильно(ВидДокумента, НомерДокумента, ТекстОшибки) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: %2.'"),
				ДанныеФизическогоЛица.Наименование,
				ТекстОшибки);

			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымНомераДокумента,
				НомерСтроки);
				
		КонецЕсли;
			
		Если ПравилоПроверки.ПроверятьКемВыданДатаВыдачи Тогда
			
			Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымДатыВыдачиДокумента]) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: не указана дата выдачи документа.'"),
				ДанныеФизическогоЛица.Наименование);
				
				ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымДатыВыдачиДокумента,
				НомерСтроки);
				
			КонецЕсли; 	
			
			Если НЕ ЗначениеЗаполнено(ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДаннымКемВыданДокумент]) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: не указано кем выдан документ'"),
				ДанныеФизическогоЛица.Наименование);
				
				ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДаннымКемВыданДокумент,
				НомерСтроки);
				
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ПроверитьАдрес(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	ТекстОшибки = "";
	Адрес = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	
	Если НЕ ЗначениеЗаполнено(Адрес) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сотрудник %1: - не заполнено поле ""%2""'"),
				ДанныеФизическогоЛица.Наименование,
				ПравилоПроверки.ПредставлениеПроверяемогоЭлемента);
					
		КонецЕсли;
		
	Иначе
		
		СообщенияПроверки = "";
		
		МассивОшибок = РаботаСАдресами.ПроверитьАдрес(Адрес);
		
		Если МассивОшибок.СписокОшибок.Количество() <> 0 Тогда
			
			Для каждого СтруктураОшибки Из МассивОшибок.СписокОшибок Цикл
				СообщенияПроверки = ?(ПустаяСтрока(СообщенияПроверки), "", СообщенияПроверки + Символы.ПС) + СтруктураОшибки.Представление;
			КонецЦикла;
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник %1: - поле ""%2"": %3'"),
					ДанныеФизическогоЛица.Наименование,
					ПравилоПроверки.ПредставлениеПроверяемогоЭлемента,
					СообщенияПроверки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		
		ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
			Ошибки,
			ДанныеФизическогоЛица.ФизическоеЛицо,
			ТекстОшибки,
			Отказ,
			ПравилоПроверки.ПутьКДанным,
			НомерСтроки);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПроверитьПол(ДанныеФизическогоЛица, ПравилоПроверки, Ошибки, Отказ, НомерСтроки)
	
	Пол = ДанныеФизическогоЛица[ПравилоПроверки.ПутьКДанным];
	
	Если НЕ ЗначениеЗаполнено(Пол) Тогда
		
		Если ПравилоПроверки.ОбязательноКЗаполнению Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Сотрудник %1: - не указан пол'"),
					ДанныеФизическогоЛица.Наименование);
					
			ДобавитьОшибкуЗаполненияДанныхФизическогоЛица(
				Ошибки,
				ДанныеФизическогоЛица.ФизическоеЛицо,
				ТекстОшибки,
				Отказ,
				ПравилоПроверки.ПутьКДанным,
				НомерСтроки);
				
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаВыбораСотрудниковПриСозданииНаСервере(Форма, Параметры) Экспорт
	
	УстановитьЗапросСпискаВФормеВыбораСотрудников(Форма);
	
КонецПроцедуры

Процедура УстановитьЗапросСпискаВФормеВыбораСотрудников(Форма)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		Список = Форма.Список;
		
		Список.ТекстЗапроса =
			"ВЫБРАТЬ
			|	СправочникФизическиеЛица.Ссылка КАК Ссылка,
			|	СправочникФизическиеЛица.ПометкаУдаления КАК ПометкаУдаления,
			|	СправочникФизическиеЛица.Предопределенный КАК Предопределенный,
			|	СправочникФизическиеЛица.Родитель КАК Родитель,
			|	СправочникФизическиеЛица.ЭтоГруппа КАК ЭтоГруппа,
			|	СправочникФизическиеЛица.Код КАК Код,
			|	СправочникФизическиеЛица.Наименование КАК Наименование,
			|	СправочникФизическиеЛица.ДатаРождения КАК ДатаРождения,
			|	СправочникФизическиеЛица.ИНН КАК ИНН,
			|	СправочникФизическиеЛица.СтраховойНомерПФР КАК СтраховойНомерПФР,
			|	ТекущиеКадровыеДанныеСотрудников.ДатаПриема КАК ДатаПриема,
			|	ТекущиеКадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
			|	ОсновныеСотрудникиФизическихЛиц.Сотрудник.Код КАК ТабельныйНомер,
			|	ОсновныеСотрудникиФизическихЛиц.Сотрудник.ВАрхиве КАК ВАрхиве,
			|	ОсновныеСотрудникиФизическихЛиц.ГоловнаяОрганизация КАК Организация,
			|	КадроваяИсторияСотрудниковИнтервальный.Организация КАК Филиал,
			|	КадроваяИсторияСотрудниковИнтервальный.Подразделение КАК Подразделение,
			|	ВидыЗанятостиСотрудниковИнтервальный.ВидЗанятости КАК ВидЗанятости
			|ИЗ
			|	РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК СправочникФизическиеЛица
			|		ПО ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо = СправочникФизическиеЛица.Ссылка
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|		ПО ОсновныеСотрудникиФизическихЛиц.ГоловнаяОрганизация = ТекущиеКадровыеДанныеСотрудников.ГоловнаяОрганизация
			|			И ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо = ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо
			|			И ОсновныеСотрудникиФизическихЛиц.Сотрудник = ТекущиеКадровыеДанныеСотрудников.Сотрудник
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК КадроваяИсторияСотрудниковИнтервальный
			|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = КадроваяИсторияСотрудниковИнтервальный.Сотрудник
			|			И (КадроваяИсторияСотрудниковИнтервальный.ДатаНачала В
			|				(ВЫБРАТЬ
			|					МАКСИМУМ(Т.ДатаНачала)
			|				ИЗ
			|					РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК Т
			|				ГДЕ
			|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
			|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятостиСотрудниковИнтервальный
			|		ПО ОсновныеСотрудникиФизическихЛиц.Сотрудник = ВидыЗанятостиСотрудниковИнтервальный.Сотрудник
			|			И (ВидыЗанятостиСотрудниковИнтервальный.ДатаНачала В
			|				(ВЫБРАТЬ
			|					МАКСИМУМ(Т.ДатаНачала)
			|				ИЗ
			|					РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК Т
			|				ГДЕ
			|					ОсновныеСотрудникиФизическихЛиц.Сотрудник = Т.Сотрудник
			|					И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания МЕЖДУ Т.ДатаНачала И Т.ДатаОкончания))
			|ГДЕ
			|	ОсновныеСотрудникиФизическихЛиц.ДатаОкончания = &МаксимальнаяДатаНачалоДня";
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "МаксимальнаяДатаНачалоДня", НачалоДня(ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата()), Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
