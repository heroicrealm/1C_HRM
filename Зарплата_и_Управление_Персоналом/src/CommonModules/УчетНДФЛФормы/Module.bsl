#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает на форме доступность для редактирования полей доходов и вычетов таблицы сведений о доходах 
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения
//  КодДоходаПутьКДанным - Строка
//  ИмяПоляКодВычета     - Строка
//  ИмяПоляСуммаВычета   - Строка
//
Процедура СведенияОДоходахПриСозданииНаСервере(Форма, КодДоходаПутьКДанным, ИмяПоляКодВычета, ИмяПоляСуммаВычета = "") Экспорт 	
	УстановитьУсловноеОформлениеТаблицыСведенияОДоходах(Форма, КодДоходаПутьКДанным, ИмяПоляКодВычета, ИмяПоляСуммаВычета);
КонецПроцедуры	

#Область ПанельПримененныеВычеты

// Возвращает максимальное значение идентификатора строки НДФЛ.
//
// Параметры:
//		ТаблицаНДФЛ - ДанныеФормыКоллекция
//
// Возвращаемое значение:
//		Число
//
Функция МаксимальныйИдентификаторСтрокиНДФЛ(ТаблицаНДФЛ) Экспорт
	
	МаксимальныйИдентификаторСтрокиНДФЛ = 0;
	
	Для каждого СтрокаТаблицыНДФЛ Из ТаблицаНДФЛ Цикл
		
		Если МаксимальныйИдентификаторСтрокиНДФЛ < СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ Тогда
			МаксимальныйИдентификаторСтрокиНДФЛ = СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МаксимальныйИдентификаторСтрокиНДФЛ;
	
КонецФункции

