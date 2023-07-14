#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
		ИначеЕсли ДанныеЗаполнения.Свойство("Сотрудник") И ЗначениеЗаполнено(ДанныеЗаполнения.Сотрудник) Тогда
			ДанныеЗаполнения = ДанныеЗаполнения.Сотрудник;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ДатаСобытия);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
	
	// Не проверяем, работает ли человек, при выплате пособия стороннему физлицу
	Если Не ПособиеСтороннемуФизлицу() Тогда
		ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудниковОрганизаций.Организация 		= Организация;
		ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода		= Дата;
		ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	= Дата;
		
		КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо),
			ПараметрыПолученияСотрудниковОрганизаций,
			Отказ,
			Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "ФизическоеЛицо", "Объект")
		);
	КонецЕсли;
			
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	Если ПорядокВыплаты <> Перечисления.ХарактерВыплатыЗарплаты.Межрасчет Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	ПособиеСтороннемуФизлицу = ПособиеСтороннемуФизлицу();
	
	Если Не ПособиеСтороннемуФизлицу Тогда
		
		// Заполним описание данных для проведения в учете начисленной зарплаты.
		ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
		ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
		ДанныеДляПроведенияУчетЗарплаты.Организация 			= Организация;
		ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= ПериодРегистрации;
		ДанныеДляПроведенияУчетЗарплаты.ПорядокВыплаты 			= ПорядокВыплаты;
		
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисления(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.НачисленияДокумента, Неопределено);
		
		// - Регистрация начислений и удержаний в бухучете.
		ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьНачисленияУдержания(ДанныеДляПроведенияУчетЗарплаты, Отказ,
			ДанныеДляПроведения.НачисленияДокумента, Неопределено, Неопределено);
		
	Иначе
		
		ВидыДоходаИсполнительногоПроизводства = УчетНачисленнойЗарплаты.ВидыДоходовИсполнительногоПроизводстваНачислений();
		Если ДанныеДляПроведения.НачисленияДокумента.Колонки.Найти("ВидДоходаИсполнительногоПроизводства") = Неопределено Тогда
			ДанныеДляПроведения.НачисленияДокумента.Колонки.Добавить("ВидДоходаИсполнительногоПроизводства", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыДоходовИсполнительногоПроизводства"));
		КонецЕсли;
		Для каждого СтрокаТЗ Из ДанныеДляПроведения.НачисленияДокумента Цикл
			СтрокаТЗ.ВидДоходаИсполнительногоПроизводства = ВидыДоходаИсполнительногоПроизводства[СтрокаТЗ.Начисление];
		КонецЦикла;
		
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения.НачисленияДокумента);
	
		// - Регистрация начислений и удержаний.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоКонтрагентамАкционерам(
					Движения, Отказ, Организация, ПериодРегистрации,
					ДанныеДляПроведения.НачисленияДокумента,
					Неопределено,
					Неопределено,
					Истина);
			
	КонецЕсли;

	Если Не ПособиеСтороннемуФизлицу Тогда
		УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, , , Ссылка);
		
		Если ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка Тогда
			Начисление = Перечисления.ВидыОсобыхНачисленийИУдержаний.ПособиеПриРожденииРебенка
		ИначеЕсли ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности Тогда
			Начисление = Перечисления.ВидыОсобыхНачисленийИУдержаний.ПособиеПриПостановкеНаУчетВРанниеСрокиБеременности
		ИначеЕсли ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью Тогда
			Начисление = Перечисления.ВидыОсобыхНачисленийИУдержаний.ПособиеНаПогребениеСотруднику
		Иначе
			Начисление = Перечисления.ВидыОсобыхНачисленийИУдержаний.ПустаяСсылка()
		КонецЕсли;
		Для Каждого СтрокаНабора Из Движения.СведенияОДоходахСтраховыеВзносы Цикл
			Если Не ЗначениеЗаполнено(СтрокаНабора.ФизическоеЛицо) Тогда
				СтрокаНабора.ФизическоеЛицо = ФизическоеЛицо
			КонецЕсли;
			СтрокаНабора.Начисление = Начисление
		КонецЦикла;
	
	КонецЕсли;
	
	УчетПособийСоциальногоСтрахования.СформироватьПособия(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения.ПособияДокумента, Неопределено);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подготавливает структуру таблиц для проведения.
