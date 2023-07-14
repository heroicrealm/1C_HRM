#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.ТерриторияТруда.Скопировать(, "Сотрудник, Период"), Ссылка, "Период");
	
	КадровыйУчетРасширенный.СформироватьДвиженияПоТерриториям(Движения, ДанныеДляПроведения.ТерриторияТруда);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, НачалоПериода, "Объект.НачалоПериода", Отказ, НСтр("ru='Начало периода'"), , , Ложь);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеТерритории", Новый Структура("Организация", Организация)) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В организации ""%1"" не используются обособленные территории'"),
				Организация),
			Ссылка,
			"Организация",
			"Объект",
			Отказ);
		
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОкончаниеПериода) И ОкончаниеПериода < НачалоПериода Тогда
		
		ТекстСообщения = НСтр("ru='Неверно задано окончание периода'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ОкончаниеПериода", , Отказ);
		
	КонецЕсли;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения", "НачалоПериода");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка.НачалоПериода КАК Период,
		|	ПеремещениеМеждуТерриториямиСотрудники.Сотрудник КАК Сотрудник,
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПеремещениеМеждуТерриториямиСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка.Территория КАК Территория
		|ИЗ
		|	Документ.ПеремещениеМеждуТерриториями.Сотрудники КАК ПеремещениеМеждуТерриториямиСотрудники
		|ГДЕ
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка = &Ссылка";
	
	ТерриторияТруда = Запрос.Выполнить().Выгрузить();
	Если ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		
		ТерриторияТруда.Колонки.Добавить("ДействуетДо", Новый ОписаниеТипов("Дата"));
		ТерриторияТруда.ЗаполнитьЗначения(КонецДня(ОкончаниеПериода) + 1, "ДействуетДо");
		
	КонецЕсли;
	
	Данные = Новый Структура("ТерриторияТруда", ТерриторияТруда);
	
	Возврат Данные;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрации = Документы.ПеремещениеМеждуТерриториями.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрации[Ссылка];	
КонецФункции	

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли