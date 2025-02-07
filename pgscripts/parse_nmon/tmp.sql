-- Создаем временную таблицу
CREATE TABLE nmon_tmp (
    TOP text,
    "+PID" bigint,
    "Time" text,
    "%CPU" float,
    "%Usr" float,
    "%Sys" float,
    "Size" float,
    "ResSet" float,
    "ResText" float,
    "ResData" float,
    "ShdLib" float,
    "MinorFault" float,
    "MajorFault" float,
    "Command" text,
    "d1" int,
    "d2" int
);

-- Загружаем данные из вывода командной строки
COPY nmon_tmp FROM '/tmp/tmp.table' DELIMITER ',' CSV;
