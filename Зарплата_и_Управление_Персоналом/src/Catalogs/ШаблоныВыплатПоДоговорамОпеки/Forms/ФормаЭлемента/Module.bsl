
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВыплатыОграниченияПоВозрастуПредставление",
		"Видимость",
		ПолучитьФункциональнуюОпцию("УчитыватьВозрастРебенкаПриВыплатахПоДоговорамОпеки"));
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ВыплатыПоДоговорамОпеки.ЗаполнитьВсеПоляПредставленийВыплаты(Объект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ВыплатыПоДоговорамОпеки.ЗаполнитьВсеПоляПредставленийВыплаты(Объект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыплаты

&НаКлиенте
Процедура ВыплатыОграниченияПоВозрастуПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Выплаты.ТекущиеДанные;
	ПараметрыОграничений = ВыплатыПоДоговорамОпекиКлиент.ПараметрыОграниченийПоВозрасту();
	ПараметрыОграничений.ВозрастОт = ТекДанные.ВыплачиваетсяПриВозрастеОт;
	ПараметрыОграничений.ВозрастДо = ТекДанные.ВыплачиваетсяПриВозрастеДо;
	ПараметрыОграничений.ИсключаяДатуОт = ТекДанные.ИсключаяДатуОт;
	ПараметрыОграничений.ВключаяДатуДо = ТекДанные.ВключаяДатуДо;
	ВыплатыПоДоговорамОпекиКлиент.ВводОграниченийПоВозрасту(ПараметрыОграничений, Элементы.ВыплатыОграниченияПоВозрастуПредставление);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатыОграниченияПоВозрастуПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение)=Тип("Структура") Тогда
		РезультатВыбора = Новый ФиксированнаяСтруктура(ВыбранноеЗначение);
		ТекДанные = Элементы.Выплаты.ТекущиеДанные;
		ТекДанные.ВыплачиваетсяПриВозрастеОт = РезультатВыбора.ВозрастОт;
		ТекДанные.ВыплачиваетсяПриВозрастеДо = РезультатВыбора.ВозрастДо;
		ТекДанные.ИсключаяДатуОт = РезультатВыбора.ИсключаяДатуОт;
		ТекДанные.ВключаяДатуДо = РезультатВыбора.ВключаяДатуДо;
		ВыбранноеЗначение = ВыплатыПоДоговорамОпекиКлиентСервер.ОграниченияПоВозрастуПредставление(
			ТекДанные.ВыплачиваетсяПриВозрастеОт, ТекДанные.ВыплачиваетсяПриВозрастеДо,
			ТекДанные.ИсключаяДатуОт, ТекДанные.ВключаяДатуДо);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыплатыРасчетРазмераВыплатыПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Выплаты.ТекущиеДанные;
	ПараметрыРасчетаРазмераВыплаты = Новый Структура;
	ПараметрыРасчетаРазмераВыплаты.Вставить("СпособРасчета", ТекДанные.СпособРасчета);
	ПараметрыРасчетаРазмераВыплаты.Вставить("ПрожиточныйМинимум", ТекДанные.ПрожиточныйМинимум);
	ПараметрыРасчетаРазмераВыплаты.Вставить("Размер", ТекДанные.Размер);
	ПараметрыРасчетаРазмераВыплаты.Вставить("Коэффициент", ТекДанные.Коэффициент);
	ВыплатыПоДоговорамОпекиКлиент.ВводДанныхДляРасчетаРазмераВыплаты(ПараметрыРасчетаРазмераВыплаты, Элементы.ВыплатыРасчетРазмераВыплатыПредставление);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатыРасчетРазмераВыплатыПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СпособРасчетаФиксированныйРазмер             = ПредопределенноеЗначение("Перечисление.СпособыРасчетаВыплатПоДоговорамОпеки.ФиксированныйРазмер");
	СпособРасчетаКоэффициентНаПрожиточныйМинимум = ПредопределенноеЗначение("Перечисление.СпособыРасчетаВыплатПоДоговорамОпеки.КоэффициентНаПрожиточныйМинимум");
	СпособРасчетаКоэффициентНаМРОТ               = ПредопределенноеЗначение("Перечисление.СпособыРасчетаВыплатПоДоговорамОпеки.КоэффициентНаМРОТ");
	
	Если ТипЗнч(ВыбранноеЗначение)=Тип("Структура") Тогда
		РезультатВыбора = Новый ФиксированнаяСтруктура(ВыбранноеЗначение);
		ТекДанные = Элементы.Выплаты.ТекущиеДанные;
		ТекДанные.СпособРасчета = РезультатВыбора.СпособРасчета;
		Если ТекДанные.СпособРасчета=СпособРасчетаФиксированныйРазмер Тогда 
			ТекДанные.ПрожиточныйМинимум = Неопределено;
			ТекДанные.Размер = РезультатВыбора.Размер;
			ТекДанные.Коэффициент = 1;
		ИначеЕсли ТекДанные.СпособРасчета=СпособРасчетаКоэффициентНаПрожиточныйМинимум Тогда
			ТекДанные.ПрожиточныйМинимум = РезультатВыбора.ПрожиточныйМинимум;
			ТекДанные.Размер = 0;
			ТекДанные.Коэффициент = РезультатВыбора.Коэффициент;
		ИначеЕсли ТекДанные.СпособРасчета=СпособРасчетаКоэффициентНаМРОТ Тогда
			ТекДанные.ПрожиточныйМинимум = Неопределено;
			ТекДанные.Размер = 0;
			ТекДанные.Коэффициент = РезультатВыбора.Коэффициент;
		Иначе 
			ТекДанные.ПрожиточныйМинимум = Неопределено;
			ТекДанные.Размер = 0;
			ТекДанные.Коэффициент = 1;
		КонецЕсли;
		ВыбранноеЗначение = ВыплатыПоДоговорамОпекиКлиентСервер.РасчетРазмераВыплатыПредставление(
			ТекДанные.СпособРасчета, ТекДанные.ПрожиточныйМинимум, ТекДанные.Размер, ТекДанные.Коэффициент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатыПриИзменении(Элемент)
	ТекДанные = Элементы.Выплаты.ТекущиеДанные;
	Если ТекДанные<>Неопределено Тогда 
		ТекДанные.ОграниченияПоВозрастуПредставление = ВыплатыПоДоговорамОпекиКлиентСервер.ОграниченияПоВозрастуПредставление(
			ТекДанные.ВыплачиваетсяПриВозрастеОт, ТекДанные.ВыплачиваетсяПриВозрастеДо, 
			ТекДанные.ИсключаяДатуОт, ТекДанные.ВключаяДатуДо);
		ТекДанные.РасчетРазмераВыплатыПредставление = ВыплатыПоДоговорамОпекиКлиентСервер.РасчетРазмераВыплатыПредставление(
			ТекДанные.СпособРасчета, ТекДанные.ПрожиточныйМинимум, ТекДанные.Размер, ТекДанные.Коэффициент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыплатыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	ТекДанные = Элементы.Выплаты.ТекущиеДанные;
	ТекИдентификатор = ТекДанные.ПолучитьИдентификатор();
	Для Каждого СтрокаВыплаты Из Объект.Выплаты Цикл 
		Если СтрокаВыплаты.ПолучитьИдентификатор()<>ТекИдентификатор Тогда 
			Если (СтрокаВыплаты.ВыплачиваетсяПриВозрастеДо=ТекДанные.ВыплачиваетсяПриВозрастеОт И СтрокаВыплаты.ВключаяДатуДо И Не ТекДанные.ИсключаяДатуОт) Тогда 
				Если (СтрокаВыплаты.ВыплачиваетсяПриВозрастеДо=ТекДанные.ВыплачиваетсяПриВозрастеОт И СтрокаВыплаты.ВключаяДатуДо И Не ТекДанные.ИсключаяДатуОт) Тогда 
					ТекстОшибки = СтрШаблон(НСтр("ru = 'День начала выплаты номер %1 накладывается на день окончания выплаты номер %2.'"), 
						ТекДанные.НомерСтроки, СтрокаВыплаты.НомерСтроки);
					ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , 
						СтрШаблон("Объект.Выплаты[%1].ОграниченияПоВозрастуПредставление", ТекДанные.НомерСтроки-1));
				КонецЕсли;
				Если (СтрокаВыплаты.ВыплачиваетсяПриВозрастеОт=ТекДанные.ВыплачиваетсяПриВозрастеДо И Не СтрокаВыплаты.ИсключаяДатуОт И ТекДанные.ВключаяДатуДо) Тогда 
					ТекстОшибки = СтрШаблон(НСтр("ru = 'День окончания выплаты номер %1 накладывается на день начала выплаты номер %2.'"), 
						ТекДанные.НомерСтроки, СтрокаВыплаты.НомерСтроки);
					ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , 
						СтрШаблон("Объект.Выплаты[%1].ОграниченияПоВозрастуПредставление", ТекДанные.НомерСтроки-1));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти