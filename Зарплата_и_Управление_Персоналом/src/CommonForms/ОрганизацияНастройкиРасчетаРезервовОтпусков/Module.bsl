#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Заголовок",			Заголовок);
	Параметры.Свойство("ОрганизацияСсылка",	ОрганизацияСсылка);
	
	ПрочитатьДанные();
	
	ОбновитьЭлементыФормыПоТекущимНастройкам();
	
	ТолькоПросмотр = ОбособленноеПодразделение;
	

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтредактированаИстория" И ОрганизацияСсылка = Источник Тогда
		
		Если Параметр.ИмяРегистра = "НастройкиРасчетаРезервовОтпусков" Тогда
			
			Если НастройкиРасчетаРезервовОтпусковНаборЗаписейПрочитан Тогда
				
				РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(
				ЭтотОбъект,
				ОрганизацияСсылка,
				ИмяСобытия,
				Параметр,
				Источник);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтотОбъект, "НастройкиРасчетаРезервовОтпусков", ОрганизацияСсылка, Отказ);
	
	Если Не Отказ Тогда
		
		ПроверитьЗаполнение = НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ
			И (НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков = ПредопределенноеЗначение("Перечисление.МетодыНачисленияРезервовОтпусков.НормативныйМетод")
			Или НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковНУ);
			
			Если ПроверитьЗаполнение Тогда
				
				МетаданныеРегистра = Метаданные.РегистрыСведений.НастройкиРасчетаРезервовОтпусков;
				Если НастройкиРасчетаРезервовОтпусков.НормативОтчисленийВРезервОтпусков = 0 Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не заполнено поле ""%1"".'"), МетаданныеРегистра.Ресурсы.НормативОтчисленийВРезервОтпусков.Синоним);
					ПутьКРеквизитуФормы = "НастройкиРасчетаРезервовОтпусков.НормативОтчисленийВРезервОтпусков";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,	ПутьКРеквизитуФормы, , Отказ);
				КонецЕсли;
				
				Если НастройкиРасчетаРезервовОтпусков.ПредельнаяВеличинаОтчисленийВРезервОтпусков = 0 Тогда
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не заполнено поле ""%1"".'"), МетаданныеРегистра.Ресурсы.ПредельнаяВеличинаОтчисленийВРезервОтпусков.Синоним);
					ПутьКРеквизитуФормы = "НастройкиРасчетаРезервовОтпусков.ПредельнаяВеличинаОтчисленийВРезервОтпусков";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,	ПутьКРеквизитуФормы, , Отказ);
				КонецЕсли;
				
			КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГодНастроекПриИзменении(Элемент)
	
	НастройкиРасчетаРезервовОтпусков.Период = Дата(ГодНастроек,1,1);
	
КонецПроцедуры

&НаКлиенте
Процедура ГодНастроекРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	НастройкиРасчетаРезервовОтпусков.Период = Дата(ГодНастроек,1,1);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьРезервОтпусковБУПриИзменении(Элемент)
	
	Если НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ Тогда
		
		Если Не ЗначениеЗаполнено(НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков) Тогда
			НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков = ПредопределенноеЗначение("Перечисление.МетодыНачисленияРезервовОтпусков.НормативныйМетод");
			НастройкиРасчетаРезервовОтпусков.ОпределятьИзлишкиЕжемесячно = Ложь;
		КонецЕсли;
		
	Иначе
		
		НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковНУ = Ложь;
		НастройкиРасчетаРезервовОтпусков.ОпределятьИзлишкиЕжемесячно = Ложь;
		НастройкиРасчетаРезервовОтпусков.НормативОтчисленийВРезервОтпусков = 0;
		НастройкиРасчетаРезервовОтпусков.ПредельнаяВеличинаОтчисленийВРезервОтпусков = 0;
		НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков = ПредопределенноеЗначение("Перечисление.МетодыНачисленияРезервовОтпусков.ПустаяСсылка");
		
	КонецЕсли;
	
	ОбновитьДоступностьНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияРезерваОтпусковПриИзменении(Элемент)
	
	ОбработатьИзменениеНастроекМетодаНачисления();
	ОбновитьДоступностьНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьРезервОтпусковНУПриИзменении(Элемент)
	
	ОбработатьИзменениеНастроекМетодаНачисления();	
	ОбновитьДоступностьНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеНастроекМетодаНачисления()

	ДоступностьНастроек = НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ
	И (НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков = ПредопределенноеЗначение("Перечисление.МетодыНачисленияРезервовОтпусков.НормативныйМетод")
	Или НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковНУ);
	Если Не ДоступностьНастроек Тогда
		НастройкиРасчетаРезервовОтпусков.НормативОтчисленийВРезервОтпусков = 0;
		НастройкиРасчетаРезервовОтпусков.ПредельнаяВеличинаОтчисленийВРезервОтпусков = 0;
	КонецЕсли;
	
	Если НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков = ПредопределенноеЗначение("Перечисление.МетодыНачисленияРезервовОтпусков.НормативныйМетод") Тогда
		НастройкиРасчетаРезервовОтпусков.ОпределятьИзлишкиЕжемесячно = Ложь;
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиРасчетаРезервовОтпусковИстория(Команда)
	
	ОткрытьФормуРедактированияИстории("НастройкиРасчетаРезервовОтпусков", ГоловнаяОрганизация, ЭтотОбъект, ОбособленноеПодразделение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьИЗакрытьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	СохранитьИЗакрытьНаКлиенте(Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиенте(ЗакрытьФорму = Истина) Экспорт 

	ДополнительныеПараметры = Новый Структура("ЗакрытьФорму", ЗакрытьФорму);
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрытьНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	СохранитьДанные(Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрытьНаКлиентеЗавершение(Отказ, ДополнительныеПараметры) Экспорт 

	Если Не Отказ И Открыта() Тогда
		
		Модифицированность = Ложь;
		Если ДополнительныеПараметры.ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Отказ, ОповещениеЗавершения = Неопределено) Экспорт
	
	Если Не Модифицированность Тогда
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ТекстКнопкиДа = НСтр("ru = 'Изменились сведения о настройках'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru =  'При редактировании изменены сведения о настройках.
						|Если исправлена прежняя запись (она была ошибочной), нажмите ""Исправлена ошибка"".
						|Если изменились сведения с %1, нажмите'") + " ""%2""",
			Формат(НастройкиРасчетаРезервовОтпусков.Период, "ДФ='д ММММ гггг ""г""'"),
			ТекстКнопкиДа);
			
	Оповещение = Новый ОписаниеОповещения("СохранитьДанныеЗавершение", ЭтотОбъект, ОповещениеЗавершения);
	РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ЭтотОбъект, "НастройкиРасчетаРезервовОтпусков", ТекстВопроса, ТекстКнопкиДа, Отказ, Оповещение);
			
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеЗавершение(Отказ, ОповещениеЗавершения) Экспорт  
	
	СохранитьДанныеНаСервере(Отказ);
	
	Если НЕ Отказ И ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанные()
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(ОрганизацияСсылка);
	ОбособленноеПодразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОрганизацияСсылка,"ОбособленноеПодразделение");
	
	ЮридическоеФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГоловнаяОрганизация,"ЮридическоеФизическоеЛицо");
	ЭтоЮрЛицо = ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	Элементы.ФормироватьРезервОтпусковНУ.Видимость = ЭтоЮрЛицо;
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтотОбъект, "НастройкиРасчетаРезервовОтпусков", ГоловнаяОрганизация);
	
	Если Не ЗначениеЗаполнено(НастройкиРасчетаРезервовОтпусков.Период) Тогда
		ГодНастроек = 2014;
		НастройкиРасчетаРезервовОтпусков.Период = Дата(ГодНастроек,1,1);
	Иначе
		ГодНастроек = Год(НастройкиРасчетаРезервовОтпусков.Период);
		Если Не ЭтоЮрЛицо И НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковНУ Тогда
			НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковНУ = Ложь;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеНаСервере(Отказ)
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтотОбъект, "НастройкиРасчетаРезервовОтпусков", ГоловнаяОрганизация);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияИстории(ИмяРегистра, ВедущийОбъект, Форма, ЗапретРедактирования = Ложь)
	
	ТолькоПросмотрИстории = Форма.ТолькоПросмотр ИЛИ ЗапретРедактирования;
	Если Не ТолькоПросмотрИстории Тогда
		Попытка
			Форма.ЗаблокироватьДанныеФормыДляРедактирования();
			ТолькоПросмотрИстории = Ложь;
		Исключение
			ТолькоПросмотрИстории = Истина;
		КонецПопытки
	КонецЕсли;
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию(ИмяРегистра, ВедущийОбъект, Форма, ТолькоПросмотрИстории);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтотОбъект, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	Отказ = Ложь;
	СохранитьДанныеНаСервере(Отказ);
	
	Если Не Отказ Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормыПоТекущимНастройкам()
	
	Элементы.ОрганизацияОписаниеДекорация.Видимость = ОбособленноеПодразделение;
	РаботаВБюджетномУчреждении = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	Элементы.ГруппаОценочныеОбязательства.ОтображатьЗаголовок = Не РаботаВБюджетномУчреждении;
	Если РаботаВБюджетномУчреждении Тогда
		Элементы.ФормироватьРезервОтпусковБУ.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.ФормироватьРезервОтпусковБУ.Заголовок = НСтр("ru = 'Формировать резервы'");
	КонецЕсли;
	ОбновитьДоступностьНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьНастроек(Форма)

	ДоступностьНастроек = Форма.НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ
		И (Форма.НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков = ПредопределенноеЗначение("Перечисление.МетодыНачисленияРезервовОтпусков.НормативныйМетод")
		Или Форма.НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковНУ);
	
	Форма.Элементы.МетодНачисленияРезерваОтпусков.Доступность   = Форма.НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ;
	Форма.Элементы.ФормироватьРезервОтпусковНУ.Доступность      = Форма.НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ;
	
	Форма.Элементы.ОпределятьИзлишкиЕжемесячно.Доступность      = Форма.НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ
																	И Форма.НастройкиРасчетаРезервовОтпусков.МетодНачисленияРезерваОтпусков = ПредопределенноеЗначение("Перечисление.МетодыНачисленияРезервовОтпусков.МетодОбязательств");
	
	Форма.Элементы.НормативОтчисленийВРезервОтпусков.Доступность               = ДоступностьНастроек;
	Форма.Элементы.НормативОтчисленийВРезервОтпусков.АвтоОтметкаНезаполненного = ДоступностьНастроек; 
	Форма.Элементы.НормативОтчисленийВРезервОтпусков.ОтметкаНезаполненного     = ДоступностьНастроек И Форма.НастройкиРасчетаРезервовОтпусков.НормативОтчисленийВРезервОтпусков = 0;
	
	Форма.Элементы.ПредельнаяВеличинаОтчисленийВРезервОтпусков.Доступность               = ДоступностьНастроек;
	Форма.Элементы.ПредельнаяВеличинаОтчисленийВРезервОтпусков.АвтоОтметкаНезаполненного = ДоступностьНастроек; 
	Форма.Элементы.ПредельнаяВеличинаОтчисленийВРезервОтпусков.ОтметкаНезаполненного     = ДоступностьНастроек И Форма.НастройкиРасчетаРезервовОтпусков.ПредельнаяВеличинаОтчисленийВРезервОтпусков = 0;
	
КонецПроцедуры


#КонецОбласти
