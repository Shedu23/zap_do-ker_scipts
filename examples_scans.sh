#Start vulnerability application
docker run --net=zapnet -p 60999:8080 -t -d webgoat/webgoat-8.0


#Start ZAP & scan container

#Start scan docker to webapp
docker run -v /tmp/zap/:/zap/wrk/:rw -t owasp/zap2docker-live zap-baseline.py -t https://example.ru/ -j -a -m 5 -r scan_webapp_report-$(date "+%Y-%m-%d").html 

#Start scan docker to docker web app & zap-baseline.py 
docker run --net=zapnet -t owasp/zap2docker-stable:latest zap-baseline.py -t http://$(ip -f inet -o addr show docker0 | awk '{print $4}' | cut -d '/' -f 1):60999/WebGoat/login 

#Start scan docker to docker web app & zap-full-scan.py
docker run --net=zapnet -t owasp/zap2docker-stable:latest zap-full-scan.py  -t http://$(ip -f inet -o addr show docker0 | awk '{print $4}' | cut -d '/' -f 1):60999/WebGoat/login 

#Start scan docker to docker web app & custom 1
docker run --net=zapnet -v /tmp/zap/:/zap/wrk/:rw -t owasp/zap2docker-stable:latest zap-full-scan.py -t http://$(ip -f inet -o addr show docker0 | awk '{print $4}' | cut -d '/' -f 1):60999/WebGoat/login -a -m 5 -r scan_web_goat$(date "+%Y-%m-%d").html

#Start scan docker to docker web app & custom 2
docker run --net=zapnet -v /tmp/zap/:/zap/wrk/:rw -t owasp/zap2docker-stable:latest zap-full-scan.py -t http://172.17.0.1:60999/WebGoat/login -a -m 5 -r scan_web_goat$(date "+%Y-%m-%d").html

#Trivy
docker run --rm -v /home/iss/trivy-cache/:/root/.cache/ aquasec/trivy webgoat/webgoat-8.0 > trivy-scan-1
