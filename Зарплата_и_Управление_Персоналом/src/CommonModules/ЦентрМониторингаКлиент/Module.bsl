///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПрограммныйИнтерфейсБизнесСтатистики

// Записывает операцию бизнес статистики в кэш на клиенте.
// Запись в информационную базу происходит по обработчику ОбработчикОжиданияСтандартныхПериодическихПроверок
// глобального модуля СтандартныеПодсистемыГлобальный.
// При закрытии приложения данные не записываются.
//
// Параметры:
//  ИмяОперации	- Строка	- имя операции статистики, в случае отсутствия создается новое.
//  Значение	- Число		- количественное значение операции статистики.
//
Процедура ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение) Экспорт
    
    Если РегистрироватьБизнесСтатистику() Тогда 
        ПараметрыЗаписи = Новый Структура("ИмяОперации,Значение, ТипЗаписи");
        ПараметрыЗаписи.ИмяОперации = ИмяОперации;
        ПараметрыЗаписи.Значение = Значение;
        ПараметрыЗаписи.ТипЗаписи = 0;
        
        ЗаписатьОперациюБизнесСтатистикиСлужебная(ПараметрыЗаписи);
    КонецЕсли;
    
КонецПроцедуры

// Записывает уникальную операцию бизнес статистики в разрезе часа в кэш на клиенте.
// При записи проверяет уникальность.
// Запись в информационную базу происходит по обработчику ОбработчикОжиданияСтандартныхПериодическихПроверок
// глобального модуля СтандартныеПодсистемыГлобальный.
// При закрытии приложения данные не записываются.
//
// Параметры:
//  ИмяОперации      - Строка - имя операции статистики, в случае отсутствия создается новое.
//  Значение         - Число  - количественное значение операции статистики.
//  Замещать         - Булево - определяет режим замещения существующей записи.
//                              Истина - перед записью существующая запись будет удалена.
//                              Ложь - если запись уже существует, новые данные игнорируются.
//                              Значение по умолчанию: Ложь.
//  КлючУникальности - Строка - ключ для контроля уникальности записи, максимальная длина 100. Если не задан,
//                              используется хеш MD5 уникального идентификатора пользователя и номера сеанса.
//                              Значение по умолчанию: Неопределено.
//
Процедура ЗаписатьОперациюБизнесСтатистикиЧас(ИмяОперации, Значение, Замещать = Ложь, КлючУникальности = Неопределено) Экспорт
    
    Если РегистрироватьБизнесСтатистику() Тогда
        ПараметрыЗаписи = Новый Структура("ИмяОперации, КлючУникальности, Значение, Замещать, ТипЗаписи");
        ПараметрыЗаписи.ИмяОперации = ИмяОперации;
        ПараметрыЗаписи.КлючУникальности = КлючУникальности;
        ПараметрыЗаписи.Значение = Значение;
        ПараметрыЗаписи.Замещать = Замещать;
        ПараметрыЗаписи.ТипЗаписи = 1;
        
        ЗаписатьОперациюБизнесСтатистикиСлужебная(ПараметрыЗаписи);
    КонецЕсли;
    
КонецПроцедуры

// Записывает уникальную операцию бизнес статистики в разрезе суток в кэш на клиенте.
// При записи проверяет уникальность.
// Запись в информационную базу происходит по обработчику ОбработчикОжиданияСтандартныхПериодическихПроверок
// глобального модуля СтандартныеПодсистемыГлобальный.
// При закрытии приложения данные не записываются.
//
// Параметры:
//  ИмяОперации      - Строка - имя операции статистики, в случае отсутствия создается новое.
//  Значение         - Число  - количественное значение операции статистики.
//  Замещать         - Булево - определяет режим замещения существующей записи.
//                              Истина - перед записью существующая запись будет удалена.
//                              Ложь - если запись уже существует, новые данные игнорируются.
//                              Значение по умолчанию: Ложь.
//  КлючУникальности - Строка - ключ для контроля уникальности записи, максимальная длина 100. Если не задан,
//                              используется хеш MD5 уникального идентификатора пользователя и номера сеанса.
//                              Значение по умолчанию: Неопределено.
//
Процедура ЗаписатьОперациюБизнесСтатистикиСутки(ИмяОперации, Значение, Замещать = Ложь, КлючУникальности = Неопределено) Экспорт
    
    Если РегистрироватьБизнесСтатистику() Тогда
        ПараметрыЗаписи = Новый Структура("ИмяОперации, КлючУникальности, Значение, Замещать, ТипЗаписи");
        ПараметрыЗаписи.ИмяОперации = ИмяОперации;
        ПараметрыЗаписи.КлючУникальности = КлючУникальности;
        ПараметрыЗаписи.Значение = Значение;
        ПараметрыЗаписи.Замещать = Замещать;
        ПараметрыЗаписи.ТипЗаписи = 2;
        
        ЗаписатьОперациюБизнесСтатистикиСлужебная(ПараметрыЗаписи);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьОперациюБизнесСтатистикиСлужебная(ПараметрыЗаписи)
    
    ЦентрМониторингаПараметрыПриложения = ЦентрМониторингаКлиентСлужебный.ПолучитьПараметрыПриложения();
    Замеры = ЦентрМониторингаПараметрыПриложения["Замеры"][ПараметрыЗаписи.ТипЗаписи];
    
    Замер = Новый Структура("ТипЗаписи, Ключ, ОперацияСтатистики, Значение, Замещать");
    Замер.ТипЗаписи = ПараметрыЗаписи.ТипЗаписи;
    Замер.ОперацияСтатистики = ПараметрыЗаписи.ИмяОперации;
    Замер.Значение = ПараметрыЗаписи.Значение;
    
    Если Замер.ТипЗаписи = 0 Тогда
        
        Замеры.Добавить(Замер);
        
    Иначе
        
        Если ПараметрыЗаписи.КлючУникальности = Неопределено Тогда
            Замер.Ключ = ЦентрМониторингаПараметрыПриложения["ИнформацияКлиента"]["ПараметрыКлиента"]["ХешПользователя"];
        Иначе
            Замер.Ключ = ПараметрыЗаписи.КлючУникальности;
        КонецЕсли;
        
        Замер.Замещать = ПараметрыЗаписи.Замещать;
        
        Если НЕ (Замеры[Замер.Ключ] <> Неопределено И НЕ Замер.Замещать) Тогда
            Замеры.Вставить(Замер.Ключ, Замер);
        КонецЕсли;
        
    КонецЕсли;
        
КонецПроцедуры

Функция  РегистрироватьБизнесСтатистику()
    
    ИмяПараметра = "СтандартныеПодсистемы.ЦентрМониторинга";
    
    Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
        ПараметрыПриложения.Вставить(ИмяПараметра, ЦентрМониторингаКлиентСлужебный.ПолучитьПараметрыПриложения());
    КонецЕсли;
        
    Возврат ПараметрыПриложения[ИмяПараметра]["РегистрироватьБизнесСтатистику"];
    
КонецФункции

Процедура ПослеОбновленияИдентификатора(Результат, ДополнительныеПараметры) Экспорт	
	Если Результат <> Неопределено Тогда
		Оповестить("ОбновлениеИдентификатораЦентрМониторинга", Результат);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти