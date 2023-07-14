#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли; 
	
	// Запись набора в служебных целях.
	Если ДополнительныеСвойства.Свойство("ЭтоВторичныйНабор") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("МенеджерВременныхТаблиц") Тогда
		ДополнительныеСвойства.Вставить("НеОбновлятьДанныеФОТ");
		Возврат;
	КонецЕсли;
	
	СоздатьВТВТИзменениямГрафиков(ЭтотОбъект);
КонецПроцедуры	

Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли; 
	
	// Запись набора в служебных целях.
	Если ДополнительныеСвойства.Свойство("ЭтоВторичныйНабор") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("МенеджерВременныхТаблиц") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НеОбновлятьДанныеФОТ") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеФОТПриИзмененииДанныхГрафика(ДополнительныеСвойства.МенеджерВременныхТаблиц);	
	
	Если ЗначениеЗаполнено(Отбор.ГрафикРаботыСотрудников.Значение)
		И ТипЗнч(Отбор.ГрафикРаботыСотрудников.Значение) = Тип("СправочникСсылка.ГрафикиРаботыСотрудников") Тогда
		
		Если ЗначениеЗаполнено(Отбор.Год.Значение) Тогда
			ГодОбновляемыхДанных = Отбор.Год.Значение;
		Иначе
			ГодОбновляемыхДанных = Неопределено;
		КонецЕсли;	
		
		РежимРаботы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отбор.ГрафикРаботыСотрудников.Значение, "РежимРаботы");
		
		Если ЗначениеЗаполнено(РежимРаботы) Тогда
			УчетРабочегоВремениРасширенный.ОбновитьСреднемесячныеНормыПоРежимуРаботы(РежимРаботы, ГодОбновляемыхДанных);
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

Процедура СоздатьВТВТИзменениямГрафиков(НаборЗаписей)
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если НаборЗаписей.Отбор.ГрафикРаботыСотрудников.Использование
		И НаборЗаписей.Отбор.Год.Использование Тогда
		
		Запрос.УстановитьПараметр("ГрафикРаботыСотрудников", НаборЗаписей.Отбор.ГрафикРаботыСотрудников.Значение);
		Запрос.УстановитьПараметр("Год", НаборЗаписей.Отбор.Год.Значение);
		
	Иначе
		НаборЗаписей.ДополнительныеСвойства.Вставить("НеОбновлятьДанныеФОТ");
		
		Возврат;
	КонецЕсли;
		
	// Подготовка данных для перезаполнения планового ФОТ
	Запрос.УстановитьПараметр("ЗаписываемыйНабор", НаборЗаписей.Выгрузить());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СреднемесячныеНормыВремени.ГрафикРаботыСотрудников,
		|	СреднемесячныеНормыВремени.Год,
		|	СреднемесячныеНормыВремени.СреднемесячноеЧислоЧасов,
		|	СреднемесячныеНормыВремени.СреднемесячноеЧислоДней
		|ПОМЕСТИТЬ ВТСреднемесячныеНормыВремениЗаписываемыйНабор
		|ИЗ
		|	&ЗаписываемыйНабор КАК СреднемесячныеНормыВремени
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СреднемесячныеНормыВремени.ГрафикРаботыСотрудников,
		|	СреднемесячныеНормыВремени.Год,
		|	СреднемесячныеНормыВремени.СреднемесячноеЧислоЧасов,
		|	СреднемесячныеНормыВремени.СреднемесячноеЧислоДней
		|ПОМЕСТИТЬ ВТСреднемесячныеНормыВремениТекущийНабор
		|ИЗ
		|	РегистрСведений.СреднемесячныеНормыВремениГрафиковРаботыСотрудников КАК СреднемесячныеНормыВремени
		|ГДЕ
		|	СреднемесячныеНормыВремени.ГрафикРаботыСотрудников = &ГрафикРаботыСотрудников
		|	И СреднемесячныеНормыВремени.Год = &Год";
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЕСТЬNULL(ТекущийНабор.ГрафикРаботыСотрудников, ЗаписываемыйНабор.ГрафикРаботыСотрудников) КАК ГрафикРаботыСотрудников,
		|	ЕСТЬNULL(ТекущийНабор.Год, ЗаписываемыйНабор.Год) КАК Год,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ТекущийНабор.СреднемесячноеЧислоЧасов, 0) <> ЗаписываемыйНабор.СреднемесячноеЧислоЧасов
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ИзмененоЧислоЧасов,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ТекущийНабор.СреднемесячноеЧислоДней, 0) <> ЗаписываемыйНабор.СреднемесячноеЧислоДней
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ИзмененоЧислоДней
		|ПОМЕСТИТЬ ВТИзменениямГрафиков
		|ИЗ
		|	ВТСреднемесячныеНормыВремениТекущийНабор КАК ТекущийНабор
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТСреднемесячныеНормыВремениЗаписываемыйНабор КАК ЗаписываемыйНабор
		|		ПО ТекущийНабор.ГрафикРаботыСотрудников = ЗаписываемыйНабор.ГрафикРаботыСотрудников
		|			И ТекущийНабор.Год = ЗаписываемыйНабор.Год
		|ГДЕ
		|	НЕ ЗаписываемыйНабор.ГрафикРаботыСотрудников ЕСТЬ NULL 
		|";
		
	Запрос.Выполнить();	
	
