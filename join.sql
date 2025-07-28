desc emp
desc dept

-- join
-- Equi-join
select dname,ename,sal from dept,emp where dept.deptno=emp.deptno;

select dname,ename,job,sal from emp, dept where deptno=deptno;

select dname,ename,job,sal from scott.emp, scott.dept where emp.deptno=dept.deptno;

select dname,ename,job,sal from emp, dept
where emp.deptno = dept.deptno and emp.job in ('MANAGER', 'CLERK');

select d.dname,e.ename,e.job,e.sal from emp e, dept d where e.deptno=d.deptno;

select d.dname,e.ename,e.job,e.sal from emp e inner join dept d
on e.deptno=d.deptno;

select d.dname,e.ename,e.job,e.sal from emp e inner join dept d
on e.deptno=d.deptno
where e.deptno in (10,20) and d.dname='RESEARCH';

select * from salgrade;

--Non Equi-join
select e.ename,e.job,e.sal,s.grade from emp e, salgrade s
where e.sal between s.losal and s.hisal;

select dname,ename,job,sal,grade
from emp e, dept d, salgrade s
where e.deptno=d.deptno and e.sal between s.losal and s.hisal;

select e.ename,e.job,e.sal,s.grade from emp e, salgrade s
where e.sal between s.losal and s.hisal and e.deptno in (10,30)
order by e.ename;

select e.ename,e.job,e.sal,s.grade from emp e, salgrade s
where e.sal < s.losal and e.deptno in (10,30)
order by e.ename;

select deptno, ename from emp;

--Outer-join
select d.dname,e.ename,e.job,e.sal from emp e,dept d where e.deptno=d.deptno
order by d.dname;

select d.dname,e.ename,e.job,e.sal from emp e,dept d where e.deptno(+) = d.deptno
order by d.dname;

select d.dname,e.ename,e.job,e.sal from emp e,dept d where e.deptno = d.deptno(+)
order by d.dname;

select d.dname,nvl(e.ename,'비상근 부서'),e.job,e.sal from emp e,dept d
where e.deptno(+)=d.deptno
order by d.dname;

select d.dname,e.ename,e.job,e.sal from emp d,dept d where e.deptno(+)=d.deptno(+)
order by d.dname;

--Ansi Outer-join
select e.deptno,d.dname,e.ename from emp e left outer join dept d
on e.deptno=d.deptno
order by e.deptno;

select e.deptno,d.dname,e.ename from emp e right outer join dept d
on e.deptno=d.deptno
order by e.deptno;

select d.deptno,d.dname,e.ename from scott.emp e full outer join scott.dept d
on e.deptno=d.deptno
order by e.deptno;

--Self-join
select e.ename||' "S MANAGER IS '||m.ename
from emp e, emp m
where e.mgr=m.empno
order by m.ename;


--과제
--select * from system;
--select * from resource_usage;
--
--select s.system_id,s.system_name, r.resource_name 
--from system s, resource_usage r
--where s.system_id(+)=r.system_id
--order by s.system_id;



--Constraint
--Not null
CREATE TABLE CUSTOMER1(
                ID VARCHAR2(8) NOT NULL,
                PWD VARCHAR2(8) CONSTRAINT CUSTOMER_PWD_NN NOT NULL,
                NAME VARCHAR2(20), -- 이름
                SEX CHAR(1), -- 성별 [M|F] M:Male F: Female
                AGE NUMBER(3) -- 나이
 );
DESC CUSTOMER1 

insert into customer1(id,pwd,name,sex,age) values('xman','ok','kang','M',21);
insert into customer1(id,pwd,name,sex,age) values('XMAN','no','kim','T',-20);

--insert into customer1(id,name,age) values('zman','son',99);
--insert into customer1(id,pwd,name,age) values('rman',NULL,'jjang',24);
--insert into customer1(id,pwd,name,age) values('','pwd','jjang','24);

update customer1 set pwd = null where id='XMAN';
select * from customer1;

select table_name,constraint_name,constraint_type,search_condition
from user_constraints
where table_name='CUSTOMER1';

select table_name,constraint_name,position,column_name
from user_cons_columns
where table_name='CUSTOMER1' order by constraint_name,position;

--Check
alter table customer1 add constraint customer_sex_ck check (sex in ('M','F'));

update customer1 set sex='M' where sex='T';
commit;
alter table customer1 add constraint customer_sex_ck check (sex in ('M','F'));

insert into customer1(id,pwd,name,sex,age) values('xman','ok','kang','M',21);
insert into customer1(id,pwd,name,sex,age) values('xman','ok','jjang','M',20);

insert into customer1(id,pwd,name,age) values('asura','ok','joo',99);

insert into customer1(id,pwd,name,sex,age) values('harisu','ok','susu','T',33);

insert into customer1(id,pwd,name,sex,age) values('harisu','ok','susu','T',999);


drop table customer1;
commit;

--Unique key

CREATE TABLE CUSTOMER1(
    ID VARCHAR2(8) NOT NULL CONSTRAINT CUSTOMER_ID_UK UNIQUE,
    PWD VARCHAR2(8) NOT NULL,
    NAME VARCHAR2(20),
    SEX CHAR(1) DEFAULT 'M'
    CONSTRAINT CUSTOMER_SEX_CK CHECK (SEX IN ('M','F')),
    MOBILE VARCHAR2(14) UNIQUE,
    AGE NUMBER(3) DEFAULT 18
);
DESC CUSTOMER1 

insert into customer1(id,pwd,name,mobile,age) values('xman','ok','kang','011-3333',21);
insert into customer1(id,pwd,name,mobile,age) values('XMAN','yes','kim','011-3334',33);

insert into customer1(id,pwd,name,mobile,age) values('xman','yes','lee','011-3335',-21);
insert into customer1(id,pwd,name,mobile,age) values('yman','yes','lee','011-3333',28);

insert into customer1(is,pwd,name,mobile) values('무명인','yes',NULL,NULL);

alter table customer1 add constraint customer_name_sex_uk unique(name,sex);
alter table customer1 modify(name not null);

insert into customer1(id,pwd,name,sex) values('rman','yes','syo','M');
insert into customer1(id,pwd,name,sex) values('Rman','yes','syo','F');
insert into customer1(id,pwd,name,sex) values('RmaN','yes','syo','M');

select index_name,index_type,uniqueness from user_indexes
where table_name='CUSTOMER1';

select index_name,column_position,column_name from user_ind_columns
where table_name='CUSTOMER1' order by 





