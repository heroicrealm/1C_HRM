////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотКлиентПовтИсп, клиент, повт. использование
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает настройки базы Документооборота.
//
// Возвращаемое значение:
//   см. ИнтеграцияС1СДокументооборотВызовСервера.ПолучитьНастройки
//
Функция ПолучитьНастройки() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.ПолучитьНастройки();
	
КонецФункции

// Возвращает максимально допустимый размер файла из соответствующей константы.
//
// Возвращаемое значение:
//   Число
//
Функция МаксимальныйРазмерПередаваемогоФайла() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.МаксимальныйРазмерПередаваемогоФайла();
	
КонецФункции

// Получает доступность функционала версии web-сервиса Документооборота.
//
// Параметры:
//   ВерсияСервиса - Строка - версия web-сервиса Документооборота, содержащая требуемый функционал.
//
// Возвращаемое значение:
//   Булево - Истина, если web-сервис Документооборота указанной версии доступен.
//
Функция ДоступенФункционалВерсииСервиса(ВерсияСервиса = "") Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.ДоступенФункционалВерсииСервиса(ВерсияСервиса);
	
КонецФункции

// Проверяет, известен ли пароль пользователя ДО. Возвращает Истина, если пароль пользователя ДО уже известен.
//
// Возвращаемое значение:
//   Булево
//
Функция ПарольИзвестен() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.ПарольИзвестен();
	
КонецФункции

// Проверяет, используется ли аутентификация ОС. Возвращает Истина, если используется аутентификация ОС.
//
// Возвращаемое значение:
//   Булево
//
Функция ИспользуетсяАутентификацияОС() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.ИспользуетсяАутентификацияОС();
	
КонецФункции

// Получает версию сервиса ДО.
//
// Возвращаемое значение:
//   Строка - версия сервиса.
//
Функция ВерсияСервиса() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.ВерсияСервиса();
	
КонецФункции

// Проверяет, настроена ли интеграция для указанного объекта интегрируемой системы.
//
// Параметры:
//   ОбъектИС - Произвольный - проверяемый объект ИС.
//
// Возвращаемое значение:
//   Булево
//
Функция НастроенаИнтеграцияДляОбъекта(ОбъектИС) Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.НастроенаИнтеграцияДляОбъекта(ОбъектИС);
	
КонецФункции

// Проверяет, используются ли присоединенные файлы ДО.
//
// Возвращаемое значение:
//   Булево
//
Функция ИспользоватьПрисоединенныеФайлы1СДокументооборота() Экспорт
	
	Возврат ИнтеграцияС1СДокументооборотВызовСервера.
		ИспользоватьПрисоединенныеФайлы1СДокументооборота();
	
КонецФункции

// Возвращает Истина, если используется термин "Корреспонденты".
//
// Возвращаемое значение:
//   Булево
//
Функция ИспользоватьТерминКорреспонденты() Экспорт
	
	Возврат Не ИнтеграцияС1СДокументооборотВызовСервера.ДоступенФункционалВерсииСервиса("2.1.0.1");
	
КонецФункции

#КонецОбласти