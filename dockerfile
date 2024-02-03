FROM maven:3.8.4-openjdk-11-slim As build-stage
WORKDIR /app 
COPY ./pom.xml ./pom.xml
COPY ./src ./src
RUN mvn dependency:go-offline
RUN mvn package

FROM tomcat:8.5.78-jdk11-openjdk-slim
COPY --from=build-stage /app/target/*.war /usr/local/tomcat/webapps/
expose 8080
cmd ["catalina.sh" , "run"]