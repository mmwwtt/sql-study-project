

#库管理-----------------------------------------------------------------------------------------------------
DROP DATABASE IF EXISTS sql_study;           #删除库
CREATE DATABASE sql_study;                   #创建库
ALTER DATABASE sql_study CHARACTER SET utf8; #修改数据库字符集
USE sql_study;															 #使用数据库


#表结构管理-------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS salary_grade;
CREATE TABLE salary_grade(#工资等级表
	id           INT    PRIMARY KEY AUTO_INCREMENT,
	salary_low   DOUBLE,
	salary_heigh DOUBLE,
	grade        CHAR(5)
);
DROP TABLE IF EXISTS department;
CREATE TABLE department(  #部门表        
	id CHAR(5) PRIMARY KEY,
	department_name VARCHAR(20)
);
DROP DATABASE IF EXISTS staff;                   #删除表
CREATE TABLE staff (      #员工表                #创建表
	id            INT          PRIMARY KEY AUTO_INCREMENT,   #id,主键
	staff_name    VARCHAR (20) NOT NULL,      #员工名
	sex           CHAR(5)      DEFAULT '男',  #性别
	number        CHAR(20)     UNIQUE,        #手机号
	department_id CHAR(5),                    #所属部门id
	salary        INT,                        #工资
	hiredate      DATE,                       #入职日期
	manager_id    INT,                        #上级id
	test          CHAR(20),                   #测试字段
	CONSTRAINT c_depart FOREIGN KEY(department_id) REFERENCES department(id)
	#check(sex in ('男', '女')) #mysql不支持check约束
);


ALTER TABLE staff CHANGE COLUMN test test1 INT;  #修改字段名
ALTER TABLE staff MODIFY COLUMN test1 CHAR(10);  #修改字段类型
ALTER TABLE staff CHANGE COLUMN test1 test INT; 
ALTER TABLE staff ADD COLUMN new_add CHAR(10);   #添加字段
ALTER TABLE staff DROP COLUMN new_add;           #删除字段
#alter table staff rename to staff1;             #修改表名
CREATE TABLE t_copy1 LIKE staff;                 #复制表结构
CREATE TABLE t_copy2 SELECT * FROM staff WHERE 1;#复制表结构和数据, where 1 会复制数据，where 0 不糊复制数据
DESC staff;                                      #显示表结构

ALTER TABLE staff MODIFY COLUMN test CHAR(20) UNIQUE;         #添加列级约束
ALTER TABLE staff ADD CONSTRAINT c_hiredate UNIQUE(hiredate); #添加表级约束
ALTER TABLE staff MODIFY COLUMN test CHAR(20);                #删除列级约束
ALTER TABLE staff DROP INDEX  c_hiredate;                     #删除表级别约束
SHOW INDEX FROM staff;                                        #显示表约束



#前期准备，先插入部分数据---------------------------------------------------------------------------------
INSERT INTO department(id,department_name) 
VALUES('0000', '管理层'),
('000', '产品部'),
('001', '架构部'),
('002', '研发部'),
('003', '测试部'),
('004', '实施部'),
('005', '财务部'),
('006', '人事部'),
('007', '后勤部'),
('008', 'test部门');
INSERT INTO staff(staff_name,sex,number,department_id,salary,hiredate,manager_id,test)
VALUES('经理1','男','159-8847-0000','0000',9500,'1999-1-17',0,NULL),
('经理2','男','159-8847-0001','0000',8500,'1999-1-18',1,NULL),
('产品1','男','15988487000','000',2000,'1999-2-01',0,NULL),
('产品2','男','159-8848-0001','000',2100,'1999-2-02',0,'test2'),
('架构1','男','159-8858-0002','001',8200,'1999-2-03',0,NULL),
('架构2','男','159-8828-0003','001',5300,'1999-2-04',0,'test4'),
('研发1','男','159-8818-0004','002',2400,'1999-2-05',0,'test5'),
('研发2','男','159-8848-0005','002',2500,'1999-2-06',0,NULL),
('测试1','男','159-8848-0006','003',2600,'1999-2-07',0,NULL),
('测试2','男','159-8848-0007','003',5700,'1999-2-08',0,NULL),
('实施1','男','159-8848-0008','004',2800,'1999-2-09',1,'test9'),
('实施2','男','159-8848-0009','004',9900,'1999-2-10',1,'test10'),
('财务1','男','159-8848-0010','005',3000,'1999-2-11',1,NULL),
('财务2','男','159-8848-0011','005',8100,'1999-2-12',1,'test12'),
('人事1','男','159-8848-0012','006',3200,'1999-2-13',1,NULL),
('人事2','男','159-8848-0013','006',3300,'1999-2-14',1,'test14'),
('后勤1','男','159-8848-0014','007',7400,'1999-2-15',1,NULL),
('后勤2','男','159-8848-0015','007',1500,'1999-2-16',1,NULL),
('test1','男','159-8848-0016',NULL,1500,'1999-2-16',1,NULL);
INSERT INTO salary_grade(salary_low,salary_heigh,grade)
VALUES(0,1999,'E'),
(2000,2999,'D'),
(3000,3999,'C'),
(4000,4999,'B'),
(5000,9999,'A');

