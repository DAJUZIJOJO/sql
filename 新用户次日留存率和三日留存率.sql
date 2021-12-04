SELECT * FROM 备考测试.t_login;
use 备考测试;
#新用户的次日留存率
select new_day,count(login_date),
count(next_day),count(next_day)/count(login_date) 新用户次日留存率
from (Select t.*,t3.new_day
from (Select t1.*,t2.login_date next_day
from t_login t1 
Left join t_login t2
On date(t1.login_date)=date(t2.login_date)-1) t
join (select uid, min(login_date) new_day from t_login    
group by uid) t3
on t.uid=t3.uid) t4
where t4.login_date=t4.new_day 
group by t4.login_date ;
#新用户的两日留存率
select new_day,count(login_date),
count(sec_day),count(sec_day)/count(login_date) 新用户两日留存率
from (Select t.*,t3.new_day
from (Select t1.*,t2.login_date sec_day
from t_login t1 
Left join t_login t2
On date(t1.login_date)=date(t2.login_date)-2) t
join (select uid, min(login_date) new_day from t_login    
group by uid) t3
on t.uid=t3.uid) t4
where t4.login_date=t4.new_day 
group by t4.login_date ;