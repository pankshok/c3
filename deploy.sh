#! /usr/bin/env bash

PYTHON=./env/bin/python3
PIP3=./env/bin/pip3
VENV=./env

rm -rf ${VENV}
virtualenv env
#${VENV}/bin/pip install -r ./requirements.txt

${PIP3} install --editable .
echo "Use following command to activate virtual environment:"
echo "source ${VENV}/bin/activate"
