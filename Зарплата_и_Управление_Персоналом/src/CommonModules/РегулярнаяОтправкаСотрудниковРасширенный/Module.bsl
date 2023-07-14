#Область СлужебныеПроцедурыИФункции

#Область ПодпискиНаСобытия

Процедура ПроверитьИзмененияПодразделенийИЗарегистрироватьНеобходимостьОтправки(СистемаБронирования,
	Источник,
	ИспользуетсяОтборПоПодразделениям) Экспорт

	ИзменившиесяДанные = Источник.ТаблицаИзменившихсяДанныхНабора();

	Если ИзменившиесяДанные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	МассивСотрудниковДляДобавления = Новый Массив;
	МассивСотрудниковДляУдаления = Новый Массив;

	ПричинаПоУсловию = Перечисления.ПричиныОтправкиСотрудниковБронированияКомандировок.ПоУсловию;
	ПричинаНепосредственно = Перечисления.ПричиныОтправкиСотрудниковБронированияКомандировок.Непосредственно;

	Если ИспользуетсяОтборПоПодразделениям Тогда

		ТаблицаОтправляемыхПодразделений = ПодразделенияБронированияКомандировок(СистемаБронирования);
		ТаблицаОтправляемыхСотрудников = РегулярнаяОтправкаСотрудников.СотрудникиБронированияКомандировок(СистемаБронирования,
			Источник.ВыгрузитьКолонку("ФизическоеЛицо"), Неопределено, Неопределено);
			
		ЕстьПодразделенияДляОтправки = Ложь;
		Если ЗначениеЗаполнено(ТаблицаОтправляемыхПодразделений) Тогда
			ЕстьПодразделенияДляОтправки = Истина;
			ОбщегоНазначенияБЗК.ДобавитьИндексКоллекции(ТаблицаОтправляемыхПодразделений, "Подразделение");
		КонецЕсли;
		ОбщегоНазначенияБЗК.ДобавитьИндексКоллекции(ТаблицаОтправляемыхСотрудников, "ФизическоеЛицо");

		Для Каждого СтрокаИзменения Из ИзменившиесяДанные Цикл
			Если СтрокаИзменения.Добавление Тогда
				ФизическоеЛицо = СтрокаИзменения.НовоеЗначениеГоловнойСотрудник.ФизическоеЛицо;
				Если СтрокаИзменения.НовоеЗначениеВидСобытия = Перечисления.ВидыКадровыхСобытий.Прием
					И ЕстьПодразделенияДляОтправки Тогда

					ПодразделениеВСтруктуре = ОрганизационнаяСтруктура.ПодразделениеВСтруктуреПредприятия(
						СтрокаИзменения.НовоеЗначениеПодразделение);

					НайденноеПодразделение = ТаблицаОтправляемыхПодразделений.Найти(
						ПодразделениеВСтруктуре, "Подразделение");

					Если НайденноеПодразделение <> Неопределено Тогда
						РегулярнаяОтправкаСотрудников.ДобавитьЭлементВСписок(МассивСотрудниковДляДобавления, ФизическоеЛицо);
					КонецЕсли;

				ИначеЕсли СтрокаИзменения.НовоеЗначениеВидСобытия = Перечисления.ВидыКадровыхСобытий.Увольнение Тогда

					СотрудникВНастройках = ТаблицаОтправляемыхСотрудников.Найти(
						ФизическоеЛицо, "ФизическоеЛицо");

					Если СотрудникВНастройках <> Неопределено Тогда
						Если СотрудникВНастройках.Отправляется Тогда
							РегулярнаяОтправкаСотрудников.ДобавитьЭлементВСписок(МассивСотрудниковДляУдаления, ФизическоеЛицо);
						КонецЕсли;
					КонецЕсли;

				ИначеЕсли СтрокаИзменения.НовоеЗначениеВидСобытия = Перечисления.ВидыКадровыхСобытий.Перемещение Тогда

					ПодразделениеВСтруктуре = ОрганизационнаяСтруктура.ПодразделениеВСтруктуреПредприятия(
						СтрокаИзменения.НовоеЗначениеПодразделение);
						
					Если ЕстьПодразделенияДляОтправки Тогда
						НайденноеПодразделение = ТаблицаОтправляемыхПодразделений.Найти(
							ПодразделениеВСтруктуре, "Подразделение");
					Иначе
						НайденноеПодразделение = Неопределено;
					КонецЕсли;
					
					СотрудникВНастройках = ТаблицаОтправляемыхСотрудников.Найти(
						ФизическоеЛицо, "ФизическоеЛицо");

					Если НайденноеПодразделение = Неопределено И СотрудникВНастройках = Неопределено Тогда
						Продолжить;
					ИначеЕсли НайденноеПодразделение <> Неопределено И СотрудникВНастройках = Неопределено Тогда
						РегулярнаяОтправкаСотрудников.ДобавитьЭлементВСписок(МассивСотрудниковДляДобавления, ФизическоеЛицо);
					ИначеЕсли НайденноеПодразделение = Неопределено И СотрудникВНастройках <> Неопределено Тогда
						Если СотрудникВНастройках.ПричинаОтправки = ПричинаНепосредственно Тогда
							Продолжить;
						Иначе
							Если СотрудникВНастройках.Отправляется Тогда
								РегулярнаяОтправкаСотрудников.ДобавитьЭлементВСписок(МассивСотрудниковДляУдаления, ФизическоеЛицо);
							КонецЕсли;
						КонецЕсли;
					ИначеЕсли НайденноеПодразделение <> Неопределено И СотрудникВНастройках <> Неопределено Тогда
						Если СотрудникВНастройках.ПричинаОтправки = ПричинаНепосредственно Тогда
							Продолжить;
						Иначе
							Если Не СотрудникВНастройках.Отправляется Тогда
								РегулярнаяОтправкаСотрудников.ДобавитьЭлементВСписок(МассивСотрудниковДляДобавления, ФизическоеЛицо);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;

				КонецЕсли;
			КонецЕсли;
		КонецЦикла;

	Иначе

		Для Каждого СтрокаИзменения Из ИзменившиесяДанные Цикл
			Если СтрокаИзменения.Добавление Тогда
				ФизическоеЛицо = СтрокаИзменения.НовоеЗначениеГоловнойСотрудник.ФизическоеЛицо;
				Если СтрокаИзменения.НовоеЗначениеВидСобытия = Перечисления.ВидыКадровыхСобытий.Прием Тогда
					РегулярнаяОтправкаСотрудников.ДобавитьЭлементВСписок(МассивСотрудниковДляДобавления, ФизическоеЛицо);
				ИначеЕсли СтрокаИзменения.НовоеЗначениеВидСобытия = Перечисления.ВидыКадровыхСобытий.Увольнение Тогда
					РегулярнаяОтправкаСотрудников.ДобавитьЭлементВСписок(МассивСотрудниковДляУдаления, ФизическоеЛицо);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;

	Если МассивСотрудниковДляДобавления.Количество() > 0 Тогда
		РегистрыСведений.ФизическиеЛицаБронированияКомандировок.ЗарегистрироватьИзмененияСотрудниковВСпискеОтправляемых(
			СистемаБронирования, МассивСотрудниковДляДобавления, ПричинаПоУсловию, Истина);
	КонецЕсли;
	Если МассивСотрудниковДляУдаления.Количество() > 0 Тогда
		РегистрыСведений.ФизическиеЛицаБронированияКомандировок.УдалитьСотрудниковИзСпискаОтправляемых(
			СистемаБронирования, МассивСотрудниковДляУдаления);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

