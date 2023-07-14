
#Область СлужебныеПроцедурыИФункции

Процедура ЗапретИзмененияИспользованияКадровогоУчетаПередЗаписью(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.Значение = Ложь Тогда
		ВызватьИсключение НСтр("ru = 'Нельзя отказаться от ведения кадрового учета в программе. Действие не выполнено'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьЗначениеРеквизитаОрганизацияСправочникаСотрудникиПриОднофирменномУчетеРасширеннаяОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ЗарплатаКадры.ЗаполнитьЗначениеРеквизитаОрганизацияПриОднофирменномУчете(Источник, "ГоловнаяОрганизация"); 
	
КонецПроцедуры

Процедура УстановитьИспользованиеИндивидуальныхПравилПересчетаТарифныхСтавокСотрудниковПриЗаписи(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.УстановитьИспользованиеИндивидуальныхПравилПересчетаТарифныхСтавок();
	
КонецПроцедуры

Процедура УстановитьСдвигПериодаРегистраСПериодичностьюСекунда(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("НеСдвигатьПериодЗаписей") Тогда
		Возврат;
	КонецЕсли; 
	
	Если Источник.ДополнительныеСвойства.Свойство("ЭтоВторичныйНабор") Тогда
		Возврат;
	КонецЕсли; 
	
	Если Источник.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Регистратор = Источник.Отбор.Регистратор.Значение;
	
	ТаблицаРегистра = Источник.ВыгрузитьКолонки();
	ИспользуютсяВторичныеЗаписи = ТаблицаРегистра.Колонки.Найти("ВторичнаяЗапись") <> Неопределено;
	
	СдвигПериода = ЗарплатаКадрыРасширенный.ЗначениеСдвигаПериодаЗаписиРегистра(Регистратор);
	
	Если СдвигПериода = Неопределено Тогда
		
		КонкурирующиеРегистраторы = ЗарплатаКадрыРасширенный.КонкурирующиеПоПериодуРегистраторыНачислений();
		Если КонкурирующиеРегистраторы.Найти(ТипЗнч(Регистратор)) = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		ВремяРегистрацииДокумента = Неопределено;
		Источник.ДополнительныеСвойства.Свойство("ВремяРегистрацииДокумента", ВремяРегистрацииДокумента);
		
		ПерезаполнитьВремяРегистрации = Ложь;
		Если ВремяРегистрацииДокумента <> Неопределено Тогда
			
			Для Каждого ЗаписьРегистра Из Источник Цикл
				
				Если Не (ИспользуютсяВторичныеЗаписи И ЗаписьРегистра.ВторичнаяЗапись) Тогда
					
					ДатаСобытия = НачалоДня(ЗаписьРегистра.Период);
					Если ВремяРегистрацииДокумента.Получить(ДатаСобытия) = Неопределено Тогда
						ПерезаполнитьВремяРегистрации = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ВремяРегистрацииДокумента = Неопределено Или ПерезаполнитьВремяРегистрации Тогда 
			
			СотрудникиДаты = ТаблицаРегистра.СкопироватьКолонки("Период, Сотрудник");
			
			Для Каждого ЗаписьРегистра Из Источник Цикл
				Если ИспользуютсяВторичныеЗаписи И ЗаписьРегистра.ВторичнаяЗапись Тогда
					Продолжить;
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(СотрудникиДаты.Добавить(), ЗаписьРегистра, "Период, Сотрудник");
			КонецЦикла;
			
			Движения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Источник);

			ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, СотрудникиДаты, Регистратор, "Период");
			
			ВремяРегистрацииДокумента = Источник.ДополнительныеСвойства.ВремяРегистрацииДокумента;
			
		КонецЕсли;
		
		Для Каждого ЗаписьРегистра Из Источник Цикл
			
			Если ЗарплатаКадрыРасширенный.ПериодВСтрокеНабораЗафиксирован(Источник, ЗаписьРегистра) Тогда 
				Продолжить;
			КонецЕсли;
			
			ДатаСобытия = НачалоДня(ЗаписьРегистра.Период);
			
			Если ИспользуютсяВторичныеЗаписи И ЗаписьРегистра.ВторичнаяЗапись Тогда 
				ЗаписьРегистра.Период = ДатаСобытия;
			Иначе 
				
				ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(ДатаСобытия);
				ВремяРегистрации = ВремяРегистрацииСотрудников.Получить(ЗаписьРегистра.Сотрудник);
				ЗаписьРегистра.Период = ВремяРегистрации;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого ЗаписьРегистра Из Источник Цикл
			
			Если ЗарплатаКадрыРасширенный.ПериодВСтрокеНабораЗафиксирован(Источник, ЗаписьРегистра) Тогда 
				Продолжить;
			КонецЕсли;
			
			ДатаСобытия = ЗаписьРегистра.Период;
			Если ИспользуютсяВторичныеЗаписи И ЗаписьРегистра.ВторичнаяЗапись Тогда 
				ЗаписьРегистра.Период = ДатаСобытия;
			Иначе
				
				Если НачалоДня(ДатаСобытия) <> НачалоДня(ДатаСобытия + СдвигПериода) Тогда
					ДатаСобытия = НачалоДня(ЗаписьРегистра.Период);
				КонецЕсли;
				
				ВремяРегистрации = ДатаСобытия + СдвигПериода;
				ЗаписьРегистра.Период = ВремяРегистрации;
				
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьВремяРегистрацииПриОтменеПроведенияДокументаОбработкаУдаленияПроведения(Источник, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Документ", Источник.Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВремяРегистрацииДокументовПлановыхНачислений.Дата,
	               |	ВремяРегистрацииДокументовПлановыхНачислений.Сотрудник,
	               |	ВремяРегистрацииДокументовПлановыхНачислений.Документ,
	               |	ВремяРегистрацииДокументовПлановыхНачислений.ВремяРегистрации,
	               |	ЛОЖЬ КАК Проведен
	               |ИЗ
	               |	РегистрСведений.ВремяРегистрацииДокументовПлановыхНачислений КАК ВремяРегистрацииДокументовПлановыхНачислений
	               |ГДЕ
	               |	ВремяРегистрацииДокументовПлановыхНачислений.Документ = &Документ";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ВремяРегистрацииДокументовПлановыхНачислений.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Источник.Ссылка);
	
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#Область ОбновитьСтроковыеСведенияФизическогоЛица

Процедура ОбновитьСтроковыеСведенияФизическогоЛицаПриЗаписиРегистраСведений(Источник, Отказ, Замещение) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;

	ПричинаОбновления = ПричинаОбновленияСтроковыхСведенийФизическогоЛица(Источник);
	Если ПричинаОбновления = Неопределено Тогда
	  Возврат;
	КонецЕсли;
	
	ФизическиеЛица = ФизическиеЛицаНабораЗаписей(Источник);
	   
	Для Каждого ФизическоеЛицо Из ФизическиеЛица Цикл 
		РегистрыСведений.СтроковыеСведенияФизическихЛиц.ОбновитьСтроковыеСведенияФизическогоЛица(ФизическоеЛицо, ПричинаОбновления);		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСтроковыеСведенияФизическогоЛицаПриЗаписиСправочника(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ПричинаОбновления = ПричинаОбновленияСтроковыхСведенийФизическогоЛица(Источник);
	Если ПричинаОбновления = Неопределено Тогда
	  Возврат;
	КонецЕсли;

	ФизическоеЛицо = Источник["Владелец"];	
	
	Если НЕ ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СтроковыеСведенияФизическихЛиц.ОбновитьСтроковыеСведенияФизическогоЛица(ФизическоеЛицо, ПричинаОбновления);
	
КонецПроцедуры

Функция ПричинаОбновленияСтроковыхСведенийФизическогоЛица(Источник)
	
	ТипИсточника = ТипЗнч(Источник);
	
	ПричинаОбновления = Неопределено;
	
	Если ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ДокументыФизическихЛиц") Тогда
		ПричинаОбновления = "Документы";
	ИначеЕсли ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ЗнаниеЯзыковФизическихЛиц") Тогда	
		ПричинаОбновления = "ЗнаниеЯзыков";
	ИначеЕсли ТипИсточника = Тип("РегистрСведенийНаборЗаписей.НаградыФизическихЛиц") Тогда	
		ПричинаОбновления = "Награды";
	ИначеЕсли ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ПрофессииФизическихЛиц") Тогда	
		ПричинаОбновления = "Профессии";
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.РодственникиФизическихЛиц") Тогда	
		ПричинаОбновления = "СоставСемьи";
	ИначеЕсли ТипИсточника = Тип("РегистрСведенийНаборЗаписей.СпециальностиФизическихЛиц") Тогда	
		ПричинаОбновления = "Специальности";
	ИначеЕсли ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ТрудоваяДеятельностьФизическихЛиц") Тогда	
		ПричинаОбновления = "ТрудоваяДеятельность";
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ОбразованиеФизическихЛиц") Тогда	
		ПричинаОбновления = "Образование";
	КонецЕсли;
	
	Возврат ПричинаОбновления;	
	
КонецФункции
	
#КонецОбласти

Процедура УстановитьИспользованиеТерриториальныхУсловийПФР(Источник, Отказ, Замещение) Экспорт
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбновитьИспользованиеТерриториальныхУсловийПФРПоОрганизациям();
		
КонецПроцедуры

Процедура ИспользоватьНачислениеЗарплатыПриЗаписи(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Константы.НеИспользоватьНачислениеЗарплаты.Установить(Не Источник.Значение);
	
	РасчетЗарплатыРасширенный.ЗаполнитьНастройкиРасчетаЗарплаты(Источник.Значение);
	
	ЗаполнитьНастройкиЗарплатаКадрыРасширенная(Источник.Значение);
	
	ЗаймыСотрудникам.ЗаполнитьНастройкиЗаймовСотрудникам(Источник.Значение);
	
	УправлениеШтатнымРасписанием.ЗаполнитьНастройкиШтатногоРасписания(Источник.Значение);
	
	Константы.ИспользоватьРасчетЗарплатыИСтатьиФинансированияЗарплата.Установить(Константы.ИспользоватьСтатьиФинансированияЗарплата.Получить() И Источник.Значение);
	
	Если НЕ Источник.Значение Тогда
		РегистрыСведений.НастройкиВзаиморасчетовПоПрочимДоходам.ВыключитьНастройки();
	КонецЕсли;
	
	ЗарплатаКадрыРасширенныйПереопределяемый.ПриУстановкеИспользованияЗарплатаКадры(Источник.Значение);
	
КонецПроцедуры

Функция ФизическиеЛицаНабораЗаписей(НаборЗаписей)
	
	ИмяПоляФизическоеЛицо = ИмяПоляФизическоеЛицоРегистраСведений(НаборЗаписей);
	ФизическиеЛица = НаборЗаписей.Выгрузить( , ИмяПоляФизическоеЛицо);
	ФизическиеЛица.Свернуть(ИмяПоляФизическоеЛицо);
	ФизическиеЛица = ФизическиеЛица.ВыгрузитьКолонку(ИмяПоляФизическоеЛицо);
	
	Если ФизическиеЛица.Количество() = 0 Тогда
		
		Если НаборЗаписей.Отбор[ИмяПоляФизическоеЛицо].Использование Тогда
			ФизическоеЛицо = НаборЗаписей.Отбор[ИмяПоляФизическоеЛицо].Значение;
			Если ЗначениеЗаполнено(ФизическоеЛицо) И ОбщегоНазначения.СсылкаСуществует(ФизическоеЛицо) Тогда
				ФизическиеЛица.Добавить(ФизическоеЛицо);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ФизическиеЛица;
	
КонецФункции 

Функция ИмяПоляФизическоеЛицоРегистраСведений(НаборЗаписей)
	
	ПолеФизическоеЛицо = "";
	
	МетаданныеНабора = НаборЗаписей.Метаданные();
	
	Если МетаданныеНабора.Измерения.Найти("ФизическоеЛицо") <> Неопределено Тогда
		ПолеФизическоеЛицо = "ФизическоеЛицо";
	ИначеЕсли МетаданныеНабора.Измерения.Найти("Физлицо") <> Неопределено Тогда
		ПолеФизическоеЛицо = "Физлицо";
	КонецЕсли;
	
	Возврат ПолеФизическоеЛицо;
	
КонецФункции 

Процедура ЗаполнитьНастройкиЗарплатаКадрыРасширенная(ИспользоватьРасчетЗарплатыРасширенная)
	НастройкиЗарплатаКадрыРасширенная = РегистрыСведений.НастройкиЗарплатаКадрыРасширенная.СоздатьНаборЗаписей();
	НастройкиЗарплатаКадрыРасширенная.Прочитать();
	НастройкиЗарплатаКадрыРасширенная.ДополнительныеСвойства.Вставить("ИспользоватьРасчетЗарплатыРасширенная", ИспользоватьРасчетЗарплатыРасширенная);
	НастройкиЗарплатаКадрыРасширенная.Записать();
КонецПроцедуры

Процедура ПроверитьНеобходимостьОбновленияПодчиненностиПодразделений(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ЭтоНовый() Тогда
		Источник.ДополнительныеСвойства.Вставить("НовоеПодразделение", Истина);
	Иначе
		
		ТекущийРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "Родитель");
		Если ТекущийРодитель <> Источник.Родитель Тогда
			Источник.ДополнительныеСвойства.Вставить("ОбновитьПодчиненностьПодразделенийОрганизаций", Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПодчиненностьПодразделенийОрганизаций(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	СписокПодразделений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Источник.Ссылка);
	
	Если Источник.ДополнительныеСвойства.Свойство("НовоеПодразделение")
		Или Источник.ДополнительныеСвойства.Свойство("ОбновитьПодчиненностьПодразделенийОрганизаций") Тогда
		
		РегистрыСведений.ПодчиненностьПодразделенийОрганизаций.ОбновитьПодчиненностьПодразделений(СписокПодразделений);
		
		Если Источник.ДополнительныеСвойства.Свойство("ОбновитьПодчиненностьПодразделенийОрганизаций") Тогда
			РегистрыСведений.ПодчиненностьПодразделенийОрганизаций.ОбновитьПодчиненностьПодразделенийПриСменеРодителя(СписокПодразделений);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтключитьКадровыйУчет(Источник, Отказ) Экспорт
	
	Если Не Источник.Значение Тогда
		
		НаборЗаписей = РегистрыСведений.НастройкиШтатногоРасписания.СоздатьНаборЗаписей();
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			
			НаборЗаписей[0].ИспользоватьШтатноеРасписание = Ложь;
			НаборЗаписей[0].НеИспользоватьШтатноеРасписание = Истина;
			
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.НастройкиВоинскогоУчета.СоздатьНаборЗаписей();
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			
			НаборЗаписей[0].ИспользоватьБронированиеГраждан = Истина;
			НаборЗаписей[0].ИспользоватьВоинскийУчет = Истина;
			
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НаборЗаписей.Записать();
			
		КонецЕсли;
		
		ИспользоватьПодработки = Константы.ИспользоватьПодработки.СоздатьМенеджерЗначения();
		ИспользоватьПодработки.Значение = Ложь;
		ИспользоватьПодработки.ОбменДанными.Загрузка = Истина;
		ИспользоватьПодработки.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти