
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		Объект.Округление = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли	

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриПолученииДанныхНаСервере()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособПолученияПриИзменении(Элемент)
	НастроитьЭлементыФормы(ЭтаФорма)
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	НастроитьЭлементыФормы(ЭтаФорма)
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма)
	ВидДокументаОснованияОбязателен = 
		Форма.Объект.СпособПолучения = 
		ПредопределенноеЗначение("Перечисление.СпособыПолученияЗарплатыКВыплате.ОтдельныйРасчет");
	Форма.Элементы.ВидДокументаОснования.АвтоОтметкаНезаполненного = ВидДокументаОснованияОбязателен;
	Форма.Элементы.ВидДокументаОснования.ОтметкаНезаполненного = 
		ВидДокументаОснованияОбязателен 
		И НЕ ЗначениеЗаполнено(Форма.Объект.ВидДокументаОснования)
КонецПроцедуры

#КонецОбласти

