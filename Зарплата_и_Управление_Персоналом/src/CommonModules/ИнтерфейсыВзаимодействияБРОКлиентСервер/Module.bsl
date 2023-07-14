
#Область ПрограммныйИнтерфейс

// Возвращает начало периода даты.
//
// Параметры:
//   Периодичность - Перечисление.Периодичность - периодичность.
//   Дата - Дата - дата.
//
// Возвращаемое значение:
//   Дата - начало периода даты.
//
Функция НачалоПериода(Периодичность, Дата) Экспорт
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Возврат НачалоГода(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		НомерМесяца = Месяц(Дата);
		
		Если НомерМесяца < 7 Тогда
			Возврат НачалоГода(Дата);
		Иначе
			Возврат ДобавитьМесяц(НачалоГода(Дата), 6);
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Возврат НачалоКвартала(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Возврат НачалоМесяца(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		Возврат НачалоНедели(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		День = 24 * 60 * 60; // Количество секунд в дне
		
		НомерДня = День(Дата);
		
		Если НомерДня <= 10 Тогда
			Возврат НачалоМесяца(Дата);
		ИначеЕсли НомерДня <= 20 Тогда
			Возврат НачалоМесяца(Дата) + 10 * День;
		Иначе
			Возврат НачалоМесяца(Дата) + 20 * День;
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Возврат НачалоДня(Дата);
		
	Иначе
		
		Возврат Дата;
		
	КонецЕсли;
	
КонецФункции

// Возвращает конец периода.
//
Функция КонецПериода(Периодичность, Дата) Экспорт
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Возврат КонецГода(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		НомерМесяца = Месяц(Дата);
		Если НомерМесяца < 7 Тогда
			Возврат КонецМесяца(ДобавитьМесяц(НачалоГода(Дата), 5));
		Иначе
			Возврат КонецГода(Дата);
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Возврат КонецКвартала(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Возврат КонецМесяца(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		Возврат КонецНедели(Дата);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		День = 24 * 60 * 60; // Количество секунд в дне
		
		НомерДня = День(Дата);
		Если НомерДня <= 10 Тогда
			Возврат НачалоМесяца(Дата) + 10 * День - 1;
		ИначеЕсли НомерДня <= 20 Тогда
			Возврат НачалоМесяца(Дата) + 20 * День - 1;
		Иначе
			Возврат КонецМесяца(Дата);
		КонецЕсли;
		
	Иначе
		
		Возврат КонецДня(Дата);
		
	КонецЕсли;
	
КонецФункции

// Добавляет период.
//
Функция ДобавитьПериод(Знач Дата, Периодичность, Знач КоличествоПериодов = 1) Экспорт
	
	Если КоличествоПериодов = 0 Тогда
		КоличествоПериодов = 1;
	КонецЕсли;
	
	День = 24 * 60 * 60; // Количество секунд в дне
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Возврат ДобавитьМесяц(Дата, 12 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		Возврат ДобавитьМесяц(Дата, 6 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Возврат ДобавитьМесяц(Дата, 3 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Возврат ДобавитьМесяц(Дата, 1 * КоличествоПериодов);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		Возврат Дата + 7 * День * КоличествоПериодов;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		Возврат Дата + 10 * День * КоличествоПериодов;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Возврат Дата + 1 * День * КоличествоПериодов;
		
	КонецЕсли;
	
КонецФункции

// Возвращает операции регламентированного отчета с признаками их доступности.
//
// Параметры:
//   ИмяОтчета - Строка - имя регламентированного отчета, например, "РегламентированныйОтчет4ФСС".
//   ИмяФормы - Строка - имя формы регламентированного отчета, например, "ФормаОтчета2017Кв1".
//
// Возвращаемое значение:
//   ФиксированнаяСтруктура - операции с регламентированным отчетом.
//	   * АвтоФормированиеНаСервере - Булево - признак автоматического формирования отчета в тихом режиме на сервере.
//	   * ВыгрузкаНаСервере - Булево - признак выгрузки отчета в тихом режиме на сервере.
//	   * ПечатьСоШтрихкодомPDF417НаСервере - Булево - признак печати отчета со штрихкодом PDF417 в тихом режиме
//													  на сервере.
//	   * ПечатьБезШтрихкодаPDF417НаСервере - Булево - признак печати отчета без штрихкода PDF417 в тихом режиме
//													  на сервере.
//
Функция ОперацииСРегламентированнымОтчетом(ИмяОтчета, ИмяФормы) Экспорт
			    	
	Возврат РегламентированнаяОтчетностьКлиентСервер.ОперацииСРегламентированнымОтчетом(ИмяОтчета, ИмяФормы);
							        		                                                                                                                        						
КонецФункции

// Определяет, можно ли использовать функцинал формирования пакета для ФНС для внесения изменений в ЕГРЮЛ
// 
// Возвращаемое значение:
//  Булево - Истина, если можно использовать.
//
Функция ПоддерживаетсяФормированиеПакетаДляВнесенияИзмененийВЕГРЮЛ() Экспорт
	
	Возврат ДокументооборотСКОКлиентСервер.ПоддерживаетсяФормированиеПакетаДляВнесенияИзмененийВЕГРЮЛ();
	
КонецФункции

// Содержит реестр ошибок возникающие во время формирования пакет для для внесения изменений в ЕГРЮЛ.
// Используется в поле "ТипОшибки" в возвращаемом значении функции ПараметрыМетодаСформироватьПакетПоЕГРЮЛ.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура
//
Функция КлассификаторОшибокПакетаПоЕГРЮЛ() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НеклассифицированнаяОшибка", 0);
	Результат.Вставить("ОтсутствуютДействующиеСертификаты", 1);
	Результат.Вставить("ОтсутствуютСертификаты", 2);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#Область ПроцедурыИФункцииСпискаЗадачБухгалтера

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции интерфейса взаимодействия с сервисом "Список задач
// бухгалтера".

// Определяет строковой статус объекта регламентированной отчетности,
// предназначенный для интерактивного изменения пользователем,
// соответствующий финальному статусу.
// 
// Возвращаемое значение:
//  Строка - строковое представление статуса, предназначенное для программной обработки.
//
Функция СтатусСданоСтрокой() Экспорт
	
	Возврат "Сдано"; // См. РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе
	
КонецФункции

// Определяет строковой статус объекта регламентированной отчетности,
// предназначенный для интерактивного изменения пользователем,
// соответствующий статусу отчета, находящегося в процессе подготовки.
// 
// Возвращаемое значение:
//  Строка - строковое представление статуса, предназначенное для программной обработки.
//
Функция СтатусВРаботеСтрокой() Экспорт
	
	Возврат "В работе"; // См. РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе
	
КонецФункции

// Определяет строковый статус объекта регламентированной отчетности,
// предназначенный для интерактивного изменения пользователем,
// соответствующий статусу подготовленной отчетности.
// 
// Возвращаемое значение:
//  Строка - строковое представление статуса, предназначенное для программной обработки.
//
Функция СтатусПодготовленоСтрокой() Экспорт
	
	Возврат "Подготовлено"; // См. РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе
	
КонецФункции

// Пользовательское представление статуса объекта регламентированной отчетности,
// соответствующего статусу по умолчанию.
// 
// Возвращаемое значение:
//  Строка - строковое представление статуса пользователю.
//
Функция ПредставлениеСтатусаНеОтправлено() Экспорт
	
	Возврат НСтр("ru = 'Не отправлено'");
	
КонецФункции

// Пользовательское представление строкового статуса объекта регламентированной отчетности,
// предназначенного для интерактивного изменения пользователем,
// соответствующего финальному статусу.
// 
// Возвращаемое значение:
//  Строка - строковое представление статуса пользователю.
//
Функция ПредставлениеСтатусаСдано() Экспорт
	
	// См. РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе.
	Возврат НСтр("ru = 'Сдано'");
	
КонецФункции

// Пользовательское представление строкового статуса объекта регламентированной отчетности,
// предназначенного для интерактивного изменения пользователем,
// соответствующего статусу отчета, находящегося в процессе подготовки.
// 
// Возвращаемое значение:
//  Строка - строковое представление статуса пользователю.
//
Функция ПредставлениеСтатусаВРаботе() Экспорт
	
	// См. РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе.
	Возврат НСтр("ru = 'В работе'"); 
	
КонецФункции

// Пользовательское представление строкового статуса объекта регламентированной отчетности,
// предназначенного для интерактивного изменения пользователем,
// соответствующего статусу подготовленной отчетности.
// 
// Возвращаемое значение:
//  Строка - строковое представление статуса пользователю.
//
Функция ПредставлениеСтатусаПодготовлено() Экспорт
	
	// См. РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе.
	Возврат НСтр("ru = 'Подготовлено'");
	
КонецФункции

// Конструктор коллекции со сведениями о состоянии передачи в учреждение отчета или иного документа
// - при передаче в электронном виде - состояние отправки;
// - при передаче иным способом - статус, установленный пользователем.
//
// Возвращаемое значение:
//  Структура
//    * Представление - Строка - представление состояния передачи в учреждение.
//    * Статус        - Строка - строковый статус объекта регламентированной отчетности.
//    * Сдано         - Булево - Истина, если отчет сдан любым способом.
//    * Отправлено    - Булево - Истина, если отчет отправлен в учреждение в электронном виде.
//    * ВРаботе       - Булево - Истина, если отчет редактируется и еще не отправлен в учреждение.
//
Функция НовыйСостояниеДокумента() Экспорт
	
	Состояние = Новый Структура;
	Состояние.Вставить("Представление", ПредставлениеСтатусаНеОтправлено());
	Состояние.Вставить("Статус",        "");
	Состояние.Вставить("Сдано",         Ложь);
	Состояние.Вставить("Отправлено",    Ложь);
	Состояние.Вставить("ВРаботе",       Ложь);
	
	Возврат Состояние;
	
КонецФункции

// Определяет, возможна ли отправка отчета в учреждение в виде электронного документа.
//
// Параметры:
//  ИмяОтчета - Строка - Имя отчета (элемента метаданных).
// 
// Возвращаемое значение:
//  Булево - Истина, если отчет может быть отправлен в электронном виде.
//
Функция ВозможнаОтправкаЭлектронногоДокумента(ИмяОтчета) Экспорт
	
	ОтчетыОтправкаОграничена = ОтчетыОтправкаОграничена();
	Возврат (ОтчетыОтправкаОграничена.Найти(ИмяОтчета) = Неопределено);
	
КонецФункции

// Определяет перечень отчетов, отправка которых в учреждение невозможна в виде электронного документа.
//
// В список включены отчеты, из форм которых не вызывается
// ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПередОтправкойРегламентированногоОтчета()
//
// Внимание!
// При изменении содержимого этого перечня регламентированных отчетов в конфигурации-потребителе
// БРО при обновлении но новую версию необходимо выполнить специальный обработчик обновления,
// который должен выполняться каждый раз при изменени содержимого этого перечня.
//
// Возвращаемое значение:
//  ФиксированныйМассив - имена отчетов (элементов метаданных).
//
Функция ОтчетыОтправкаОграничена() Экспорт
	
	ВариантыОграниченаПередача = // См. также ПредставлениеПолучателяБумажногоДокумента()
	"РегламентированныйОтчетДвижениеСредствПоСчетуВБанкеЗаПределамиРФ
	|РегламентированныйОтчетДеятельностьИнОргВРФ
	|РегламентированныйОтчетПрибыльСколковоРасчетНалоговойБазы
	|РегламентированныйОтчетРасчетПоОплатеЗаВоду
	|РегламентированныйОтчетРасчетЧистыхАктивов
	|РегламентированныйОтчетРеестрАкцизыВычетыВиноматериалы
	|РегламентированныйОтчетРеестрАкцизыВычетыЭтиловыйСпирт
	|РегламентированныйОтчетРеестрСФНаПереработкуБензина
	|РегламентированныйОтчетРеестрСФПоАвиационномуКеросину
	|РегламентированныйОтчетРеестрСФПоБензинуИзДавальческогоСырья
	|РегламентированныйОтчетРеестрСФПоБензинуИзСобственногоСырья
	|РегламентированныйОтчетРеестрСФПоБензолуПараксилолуОртоксилолу
	|РегламентированныйОтчетРеестрСФПоВиноматериалам
	|РегламентированныйОтчетРеестрСФПоДенатурированномуЭтиловомуСпирту
	|РегламентированныйОтчетРеестрСФПоНефтяномуСырью
	|РегламентированныйОтчетРеестрСФПоСреднимДистиллятам
	|РегламентированныйОтчетРеестрСФПоЭтиловомуСпирту
	|РегламентированныйОтчетСведенияОрублевыхСчетах
	|РегламентированныйОтчетСведенияОСчетахвВиностраннойВалюте
	|РегламентированныйОтчетСоответствиеУсловийТруда
	|РегламентированныйОтчетСтатистика1Квотирование
	|РегламентированныйОтчетСтатистикаФорма1ДМ
	|РегламентированныйОтчетСтатистикаФорма2ДМ
	|РегламентированныйОтчетСтатистикаФорма2ДМДавальческоеСырье
	|РегламентированныйОтчетСтатистикаФорма2ДМприл
	|РегламентированныйОтчетСтатистикаФорма4ДМ
	|РегламентированныйОтчетСтатистикаФормаП1Приложение3
	|РегламентированныйОтчетСтраховыеВзносыНСИПЗ";
	
	Возврат Новый ФиксированныйМассив(СтрРазделить(ВариантыОграниченаПередача, Символы.ПС, Ложь));
	
КонецФункции

// Определяет краткое наименование государственного органа - получателя документа, который невозможно отправить ему в электронном виде.
// Следует использовать для отчетов, для которых ВозможнаОтправкаЭлектронногоДокумента() = Ложь.
//
// Параметры:
//  ИмяОтчета - Строка - Имя отчета (элемента метаданных).
// 
// Возвращаемое значение:
//  Строка - представление гос. органа; пустая строка, если неизвестно.
//
Функция ПредставлениеПолучателяБумажногоДокумента(ИмяОтчета) Экспорт
	
	Если ИмяОтчета = "РегламентированныйОтчетСтатистикаФорма1ДМ"
		Или ИмяОтчета = "РегламентированныйОтчетСтатистикаФорма1ДМ"
		Или ИмяОтчета = "РегламентированныйОтчетСтатистикаФорма2ДМ"
		Или ИмяОтчета = "РегламентированныйОтчетСтатистикаФорма2ДМДавальческоеСырье"
		Или ИмяОтчета = "РегламентированныйОтчетСтатистикаФорма2ДМприл"
		Или ИмяОтчета = "РегламентированныйОтчетСтатистикаФорма4ДМ" Тогда
		
		Возврат НСтр("ru = 'Гохран'");
		
	ИначеЕсли ИмяОтчета = "РегламентированныйОтчетСтатистика1Квотирование" Тогда
		
		Возврат НСтр("ru = 'Центр занятости'");
		
	Иначе	
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

// Определяет текст для пользователя, кратко, в несколько слов описывающий суть ограничения отправки отчета.
// Такой текст выводится в дополнение к названию отчета и т.п.
//
// Возвращаемое значение:
//  Строка - краткое представление ограничения отправки отчета для пользователя.
//
Функция КраткоеПредставлениеОграниченияОтправкиОтчета() Экспорт
	
	Возврат НСтр("ru = 'сдается в бумажном виде'");
	
КонецФункции

#КонецОбласти

#КонецОбласти