//
Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура;
	
	СотрудникПолучающийПособие = СотрудникПолучающийПособие();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	СоздатьВТДанныеДокумента(Запрос, СотрудникПолучающийПособие);
	
	СоздатьВТНачисления(Запрос, СотрудникПолучающийПособие);				
	
	ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВДПоЕжемесячнойДоле(Организация, ПериодРегистрации, Запрос.МенеджерВременныхТаблиц);
	
	ДанныеДляПроведения.Вставить("НачисленияДокумента", 	НачисленияДокумента(Запрос));
	ДанныеДляПроведения.Вставить("ПособияДокумента", 		ПособияДокумента(Запрос));
	ДанныеДляПроведения.Вставить("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции 

Процедура СоздатьВТДанныеДокумента(Запрос, СотрудникПолучающийПособие)
	
	Запрос.УстановитьПараметр("Сотрудник", 		СотрудникПолучающийПособие.Сотрудник);
	Запрос.УстановитьПараметр("Подразделение", 	СотрудникПолучающийПособие.Подразделение);
	Запрос.УстановитьПараметр("ТерриторияВыполненияРаботВОрганизации", СотрудникПолучающийПособие.ТерриторияВыполненияРаботВОрганизации);
	
	Если ПолучитьФункциональнуюОпцию("РаботаВХозрасчетнойОрганизации") Тогда
		ОписаниеСтатейРасходов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
		Если ПособиеСтороннемуФизлицу() Тогда
			СтатьяРасходов = ОписаниеСтатейРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами];
		Иначе
			СтатьяРасходов = ОписаниеСтатейРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.ОплатаТруда];
		КонецЕсли;
	Иначе
		СтатьяРасходов = ОтражениеЗарплатыВБухучетеРасширенный.СтатьяРасходовДляПособияНаПогребение(ПериодРегистрации);
	КонецЕсли;
	Запрос.УстановитьПараметр("СтатьяРасходов", СтатьяРасходов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Сотрудник КАК Сотрудник,
	|	ЕдиновременноеПособие.ФизическоеЛицо КАК ФизическоеЛицо,
	|	&Подразделение КАК Подразделение,
	|	&ТерриторияВыполненияРаботВОрганизации КАК ТерриторияВыполненияРаботВОрганизации,
	|	ЗНАЧЕНИЕ(Справочник.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС) КАК Начисление,
	|	ВЫБОР
	|		КОГДА ЕдиновременноеПособие.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеПриРожденииРебенка)
	|		КОГДА ЕдиновременноеПособие.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеПриПостановкеНаУчетВРанниеСрокиБеременности)
	|		КОГДА ЕдиновременноеПособие.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью)
	|			ТОГДА ВЫБОР
	|					КОГДА ЕдиновременноеПособие.ПособиеНаПогребениеСотруднику
	|						ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеНаПогребениеСотруднику)
	|					ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеНаПогребение)
	|				КОНЕЦ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПустаяСсылка)
	|	КОНЕЦ КАК НачислениеДляРасчетногоЛистка,
	|	ЕдиновременноеПособие.ВидПособия КАК ВидПособияСоциальногоСтрахования,
	|	ЕдиновременноеПособие.Начислено КАК СуммаДохода,
	|	0 КАК СуммаВычетаВзносы,
	|	ЕдиновременноеПособие.ДатаСобытия КАК ДатаНачалаСобытия,
	|	ЕдиновременноеПособие.ДатаСобытия КАК ДатаНачала,
	|	ЕдиновременноеПособие.ДатаСобытия КАК ДатаОкончания,
	|	ЕдиновременноеПособие.СтатьяФинансирования,
	|	&СтатьяРасходов КАК СтатьяРасходов,
	|	ЛОЖЬ КАК Сторно,
	|	ЗНАЧЕНИЕ(Документ.ЕдиновременноеПособиеЗаСчетФСС.ПустаяСсылка) КАК СторнируемыйДокумент
	|ПОМЕСТИТЬ ВТНачисленияДокумента
	|ИЗ
	|	Документ.ЕдиновременноеПособиеЗаСчетФСС КАК ЕдиновременноеПособие
	|ГДЕ
	|	ЕдиновременноеПособие.Ссылка = &Ссылка";
	
	Если ЗначениеЗаполнено(ИсправленныйДокумент) Тогда
		
		Запрос.УстановитьПараметр("ИсправленныйДокумент", ИсправленныйДокумент);
		
		Запрос.Текст = Запрос.Текст + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
		
		Запрос.Текст = Запрос.Текст + 
		"ВЫБРАТЬ
		|	&Сотрудник КАК Сотрудник,
		|	ЕдиновременноеПособие.ФизическоеЛицо КАК ФизическоеЛицо,
		|	&Подразделение КАК Подразделение,
		|	&ТерриторияВыполненияРаботВОрганизации КАК ТерриторияВыполненияРаботВОрганизации,
		|	ЗНАЧЕНИЕ(Справочник.ВидыДоходовПоСтраховымВзносам.ПособияЗаСчетФСС) КАК Начисление,
		|	ВЫБОР
		|		КОГДА ЕдиновременноеПособие.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеПриРожденииРебенка)
		|		КОГДА ЕдиновременноеПособие.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеПриПостановкеНаУчетВРанниеСрокиБеременности)
		|		КОГДА ЕдиновременноеПособие.ВидПособия = ЗНАЧЕНИЕ(Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью)
		|			ТОГДА ВЫБОР
		|					КОГДА ЕдиновременноеПособие.ПособиеНаПогребениеСотруднику
		|						ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеНаПогребениеСотруднику)
		|					ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеНаПогребение)
		|				КОНЕЦ
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПустаяСсылка)
		|	КОНЕЦ КАК НачислениеДляРасчетногоЛистка,
		|	ЕдиновременноеПособие.ВидПособия КАК ВидПособияСоциальногоСтрахования,
		|	ЕдиновременноеПособие.Начислено * -1 КАК СуммаДохода,
		|	0 КАК СуммаВычетаВзносы,
		|	ЕдиновременноеПособие.ДатаСобытия КАК ДатаНачалаСобытия,
		|	ЕдиновременноеПособие.ДатаСобытия КАК ДатаНачала,
		|	ЕдиновременноеПособие.ДатаСобытия КАК ДатаОкончания,
		|	ЕдиновременноеПособие.СтатьяФинансирования КАК СтатьяФинансирования,
		|	&СтатьяРасходов КАК СтатьяРасходов,
		|	ИСТИНА КАК Сторно,
		|	ЕдиновременноеПособие.Ссылка КАК СторнируемыйДокумент
		|ИЗ
		|	Документ.ЕдиновременноеПособиеЗаСчетФСС КАК ЕдиновременноеПособие
		|ГДЕ
		|	ЕдиновременноеПособие.Ссылка = &ИсправленныйДокумент
		|	И ЕдиновременноеПособие.Проведен";	
		
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СоздатьВТНачисления(Запрос, СотрудникПолучающийПособие)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Начисления.Сотрудник КАК Сотрудник,
	|	Начисления.ДатаНачала КАК ДатаНачала,
	|	Начисления.Начисление КАК Начисление,
	|	Начисления.НачислениеДляРасчетногоЛистка КАК НачислениеДляРасчетногоЛистка,
	|	Начисления.Подразделение КАК ПодразделениеОрганизации,
	|	Начисления.Подразделение КАК Подразделение,
	|	Начисления.СуммаДохода КАК СуммаДохода,
	|	Начисления.СуммаВычетаВзносы КАК СуммаВычетаВзносы,
	|	Начисления.ДатаНачала КАК ДатаОкончания,
	|	Начисления.Сторно КАК Сторно,
	|	Начисления.СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Начисления.ВидПособияСоциальногоСтрахования КАК ВидПособияСоциальногоСтрахования,
	|	Начисления.ДатаНачалаСобытия КАК ДатаНачалаСобытия,
	|	ЗНАЧЕНИЕ(Справочник.УсловияТруда.ПустаяСсылка) КАК УсловияТруда,
	|	Начисления.СтатьяРасходов КАК СтатьяРасходов,
	|	Начисления.ТерриторияВыполненияРаботВОрганизации КАК ТерриторияВыполненияРаботВОрганизации
	|ПОМЕСТИТЬ ВТНачисления
	|ИЗ
	|	ВТНачисленияДокумента КАК Начисления";
	Запрос.Выполнить();
	
	Запрос.Текст =
	"УНИЧТОЖИТЬ ВТНачисленияДокумента";
	Запрос.Выполнить();
	
