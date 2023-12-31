#Область ПрограммныйИнтерфейс

// Обновляет подключаемые команды формы, меня пиктограммы у команд печати с присоединенным файлом.
//
// Параметры:
//  УправляемаяФорма               - УправляемаяФорма
//  ОбъектФормы                    - ДанныеФормыСтруктура, основной объект формы
//                                 - ДинамическийСписок, формы списка
//  ВыполнитьСтандартныйОбработчик - Булево
//
Процедура ОбновитьКоманды(УправляемаяФорма, ОбъектФормы, ВыполнитьСтандартныйОбработчик) Экспорт
	
	Если ВыполнитьСтандартныйОбработчик Тогда
		ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(УправляемаяФорма, ОбъектФормы);
	КонецЕсли;
	
	Структура = Новый Структура("ПараметрыПодключаемыхКоманд,ИдентификаторыФайловСЭЦП", Null, Null);
	ЗаполнитьЗначенияСвойств(Структура, УправляемаяФорма);
	ПараметрыПодключаемыхКоманд = Структура.ПараметрыПодключаемыхКоманд;
	Если ТипЗнч(ПараметрыПодключаемыхКоманд) <> Тип("Структура")
		Или Структура.ИдентификаторыФайловСЭЦП = Null Тогда
		
		Возврат;
	КонецЕсли;
	
	ИдентификаторыФайловСЭЦП = Структура.ИдентификаторыФайловСЭЦП;
	Для Каждого Подменю Из ПараметрыПодключаемыхКоманд.ПодменюСУсловиямиВидимости Цикл
		
		Для Каждого ОписаниеКоманды Из Подменю.КомандыСУсловиямиВидимости Цикл
			
			ЭлементФормы = УправляемаяФорма.Элементы.Найти(ОписаниеКоманды.ИмяВФорме);
			Если ЭлементФормы <> Неопределено И ЭлементФормы.Видимость Тогда
				
				Для Каждого Условие Из ОписаниеКоманды.УсловияВидимости Цикл
					
					Если Не СтрНачинаетсяС(Условие.Реквизит, "ПечатнаяФорма_") Тогда
						Продолжить;
					КонецЕсли;
					
					Если ОбъектФормы.Свойство(Условие.Реквизит) Тогда
						Продолжить;
					КонецЕсли;
					
					Если ИдентификаторыФайловСЭЦП <> Неопределено Тогда
						ЗначениеКлюча = ИдентификаторыФайловСЭЦП.Получить(Условие.Реквизит) = Истина;
					Иначе
						ЗначениеКлюча = Ложь;
					КонецЕсли;
					
					Если ЗначениеКлюча <> Условие.Значение Тогда
						
						ЭлементФормы.Видимость = Ложь;
						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ТолькоИдентификаторПечатнойФормы(ИдентификаторПечатнойФормы) Экспорт
	
	ПозицияТочки = СтрНайти(ИдентификаторПечатнойФормы, ".", НаправлениеПоиска.СКонца);
	Если ПозицияТочки > 0 Тогда
		Возврат Сред(ИдентификаторПечатнойФормы, ПозицияТочки + 1);
	КонецЕсли;
	
	Возврат ИдентификаторПечатнойФормы;
	
КонецФункции

Функция ЭтоИдентификаторыЭлектронногоДокумента(Знач ИдентификаторПечатнойФормы) Экспорт
	
	Возврат КадровыйЭДОВызовСервера.НастройкиПечатныхФорм().Получить(
		ТолькоИдентификаторПечатнойФормы(ИдентификаторПечатнойФормы)) <> Неопределено;
	
КонецФункции

Функция ИмяДействияУведомленияОзнакомитьсяИПодписать() Экспорт
	Возврат "ДействиеУведомленияОзнакомитьсяИПодписать";
КонецФункции

Процедура ОбновитьИнформационнуюНадписьОВозможностиРедактированияПечатнойФормы(УправляемаяФорма) Экспорт
	
	Защита = Ложь;
	Для Каждого НастройкаПечатнойФормы Из УправляемаяФорма.НастройкиПечатныхФорм Цикл
		Если УправляемаяФорма[НастройкаПечатнойФормы.ИмяРеквизита].Защита Тогда
			Защита = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		ПрефиксЭлементовОВозможностиРедактирования() + "Группа",
		"Видимость",
		Защита);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		ПрефиксЭлементовОВозможностиРедактирования() + "КомандаРедактирования",
		"Видимость",
		Не Защита);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		УправляемаяФорма.Элементы,
		"КнопкаРедактирование",
		"Видимость",
		Ложь);
	
КонецПроцедуры

Функция ПрефиксЭлементовОВозможностиРедактирования() Экспорт
	Возврат "ИнформацияОДоступностиРедактирования";
КонецФункции

#КонецОбласти