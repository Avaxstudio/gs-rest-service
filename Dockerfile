# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app/complete
COPY complete/ /app/complete
RUN mvn clean package -DskipTests

# Stage 2: Minimalni runtime
FROM gcr.io/distroless/java17-debian11
WORKDIR /app/complete
COPY --from=build /app/complete/target/*.jar app.jar
EXPOSE 777
ENTRYPOINT ["java", "-jar", "app.jar"]
