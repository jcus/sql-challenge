--Design tables to hold data in the CSVs, import the CSVs into a SQL database, and answer questions about the data. 
--Employee Database perform: Data Modeling an Data Engineering, Data Analysis
--DROP TABLE IF EXISTS dept_manager;
--Create tables in order: Titles, Employees, Departments, Department Manager, Dept_emp, Salaries
CREATE TABLE Titles (
	title_id VARCHAR(6) PRIMARY KEY,
	title VARCHAR
);
SELECT * FROM titles;

CREATE TABLE Employees (
	emp_no INT PRIMARY KEY,
	emp_title_id VARCHAR(6),
	birth_date DATE,
	first_name VARCHAR,
	last_name VARCHAR,
	sex VARCHAR(2),
	hire_date DATE,
	FOREIGN KEY (emp_title_id) REFERENCES Titles(title_id)
);
SELECT * FROM Employees;

CREATE TABLE Departments (
	dept_no VARCHAR PRIMARY KEY,
	dept_name VARCHAR
);
SELECT * FROM Departments;

--Department Manager
CREATE TABLE dept_manager (
	dept_no VARCHAR,
	emp_no INT,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (dept_no, emp_no)
);
SELECT * FROM dept_manager;

--if "PRIMARY KEY (dept_no, emp_no)"
--ERROR:  foreign key constraint "dept_manager_emp_no_fkey" cannot be implemented
--DETAIL:  Key columns "emp_no" and "emp_no" are of incompatible types: integer and character varying.
--SQL state: 42804

--Dept_emp
CREATE TABLE Dept_emp (
	emp_no INT,
	dept_no VARCHAR,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (emp_no, dept_no)
);
SELECT * FROM Dept_emp;

--Salaries
CREATE TABLE Salaries (
	emp_no INT,
	salary INT,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);
SELECT * FROM Salaries;

--1.List each employee: employee number, last name, first name, sex, and salary
SELECT employees.emp_no, 
	employees.last_name, 
	employees.first_name, 
	employees.sex,
	salaries.salary
FROM employees
INNER JOIN salaries ON
employees.emp_no = salaries.emp_no;

--2.List first name, last name, and hire date for employees who were hired in 1986. (BETWEEN DATE)
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

--3.List the manager of each department with the following information: 
--  department number, department name, the manager's employee number, last name, first name
--  SELECT * FROM employees; --dept_manager; departments; dept_emp;
SELECT dept_manager.dept_no, departments.dept_name,  employees.emp_no, employees.last_name, employees.first_name 
FROM employees
--WHERE emp_title_id = 'm0001' 
-- AND title='Manager' --employees.emp_title_id
INNER JOIN dept_manager
ON dept_manager.emp_no = employees.emp_no
-- get departments.dept_name
INNER JOIN departments
ON departments.dept_no= dept_manager.dept_no;
--INNER JOIN dept_manager
--ON dept_manager.emp_no = employees.emp_no
--WHERE emp_title_id IN ('m0001');

--4.List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT departments.dept_name, employees.emp_no,  employees.last_name, employees.first_name 
FROM employees
INNER JOIN dept_emp
ON dept_emp.emp_no = employees.emp_no
-- and department name
INNER JOIN departments
ON departments.dept_no= dept_emp.dept_no
ORDER BY employees.last_name; 


--5.List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT * FROM employees;
SELECT first_name, last_name, sex FROM employees
WHERE first_name ='Hercules'
AND last_name like 'B%';

--6.List all employees in the Sales department, including their employee number, last name, first name, and department name.

--7.List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, first_name, Last_name, dept_name
FROM employees
INNER JOIN dept_emp
ON dept_emp.emp_no = employees.emp_no
INNER JOIN departments
ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name IN ('Sales', 'Development');

--8.In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

