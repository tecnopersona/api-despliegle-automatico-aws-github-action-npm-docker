// --- Importación de Módulos ---
// 'require' es la forma que tiene Node.js de importar librerías o "módulos".
// Aquí, estamos importando la librería 'express', que es un framework muy popular
// para construir servidores y aplicaciones web de forma rápida y sencilla.
const express = require('express');

// --- Creación de la Aplicación ---
// Ejecutamos la función 'express()' que importamos y guardamos el resultado
// en una constante llamada 'app'. Esta variable 'app' representa nuestra aplicación
// web y la usaremos para definir rutas y configurar nuestro servidor.
const app = express();

// --- Configuración del Puerto ---
// Definimos el puerto en el que nuestro servidor va a escuchar las peticiones.
// 'process.env.PORT' es una variable de entorno. Las plataformas en la nube
// como AWS App Runner usan esta variable para decirle a nuestra aplicación en qué
// puerto debe escuchar para recibir tráfico de internet.
// El operador '||' (OR) significa que si 'process.env.PORT' no existe
// (por ejemplo, cuando ejecutamos la app en nuestra computadora local),
// se usará el valor '8080' como puerto por defecto.
const PORT = process.env.PORT || 8080;

// --- Definición de Rutas ---
// Aquí definimos cómo debe responder nuestro servidor a las peticiones de los usuarios.
// 'app.get()' establece una ruta que responde a peticiones HTTP de tipo GET.
// El primer argumento, '/', es la ruta de la URL. En este caso, es la raíz
// del sitio web (por ejemplo, http://misitio.com/).
// El segundo argumento es una función que se ejecutará cada vez que alguien
// visite esa ruta. Recibe dos objetos principales:
// - 'req' (request): Contiene toda la información sobre la petición del usuario.
// - 'res' (response): Es el objeto que usamos para enviar una respuesta de vuelta.
app.get('/', (req, res) => {
  // Usamos el método '.send()' del objeto 'res' para enviar una respuesta de
  // texto plano al navegador del usuario.
  res.send('¡Hola Usuario3! Pipeline CI/CD funcionando.');
});

// --- Arranque del Servidor ---
// Este comando pone en marcha el servidor y lo deja "escuchando" peticiones
// en el puerto que definimos en la constante 'PORT'.
// El segundo argumento es una función "callback" que se ejecuta una sola vez
// cuando el servidor ha arrancado exitosamente.
app.listen(PORT, () => {
  // 'console.log()' imprime un mensaje en la consola del servidor (no en el
  // navegador del usuario). Es muy útil para saber que nuestra aplicación
  // se ha iniciado correctamente y en qué puerto está funcionando.
  console.log(`Servidor escuchando en el puerto ${PORT}`);
});