--DROP TABLE public.college CASCADE;
/*
select * from public.college;
select * from public.course;
select * from public.student;
select * from public.student_on_course;
*/

/*a. Напишите SQL запрос который возвращает имена студентов и их аккаунт
в Telegram у которых родной город “Казань” или “Москва”. Результат
отсортируйте по имени студента в убывающем порядке */
select name, telegram_contact from public.student
where city = 'Казань' or city = 'Москва';

/*b. Напишите SQL запрос который возвращает данные по университетам в
следующем виде (один столбец со всеми данными внутри) с сортировкой
по полю “полная информация”
"полная информация"
университет: Иннополис; количество студентов: 1077*/
select concat('университет: ',name,'; ','количество студентов: ',size) as "полная информация"
from public.college
order by "полная информация";

/*c. Напишите SQL запрос который возвращает список университетов и
количество студентов, если идентификатор университета должен быть
выбран из списка 10, 30, 50. Пожалуйста примените конструкцию IN.
Результат запроса отсортируйте по количеству студентов И затем по
наименованию университета.*/
select name, size 
from public.college
where id in (10, 30, 50)
order by size, name;

/*d. Напишите SQL запрос который возвращает список университетов и
количество студентов, если идентификатор университета НЕ должен
соответствовать значениям из списка 10, 30, 50. Пожалуйста в основе
примените конструкцию IN. Результат запроса отсортируйте по
количеству студентов И затем по наименованию университета.*/
select name, size 
from public.college
where id not in (10, 30, 50)
order by size, name;

/*e. Напишите SQL запрос который возвращает название online курсов
университетов и количество заявленных слушателей. Количество
заявленных слушателей на курсе должно быть в диапазоне от 27 до 310
студентов. Результат отсортируйте по названию курса и по количеству
заявленных слушателей в убывающем порядке для двух полей.*/
select name, amount_of_students 
from public.course
where is_online = true and amount_of_students between 27 and 310
order by name desc, amount_of_students desc;

/*f. Напишите SQL запрос который возвращает имена студентов и название
курсов университетов в одном списке. Результат отсортируйте в
убывающем порядке. Пример части результата представлен ниже
name
Цифровая трансформация
Сергей Петров*/
select name from public.student
union
select name from public.course
order by name desc;

/*g. Напишите SQL запрос который возвращает имена университетов и
название курсов в одном списке, но с типом что запись является или
“университет” или “курс”. Результат отсортируйте в убывающем порядке
по типу записи и потом по имени. Пример части результата представлен
ниже
name object_type
Иннополис университет
КФУ университет
… …
Data Mining курс*/
select name, 'университет' as object_type from public.college
union
select name, 'курс' as object_type from public.course
order by object_type desc, name desc;

/*h. Напишите SQL запрос который возвращает название курса и количество
заявленных студентов в отсортированном списке по количеству
слушателей в возрастающем порядке, НО запись с количеством
слушателей равным 300 должна быть на первом месте. Ограничьте
вывод данных до 3 строк. Пример результата представлен ниже
name amount_of_students
Введение в РСУБД 300
Data Mining 10
Актерское мастерство 15*/
SELECT 
	c.name,
	c.amount_of_students /*,
	CASE
		WHEN c.amount_of_students < 25
			THEN 'малокомплектная группа'
		WHEN c.amount_of_students >= 25 AND c.amount_of_students < 50
			THEN 'группа среднего размера'
		WHEN c.amount_of_students > 200 AND c.amount_of_students < 250
			THEN 'группа большого размера, поточный курс'
		ELSE 'более одной группы'
	END AS amount_text_str*/
FROM course c
ORDER BY 
	CASE 
		WHEN c.amount_of_students = 300 
			THEN -1
		ELSE 
			c.amount_of_students
	END
LIMIT 3;
 
/*i. Напишите DML запрос который создает новый offline курс со
следующими характеристиками:
- id = 60
- название курса = Machine Learning
- количество студентов = 17
- курс проводится в том же университете что и курс Data Mining
Предоставьте INSERT выражение которое заполняет необходимую
таблицу данными
Приложите скрин результата запроса к данным курсов после
выполнения команды INSERT к таблице которая была изменена.*/
insert into course(id, name, is_online, amount_of_students, college_id) values (60,'Machine Learning', false, 17 , 
(select college_id
from course
where name = 'Data Mining')
);
--select * from course;
/*
j. Напишите SQL скрипт который подсчитывает симметрическую разницу
множеств A и B.
(A \ B) U (B \ A)
где A - таблица course, B - таблица student_on_course, “\” - это разница
множеств, “U” - объединение множеств. Необходимо подсчитать на
основании атрибута id из обеих таблиц. Результат отсортируйте по 1
столбцу. Пример результата представлен ниже.
*/
select B.id from course as A full outer join student_on_course as B
on A.id = B.id
where A.id is NULL or
B.id is null
order by A.id

/*k. Напишите SQL запрос который вернет имена студентов, курс на котором
они учатся, названия их родных университетов (в которых они
официально учатся) и соответствующий рейтинг по курсу. С условием
что рассматриваемый рейтинг студента должен быть строго больше (>)
50 баллов и размер соответствующего ВУЗа должен быть строго больше
(>) 5000 студентов. Результат необходимо отсортировать по первым двум
столбцам. Обратите внимание на часть ответа ниже с учетом
именования выходных атрибутов вашего запроса
student_name course_name student_college student_rating
Анна Потапова Нейронные сети МФТИ 76
Екатерина Андреева Актерское мастерство МГУ 95*/
select st.name st_name, 
--soc.course_id, 
--st.college_id, 
crs.name crs_name,
clg.name clg_name,
soc.student_rating
from public.student as st 
inner join public.student_on_course as soc on st.id = soc.student_id 
inner join public.college as clg on st.college_id = clg.id 
inner join public.course as crs on soc.course_id = crs.id 
where student_rating > 50 and clg.size > 5000
order by st_name, crs_name

/*
 l. Выведите уникальные семантические пары студентов, родной город
которых один и тот же. Результат необходимо отсортировать по первому
столбцу. Семантически эквивалентная пара является пара студентов
например (Иванов, Петров) = (Петров, Иванов), в этом случае должна
быть выведена одна из пар. Обратите внимание на ответ ниже с учетом
именования выходных атрибутов вашего запроса
student_1 student_2 city
Ильяс Мухаметшин Иван Иванов Казань
Сергей Петров Екатерина Андреева Москва
*/
select distinct s1.name s1name, s2.name s2name, s1.city
from student s1 full outer join student s2
on s1.city = s2.city 
where s1.name != s2.name and s1.name is not null and s2.name is not null 
order by 1

/*
m. Напишите SQL запрос который возвращает количество студентов,
сгруппированных по их оценке. Результат отсортируйте по названию
оценки студента. Формула выставления оценки представлена ниже как
псевдокод.
ЕСЛИ оценка < 30 ТОГДА неудовлетворительно
ЕСЛИ оценка >= 30 И оценка < 60 ТОГДА удовлетворительно
ЕСЛИ оценка >= 60 И оценка < 85 ТОГДА хорошо
В ОСТАЛЬНЫХ СЛУЧАЯХ отлично
Пример результата ниже. Обратите внимание на именование
результирующих столбцов в вашем решении. Курс “Machine Learning”, так
как у него нет студентов - проигнорируйте, используя соответствующий
тип JOIN.
оценка количество студентов
неудовлетворительно 2
отлично 3
удовлетворительно 3
хорошо 5
*/
select count(*) "количество студентов",   
	CASE
		WHEN student_rating < 30
			THEN 'неудовлетворительно'
		WHEN student_rating >= 30 AND student_rating < 60
			THEN 'удовлетворительно'
		WHEN student_rating >= 60 AND student_rating < 85
			THEN 'хорошо'
		ELSE 'отлично'
	END AS "оценка"
from student_on_course --soc
group by "оценка"--student_rating 
order by "оценка"

/*
n. Дополните SQL запрос из задания a), с указанием вывода имени курса и
количество оценок внутри курса. Результат отсортируйте по названию
курса и оценки студента. Пример части результата ниже.
Обратите внимание на именование результирующих столбцов в вашем
решении. Курс “Machine Learning”, так как у него нет студентов -
проигнорируйте, используя соответствующий тип JOIN.
курс оценка количество студентов
Data Mining неудовлетворительно 1
*/
select c.name "курс", count(*) "количество студентов",   
	CASE
		WHEN student_rating < 30
			THEN 'неудовлетворительно'
		WHEN student_rating >= 30 AND student_rating < 60
			THEN 'удовлетворительно'
		WHEN student_rating >= 60 AND student_rating < 85
			THEN 'хорошо'
		ELSE 'отлично'
	END AS "оценка"
from student_on_course soc inner join course c on soc.course_id =c.id 
group by "курс", "оценка"--student_rating 
order by "оценка"