// Назначает идентификаторы строкам таблицы значений НДФЛ и строкам связанной 
// таблицы значений ПримененныеВычетыНаДетейИИмущественные, перед добавление в
// коллекции строк табличных частей объектов.
//
// Параметры:
//		МаксимальныйИдентификаторСтрокиНДФЛ - Число
//		ТаблицаНДФЛ - ТаблицаЗначений
//		ПримененныеВычетыНаДетейИИмущественные - ТаблицаЗначений
//
Процедура НазначитьИдентификаторыНовымСтрокамТаблицамНДФЛИПримененныеВычетыНаДетейИИмущественные(Знач МаксимальныйИдентификаторСтрокиНДФЛ, ТаблицаНДФЛ, ПримененныеВычетыНаДетейИИмущественные) Экспорт
	
	СоответствиеИдентификаторов = Новый Соответствие;
	Для каждого СтрокаТаблицыНДФЛ Из ТаблицаНДФЛ Цикл
		
		СоответствиеИдентификаторов.Вставить(СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ, МаксимальныйИдентификаторСтрокиНДФЛ);
		СтрокаТаблицыНДФЛ.ИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ;
		МаксимальныйИдентификаторСтрокиНДФЛ = МаксимальныйИдентификаторСтрокиНДФЛ + 1;
		
	КонецЦикла;
	
	Для каждого СтрокаТаблицыПримененныеВычетыНаДетейИИмущественные Из ПримененныеВычетыНаДетейИИмущественные Цикл
		
		ИдентификаторСтрокиНДФЛ = СоответствиеИдентификаторов.Получить(СтрокаТаблицыПримененныеВычетыНаДетейИИмущественные.ИдентификаторСтрокиНДФЛ);
		Если ИдентификаторСтрокиНДФЛ <> Неопределено Тогда
			СтрокаТаблицыПримененныеВычетыНаДетейИИмущественные.ИдентификаторСтрокиНДФЛ = ИдентификаторСтрокиНДФЛ;
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет вторичные данные формы.
//
// Параметры:
//		Форма	- ФормаКлиентскогоПриложения
//		Период	- Дата, дата в налоговом периоде, в котором применяются вычеты к доходам.
//
Процедура ЗаполнитьВторичныеДанныеТабличныхЧастей(Форма, Период = '00010101', ВыбранныеСотрудники = Неопределено) Экспорт
	
	Если НЕ Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьНачислениеЗарплаты") Тогда
		Возврат;
	КонецЕсли; 
	
	Если ВыбранныеСотрудники <> Неопределено Тогда 
		
		ФизическиеЛицаСотрудников = Новый Соответствие;
		ВыбранныеФизическиеЛица = Новый Соответствие;
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ВыбранныеСотрудники", ВыбранныеСотрудники);
		
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	Сотрудники.ФизическоеЛицо
		               |ПОМЕСТИТЬ ВТФизическиеЛица
		               |ИЗ
		               |	Справочник.Сотрудники КАК Сотрудники
		               |ГДЕ
		               |	Сотрудники.Ссылка В(&ВыбранныеСотрудники)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	Сотрудники.Ссылка КАК Сотрудник,
		               |	Сотрудники.ФизическоеЛицо
		               |ИЗ
		               |	Справочник.Сотрудники КАК Сотрудники
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТФизическиеЛица КАК ФизическиеЛица
		               |		ПО Сотрудники.ФизическоеЛицо = ФизическиеЛица.ФизическоеЛицо";
					   
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		
		Пока Выборка.Следующий() Цикл 
			ФизическиеЛицаСотрудников.Вставить(Выборка.Сотрудник, Выборка.ФизическоеЛицо);
			ВыбранныеФизическиеЛица.Вставить(Выборка.ФизическоеЛицо, Истина);
		КонецЦикла;
		
	КонецЕсли;
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаСервере();
	
	ВычетыКДоходам = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам");
	Если ВычетыКДоходам <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "СоответствиеКодовВычетовКодамДоходов",
			Новый ФиксированноеСоответствие(УчетНДФЛ.ВычетыКДоходам(Год(Период))));
			
		ДанныеВычетовКДоходам = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ВычетыКДоходам);
		
		Сотрудники = ДанныеВычетовКДоходам.Выгрузить(, "Сотрудник");
		Сотрудники.Свернуть("Сотрудник");
		
		Начисления = ДанныеВычетовКДоходам.Выгрузить(, "Начисление");
		Начисления.Свернуть("Начисление");
		
		УстановитьПривилегированныйРежим(Истина);
		Если ВыбранныеСотрудники = Неопределено Тогда 
			ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сотрудники.ВыгрузитьКолонку("Сотрудник"), "ФизическоеЛицо");
		КонецЕсли;	
		КодыДоходов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Начисления.ВыгрузитьКолонку("Начисление"), "КодДоходаНДФЛ");
		УстановитьПривилегированныйРежим(Ложь);
		
		Для каждого СтрокаНачисления Из ДанныеВычетовКДоходам Цикл
			
			ФизическоеЛицо = ФизическиеЛицаСотрудников[СтрокаНачисления.Сотрудник];
			Если ВыбранныеСотрудники <> Неопределено И ФизическоеЛицо = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаНачисления.Начисление)
				И ТипЗнч(СтрокаНачисления.Начисление) = Тип("ПланВидовРасчетаСсылка.Начисления") Тогда
				
				СтрокаНачисления.ВычетПримененныйКДоходам = Форма.СоответствиеКодовВычетовКодамДоходов.Получить(КодыДоходов.Получить(СтрокаНачисления.Начисление)) <> Неопределено;
				
			КонецЕсли; 
			
			Если ФизическоеЛицо <> Неопределено Тогда
				СтрокаНачисления.ФизическоеЛицо = ФизическоеЛицо;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли; 
	
	ВычетыНаДетейИИмущественные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные");
	Если ВычетыНаДетейИИмущественные <> Неопределено Тогда
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ВычетыНаДетейИИмущественные), "МесяцПериодаПредоставленияВычета", "МесяцПериодаПредоставленияВычетаСтрокой");
	КонецЕсли;
	
	ДанныеНДФЛ = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ПутьКДаннымНДФЛ);
	Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "МаксимальныйИдентификаторСтрокиНДФЛ"] = МаксимальныйИдентификаторСтрокиНДФЛ(ДанныеНДФЛ);
	
	ДанныеНДФЛСтроки = Новый Массив;
	ИмяПоляФизическоеЛицо = ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляФизическоеЛицо;
	
	Для каждого СтрокаНДФЛ Из ДанныеНДФЛ Цикл
		Если ВыбранныеСотрудники <> Неопределено И ВыбранныеФизическиеЛица.Получить(СтрокаНДФЛ[ИмяПоляФизическоеЛицо]) = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		ЗаполнитьПредставленияВычетовСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
		ДанныеНДФЛСтроки.Добавить(СтрокаНДФЛ);
	КонецЦикла;
		
	Если НЕ ПустаяСтрока(ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод) Тогда
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(
			ДанныеНДФЛСтроки,
			ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод,
			ОписаниеПанелиВычеты.ТабличнаяЧастьНДФЛ.ИмяПоляПериод + "Строкой");
	КонецЕсли; 
	
КонецПроцедуры

// Возвращает табличный документ, содержащий печатную форму отчета РегистрНалоговогоУчетаПоНДФЛ,
// сформированный с учетом данных, содержащихся в документе из которого производится вызов.
//
// Параметры:
//		ДокументОбъект - ДокументОбъект, с учетом данных которого формируется отчет.
//		Модифицированность - Булево, признак модифицированности данных формы.
//		ФизическоеЛицо - СправочникСсылка.ФизическиеЛица, по которому формируется отчет.
//		ДатаОтчета - Дата, период за который формируется отчет.
//
// Возвращаемое значение:
//		ТабличныйДокумент
//
Функция РегистрНалоговогоУчетаПоНДФЛ(ДокументОбъект, Модифицированность, ФизическиеЛица, ДатаОтчета) Экспорт
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.АвтоМасштаб = Истина;
	ДокументРезультат.ОтображатьЗаголовки = Ложь;
	ДокументРезультат.ОтображатьСетку = Ложь;
	
	Если ДокументОбъект.ПометкаУдаления Тогда
		ВызватьИсключение НСтр("ru='Документ помечен на удаление, отчет не будет сформирован'");
	Иначе
		
		Попытка
			
			НачатьТранзакцию();
			
			УстановитьПривилегированныйРежим(Истина);
			
			Если ТипЗнч(ФизическиеЛица) = Тип("Массив") Тогда
				ФизическиеЛицаОтчета = ФизическиеЛица;
			Иначе
				ФизическиеЛицаОтчета = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическиеЛица);
			КонецЕсли;
			
			Если НЕ ДокументОбъект.Проведен ИЛИ Модифицированность Тогда
				
				ДокументОбъект.ДополнительныеСвойства.Вставить("ФизическиеЛица", ФизическиеЛицаОтчета);
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				
			КонецЕсли;
			
			УстановитьПривилегированныйРежим(Ложь);
			
			ОтчетРегистрНалоговогоУчетаПоНДФЛ = Отчеты.РегистрНалоговогоУчетаПоНДФЛ.Создать();
			
			Отбор = ОтчетРегистрНалоговогоУчетаПоНДФЛ.КомпоновщикНастроек.Настройки.Отбор;
			Отбор.Элементы.Очистить();
			
			СтандартныйПериод = Новый СтандартныйПериод;
			СтандартныйПериод.ДатаНачала    = НачалоГода(ДатаОтчета);
			СтандартныйПериод.ДатаОкончания = КонецГода(ДатаОтчета);
			
			ПараметрыДанных = ОтчетРегистрНалоговогоУчетаПоНДФЛ.КомпоновщикНастроек.Настройки.ПараметрыДанных;
			ПараметрыДанных.УстановитьЗначениеПараметра("Период", СтандартныйПериод);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Организация", ВидСравненияКомпоновкиДанных.Равно, ДокументОбъект.Организация);
			ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ФизическоеЛицо", ВидСравненияКомпоновкиДанных.ВСписке, ФизическиеЛицаОтчета);
			
			ОтчетРегистрНалоговогоУчетаПоНДФЛ.СкомпоноватьРезультат(ДокументРезультат);
			
			ОтменитьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			Если ПривилегированныйРежим() Тогда
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли; 
			
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение НСтр("ru = 'Не удалось, сформировать отчет.'") + " " + КраткоеПредставлениеОшибки(Инфо);

		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ДокументРезультат;
	
КонецФункции

// Размещает элементы управления панели вычетов НДФЛ, на управляемой форме, переданной
// в качестве параметра.
//
// Параметры:
//		Форма - ФормаКлиентскогоПриложения
//		ОписаниеПанелиВычеты - Структура, описывающая панель вычетов,
//					см. функцию УчетНДФЛКлиентСерверВнутренний.ОписаниеПанелиВычеты.
//
Процедура ДополнитьФормуПанельюВычетов(Форма, ОписаниеПанелиВычеты = Неопределено, ДобавлятьЭлементыФормы = Истина, ДобавлятьРеквизитыФормы = Истина, ОтложенноеИзменение = Ложь) Экспорт
	
	Если НЕ Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьНачислениеЗарплаты") Тогда
		Возврат;
	КонецЕсли; 
	
	УчетНДФЛФормыВнутренний.ДополнитьФормуПанельюВычетов(Форма, ОписаниеПанелиВычеты, ДобавлятьЭлементыФормы, ДобавлятьРеквизитыФормы, ОтложенноеИзменение);
	
КонецПроцедуры

// Добавляет реквизиты формы (в коллекцию добавляемых реквизитов), необходимые для работы панели вычетов.
//
// Параметры:
//		Форма - ФормаКлиентскогоПриложения
//		МассивДобавляемыхРеквизитов - Массив, в который добавляются новые реквизиты.
//		МассивИменРеквизитовФормы - Массив, строк, содержащих пути к данным реквизитам формы.
//      ОписаниеПанелиВычеты - Структура, описывающая панель вычетов,
//					см. функцию УчетНДФЛКлиентСерверВнутренний.ОписаниеПанелиВычеты.
//
Процедура ДополнитьМассивРеквизитовПанелиВычетов(Форма, МассивДобавляемыхРеквизитов, МассивИменРеквизитовФормы, ОписаниеПанелиВычеты = Неопределено) Экспорт
	
	УчетНДФЛФормыВнутренний.ДополнитьМассивРеквизитовПанелиВычетов(Форма, МассивДобавляемыхРеквизитов, МассивИменРеквизитовФормы, ОписаниеПанелиВычеты);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура УстановитьУсловноеОформлениеТаблицыСведенияОДоходах(Форма, КодДоходаПутьКДанным, ИмяПоляКодВычета, ИмяПоляСуммаВычета)
	
	БудущийНалоговыйПериод = Год(ТекущаяДатаСеанса()) + 1;
	
	СоответствиеДоходов = Новый Соответствие;
	Для СчЛет = 2010 По БудущийНалоговыйПериод Цикл
		СоответствиеНалоговогоПериода = УчетНДФЛ.ВычетыКДоходам(СчЛет);
		Для каждого Элемент Из СоответствиеНалоговогоПериода Цикл
			СоответствиеДоходов.Вставить(Элемент.Ключ, Истина);
		КонецЦикла;
	КонецЦикла;
	СписокДоходовСВычетами = Новый СписокЗначений;
	Для каждого Элемент Из СоответствиеДоходов Цикл
		СписокДоходовСВычетами.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	ЭлементУсловногоОформления = Форма.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(КодДоходаПутьКДанным);
	ЭлементОтбора.ПравоеЗначение = СписокДоходовСВычетами;
	
	ОформляемоеПоле =  ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоляКодВычета);
	
	Если ИмяПоляСуммаВычета <> "" Тогда 
		ОформляемоеПоле =  ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Использование = Истина;
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоляСуммаВычета);
	КонецЕсли;
	
	ЭлементОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ТолькоПросмотр");
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Значение = Истина;
	
КонецПроцедуры	

Процедура ПроверитьЗанятостьПолучателяВычетов(Организация, Месяц, Сотрудники, Отказ) Экспорт
	
	УчетНДФЛФормыВнутренний.ПроверитьЗанятостьПолучателяВычетов(Организация, Месяц, Сотрудники, Отказ);
	
КонецПроцедуры

#Область ПанельПримененныеВычеты

Процедура ЗаполнитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты)
	
	ВычетыНаДетейИИмущественные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные");
	Если ВычетыНаДетейИИмущественные <> Неопределено Тогда
		
		СтрокаНДФЛ.ПредставлениеВычетовНаДетейИИмущественных = 0;
		ДанныеВычетовНаДетейИИмущественных = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
			Форма, ВычетыНаДетейИИмущественные);
			
		ДанныеПоСтрокеНДФЛ = ДанныеВычетовНаДетейИИмущественных.НайтиСтроки(Новый Структура("ИдентификаторСтрокиНДФЛ", СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ));
		Для каждого СтрокаДанныхВычетов Из ДанныеПоСтрокеНДФЛ Цикл
			УчетНДФЛКлиентСервер.ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовНаДетейИИмущественных, СтрокаДанныхВычетов.КодВычета, СтрокаДанныхВычетов.РазмерВычета);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты)
	
	ВычетыКДоходам = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам");
	Если ВычетыКДоходам <> Неопределено Тогда
		
		СтрокаНДФЛ.ПредставлениеВычетовКДоходам = 0;
		
		ДанныеВычетовКДоходам = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
			Форма, ВычетыКДоходам);
			
		СтруктураОтбораВычетыПримененныеКДоходам = Новый Структура("ФизическоеЛицо,Подразделение,ВычетПримененныйКДоходам");
		ЗаполнитьЗначенияСвойств(СтруктураОтбораВычетыПримененныеКДоходам, СтрокаНДФЛ);
		
		СтруктураОтбораВычетыПримененныеКДоходам.ВычетПримененныйКДоходам = Истина;
		
		ДанныеПоСтрокеНДФЛ = ДанныеВычетовКДоходам.НайтиСтроки(СтруктураОтбораВычетыПримененныеКДоходам);
		Для каждого СтрокаДанныхВычетов Из ДанныеПоСтрокеНДФЛ Цикл
			УчетНДФЛКлиентСервер.ДополнитьПредставлениеВычетов(СтрокаНДФЛ.ПредставлениеВычетовКДоходам, СтрокаДанныхВычетов.КодВычета, СтрокаДанныхВычетов.СуммаВычета);
		КонецЦикла;
		
	КонецЕсли; 
			
