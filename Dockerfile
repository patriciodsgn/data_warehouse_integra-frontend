# Usar una imagen base oficial de Node para la construcción
FROM node:18 AS builder

# Configuración del directorio de trabajo
WORKDIR /app

# Copiar package.json y package-lock.json e instalar dependencias
COPY package*.json ./
RUN npm install

# Copiar el código fuente
COPY . .

# Compilar la aplicación Angular para producción
RUN npm run build --configuration=production

# Segunda etapa: Servir la app con un servidor web (Nginx)
FROM nginx:alpine

# Copiar los archivos de la compilación a la carpeta predeterminada de Nginx
COPY --from=builder /app/dist/ /usr/share/nginx/html

# Exponer el puerto 80
EXPOSE 80

# Comando por defecto
CMD ["nginx", "-g", "daemon off;"]
