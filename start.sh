#!/bin/bash

if [ ! -f /opt/nzbget/config/nzbget.conf ]
then
	cp /opt/nzbget/nzbget.conf /opt/nzbget/config/
fi

/opt/nzbget/nzbget -s -o outputmode=log -c /opt/nzbget/config/nzbget.conf