КонецПроцедуры

Процедура ЗаполнитьПредставлениеОбщейСуммыВычетов(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты)
	
	ИмяКолонкиПримененныеВычеты = ОписаниеПанелиВычеты.ИмяКолонкиПримененныеВычеты;
	Если Не ЗначениеЗаполнено(ИмяКолонкиПримененныеВычеты) Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаНДФЛ[ИмяКолонкиПримененныеВычеты] = 0;
	
	ВычетыЛичные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыЛичные");
	Если ВычетыЛичные <> Неопределено Тогда
		СтрокаНДФЛ[ИмяКолонкиПримененныеВычеты] = СтрокаНДФЛ[ИмяКолонкиПримененныеВычеты] + СтрокаНДФЛ.ПредставлениеВычетовЛичных;
	КонецЕсли;
	
	ВычетыКДоходам = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам");
	Если ВычетыКДоходам <> Неопределено Тогда
		СтрокаНДФЛ[ИмяКолонкиПримененныеВычеты] = СтрокаНДФЛ[ИмяКолонкиПримененныеВычеты] + СтрокаНДФЛ.ПредставлениеВычетовКДоходам;
	КонецЕсли;
	
	ВычетыНаДетейИИмущественные = ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные");
	Если ВычетыНаДетейИИмущественные <> Неопределено Тогда
		СтрокаНДФЛ[ИмяКолонкиПримененныеВычеты] = СтрокаНДФЛ[ИмяКолонкиПримененныеВычеты] + СтрокаНДФЛ.ПредставлениеВычетовНаДетейИИмущественных;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПредставленияВычетовСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты) Экспорт
	
	УчетНДФЛКлиентСервер.ЗаполнитьПредставлениеВычетовЛичныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
	ЗаполнитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
	ЗаполнитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
	ЗаполнитьПредставлениеОбщейСуммыВычетов(Форма, СтрокаНДФЛ, ОписаниеПанелиВычеты);
	
КонецПроцедуры

Процедура ОбновитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаСервере();
	Если ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыНаДетейИИмущественные") <> Неопределено Тогда
		
		НДФЛТекущиеДанные = УчетНДФЛКлиентСервер.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
		ЗаполнитьПредставлениеВычетовНаДетейИИмущественныхСтрокиНДФЛ(Форма, НДФЛТекущиеДанные, ОписаниеПанелиВычеты);
		
		Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "ПредставлениеВычетовНаДетейИИмущественных"] = НДФЛТекущиеДанные["ПредставлениеВычетовНаДетейИИмущественных"];
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма) Экспорт
	
	ОписаниеПанелиВычеты = Форма.ОписаниеПанелиВычетыНаСервере();
	Если ОписаниеПанелиВычеты.НастраиваемыеПанели.Получить("ВычетыКДоходам") <> Неопределено Тогда
		
		НДФЛТекущиеДанные = УчетНДФЛКлиентСервер.НДФЛТекущиеДанные(Форма, ОписаниеПанелиВычеты);
		ЗаполнитьПредставлениеВычетовКДоходамСтрокиНДФЛ(Форма, НДФЛТекущиеДанные, ОписаниеПанелиВычеты);
		
		Форма[ОписаниеПанелиВычеты.ИмяГруппыФормыПанелиВычеты + "ПредставлениеВычетовКДоходам"] = НДФЛТекущиеДанные["ПредставлениеВычетовКДоходам"];
		
	КонецЕсли; 
	
