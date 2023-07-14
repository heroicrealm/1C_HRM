#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Начальная установка настройки Отражение взаиморасчетов с сотрудниками.
//
// Параметры:
//  ПараметрыОбновления	 - Структура - стандартная структура для отложенного обновления ИБ.
//
Процедура УстановитьНачальноеЗначениеОтражениеВзаиморасчетовССотрудниками(ПараметрыОбновления = Неопределено) Экспорт
	Запись = РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, ВсеНастройки());
	Если Не ЗначениеЗаполнено(Запись.ОтражениеВзаиморасчетовССотрудниками) Тогда 
		Запись.ОтражениеВзаиморасчетовССотрудниками = НастройкаОтражениеВзаиморасчетовССотрудникамиПоУмолчанию();
		УстановитьНастройки(Запись);
	КонецЕсли;	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
КонецПроцедуры

// Устанавливает первоначальные настройки формирования печатных форм.
//
Процедура НачальноеЗаполнение() Экспорт
	
	Запись = РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, ВсеНастройки());
	
	Запись.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов = Истина;
	Запись.НастройкаУпорядочиванияСпискаСотрудников = НастройкаУпорядочиванияСпискаСотрудниковПоУмолчанию();
	Запись.ОтражениеВзаиморасчетовССотрудниками = НастройкаОтражениеВзаиморасчетовССотрудникамиПоУмолчанию();
	
	УстановитьНастройки(Запись);
	
КонецПроцедуры

// Возвращает все настройки
//
Функция ВсеНастройки() Экспорт
	
	Запись = РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.СоздатьМенеджерЗаписи();
	Запись.Прочитать();
	
	Возврат ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(Запись, Метаданные.РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры);
	
КонецФункции

// Возвращает настройки печатных форм.
//
Функция НастройкиПечатныхФорм() Экспорт
	
	Ресурсы = Метаданные.РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.Ресурсы;
	НастройкиПечатныхФорм = Новый Структура;
	НастройкиПечатныхФорм.Вставить(Ресурсы.ВыводитьПолныеФИОВСписочныхПечатныхФормах.Имя);
	НастройкиПечатныхФорм.Вставить(Ресурсы.УдалятьПрефиксыОрганизацииИИБИзНомеровКадровыхПриказов.Имя);
	НастройкиПечатныхФорм.Вставить(Ресурсы.ВыводитьПолнуюИерархиюПодразделений.Имя);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Прочитать();
	
	ЗаполнитьЗначенияСвойств(НастройкиПечатныхФорм, МенеджерЗаписи);
	
	Возврат НастройкиПечатныхФорм;
	
КонецФункции

// Сохраняет настройки
//
Процедура УстановитьНастройки(Настройки) Экспорт
	
	Запись = РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Настройки);
	
	Запись.Записать();
	
КонецПроцедуры

// Возвращает массив описаний полей упорядочивания
//
// Параметры:
//		НастройкаУпорядочиванияСпискаСотрудников - Строка, строка с перечисленными полями упорядочивания, если
//													параметр не указывать, то строка будет получена из настроек.
//
// Возвращаемое значение;
//		Массив	- Коллекция структур с ключами:
//			* КлючПорядка - Строка, полное имя объекта метаданных по которому производится упорядочивание
//			* ПолеПорядка - Строка, имя реквизита объекта метаданных.
//
Функция ПоляУпорядочиванияСпискаСотрудников(НастройкаУпорядочиванияСпискаСотрудников = Неопределено) Экспорт
	
	Если НастройкаУпорядочиванияСпискаСотрудников = Неопределено Тогда
		НастройкаУпорядочиванияСпискаСотрудников = НастройкаУпорядочиванияСпискаСотрудников();
	КонецЕсли; 
	
	НастройкаПорядка = Новый Массив;
	МассивПолейПорядка = СтрРазделить(НастройкаУпорядочиванияСпискаСотрудников, ",");
	Для каждого ПолеПорядка Из МассивПолейПорядка Цикл
		
		СловаПорядка = СтрРазделить(ПолеПорядка, ".");
		
		НомерСлова = 0;
		КлючПорядка = "";
		Пока НомерСлова < СловаПорядка.Количество() - 1 Цикл
			КлючПорядка = ?(ПустаяСтрока(КлючПорядка), "", КлючПорядка + ".") + СловаПорядка[НомерСлова];
			НомерСлова = НомерСлова + 1;
		КонецЦикла; 
		НастройкаПорядка.Добавить(Новый Структура("КлючПорядка,ПолеПорядка", КлючПорядка, СловаПорядка[СловаПорядка.Количество() - 1]));
		
	КонецЦикла;
	
	Возврат НастройкаПорядка;
	
КонецФункции

Функция НастройкаУпорядочиванияСпискаСотрудников() Экспорт
	
	Настройка = "";
	
	ЗапросПолученияНастройки = Новый Запрос(
	"ВЫБРАТЬ
	|	ДополнительныеНастройкиЗарплатаКадры.НастройкаУпорядочиванияСпискаСотрудников КАК НастройкаУпорядочиванияСпискаСотрудников
	|ИЗ
	|	РегистрСведений.ДополнительныеНастройкиЗарплатаКадры КАК ДополнительныеНастройкиЗарплатаКадры");
	РезультатЗапроса = ЗапросПолученияНастройки.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Настройка = Выборка.НастройкаУпорядочиванияСпискаСотрудников;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Настройка) Тогда
		Настройка = НастройкаУпорядочиванияСпискаСотрудниковПоУмолчанию();;
	КонецЕсли;
	
	Возврат Настройка;
	
КонецФункции

Функция НастройкаУпорядочиванияСпискаСотрудниковПоУмолчанию()
	Возврат "Справочник.ПодразделенияОрганизаций.РеквизитДопУпорядочиванияИерархического,Справочник.Должности.РеквизитДопУпорядочивания,Справочник.Сотрудники.Наименование";
КонецФункции

Функция ОтражениеВзаиморасчетовССотрудниками() Экспорт
	ЗапросПолученияНастройки = Новый Запрос(
	"ВЫБРАТЬ
	|	ДополнительныеНастройкиЗарплатаКадры.ОтражениеВзаиморасчетовССотрудниками КАК ОтражениеВзаиморасчетовССотрудниками
	|ИЗ
	|	РегистрСведений.ДополнительныеНастройкиЗарплатаКадры КАК ДополнительныеНастройкиЗарплатаКадры");
	РезультатЗапроса = ЗапросПолученияНастройки.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ВариантСальдо = Перечисления.ВариантыОтраженияВзаиморасчетовССотрудниками.ПоМесяцамРасчетаЗарплаты;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ВариантСальдо = Выборка.ОтражениеВзаиморасчетовССотрудниками;
		Если ВариантСальдо = Перечисления.ВариантыОтраженияВзаиморасчетовССотрудниками.ПустаяСсылка() Тогда
			ВариантСальдо = Перечисления.ВариантыОтраженияВзаиморасчетовССотрудниками.ПоМесяцамРасчетаЗарплаты;
		КонецЕсли;
	КонецЕсли;
	Возврат ВариантСальдо;
	
КонецФункции

Функция НастройкаОтражениеВзаиморасчетовССотрудникамиПоУмолчанию()
	Возврат Перечисления.ВариантыОтраженияВзаиморасчетовССотрудниками.ПоМесяцамРасчетаЗарплаты;
КонецФункции

#КонецОбласти

#КонецЕсли
