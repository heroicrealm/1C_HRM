#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ФайлыНаПодписьПользователя(ТолькоРазрешенные, Знач Исполнитель = Неопределено) Экспорт
	
	Если Исполнитель = Неопределено Тогда
		Исполнитель = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТФайлыКОбработкеСДаннымиПечатныхФорм(
		ТолькоРазрешенные,
		Запрос.МенеджерВременныхТаблиц,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Исполнитель),
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.ДействияСФайламиДокументовКЭДО.Подписать));
	
	Запрос.УстановитьПараметр("Исполнитель", Исполнитель);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("МаксимальныйПериодОжидания", МаксимальныйПериодОжидания());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПечатныеФормыКОбработке.ПрисоединенныйФайл КАК ФайлОбъекта,
		|	ПодписанныеФормы.ИдентификаторПечатнойФормы КАК ИдентификаторПечатнойФормы,
		|	ТаблицаРегистра.ПрисоединенныйФайл.ВладелецФайла КАК Владелец,
		|	ВЫБОР
		|		КОГДА РАЗНОСТЬДАТ(ТаблицаРегистра.ДатаЗадания, &ТекущаяДата, МИНУТА) > &МаксимальныйПериодОжидания
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Просрочено,
		|	ВЫБОР
		|		КОГДА ПодписанныеФормы.ПрисоединенныйФайл ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ПечатнаяФорма,
		|	ПодписанныеФормы.Оригинал КАК Оригинал,
		|	ПодписанныеФормы.Название КАК Название,
		|	ПодписанныеФормы.Организация КАК Организация,
		|	ПодписанныеФормы.Сотрудник КАК Сотрудник,
		|	ПодписанныеФормы.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПодписанныеФормы.Номер КАК Номер,
		|	ПодписанныеФормы.Дата КАК Дата
		|ИЗ
		|	ВТФайлыКОбработкеСДаннымиПечатныхФорм КАК ПечатныеФормыКОбработке
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
		|		ПО ПечатныеФормыКОбработке.ПрисоединенныйФайл = ТаблицаРегистра.ПрисоединенныйФайл
		|			И (ТаблицаРегистра.Исполнитель = &Исполнитель)
		|			И (ТаблицаРегистра.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодписанныеПечатныеФормы КАК ПодписанныеФормы
		|		ПО ПечатныеФормыКОбработке.ПрисоединенныйФайл = ПодписанныеФормы.ПрисоединенныйФайл
		|ГДЕ
		|	ТаблицаРегистра.Исполнитель = &Исполнитель
		|	И ТаблицаРегистра.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать)";
	
	УстановитьПривилегированныйРежим(Истина);
	ФайлыНаПодпись = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ФайлыНаПодпись;
	
КонецФункции

Функция ЗаданияОбработки(ТолькоРазрешенные, Действия = Неопределено) Экспорт
	
	Задания = Новый Соответствие;
	
	ДействияСФайламиДокументовКЭДО = Новый Массив;
	ДействияСФайламиДокументовКЭДО.Добавить(Перечисления.ДействияСФайламиДокументовКЭДО.ЗаписатьНаДиск);
	
	Если РаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем() Тогда
		ДействияСФайламиДокументовКЭДО.Добавить(Перечисления.ДействияСФайламиДокументовКЭДО.ОтправитьПоПочте);
	КонецЕсли;
	
	Если ИнтеграцияСРаботаВРоссии.ДоступнаПередачаДокументовНаРаботаВРоссии() Тогда
		ДействияСФайламиДокументовКЭДО.Добавить(Перечисления.ДействияСФайламиДокументовКЭДО.ПередатьНаРаботаВРоссии);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТФайлыКОбработке(
		ТолькоРазрешенные,
		Запрос.МенеджерВременныхТаблиц,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			Справочники.Пользователи.ПустаяСсылка()),
		ДействияСФайламиДокументовКЭДО);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ФайлыКОбработке.Действие КАК Действие,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ФайлыКОбработке.ПрисоединенныйФайл) КАК КоличествоПечатныхФорм
		|ИЗ
		|	ВТФайлыКОбработке КАК ФайлыКОбработке
		|ГДЕ
		|	ФайлыКОбработке.КоличествоПодписантов = 0
		|	И &ОтборПоДействию
		|
		|СГРУППИРОВАТЬ ПО
		|	ФайлыКОбработке.Действие
		|
		|УПОРЯДОЧИТЬ ПО
		|	Действие";
	
	Если Действия = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоДействию", "(ИСТИНА)");
	Иначе
		Запрос.УстановитьПараметр("Действия", Действия);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоДействию", "ФайлыКОбработке.Действие В (&Действия)");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		Задания.Вставить(Выборка.Действие, Выборка.КоличествоПечатныхФорм);
	КонецЦикла;
	
	Возврат Задания;
	
