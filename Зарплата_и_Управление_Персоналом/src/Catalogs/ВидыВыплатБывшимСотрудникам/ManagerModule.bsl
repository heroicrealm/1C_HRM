#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает массив вид выплат, входящих в расчетную базу удержаний
//
Функция ВидыВыплатДополненияРасчетнойБазыУдержаний() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыВыплатБывшимСотрудникам.Ссылка КАК ВидВыплаты
	|ИЗ
	|	Справочник.ВидыВыплатБывшимСотрудникам КАК ВидыВыплатБывшимСотрудникам
	|ГДЕ
	|	ВидыВыплатБывшимСотрудникам.КодДоходаНДФЛ <> ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидВыплаты");
	
КонецФункции

// Возвращает массив видов выплат бывшим сотрудникам на период трудоустройства.
Функция ВидыВыплатНаПериодТрудоустройства() Экспорт
	Результат = Новый Массив;
	ДобавитьПредопределенныйВМассив(Результат, "Справочник.ВидыВыплатБывшимСотрудникам.СохраняемоеДенежноеСодержаниеНаПериодТрудоустройства");
	ДобавитьПредопределенныйВМассив(Результат, "Справочник.ВидыВыплатБывшимСотрудникам.СохраняемыйЗаработокНаВремяТрудоустройства");
	Возврат Результат;
КонецФункции

// Возвращает виды доходов исполнительного производства выплат
//
// Возвращаемое значение:
// 	Соответствие:
// 	 	* Ключ     - ПеречислениеСсылка.ВидыОсобыхНачисленийИУдержаний
// 	 	* Значение - ПеречислениеСсылка.ВидыДоходовИсполнительногоПроизводства
// 
Функция ВидыДоходовИсполнительногоПроизводства() Экспорт
	Возврат УчетНачисленнойЗарплаты.ВидыДоходовИсполнительногоПроизводстваОбъектов(Метаданные.Справочники.ВидыВыплатБывшимСотрудникам);
КонецФункции

// Создает виды выплат бывшим сотрудникам в зависимости от настроек программы.
Процедура СоздатьВидыВыплатБывшимСотрудникамПоНастройкам() Экспорт
	
	НастройкиПрограммы = ЗарплатаКадрыРасширенный.НастройкиПрограммыБюджетногоУчреждения();
	
	Если НастройкиПрограммы.ИспользоватьГосударственнуюСлужбу
		ИЛИ НастройкиПрограммы.ИспользоватьМуниципальнуюСлужбу Тогда
		
		// Сохраняемое денежное содержание на период трудоустройства
		ОписаниеВидаВыплатБывшимСотрудникам = ОписаниеВидаВыплатБывшимСотрудникам();
		ОписаниеВидаВыплатБывшимСотрудникам.ПредопределенныйВидВыплатБывшимСотрудникам 	= Истина;
		ОписаниеВидаВыплатБывшимСотрудникам.ИмяПредопределенныхДанных	= "СохраняемоеДенежноеСодержаниеНаПериодТрудоустройства";
		ОписаниеВидаВыплатБывшимСотрудникам.Наименование				= НСтр("ru = 'Сохраняемое денежное содержание на период трудоустройства'");
		ОписаниеВидаВыплатБывшимСотрудникам.КодДоходаСтраховыеВзносы	= Справочники.ВидыДоходовПоСтраховымВзносам.НеЯвляетсяОбъектом;
		
		НовыйВидВыплатБывшимСотрудникам(ОписаниеВидаВыплатБывшимСотрудникам);
		
	КонецЕсли;
		
КонецПроцедуры

