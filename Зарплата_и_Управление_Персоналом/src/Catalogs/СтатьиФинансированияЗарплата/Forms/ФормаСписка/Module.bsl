
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтборИспользуемых(Список.Отбор, ПоказатьАрхивные);
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "ВАрхиве");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьАрхивныеПриИзменении(Элемент)
	УстановитьОтборИспользуемых(Список.Отбор, ПоказатьАрхивные);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборИспользуемых(ГруппаОтбора, ПоказатьАрхивные)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ГруппаОтбора, "ВАрхиве");
	Если НЕ ПоказатьАрхивные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "ВАрхиве", Ложь);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

