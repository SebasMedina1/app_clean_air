# Usar la imagen oficial de Dart
FROM dart:stable AS build

WORKDIR /app

# Copiar el archivo de configuración y obtener las dependencias
COPY pubspec.* /app/
RUN dart pub get

# Copiar el resto del proyecto
COPY . /app/

# Exponer el puerto 8080 (o el que use Railway)
EXPOSE 8080

# Comando para ejecutar el servidor
CMD ["dart", "bin/server.dart"]
