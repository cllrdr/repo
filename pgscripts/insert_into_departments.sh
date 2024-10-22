#!/bin/bash
echo "insert into departments (department_name) values ('$1')" | psql