#常见函数-------------------------------------------------------------------------------------------------
#字符函数
SELECT LENGTH('hello 世界');                   #length()返回参数的字节个数，utf8: 每个汉字3个字符， gbk: 每个汉字2个字符
SELECT CONCAT('hello', ' ' , '世界');          #concat()拼接字符串
SELECT CONCAT(UPPER('hello'), ' ', LOWER('HELLO'));  #upper()转为大写, lower()转为小写 , 函数可以嵌套调用
SELECT SUBSTR('abcd efg hijk lmn', 4);         #substr(str, start, len)截取字符串, 包括start位
SELECT SUBSTR('abcd efg hijk lmn', 4, 5);  
SELECT INSTR('abcd efg hijk lmn', 'efg');      #instr(str1, str2) 返回str2在str1中的第一次的起始索引，无则返回0
SELECT TRIM('   abcd    ');                    #trim(str) 去除str中前后的空格
SELECT LPAD('abcd',10,'*');                    #lpad(str1, num, str2),rpad()  对str1左/右填充str2到长度为num,少则截断
SELECT REPLACE('abcdabcdabcd', 'abc', '123 '); #replace(str1,str2,str3) 将str1中的str2替换为str3
#数学函数
SELECT ROUND(3.1415926, 2);    #round(num1,num2) 四舍五入 num2为保留位数
SELECT CEIL(3.14);             #ceil(num) 向上取整
SELECT FLOOR(3.14);            #floor(num)向下取整
SELECT TRUNCATE(3.1415926,5);  #truncate(num1,num2) 对num2位后的小数进行截断
SELECT MOD(11,3), 11%3;        #mod(num1,num2) 对num1进行取余
SELECT RAND();                 #rand() 取[0,1)随机数 
#日期函数
SELECT NOW();       #返回系统的 yy-mm-dd hh-mm-ss
SELECT CURDATE();   #返回系统的 yy-mm-dd
SELECT CURTIME();   #返回系统的 hh-mm-ss
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW());  #year() month() day() hour() minute()  second() 返回对应的部分
SELECT STR_TO_DATE('2-22-2222','%c-%d-%Y');                   #str_to_date() 将日期字符串转为 日期类型
SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日');
SELECT DATEDIFF(MAX(hiredate),MIN(hiredate)) FROM staff;  #datediff(date1,date2) 日期相减
#其他函数
SELECT VERSION();  #查看当前版本号
SELECT DATABASE(); #查看当前数据库
SELECT USER();     #查看当前用户

#流程控制函数
SELECT IF(10>5, '大', '小');         #if(表达式, true则输出, false则输出) 类似于三元运算符
SELECT salary 原工资,department_id,  #case结构， 用法1
	CASE department_id
		WHEN 30 THEN salary*1.1
		WHEN 40 THEN salary*1.2
		ELSE salary
	END AS 新工资 
FROM staff;

SELECT salary,                       #case结构， 用法2
	CASE
		WHEN salary>20000 THEN 'A'
		WHEN salary>15000 THEN 'B'
		ELSE 'D'
	END AS 工资级别
FROM staff;
                     
#分组函数 sum()合计 、avg()平均值 、 min()最小 、 max()最大 、 count()非空值计数
SELECT SUM(salary), AVG(salary), MIN(salary), MAX(salary), COUNT(salary) FROM staff;
SELECT COUNT(DISTINCT salary) FROM staff;      #和distinct搭配使用


