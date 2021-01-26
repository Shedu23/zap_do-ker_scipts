#!/bin/bash
# Default Script for local docker scan
# Before use need to create network bridge
# docker network create -d bridge zapnet 
#
# docker pull webgoat/webgoat-8.0
# docker run -d -p 8080:8080 -t webgoat/webgoat-8.0
#


docker run --net=zapnet -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable:latest \
       	zap-full-scan.py -t http://$(ip -f inet -o addr show docker0 \
	| awk '{print $4}' | cut -d '/' -f 1):8080/WebGoat/login \
	-a -m 5 -r scan_web_goat$(date "+%Y-%m-%d").html

