////////////////////////////////////////////////////////////////////////////////
// Подсистема "Ограничение использования документов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет ограниченность документа для редактирования и выполнения прочих команд.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, который проверяется.
//
// Возвращаемое значение:
//  Булево
//
Функция ДокументОграничен(Документ) Экспорт
	
	Возврат Не (Документ.Пустая() ИЛИ Не РегистрыСведений.ОграниченныеДокументы.ДокументОграничен(Документ));
	
КонецФункции

#КонецОбласти
