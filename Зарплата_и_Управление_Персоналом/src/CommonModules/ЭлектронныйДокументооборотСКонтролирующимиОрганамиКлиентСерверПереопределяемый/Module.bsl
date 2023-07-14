
#Область ПрограммныйИнтерфейс

// Функция возвращает ссылку на документ по заданной форме.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, отображающая данные документа, ссылку на
//                                       который требутеся вернуть.
//
// Результат:
//  Ссылка на документ.
//
// Пример:
//  Возврат Форма.Объект.Ссылка;
// 
Функция ПолучитьСсылкуНаОтправляемыйДокументПоФорме(Форма) Экспорт
	
	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "Объект")
		И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.Объект, "Ссылка") Тогда
		Возврат Форма.Объект.Ссылка;
	Иначе
		Возврат ПерсонифицированныйУчетКлиентСервер.ПолучитьСсылкуНаОтправляемыйДокументПоФорме(Форма);
	КонецЕсли;
	
КонецФункции

// Функция возвращает ссылку на организацию-отправитель документа по заданной форме.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой производится отправка.
//
// Результат:
//  СправочникСсылка.Организации,
//	Неопределено, если получить ссылку на организацию не получилось
//
Функция ПолучитьСсылкуНаОрганизациюОтправляемогоДокументаПоФорме(Форма) Экспорт
	
КонецФункции

// Функция возвращает строкой имя объекта метаданных.
// 
// 
// Параметры:
//	Имя - строка, условное имя объекта
//	Возможные варианты:
//		УведомлениеОКонтролируемыхСделках
//		РеестрСведенийНаВыплатуПособийФСС
//		СправкиНДФЛДляПередачиВНалоговыйОрган
//
// Результат:
//	Строка, имя объекта метаданных, если объект данного вида присутствует в конфигурации данного прикладного решения
//	Неопределено, если объект данного вида отсутствует в конфигурации данного прикладного решения
// 
// Пример:
// 	Если Имя = "СправкиНДФЛДляПередачиВНалоговыйОрган" Тогда 
//		Возврат "СправкиНДФЛДляПередачиВНалоговыйОрган";
//	Иначе
//		Возврат Неопределено;
//	КонецЕсли;
Функция ИмяОбъектаМетаданных(Имя) Экспорт
	
	Если Имя = "СправкиНДФЛДляПередачиВНалоговыйОрган" Тогда 
		Возврат "СправкиНДФЛДляПередачиВНалоговыйОрган";
	ИначеЕсли Имя = "ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ" Тогда
		Возврат "ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ";
	ИначеЕсли Имя = "РеестрСведенийНаВыплатуПособийФСС" Тогда 
		Возврат "РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий";
	ИначеЕсли Имя = "РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам" Тогда
		Возврат "РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам";
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Функция возвращает тип организации
//
// Параметры
//  Отсутствуют
//
// Возвращаемое значение:
//   Тип   - тип организации в данной базе
//
Функция ТипОрганизации() Экспорт
	
	Возврат Тип("СправочникСсылка.Организации");
	
КонецФункции

// Функция возвращает тип физ лица
//
// Параметры
//  Отсутствуют
//
// Возвращаемое значение:
//   Тип   - тип физ лица в данной базе
//
Функция ТипФизЛица() Экспорт
	
	Возврат Тип("СправочникСсылка.ФизическиеЛица");
	
КонецФункции

#Область ДокументыПоТребованиюФНС

// Определяет соответствие между видом документа ФНС и массивом типов ссылок на соответствующие объекты метаданных
//
// Параметры:
//  СоответствиеВидовДокументов  - Соответствие, значения соответствия требуется переопределить
//
//	Ключ		- ПеречислениеСсылка.ВидыПредставляемыхДокументов
//	 Значение	- Массив, 
//			элементы массива	- Тип, тип ссылки на объект метаданных. 
//
Процедура ОпределитьСоответствиеТиповИсточниковВидамДокументовФНС(СоответствиеВидовДокументов) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти
