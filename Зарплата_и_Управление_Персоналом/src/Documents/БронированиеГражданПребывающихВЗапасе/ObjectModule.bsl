#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	СформироватьДвиженияПоБронированию(Движения, ДанныеДляПроведения.ДвиженияПоБронированию);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ХодатайствоОБронированииГражданПребывающихВЗапасе") Тогда
		ЗаполнитьПоХодатайству(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	БронированиеГражданПребывающихВЗапасеСотрудники.Ссылка.Дата КАК Период,
	               |	БронированиеГражданПребывающихВЗапасеСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	БронированиеГражданПребывающихВЗапасеСотрудники.Ссылка.Организация КАК Организация
	               |ИЗ
	               |	Документ.БронированиеГражданПребывающихВЗапасе.Сотрудники КАК БронированиеГражданПребывающихВЗапасеСотрудники
	               |ГДЕ
	               |	БронированиеГражданПребывающихВЗапасеСотрудники.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура;
	
	ДвиженияПоБронированию = РезультатЗапроса.Выгрузить();
	ДанныеДляПроведения.Вставить("ДвиженияПоБронированию", ДвиженияПоБронированию);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СформироватьДвиженияПоБронированию(Движения, ДвиженияПоБронированию) Экспорт 
	
	Если ДвиженияПоБронированию.Количество() > 0 Тогда
		Движения.БронированиеСотрудников.Записывать = Истина;
	КонецЕсли; 
	
	Движения.БронированиеСотрудников.Загрузить(ДвиженияПоБронированию);
	
КонецПроцедуры

Процедура ЗаполнитьПоХодатайству(ДокументСсылка)
	
	РеквизитыШапки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Организация, Проведен");
	
	ПроверитьВозможностьВводаНаОсновании(ДокументСсылка, РеквизитыШапки.Проведен);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыШапки, , "Проведен");
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ХодатайствоОБронированииГражданПребывающихВЗапасеСотрудники.ФизическоеЛицо КАК ФизическоеЛицо
	               |ИЗ
	               |	Документ.ХодатайствоОБронированииГражданПребывающихВЗапасе.Сотрудники КАК ХодатайствоОБронированииГражданПребывающихВЗапасеСотрудники
	               |ГДЕ
	               |	ХодатайствоОБронированииГражданПребывающихВЗапасеСотрудники.Ссылка = &Ссылка";
				   
	Сотрудники.Загрузить(Запрос.Выполнить().Выгрузить());			   
	
КонецПроцедуры

Процедура ПроверитьВозможностьВводаНаОсновании(ДокументСсылка, ДокументПроведен)
	
	Если Не ДокументПроведен Тогда 
		
		ТекстОшибки = НСтр("ru='Документ %1 не проведен. Ввод на основании непроведенного документа запрещен.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДокументСсылка);
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли