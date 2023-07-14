#Область ПрограммныйИнтерфейс

// Для вызова из модуля менеджера справочника "Подразделения организаций".
// Возвращает текст запроса, используемого для обновления подчиненных структурных единиц по указанному регистру.
//
// Параметры:
//  ИмяРегистра  - Строка - имя регистра, в котором будет произведен выбор записей для обновления.
//  ИмяРеквизита - Строка - имя ресурса регистра.
// 
// Возвращаемое значение:
//  Строка - текст запроса.
//
Функция ТекстЗапросаСравненияНаборовСтруктурныхЕдиниц(ИмяРегистра, ИмяРеквизита) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НаборРегистраСведений.Период КАК Период,
	|	НаборРегистраСведений.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	НаборРегистраСведений.ИмяРеквизита КАК ИмяРеквизита
	|ПОМЕСТИТЬ ВТНаборПроверки
	|ИЗ
	|	#ТаблицаРегистра КАК НаборРегистраСведений
	|ГДЕ
	|	НаборРегистраСведений.СтруктурнаяЕдиница В(&ПодчиненныеСтруктурныеЕдиницы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НаборРегистраСведений.Период КАК Период,
	|	НаборРегистраСведений.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	НаборРегистраСведений.ИмяРеквизита КАК ИмяРеквизита
	|ПОМЕСТИТЬ ВТОсновнойНабор
	|ИЗ
	|	#ТаблицаРегистра КАК НаборРегистраСведений
	|ГДЕ
	|	НаборРегистраСведений.СтруктурнаяЕдиница = &ГоловнаяСтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновнойНабор.Период КАК Период,
	|	Организации.Ссылка КАК СтруктурнаяЕдиница,
	|	ОсновнойНабор.ИмяРеквизита КАК ИмяРеквизита
	|ПОМЕСТИТЬ ВТВсеСтруктурныеЕдиницы
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОсновнойНабор КАК ОсновнойНабор
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Организации.Ссылка В(&ПодчиненныеСтруктурныеЕдиницы)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОсновнойНабор.Период,
	|	ПодразделенияОрганизаций.Ссылка,
	|	ОсновнойНабор.ИмяРеквизита
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОсновнойНабор КАК ОсновнойНабор
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПодразделенияОрганизаций.Ссылка В(&ПодчиненныеСтруктурныеЕдиницы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(НаборПроверки.СтруктурнаяЕдиница, ВсеСтруктурныеЕдиницы.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиница
	|ИЗ
	|	ВТНаборПроверки КАК НаборПроверки
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТВсеСтруктурныеЕдиницы КАК ВсеСтруктурныеЕдиницы
	|		ПО НаборПроверки.Период = ВсеСтруктурныеЕдиницы.Период
	|			И НаборПроверки.СтруктурнаяЕдиница = ВсеСтруктурныеЕдиницы.СтруктурнаяЕдиница
	|			И НаборПроверки.ИмяРеквизита = ВсеСтруктурныеЕдиницы.ИмяРеквизита
	|ГДЕ
	|	(НаборПроверки.ИмяРеквизита ЕСТЬ NULL
	|			ИЛИ ВсеСтруктурныеЕдиницы.ИмяРеквизита ЕСТЬ NULL)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновнойНабор.Период КАК Период,
	|	ОсновнойНабор.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ОсновнойНабор.ИмяРеквизита КАК ИмяРеквизита
	|ИЗ
	|	ВТОсновнойНабор КАК ОсновнойНабор";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ТаблицаРегистра", "РегистрСведений." + ИмяРегистра);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяРеквизита", ИмяРеквизита);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Для вызова из модуля менеджера справочника "Подразделения организаций".
// Возвращает головную структурную единицу и массив подчиненных подразделений, для которых требуется тиражирование
// значения из головной структурной единицы.
//
// Параметры:
//  СтруктурнаяЕдиница - СправочникСсылка.Организации, СправочникСсылка.ПодразделенияОрганизаций - организация или подразделение 
//                       для которых требуется получить подчиненные подразделения до первого обособленного.
//
// Возвращаемое значение:
//  Соответствие:
//   * Ключ     - ГоловнаяСтруктурнаяЕдиница    - СправочникСсылка.Организации,
//                                                СправочникСсылка.ПодразделенияОрганизаций - Вышестоящая структурная
//                                                    единица, из которой будет тиражироваться значение.
//   * Значение - ПодчиненныеСтруктурныеЕдиницы - Массив из СправочникСсылка.ПодразделенияОрганизаций - Подчиненные подразделения, 
//                                                для которых требуется установка значения из вышестоящей структурной единицы.
//
Функция ПодчиненныеСтруктурныеЕдиницы(СтруктурнаяЕдиница) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодразделенияОрганизаций.Ссылка,
	|	ВЫБОР
	|		КОГДА ПодразделенияОрганизаций.Родитель = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	|			ТОГДА ПодразделенияОрганизаций.Владелец
	|		ИНАЧЕ ПодразделенияОрганизаций.Родитель
	|	КОНЕЦ КАК Родитель
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	(&СтруктурнаяЕдиница = НЕОПРЕДЕЛЕНО
	|			ИЛИ ПодразделенияОрганизаций.Ссылка В ИЕРАРХИИ (&СтруктурнаяЕдиница))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Организации.Ссылка,
	|	ВЫБОР
	|		КОГДА Организации.ГоловнаяОрганизация = Организации.Ссылка
	|			ТОГДА Организации.Ссылка
	|		ИНАЧЕ Организации.ГоловнаяОрганизация
	|	КОНЕЦ
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	(&СтруктурнаяЕдиница = НЕОПРЕДЕЛЕНО
	|			ИЛИ Организации.Ссылка = &СтруктурнаяЕдиница)";
	
	Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организации.Ссылка = &СтруктурнаяЕдиница", "(ИСТИНА)");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПодразделенияОрганизаций.Ссылка В ИЕРАРХИИ (&СтруктурнаяЕдиница)", "ПодразделенияОрганизаций.Владелец = &СтруктурнаяЕдиница");
	КонецЕсли;
	
	ТаблицаПодчиненности = Новый ТаблицаЗначений;
	ТаблицаПодчиненности.Колонки.Добавить("Элемент", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации"));
	ТаблицаПодчиненности.Колонки.Добавить("Родитель", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации"));
	ТаблицаПодчиненности.Колонки.Добавить("Уровень", Новый ОписаниеТипов("Число"));
	
	СоответствиеПодчиненности = Новый Соответствие;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеПодчиненности.Вставить(Выборка.Ссылка, Выборка.Родитель);
	КонецЦикла;
	Если СтруктурнаяЕдиница <> Неопределено Тогда
		ДополнитьРодителямиСтруктурнойЕдиницы(СоответствиеПодчиненности, СтруктурнаяЕдиница);
	КонецЕсли;
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		Родитель = СоответствиеПодчиненности[Выборка.Ссылка];
		Уровень = 1;
		Пока Истина Цикл
			НоваяСтрока = ТаблицаПодчиненности.Добавить();
			НоваяСтрока.Элемент = Выборка.Ссылка;
			НоваяСтрока.Родитель = Родитель;
			НоваяСтрока.Уровень = Уровень;
			Если Выборка.Ссылка = Родитель Тогда
				НоваяСтрока.Уровень = 0;
				Прервать;
			КонецЕсли;
			ПредыдущийРодитель = Родитель;
			Родитель = СоответствиеПодчиненности[Родитель];
			Если Родитель = Неопределено И ПредыдущийРодитель <> Неопределено Тогда
				Если ТипЗнч(ПредыдущийРодитель) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредыдущийРодитель, "Владелец");
				Иначе
					Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредыдущийРодитель, "ГоловнаяОрганизация");
				КонецЕсли;
			КонецЕсли;
			Уровень = Уровень + 1;
			Если ПредыдущийРодитель = Родитель Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаПодчиненности", ТаблицаПодчиненности);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПодчиненности.Элемент КАК ПодчиненнаяСтруктурнаяЕдиница,
	|	ТаблицаПодчиненности.Родитель КАК СтруктурнаяЕдиница,
	|	ТаблицаПодчиненности.Уровень
	|ПОМЕСТИТЬ ВТСтруктурныеЕдиницы
	|ИЗ
	|	&ТаблицаПодчиненности КАК ТаблицаПодчиненности
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодчиненнаяСтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница,
	|	СтруктурныеЕдиницы.Уровень КАК Уровень
	|ПОМЕСТИТЬ ВТПодчиненныеПодразделенияИОрганизации
	|ИЗ
	|	ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ВладельцыПодразделений
	|			ПО ПодразделенияОрганизаций.Владелец = ВладельцыПодразделений.Ссылка
	|		ПО (ПодразделенияОрганизаций.ОбособленноеПодразделение)
	|			И (ВладельцыПодразделений.ЕстьОбособленныеПодразделения)
	|			И СтруктурныеЕдиницы.СтруктурнаяЕдиница = ПодразделенияОрганизаций.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница,
	|	СтруктурныеЕдиницы.Уровень
	|ИЗ
	|	ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО СтруктурныеЕдиницы.СтруктурнаяЕдиница = Организации.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница,
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА ВладельцыПодразделений.ЕстьОбособленныеПодразделения
	|				ТОГДА Подразделения.ОбособленноеПодразделение
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ, Организации.ОбособленноеПодразделение) КАК ОбособленноеПодразделение,
	|	МИНИМУМ(ПодчиненныеПодразделенияИОрганизации.Уровень) КАК Уровень,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ВЫБОР
	|						КОГДА ВладельцыПодразделений.ЕстьОбособленныеПодразделения
	|							ТОГДА Подразделения.ОбособленноеПодразделение
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ, Организации.ОбособленноеПодразделение)
	|				ИЛИ ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница ССЫЛКА Справочник.Организации
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПодразделениеОбособленноеИлиОрганизация
	|ПОМЕСТИТЬ ВТПодчиненныеСтруктурныеЕдиницы
	|ИЗ
	|	ВТПодчиненныеПодразделенияИОрганизации КАК ПодчиненныеПодразделенияИОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК Подразделения
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ВладельцыПодразделений
	|			ПО Подразделения.Владелец = ВладельцыПодразделений.Ссылка
	|		ПО ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница = Подразделения.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница = Организации.Ссылка
	|ГДЕ
	|	(Подразделения.Ссылка ЕСТЬ НЕ NULL 
	|			ИЛИ Организации.Ссылка ЕСТЬ НЕ NULL )
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница,
	|	ЕСТЬNULL(Подразделения.ОбособленноеПодразделение, Организации.ОбособленноеПодразделение),
	|	Подразделения.ОбособленноеПодразделение,
	|	Организации.ОбособленноеПодразделение,
	|	ВладельцыПодразделений.ЕстьОбособленныеПодразделения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТГоловнаяСтруктурнаяЕдиница
	|ИЗ
	|	ВТПодчиненныеСтруктурныеЕдиницы КАК ПодчиненныеСтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ПО (&СтруктурнаяЕдиница = НЕОПРЕДЕЛЕНО
	|				ИЛИ ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = &СтруктурнаяЕдиница)
	|			И (ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|					И ПодчиненныеСтруктурныеЕдиницы.ПодразделениеОбособленноеИлиОрганизация
	|				ИЛИ НЕ ПодчиненныеСтруктурныеЕдиницы.ОбособленноеПодразделение
	|					И ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница
	|					И ПодчиненныеСтруктурныеЕдиницы.Уровень = СтруктурныеЕдиницы.Уровень)
	|
	|СГРУППИРОВАТЬ ПО
	|	СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница
	|ИЗ
	|	ВТПодчиненныеСтруктурныеЕдиницы КАК ПодчиненныеСтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТГоловнаяСтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница
	|			ПО СтруктурныеЕдиницы.СтруктурнаяЕдиница = ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница
	|		ПО ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница
	|			И ПодчиненныеСтруктурныеЕдиницы.Уровень = СтруктурныеЕдиницы.Уровень
	|			И (НЕ ПодчиненныеСтруктурныеЕдиницы.ОбособленноеПодразделение)
	|			И (СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница ССЫЛКА Справочник.ПодразделенияОрганизаций)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГоловнаяСтруктурнаяЕдиница,
	|	СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница
	|ИЗ
	|	ВТГоловнаяСтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница";
	
	ПодчиненныеСтруктурныеЕдиницы = Новый Соответствие;
	
	РезультатЗапросов = Запрос.ВыполнитьПакет();
	Подчиненные = РезультатЗапросов[РезультатЗапросов.Количество() - 2].Выгрузить();
	Выборка = РезультатЗапросов[РезультатЗапросов.Количество() - 1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОтборПоГоловнойСтруктурнойЕдинице = Новый Структура("ГоловнаяСтруктурнаяЕдиница", Выборка.ГоловнаяСтруктурнаяЕдиница);
		НайденныеСтроки = Подчиненные.НайтиСтроки(ОтборПоГоловнойСтруктурнойЕдинице);
		МассивПодчиненныхСтруктурныхЕдиниц = Подчиненные.Скопировать(НайденныеСтроки).ВыгрузитьКолонку("СтруктурнаяЕдиница");
		ПодчиненныеСтруктурныеЕдиницы.Вставить(Выборка.ГоловнаяСтруктурнаяЕдиница, МассивПодчиненныхСтруктурныхЕдиниц);
	КонецЦикла;;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПодчиненныеСтруктурныеЕдиницы;
	
КонецФункции

// Для вызова из модуля объекта справочника "Подразделения организаций".
// Вызывается перед записью объекта.
//
// Параметры:
//  ПодразделениеОрганизации - СправочникОбъект.ПодразделенияОрганизаций - объект, для которого вызывается метод.
//  Отказ                    - Булево                                    - признак отказа от записи.
//
Процедура ПередЗаписью(ПодразделениеОрганизации, Отказ) Экспорт

	Если ПодразделениеОрганизации.ЭтоНовый() Тогда
		ПодразделениеОрганизации.ДополнительныеСвойства.Вставить("ОбновитьИсториюРегистрацийВНалоговомОргане", Истина);
		ПодразделениеОрганизации.ДополнительныеСвойства.Вставить("ОбновитьИсториюСамостоятельныхКлассификационныхЕдиниц", Истина);
	Иначе
		
		ПрежниеЗначение = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПодразделениеОрганизации.Ссылка, 
			"ОбособленноеПодразделение,Владелец,Родитель,РегистрацияВНалоговомОргане,СамостоятельнаяКлассификационнаяЕдиница");
		
		Если ПрежниеЗначение.Владелец <> ПодразделениеОрганизации.Владелец Тогда
			ВызватьИсключение НСтр("ru='Нельзя менять организацию - владельца элемента справочника ""Подразделения""'");;
		КонецЕсли;
		
		Если ПодразделениеОрганизации.ОбособленноеПодразделение <> ПрежниеЗначение.ОбособленноеПодразделение Тогда
			ПодразделениеОрганизации.ДополнительныеСвойства.Вставить("ОбновитьИсториюРегистрацийВНалоговомОргане", Истина);
			ПодразделениеОрганизации.ДополнительныеСвойства.Вставить("ОбновитьИсториюСамостоятельныхКлассификационныхЕдиниц", Истина);
		ИначеЕсли ПодразделениеОрганизации.Родитель <> ПрежниеЗначение.Родитель Тогда
			
			Если ЗначениеЗаполнено(ПодразделениеОрганизации.Родитель) Тогда
				РегистрацияВНалоговомОрганеВышестоящего = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
					ПодразделениеОрганизации.Родитель, "РегистрацияВНалоговомОргане");
				СКЕВышестоящего = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодразделениеОрганизации.Родитель, "СамостоятельнаяКлассификационнаяЕдиница");
			Иначе
				РегистрацияВНалоговомОрганеВышестоящего = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
					ПодразделениеОрганизации.Владелец, "РегистрацияВНалоговомОргане");
				СКЕВышестоящего = Неопределено;
			КонецЕсли;
			
			Если Не ПодразделениеОрганизации.ОбособленноеПодразделение 
				И ПрежниеЗначение.РегистрацияВНалоговомОргане <> РегистрацияВНалоговомОрганеВышестоящего Тогда
				ПодразделениеОрганизации.ДополнительныеСвойства.Вставить("ОбновитьИсториюРегистрацийВНалоговомОргане", Истина);
			КонецЕсли;
			
			Если ПрежниеЗначение.СамостоятельнаяКлассификационнаяЕдиница <> СКЕВышестоящего Тогда
				ПодразделениеОрганизации.ДополнительныеСвойства.Вставить("ОбновитьИсториюСамостоятельныхКлассификационныхЕдиниц", Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НастройкаПорядкаЭлементов.УстановитьЗначениеРеквизитаУпорядочивания(ПодразделениеОрганизации);
	
	РеквизитИерархическогоУпорядочивания = РеквизитИерархическогоУпорядочивания(ПодразделениеОрганизации);
	Если ПодразделениеОрганизации.РеквизитДопУпорядочиванияИерархического <> РеквизитИерархическогоУпорядочивания Тогда
		ПодразделениеОрганизации.РеквизитДопУпорядочиванияИерархического = РеквизитИерархическогоУпорядочивания;
	КонецЕсли;
	
КонецПроцедуры

// Для вызова из модуля объекта справочника "Подразделения организаций".
// Вызывается при записи объекта.
//
// Параметры:
//  ПодразделениеОрганизации - СправочникОбъект.ПодразделенияОрганизаций - объект, для которого вызывается метод.
//  Отказ                    - Булево                                    - признак отказа от записи.
//
Процедура ПриЗаписи(ПодразделениеОрганизации, Отказ) Экспорт
	
	Если ПодразделениеОрганизации.ДополнительныеСвойства.Свойство("ОбновитьИсториюРегистрацийВНалоговомОргане") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Если ПодразделениеОрганизации.ОбособленноеПодразделение Тогда
			
			Набор = РегистрыСведений.ИсторияРегистрацийВНалоговомОргане.СоздатьНаборЗаписей();
			Набор.Отбор.СтруктурнаяЕдиница.Установить(ПодразделениеОрганизации.Ссылка);
			
			Если ЗначениеЗаполнено(ПодразделениеОрганизации.РегистрацияВНалоговомОргане) Тогда
				
				Запись = Набор.Добавить();
				Запись.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц();
				Запись.СтруктурнаяЕдиница = ПодразделениеОрганизации.Ссылка;
				Запись.РегистрацияВНалоговомОргане = ПодразделениеОрганизации.РегистрацияВНалоговомОргане;
				
			КонецЕсли;
			
			Набор.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			Набор.Записать();
			
		Иначе
			
			Если ЗначениеЗаполнено(ПодразделениеОрганизации.Родитель) Тогда
				ВышестоящаяСтруктурнаяЕдиница = ПодразделениеОрганизации.Родитель;
			Иначе
				ВышестоящаяСтруктурнаяЕдиница = ПодразделениеОрганизации.Владелец;
			КонецЕсли;
			
			ПараметрыЗаполнения = Новый Соответствие;
			ПараметрыЗаполнения.Вставить(ВышестоящаяСтруктурнаяЕдиница, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				ПодразделениеОрганизации.Ссылка));
			
			РегистрыСведений.ИсторияРегистрацийВНалоговомОргане.ОбновитьПодчиненныеСтруктурныеЕдиницы(ПараметрыЗаполнения);
			
		КонецЕсли; 
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли; 
	
	Если ПодразделениеОрганизации.ДополнительныеСвойства.Свойство("ОбновитьИсториюСамостоятельныхКлассификационныхЕдиниц") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Если ПодразделениеОрганизации.ОбособленноеПодразделение Тогда
			
			Набор = РегистрыСведений.ИсторияСамостоятельныхКлассификационныхЕдиниц.СоздатьНаборЗаписей();
			Набор.Отбор.СтруктурнаяЕдиница.Установить(ПодразделениеОрганизации.Ссылка);
			
			Если ЗначениеЗаполнено(ПодразделениеОрганизации.СамостоятельнаяКлассификационнаяЕдиница) Тогда
				
				Запись = Набор.Добавить();
				Запись.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведенийСПериодомМесяц();
				Запись.СтруктурнаяЕдиница = ПодразделениеОрганизации.Ссылка;
				Запись.СКЕ = ПодразделениеОрганизации.СамостоятельнаяКлассификационнаяЕдиница;
				
			КонецЕсли;
			
			Набор.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			Набор.Записать();
			
		Иначе
			
			Если ЗначениеЗаполнено(ПодразделениеОрганизации.Родитель) Тогда
				ВышестоящаяСтруктурнаяЕдиница = ПодразделениеОрганизации.Родитель;
			КонецЕсли;
			
			ПараметрыЗаполнения = Новый Соответствие;
			ПараметрыЗаполнения.Вставить(ВышестоящаяСтруктурнаяЕдиница, 
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПодразделениеОрганизации.Ссылка));
			
			РегистрыСведений.ИсторияСамостоятельныхКлассификационныхЕдиниц.ОбновитьПодчиненныеСтруктурныеЕдиницы(ПараметрыЗаполнения);
			
		КонецЕсли; 
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	ОбновитьРеквизитИерархическогоУпорядочивания(ПодразделениеОрганизации.Ссылка, 
		ПодразделениеОрганизации.РеквизитДопУпорядочиванияИерархического);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbf26-9802-11e9-80cd-4cedfb43b11a", Метаданные.Справочники.ПодразделенияОрганизаций);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Справочники.ПодразделенияОрганизаций, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьРодителямиСтруктурнойЕдиницы(СоответствиеПодчиненности, СтруктурнаяЕдиница)
	
	Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации") Тогда
		ИмяРеквизитаРодитель = "ГоловнаяОрганизация";
	ИначеЕсли ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		ИмяРеквизитаРодитель = "Родитель";
	Иначе
		ИмяРеквизитаРодитель = "Ссылка";
	КонецЕсли;
	РодительСтруктурнойЕдиницы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница, ИмяРеквизитаРодитель);
	Если РодительСтруктурнойЕдиницы = СтруктурнаяЕдиница Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РодительСтруктурнойЕдиницы) Тогда
		СоответствиеПодчиненности.Вставить(СтруктурнаяЕдиница, РодительСтруктурнойЕдиницы);
		ДополнитьРодителямиСтруктурнойЕдиницы(СоответствиеПодчиненности, РодительСтруктурнойЕдиницы);
	КонецЕсли;
	
