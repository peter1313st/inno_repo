--create schema university_scores;
--set search_path = "university_scores, public";
--show search_path;

--Создаем таблицу students
create table if not exists university_scores.students (
	id SERIAL PRIMARY KEY,
	name VARCHAR(200),
	total_score INTEGER
);

--Создаем таблицу activity_scores
create table if not exists university_scores.activity_scores (
	id SERIAL PRIMARY KEY,
	student_id INTEGER,
	activity_type VARCHAR(150),
	score INTEGER,
	
	FOREIGN KEY (student_id) REFERENCES university_scores.students(id)
);

-- реализация функции расчет стипендии
CREATE OR REPLACE 
FUNCTION university_scores.calculate_scholarship(student_id INTEGER)
returns INTEGER as $$
	declare 
		--объявим переменную
		student_total_score INTEGER; --общий балл студента
		scholarship_total INTEGER; -- чему равна стbиендия
	begin 
		-- Получить общий балл студента
		-- Сделать выборку (SELECT) по таблице студентов
		-- TODO SELECT .. INTO student_total_score ...
		SELECT total_score INTO student_total_score FROM university_scores.students 
		WHERE university_scores.students.id = student_id;
		-- Рассчитать стипендию в зависимостит от параметра
		
		if student_total_score >= 90 then 
			-- чему равна стипендия?;
			scholarship_total = 1000;
			return scholarship_total;
		elsif student_total_score >= 80 AND student_total_score < 90 then 
			-- чему равна стипендия?;
			scholarship_total = 500;
			return scholarship_total;
		else
			-- чему равна стипендия?;
			scholarship_total = 0;
			return scholarship_total;
		end if;
	--end
	
	
	return scholarship_total;
	end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION university_scores.update_scholarship()
RETURNS TRIGGER AS $$
	begin 
		-- вызываем функцию calculate_scholarship 
		-- для соответствующего студента
		-- TODO 
		SELECT calculate_scholarship(NEW.student_id) INTO NEW.score;
		
		return NEW;
	end;
$$ language plpgsql;

create trigger update_scholarship_trigger
after update on university_scores.activity_scores
for each row 
execute function university_scores.update_scholarship();

-- Создаем функцию update_total_score
/*
 * 
 * update_total_score(student_id INTEGER):
	пересчитывать общий балл студента
	activity_scores
	цикл для итерации по всем записям в
	activity_scores для заданного student_id
	total_score для соответствующего студента в
	таблице students суммой всех баллов
	триггер, который будет автоматически вызывать функцию
	update_total_score при вставке новых записей в таблицу
	activity_scores
*/
create or replace function university_scores.update_total_score() --(student_id INTEGER)
--returns INTEGER as $$
RETURNS TRIGGER AS $$
	declare 
		total_score INTEGER;
		student_total_score INTEGER;
	begin 
		-- Получить общий балл студента
		-- Сделать выборку (SELECT) по таблице студентов
		-- TODO 
		SELECT sum(total_score) INTO student_total_score
		FROM university_scores.students WHERE student_id = students.id;
		-- select sum(score) into total_score ...
		--select sum(score) into total_score
		--from student_total_score;
	return student_total_score;
	end;

$$ language plpgsql;

CREATE OR REPLACE FUNCTION university_scores.update_scores_wrapper()
RETURNS TRIGGER AS 
$$
	begin 
		-- вызываем функцию update_total_score 
		-- для соответствующего студента
		select update_total_score(new.student_id) into new.total_score;
		
		return new;
	end;
$$ language plpgsql;

create trigger update_total_score_trigger
after update on university_scores.activity_scores
for each row 
execute function university_scores.update_total_score();