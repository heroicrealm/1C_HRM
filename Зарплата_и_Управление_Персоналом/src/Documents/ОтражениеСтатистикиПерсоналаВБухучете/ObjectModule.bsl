#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроверитьВведенныеДокументыМесяца(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьВведенныеДокументыМесяца(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОСреднесписочнойЧисленности.Ссылка КАК Документ,
		|	СведенияОСреднесписочнойЧисленности.Организация КАК Организация,
		|	СведенияОСреднесписочнойЧисленности.ПериодРегистрации КАК ПериодРегистрации
		|ИЗ
		|	Документ.ОтражениеСтатистикиПерсоналаВБухучете КАК СведенияОСреднесписочнойЧисленности
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(СведенияОСреднесписочнойЧисленности.ПериодРегистрации, МЕСЯЦ) = НАЧАЛОПЕРИОДА(&ПериодРегистрации, МЕСЯЦ)
		|	И СведенияОСреднесписочнойЧисленности.Организация = &Организация
		|	И СведенияОСреднесписочнойЧисленности.Проведен
		|	И СведенияОСреднесписочнойЧисленности.Ссылка <> &ТекущийДокумент";
	
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	Запрос.УстановитьПараметр("ПериодРегистрации", ПериодРегистрации);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Отказ = Истина;
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ТекстСообщения = НСтр("ru = 'Для организации %1 за %2 уже введен документ %3'");
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(ТекстСообщения, 
					ВыборкаДетальныеЗаписи.Организация, 
					ПредставлениеПериода(НачалоМесяца(ВыборкаДетальныеЗаписи.ПериодРегистрации),
						КонецМесяца(ВыборкаДетальныеЗаписи.ПериодРегистрации),
						"ФП"),
					ВыборкаДетальныеЗаписи.Документ),
				,,,Отказ);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли

