FROM tomcat:8.5.72-jdk8-openjdk-slim-buster
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_VERSION 3.8.4
WORKDIR /app
RUN apt-get update
    apt-get install curl -y && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    apt-get clean && \
     rm -rf /var/lib/apt/lists/*
COPY ./pom.xml ./pom.xml
COPY ./src ./src
RUN mvn clean package
RUN rm -rf /usr/local/tomcat/webapps/*
RUN cp /app/target/addressbook.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
