#Использовать v8runner

Функция ПолучитьТипБД(Путь) Экспорт
	
	ВариантБД = "";
	Если (СтрНачинаетсяС(Путь,"\\")) Тогда
		ВариантБД = "File";
	ИначеЕсли (Сред(Путь, 2, 1) = ":") Тогда
		ВариантБД = "File";
	ИначеЕсли (СтрНачинаетсяС(Путь,"http://")) Тогда
		ВариантБД = "ws";
	ИначеЕсли (СтрНачинаетсяС(Путь,"https://")) Тогда
		ВариантБД = "ws";
	Иначе
		ВариантБД = "Srvr";
	КонецЕсли;
	Возврат ВариантБД;

КонецФункции // ОпределитьТипБД(Парамеры) Экспорт

// Вспомогательные методы
// 
Процедура ОбеспечитьКаталог(Знач Каталог)

	Файл = Новый Файл(Каталог);
	Если Не Файл.Существует() Тогда
		СоздатьКаталог(Каталог);
	ИначеЕсли Не Файл.ЭтоКаталог() Тогда
		ВызватьИсключение "Каталог " + Каталог + " не является каталогом";
	КонецЕсли;

КонецПроцедуры

Функция ОбернутьВКавычки(Знач Строка);
	Возврат """" + Строка + """";
КонецФункции

// Создание резервной копии базы.
// Не делает проверку на наличие соединений с базой
//
// Параметры:
//  Параметры  - Структура - Параметры соединения и архивирования
//    ПутьКБазе - Строка - Строка соединения с базой
//    Логин - Строка - Логин для входа в базу
//    Пароль - Строка - Пароль для входа в базу
//    КаталогКопий - Строка - Куда положить резервную копию
//    ИмяФайлаВыгрузки - Строка - Основная часть имени резервной копии
//    Суфикс - Строка - Дополнительный текст вставляемый в имя файла копии
//
// Возвращаемое значение:
//   Булево
//
Функция СделатьРезервнуюКопию(Параметры) Экспорт

	ТипБазы = ПолучитьТипБД(Параметры.ПутьКБазе);

	Если ТипБазы = "ws" Тогда
		Сообщить("Нельзя сделать выгрузку для базы на WEB-сервере");
		Возврат Ложь;
	ИначеЕсли ТипБазы = "Srvr" Тогда
		СтрокаСоединения = "/IBConnectionString" + ОбернутьВКавычки(Параметры.ПутьКБазе);
	ИначеЕсли ТипБазы = "File" Тогда
		СтрокаСоединения = "/F" + Параметры.ПутьКБазе;
	КонецЕсли;

	Конфигуратор = Новый УправлениеКонфигуратором();

	СтрДата = Формат(ТекущаяДата(), "ДФ=""гггг-ММ-дд_ЧЧ-мм""");
	ПутьВыгрузки = ОбъединитьПути(Параметры.КаталогКопий, Параметры.ИмяФайлаВыгрузки + "_" + СтрДата + "-" + Параметры.Суфикс + ".dt");
	

	Конфигуратор.УстановитьКонтекст(СтрокаСоединения, Параметры.Логин, Параметры.Пароль);
	Конфигуратор.ВыгрузитьИнформационнуюБазу(ПутьВыгрузки);

	Возврат Истина;

КонецФункции // СделатьРезервнуюКопию()

// Создание резервной копии базы.
// В случае наличия пользователей в базе добавит суфикс online.
// Подходит только для файловых баз
//
// Параметры:
//  Параметры  - Структура - Параметры соединения и архивирования
//    ПутьКБазе - Строка - Строка соединения с базой
//    Логин - Строка - Логин для входа в базу
//    Пароль - Строка - Пароль для входа в базу
//    КаталогКопий - Строка - Куда положить резервную копию
//    ИмяФайлаВыгрузки - Строка - Основная часть имени резервной копии
//    Суфикс - Строка - Дополнительный текст вставляемый в имя файла копии
//
// Возвращаемое значение:
//   Булево
//
Функция СделатьГрубуюРезервнуюКопию(Параметры) Экспорт

	ТипБазы = ПолучитьТипБД(Параметры.ПутьКБазе);

	Если ТипБазы <> "File" Тогда
		Сообщить("Грубая резервная копия не сделана. Тип базы не файловый!");
		Возврат Ложь;
	КонецЕсли;

	Конфигуратор = Новый УправлениеКонфигуратором();

 	ФайлНаличияСоединений = Новый Файл(ОбъединитьПути(Параметры.ПутьКБазе,"1Cv8tmp.1CD"));
 	
 	Суфикс = "-" + Параметры.Суфикс;
	Если ФайлНаличияСоединений.Существует() Тогда
		Суфикс = "-online" + Суфикс;
	КонецЕсли;

	СтрДата = Формат(ТекущаяДата(), "ДФ=""гггг-ММ-дд_ЧЧ-мм""");
	
	КаталогКопий = Параметры.КаталогКопий;
	СтрокаСоединения = "/F" + КаталогКопий;
	
	ФайлБазы = ОбъединитьПути(Параметры.ПутьКБазе, "1Cv8.1CD");
	
	ЮИД = Новый УникальныйИдентификатор();
			   
	ОбеспечитьКаталог(КаталогКопий + ЮИД);

	КопироватьФайл(ФайлБазы , ОбъединитьПути(КаталогКопий, ЮИД, "1Cv8.1CD"));
	
	Конфигуратор.УстановитьКонтекст(ОбъединитьПути(СтрокаСоединения, ЮИД), Параметры.Логин, Параметры.Пароль);
	Конфигуратор.ВыгрузитьИнформационнуюБазу(ОбъединитьПути(КаталогКопий, Параметры.ИмяФайлаВыгрузки + "_" + СтрДата + Суфикс + ".dt"));
	УдалитьФайлы(ОбъединитьПути(КаталогКопий, ЮИД));	

	Возврат Истина;
КонецФункции

Процедура Инициализация()
	
КонецПроцедуры

Инициализация();


