#!/bin/bash
python3 -m venv .venv
source .venv/bin/activate
#deactivate
pip install numpy
#pip install numpy==2.2.2
pip freeze > requirements.txt
#pip install -r requirements.txt
