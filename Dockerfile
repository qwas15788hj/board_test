FROM tomcat:9.0-jdk8-openjdk

ARG WAR_FILE=./target/*.war
ARG PROFILE

ENV SPRING_PROFILE=$PROFILE
COPY ${WAR_FILE} /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]