КонецПроцедуры

Функция РеквизитИерархическогоУпорядочивания(ПодразделениеОрганизации)
	
	РеквизитИерархическогоУпорядочивания = Формат(ПодразделениеОрганизации.РеквизитДопУпорядочивания, "ЧЦ=5; ЧН=; ЧВН=; ЧГ=");
	ПроверяемыйРодитель = ПодразделениеОрганизации.Родитель;
	Если ЗначениеЗаполнено(ПроверяемыйРодитель) Тогда
		ЗначенияРеквизитаРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроверяемыйРодитель, "РеквизитДопУпорядочиванияИерархического");
		РеквизитИерархическогоУпорядочивания = ЗначенияРеквизитаРодителя + РеквизитИерархическогоУпорядочивания;
	КонецЕсли;
	
	Возврат РеквизитИерархическогоУпорядочивания;
	
КонецФункции

Процедура ОбновитьРеквизитИерархическогоУпорядочивания(ПодразделенияОрганизацийСсылка, РеквизитИерархическогоУпорядочивания)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодразделенияОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	ПодразделенияОрганизаций.Родитель = &ПодразделенияОрганизацийСсылка
	|	И НЕ ПодразделенияОрганизаций.РеквизитДопУпорядочиванияИерархического ПОДОБНО &РеквизитИерархическогоУпорядочивания";
	
	Запрос.УстановитьПараметр("ПодразделенияОрганизацийСсылка", ПодразделенияОрганизацийСсылка);
	Запрос.УстановитьПараметр("РеквизитИерархическогоУпорядочивания", РеквизитИерархическогоУпорядочивания + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПодразделенияОрганизацийОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Попытка 
				ПодразделенияОрганизацийОбъект.Заблокировать();
			Исключение
				ТекстИсключенияЗаписи = СтрШаблон(
					НСтр("ru = 'Не удалось изменить настройку упорядочивания для подразделения ""%1"" 
					           |Возможно, подразделения редактируется другим пользователем'"),
					ПодразделенияОрганизацийОбъект.Наименование);
				ВызватьИсключение ТекстИсключенияЗаписи;
			КонецПопытки;
			ПодразделенияОрганизацийОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти