#Использовать ".."

Процедура Выполнить()

	Данные = Новый Структура();
	//Данные.Вставить("Тип",               "HRM");
	Данные.Вставить("Тип",               "Accounting");
	Данные.Вставить("Версия",            "30");
	Данные.Вставить("ПолнаяВерсия",      "30");
	Данные.Вставить("ВерсияПлатформы",   "83");
	Данные.Вставить("Логин",             "");
	Данные.Вставить("Пароль",            "");
	Данные.Вставить("КаталогСохранения", "tests/arh");
	//Данные.Вставить("ПутьКБазе",         "C:\Users\usergey\Documents\1C\DemoHRM\");
	Данные.Вставить("ПутьКБазе",         "Srvr=localhost;Ref='BP3Demo'");
	Данные.Вставить("ЛогинБД",           "Любимов (администратор)");
	Данные.Вставить("ПарольБД",          "");
	Данные.Вставить("КаталогВерсии",     "");
	Данные.Вставить("ИмяФайлаВыгрузки",  "bp3");
	Данные.Вставить("Суфикс",            "sql");
	Данные.Вставить("КаталогКопий","c:\work\db\site\copy-lessons\");

	Обновление = Новый ОбновлениеКонфигурации;
	//Обновление.Выполнить(Данные);

	Параметры = Данные;
	
		ПараметрыСоединения = Новый Структура;
		ПараметрыСоединения.Вставить("ПутьКБазе", Параметры.ПутьКБазе);
		ПараметрыСоединения.Вставить("Логин", Параметры.ЛогинБД);
		ПараметрыСоединения.Вставить("Пароль", Параметры.ПарольБД);
		ПараметрыСоединения.Вставить("КаталогВерсии", Параметры.КаталогВерсии);

		Обновление.УстановитьОбновление(ПараметрыСоединения);


КонецПроцедуры

Выполнить();

//Параметры = новый Массив;
////Параметры.Добавить("all");
//Параметры.Добавить("db");
//Параметры.Добавить("c:\work\db\v8_tasks");
//Выполнить(Параметры);