#表查询---------------------------------------------------------------------------------------------------
#基础查询
SELECT staff_name 员工名,number 手机号 FROM staff; #查询字段
SELECT 100;                                        #查询常量值
SELECT 100%95;                                     #查询表达式
SELECT VERSION();                                  #查询函数
SELECT VERSION() AS 版本号;                        #起别名 使用AS关键字/空格
SELECT VERSION() "mysql 版本号";                   #别名包含空格就要加引号
SELECT DISTINCT department_id FROM staff;          #DISTINCT关键字数据去重， 只允许一个字段
SELECT '100'+'123';                                #加号会将字符转为数值运算，无法转换转为0，null和任何拼接/相加结果都为null
SELECT CONCAT(staff_name,' - ',sex) AS 全名 FROM staff; #concat(str1,str2,str3) 拼接多个字符串
SELECT IFNULL(test,0)FROM staff;                        #IFNULL(param1,param2),  param1中为null的内容用param2替代

#条件查询
SELECT staff_name,salary FROM staff WHERE salary > 3000 AND salary < 8000;      #AND 连接两个条件
SELECT staff_name FROM staff WHERE staff_name LIKE '%1';                        #LIKe模糊查询  通配符%(代表任意个字符，包括0个字符) 
SELECT staff_name FROM staff WHERE staff_name LIKE '人_1';                      #通配符_：表示1个字符  如果要匹配通配符，则要 \_  \% 来进行转义
SELECT staff_name,salary FROM staff WHERE salary BETWEEN 3000 AND 8000;         #between and 包含临界值
SELECT staff_name,department_id FROM staff WHERE department_id IN ('001', '002', '003');  #in中 值类型必须一致/兼容，不支持通配符
SELECT staff_name,test FROM staff WHERE test IS NULL;                           #判断 null 需要用 IS NULL/IS NOT NULL
SELECT staff_name,test FROM staff WHERE test IS NOT NULL; 
SELECT staff_name,salary FROM staff ORDER BY salary DESC;                       #排序查询 asc(升序) desc(降序)
SELECT staff_name,salary,hiredate FROM staff ORDER BY hiredate DESC, salary ASC;#利用函数和多个字段排序

#分页查询
SELECT staff_name 员工名,number 手机号 FROM staff LIMIT 2,10;

#分组查询
SELECT department_id, MAX(salary) FROM staff GROUP BY department_id;                                #group by基本语法
SELECT department_id, AVG(salary), sex FROM staff GROUP BY sex, department_id ORDER BY AVG(salary); #多字段分组及排序
SELECT department_id, AVG(salary) FROM staff WHERE test IS NOT NULL GROUP BY department_id;         #分组前筛选
SELECT department_id, AVG(salary) FROM staff GROUP BY department_id HAVING AVG(salary)>4000;        #分组后筛选  部门人数大于2


#连接查询
#sql92语法-内连接 
SELECT s.*,d.department_name FROM staff s,department d WHERE s.department_id=d.id;                                   #等值连接
SELECT s.*,g.grade 工资等级 FROM staff s,salary_grade g WHERE salary BETWEEN g.salary_low AND g.salary_heigh;        #非等值连接，给范围内的工资凭等级
SELECT s1.staff_name 员工名, s2.staff_name 上级名 FROM staff s1,staff s2 WHERE s1.manager_id=s2.id;                  #自连接，同一张表查2次，找员工名和上级名
#sql99语法(推荐使用)-内连接(取交集)
SELECT s.*,d.department_name FROM staff s INNER JOIN department d ON s.department_id=d.id;                           #等值连接
SELECT s.*,g.grade 工资等级 FROM staff s INNER JOIN salary_grade g ON salary BETWEEN g.salary_low AND g.salary_heigh;#非等值连接 
SELECT s1.staff_name 员工名, s2.staff_name 上级名 FROM staff s1 INNER JOIN staff s2 ON s1.manager_id=s2.id;          #自链接
#sql99语法(推荐使用)-外连接
SELECT s.*,d.department_name FROM staff s LEFT JOIN department d ON s.department_id=d.id;                            #左外连接
SELECT s.*,d.department_name FROM staff s RIGHT JOIN department d ON s.department_id=d.id;                           #右外连接
#SELECT s.*,d.department_name FROM staff s full JOIN department d ON s.department_id=d.id;                           #全连接(mysql不支持全连接)


