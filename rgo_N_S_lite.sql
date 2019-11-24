drop view rgonorth;
create view rgonorth as
select date, cwsa, lns, cld
from sunspots
where cwsa is not null
and lns >= 0
;

drop view rgosouth;
create view rgosouth as
select date, cwsa, lns, cld
from sunspots
where cwsa is not null
and lns <= 0
;

.mode csv
.header on
.output rgo_N_S_lite.csv

select s.date, s.cwsa, n.cwsa,
s.lns slat, n.lns nlat, 
s.cld slong, n.cld nlong,
count(*)
from rgonorth n, rgosouth s
where n.date = s.date
and substr(s.date,1,4) >= '1874'
group by s.date

;

