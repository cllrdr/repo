#!/bin/bash
echo "insert into employees (department_id, chief_id, employee_name, salary) values ('$1', '$2', '$3', '$4')" | psql