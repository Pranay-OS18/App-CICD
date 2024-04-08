FROM adoptopenjdk/openjdk11

WORKDIR $APP_HOME
 
ENV APP_HOME /usr/src/app

COPY target/*.jar $APP_HOME/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
