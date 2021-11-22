FROM ubuntu:18.04
RUN apt update
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget
RUN mkdir /usr/local/tomcat
RUN wget http://apache.stu.edu.tw/tomcat/tomcat-9/v9.0.55/bin/apache-tomcat-9.0.55.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-9.0.55/* /usr/local/tomcat/
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run

RUN apt install maven -y
RUN apt install git -y
WORKDIR /tmp/
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello
WORKDIR /tmp/boxfuse-sample-java-war-hello/
RUN ls -l
RUN mvn package
RUN cp target/hello-1.0.war /usr/local/tomcat/webapps

