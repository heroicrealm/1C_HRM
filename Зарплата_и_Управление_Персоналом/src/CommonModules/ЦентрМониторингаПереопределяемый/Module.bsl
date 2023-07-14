///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняется при запуске регламентного задания.
//
Процедура ПриСбореПоказателейСтатистикиКонфигурации() Экспорт
	ЗарплатаКадры.ПриСбореПоказателейСтатистикиКонфигурации();
КонецПроцедуры

// Задает настройки, применяемые как умолчания для объектов подсистемы.
//
// Параметры:
//   Настройки - Структура - коллекция настроек подсистемы. Реквизиты:
//       * ВключитьОповещение - Булево - умолчание для оповещений пользователя:
//           Истина - По умолчанию оповещаем администратора системы, например, если нет подсистемы "Текущие дела".
//           Ложь   - По умолчанию не оповещаем администратора системы.
//           Значение по умолчанию: зависит от наличия подсистемы "Текущие дела".                              
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