// Обработчик начального заполнения ИБ
Процедура СоздатьВидыВыплатБывшимСотрудникам() Экспорт
	
	ОписаниеВидаВыплатБывшимСотрудникам = ОписаниеВидаВыплатБывшимСотрудникам();
	ОписаниеВидаВыплатБывшимСотрудникам.ПредопределенныйВидВыплатБывшимСотрудникам 	= Истина;
	ОписаниеВидаВыплатБывшимСотрудникам.ИмяПредопределенныхДанных = "СохраняемыйЗаработокНаВремяТрудоустройства";
	ОписаниеВидаВыплатБывшимСотрудникам.Наименование              = НСтр("ru = 'Сохраняемый средний заработок на время трудоустройства'");
	ОписаниеВидаВыплатБывшимСотрудникам.КодДоходаСтраховыеВзносы  = Справочники.ВидыДоходовПоСтраховымВзносам.НеЯвляетсяОбъектом;
	ОписаниеВидаВыплатБывшимСотрудникам.ВидДоходаИсполнительногоПроизводства = Перечисления.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения;
		
	НовыйВидВыплатБывшимСотрудникам(ОписаниеВидаВыплатБывшимСотрудникам);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПредопределенныйВМассив(Массив, ИмяПредопределенного)
	Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент(ИмяПредопределенного);
	Если Ссылка <> Неопределено Тогда
		Массив.Добавить(Ссылка);
	КонецЕсли;
КонецПроцедуры

Функция ОписаниеВидаВыплатБывшимСотрудникам()
	
	Возврат Новый Структура("
	|Наименование,
	|КодДоходаНДФЛ,
	|КодДоходаСтраховыеВзносы,
	|ВидДоходаИсполнительногоПроизводства,
	|ПредопределенныйВидВыплатБывшимСотрудникам,
	|ИмяПредопределенныхДанных");
	
КонецФункции

Функция НовыйВидВыплатБывшимСотрудникам(ОписаниеВидаВыплатБывшимСотрудникам)
	
	ВидВыплатБывшимСотрудникамОбъект = Неопределено;
	Если ОписаниеВидаВыплатБывшимСотрудникам.ПредопределенныйВидВыплатБывшимСотрудникам Тогда 
		ВидВыплатБывшимСотрудникамСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыВыплатБывшимСотрудникам." + ОписаниеВидаВыплатБывшимСотрудникам.ИмяПредопределенныхДанных);
		Если ВидВыплатБывшимСотрудникамСсылка <> Неопределено Тогда 
			ВидВыплатБывшимСотрудникамОбъект = ВидВыплатБывшимСотрудникамСсылка.ПолучитьОбъект();
			Возврат ВидВыплатБывшимСотрудникамОбъект;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидВыплатБывшимСотрудникамОбъект = Неопределено Тогда 
		ВидВыплатБывшимСотрудникамОбъект = Справочники.ВидыВыплатБывшимСотрудникам.СоздатьЭлемент();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ВидВыплатБывшимСотрудникамОбъект, ОписаниеВидаВыплатБывшимСотрудникам);
	ВидВыплатБывшимСотрудникамОбъект.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат ВидВыплатБывшимСотрудникамОбъект;
	
КонецФункции

// Обработчик обновления
Процедура ЗаполнитьВидДоходаИсполнительногоПроизводства() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустаяСсылка", Перечисления.ВидыДоходовИсполнительногоПроизводства.ПустаяСсылка());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыВыплатБывшимСотрудникам.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыВыплатБывшимСотрудникам КАК ВидыВыплатБывшимСотрудникам
	|ГДЕ
	|	ВидыВыплатБывшимСотрудникам.ВидДоходаИсполнительногоПроизводства = &ПустаяСсылка";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат
	КонецЕсли;	
	
	ВидыВыплат = РезультатЗапроса.Выбрать();
	Пока ВидыВыплат.Следующий() Цикл
		ВидВыплаты = ВидыВыплат.Ссылка.ПолучитьОбъект();
		ВидВыплаты.ВидДоходаИсполнительногоПроизводства = Перечисления.ВидыДоходовИсполнительногоПроизводства.ДоходыБезОграниченияВзысканий;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидВыплаты);
	КонецЦикла	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
