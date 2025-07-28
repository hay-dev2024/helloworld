select * from tab;

select count(*) from emp_large;
select count(*) from bonus_large;
select count(*) from customer;


select rownum,ename,deptno,sal from emp;
select rownum,ename,deptno,sal from emp order by deptno,sal;

select rownum,ename,deptno,sal from emp where deptno in (10,20) order by deptno,sal;

select ename,deptno,sal from emp where rownum = 1;
select ename,deptno,sal from emp where rownum = 3;
select ename,deptno,sal from emp where rownum > 3;

select ename,deptno,sal from emp where rownum <= 3;
select ename,deptno,sal from emp where rownum < 3;

select ename,job,sal,deptno from emp where sal > 2000 or sal > 2000;
select ename,job,sal,deptno from emp where sal > 2000 and sal > 2000;


--single row func
select ename,empno,sal,comm from emp;

select ename,lower(ename),upper(lower(ename)),length(ename),abs(sal-empno),comm
from emp;

select ename,substr(ename,1,3) from emp
where hiredate between to_date('1981/01/01', 'yyyy/mm/dd') and to_date('1982/12/31', 'yyyy/mm/dd')
order by length(ename);

select ename,substr(ename,1,3) from emp
where hiredate between to_date('1981/01/01', 'yyyy/mm/dd') and to_date('1982/12/31', 'yyyy/mm/dd')
order by length(ename), ename asc;


--group row func
select avg(sal),sum(sal),sum(comm),count(*) from emp;

select deptno,count(*),sum(sal),avg(sal) from emp
group by deptno;

select deptno,job,count(*),sum(sal),avg(sal) from emp
group by deptno,job
order by deptno,job;


--문자함수
select ename,lower(ename),upper(ename),initcap(ename) from emp;
select ename,substr(ename,1,3),substr(ename,4),substr(ename,-3,2) from emp;

select ename,instr(ename,'A'),instr(ename,'A',2),instr(ename,'A',1,2), ascii(' ') from emp;

select ename,rpad(ename,10,' '),rpad(ename,10),rpad(ename,10,'*'),lpad(ename,10,'+') from emp;
select length(rpad('X',1000,'X')), rpad('X', 1000, 'X') from dual;

select ename, replace(ename, 'S', 's') from emp;

select ename, concat(ename, job), ename||job from emp;

select ltrim(' 대한민국 '), rtrim(' 대한민국 '), trim(' ' from ' 대한민국 '), trim('*' from '**대한민국**') from dual;
select trim('장' from '장발장'), ltrim('장발장','장'),rtrim('장발장','장') from dual;

select length('abcd'), substr('abcd',2,2), length('대한민국'), substr('대한민국',2,2) from dual;

select lengthb('abcd'),lengthb('대한민국'),substr('대한민국',2,2),substrb('대한민국',2,2) from dual;

select length('abcd'), vsize('abcd'), length('대한민국'), vsize('대한민국') from dual;



--
select sysdate, sysdate+7,sysdate-2,sysdate+1/24 from dual;

select deptno,ename,trunc(sysdate-hiredate) as work_day, sysdate-hiredate
from emp
order by deptno, work_day desc;

select ename,sysdate,hiredate,
        to_char(sysdate,'yyyy-mm-dd:hh24:mi:ss'), to_char(hiredate, 'yyyy-mm-dd:hh24:mi:ss')
from emp;


alter session set nls_date_format = 'yyyy-mm-dd:hh24:mi:ss';
select ename,sysdate,hiredate from emp;
select sysdate from dual;

--session id 확인하는 명령어
select sid from v$mystat;


select hiredate,months_between(sysdate,hiredate),months_between(hiredate,sysdate) from emp;
select sysdate,add_months(sysdate,3),next_day(sysdate,'일요일'),next_day(sysdate,2) from dual;
select sysdate,round(sysdate,'YEAR'),round(sysdate,'MONTH'),round(sysdate,'DAY'),round(sysdate)
from dual;

select sysdate,trunc(sysdate,'YEAR'),trunc(sysdate,'MONTH'),trunc(sysdate,'DAY'),trunc(sysdate) from dual;
select to_char(sysdate,'MM"월"DD"일"') as mmdd1,
       to_char(sysdate,'MM')||'월'||to_char(sysdate,'DD')||'일' as mmdd2 from dual;
select extract(year from sysdate),extract(month from sysdate),extract(day from sysdate) from dual;


select sysdate, to_char(sysdate,'YEAR'), to_char(sysdate,'Year'),
                to_char(sysdate,'YYYY'), to_char(sysdate,'YY') from dual;

select to_char(sysdate,'MONTH'),to_char(sysdate,'MON'),
       to_char(sysdate,'Mon'),to_char(sysdate,'mon'),
       to_char(sysdate,'MM'),to_char(sysdate,'mm') from dual;
              
select sysdate,
       to_char(sysdate,'DAY'), to_char(sysdate,'Day'),to_char(sysdate,'DY'),to_char(sysdate,'dy'),
       to_char(sysdate,'DD'), to_char(sysdate,'dd') from dual;

select -123456,to_char(-123456,'999999'), replace(to_char(123456,'999999'), ' ' , '*'), length(to_char(-123456,'999999')),
        length(to_char(-123456,'fm999999'))
from dual;

select to_char(12345*123.45,'999,999.99'), to_char(12345*123.45,'99,999,999.99') from dual;

select to_char(sal,'$999,999'), replace(to_char(sal,'$999,999'),' ','?'),
       to_char(sal,'L999,999'), to_char(sal,'999,999L'), to_char(sal,'fm999,999L')
from emp;


--

select * from emp;
desc emp;

select * from v$version;
select job from emp group by job;

explain plan for
select job from emp group by job;

select * from table(dbms_xplan.display);



--
select to_char(sysdate,'DDD'),to_char(sysdate,'DD'),to_char(sysdate,'D') from dual;
select last_day(sysdate) from dual;


select to_char(last_day(sysdate), 'D'), case
        when to_char(sysdate, 'D') = '1' then '금요일'
        when to_char(sysdate, 'D') = '2' then '월요일'
        when to_char(sysdate, 'D') = '3' then '수요일'
        when to_char(sysdate, 'D') = '4' then '목요일'
        when to_char(sysdate, 'D') = '5' then '금요일'
        when to_char(sysdate, 'D') = '6' then '토요일'
        when to_char(sysdate, 'D') = '7' then '금요일' 
        end as 마지막영업일
    
from dual;

--

select deptno, min(sal), max(sal)
from emp
group by deptno
order by deptno;


select  sum(decode(deptno,10,count(deptno))) as "10번부서", 
        sum(decode(deptno,20,count(deptno))) as "20번부서",
        sum(decode(deptno,30,count(deptno))) as "30번부서"
from emp
group by deptno;



select  sum(decode(deptno,10,1)) as "10번부서", 
        sum(decode(deptno,20,1)) as "20번부서",
        sum(decode(deptno,30,1)) as "30번부서"
from emp
group by deptno;








