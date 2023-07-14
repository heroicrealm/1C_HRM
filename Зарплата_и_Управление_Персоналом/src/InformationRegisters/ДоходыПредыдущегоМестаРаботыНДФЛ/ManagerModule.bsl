
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область РегистрацияФизическихЛиц

// АПК:299-выкл: Особенности иерархии библиотек

Функция РеквизитГоловнаяОрганизация() Экспорт
	Возврат Метаданные.РегистрыСведений.ДоходыПредыдущегоМестаРаботыНДФЛ.Измерения.ГоловнаяОрганизация.Имя;
КонецФункции

Функция РеквизитФизическоеЛицо() Экспорт
	Возврат Метаданные.РегистрыСведений.ДоходыПредыдущегоМестаРаботыНДФЛ.Измерения.ФизическоеЛицо.Имя;
КонецФункции

// АПК:299-вкл

#КонецОбласти

#КонецОбласти

#КонецЕсли