#子查询
#where跟子查询 
SELECT * FROM staff WHERE salary>(SELECT salary FROM staff WHERE id = 3);                                                                #标量子查询 子查询结果为单行单列
SELECT * FROM staff WHERE department_id IN (SELECT id FROM department WHERE id IN ('000','002'));                                        #列子查询 子查询结果为 多行单列
SELECT * FROM staff WHERE (staff_name,department_id)=(SELECT staff_name,department_id FROM staff WHERE staff_name='测试1' AND sex='男'); #行子查询 子查询结果为单行多列
#select跟子查询
SELECT d.*,(SELECT COUNT(*) FROM staff s WHERE s.department_id=d.id) 部门人数 FROM department d; #标量子查询
#from跟子查询
SELECT n.staff_name,n.salary,n.工资等级 FROM (SELECT s.*,g.grade 工资等级 FROM staff s,salary_grade g WHERE salary BETWEEN g.salary_low AND g.salary_heigh) n;
#exists跟子查询(相关子查询)
SELECT EXISTS (SELECT test FROM staff);#有数据则结果为1，无则为0


#联合查询
SELECT * FROM staff WHERE staff_name LIKE '%品%' 
UNION ALL
SELECT * FROM staff WHERE salary<3000;
  
  
#表操作，增删改-----------------------------------------------------------------------------------------------
#插入
INSERT INTO department(id,department_name) 
VALUES('0010', 'test插入');
INSERT INTO staff(staff_name,sex,number,department_id,salary,hiredate,manager_id,test)
VALUES('test','男','159-8849-0001','0010',9500,'1999-1-17',0,NULL);

#修改
UPDATE department SET department_name='test修改' WHERE id='0010';                                                  #单表修改数据
UPDATE staff s INNER JOIN department d ON s.department_id=d.id SET s.staff_name='test多表修改' WHERE d.id='0010' ; #多表连接修改数据

#删除
DELETE s FROM staff s INNER JOIN department d ON s.department_id=d.id WHERE d.id='0010';  #多表联合删除数据
DELETE FROM department WHERE id = '0010';                                                 #单表删除数据
																					                                                #级联删除
																					                                                #级联更新



#视图---------------------------------------------------------------------------------------------------------
CREATE VIEW v1 AS SELECT staff_name FROM staff;               #创建视图
CREATE OR REPLACE VIEW v1 AS SELECT staff_name,sex FROM staff;#修改视图1
ALTER VIEW v1 AS SELECT staff_name,sex,salary FROM staff;     #修改视图2
SELECT * FROM v1 WHERE staff_name LIKE '%品%';                #使用视图
DESC v1;																				              #查看视图结构1
SHOW CREATE VIEW v1;                                          #查看视图结构2
DROP VIEW v1;                                                 #删除视图

#事务---------------------------------------------------------------------------------------------------------
SELECT @@tx_isolation;  #查看隔离级别
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; #设置隔离级别  
SET autocommit=0;       #关闭自动提交
SAVEPOINT a;            #设置保存点
INSERT INTO salary_grade(salary_low,salary_heigh,grade)
VALUE(10000,19999,'AA');
INSERT INTO salary_grade(salary_low,salary_heigh,grade)
VALUE(20000,29999,'AAA');
#commit;                 #提交事务
ROLLBACK TO a;          #回滚到保存点

#索引----------------------------------------------------------------------------------------------------------

CREATE INDEX c_first_last_birth_gender ON employees(first_name,last_name,birth_date,gender); #创建索引1
ALTER TABLE employees ADD INDEX c_hire(hire_date);                             #创建索引2
DROP INDEX c_hire ON employees;                                                #删除索引
SHOW INDEX FROM employees;                                                     #查看索引

#EXPLAIN 查看sql是否用上索引    
EXPLAIN SELECT emp_no FROM employees WHERE emp_no='10001';                     #const
EXPLAIN SELECT first_name,last_name,birth_date FROM employees                  #ref
WHERE first_name='Georgi' AND last_name='Facello' AND birth_date='1953-09-02';  
EXPLAIN SELECT first_name FROM employees WHERE first_name IN('Georgi','Parto');#range
EXPLAIN SELECT first_name FROM employees;                                      #index
EXPLAIN SELECT * FROM employees;																							 #all


#查看变量-----------------------------------------------------------------------------------------------------
SHOW VARIABLES LIKE '%slow_query_log%';

#查看表内容---------------------------------------------------------------------------------------------------
SELECT * FROM department;
SELECT * FROM staff;
SELECT * FROM salary_grade;

