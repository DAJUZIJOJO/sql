
create table t_login(
    uid int,
    login_date date
);

insert into t_login values (123,'2018-08-02');
insert into t_login values (123,'2018-08-03');
insert into t_login values (123,'2018-08-04');
insert into t_login values (456,'2018-11-02');
insert into t_login  values (456,'2018-11-09');
insert into t_login  values (789,'2018-01-01');
insert into t_login  values (789,'2018-04-23');
insert into t_login  values (789,'2018-11-10');
insert into t_login   values (789,'2018-11-11');
insert into t_login  values (789,'2018-11-12');
desc t_login;

select substr(con,1,3) user_id,
date(substr(con,4,10))+1 连续开始时间,
count(con) 连续登录天数
from 
( 
select A.uid, 
concat(A.uid,date_sub(A.login_date,interval A.rn DAY) ) con, 
A.login_date
from ( select uid, login_date, MONTH(login_date) m1,
row_number() over (partition by uid order by login_date) as rn 
from t_login)A 
Where A.m1=11 
)B
group by B.con;

##############
select month(login_date),date_sub(login_date,interval 1 DAY) AS inteval_days 
from t_login;

#####每个用户11月最大的连续登录天数
select uid,开始日期,MAX(cou) 最大连续登陆天数
from
(
select uid,interday+1 开始日期, count(1) cou
from 
( 
select A.uid, date_sub(A.login_date,interval A.rn DAY) interday, 
A.login_date
from ( select uid, login_date, MONTH(login_date) m1,
row_number() over (partition by uid order by login_date) as rn 
from t_login)A 
Where A.m1=11 
)B
group by  uid ,interday
) C
group by uid;

#计算每天的三日留存率
select count(1) 连续三天人数,interday
from (
select A.uid, date_sub(A.login_date,interval A.rn-1 DAY) interday, 
count(1) 连续天数
from ( select uid, login_date, MONTH(login_date) m1,
row_number() over (partition by uid order by login_date) as rn 
from t_login)A 
#Where A.m1=11 
group by  uid ,interday
having 连续天数=3 ) B
group by B.interday ;

##################
select * from 
(select count(1) 今日登录人数,login_date
from t_login
group by login_date) 
T1
left join 
(select count(1) 连续三天人数,interday
from (
select A.uid, date_sub(A.login_date,interval A.rn-1 DAY) interday, 
 A.login_date,
count(1) 连续天数
from ( select uid, login_date, MONTH(login_date) m1,
row_number() over (partition by uid order by login_date) as rn 
from t_login)A 
group by  uid ,interday
having 连续天数=3 ) B
group by B.interday )
T2  
ON T2.interday=T1.login_date;