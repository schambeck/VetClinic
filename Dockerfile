ARG APP=/app
ARG TARGET=${APP}/target

FROM maven:3.9.5-eclipse-temurin-21-alpine AS build
ARG APP
WORKDIR ${APP}

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests
ARG TARGET
WORKDIR ${TARGET}
RUN java -Djarmode=layertools -jar vetclinic*.jar extract

FROM eclipse-temurin:21-jre-alpine
ARG TARGET
COPY --from=build ${TARGET}/dependencies/ ./
COPY --from=build ${TARGET}/snapshot-dependencies/ ./
COPY --from=build ${TARGET}/spring-boot-loader/ ./
COPY --from=build ${TARGET}/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
