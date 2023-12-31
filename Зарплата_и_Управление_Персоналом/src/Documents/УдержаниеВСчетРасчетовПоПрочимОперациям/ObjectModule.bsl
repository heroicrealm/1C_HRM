#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Начало периода'"), , , Ложь);
	ОтражениеЗарплатыВБухучетеРасширенный.УточнитьСоставПроверяемыхРеквизитовБухучетПлановыхУдержаний(ЭтотОбъект, ПроверяемыеРеквизиты);
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 		= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода		= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	= ДатаОкончания;
	
	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "ФизическоеЛицо", "Объект")
	);
	
	Если Действие = Перечисления.ДействияСУдержаниями.Начать Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДокументОснование");
	КонецЕсли;
	
	Если Действие <> Перечисления.ДействияСУдержаниями.Прекратить Тогда 
		ЗарплатаКадрыРасширенный.ПроверитьПериодРегистратораНачисленийУдержаний(ДатаНачала, ДатаОкончания, ЭтотОбъект, "ДатаОкончания", Отказ);
	КонецЕсли;
	
	Если Не ПрекратитьПоДостижениюПредела Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Предел");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Сотрудник") Тогда
			ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения.Сотрудник);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = РасчетЗарплатыРасширенный.СоздатьДанныеДляРегистрацииПлановыхУдержаний();
	РасчетЗарплатыРасширенный.ЗаполнитьДанныеДляРегистрацииПлановыхУдержаний(ДанныеДляПроведения, Ссылка);
	ЗаполнитьПредельныеСуммыУдержанийСотрудников(ДанныеДляПроведения);
	
	ДвиженияУдержаний = Новый Структура;
	ДвиженияУдержаний.Вставить("ДанныеПлановыхУдержаний", ДанныеДляПроведения.ДанныеПлановыхУдержаний);
	ДвиженияУдержаний.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
	ДвиженияУдержаний.Вставить("РабочиеМестаУдержаний", ДанныеДляПроведения.РабочиеМестаУдержаний);
	
	РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхУдержаний(Движения, ДвиженияУдержаний);
	РасчетЗарплатыРасширенный.СформироватьДвиженияПредельныхСуммУдержанийСотрудников(Движения, ДанныеДляПроведения.ПредельныеСуммыУдержанийСотрудников);
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") И БухучетЗаданВДокументе Тогда
		БухучетПлановыхУдержаний = ОтражениеЗарплатыВБухучетеРасширенный.ДанныеДляРегистрацииБухучетаПлановыхУдержаний(Ссылка);
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетПлановыхУдержаний(Движения, БухучетПлановыхУдержаний);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредельныеСуммыУдержанийСотрудников(ДанныеДляПроведения)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	УдержаниеВСчетРасчетовПоПрочимОперациям.ДатаНачала КАК Период,
	               |	УдержаниеВСчетРасчетовПоПрочимОперациям.Организация.ГоловнаяОрганизация КАК Организация,
	               |	УдержаниеВСчетРасчетовПоПрочимОперациям.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	УдержаниеВСчетРасчетовПоПрочимОперациям.Удержание КАК Удержание,
	               |	ВЫБОР
	               |		КОГДА УдержаниеВСчетРасчетовПоПрочимОперациям.ДокументОснование = ЗНАЧЕНИЕ(Документ.УдержаниеВСчетРасчетовПоПрочимОперациям.ПустаяСсылка)
	               |			ТОГДА УдержаниеВСчетРасчетовПоПрочимОперациям.Ссылка
	               |		ИНАЧЕ УдержаниеВСчетРасчетовПоПрочимОперациям.ДокументОснование
	               |	КОНЕЦ КАК ДокументОснование,
	               |	УдержаниеВСчетРасчетовПоПрочимОперациям.ПрекратитьПоДостижениюПредела КАК ПрекратитьПоДостижениюПредела,
	               |	УдержаниеВСчетРасчетовПоПрочимОперациям.Предел КАК Сумма
	               |ИЗ
	               |	Документ.УдержаниеВСчетРасчетовПоПрочимОперациям КАК УдержаниеВСчетРасчетовПоПрочимОперациям
	               |ГДЕ
	               |	УдержаниеВСчетРасчетовПоПрочимОперациям.Ссылка = &Ссылка";
				   
	ДанныеДляПроведения.ПредельныеСуммыУдержанийСотрудников = Запрос.Выполнить().Выгрузить();			   
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли