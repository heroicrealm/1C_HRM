
#Область СлужебныеПроцедурыИФункции

Функция ПубликуемаяСтруктураПредприятия(Позиции) Экспорт

	Возврат КабинетСотрудникаРасширенный.ПубликуемаяСтруктураПредприятия(Позиции);

КонецФункции

Процедура СоздатьВТШтатноеРасписание(МенеджерВТ, ИспользоватьШтатноеРасписание) Экспорт
	
	КабинетСотрудникаРасширенный.СоздатьВТШтатноеРасписание(МенеджерВТ, ИспользоватьШтатноеРасписание);
	
КонецПроцедуры

Функция ПодразделениеВСтруктуреПредприятия(Подразделение) Экспорт

	Возврат КабинетСотрудникаРасширенный.ПодразделениеВСтруктуреПредприятия(Подразделение);

КонецФункции

Функция ИменаКонтролируемыхПолей(Объект) Экспорт

	Возврат КабинетСотрудникаРасширенный.ИменаКонтролируемыхПолей(Объект);

КонецФункции

Процедура ОбъектПриЗаписи(Объект) Экспорт

	КабинетСотрудникаРасширенный.ОбъектПриЗаписи(Объект);

КонецПроцедуры

Процедура ОбъектПередЗаписью(Объект) Экспорт

	КабинетСотрудникаРасширенный.ОбъектПередЗаписью(Объект);

КонецПроцедуры

Функция ФотографииФизическихЛиц(ФизическиеЛица) Экспорт

	Возврат КабинетСотрудникаРасширенный.ФотографииФизическихЛиц(ФизическиеЛица);

КонецФункции

Функция ТипШтатноеРасписание() Экспорт

	Возврат КабинетСотрудникаРасширенный.ТипШтатноеРасписание();

КонецФункции

Функция ТипСтруктураПредприятия() Экспорт

	Возврат КабинетСотрудникаРасширенный.ТипСтруктураПредприятия();

КонецФункции

Функция ДанныеСтруктурыПредприятия(СписокОтбора) Экспорт

	Возврат КабинетСотрудникаРасширенный.ДанныеСтруктурыПредприятия(СписокОтбора);

КонецФункции

Функция ДанныеШтатногоРасписания(СписокОтбора) Экспорт

	Возврат КабинетСотрудникаРасширенный.ДанныеШтатногоРасписания(СписокОтбора);

КонецФункции

Процедура ДобавитьСотрудникиДляОбновленияПубликацииПравНаОтпуск(Сотрудник, ОбновлениеИБ) Экспорт

	КабинетСотрудникаРасширенный.ДобавитьСотрудникиДляОбновленияПубликацииПравНаОтпуск(Сотрудник, ОбновлениеИБ);

КонецПроцедуры

Процедура ОчиститьДанныеПриОтключенииСервиса() Экспорт

	КабинетСотрудникаРасширенный.ОчиститьДанныеПриОтключенииСервиса();

КонецПроцедуры

Процедура ОбновитьСтруктуруПредприятия() Экспорт

	КабинетСотрудникаРасширенный.ОбновитьСтруктуруПредприятия();

КонецПроцедуры

Функция НоваяПубликуемаяСтруктураПредприятияПозиций(Позиции) Экспорт

	Возврат КабинетСотрудникаРасширенный.НоваяПубликуемаяСтруктураПредприятияПозиций(Позиции);

КонецФункции

Функция ТипыОбрабатываемыхЗаявок() Экспорт

	Возврат КабинетСотрудникаРасширенный.ТипыОбрабатываемыхЗаявок();

КонецФункции

Процедура ОчиститьДанныеОбАктуальностиИнформацииОбОтпускеНепубликуемыхСотрудников(СотрудникиКПубликации) Экспорт 
	
	КабинетСотрудникаРасширенный.ОчиститьДанныеОбАктуальностиИнформацииОбОтпускеНепубликуемыхСотрудников(СотрудникиКПубликации);
	
КонецПроцедуры

Процедура ТекущиеКадровыеДанныеСотрудниковПередЗаписью(НаборЗаписей) Экспорт

	// в расширенной реализации не переопределяется

КонецПроцедуры

Процедура ТекущиеКадровыеДанныеСотрудниковПриЗаписи(НаборЗаписей) Экспорт

	КабинетСотрудникаРасширенный.ТекущиеКадровыеДанныеСотрудниковПриЗаписи(НаборЗаписей);

КонецПроцедуры

Функция ДоступнаяФункциональностьСервиса() Экспорт

	Возврат КабинетСотрудникаРасширенный.ДоступнаяФункциональностьСервиса();

КонецФункции

Функция КадровыеДанныеОбновляемыхСотрудников(МенеджерВТ) Экспорт
	
	Возврат КабинетСотрудникаРасширенный.КадровыеДанныеОбновляемыхСотрудников(МенеджерВТ);
	
КонецФункции

Процедура ДобавитьЭлементыБлокировкиПриОбновленииПубликации(Блокировка) Экспорт

	КабинетСотрудникаРасширенный.ДобавитьЭлементыБлокировкиПриОбновленииПубликации(Блокировка);

