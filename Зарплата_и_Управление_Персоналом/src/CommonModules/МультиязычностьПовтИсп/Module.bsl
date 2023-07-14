///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьТипФормы(ИмяФормы) Экспорт
	
	Возврат МультиязычностьСервер.ОпределитьТипФормы(ИмяФормы);
	
КонецФункции

Функция КонфигурацияИспользуетТолькоОдинЯзык(ПредставленияВТабличнойЧасти) Экспорт
	
	Если Метаданные.Языки.Количество() = 1 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПредставленияВТабличнойЧасти Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если МультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык()
		Или МультиязычностьСервер.ИспользуетсяВторойДополнительныйЯзык() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ОбъектНеСодержитТЧПредставления(Ссылка) Экспорт
	
	Возврат Ссылка.Метаданные().ТабличныеЧасти.Найти("Представления") = Неопределено;
	
КонецФункции

Функция СведенияОбЯзыках() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("Язык1", МультиязычностьСервер.КодПервогоДополнительногоЯзыкаИнформационнойБазы());
	Результат.Вставить("Язык2",  МультиязычностьСервер.КодВторогоДополнительногоЯзыкаИнформационнойБазы());
	Результат.Вставить("ОсновнойЯзык", ОбщегоНазначения.КодОсновногоЯзыка());
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

Функция СуффиксЯзыка(Язык) Экспорт
	
	Если Язык = Константы.ДополнительныйЯзык1.Получить() И МультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык() Тогда
		Возврат "Язык1";
	КонецЕсли;
	
	Если Язык = Константы.ДополнительныйЯзык2.Получить() И МультиязычностьСервер.ИспользуетсяВторойДополнительныйЯзык() Тогда
		Возврат "Язык2";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

