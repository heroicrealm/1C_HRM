
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ЛицензияДатаБлокировки, ЛицензияПросрочена, СертификатДатаОкончания, СертификатПросрочен, СсылкаНаОбъект, СрокДействияКлюча, СрокДействияКлючаПросрочен");
	
	КонтекстЭДОСервер        = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	СведенияПоОбъекту        = КонтекстЭДОСервер.СведенияПоОтправляемымОбъектам(СсылкаНаОбъект);
	Организация 			 = СведенияПоОбъекту.Организация;
	ВидКонтролирующегоОргана = СведенияПоОбъекту.ВидКонтролирующегоОргана;
	ОрганСтрокой 			 = ВидКонтролирующегоОргана;
	Заголовок                = КонтекстЭДОСервер.СообщениеОНеподключенномНаправлении_ЗаголовокФормы(СсылкаНаОбъект, ОрганСтрокой);
	
	ПоддерживаетсяВторичноеЗаявление = КонтекстЭДОСервер.ПоддерживаетсяВторичноеЗаявление(Организация);
	
	Элементы.ЧтоДелать.Заголовок = ЧтоДелать();
	
	Если НЕ ПоддерживаетсяВторичноеЗаявление Тогда
		Элементы.ФормаОтправитьЗаявление.Видимость = Ложь;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявление(Команда)
	Закрыть(Организация);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЧтоДелать()
	
	Возврат Новый ФорматированнаяСтрока(
		Предложение1(), 
		Предложение2(),
		Предложение3(),
		Предложение4(),
		Предложение5());

КонецФункции

&НаСервере
Функция Предложение1()
	
	Предложение1 = НСтр("ru = 'Для отправки %1 необходимо продлить %2 для 1С-Отчетности.'");
	
	Текст1 = ДлительнаяОтправкаКлиентСервер.НазваниеОбъектаВРодительномПадеже(СсылкаНаОбъект);
	
	Текст2 = "";
	
	МассивКонтроля = Новый Массив;
	Если ЛицензияПросрочена Тогда
		МассивКонтроля.Добавить(НСтр("ru = 'лицензию'"));
	КонецЕсли;
	
	Если СертификатПросрочен Тогда
		МассивКонтроля.Добавить(НСтр("ru = 'сертификат'"));
	КонецЕсли;
	
	Если СрокДействияКлючаПросрочен Тогда
		МассивКонтроля.Добавить(НСтр("ru = 'ключ myDSS'"));
	КонецЕсли;
	
	Всего = МассивКонтроля.Количество() - 1;
	Для Счетчик = 0 По Всего Цикл
		Если Счетчик <> 0 И Счетчик = Всего Тогда
			Текст2 = Текст2 + " " + НСтр("ru = 'и'") + " ";
		ИначеЕсли Счетчик > 0 Тогда
			Текст2 = Текст2 + ", ";
		КонецЕсли;	
		Текст2 = Текст2 + МассивКонтроля[Счетчик];
	КонецЦикла;
	
	Предложение1 = СтрШаблон(Предложение1, Текст1, Текст2);
	
	Возврат Предложение1 + Символы.ПС;
	
КонецФункции

&НаСервере
Функция Предложение2()
	
	Если ПоддерживаетсяВторичноеЗаявление Тогда
		Предложение2 = НСтр("ru = 'Для этого отправьте заявление на продление.'");
	Иначе
		Предложение2 = НСтр("ru = 'Для этого обратитесь к вашему оператору связи.'");
	КонецЕсли;
	
	Возврат Предложение2 + Символы.ПС + Символы.ПС;
	
КонецФункции

&НаСервере
Функция Предложение3()
	
	Предложение3 = "";
	Если ЛицензияПросрочена Тогда
		
		Предложение3 = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Лицензия истекла: '"),
			Новый ФорматированнаяСтрока(Строка(ЛицензияДатаБлокировки), Новый Шрифт(,,Истина)),
			Символы.ПС);
			
	КонецЕсли;
	
	Возврат Предложение3;
	
КонецФункции

&НаСервере
Функция Предложение4()
	
	Предложение4 = "";
	Если СертификатПросрочен Тогда
		
		Предложение4 = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Сертификат истек:  '"),
			Новый ФорматированнаяСтрока(Строка(СертификатДатаОкончания), Новый Шрифт(,,Истина)));
			
	КонецЕсли;
	
	Возврат Предложение4;
	
КонецФункции

&НаСервере
Функция Предложение5()
	
	Предложение5 = "";
	Если СрокДействияКлючаПросрочен Тогда
		
		Предложение5 = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Истекает срок действия ключа myDSS:  '"),
			Новый ФорматированнаяСтрока(Строка(СрокДействияКлюча), Новый Шрифт(,,Истина)));
			
	КонецЕсли;
	
	Возврат Предложение5;
	
КонецФункции

#КонецОбласти