КонецФункции

Процедура ЗарегистрироватьОбработкуФайлов(ФайлыКОбработке, Действие = Неопределено, Исполнители = Неопределено) Экспорт
	
	ИсполнителиКУведомлению = Новый Массив;
	Для Каждого ФайлКОбработке Из ФайлыКОбработке Цикл
		
		Если Исполнители <> Неопределено Тогда
			
			Для Каждого Исполнитель Из Исполнители Цикл
				
				НаборЗаписей = РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ПрисоединенныйФайл.Установить(ФайлКОбработке);
				НаборЗаписей.Отбор.Исполнитель.Установить(Исполнитель);
				НаборЗаписей.Отбор.Действие.Установить(Перечисления.ДействияСФайламиДокументовКЭДО.Подписать);
				
				Запись = НаборЗаписей.Добавить();
				Запись.ПрисоединенныйФайл = ФайлКОбработке;
				Запись.ДатаЗадания        = ТекущаяДатаСеанса();
				Запись.Исполнитель        = Исполнитель;
				Запись.Действие           = Перечисления.ДействияСФайламиДокументовКЭДО.Подписать;
				
				УстановитьПривилегированныйРежим(Истина);
				НаборЗаписей.Записать();
				УстановитьПривилегированныйРежим(Ложь);
				
			КонецЦикла;
			ИсполнителиКУведомлению.Добавить(Исполнитель);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Действие)
			И Действие <> Перечисления.ДействияСФайламиДокументовКЭДО.Подписать Тогда
			
			НаборЗаписей = РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ПрисоединенныйФайл.Установить(ФайлКОбработке);
			НаборЗаписей.Отбор.Действие.Установить(Действие);
			
			Запись = НаборЗаписей.Добавить();
			Запись.ПрисоединенныйФайл = ФайлКОбработке;
			Запись.ДатаЗадания        = ТекущаяДатаСеанса();
			Запись.Действие           = Действие;
			
			УстановитьПривилегированныйРежим(Истина);
			НаборЗаписей.Записать();
			УстановитьПривилегированныйРежим(Ложь);
			
			Если ПолучитьФункциональнуюОпцию("ИспользуетсяСервисКабинетСотрудника")
				И Действие <> Перечисления.ДействияСФайламиДокументовКЭДО.ПередатьВКабинетСотрудников Тогда
				
				НаборЗаписей = РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ПрисоединенныйФайл.Установить(ФайлКОбработке);
				НаборЗаписей.Отбор.Действие.Установить(Перечисления.ДействияСФайламиДокументовКЭДО.ПередатьВКабинетСотрудников);
				
				Запись = НаборЗаписей.Добавить();
				Запись.ПрисоединенныйФайл = ФайлКОбработке;
				Запись.ДатаЗадания        = ТекущаяДатаСеанса();
				Запись.Действие           = Перечисления.ДействияСФайламиДокументовКЭДО.ПередатьВКабинетСотрудников;
				
				УстановитьПривилегированныйРежим(Истина);
				НаборЗаписей.Записать();
				УстановитьПривилегированныйРежим(Ложь);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбсужденияБЗК.ЗапланироватьУведомления(ИсполнителиКУведомлению);
	
КонецПроцедуры

Процедура УдалитьФайлыИзОбработки(ФайлыКОбработке, Действие = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Исполнители = Новый Массив;
	Для Каждого ФайлКОбработке Из ФайлыКОбработке Цикл
		
		Набор = РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.СоздатьНаборЗаписей();
		Набор.Отбор.ПрисоединенныйФайл.Установить(ФайлКОбработке);
		Если ЗначениеЗаполнено(Действие) Тогда
			Набор.Отбор.Действие.Установить(Действие);
		КонецЕсли;
		
		Если Действие = Неопределено Или Действие = Перечисления.ДействияСФайламиДокументовКЭДО.Подписать Тогда
			
			Набор.Прочитать();
			Исполнители = Набор.ВыгрузитьКолонку("Исполнитель");
			Набор.Очистить();
			
		КонецЕсли;
		
		Набор.Записать();
		
	КонецЦикла;
	
	ОбсужденияБЗК.ЗапланироватьУведомления(Исполнители);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура УдалитьФайлыИзОбработкиПользователя(ФайлыКОбработке) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ФайлКОбработке Из ФайлыКОбработке Цикл
		
		Набор = РегистрыСведений.ЗапланированныеДействияСФайламиДокументовКЭДО.СоздатьНаборЗаписей();
		Набор.Отбор.ПрисоединенныйФайл.Установить(ФайлКОбработке);
		Набор.Отбор.Исполнитель.Установить(Пользователи.ТекущийПользователь());
		Набор.Отбор.Действие.Установить(Перечисления.ДействияСФайламиДокументовКЭДО.Подписать);
		Набор.Записать();
		
	КонецЦикла;
	
	ОбсужденияБЗК.ЗапланироватьУведомления(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Пользователи.ТекущийПользователь()));
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ФайлыКОбработке(ТолькоРазрешенные, Действия) Экспорт
	
	ФайлыДействий = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТФайлыКОбработке(
		ТолькоРазрешенные,
		Запрос.МенеджерВременныхТаблиц,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			Справочники.Пользователи.ПустаяСсылка()),
		Действия);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ФайлыКОбработке.ПрисоединенныйФайл КАК ПрисоединенныйФайл,
		|	ФайлыКОбработке.Имя КАК Имя,
		|	ФайлыКОбработке.Расширение КАК Расширение,
		|	ФайлыКОбработке.Размер КАК Размер,
		|	ФайлыКОбработке.ПодписанЭП КАК ПодписанЭП,
		|	ФайлыКОбработке.Действие КАК Действие
		|ИЗ
		|	ВТФайлыКОбработке КАК ФайлыКОбработке
		|ГДЕ
		|	ФайлыКОбработке.КоличествоПодписантов = 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Действие,
		|	Имя,
		|	Расширение,
		|	Размер";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.СледующийПоЗначениюПоля("Действие") Цикл
		
		СписокФайлов = Новый СписокЗначений;
		ФайлыДействий.Вставить(Выборка.Действие, СписокФайлов);
		
		Пока Выборка.Следующий() Цикл
			
			РаботаСФайламиБЗК.ДобавитьФайлВСписок(
				СписокФайлов,
				Выборка.ПрисоединенныйФайл,
				Выборка.Имя,
				Выборка.Расширение,
				Выборка.Размер,
				Выборка.ПодписанЭП);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ФайлыДействий;
	
КонецФункции

Функция КоличествоЗависшихЗаданийОбработки(ТолькоРазрешенные) Экспорт
	
	Возврат ФайлыСБольшимиСрокамиОжидания(ТолькоРазрешенные).Количество();
	
КонецФункции

Функция ФайлыСБольшимиСрокамиОжидания(ТолькоРазрешенные) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТФайлыКОбработкеСДаннымиПечатныхФорм(ТолькоРазрешенные, Запрос.МенеджерВременныхТаблиц);
	
	Запрос.УстановитьПараметр("ДатаОтсчета", ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений());
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("КритическийПериодОжидания", КритическийПериодОжидания());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПечатныеФормыКОбработке.ПрисоединенныйФайл КАК ПрисоединенныйФайл,
		|	ПечатныеФормыКОбработке.ВладелецФайла КАК ВладелецФайла,
		|	ПечатныеФормыКОбработке.Имя КАК Имя,
		|	ПечатныеФормыКОбработке.Расширение КАК Расширение,
		|	ПечатныеФормыКОбработке.Размер КАК Размер,
		|	ПечатныеФормыКОбработке.ПодписанЭП КАК ПодписанЭП,
		|	ТаблицаРегистра.Исполнитель КАК Исполнитель,
		|	ТаблицаРегистра.Действие КАК Действие,
		|	ТаблицаРегистра.ДатаЗадания КАК ДатаЗадания,
		|	ВЫБОР
		|		КОГДА ТаблицаРегистра.ДатаЗадания < &ДатаОтсчета
		|			ТОГДА 0
		|		ИНАЧЕ РАЗНОСТЬДАТ(ТаблицаРегистра.ДатаЗадания, &ТекущаяДата, МИНУТА)
		|	КОНЕЦ КАК ОжиданиеМинут
		|ИЗ
		|	ВТФайлыКОбработкеСДаннымиПечатныхФорм КАК ПечатныеФормыКОбработке
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
		|		ПО ПечатныеФормыКОбработке.ПрисоединенныйФайл = ТаблицаРегистра.ПрисоединенныйФайл
		|ГДЕ
		|	ВЫБОР
		|			КОГДА ТаблицаРегистра.ДатаЗадания < &ДатаОтсчета
		|				ТОГДА 0
		|			ИНАЧЕ РАЗНОСТЬДАТ(ТаблицаРегистра.ДатаЗадания, &ТекущаяДата, МИНУТА)
		|		КОНЕЦ > &КритическийПериодОжидания";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция НаправленияНаПодпись(ФайлПечатнойФормы) Экспорт
	
	Направления = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФайлПечатнойФормы", ФайлПечатнойФормы);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаРегистра.Исполнитель КАК Исполнитель,
		|	ТаблицаРегистра.ДатаЗадания КАК ДатаЗадания
		|ИЗ
		|	РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
		|ГДЕ
		|	ТаблицаРегистра.ПрисоединенныйФайл = &ФайлПечатнойФормы
		|	И ТаблицаРегистра.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Исполнитель";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		
		Направление = Новый Структура("Исполнитель,ДатаЗадания");
		ЗаполнитьЗначенияСвойств(Направление, Выборка);
		
		Направления.Добавить(Направление);
		
	КонецЦикла;
	
	Возврат Направления;
	
КонецФункции

