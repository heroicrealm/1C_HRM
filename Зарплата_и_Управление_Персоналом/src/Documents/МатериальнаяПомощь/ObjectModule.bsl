#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Действие") Тогда 
			Если ДанныеЗаполнения.Действие = "Исправить" Тогда
				ДокументыРазовыхНачислений.СкопироватьИсправляемыйДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка,
					"ДокументРассчитан", 
					"НачисленияПерерасчет,
					|НДФЛ,
					|ПримененныеВычетыНаДетейИИмущественные,
					|РаспределениеРезультатовНачислений,
					|РаспределениеРезультатовУдержаний,
					|Удержания");
				ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
				
			ИначеЕсли ДанныеЗаполнения.Действие = "ЗаполнитьПоЗаявке" Тогда 
				Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.СамообслуживаниеСотрудников") Тогда 
					Модуль = ОбщегоНазначения.ОбщийМодуль("СамообслуживаниеСотрудников");
					Модуль.ОбработкаЗаполненияДокументаМатериальнаяПомощь(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПроизвольныеКадровыеПриказы") Тогда
		МодульПроизвольныеКадровыеПриказы = ОбщегоНазначения.ОбщийМодуль("ПроизвольныеКадровыеПриказы");
		МодульПроизвольныеКадровыеПриказы.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.МатериальнаяПомощь.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, , "ПериодРегистрации");
	
	МассивНачисленийДокумента = Новый Массив;
	МассивНачисленийДокумента.Добавить(ВидРасчета);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, НачисленияПерерасчет.ВыгрузитьКолонку("Начисление"), Истина);
	
	Если Не УчетНДФЛРасширенный.ДатаВыплатыОбязательнаКЗаполнению(ПорядокВыплаты, МассивНачисленийДокумента) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");
	КонецЕсли;
	
	// Проверка корректности распределения по источникам финансирования
	ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
	
	ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
		ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ, ВидРасчета);
	
	// Проверка корректности распределения по территориям и условиям труда
	ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
	
	РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
		ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПерерасчетЗарплаты.УдалитьПерерасчетыПоРегистратору(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
		
	ДокументыРазовыхНачислений.ЗаполнитьРегистраторРазовыхНачисленийПередЗаписью(ЭтотОбъект);
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокумент(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.МатериальнаяПомощь.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
		
	ДокументыРазовыхНачислений.ПриКопированииДокумента(ЭтотОбъект);
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокументПриКопировании(ЭтотОбъект, ОбъектКопирования.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли