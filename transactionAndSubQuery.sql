desc dept;
desc emp;

insert into dept values(50,'연구소1','서울');
select * from dept;
insert into dept(deptno,dname,loc) values(51,'연구소2','대전');
select * from dept;

insert into dept values('중부영업점','대구');
insert into dept(dname,loc) values('중부영업점','대구');
insert into dept(dname,loc) values('중부지점','대구');
select * from dept;

insert into dept(deptno,dname,loc) values(52,'북부지점',null);
select * from dept;
insert into dept(deptno,dname,loc) values(53,'남부지점','');
select * from dept;

insert into dept(deptno,dname) values(54,'서부지점');
select deptno,dname,nvl(loc,'미지정영역') as loc from dept;
commit;

--
update dept set dname = ' M연구소' where deptno = 50;
update dept set dname = ' T연구소', loc = '인천' where deptno = 51;
select * from dept where deptno in (50,51);
commit;

update dept set loc='미개척지';
select * from dept;
rollback;
select * from dept;

select dname,replace(dname,' ','*') from dept;
update dept set dname=trim(dname);
select dname,replace(dname,' ','*') from dept;
commit;
select * from dept;

--
delete from dept where loc is null or deptno is null;
select * from dept;
commit;

delete dept;
select * from dept;

rollback;
select * from dept;

--
insert into dept(deptno,dname,loc) values(90,'신사업부','경기도');
update emp set deptno=90 where deptno=30;
delete from dept where deptno=30;
select * from dept;
select * from emp where deptno=30;
rollback;
select * from dept;
select * from emp;

insert into emp(empno,ename,job,sal) values(1111,'Oracle','DBA',3500);
update emp set sal=sal*1.3 where empno=1111;
commit;
rollback;
select * from emp;

desc emp;

--Statemnet level rollback
rollback;
delete from emp where empno=1111;
update emp set sal=123456789 where empno=7788;
update emp set sal=1234 where empno=7902;
commit;
select empno,sal from emp where empno in (1111,7788,7902);

select * from emp;


-- begin-exception-end; Transaction level rollback
begin
    delete from emp where deptno=20;
    update emp set sal=123456789 where empno=7499;
    update emp set sal=1234 where empno=7698;
    commit;
exception
    when others then
        rollback;
end;
/
select empno,sal from emp where deptno=20 or empno in (7499,7698);

-- transaction and ddl
insert into emp(empno,ename,deptno) values(9999,'OCPOK',20);
alter table emp add(sex char(1) default'M');
rollback;
desc emp;
alter table emp drop column sex;
rollback;
desc emp;


--SubQuery
select ename,job from emp
where deptno=(select deptno from emp where ename='SMITH');

select ename,sal from emp where sal < (select avg(sal) from emp);

select ename,job from emp where deptno=10,30;
select ename,job from emp where deptno in (10,30);

select dname,loc from dept
where deptno in (select deptno from emp group by deptno having count(*) > 3);

select deptno,job,ename,sal from emp
where (deptno,job) in (select deptno,job from emp group by deptno,job having avg(sal) > 2000);

-- Scalar SubQuery & Correlated SubQuery
select deptno,ename,job,sal, (select round(avg(sal),0) 
from emp S where S.JOB=M.JOb) as job_avg_sal
from emp M
order by job;

select deptno,ename,job,sal from emp M
where sal > (select avg(sal) as avg_sal from emp where job=M.JOB);

--In-line view
select deptno,ename,emp.job,sal,iv.avg_sal
from emp,(select job,round(avg(sal)) as avg_sal from emp group by job) iv
where emp.job = iv.job and sal > iv.avg_sal
order by deptno,sal desc;

--Top-n, Bottom-m
select *
from (select empno,ename,sal from emp order by sal asc) bm
where rownum <= 5;

select tn.empno,tn.ename,tn.sal
from (select empno,ename,sal from emp order by sal desc) tn
where rownum < 5;

--DML & SubQuery
insert into bonus(ename,job,sal,comm) select ename,job,sal,comm from emp;

select * from bonus;
rollback;
select * from bonus;

insert into bonus(ename,job,sal,comm)
select ename,job,sal,decode(deptno,10,sal*0.3,20,sal*0.2)+nvl(comm,0)
from emp where deptno in (10,20);

select * from bonus;
commit;

update emp set comm=(select avg(comm)/2 from emp) where comm is null or comm = 0;
select * from emp;
commit;

delete from bonus where sal > (select avg(sal) from emp);
commit;
select * from emp;
select * from bonus;














