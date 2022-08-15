FROM maven:3-openjdk-17-slim as base

WORKDIR /app

COPY pom.xml ./
RUN mvn dependency:resolve -DskipTests
COPY src ./src

FROM base as build
RUN mvn package -DskipTests

FROM build as debug
COPY --from=build /app/target/demo-*.jar /demo.jar
CMD ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005", "-jar", "/demo.jar"]

FROM azul/zulu-openjdk-debian:17-jre as production
COPY --from=build /app/target/demo-*.jar /demo.jar
CMD ["java", "-jar", "/demo.jar"]
