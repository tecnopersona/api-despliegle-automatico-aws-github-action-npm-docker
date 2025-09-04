# ==============================================================================
#  ETAPA 1: La Etapa de Construcción ("Builder")
# ------------------------------------------------------------------------------
# El único propósito de esta etapa es instalar las dependencias de Node.js de
# forma limpia y aislada. No contendrá nuestro código final. Piensa en ella
# como un taller de ensamblaje temporal.
# ==============================================================================

# Inicia una nueva etapa de construcción a partir de una imagen base oficial de Node.js.
# - 'node:18-alpine': Usa la versión 18 de Node.js. 'alpine' es una versión
#   muy ligera de Linux, lo que hace que la imagen sea más pequeña.
# - 'AS builder': Le damos un nombre a esta etapa ("builder") para poder
#   referirnos a ella más tarde.
FROM node:18-alpine AS builder

# Establece el directorio de trabajo dentro del contenedor en '/app'.
# Todas las siguientes instrucciones se ejecutarán desde esta carpeta. Si la
# carpeta no existe, este comando la crea.
WORKDIR /app

# Copia los archivos de gestión de paquetes desde tu PC al directorio de trabajo
# del contenedor ('/app').
# - 'package*.json': El asterisco asegura que copie tanto 'package.json'
#   (que lista las dependencias) como 'package-lock.json' (que asegura
#   versiones consistentes).
# - './': El punto indica que se copia en el directorio de trabajo actual ('/app').
# Se copia esto primero, por separado del resto del código, para aprovechar el
# caché de Docker. Si estos archivos no cambian, Docker no volverá a
# ejecutar 'npm install' en futuras construcciones, haciéndolas mucho más rápidas.
COPY package*.json ./

# Ejecuta el comando 'npm install' dentro del contenedor.
# Esto lee el 'package.json' y descarga todas las dependencias necesarias,
# creando la carpeta 'node_modules' dentro del contenedor.
RUN npm install


# ==============================================================================
#  ETAPA 2: La Etapa de Producción (La Imagen Final)
# ------------------------------------------------------------------------------
# Esta es la etapa final que creará la imagen que realmente se usará para
# ejecutar la aplicación. Será muy ligera porque solo contendrá lo
# estrictamente necesario para funcionar, gracias a que tomaremos los
# artefactos pre-construidos de la etapa 'builder'.
# ==============================================================================

# Inicia una segunda etapa, completamente nueva y limpia, desde la misma imagen base.
# Esto asegura que no queden archivos residuales del proceso de instalación
# en nuestra imagen final.
FROM node:18-alpine

# Establece de nuevo el directorio de trabajo a '/app'.
WORKDIR /app

# Aquí ocurre la magia del "multi-stage build".
# - 'COPY --from=builder': Le decimos a Docker que copie archivos no desde
#   nuestra PC, sino desde la etapa que nombramos 'builder'.
# - '/app/node_modules ./node_modules': Copia la carpeta 'node_modules' que fue
#   generada en la etapa 'builder' y la pone en el directorio de trabajo actual.
#   Con esto, obtenemos todas las dependencias sin necesidad de tener
#   'npm' o el 'package.json' en nuestra imagen final, haciéndola más ligera y segura.
COPY --from=builder /app/node_modules ./node_modules

# Copia el código fuente de nuestra aplicación (el archivo index.js) desde la
# PC al directorio de trabajo del contenedor.
COPY index.js .

# Documenta que la aplicación dentro del contenedor escuchará en el puerto 8080.
# No abre el puerto realmente, pero sirve como información para quien use la
# imagen y para servicios como AWS App Runner.
EXPOSE 8080

# Define el comando que se ejecutará por defecto cuando se inicie un contenedor
# a partir de esta imagen.
# - '[ "node", "index.js" ]': Ejecutará el comando 'node index.js', que
#   inicia nuestro servidor web. Se usa este formato de array (JSON) porque
#   es la forma más robusta y recomendada de definir el comando de inicio.
CMD [ "node", "index.js" ]