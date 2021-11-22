FROM ubuntu:18.04
RUN apt update
RUN sudo apt install default–jdk -y
RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN curl -O https://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz
RUN mkdir /opt/tomcat
RUN sudo tar xzvf apache-tomcat-9.0.*tar.gz -C /opt/tomcat --strip-components=1
WORKDIR /opt/tomcat
RUN chgrp -R tomcat /opt/tomcat
RUN chmod -R g+r conf
RUN chmod g+x conf
RUN chown -R tomcat webapps/ work/ temp/ logs/
RUN update-java-alternatives -l
RUN touch /etc/systemd/system/tomcat.service
RUN echo '[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_Home=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment=’CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC’
Environment=’JAVA_OPTS.awt.headless=true -Djava.security.egd=file:/dev/v/urandom’

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]

WantedBy=multi-user.target' > /etc/systemd/system/tomcat.service

RUN cat /etc/systemd/system/tomcat.service
RUN systemctl daemon-reload
RUN /opt/tomcat/bin/startup.sh run

RUN apt install maven -y
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello
WORKDIR /usr/local/tomcat/boxfuse-sample-java-war-hello/
RUN ls -la
RUN mvn package
RUN cp target/hello-1.0.war /usr/local/tomcat/webapps