КонецПроцедуры

Функция НачисленияДокумента(Запрос)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Начисления.Сотрудник КАК Сотрудник,
	|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Начисления.Подразделение КАК Подразделение,
	|	Начисления.НачислениеДляРасчетногоЛистка КАК Начисление,
	|	СУММА(Начисления.СуммаДохода) КАК Сумма,
	|	0 КАК ОтработаноДней,
	|	0 КАК ОтработаноЧасов,
	|	0 КАК ОплаченоДней,
	|	0 КАК ОплаченоЧасов,
	|	Начисления.СтатьяРасходов КАК СтатьяРасходов,
	|	ВЫБОР
	|		КОГДА НачисленияСДаннымиЕНВД.ДоляЕНВД ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		КОГДА НачисленияСДаннымиЕНВД.ДоляЕНВД = 0
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОблагаетсяЕНВД,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования
	|ИЗ
	|	ВТНачисления КАК Начисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияСДаннымиЕНВД КАК НачисленияСДаннымиЕНВД
	|		ПО Начисления.Сотрудник = НачисленияСДаннымиЕНВД.Сотрудник
	|			И Начисления.Подразделение = НачисленияСДаннымиЕНВД.Подразделение
	|			И Начисления.ДатаНачала = НачисленияСДаннымиЕНВД.ДатаНачала
	|ГДЕ
	|	Начисления.НачислениеДляРасчетногоЛистка <> ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Начисления.Сотрудник,
	|	Начисления.ФизическоеЛицо,
	|	Начисления.Подразделение,
	|	Начисления.НачислениеДляРасчетногоЛистка,
	|	Начисления.СтатьяРасходов,
	|	ВЫБОР
	|		КОГДА НачисленияСДаннымиЕНВД.ДоляЕНВД ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		КОГДА НачисленияСДаннымиЕНВД.ДоляЕНВД = 0
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ";
	
	ТаблицаНачислений = Запрос.Выполнить().Выгрузить();
	Если ТаблицаНачислений.Количество() > 0 И ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный") Тогда
		Если ЗначениеЗаполнено(СтатьяФинансирования) Тогда
			ТаблицаНачислений[0].СтатьяФинансирования = СтатьяФинансирования;
		Иначе
			Если ЗначениеЗаполнено(ТаблицаНачислений[0].Сотрудник) Тогда
				Бухучет = ОтражениеЗарплатыВБухучетеРасширенный.БухучетСотрудникаПоУмолчанию(ТаблицаНачислений[0].Сотрудник, ДатаСобытия);
			Иначе
				Бухучет = ОтражениеЗарплатыВБухучетеРасширенный.БухучетОрганизации(Организация, ДатаСобытия);
			КонецЕсли;
			ТаблицаНачислений[0].СтатьяФинансирования = Бухучет.СтатьяФинансирования;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаНачислений;
	