Процедура ДобавитьОтборПоДолжностиПоШтатномуРасписанию(Параметры, СписокПодразделений) Экспорт
	
		УстановитьПривилегированныйРежим(Истина);
		ПозицииПодразделений = ОрганизационнаяСтруктура.ПозицииПодразделений(СписокПодразделений);
		УстановитьПривилегированныйРежим(Ложь);
		Позиции = ПозицииПодразделений.ВыгрузитьКолонку("Позиция");
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(Параметры.Отборы, "ДолжностьПоШтатномуРасписанию", "В", Позиции);

КонецПроцедуры

Функция ПодразделенияБронированияКомандировок(СистемаБронирования) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СистемаБронирования", СистемаБронирования);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодразделенияБронированияКомандировок.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.ПодразделенияБронированияКомандировок КАК ПодразделенияБронированияКомандировок
	|ГДЕ
	|	ПодразделенияБронированияКомандировок.СистемаБронирования = &СистемаБронирования
	|	И ПодразделенияБронированияКомандировок.ВключатьПодчиненныеПодразделения = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодразделенияБронированияКомандировок.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.ПодразделенияБронированияКомандировок КАК ПодразделенияБронированияКомандировок
	|ГДЕ
	|	ПодразделенияБронированияКомандировок.СистемаБронирования = &СистемаБронирования
	|	И ПодразделенияБронированияКомандировок.ВключатьПодчиненныеПодразделения = ЛОЖЬ";

	Пакет = Запрос.ВыполнитьПакет();
	
	Если Пакет[0].Пустой() И Пакет[1].Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Подразделение", Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
	
	МассивВключатьПодчиненные 	= Пакет[0].Выгрузить().ВыгрузитьКолонку("Подразделение");
	МассивНеВключатьПодчиненные = Пакет[1].Выгрузить().ВыгрузитьКолонку("Подразделение");
	
	Если МассивВключатьПодчиненные.Количество() > 0 Тогда
		ДобавленыВСписок = ОрганизационнаяСтруктура.ПодчиненныеПодразделения(МассивВключатьПодчиненные);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(Таблица, ДобавленыВСписок, "Подразделение");
	КонецЕсли;
	
	Если МассивНеВключатьПодчиненные.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(Таблица, МассивНеВключатьПодчиненные, "Подразделение");
	КонецЕсли;
	
	Таблица.Свернуть("Подразделение");
	
	Возврат Таблица;

КонецФункции

#КонецОбласти
