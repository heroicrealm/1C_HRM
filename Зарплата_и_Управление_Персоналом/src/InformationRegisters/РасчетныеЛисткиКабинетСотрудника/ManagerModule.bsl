#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти
	
	
#Область СлужебныеПроцедурыИФункции

Функция МесяцПубликацииРасчетныхЛистков() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(РасчетныеЛисткиКабинетСотрудника.Месяц) КАК Месяц
	|ИЗ
	|	РегистрСведений.РасчетныеЛисткиКабинетСотрудника КАК РасчетныеЛисткиКабинетСотрудника
	|ГДЕ
	|	РасчетныеЛисткиКабинетСотрудника.СостояниеПубликации = ЗНАЧЕНИЕ(Перечисление.СостоянияРасчетныхЛистковКабинетСотрудника.Опубликован)";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Месяц;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции


#КонецОбласти

#КонецЕсли



