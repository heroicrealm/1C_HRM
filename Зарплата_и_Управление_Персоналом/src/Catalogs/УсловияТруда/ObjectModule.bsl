#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Должности")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.УсловияТруда") Тогда
		
		ИменаРеквизитов = "ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией,
						  |ОснованиеДосрочногоНазначенияПенсии,
						  |ОсобыеУсловияТрудаПФР,
						  |ПроцентНадбавкиЗаВредность,
						  |ВыплачиваетсяНадбавкаЗаВредность,
						  |КоличествоДнейДополнительногоОтпускаВГод,
						  |КодПозицииСпискаПФР";
		
		СведенияОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, ИменаРеквизитов);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОснования);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		МодульОхранаТруда = ОбщегоНазначения.ОбщийМодуль("ОхранаТруда");
		МодульОхранаТруда.ОбновитьДанныеРабочихМестПоУсловиямТруда(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли