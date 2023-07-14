#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("СотрудникСсылка", СотрудникСсылка);
	
	КоличествоПоказателей = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьМаксимальноеКоличествоЗапрашиваемыхПоказателей();
	ДополнитьФормуПоКоличествуПоказателей();
	
	Если ЗначениеЗаполнено(СотрудникСсылка) Тогда
		СформироватьИнформациюОНачислениях();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
		НастроитьВидИсторииНачислений();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыИсторияНачислений

&НаКлиенте
Процедура ИсторияНачисленийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		
		ТекущиеДанные = ИсторияНачислений.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные <> Неопределено Тогда
			
			Если ЗначениеЗаполнено(ТекущиеДанные.Регистратор) Тогда
				ПоказатьЗначение(, ТекущиеДанные.Регистратор);
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	СформироватьИнформациюОНачислениях();
	НастроитьВидИсторииНачислений();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДополнитьФормуПоКоличествуПоказателей()
	
	Если КоличествоПоказателей > 6 Тогда
		
		МассивДобавляемыхРеквизитов = Новый Массив;
		Для НомерПоказателя = 7 По КоличествоПоказателей Цикл
			
			НовыйРеквизитПоказатель = Новый РеквизитФормы("Показатель" + НомерПоказателя, Новый ОписаниеТипов("СправочникСсылка.ПоказателиРасчетаЗарплаты"), "ИсторияНачислений");
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитПоказатель);
			
			НовыйРеквизитЗначение = Новый РеквизитФормы("Значение" + НомерПоказателя, Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15, 4)), "ИсторияНачислений");
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитЗначение);
			
			НовыйРеквизитПредставлениеПоказателя = Новый РеквизитФормы("ПредставлениеПоказателя" + НомерПоказателя, Новый ОписаниеТипов("Строка"), "ИсторияНачислений");
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитПредставлениеПоказателя);
			
			НовыйРеквизитТочностьПоказателя = Новый РеквизитФормы("ТочностьПоказателя" + НомерПоказателя, Новый ОписаниеТипов("Строка"), "ИсторияНачислений");
			МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизитТочностьПоказателя);
			
		КонецЦикла;
		
		ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
		
		Для НомерПоказателя = 7 По КоличествоПоказателей Цикл
			
			ЭлементПоказатель = Элементы.Добавить("ИсторияНачисленийПоказатель" + НомерПоказателя, Тип("ПолеФормы"), Элементы.ИсторияНачисленийПоказателиГруппа);
			ЭлементПоказатель.Вид = ВидПоляФормы.ПолеВвода;
			ЭлементПоказатель.ТолькоПросмотр = Истина;
			ЭлементПоказатель.ОтображатьВШапке = Ложь;
			ЭлементПоказатель.Ширина = 20;
			ЭлементПоказатель.ПутьКДанным = "ИсторияНачислений.Показатель" + НомерПоказателя;
			
			ЭлементЗначение = Элементы.Добавить("ИсторияНачисленийЗначение" + НомерПоказателя, Тип("ПолеФормы"), Элементы.ИсторияНачисленийПоказателиГруппа);
			ЭлементЗначение.Вид = ВидПоляФормы.ПолеВвода;
			ЭлементЗначение.ТолькоПросмотр = Истина;
			ЭлементЗначение.ОтображатьВШапке = Ложь;
			ЭлементЗначение.Ширина = 10;
			ЭлементЗначение.ПутьКДанным = "ИсторияНачислений.Значение" + НомерПоказателя;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для каждого ЭлементУсловногоОформления Из УсловноеОформление.Элементы Цикл
		
		Если ЭлементУсловногоОформления.Представление = "ВидимостьПоказателей" Тогда
			
			Для НомерПоказателя = 7 По КоличествоПоказателей Цикл
				
				НовоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
				НовоеПоле.Поле = Новый ПолеКомпоновкиДанных("ИсторияНачисленийПоказатель" + НомерПоказателя);
				
				НовоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
				НовоеПоле.Поле = Новый ПолеКомпоновкиДанных("ИсторияНачисленийЗначение" + НомерПоказателя);
				
			КонецЦикла;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для НомерПоказателя = 1 По КоличествоПоказателей Цикл
		
		// Представление показателя
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсторияНачислений.Показатель" + НомерПоказателя);
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсторияНачислений.ПредставлениеПоказателя" + НомерПоказателя);
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ИсторияНачислений.ПредставлениеПоказателя" + НомерПоказателя));
		
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ИсторияНачисленийПоказатель" + НомерПоказателя);
		
		// Точность значения
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсторияНачислений.Показатель" + НомерПоказателя);
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Формат", Новый ПолеКомпоновкиДанных("ИсторияНачислений.ТочностьПоказателя" + НомерПоказателя));
		
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ИсторияНачисленийЗначение" + НомерПоказателя);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьИнформациюОНачислениях()
	
	ИсторияНачислений.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудник", СотрудникСсылка);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаНачала,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаОкончания,
		|	&Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТСотрудникиПериоды";
	
	Запрос.Выполнить();
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
		"ВТСотрудникиПериоды", "Сотрудник");
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистра();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения,
		"ВТЗначенияПериодическихПоказателей");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ПлановыйФОТ",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПлановыйФОТ.ПериодЗаписи,
		|	ПлановыйФОТ.Сотрудник,
		|	ПлановыйФОТ.РегистраторСобытия КАК Регистратор
		|ПОМЕСТИТЬ ВТВсеПериодыПредварительно
		|ИЗ
		|	ВТПлановыйФОТ КАК ПлановыйФОТ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПлановыеНачисления.Период,
		|	ПлановыеНачисления.Сотрудник,
		|	ПлановыеНачисления.Регистратор
		|ИЗ
		|	ВТПлановыеНачисления КАК ПлановыеНачисления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Период,
		|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Сотрудник,
		|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Регистратор
		|ИЗ
		|	ВТЗначенияПериодическихПоказателей КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(ВсеПериодыПредварительно.ПериодЗаписи, ДЕНЬ) КАК ПериодДень,
		|	ВсеПериодыПредварительно.ПериодЗаписи КАК Период,
		|	ВсеПериодыПредварительно.Сотрудник,
		|	МАКСИМУМ(ВсеПериодыПредварительно.Регистратор) КАК Регистратор
		|ПОМЕСТИТЬ ВТВсеПериодыИзмененияОплатыТрудаПоДням
		|ИЗ
		|	ВТВсеПериодыПредварительно КАК ВсеПериодыПредварительно
		|
		|СГРУППИРОВАТЬ ПО
		|	ВсеПериодыПредварительно.ПериодЗаписи,
		|	ВсеПериодыПредварительно.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВсеПериодыПредварительно.ПериодДень,
		|	ВсеПериодыПредварительно.Сотрудник,
		|	ВсеПериодыПредварительно.Регистратор,
		|	МАКСИМУМ(ВсеПериодыПредварительно.Период) КАК Период
		|ПОМЕСТИТЬ ВТВсеПериодыИзмененияОплатыТруда
		|ИЗ
		|	ВТВсеПериодыИзмененияОплатыТрудаПоДням КАК ВсеПериодыПредварительно
		|
		|СГРУППИРОВАТЬ ПО
		|	ВсеПериодыПредварительно.ПериодДень,
		|	ВсеПериодыПредварительно.Сотрудник,
		|	ВсеПериодыПредварительно.Регистратор";
	
	Запрос.Выполнить();
	
	ОписательВТ = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТВсеПериодыИзмененияОплатыТруда");
	
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(
		ОписательВТ, Истина, "Организация,Подразделение,Должность,ДолжностьПоШтатномуРасписанию");
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
		"ВТВсеПериодыИзмененияОплатыТруда", "Сотрудник");
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения,
		"ВТЗначенияПериодическихПоказателейСрезПоследних");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПрименениеДополнительныхПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения,
		"ВТПрименениеДополнительныхПериодическихПоказателейСрезПоследних");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыйФОТ",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		ПараметрыПостроения);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыеДанныеСотрудников.Период КАК Период,
		|	КадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
		|	КадровыеДанныеСотрудников.Организация,
		|	ВЫРАЗИТЬ(ПлановыеНачисления.Начисление КАК ПланВидовРасчета.Начисления) КАК Начисление,
		|	ЕСТЬNULL(ПлановыйФОТ.ВкладВФОТ, ПлановыеНачисления.Размер) КАК ВкладВФОТ,
		|	ЕСТЬNULL(ПлановыйФОТ.ДокументОснование, ЕСТЬNULL(ПлановыеНачисления.ДокументОснование, ЗначенияПериодическихПоказателей.ДокументОснование)) КАК ДокументОснование,
		|	ВЫРАЗИТЬ(ЗначенияПериодическихПоказателей.Показатель КАК Справочник.ПоказателиРасчетаЗарплаты) КАК Показатель,
		|	ЗначенияПериодическихПоказателей.Значение,
		|	ПериодыИзмененияОплатыТруда.Регистратор КАК Регистратор,
		|	НачисленияПоказатели.НомерСтроки КАК ПорядокПоказателей
		|ПОМЕСТИТЬ ВТПериодыСНачислениями
		|ИЗ
		|	ВТВсеПериодыИзмененияОплатыТруда КАК ПериодыИзмененияОплатыТруда
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
		|				ЛЕВОЕ СОЕДИНЕНИЕ ВТПлановыйФОТСрезПоследних КАК ПлановыйФОТ
		|				ПО ПлановыеНачисления.Период = ПлановыйФОТ.Период
		|					И ПлановыеНачисления.Сотрудник = ПлановыйФОТ.Сотрудник
		|					И ПлановыеНачисления.Начисление = ПлановыйФОТ.Начисление
		|					И ПлановыеНачисления.ДокументОснование = ПлановыйФОТ.ДокументОснование
		|					И (ПлановыеНачисления.Используется)
		|				ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
		|				ПО ПлановыеНачисления.Начисление = НачисленияПоказатели.Ссылка
		|					И (НачисленияПоказатели.ЗапрашиватьПриВводе)
		|			ПО КадровыеДанныеСотрудников.Период = ПлановыеНачисления.Период
		|				И КадровыеДанныеСотрудников.Сотрудник = ПлановыеНачисления.Сотрудник
		|				И (ПлановыеНачисления.Используется)
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТЗначенияПериодическихПоказателейСрезПоследних КАК ЗначенияПериодическихПоказателей
		|			ПО КадровыеДанныеСотрудников.Период = ЗначенияПериодическихПоказателей.Период
		|				И КадровыеДанныеСотрудников.Сотрудник = ЗначенияПериодическихПоказателей.Сотрудник
		|				И КадровыеДанныеСотрудников.Организация = ЗначенияПериодическихПоказателей.Организация
		|				И (НачисленияПоказатели.Показатель = ЗначенияПериодическихПоказателей.Показатель)
		|				И (ПлановыеНачисления.ДокументОснование = ЗначенияПериодическихПоказателей.ДокументОснование)
		|		ПО ПериодыИзмененияОплатыТруда.Период = КадровыеДанныеСотрудников.Период
		|			И ПериодыИзмененияОплатыТруда.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗначенияПериодическихПоказателей.Период,
		|	ЗначенияПериодическихПоказателей.ПериодЗаписи,
		|	ЗначенияПериодическихПоказателей.Организация,
		|	ЗначенияПериодическихПоказателей.Сотрудник,
		|	ВЫРАЗИТЬ(ЗначенияПериодическихПоказателей.Показатель КАК Справочник.ПоказателиРасчетаЗарплаты) КАК Показатель,
		|	ЗначенияПериодическихПоказателей.Значение,
		|	ЗначенияПериодическихПоказателей.Регистратор КАК Регистратор
		|ПОМЕСТИТЬ ВТДополнительныеПоказатели
		|ИЗ
		|	ВТЗначенияПериодическихПоказателейСрезПоследних КАК ЗначенияПериодическихПоказателей
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыСНачислениями КАК ПериодыСНачислениями
		|		ПО ЗначенияПериодическихПоказателей.Период = ПериодыСНачислениями.Период
		|			И ЗначенияПериодическихПоказателей.Организация = ПериодыСНачислениями.Организация
		|			И ЗначенияПериодическихПоказателей.Сотрудник = ПериодыСНачислениями.Сотрудник
		|			И ЗначенияПериодическихПоказателей.Показатель = ПериодыСНачислениями.Показатель
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПрименениеДополнительныхПериодическихПоказателейСрезПоследних КАК ПрименениеДополнительныхПериодическихПоказателей
		|		ПО ЗначенияПериодическихПоказателей.Период = ПрименениеДополнительныхПериодическихПоказателей.Период
		|			И ЗначенияПериодическихПоказателей.Сотрудник = ПрименениеДополнительныхПериодическихПоказателей.Сотрудник
		|			И ЗначенияПериодическихПоказателей.Организация = ПрименениеДополнительныхПериодическихПоказателей.Организация
		|			И ЗначенияПериодическихПоказателей.Показатель = ПрименениеДополнительныхПериодическихПоказателей.Показатель
		|ГДЕ
		|	ПериодыСНачислениями.Сотрудник ЕСТЬ NULL 
		|	И ЕСТЬNULL(ПрименениеДополнительныхПериодическихПоказателей.Применение, ЛОЖЬ)
		|	И ЗначенияПериодическихПоказателей.Значение <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыСНачислениями.Период КАК Период,
		|	ПериодыСНачислениями.Сотрудник КАК Сотрудник,
		|	ПериодыСНачислениями.Организация,
		|	ПериодыСНачислениями.Начисление,
		|	ПериодыСНачислениями.ВкладВФОТ КАК ВкладВФОТ,
		|	ПериодыСНачислениями.Показатель,
		|	ПериодыСНачислениями.Значение,
		|	ПериодыСНачислениями.Начисление.РеквизитДопУпорядочивания КАК ПорядокНачислений,
		|	ПериодыСНачислениями.Регистратор КАК Регистратор,
		|	ПериодыСНачислениями.ПорядокПоказателей КАК ПорядокПоказателей,
		|	ПериодыСНачислениями.Начисление.КраткоеНаименование КАК НачислениеКраткоеНаименование,
		|	ПериодыСНачислениями.Показатель.КраткоеНаименование КАК ПоказательКраткоеНаименование,
		|	ПериодыСНачислениями.Показатель.Точность КАК ПоказательТочность,
		|	ПериодыСНачислениями.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	ВТПериодыСНачислениями КАК ПериодыСНачислениями
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДополнительныеПоказатели.Период,
		|	ДополнительныеПоказатели.Сотрудник,
		|	ДополнительныеПоказатели.Организация,
		|	NULL,
		|	NULL,
		|	ДополнительныеПоказатели.Показатель,
		|	ДополнительныеПоказатели.Значение,
		|	99999999,
		|	ВЫБОР
		|		КОГДА ДополнительныеПоказатели.Период = ДополнительныеПоказатели.ПериодЗаписи
		|			ТОГДА ДополнительныеПоказатели.Регистратор
		|		ИНАЧЕ ПериодыСНачислениями.Регистратор
		|	КОНЕЦ,
		|	ДополнительныеПоказатели.Показатель.РеквизитДопУпорядочивания + 1000000,
		|	NULL,
		|	ДополнительныеПоказатели.Показатель.КраткоеНаименование,
		|	ДополнительныеПоказатели.Показатель.Точность,
		|	NULL
		|ИЗ
		|	ВТДополнительныеПоказатели КАК ДополнительныеПоказатели
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыСНачислениями КАК ПериодыСНачислениями
		|		ПО ДополнительныеПоказатели.Период = ПериодыСНачислениями.Период
		|			И ДополнительныеПоказатели.Организация = ПериодыСНачислениями.Организация
		|			И ДополнительныеПоказатели.Сотрудник = ПериодыСНачислениями.Сотрудник
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	Период УБЫВ,
		|	ДокументОснование,
		|	ПорядокНачислений,
		|	ПорядокПоказателей
		|ИТОГИ
		|	СУММА(ВкладВФОТ),
		|	МАКСИМУМ(Регистратор)
		|ПО
		|	Сотрудник,
		|	Период";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			
			СтрокаСотрудника = ИсторияНачислений.ПолучитьЭлементы().Добавить();
			СтрокаСотрудника.Сотрудник = Выборка.Сотрудник;
			СтрокаСотрудника.Представление = СтрокаСотрудника.Сотрудник;
			СтрокаСотрудника.Уровень = 0;
			
			ВыборкаПоПериодам = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоПериодам.Следующий() Цикл
				
				СтрокаДокумента = СтрокаСотрудника.ПолучитьЭлементы().Добавить();
				СтрокаДокумента.Сотрудник = ВыборкаПоПериодам.Сотрудник;
				СтрокаДокумента.Период = ВыборкаПоПериодам.Период;
				СтрокаДокумента.Регистратор = ВыборкаПоПериодам.Регистратор;
				СтрокаДокумента.ФОТ = 0;
				СтрокаДокумента.Представление = Формат(СтрокаДокумента.Период, "ДЛФ=D");
				СтрокаДокумента.Уровень = 1;
				
				ТекущееНачисление = Неопределено;
				ТекущийДокументОснование = Неопределено;
				ВыборкаПоНачислениям = ВыборкаПоПериодам.Выбрать();
				Пока ВыборкаПоНачислениям.Следующий() Цикл
					
					Если ЗначениеЗаполнено(ВыборкаПоНачислениям.Начисление) Тогда
						
						Если ТекущееНачисление <> ВыборкаПоНачислениям.Начисление
							Или ТекущийДокументОснование <> ВыборкаПоНачислениям.ДокументОснование Тогда
							
							СтрокаДокумента.ФОТ = СтрокаДокумента.ФОТ + ВыборкаПоНачислениям.ВкладВФОТ;
							
							ТекущееНачисление = ВыборкаПоНачислениям.Начисление;
							ТекущийДокументОснование = ВыборкаПоНачислениям.ДокументОснование;
							
							СтрокаНачисления = СтрокаДокумента.ПолучитьЭлементы().Добавить();
							СтрокаНачисления.Сотрудник = ВыборкаПоНачислениям.Сотрудник;
							СтрокаНачисления.Период = ВыборкаПоНачислениям.Период;
							СтрокаНачисления.Регистратор = ВыборкаПоНачислениям.Регистратор;
							СтрокаНачисления.Начисление = ВыборкаПоНачислениям.Начисление;
							СтрокаНачисления.ФОТ = ВыборкаПоНачислениям.ВкладВФОТ;
							СтрокаНачисления.Представление = СтрокаНачисления.Начисление;
							СтрокаНачисления.Уровень = 2;
							
							НомерПоказателя = 1;
							
						КонецЕсли; 
						
						СтрокаНачисления["Показатель" + НомерПоказателя]= ВыборкаПоНачислениям.Показатель;
						СтрокаНачисления["ПредставлениеПоказателя" + НомерПоказателя]= ВыборкаПоНачислениям.ПоказательКраткоеНаименование;
						СтрокаНачисления["Значение" + НомерПоказателя] = ВыборкаПоНачислениям.Значение;
						СтрокаНачисления["ТочностьПоказателя" + НомерПоказателя] = "ЧДЦ=" + ВыборкаПоНачислениям.ПоказательТочность;
						
						НомерПоказателя = НомерПоказателя + 1;
						
					Иначе
						
						Если ЗначениеЗаполнено(ВыборкаПоНачислениям.Показатель) Тогда
							
							СтрокаНачисления = СтрокаДокумента.ПолучитьЭлементы().Добавить();
							СтрокаНачисления.Сотрудник = ВыборкаПоНачислениям.Сотрудник;
							СтрокаНачисления.Период = ВыборкаПоНачислениям.Период;
							СтрокаНачисления.Регистратор = ВыборкаПоНачислениям.Регистратор;
							СтрокаНачисления.Начисление = ВыборкаПоНачислениям.Начисление;
							СтрокаНачисления.ФОТ = ВыборкаПоНачислениям.ВкладВФОТ;
							СтрокаНачисления.Представление = НСтр("ru='Доп. тариф/коэфф.'");
							СтрокаНачисления.Показатель1 = ВыборкаПоНачислениям.Показатель;
							СтрокаНачисления.ПредставлениеПоказателя1 = ВыборкаПоНачислениям.ПоказательКраткоеНаименование;
							СтрокаНачисления.Значение1 = ВыборкаПоНачислениям.Значение;
							СтрокаНачисления.ТочностьПоказателя1 = "ЧДЦ=" + ВыборкаПоНачислениям.ПоказательТочность;
							СтрокаНачисления.Уровень = 2;
							
						КонецЕсли;
						
					КонецЕсли;
				
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьВидИсторииНачислений()
	
	Для каждого СтрокаСотрудника Из ИсторияНачислений.ПолучитьЭлементы() Цикл
		Элементы.ИсторияНачислений.Развернуть(СтрокаСотрудника.ПолучитьИдентификатор(), Ложь);
		Для каждого СтрокаРегистратора Из  СтрокаСотрудника.ПолучитьЭлементы() Цикл
			Элементы.ИсторияНачислений.Развернуть(СтрокаРегистратора.ПолучитьИдентификатор(), Истина);
			Прервать;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