КонецПроцедуры

Функция МассивСвязейПараметровВыбораВычетовНДФЛ(ОписаниеПанелиВычеты) Экспорт
	
	Возврат УчетНДФЛФормыВнутренний.МассивСвязейПараметровВыбораВычетовНДФЛ(ОписаниеПанелиВычеты);
	
КонецФункции

Процедура УстановитьФиксРасчетСтрокНДФЛ(Форма, СтруктураПоиска) Экспорт
	
	УчетНДФЛФормыВнутренний.УстановитьФиксРасчетСтрокНДФЛ(Форма, СтруктураПоиска);
	
КонецПроцедуры

Функция ФормаПодробнееОРасчетеНДФЛКонтролируемыеПоляДляФиксацииРезультатов() Экспорт
	
	Возврат УчетНДФЛФормыВнутренний.ФормаПодробнееОРасчетеНДФЛКонтролируемыеПоляДляФиксацииРезультатов();
	
КонецФункции

#КонецОбласти


Функция СведенияОбНДФЛ(Форма, ФизическоеЛицо = Неопределено, ПутьКДаннымАдресРаспределенияРезультатовВХранилище = Неопределено, ТаблицаНачислений= Неопределено) Экспорт
	
	ДанныеОбНДФЛ = Новый Структура;
	Если ФизическоеЛицо = Неопределено Тогда
		
		КоллекцияСтрокНДФЛ = Форма.Объект.НДФЛ.Выгрузить();
		КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных = Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить();
		
		Если ТаблицаНачислений <> Неопределено Тогда
			ДанныеОбНДФЛ.Вставить("Начисления", ТаблицаНачислений);
		КонецЕсли; 
		
	Иначе
		
		СтруктураОтбора = Новый Структура("ФизическоеЛицо", ФизическоеЛицо);
		КоллекцияСтрокНДФЛ = Форма.Объект.НДФЛ.Выгрузить(СтруктураОтбора);
		
		Если Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Количество() = 0 Тогда
			КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных =	Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить();
		Иначе
			
			КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных =	Форма.Объект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить(
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Форма.Объект.ПримененныеВычетыНаДетейИИмущественные[0]));
				
			КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных.Очистить();
			
			ИдентификаторыСтрокНДФЛ = Новый Соответствие;
			Для каждого СтрокаНДФЛ Из КоллекцияСтрокНДФЛ Цикл
				ИдентификаторыСтрокНДФЛ.Вставить(СтрокаНДФЛ.ИдентификаторСтрокиНДФЛ, Истина);
			КонецЦикла;
			
			Для каждого СтрокаВычетов Из Форма.Объект.ПримененныеВычетыНаДетейИИмущественные Цикл
				
				Если ИдентификаторыСтрокНДФЛ.Получить(СтрокаВычетов.ИдентификаторСтрокиНДФЛ) = Истина Тогда
					ЗаполнитьЗначенияСвойств(КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных.Добавить(), СтрокаВычетов);
				КонецЕсли; 
				
			КонецЦикла;
		
		КонецЕсли;
		
		СтруктураОтбора.Вставить("ВычетПримененныйКДоходам", Истина);
		ДанныеОбНДФЛ.Вставить("Начисления", Форма.Объект.Начисления.Выгрузить(СтруктураОтбора));
		
	КонецЕсли;
	
	ДанныеОбНДФЛ.Вставить("НДФЛ", КоллекцияСтрокНДФЛ);
	ДанныеОбНДФЛ.Вставить("ПримененныеВычетыНаДетейИИмущественные", КоллекцияСтрокПримененныхВычетовНаДетейИИмущественных);
	
	Если ПутьКДаннымАдресРаспределенияРезультатовВХранилище <> Неопределено Тогда
		ДанныеОбНДФЛ.Вставить("АдресРаспределенияРезультатовВХранилище", Форма[ПутьКДаннымАдресРаспределенияРезультатовВХранилище]);
	КонецЕсли; 
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеОбНДФЛ, Форма.УникальныйИдентификатор);
	
КонецФункции

Процедура ФормаПодробнееОРасчетеНДФЛПриЗаполнении(Форма, ОписаниеТаблицыНДФЛ, ОписанияТаблицДляРаспределения) Экспорт
	
	УчетНДФЛФормыВнутренний.ФормаПодробнееОРасчетеНДФЛПриЗаполнении(Форма, ОписаниеТаблицыНДФЛ, ОписанияТаблицДляРаспределения);
	
КонецПроцедуры

Функция ДополнительныеДанныеДляПолученияСведенийОДоходахНДФЛДокумента() Экспорт 
	
	ДополнительныеСведения = Новый Структура;
	ДополнительныеСведения.Вставить("МесяцНачисления");
	ДополнительныеСведения.Вставить("ПланируемаяДатаВыплаты");
	
	Возврат ДополнительныеСведения;
	
КонецФункции

Функция СведенияОДоходахНДФЛДокумента(ДокументОбъект, ТаблицыНачислений, ДополнительныеСведения, СписокФизическихЛиц = Неопределено, ПараметрыЗапроса = Неопределено) Экспорт 
	
	МесяцНачисления = ДополнительныеСведения.МесяцНачисления;
	ПланируемаяДатаВыплаты = ДополнительныеСведения.ПланируемаяДатаВыплаты;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	СоздатьВТНачисленияДокументаДляФормированияДоходовНДФЛ(МенеджерВременныхТаблиц, ДокументОбъект, ТаблицыНачислений, СписокФизическихЛиц, ПараметрыЗапроса);
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Начисления.СуммаВычетаНДФЛ КАК СуммаВычета,
	               |	Начисления.КодВычетаНДФЛ КАК КодВычета,
	               |	Начисления.*
	               |ИЗ
	               |	ВТНачисления КАК Начисления
	               |ГДЕ
	               |	Начисления.КодВычетаНДФЛ <> ЗНАЧЕНИЕ(Справочник.ВидыВычетовНДФЛ.ПустаяСсылка)";
				   
	ВычетыКДоходам = Запрос.Выполнить().Выгрузить();
	
	СведенияОДоходахНДФЛ = РегистрыНакопления.СведенияОДоходахНДФЛ.СоздатьНаборЗаписей();
	СведенияОДоходахНДФЛ.Отбор.Регистратор.Установить(Документы.НачислениеЗарплаты.ПустаяСсылка());
	
	Движения = Новый Структура;
	Движения.Вставить("СведенияОДоходахНДФЛ", СведенияОДоходахНДФЛ);
	
	ДатаОперацииПоНалогам = УчетНДФЛ.ДатаОперацииПоДокументу(ДокументОбъект.Дата, МесяцНачисления);
	
	УчетНДФЛ.СформироватьДоходыНДФЛПоНачислениям(Движения, Ложь, ДокументОбъект.Организация, ДатаОперацииПоНалогам, 
		ПланируемаяДатаВыплаты, МенеджерВременныхТаблиц, МесяцНачисления, Ложь, Ложь, , ДокументОбъект.Ссылка);
		
	СведенияОДоходах = СведенияОДоходахНДФЛ.Выгрузить();	
		
	Возврат Новый Структура("ВычетыКДоходам,СведенияОДоходах", ВычетыКДоходам, СведенияОДоходах);
	
КонецФункции

