# ========================================
# ETAPA 1: BUILD (Compilación con Maven)
# ========================================

# Imagen oficial con Maven + JDK 21
# Incluye Maven ya instalado (no hace falta apk/apt)
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar primero solo el pom.xml para aprovechar cache de Docker
COPY pom.xml .

# Descargar dependencias (se cachea si no cambia el pom)
RUN mvn dependency:go-offline

# Copiar el resto del código fuente
COPY src ./src

# Compilar y generar el JAR (sin tests para build más rápido en Docker)
RUN mvn clean package -DskipTests


# ========================================
# ETAPA 2: RUNTIME (Ejecución liviana)
# ========================================

# Imagen solo con JRE 21 (más liviana que JDK)
FROM eclipse-temurin:21-jre-alpine

# Directorio de trabajo
WORKDIR /app

# Documentar puerto de Spring Boot
EXPOSE 8080

# Copiar SOLO el JAR generado en la etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Comando de inicio
ENTRYPOINT ["java", "-jar", "app.jar"]
