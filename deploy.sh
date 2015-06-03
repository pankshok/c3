#! /usr/bin/env bash

PYTHON=./env/bin/python3
PIP=./env/bin/pip3
VENV=./env

rm -rf ${VENV}
virtualenv --python=python3 env
${PIP} install --upgrade pip

${PIP} install --editable .
echo "Use following command to activate virtual environment:"
echo "source ${VENV}/bin/activate"
