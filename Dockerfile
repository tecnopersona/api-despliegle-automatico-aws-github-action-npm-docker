# Etapa 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install

# Etapa 2: Producción
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY index.js .
EXPOSE 8080
CMD [ "node", "index.js" ]