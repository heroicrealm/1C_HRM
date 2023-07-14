#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокГражданПодлежащихПостановкеНаВоинскийУчет");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сведения о работниках, состоящих на воинском учете, а также о работниках, не состоящих, 
		|но обязанных состоять на воинском учете, для предоставления в военкомат.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокЮношейДляОВК");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Список работников мужского пола 15- и 16-летнего возраста на указанную дату 
		|для предоставления в военкомат.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокПервоначальнойПостановкиНаВоинскийУчет");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Список работников, подлежащих первоначальной постановке на воинский учет в указанном году, 
		|для предоставления в военкомат.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокДляСверкиСВоенкоматом");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сведения о воинском учете из личных карточек военнослужащих запаса 
		|для предоставления в военкомат.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КарточкаОповещения");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Оповещение работника о вызове на учения в мирное время и на воинские действия - в военное.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РаспискаПриПриемеДокументов");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Расписка, выдаваемая работнику при приеме документов воинского учета.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ИзвещениеОПриемеУвольнении");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сообщения для военкоматов о приемах или увольнениях подлежащих 
		|воинскому учету работников за заданный период.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПринятыеУволенныеВоеннообязанные");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Список принятых и уволенных военнослужащих запаса за заданный период.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПринятыеУволенныеПризывники");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Список принятых и уволенных призывников за заданный период.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализКарточекВоинскогоУчета");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Данные воинского учета работников на заданную дату.'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КарточкаУчетаОрганизации");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сведения о количестве работающих военнообязанных и призывников.'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КарточкаУчетаОрганизации2015");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сведения о количестве работающих военнообязанных и призывников.'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КарточкаГражданинаПодлежащегоВоинскомуУчету");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сведения о работниках, подлежащих воинскому учету в организации.'");
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли