PROJECT_NAME=c3
SERVICE_NAME=cns
SERVICE_FULL=${PROJECT_NAME}-${SERVICE_NAME}

deploy_configs:
	mv ${SERVICE_FULL} /etc/init.d/
	mv ${SERVICE_FULL}-uwsgi.ini /etc/${PROJECT_NAME}/
	mv ${SERVICE_FULL}-nginx.conf /etc/nginx/conf.d/
	chmod +x /etc/init.d/${SERVICE_FULL}
	chkconfig --add ${SERVICE_FULL}
	chkconfig ${SERVICE_FULL} on

.PHONY: deploy_configs