КонецПроцедуры	

Процедура ОбновитьДанныеФОТПриИзмененииДанныхГрафика(МенеджерВременныхТаблиц)	
	НачисленияСЧасовойИлиДневнойСтавкой = РасчетЗарплатыРасширенный.НачисленияСЧасовойИлиДневнойТарифнойСтавкой();
	
	Если НачисленияСЧасовойИлиДневнойСтавкой.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	ТаблицыКУничтожению = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МИНИМУМ(ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 1, 1), ГОД, ИзменениямГрафиковПредварительно.Год - 1)) КАК ДатаНачала,
	|	МАКСИМУМ(КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 1, 1), ГОД, ИзменениямГрафиковПредварительно.Год - 1), ГОД)) КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТПериодыИзмененияГрафиков
	|ИЗ
	|	ВТИзменениямГрафиков КАК ИзменениямГрафиковПредварительно
	|ГДЕ
	|	(ИзменениямГрафиковПредварительно.ИзмененоЧислоДней
	|			ИЛИ ИзменениямГрафиковПредварительно.ИзмененоЧислоЧасов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ИзменениямГрафиковПредварительно.ГрафикРаботыСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПериодыИзмененияГрафиков.ГрафикРаботыСотрудников
	|ИЗ
	|	ВТИзменениямГрафиков КАК ПериодыИзмененияГрафиков
	|ГДЕ
	|	(ПериодыИзмененияГрафиков.ИзмененоЧислоДней
	|			ИЛИ ПериодыИзмененияГрафиков.ИзмененоЧислоЧасов)";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	СписокГрафиков = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.ГрафикРаботыСотрудников) = Тип("СправочникСсылка.ГрафикиРаботыСотрудников") Тогда
			СписокГрафиков.Добавить(Выборка.ГрафикРаботыСотрудников);
		КонецЕсли;	
	КонецЦикла;	
	
	Если СписокГрафиков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОписаниеФильтра = ЗарплатаКадрыПериодическиеРегистры.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТПериодыИзмененияГрафиков");
	ПараметрыПолученияГрафиков = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияДляСоздатьВТИмяРегистра();
	ПараметрыПолученияГрафиков.ВключатьЗаписиНаНачалоПериода = Истина;
	ПараметрыПолученияГрафиков.ФормироватьСПериодичностьДень = Ложь;
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПолученияГрафиков.Отборы, "ГрафикРаботы", "В", СписокГрафиков); 
	
	ЗарплатаКадрыПериодическиеРегистры.СоздатьВТИмяРегистра("ГрафикРаботыСотрудников", МенеджерВременныхТаблиц, Ложь, ОписаниеФильтра, ПараметрыПолученияГрафиков);  
	ТаблицыКУничтожению.Добавить("ВТГрафикРаботыСотрудников");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГрафикРаботыСотрудников.Сотрудник,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(ГрафикРаботыСотрудников.Период, ГОД)) КАК ДатаНачала,
	|	МАКСИМУМ(КОНЕЦПЕРИОДА(ГрафикРаботыСотрудников.Период, ГОД)) КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТСотрудникиПериодыПолученияПлановыхНачислений
	|ИЗ
	|	ВТГрафикРаботыСотрудников КАК ГрафикРаботыСотрудников
	|
	|СГРУППИРОВАТЬ ПО
	|	ГрафикРаботыСотрудников.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	СотрудникиПериодыПолученияПлановыхНачислений.Сотрудник
	|ИЗ
	|	ВТСотрудникиПериодыПолученияПлановыхНачислений КАК СотрудникиПериодыПолученияПлановыхНачислений";
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеФильтра = ЗарплатаКадрыПериодическиеРегистры.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериодыПолученияПлановыхНачислений", "Сотрудник");
	ПараметрыПолученияНачислений = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияДляСоздатьВТИмяРегистра();
	ПараметрыПолученияНачислений.ВключатьЗаписиНаНачалоПериода = Истина;
	ПараметрыПолученияНачислений.ФормироватьСПериодичностьДень = Ложь;
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПолученияНачислений.Отборы, "Начисление", "В", НачисленияСЧасовойИлиДневнойСтавкой);
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПолученияНачислений.Отборы, "Используется", "=", Истина);
	
	ЗарплатаКадрыПериодическиеРегистры.СоздатьВТИмяРегистра("ПлановыеНачисления", МенеджерВременныхТаблиц, Ложь, ОписаниеФильтра, ПараметрыПолученияНачислений);  
	ТаблицыКУничтожению.Добавить("ВТПлановыеНачисления");

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПлановыеНачисления.Сотрудник,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(ПлановыеНачисления.Период, ГОД)) КАК ДатаНачала,
	|	ЛОЖЬ КАК ИзменениеНачислений,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзмененияНачислений,
	|	ЛОЖЬ КАК ИзменениеЗначенийПоказателей,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзмененияПоказателей,
	|	ЛОЖЬ КАК ИзменениеГрафика,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзмененияГрафика,
	|	ЛОЖЬ КАК ИзменениеКоличестваСтавок,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзмененияКоличестваСтавок,
	|	ЛОЖЬ КАК ИзменениеДанныхСтажа,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзмененияДанныхСтажа,
	|	ИСТИНА КАК ИзменениеДанныхГрафика,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(ПлановыеНачисления.Период, ГОД)) КАК ДатаИзмененияДанныхГрафика,
	|	ЛОЖЬ КАК УдалениеДанных
	|ПОМЕСТИТЬ ВТПериодыОбновленияВторичныхДанных
	|ИЗ
	|	ВТПлановыеНачисления КАК ПлановыеНачисления
	|
	|СГРУППИРОВАТЬ ПО
	|	ПлановыеНачисления.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыОбновленияВторичныхДанных.Сотрудник
	|ИЗ
	|	ВТПериодыОбновленияВторичныхДанных КАК ПериодыОбновленияВторичныхДанных";
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;	
	КонецЕсли;	
	
	ЗарплатаКадры.УничтожитьВТ(Запрос.МенеджерВременныхТаблиц, ТаблицыКУничтожению);
	
	ПлановыеНачисленияСотрудников.СформироватьДвиженияВторичныхДанных(МенеджерВременныхТаблиц);
	
КонецПроцедуры	

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли