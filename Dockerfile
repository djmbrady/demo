FROM eclipse-temurin:25-jdk AS builder
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:25-jre
WORKDIR /app
RUN useradd -r -u 1001 springuser
COPY --from=builder /app/target/*.jar app.jar
RUN chown springuser:springuser app.jar
USER springuser
EXPOSE 8080
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]