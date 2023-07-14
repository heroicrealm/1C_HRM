#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РегистрыСведений.ОснованияУвольненияВАрхиве.ПоместитьОснованиеУвольненияВАрхив(
		Объект.Ссылка, БольшеНеИспользуется);
	
	ДанныеВРеквизиты();
	УстановитьОтображениеЭлементов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Объект.Ссылка, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПрежнийДокументОснование) Тогда
		ПрежнийДокументОснование = Объект.ДокументОснование;
	КонецЕсли;
	
	ЗаполнитьНаименованияДокументаОснованияНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура НормативныйДокументОтсутствуетВКлассификатореПриИзменении(Элемент)
	
	Если НормативныйДокументОтсутствуетВКлассификаторе Тогда
		Объект.ДокументОснование = ПредопределенноеЗначение("Перечисление.НормативныеДокументыОснованийКадровыхПриказов.ПустаяСсылка");
	Иначе
		
		Объект.НаименованиеДокументаОснования = "";
		Объект.НаименованиеДокументаОснованияВРодительномПадеже = "";
		Объект.ДокументОснование = ПрежнийДокументОснование;
		ЗаполнитьНаименованияДокументаОснованияНаКлиенте();
		
	КонецЕсли;
	
	УстановитьОтображениеЭлементов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастьПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодпунктПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АбзацПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовАдреса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеИспользуетсяПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ДанныеВРеквизиты();
	УстановитьОтображениеЭлементов(ЭтотОбъект);
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ОснованияУвольненияВАрхиве) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"БольшеНеИспользуется",
			"ТолькоПросмотр",
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	ПрежнийДокументОснование = Объект.ДокументОснование;
	ЗаполнитьНаименованияДокументаОснования();
	НормативныйДокументОтсутствуетВКлассификаторе =
		Не ЗначениеЗаполнено(Объект.ДокументОснование)
		И (ЗначениеЗаполнено(Объект.НаименованиеДокументаОснования)
			Или ЗначениеЗаполнено(Объект.НаименованиеДокументаОснованияВРодительномПадеже));
	
	БольшеНеИспользуется = РегистрыСведений.ОснованияУвольненияВАрхиве.ОснованиеВАрхиве(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементов(УправляемаяФорма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ДокументОснование",
		"Доступность",
		Не УправляемаяФорма.НормативныйДокументОтсутствуетВКлассификаторе);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"ДокументОснование",
		"АвтоОтметкаНезаполненного",
		Не УправляемаяФорма.НормативныйДокументОтсутствуетВКлассификаторе);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"НаименованиеДокументаОснования",
		"Доступность",
		УправляемаяФорма.НормативныйДокументОтсутствуетВКлассификаторе);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"НаименованиеДокументаОснования",
		"АвтоОтметкаНезаполненного",
		УправляемаяФорма.НормативныйДокументОтсутствуетВКлассификаторе);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"НаименованиеДокументаОснованияВРодительномПадеже",
		"Доступность",
		УправляемаяФорма.НормативныйДокументОтсутствуетВКлассификаторе);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"НаименованиеДокументаОснованияВРодительномПадеже",
		"АвтоОтметкаНезаполненного",
		УправляемаяФорма.НормативныйДокументОтсутствуетВКлассификаторе);
	
	УстановитьОтображениеЭлементовАдреса(УправляемаяФорма);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"БольшеНеИспользуется",
		"Доступность",
		ЗначениеЗаполнено(УправляемаяФорма.Объект.Ссылка));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементовАдреса(УправляемаяФорма)
	
	Если ЗначениеЗаполнено(УправляемаяФорма.Объект.Статья)
		Или ЗначениеЗаполнено(УправляемаяФорма.Объект.Часть)
		Или ЗначениеЗаполнено(УправляемаяФорма.Объект.Пункт)
		Или ЗначениеЗаполнено(УправляемаяФорма.Объект.Подпункт)
		Или ЗначениеЗаполнено(УправляемаяФорма.Объект.Абзац) Тогда
		
		АвтоОтметкаНезаполненного = Ложь;
	Иначе
		АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"Статья",
		"АвтоОтметкаНезаполненного",
		АвтоОтметкаНезаполненного);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"Часть",
		"АвтоОтметкаНезаполненного",
		АвтоОтметкаНезаполненного);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"Пункт",
		"АвтоОтметкаНезаполненного",
		АвтоОтметкаНезаполненного);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"Подпункт",
		"АвтоОтметкаНезаполненного",
		АвтоОтметкаНезаполненного);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"Абзац",
		"АвтоОтметкаНезаполненного",
		АвтоОтметкаНезаполненного);
	
	Если Не АвтоОтметкаНезаполненного Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			УправляемаяФорма.Элементы,
			"Статья",
			"ОтметкаНезаполненного",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			УправляемаяФорма.Элементы,
			"Часть",
			"ОтметкаНезаполненного",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			УправляемаяФорма.Элементы,
			"Пункт",
			"ОтметкаНезаполненного",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			УправляемаяФорма.Элементы,
			"Подпункт",
			"ОтметкаНезаполненного",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			УправляемаяФорма.Элементы,
			"Абзац",
			"ОтметкаНезаполненного",
			Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаименованияДокументаОснованияНаКлиенте()
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ЗаполнитьНаименованияДокументаОснования();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаименованияДокументаОснования()
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		Объект.НаименованиеДокументаОснования =
			Перечисления.НормативныеДокументыОснованийКадровыхПриказов.НормативныйДокумент(
				Объект.ДокументОснование);
		
		Объект.НаименованиеДокументаОснованияВРодительномПадеже =
			Перечисления.НормативныеДокументыОснованийКадровыхПриказов.НормативныйДокументВРодительномПадеже(
				Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти