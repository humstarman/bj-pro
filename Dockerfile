FROM maven:3.5.4-jdk-8 as build
RUN mkdir -p /workspace
ADD ./THPBuilder /workspace/THPBuilder/
RUN cd /workspace/THPBuilder && mvn package
RUN mv /workspace/THPBuilder/target/THPBuilder-0.0.1-SNAPSHOT.war /workspace/THPBuilder.war

FROM tomcat:7.0.77-jre8
WORKDIR /usr/local/tomcat/conf
ADD ./conf/ ./
ADD ./pics/ /home/pics/
COPY --from=build /workspace/THPBuilder.war /usr/local/tomcat/webapps/
