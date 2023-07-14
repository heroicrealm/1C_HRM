&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем ДанныеЗаполнения;

&НаКлиенте
Перем ДанныеОрганизации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидКонтролирующегоОргана 	= Параметры.ТипПолучателя;
	Организация 				= Параметры.Организация;
	
	СертификатНедоступенИлиИстек 	= Параметры.СертификатНедоступенИлиИстек;
	
	ИндексКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.Индекс(ВидКонтролирующегоОргана);
	ИмяКонтролирующегоОргана =
		Метаданные.Перечисления.ТипыКонтролирующихОрганов.ЗначенияПеречисления[ИндексКонтролирующегоОргана].Синоним;
	
	Заголовок = ИмяКонтролирующегоОргана;
	
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ПФР Тогда
		КодПолучателя = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			Организация,,
			"КодОрганаПФР").КодОрганаПФР;
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС Тогда
		КодПолучателя = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			Организация,,
			"КодПодчиненностиФСС").КодПодчиненностиФСС;
		
	Иначе
		КодПолучателя = "";
	КонецЕсли;
	КодПолучателя = СокрЛП(КодПолучателя);
	
	Элементы.ПодключенноеНаправление.Заголовок = СтрШаблон(
		НСтр("ru = 'Направление %1 уже подключено.'"),
		ИмяКонтролирующегоОргана + ?(КодПолучателя <> "", " " + КодПолучателя, ""));
	
	ЗаявлениеНаИзменениеДоступно = НЕ СертификатНедоступенИлиИстек;
	
	Если НЕ ЗаявлениеНаИзменениеДоступно Тогда
		// Направляем в мастер
		Элементы.ОтключитьНаправление.Заголовок = НСтр("ru = 'Подготовить заявление'");
	КонецЕсли;
	
	КонтролирующийОрган = Метаданные.Перечисления.ТипыКонтролирующихОрганов.ЗначенияПеречисления[ИндексКонтролирующегоОргана].Имя;
	КлючСохраненияПоложенияОкна = "Отключить" + КонтролирующийОрган
		+ ?(НЕ ЗаявлениеНаИзменениеДоступно, "Подготовить", "");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Успешная отправка заявления. Закрыть форму владельца"
		И Источник = ЗаявлениеАбонента.Ссылка Тогда
		
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтключитьНаправление(Команда)
	
	Если НЕ СертификатНедоступенИлиИстек Тогда
		ОтправитьЗаявлениеНаИзменениеВСкрытомРежиме();
	Иначе
		Закрыть(ВидКонтролирующегоОргана);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
	// Заполняем текущие реквизиты организации
	СтруктураРеквизитов = Новый Структура("Организация, ПриОткрытии", Организация, Ложь);
	КонтекстЭДОКлиент.ЗаполнитьДанныеОрганизации(СтруктураРеквизитов);
	ДанныеЗаполнения = КонтекстЭДОКлиент.ДополнитьДанныеОрганизацииДаннымиПоОтветственнымЛицам(СтруктураРеквизитов);
	ДанныеОрганизации = ДанныеЗаполнения.СтруктураДанныхОрганизации;
	
КонецПроцедуры

#Область ОтправкаЗаявления

&НаКлиенте
Процедура ОтправитьЗаявлениеНаИзменениеВСкрытомРежиме()
	
	ДополнительныеПараметры = ДлительнаяОтправкаКлиент.ПараметрыДлительнойОтправкиЗаявления();
	ДополнительныеПараметры.Вставить("Организация", Организация);
	
	Если НЕ ДлительнаяОтправкаКлиент.ПоказатьФормуДлительнойОтправкиЗаявления(ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ОтправитьЗаявлениеНаИзменение", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтправитьЗаявлениеНаИзменение() Экспорт
	
	УдалосьСоздать = СоздатьНовоеЗаявлениеСНовымНаправлением();
	
	Если НЕ УдалосьСоздать Тогда
		ДлительнаяОтправкаКлиент.ОповеститьОНеудачнойОтправкеЗаявления();
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СообщитьРезультатОтправки",
		ЭтотОбъект);
	
	ИдентификаторАбонента = КонтекстЭДОКлиент.ИдентификаторАбонентаПоОрганизации(Организация);
	
	Контекст = КонтекстЭДОКлиент.ПараметрыПроцедурыСформироватьИОтправитьЗаявление();
	Контекст.ДокументЗаявление 							= ЗаявлениеАбонента;
	Контекст.ИдентификаторАбонента 						= ИдентификаторАбонента;
	Контекст.ВызовИзМастераПодключенияК1СОтчетности 	= Истина;
	Контекст.ВыполняемоеОповещение 						= ОписаниеОповещения;
	Контекст.ФормироватьЗакрытыйКлючИЗапросНаСертификат = Ложь;
	КонтекстЭДОКлиент.СформироватьИОтправитьЗаявление(Контекст);
	
КонецПроцедуры

&НаСервере
Функция СоздатьНовоеЗаявлениеСНовымНаправлением()
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	НовыйДокументЗаявление = КонтекстЭДОСервер.СоздатьЗаявлениеНаИзменениеВСкрытомРежиме(Организация);
	Если НовыйДокументЗаявление = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ УдалосьОтключитьНаправление(НовыйДокументЗаявление) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		НовыйДокументЗаявление.Записать();
	Исключение
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ИнформацияОбОшибке().Описание);
		Возврат Ложь;
	КонецПопытки;
	
	ЗначениеВРеквизитФормы(НовыйДокументЗаявление, "ЗаявлениеАбонента");
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция УдалосьОтключитьНаправление(НовыйДокументЗаявление)
	
	// см.СоздатьЗаявлениеНаИзменениеВСкрытомРежиме_ОпределитьНаправленияСдачиОтчетности
	НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Очистить();
	
	КонтекстЭДОСервер 	= ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.СкорректироватьНаправленияСдачиОтчетностиСУчетомПредыдущихЗаявлений(НовыйДокументЗаявление, ВидКонтролирующегоОргана);
	
	ДанныеЗаполнения 	= КонтекстЭДОСервер.СоздатьЗаявлениеНаИзменениеВСкрытомРежиме_ДанныеЗаполнения(Организация);
	ДанныеОрганизации 	= ДанныеЗаполнения.СтруктураДанныхОрганизации;
	
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ПФР Тогда
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВПФР;
		
		КонтекстЭДОСервер.УдалитьПолучателейКонтролирующегоОргана(НовыйДокументЗаявление, Перечисления.ТипыКонтролирующихОрганов.ПФР);
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС Тогда
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВФСС;
		
		КонтекстЭДОСервер.УдалитьПолучателейКонтролирующегоОргана(НовыйДокументЗаявление, Перечисления.ТипыКонтролирующихОрганов.ФСС);
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСРАР Тогда
		
		НовыйДокументЗаявление.ПодатьЗаявкуНаСертификатДляФСРАР = Ложь;
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВФСРАР;
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.РПН Тогда
		
		НовыйДокументЗаявление.ПодатьЗаявкуНаПодключениеРПН = Ложь;
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВРПН;
		
	ИначеЕсли ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФТС Тогда
		
		НовыйДокументЗаявление.ПодатьЗаявкуНаПодключениеФТС = Ложь;
		
		НоваяСтрока = НовыйДокументЗаявление.ИзменившиесяРеквизитыВторичногоЗаявления.Добавить();
		НоваяСтрока.ИзмененныйРеквизит = Перечисления.ПараметрыПодключенияК1СОтчетности.СдаватьВФТС;
		
	КонецЕсли;
	
	Если НЕ КонтекстЭДОСервер.ЗаявлениеСодержитМинимальноНеобходимыхПолучателей(НовыйДокументЗаявление) Тогда
		ТекстОшибки = НСтр("ru = 'Среди контролирующих органов, в которые будет сдаваться отчетность, должены быть ФНС или ПФР.'");
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ТекстОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СообщитьРезультатОтправки(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ТекстОшибки")
		И ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(Результат.ТекстОшибки);
		ДлительнаяОтправкаКлиент.ОповеститьОНеудачнойОтправкеЗаявления();
		
	ИначеЕсли ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ОписаниеОшибки")
		И ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(Результат.ОписаниеОшибки);
		ДлительнаяОтправкаКлиент.ОповеститьОНеудачнойОтправкеЗаявления();
		
	Иначе
		
		ТекстПояснения = НСтр("ru = 'Мы уведомим вас о результате обработки заявления.
									|Обычно это занимает 20-30 минут.'");
		ДлительнаяОтправкаКлиент.ОповеститьОбУдачнойОтправкеЗаявления(
			Организация,
			ЗаявлениеАбонента.Ссылка,
			ТекстПояснения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

