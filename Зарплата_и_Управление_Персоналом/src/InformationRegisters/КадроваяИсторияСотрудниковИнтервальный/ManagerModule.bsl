
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ГоловнаяОрганизация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьИнтервал(ИмяРегистра, ТекущийИнтервал, Источник, ДатаНачала) Экспорт
	
	Если ИмяРегистра <> Метаданные.РегистрыСведений.КадроваяИсторияСотрудников.Имя Тогда
		Возврат;
	КонецЕсли;
	
	Если ДатаНачала <> Источник.ПериодЗаписи 
		И ТекущийИнтервал.Свойство("ВидСобытия")
		И ТекущийИнтервал.ВидСобытия <> Перечисления.ВидыКадровыхСобытий.Увольнение Тогда
		
		ТекущийИнтервал.ВидСобытия = Перечисления.ВидыКадровыхСобытий.Перемещение;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбменДанными

// Пересчитывает зависимые данные после загрузки сообщения обмена
//
// Параметры:
//		ЗависимыеДанные - ТаблицаЗначений:
//			* ВедущиеМетаданные - ОбъектМетаданных - Метаданные ведущих данных
//			* ЗависимыеМетаданные - ОбъектМетаданных - Метаданные текущего объекта
//			* ВедущиеДанные - Массив объектов, заполненный при загрузке сообщения обмена
//				по этим объектам требуется обновить зависимые данные
//
Процедура ОбновитьЗависимыеДанныеПослеЗагрузкиОбменаДанными(ЗависимыеДанные) Экспорт
	
	ЗарплатаКадрыПериодическиеРегистры.ОбновитьИнтервальныйРегистрПослеЗагрузкиПервичныхДанных(
		Метаданные.РегистрыСведений.КадроваяИсторияСотрудников.Имя, ЗависимыеДанные);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
