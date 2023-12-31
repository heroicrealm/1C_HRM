#Область СлужебныйПрограммныйИнтерфейс

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "bc98f61b-f15e-4c99-85c2-f84bfb3f8910", Метаданные.Справочники.ВидыДеятельностиСпециалистов);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "4649c663-c7bb-4711-a128-2c777ba5ce95", Метаданные.Справочники.ВидыПроцедурАккредитацииСпециалистов);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "c8062b8f-6742-4931-a8cb-784d2eb190ef", Метаданные.Справочники.ПрофессиональныеСтандарты);
	
КонецПроцедуры

#КонецОбласти

Процедура ПриСозданииНаСервереФормыОбразованиеКвалификация(Форма, РодительскаяГруппа, ГруппаПередКоторойДобавить) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьАккредитациюСпециалистов") Тогда
		Возврат;
	КонецЕсли;
	
	ДобавляемыеРеквизиты = Новый Массив;
	НовыйРеквизит = Новый РеквизитФормы("ФизическоеЛицоАккредитацииТекст", Новый ОписаниеТипов("Строка"));
	НовыйРеквизит.Заголовок = НСтр("ru = 'Аккредитации'");
	ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(Форма, МассивИменРеквизитовФормы);
	ЗарплатаКадры.ИзменитьРеквизитыФормы(Форма, ДобавляемыеРеквизиты, МассивИменРеквизитовФормы);
		
	Если Форма.Команды.Найти("ФизическоеЛицоАккредитацииИзменить") = Неопределено Тогда
		НоваяКоманда = Форма.Команды.Добавить("ФизическоеЛицоАккредитацииИзменить");
		НоваяКоманда.Действие = "Подключаемый_ФизическоеЛицоАккредитацииИзменить";
		НоваяКоманда.Заголовок = НСтр("ru = 'Изменить'");
	КонецЕсли;
	
	ГруппаАккредитации = Форма.Элементы.Найти("ГруппаФизическоеЛицоАккредитацииСпециалиста");
	Если ГруппаАккредитации = Неопределено Тогда

		ГруппаАккредитации = Форма.Элементы.Вставить("ГруппаФизическоеЛицоАккредитацииСпециалиста", Тип("ГруппаФормы"), 
			РодительскаяГруппа, ГруппаПередКоторойДобавить);
		ГруппаАккредитации.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаАккредитации.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
		ГруппаАккредитации.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаАккредитации.ОтображатьЗаголовок = Ложь;
		ГруппаАккредитации.РазрешитьИзменениеСостава = Ложь;
		
		ЭлементНадпись = Форма.Элементы.Вставить("ФизическоеЛицоАккредитацииТекст", Тип("ПолеФормы"), ГруппаАккредитации);
		ЭлементНадпись.ПутьКДанным = "ФизическоеЛицоАккредитацииТекст";
		ЭлементНадпись.Вид = ВидПоляФормы.ПолеНадписи;
		ЭлементНадпись.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		ЭлементНадпись.Высота = 2;
		ЭлементНадпись.РастягиватьПоВертикали = Ложь;
		
		ЭлементКнопка = Форма.Элементы.Вставить("ФизическоеЛицоАккредитацииТекстИзменить", Тип("КнопкаФормы"), ГруппаАккредитации);
		ЭлементКнопка.Вид = ВидКнопкиФормы.Гиперссылка;
		ЭлементКнопка.ИмяКоманды = "ФизическоеЛицоАккредитацииИзменить"; 
		
	КонецЕсли;
	
	Форма.ФизическоеЛицоАккредитацииТекст = 
			РегистрыСведений.СведенияОбАккредитацияхСпециалистов.ПредставлениеАккредитацийСпециалиста(Форма.ФизическоеЛицоСсылка);
		
КонецПроцедуры

#КонецОбласти