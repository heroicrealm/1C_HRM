
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЗакрыватьПриВыборе	= Ложь;
	
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ЗначенияЗаполнения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидОбменаСКонтролирующимиОрганами) Тогда
		ВидОбменаСКонтролирующимиОрганами	= Перечисления.ВидыОбменаСКонтролирующимиОрганами.ОбменОтключен;
	КонецЕсли;
	
	Элементы.НастроитьПараметрыСпринтер.Видимость	= ЗначениеЗаполнено(Организация);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ВидОбменаСКонтролирующимиОрганами = Перечисления.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате Тогда
		МассивНепроверяемыхРеквизитов.Добавить("УчетнаяЗаписьОбмена");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура ВидОбменаСКонтролирующимиОрганамиПриИзменении(Элемент)
	
	Модифицированность	= Истина;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьОбменаПриИзменении(Элемент)
	
	Модифицированность	= Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьПараметрыСпринтер(Команда)
	
	ПараметрыФормы = Новый Структура("ОрганизацияСсылка", Организация);
	ОткрытьФорму("РегистрСведений.НастройкиИнтеграцииСоСпринтером.ФормаЗаписи", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьДанные();
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы	= Форма.Элементы;
	
	Если Форма.ВидОбменаСКонтролирующимиОрганами =
		ПредопределенноеЗначение("Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате") Тогда
		
		Элементы.ГруппаНастройки.ТекущаяСтраница	= Элементы.ГруппаОбменВУниверсальномФормате;
		
	ИначеЕсли Форма.ВидОбменаСКонтролирующимиОрганами =
		ПредопределенноеЗначение("Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменЧерезСпринтер") Тогда
		
		Элементы.ГруппаНастройки.ТекущаяСтраница	= Элементы.ГруппаОбменЧерезСпринтер;
		
	Иначе
		Элементы.ГруппаНастройки.ТекущаяСтраница	= Элементы.ГруппаОбменОтключен;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные()
	
	Модифицированность	= Ложь;
	
	ЗначениеВыбора	= Новый Структура(
		"ВидОбменаСКонтролирующимиОрганами, УчетнаяЗаписьОбмена",
		ВидОбменаСКонтролирующимиОрганами, УчетнаяЗаписьОбмена);
		
	ОповеститьОВыборе(ЗначениеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьДанные();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
