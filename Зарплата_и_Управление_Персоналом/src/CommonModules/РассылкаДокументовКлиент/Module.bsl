#Область СлужебныйПрограммныйИнтерфейс

// Формирует структуру параметров для вызова НачатьРассылку.
// 
// Возвращаемое значение:
//  Структура - Параметры рассылки:
// * ЗаголовокФормы - Строка - с помощью параметра можно переопределить заголовок формы рассылки.
// * ПечатныеФормы - Структура, Массив - рассылаемые печатные формы, см. РассылкаДокументовКлиентСервер.НоваяПечатнаяФорма().
// * ТемаПисьма - Строка - тема сопроводительного письма по умолчанию.
// * ТекстПисьма - Строка - текст сопроводительного письма по умолчанию.
//
Функция ПараметрыРассылки() Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("ЗаголовокФормы", "");
	Параметры.Вставить("ПечатныеФормы");
	Параметры.Вставить("ТемаПисьма", "");
	Параметры.Вставить("ТекстПисьма", "");
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.РассылкаДокументов") Тогда
		МодульРассылкаПоШаблонамКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РассылкаПоШаблонамКлиент");
		МодульРассылкаПоШаблонамКлиент.ДополнитьПараметрыРассылки(Параметры);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

// Метод предназначен для запуска рассылки документов в случае, если документ не подключен к механизму состава документов, 
// или по другой причине требуется сделать рассылку по заданному набору получателей. 
// 
// Параметры:
//  РассылаемыеДокументы - ОпределяемыйТип.РассылаемыйДокумент.
//  Получатели - Массив Из Структура - обязательные поля РассылаемыйДокумент и Получатель.
//  ПараметрыРассылки - Неопределено, Структура - см. ПараметрыРассылки().
//
Процедура НачатьРассылку(РассылаемыеДокументы, Получатели, ПараметрыРассылки = Неопределено) Экспорт
	
	Если ПараметрыРассылки = Неопределено Тогда
		ПараметрыРассылки = ПараметрыРассылки();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РассылаемыеДокументы", РассылаемыеДокументы);
	ПараметрыФормы.Вставить("Получатели", Получатели);
	Для Каждого КлючИЗначение Из ПараметрыРассылки Цикл
		ПараметрыФормы.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ОткрытьФорму("Обработка.РассылкаПечатныхФорм.Форма", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти