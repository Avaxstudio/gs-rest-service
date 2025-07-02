# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app/complete
COPY complete/ /app/complete
RUN mvn clean package -DskipTests
RUN ls -lh /app/complete/target


# Stage 2: Minimalni runtime
FROM gcr.io/distroless/java17-debian11
WORKDIR /app/complete
COPY --from=build /app/complete/target/*.jar app.jar
EXPOSE 777
ENTRYPOINT ["java", "-jar", "app.jar"]

