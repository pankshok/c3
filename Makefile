# Common variables
PROJ=C3
PROJ_NAME=c3
VENV=virtualenv --python=python3

# Production environment
PROJ_USER=_c3
PROJ_GROUP=_c3
PROJ_HOME=/home/${PROJ_USER}
PROJ_DIST=`pwd`/*
PROJ_ENV=${PROJ_HOME}/env
PROJ_PYTHON=${PROJ_ENV}/bin/python3
PROJ_PIP=${PROJ_ENV}/bin/pip3
PROJ_MAKEFILE=./Makefile.prod

# Development environment
DEV_ENV=./env
DEV_PIP=${DEV_ENV}/bin/pip3

# Commands
CP=cp -rf
RM=rm -rf
MKDIR=mkdir -p
CHOWN=chown
CHMOD=chmod
SUWRAP=sudo -u ${PROJ_USER}
USERADD=adduser -m -U ${PROJ_USER}
USERDEL=userdel -rf ${PROJ_USER}


all: help

help:
	@printf "USAGE: make {help | clean | install_deps | devel | install | {install|remove}_production_environment}\n"
	@printf "OPTIONS: \n"
	@printf "        help                                 print this message;\n"
	@printf "        clean                                remove venv and builds;\n"
	@printf "        devel                                deploy development environment;\n"
	@printf "        install_deps                         install dependencies;\n"
	@printf "        remove_production_environment        remove production;\n"
	@printf "        install_production_environment       deploy production.\n"


devel: clean
	@printf "========== Deploying devel environment ==========\n"
	@printf "Install (nginx, virtualenv) system packages by make install_deps.\n"
	${VENV} ${DEV_ENV}
	${DEV_PIP} install --upgrade pip
	${DEV_PIP} install --editable .
	@printf "\n\nUse following command to activate virtual environment:\n"
	@printf "source ${DEV_ENV}/bin/activate\n"
	@printf "export C3_DEBUG_MODE=True\n"
	@printf "available service handlers: c3-cns, c3-tss\n"

clean:
	@printf "========== Removing old environment ==========\n"
	${RM} ${DEV_ENV}
	${RM} ${PROJ}.egg-info
	${RM} __pycache__
	${RM} *~ \#*
	${RM} ${PROJ_MAKEFILE}


install_production_environment: clean install_deps generate_prod_makefile
	@printf "========== Deploying prod environment ==========\n"
	sudo ${USERADD}
	sudo ${CP} ${PROJ_DIST} ${PROJ_HOME}
	sudo ${CP} ${PROJ_HOME}/c3-ctl /usr/bin/
	sudo ${CHOWN} -R ${PROJ_USER}:${PROJ_GROUP} ${PROJ_HOME}
	sudo ${MKDIR} /etc/${PROJ_NAME}
	sudo ${MKDIR} /var/log/${PROJ_NAME}
	sudo ${MKDIR} /var/run/lock/${PROJ_NAME}
	sudo ${CHOWN} ${PROJ_USER}:${PROJ_GROUP} /var/log/${PROJ_NAME}
	sudo ${CHOWN} ${PROJ_USER}:${PROJ_GROUP} /var/run/lock/${PROJ_NAME}
#	Deploy cns, tss, ewi, iwi configs
	sudo ${MAKE} -C ${PROJ_HOME}/cns -f ${PROJ_HOME}/cns/Makefile deploy_configs
	sudo ${MAKE} -C ${PROJ_HOME}/tss -f ${PROJ_HOME}/tss/Makefile deploy_configs
	sudo ${MAKE} -C ${PROJ_HOME}/ewi -f ${PROJ_HOME}/ewi/Makefile deploy_configs
	sudo ${MAKE} -C ${PROJ_HOME}/iwi -f ${PROJ_HOME}/iwi/Makefile deploy_configs
#	Install cloud packages
	${SUWRAP} ${MAKE} -C ${PROJ_HOME} -f ${PROJ_HOME}/Makefile.prod install
	@printf "\n\nUse following commands to start services:\n"
	@printf "sudo service c3-cns start\n"
	@printf "sudo service c3-tss start\n"
	@printf "sudo service c3-iwi start\n"
	@printf "sudo service c3-ewi start\n"
	@printf "sudo service nginx start\n"
	@printf "\n\nUse following commands to activate virtual environment:\n"
	@printf "sudo su ${PROJ_USER}\n"
	@printf "cd ${PROJ_HOME}\n"
	@printf "source ${PROJ_ENV}/bin/activate\n"


install_deps:
	@printf "========== Installing dependencies ==========\n"
	sudo yum install nginx python3 python3-pip python3-devel
	sudo yum install mongodb mongodb-server
	sudo pip install virtualenv

generate_prod_makefile:
	@echo "install:"                                        >  ${PROJ_MAKEFILE}
	@echo "	${VENV} ${PROJ_ENV}"                            >> ${PROJ_MAKEFILE}
	@echo "	${PROJ_PIP} install --upgrade pip"              >> ${PROJ_MAKEFILE}
	@echo "	${PROJ_PYTHON} ${PROJ_HOME}/setup.py install"   >> ${PROJ_MAKEFILE}


remove_production_environment:
	@printf "========== Removing production environment ==========\n"
	sudo ${USERDEL}
	sudo ${RM} /etc/${PROJ_NAME}
	sudo ${RM} /var/log/${PROJ_NAME}
	sudo ${RM} /var/run/lock/${PROJ_NAME}
	sudo ${RM} /usr/bin/c3-ctl
	@printf "Omitting system packages removal, use make remove_deps:\n"
	@printf "nginx python3{-devel,-pip} virtualenv mongodb{-server,}\n"

remove_deps:
	@printf "========== Removing dependencies ==========\n"
	@printf "THIS IS VERY DESTRUCTIVE OPERATION. RUN make remove_deps by root.\n"
	@printf "Packages for removal: nginx python3{-devel,-pip} virtualenv mongodb{-server,}\n"
	yum remove nginx python3 python3-devel python3-pip mongodb
	pip uninstall virtualenv


.PHONY: all help devel install_deps clean install_production_environment remove_production_environment
