## ⚖️ Arquitectura del Código Fuente

El proyecto sigue los principios de **Arquitectura Limpia**, separando las responsabilidades en capas:

1. **Capa de Dominio:**
   * Contiene las entidades principales como `<span>Accions</span>` y `<span>Zones</span>`, que representan los objetos del negocio.
   * Esta capa es la más abstracta y libre de dependencias externas.
   * Debido a la falta de un servidor/backend, esta capa tiene mínimo contenido, centrándose solo en definir las entidades.
2. **Capa de Datos:**
   * En un entorno con un backend, esta capa se habría encargado de interactuar con el servidor mediante repositorios e implementaciones de servicios.
   * En este proyecto, se utiliza principalmente para interactuar con el almacenamiento local a través de Hive.
3. **Capa de Presentación:**
   * Es la capa más desarrollada debido a la ausencia de un backend.
   * Maneja la lógica de la interfaz de usuario y los widgets.
   * Se utiliza `<span>Provider</span>` para la gestión del estado global y para conectar los datos con la interfaz de usuario.

---

### Principales Prácticas Utilizadas

* **Inyección de Servicios:**
  * Los servicios, como el seguimiento de ubicación (`<span>PositionServiceImpl</span>`), se inyectan en los proveedores para mantener un código modular y flexible.
* **Servicios Abstractos e Implementaciones:**
  * Las interfaces abstractas permiten desacoplar la lógica principal de las implementaciones específicas, como el acceso a la ubicación o el manejo de Hive.
* **Widgets Personalizables:**
  * Se utilizaron widgets reutilizables para simplificar y reducir la duplicación de código en la interfaz.
* **Soporte para Modo Oscuro:**
  * La aplicación incluye soporte para cambiar entre modo claro y oscuro, proporcionando una mejor experiencia de usuario.
* **Ejecución en Segundo Plano:**
  * Gracias al paquete `<span>flutter_background</span>`, se asegura el funcionamiento de la aplicación mientras está en segundo plano, rastreando la ubicación y notificando al usuario.