КонецФункции 

Функция ПособияДокумента(Запрос)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Начисления.Сотрудник,
	|	Начисления.ФизическоеЛицо,
	|	Начисления.Подразделение,
	|	Начисления.ВидПособияСоциальногоСтрахования,
	|	Начисления.СуммаДохода КАК СуммаВсего,
	|	0 КАК ОплаченныеДни,
	|	ВЫБОР
	|		КОГДА Начисления.Сторно
	|			ТОГДА -1
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК СтраховыеСлучаи,
	|	Начисления.ДатаНачалаСобытия
	|ИЗ
	|	ВТНачисления КАК Начисления";
	
	Возврат Запрос.Выполнить().Выгрузить();	

КонецФункции 

Функция СотрудникПолучающийПособие()

	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 					= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.ОтбиратьПоГоловнойОрганизации 	= Ложь;
	ПараметрыПолученияСотрудниковОрганизаций.СписокФизическихЛиц			= ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода					= Дата;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода				= Дата;
	ПараметрыПолученияСотрудниковОрганизаций.КадровыеДанные					= "Подразделение,ТерриторияВыполненияРаботВОрганизации";
		
	ОсновныеСотрудники = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудниковОрганизаций);
	
	Если ОсновныеСотрудники.Количество() = 0 Тогда
		СтрокаСотрудника = ОсновныеСотрудники.Добавить();
	КонецЕсли;
	
	Возврат ОсновныеСотрудники[0];
	
КонецФункции

Функция ПособиеСтороннемуФизлицу()
	Возврат ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью И Не ПособиеНаПогребениеСотруднику;
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли