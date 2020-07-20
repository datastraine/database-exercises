select * from albums
where artist = 'Pink Floyd';

select release_date from albums
where name = "Sgt. Pepper's Lonely Hearts Club Band";

select genre from albums
where name = "Nevermind";

select * from albums
where release_date like '199%';

select * from albums
where sales < 20;

select * from albums
where genre = "Rock"
--because SQL is fairly explict and requires a contain or like function 
--to pull all sub grenes of rock as they are in the same column


