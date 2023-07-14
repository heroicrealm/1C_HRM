#Область СлужебныеПроцедурыИФункции

// Процедура предназначена для выполнения действия, сопряженных с регистрацией отработанного времени.
//
Процедура ПриРегистрацииОтработанногоВремени(Движения, ЗаписыватьДвижения = Ложь) Экспорт
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьКорректировкиОтработанногоВремени(Движения, ЗаписыватьДвижения);
КонецПроцедуры

Процедура ПриЗаполненииСтрокРегистрацииНачисленнойЗарплаты(ТаблицаНачислений, СтрокиНачислений) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		МодульУправленческаяЗарплата = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		МодульУправленческаяЗарплата.ПриЗаполненииСтрокРегистрацииНачисленнойЗарплаты(ТаблицаНачислений, СтрокиНачислений);
	КонецЕсли;
	
КонецПроцедуры

Функция ПравилаУчетаНачисленийСотрудников() Экспорт

	Возврат УчетНачисленнойЗарплатыРасширенный.ПравилаУчетаНачисленийСотрудников();

КонецФункции

Процедура СкорректироватьДатыНачисленийБезПериодаДействия(ТаблицаНачислений, ПериодРегистрации, ИмяПоляНачисления = "НачислениеУдержание") Экспорт
	ЗарплатаКадрыРасширенный.СкорректироватьДатыНачисленийБезПериодаДействия(ТаблицаНачислений, ПериодРегистрации, ИмяПоляНачисления);
КонецПроцедуры

Функция ЗапросВТНачисленныеДоходы(ИмяВТНачисленныеДоходы) Экспорт
	Возврат УчетНачисленнойЗарплатыРасширенный.ЗапросВТНачисленныеДоходы(ИмяВТНачисленныеДоходы);
КонецФункции

Функция ВидыДоходовИсполнительногоПроизводстваНачислений() Экспорт
	Возврат УчетНачисленнойЗарплатыРасширенный.ВидыДоходовИсполнительногоПроизводстваНачислений();
КонецФункции

#Область ПроцедурыИФункцииРаботыСОтчетами

// Формирование отчета Анализ начислений и удержаний.
//
Процедура ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс = Ложь) Экспорт
	УчетНачисленнойЗарплатыРасширенный.ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс);
КонецПроцедуры

Процедура ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеНачисленияИУдержания, НастройкиОтчета, КоличествоНачисленийУдержаний, ВидПолей, НаАванс) Экспорт
	УчетНачисленнойЗарплатыРасширенный.ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеНачисленияИУдержания, НастройкиОтчета, КоличествоНачисленийУдержаний, ВидПолей, НаАванс);
КонецПроцедуры

// Возвращает начисления в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыРасширенный.ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

// Возвращает удержания в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыРасширенный.ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

Функция ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыРасширенный.ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Функция ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыРасширенный.ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Процедура ЗаполнитьДополнительныеПоляОтчетаАнализНачисленийИУдержаний(ОтчетОбъект, ДополнительныеПоля) Экспорт
	
	УчетНачисленнойЗарплатыРасширенный.ЗаполнитьДополнительныеПоляОтчетаАнализНачисленийИУдержаний(ОтчетОбъект, ДополнительныеПоля);
	
КонецПроцедуры

Функция ПустоеЗначениеТерриторияНаЯзыкеЗапросов() Экспорт

	Возврат УчетНачисленнойЗарплатыРасширенный.ПустоеЗначениеТерриторияНаЯзыкеЗапросов();

КонецФункции


#КонецОбласти

#КонецОбласти