Процедура СоздатьВТНачисленияДокументаДляФормированияДоходовНДФЛ(МенеджерВременныхТаблиц, ДокументОбъект, ТаблицыНачислений, СписокФизическихЛиц, ПараметрыЗапроса)
	
	// Получаем массив имен табличных частей.
	ИменаТаблицНачислений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТаблицыНачислений);
	
	// Метаданные документа используем для обращения к таблице.
	МетаданныеДокумента = ДокументОбъект.Ссылка.Метаданные();
	
	НеобязательныеПоля = Новый Соответствие;
	НеобязательныеПоля.Вставить("СуммаВычета", "0");
	НеобязательныеПоля.Вставить("КодВычета", "ЗНАЧЕНИЕ(Справочник.ВидыВычетовНДФЛ.ПустаяСсылка)");
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если СписокФизическихЛиц <> Неопределено Тогда
		Запрос.УстановитьПараметр("СписокФизическихЛиц", СписокФизическихЛиц);
	КонецЕсли; 
	
	ТекстЗапроса = "";
	ПерваяТаблица = Истина;
	
	Для Каждого ИмяТаблицыНачислений Из ИменаТаблицНачислений Цикл
		
		Если Не ПерваяТаблица Тогда
			ТекстЗапроса = ТекстЗапроса + ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов();
		КонецЕсли;
		
		// Составляем текст объединения - части запроса.
		ТекстОбъединения = 
			"ВЫБРАТЬ
			|	Начисления.Сотрудник КАК Сотрудник,
			|	Начисления.Подразделение,
			|	Начисления.ДатаНачала КАК ДатаНачала,
			|	Начисления.Начисление КАК Начисление,
			|	Начисления.Результат КАК Сумма,
			|	Начисления.СуммаВычета КАК СуммаВычета,
			|	Начисления.КодВычета КАК КодВычета
			|ПОМЕСТИТЬ ВТЗаписиНачислений
			|ИЗ
			|	#ТаблицаНачислений КАК Начисления";
		
		// Проверяем необязательные поля.
		Для Каждого КлючИЗначение Из НеобязательныеПоля Цикл
			ИмяПоля = КлючИЗначение.Ключ;
			ЗначениеПоУмолчанию = КлючИЗначение.Значение;
			Если МетаданныеДокумента.ТабличныеЧасти[ИмяТаблицыНачислений].Реквизиты.Найти(ИмяПоля) <> Неопределено Тогда
				// Поле присутствует в метаданных табличной части - не делаем замен.
				Продолжить;
			КонецЕсли;
			ТекстОбъединения = СтрЗаменить(ТекстОбъединения, "Начисления." + ИмяПоля + " КАК", ЗначениеПоУмолчанию + " КАК");
		КонецЦикла;
		
		Если ПараметрыЗапроса <> Неопределено Тогда 
			Для Каждого КлючИЗначение Из ПараметрыЗапроса Цикл
				ИмяПоля = КлючИЗначение.Ключ;
				ЗначениеПараметра = КлючИЗначение.Значение;
				ТекстОбъединения = СтрЗаменить(ТекстОбъединения, "Начисления." + ИмяПоля + " КАК", "&" + ИмяПоля + " КАК");
				Запрос.УстановитьПараметр(ИмяПоля, ЗначениеПараметра);
			КонецЦикла;
		КонецЕсли;
		
		Запрос.УстановитьПараметр(ИмяТаблицыНачислений, ДокументОбъект[ИмяТаблицыНачислений].Выгрузить());
		
		ТекстОбъединения = СтрЗаменить(ТекстОбъединения, "#ТаблицаНачислений", "&" + ИмяТаблицыНачислений);
		ТекстОбъединения = СтрЗаменить(ТекстОбъединения, "ВТЗаписиНачислений", "ВТДанные" + ИмяТаблицыНачислений);
		
		ТекстЗапроса = ТекстЗапроса + ТекстОбъединения;
		ПерваяТаблица = Ложь;
		
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
	ТекстЗапроса = "";
	ПерваяТаблица = Истина;
	
	Для Каждого ИмяТаблицыНачислений Из ИменаТаблицНачислений Цикл
		
		Если Не ПерваяТаблица Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
	
		ТекстОбъединения = 
			"ВЫБРАТЬ
			|	ЗаписиНачислений.Сотрудник,
			|	ЗаписиНачислений.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ЗаписиНачислений.ДатаНачала,
			|	ЗаписиНачислений.Начисление,
			|	ЗаписиНачислений.Сумма КАК СуммаДохода,
			|	ЗаписиНачислений.СуммаВычета КАК СуммаВычетаНДФЛ,
			|	ЗаписиНачислений.КодВычета КАК КодВычетаНДФЛ,
			|	ЗаписиНачислений.Подразделение,
			|	ЗаписиНачислений.Подразделение КАК ПодразделениеОрганизации
			|ПОМЕСТИТЬ ВТНачисления
			|ИЗ
			|	ВТЗаписиНачислений КАК ЗаписиНачислений";
		
		Если СписокФизическихЛиц <> Неопределено Тогда
			ТекстОбъединения = ТекстОбъединения + "
				|	ГДЕ ЗаписиНачислений.Сотрудник.ФизическоеЛицо В (&СписокФизическихЛиц)";
		КонецЕсли; 
		
		Если Не ПерваяТаблица Тогда
			ТекстОбъединения = СтрЗаменить(ТекстОбъединения, "ПОМЕСТИТЬ ВТНачисления", "");
		КонецЕсли;
		
		ТекстОбъединения = СтрЗаменить(ТекстОбъединения, "ВТЗаписиНачислений", "ВТДанные" + ИмяТаблицыНачислений);
		
		ТекстЗапроса = ТекстЗапроса + ТекстОбъединения;
		ПерваяТаблица = Ложь;
		
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
КонецПроцедуры


#КонецОбласти
