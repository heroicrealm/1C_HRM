///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.КлиентЛицензированияВызовСервера.
//
// Серверные процедуры и функции настройки клиента лицензирования.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает признак "синхронизированности" настроек клиента лицензирования
// и признак возможности подключения Интернет-поддержки текущим пользователем.
//
Функция ПроверитьНастройкиКлиентаЛицензирования() Экспорт
	
	РезультатПроверки = КлиентЛицензирования.ПроверитьНастройкиКлиентаЛицензирования();
	Возврат Новый Структура(
		"НастройкиСинхронизированы, ПравоПодключенияИПП",
		РезультатПроверки,
		ИнтернетПоддержкаПользователей.ДоступноПодключениеИнтернетПоддержки());
	
КонецФункции

#КонецОбласти
