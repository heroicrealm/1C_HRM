#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.НачислениеПоДоговорам - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.НачислениеПоДоговорам - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
		
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ);
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	Если СтруктураВидовУчета.Начисления Тогда
		РасчетЗарплаты.СформироватьДвиженияНачисленийПоДоговорам(Движения, Отказ, РеквизитыДляПроведения.Организация, НачалоМесяца(РеквизитыДляПроведения.МесяцНачисления),
			ДанныеДляПроведения.НачисленияПоДоговорам);
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		ДатаОперации = УчетНДФЛ.ДатаОперацииПоДокументу(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.МесяцНачисления);
		
		// Удержания
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации, ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
		ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержанийДоПределаПоСотрудникам(Движения, Отказ, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.УдержанияДоПределаПоСотрудникам);
		РасчетЗарплатыРасширенный.СформироватьЗадолженностьПоУдержаниямФизическихЛиц(Движения, ДанныеДляПроведения.ЗадолженностьПоУдержаниям);
		РасчетЗарплатыРасширенный.СформироватьДополнениеРасчетнойБазыУдержаний(Движения, ДанныеДляПроведения.ДополнениеРасчетнойБазыУдержаний);
		
		// Заполним описание данных для проведения в учете начисленной зарплаты.
		ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
		ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
		ДанныеДляПроведенияУчетЗарплаты.Организация 			= РеквизитыДляПроведения.Организация;
		ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= РеквизитыДляПроведения.МесяцНачисления;
		ДанныеДляПроведенияУчетЗарплаты.ПорядокВыплаты 			= РеквизитыДляПроведения.ПорядокВыплаты;
		ДанныеДляПроведенияУчетЗарплаты.МенеджерВременныхТаблиц = ДанныеДляПроведения.МенеджерВременныхТаблиц;
		
		// - Регистрация договоров в учете начислений и удержаний.
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисления(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.НачисленияПоДоговорамСРаспределением, Неопределено);
		
		// - Регистрация договоров в бухучете.
		ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьНачисленияУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ,
				ДанныеДляПроведения.НачисленияПоДоговорамСРаспределением, Неопределено, Неопределено);
		
		// НДФЛ
		УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации, ДанныеДляПроведения.НДФЛ, Ложь, Ложь);
		УчетНДФЛРасширенный.СформироватьСоциальныеВычетыПоУдержаниям(РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления), РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.Удержания, Ложь, Ложь);
		УчетНДФЛ.СформироватьДокументыУчтенныеПриРасчетеДляМежрасчетногоДокументаПоВременнойТаблице(Движения, Отказ, РеквизитыДляПроведения.Организация, ДанныеДляПроведения.МенеджерВременныхТаблиц, РеквизитыДляПроведения.Ссылка); 	
		
		// - Регистрация договоров в учете НДФЛ.
		Если РасчетЗарплатыРасширенный.ВыплатыПоДоговорамГПХМогутНеОблагатьсяНДФЛ() Тогда
			ОбратныйИндекс = ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ.Количество();
			Пока ОбратныйИндекс > 0 Цикл
				ОбратныйИндекс = ОбратныйИндекс - 1;
				Если ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ[ОбратныйИндекс].НеОблагаетсяНДФЛ Тогда
					ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ.Удалить(ОбратныйИндекс);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ГрантыНеоблагаемыеНДФЛ") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ГрантыНеоблагаемыеНДФЛ");
			Модуль.ОтобратьДоходыПоДоговорамПодрядаОблагаемыеНДФЛ(ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ);
		КонецЕсли;
		
		УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации,
			ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ, , Ложь, ДокументСсылка);
			
		// Дополняем доходы НДФЛ сведениями о распределении по статьям финансирования и/или статьям расходов.
		ОтражениеЗарплатыВУчетеРасширенный.ДополнитьСведенияОДоходахНДФЛСведениямиОРаспределенииПоСтатьям(Движения);
		
		// Записываем движения, необходимо для регистрации удержаний в учете начисленной зарплаты.
		Движения.СведенияОДоходахНДФЛ.Записать();
		Движения.СведенияОДоходахНДФЛ.Записывать = Ложь;
		
		УчетНачисленнойЗарплаты.СоздатьВТРаспределениеНачисленийТекущегоДокумента(ДанныеДляПроведенияУчетЗарплаты);
		
		// Учет начисленной зарплаты
		// - регистрация НДФЛ в учете начислений и удержаний.
		УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НДФЛПоСотрудникам, РеквизитыДляПроведения.Организация, ДатаОперации);
		УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛИКорректировкиВыплаты(ДанныеДляПроведенияУчетЗарплаты, Отказ,
			ДанныеДляПроведения.НДФЛПоСотрудникам, ДанныеДляПроведения.КорректировкиВыплатыПоСотрудникам);
	
		// - Регистрация бухучета удержаний и НДФЛ
		ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьНачисленияУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ,
						Неопределено, ДанныеДляПроведения.УдержанияПоСотрудникам, ДанныеДляПроведения.НДФЛПоСотрудникам);
						
		// - Регистрация удержаний в учете начисленной зарплаты.
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.УдержанияПоСотрудникам);
			
		// - Регистрация договоров в доходах для страховых взносов.
		СведенияОДоходахСтраховыеВзносы = УчетСтраховыхВзносов.СведенияОДоходахПоДоговорамСтраховыеВзносы(
			РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц);
		
		УчетСтраховыхВзносов.СформироватьДоходыСтраховыеВзносы(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, СведенияОДоходахСтраховыеВзносы, Истина);
		
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

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
	
	МетаданныеДокумента = Метаданные.Документы.НачислениеПоДоговорам;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.НачислениеПоДоговорам);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатЗаполнения = Новый Структура;
	
	// Получение данных для заполнения табличных частей документа.
	ОписаниеДокумента = СтруктураПараметров.ОписаниеДокумента;
	Организация = СтруктураПараметров.Организация;
	МесяцНачисления = СтруктураПараметров.МесяцНачисления;
	
	ДополнительныеПараметры = РасчетЗарплатыРасширенный.ДополнительныеПараметрыЗаполненияТаблицДокумента();
	ДополнительныеПараметры.ДокументСсылка = СтруктураПараметров.ДокументСсылка;
	ДополнительныеПараметры.Подразделение = СтруктураПараметров.Подразделение;
	ДополнительныеПараметры.ОкончаниеПериода = СтруктураПараметров.ОкончаниеПериода;
	ДополнительныеПараметры.РежимНачисления = СтруктураПараметров.РежимНачисления;
	ДополнительныеПараметры.ПорядокВыплаты = СтруктураПараметров.ПорядокВыплаты;
	ДополнительныеПараметры.ДатаВыплаты = СтруктураПараметров.ДатаВыплаты;
	ДополнительныеПараметры.СотрудникиПериодДействияПерерасчет = СтруктураПараметров.СотрудникиПериодДействияПерерасчет;
	ДополнительныеПараметры.ИспользоватьВоеннуюСлужбу = СтруктураПараметров.ИспользоватьВоеннуюСлужбу;
	ДополнительныеПараметры.НачислениеЗарплатыВоеннослужащим = СтруктураПараметров.НачислениеЗарплатыВоеннослужащим;
	ДополнительныеПараметры.ОкончательныйРасчетНДФЛ = СтруктураПараметров.ОкончательныйРасчетНДФЛ;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.МногопотоковоеЗаполнениеДокументов") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("МногопотоковоеЗаполнениеДокументов");
		Если Не РегистрыРасчета.Начисления.ЕстьДвиженияПоРегистратору(СтруктураПараметров.ДокументСсылка) И Модуль.ИспользоватьМногопотоковоеЗаполнениеДокументов() Тогда
			ДополнительныеПараметры.АдресХранилища = АдресХранилища;
			Модуль.ПодготовитьДанныеДляЗаполнения(ОписаниеДокумента, Организация, МесяцНачисления, ДополнительныеПараметры);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеЗаполнения = РасчетЗарплатыРасширенный.ДанныеДляЗаполненияТаблицДокумента(ОписаниеДокумента, Организация, МесяцНачисления, ДополнительныеПараметры);
	
	РезультатЗаполнения.Вставить("ДанныеДляЗаполненияТаблицДокумента", ДанныеЗаполнения);
	
	ПоместитьВоВременноеХранилище(РезультатЗаполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ВыполнитьПроведение(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДокументОбъект = СтруктураПараметров.ДокументСсылка.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

Процедура ЗаполнитьПредставлениеРаспределенияРезультатовРасчета(ДокументОбъект) Экспорт 
	
	ДокументОбъект.ПредставлениеРаспределенияРезультатовРасчета.Очистить();
	
	ПроверяемыеПоля = Новый Структура;
	ПроверяемыеПоля.Вставить("СтатьяФинансирования", Справочники.СтатьиФинансированияЗарплата.ПустаяСсылка());
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
		ПроверяемыеПоля.Вставить("СтатьяРасходов", Справочники.СтатьиРасходовЗарплата.ПустаяСсылка());
	КонецЕсли;
	ПроверяемыеПоля.Вставить("СпособОтраженияЗарплатыВБухучете", Справочники.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка());
	
	ЗаполнитьДанныеПредставленияРаспределенияРезультатовНачисленийУдержаний(ДокументОбъект, ДокументОбъект.РаспределениеРезультатовНачислений, ПроверяемыеПоля, Истина);
	
	ПроверяемыеПоля.Удалить("СпособОтраженияЗарплатыВБухучете");
	ПроверяемыеПоля.Вставить("Сотрудник", Справочники.Сотрудники.ПустаяСсылка());
	
	ЗаполнитьДанныеПредставленияРаспределенияРезультатовНачисленийУдержаний(ДокументОбъект, ДокументОбъект.РаспределениеРезультатовУдержаний, ПроверяемыеПоля, Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеПредставленияРаспределенияРезультатовНачисленийУдержаний(ДокументОбъект, РаспределениеРезультатов, ПроверяемыеПоля, РаспределениеНачислений)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РаспределениеРезультатов", РаспределениеРезультатов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаспределениеРезультатов.НомерСтроки,
	|	РаспределениеРезультатов.ИдентификаторСтроки,
	|	&ПроверяемыеПоля КАК ПроверяемыеПоля,
	|	РаспределениеРезультатов.Результат
	|ПОМЕСТИТЬ ВТРаспределениеРезультатов
	|ИЗ
	|	&РаспределениеРезультатов КАК РаспределениеРезультатов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаспределениеРезультатов.ИдентификаторСтроки,
	|	КОЛИЧЕСТВО(РаспределениеРезультатов.НомерСтроки) КАК КоличествоСтрок,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА &ПроверкаНаличияПустыхПолей
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ЕстьОшибкиЗаполнения
	|ПОМЕСТИТЬ ВТСгруппированныеДанныеПоИдентификаторам
	|ИЗ
	|	ВТРаспределениеРезультатов КАК РаспределениеРезультатов
	|
	|СГРУППИРОВАТЬ ПО
	|	РаспределениеРезультатов.ИдентификаторСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаспределениеРезультатов.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	РаспределениеРезультатов.НомерСтроки КАК НомерСтрокиРаспределения,
	|	СгруппированныеДанныеПоИдентификаторам.КоличествоСтрок КАК КоличествоЭлементовПредставления,
	|	СгруппированныеДанныеПоИдентификаторам.ЕстьОшибкиЗаполнения КАК ЕстьОшибкиЗаполнения,
	|	РаспределениеРезультатов.Результат КАК Результат
	|ИЗ
	|	ВТРаспределениеРезультатов КАК РаспределениеРезультатов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСгруппированныеДанныеПоИдентификаторам КАК СгруппированныеДанныеПоИдентификаторам
	|		ПО РаспределениеРезультатов.ИдентификаторСтроки = СгруппированныеДанныеПоИдентификаторам.ИдентификаторСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторСтроки,
	|	НомерСтрокиРаспределения";
	
	ПроверяемыеПоляТаблицы = "";
	ПроверкаНаличияПустыхПолей = "";
	
	Для Каждого КлючЗначение Из ПроверяемыеПоля Цикл
		
		Запрос.УстановитьПараметр(КлючЗначение.Ключ + "ПустаяСсылка", КлючЗначение.Значение);
		
		ПроверяемыеПоляТаблицы = ПроверяемыеПоляТаблицы + "
								|	РаспределениеРезультатов." + КлючЗначение.Ключ + ",";
								
		ПроверкаНаличияПустыхПолей = ПроверкаНаличияПустыхПолей + " ИЛИ РаспределениеРезультатов." + КлючЗначение.Ключ + " = &" + КлючЗначение.Ключ + "ПустаяСсылка";
	
	КонецЦикла;
	
	ПроверкаНаличияПустыхПолей = Сред(ПроверкаНаличияПустыхПолей, 6);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПроверяемыеПоля КАК ПроверяемыеПоля,", ПроверяемыеПоляТаблицы);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПроверкаНаличияПустыхПолей", ПроверкаНаличияПустыхПолей); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ИдентификаторСтроки") Цикл
		
		НомерЭлементаПредставления = 0;
		Пока Выборка.Следующий() Цикл
			
			НомерЭлементаПредставления = НомерЭлементаПредставления + 1;
			
			СтрокаПредставленияРаспределения = ДокументОбъект.ПредставлениеРаспределенияРезультатовРасчета.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПредставленияРаспределения, Выборка);
			
			СтрокаПредставленияРаспределения.ПредставлениеРезультата = Формат(Выборка.Результат, "ЧДЦ=2; ЧРГ=; ЧН=' '");
			СтрокаПредставленияРаспределения.РаспределениеНачислений = РаспределениеНачислений;
			СтрокаПредставленияРаспределения.НомерЭлементаПредставления = НомерЭлементаПредставления;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета)
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		РасчетЗарплатыРасширенный.ЗаполнитьУдержания(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплаты.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеПоДоговорамПодряда(ДанныеДляПроведения, РеквизитыДляПроведения);
		
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьПогашениеЗадолженностиПоУдержаниям(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.МесяцНачисления);
		
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеПоДоговорам.Ссылка,
	|	НачислениеПоДоговорам.Дата,
	|	НачислениеПоДоговорам.МесяцНачисления,
	|	НачислениеПоДоговорам.Организация,
	|	НачислениеПоДоговорам.ПорядокВыплаты
	|ИЗ
	|	Документ.НачислениеПоДоговорам КАК НачислениеПоДоговорам
	|ГДЕ
	|	НачислениеПоДоговорам.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, Дата, МесяцНачисления, Организация, ПорядокВыплаты");
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

#КонецОбласти

#КонецЕсли