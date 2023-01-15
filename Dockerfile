FROM registry.access.redhat.com/ubi9/ubi-minimal

ENV APP_DIR=/opt/nzbget

WORKDIR ${APP_DIR}

ADD requirements.txt start.sh .

RUN microdnf install tar gzip python3.9 python-pip -y &&\
	pip3 install --no-cache-dir -r requirements.txt &&\
	rm requirements.txt &&\
	mkdir -p ${APP_DIR}/{downloads,config} &&\
	curl -sL https://nzbget.net/download/nzbget-latest-bin-linux.run -o nzbget-latest-bin-linux.run &&\
	sh nzbget-latest-bin-linux.run --destdir ${APP_DIR} &&\
	rm nzbget-latest-bin-linux.run &&\
	# cacert.pem fix from https://github.com/nzbget/nzbget/issues/784#issuecomment-931609658
	curl -sL https://nzbget.net/info/cacert.pem -o ${APP_DIR}/cacert.pem &&\
	pip install --upgrade --no-cache-dir setuptools &&\
	chgrp -R 0 ${APP_DIR} &&\
	chmod -R g=u ${APP_DIR} &&\
	microdnf clean all

USER 1001

EXPOSE 6789

CMD ./start.sh