КонецПроцедуры

Процедура ЗарегистрироватьОбновлениеПубликуемыхОбъектов(ПубликуемыеОбъекты, ОбновитьВсе) Экспорт

	КабинетСотрудникаРасширенный.ЗарегистрироватьОбновлениеПубликуемыхОбъектов(ПубликуемыеОбъекты, ОбновитьВсе);

КонецПроцедуры

Процедура ОпубликоватьПрочиеИзменения(ПараметрыПодключения, БылиОшибки) Экспорт

	КабинетСотрудникаРасширенный.ОпубликоватьПрочиеИзменения(ПараметрыПодключения, БылиОшибки);

КонецПроцедуры

Процедура ОпубликоватьЗарегистрированныеИзменения(ПараметрыПодключения, ТаблицаИзменений, Результат) Экспорт

	КабинетСотрудникаРасширенный.ОпубликоватьЗарегистрированныеИзменения(ПараметрыПодключения, ТаблицаИзменений, Результат);

КонецПроцедуры

Процедура ЗарегистрироватьОбновлениеГрафиковРаботы() Экспорт

	КабинетСотрудникаРасширенный.ЗарегистрироватьОбновлениеГрафиковРаботы();

КонецПроцедуры

Функция ТипыОбъектовДляРучнойРегистрации() Экспорт
	
	Возврат КабинетСотрудникаРасширенный.ТипыОбъектовДляРучнойРегистрации();	
	
КонецФункции

Процедура ЗарегистрироватьОбновлениеДанныхГрафиковРаботы() Экспорт

	КабинетСотрудникаРасширенный.ЗарегистрироватьОбновлениеДанныхГрафиковРаботы();

КонецПроцедуры

Процедура ПлановыеУдержанияПередЗаписью(НаборЗаписей) Экспорт

	КабинетСотрудникаРасширенный.ПлановыеУдержанияПередЗаписью(НаборЗаписей);

КонецПроцедуры

Процедура ПлановыеУдержанияПриЗаписи(НаборЗаписей) Экспорт

	КабинетСотрудникаРасширенный.ПлановыеУдержанияПриЗаписи(НаборЗаписей);

КонецПроцедуры

Функция ЗарегистрироватьИзмененияПлановыхУдержаний() Экспорт

	Возврат КабинетСотрудникаРасширенный.ЗарегистрироватьИзмененияПлановыхУдержаний();

КонецФункции

Процедура ЗаполнитьНастройкиПрограммы(НастройкиПрограммы) Экспорт

	КабинетСотрудникаРасширенный.ЗаполнитьНастройкиПрограммы(НастройкиПрограммы);

КонецПроцедуры

Процедура ДобавитьЭлементБлокировкиСотрудникиДляОбновленияПубликацииПравНаОтпуск(Блокировка, ПубликацииПравНаОтпускБлокировка) Экспорт

	КабинетСотрудникаРасширенный.ДобавитьЭлементБлокировкиСотрудникиДляОбновленияПубликацииПравНаОтпуск(Блокировка, ПубликацииПравНаОтпускБлокировка)

КонецПроцедуры

Процедура ДобавитьЭлементыБлокировкиОбновлениеНастройкиПубликации(Блокировка) Экспорт

	КабинетСотрудникаРасширенный.ДобавитьЭлементыБлокировкиОбновлениеНастройкиПубликации(Блокировка);

КонецПроцедуры

Процедура ОчиститьДанныеПриПриОбновленииПубликации() Экспорт

	КабинетСотрудникаРасширенный.ОчиститьДанныеПриПриОбновленииПубликации();

КонецПроцедуры

Функция ДанныеСотрудниковДляПубликации(ПараметрыПодключения, МассивОтбора) Экспорт

	Возврат КабинетСотрудникаРасширенный.ДанныеСотрудниковДляПубликации(ПараметрыПодключения, МассивОтбора);

КонецФункции

Процедура ЗарегистрироватьИзмененияГрафиковРаботы(ТаблицаСотрудников) Экспорт

	КабинетСотрудникаРасширенный.ЗарегистрироватьИзмененияГрафиковРаботы(ТаблицаСотрудников);

КонецПроцедуры

Функция ТипГрафикРаботы() Экспорт

	Возврат КабинетСотрудникаРасширенный.ТипГрафикРаботы();

КонецФункции

Функция РуководителиПодразделенийОрганизаций(Подразделения) Экспорт

	Возврат КабинетСотрудникаРасширенный.РуководителиПодразделенийОрганизаций(Подразделения); 

КонецФункции

Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	КабинетСотрудникаРасширенный.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
КонецПроцедуры

Процедура ПриПолученииСпискаШаблоновОчередиЗаданий(Шаблоны) Экспорт
	
	КабинетСотрудникаРасширенный.ПриПолученииСпискаШаблоновОчередиЗаданий(Шаблоны);
	
КонецПроцедуры

Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	КабинетСотрудникаРасширенный.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	
КонецПроцедуры

#КонецОбласти