Процедура ОбновитьУведомленияОНеобходимостиПодписанияФайловДокументовКЭДО(Знач Исполнители) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(
		Исполнители, Справочники.Пользователи.ПустаяСсылка());
	
	Если Не ЗначениеЗаполнено(Исполнители) Тогда
		Возврат;
	КонецЕсли;
	
	Исполнители = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Исполнители);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТФайлыКОбработкеСДаннымиПечатныхФорм(
		Ложь,
		Запрос.МенеджерВременныхТаблиц,
		Исполнители,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.ДействияСФайламиДокументовКЭДО.Подписать));
	
	Запрос.УстановитьПараметр("Исполнители", Исполнители);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("МаксимальныйПериодОжидания", МаксимальныйПериодОжидания());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаРегистра.Исполнитель КАК Исполнитель,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаРегистра.ПрисоединенныйФайл) КАК КоличествоФайловНаПодпись,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
		|			КОГДА РАЗНОСТЬДАТ(ТаблицаРегистра.ДатаЗадания, &ТекущаяДата, МИНУТА) > &МаксимальныйПериодОжидания
		|				ТОГДА ТаблицаРегистра.ПрисоединенныйФайл
		|			ИНАЧЕ NULL
		|		КОНЕЦ) КАК КоличествоПросроченныхФайловНаПодпись
		|ИЗ
		|	РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТФайлыКОбработкеСДаннымиПечатныхФорм КАК ПечатныеФормыКОбработке
		|		ПО (ПечатныеФормыКОбработке.ПрисоединенныйФайл = ТаблицаРегистра.ПрисоединенныйФайл)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПодписанныеПечатныеФормы КАК ПодписанныеФормы
		|		ПО ТаблицаРегистра.ПрисоединенныйФайл = ПодписанныеФормы.ПрисоединенныйФайл
		|ГДЕ
		|	ТаблицаРегистра.Исполнитель В(&Исполнители)
		|	И ТаблицаРегистра.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать)
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаРегистра.Исполнитель";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Пока Выборка.Следующий() Цикл
		КадровыйЭДО.УведомитьОНеобходимостиПодписанияФайловДокументовКЭДО(
			Выборка.КоличествоФайловНаПодпись, Выборка.КоличествоПросроченныхФайловНаПодпись, Выборка.Исполнитель);
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(Исполнители, Выборка.Исполнитель);
	КонецЦикла;
	
	// Удаление уведомления когда все подписано
	Для Каждого Исполнитель Из Исполнители Цикл
		КадровыйЭДО.УведомитьОНеобходимостиПодписанияФайловДокументовКЭДО(0, 0, Исполнитель);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТФайлыКОбработке(ТолькоРазрешенные, МенеджерВременныхТаблиц, Исполнители, Действия)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	СоздатьВТФайлыКОбработкеСДаннымиПечатныхФорм(
		ТолькоРазрешенные,
		Запрос.МенеджерВременныхТаблиц,
		Исполнители,
		Действия);
	
	Запрос.УстановитьПараметр("ДействияСФайламиДокументовКЭДО", Действия);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПечатныеФормыКОбработке.ПрисоединенныйФайл КАК ПрисоединенныйФайл,
		|	ПечатныеФормыКОбработке.Имя КАК Имя,
		|	ПечатныеФормыКОбработке.Расширение КАК Расширение,
		|	ПечатныеФормыКОбработке.Размер КАК Размер,
		|	ПечатныеФормыКОбработке.ПодписанЭП КАК ПодписанЭП,
		|	ТаблицаРегистра.Действие КАК Действие,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаРегистраПодписей.Исполнитель) КАК КоличествоПодписантов
		|ПОМЕСТИТЬ ВТФайлыКОбработке
		|ИЗ
		|	ВТФайлыКОбработкеСДаннымиПечатныхФорм КАК ПечатныеФормыКОбработке
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
		|		ПО ПечатныеФормыКОбработке.ПрисоединенныйФайл = ТаблицаРегистра.ПрисоединенныйФайл
		|			И (ТаблицаРегистра.Действие В (&ДействияСФайламиДокументовКЭДО))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистраПодписей
		|		ПО ПечатныеФормыКОбработке.ПрисоединенныйФайл = ТаблицаРегистраПодписей.ПрисоединенныйФайл
		|			И (ТаблицаРегистраПодписей.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСФайламиДокументовКЭДО.Подписать))
		|
		|СГРУППИРОВАТЬ ПО
		|	ПечатныеФормыКОбработке.ПрисоединенныйФайл,
		|	ПечатныеФормыКОбработке.Имя,
		|	ПечатныеФормыКОбработке.Расширение,
		|	ПечатныеФормыКОбработке.Размер,
		|	ПечатныеФормыКОбработке.ПодписанЭП,
		|	ТаблицаРегистра.Действие";
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура СоздатьВТФайлыКОбработкеСДаннымиПечатныхФорм(ТолькоРазрешенные, МенеджерВременныхТаблиц, Исполнители = Неопределено, Действия = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаРегистра.ПрисоединенныйФайл КАК ПрисоединенныйФайл
		|ИЗ
		|	РегистрСведений.ЗапланированныеДействияСФайламиДокументовКЭДО КАК ТаблицаРегистра
		|ГДЕ
		|	&ОтборПоИсполнителям
		|	И &ОтборПоДействиям";
	
	Если Исполнители = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоИсполнителям", "(ИСТИНА)");
	Иначе
		Запрос.УстановитьПараметр("Исполнители", Исполнители);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоИсполнителям", "ТаблицаРегистра.Исполнитель В (&Исполнители)");
	КонецЕсли;
	
	Если Действия = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоДействиям", "(ИСТИНА)");
	Иначе
		Запрос.УстановитьПараметр("Действия", Действия);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоДействиям", "ТаблицаРегистра.Действие В(&Действия)");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ФайлыПечатныхФорм = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПрисоединенныйФайл");
	УстановитьПривилегированныйРежим(Ложь);
	
	ТекстыЗапросов = Новый Массив;
	Если ФайлыПечатныхФорм.Количество() > 0 Тогда
		
		ФайлыПоТипам = ОбщегоНазначенияБЗК.ОбъектыПоТипам(ФайлыПечатныхФорм);
		Для Каждого ОписаниеФайловТипа Из ФайлыПоТипам Цикл
			
			МетаданныеСправочника = Метаданные.НайтиПоТипу(ОписаниеФайловТипа.Ключ);
			Если Не ПравоДоступа("Просмотр", МетаданныеСправочника) Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстЗапроса =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ТаблицаСправочника.Ссылка КАК ПрисоединенныйФайл,
				|	ТаблицаСправочника.ВладелецФайла КАК ВладелецФайла,
				|	ТаблицаСправочника.Наименование КАК Имя,
				|	ТаблицаСправочника.Расширение КАК Расширение,
				|	ТаблицаСправочника.Размер КАК Размер,
				|	ТаблицаСправочника.ПодписанЭП КАК ПодписанЭП
				|ПОМЕСТИТЬ ВТФайлыКОбработкеСДаннымиПечатныхФорм
				|ИЗ
				|	Справочник.УвольнениеПрисоединенныеФайлы КАК ТаблицаСправочника
				|ГДЕ
				|	ТаблицаСправочника.Ссылка В(&ПрисоединенныеФайлы)";
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.УвольнениеПрисоединенныеФайлы",
				МетаданныеСправочника.ПолноеИмя());
			
			ИмяПараметра = "ПрисоединенныеФайлы" + Формат(ТекстыЗапросов.Количество(), "ЧН=; ЧГ=");
			Запрос.УстановитьПараметр(ИмяПараметра, ОписаниеФайловТипа.Значение);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПрисоединенныеФайлы", "&" + ИмяПараметра);
			
			Если ТекстыЗапросов.Количество() > 0 Тогда
				
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "РАЗРЕШЕННЫЕ", "");
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ВТФайлыКОбработкеСДаннымиПечатныхФорм", "");
				
			КонецЕсли;
			
			ТекстыЗапросов.Добавить(ТекстЗапроса);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТекстыЗапросов.Количество() = 0 Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	НЕОПРЕДЕЛЕНО КАК ПрисоединенныйФайл,
			|	НЕОПРЕДЕЛЕНО КАК ВладелецФайла,
			|	"""" КАК Имя,
			|	"""" КАК Расширение,
			|	0 КАК Размер,
			|	ЛОЖЬ КАК ПодписанЭП
			|ПОМЕСТИТЬ ВТФайлыКОбработкеСДаннымиПечатныхФорм
			|ГДЕ
			|	ЛОЖЬ";
		
	Иначе
		
		Запрос.Текст = СтрСоединить(ТекстыЗапросов, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
		ЗарплатаКадрыОбщиеНаборыДанных.УстановитьВыборкуТолькоРазрешенныхДанных(Запрос.Текст, ТолькоРазрешенные);
		
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция МаксимальныйПериодОжидания()
	Возврат 2 * ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах() / 60;
КонецФункции

Функция КритическийПериодОжидания()
	Возврат 4 * ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах() / 60;
КонецФункции

#КонецОбласти

#КонецЕсли