# MapTrack App

## 🔗 Descripción

**MapTrack App** es una 📊 aplicación desarrollada en Flutter que permite a los usuarios 🔍 rastrear su 🗺️ ubicación en tiempo real, definir zonas geográficas personalizadas y 🔄 registrar acciones en el mapa. Además, proporciona un 🔖 historial de zonas visitadas y acciones realizadas. La 📊 aplicación está optimizada para ejecutarse en ⏳ segundo plano y utiliza 🛠️ Hive para el almacenamiento local de datos.

---

## 🌟 Características Principales

* 🔍 Rastreo de ubicación en tiempo real.
* 🌍 Definir zonas en el mapa con opciones de personalización.
* 🔄 Registrar acciones con 🔖 títulos, descripciones e 🖼️ imágenes personalizadas.
* ✉️ Mostrar notificaciones cuando se ingresa a una zona definida.
* 🛠️ Almacenamiento local utilizando Hive.
* 🔖 Historial de zonas y acciones.
* 🌑 Modo oscuro/☀️ día.
* ⏳ Soporte para ejecución en segundo plano.

---

## ⚙️ Requisitos Previos

1. **Flutter 3.22.0:**
   * Asegúrate de tener la versión 3.22.0 de Flutter instalada.
   * Puedes verificar la versión instalada ejecutando:
     ```bash
     flutter --version
     ```
2. **SDK de 📱 Android/📲 iOS:**
   * Instala el SDK necesario para compilar y ejecutar aplicaciones Flutter.
   * Configura un emulador o usa un dispositivo 📱 físico conectado.
3. **Dependencias del Proyecto:**
   * Asegúrte de tener las dependencias especificadas en el archivo `pubspec.yaml` correctamente instaladas.

---

## 🔄 Instrucciones para Ejecutar la Aplicación

### **1. 🔍 Clonar el Repositorio**

Clona el repositorio desde tu sistema de control de versiones:

```bash
git clone <URL_DEL_REPOSITORIO>
cd map_track_app
```

### **2. 🔄 Instalar Dependencias**

Ejecuta el siguiente comando para instalar las dependencias del proyecto:

```bash
flutter pub get
```

### **3. ⚙️ Configurar Permisos**

#### 📱 Android:

* En `android/app/src/main/AndroidManifest.xml`, asegúrate de que se incluyan los siguientes permisos:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

#### 📲 iOS:

* En `ios/Runner/Info.plist`, agrega:

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>La aplicación necesita acceder a tu ubicación para rastrearte incluso en segundo plano.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>La aplicación necesita acceder a tu ubicación para proporcionarte servicios personalizados.</string>
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
</array>
```

### **4. 🎮 Compilar y Ejecutar**

Para compilar y ejecutar la aplicación en un emulador o dispositivo:

```bash
flutter run
```

### **5. ❓ Solucionar Problemas de Permisos**

Si encuentras problemas relacionados con los permisos, verifica las configuraciones mencionadas en la sección "Configurar Permisos" y reinicia el proyecto.

---

## 🚀 Tecnologías y Paquetes Utilizados

### **🎨 Paquetes Principales:**

* **[geolocator](https://pub.dev/packages/geolocator):** 🔍 Rastreo de ubicación en tiempo real.
* **[google_maps_flutter](https://pub.dev/packages/google_maps_flutter):** 🌍 Integración con Google Maps.
* **[hive](https://pub.dev/packages/hive):** 🛠️ Almacenamiento local ligero y rápido.
* **[flutter_background](https://pub.dev/packages/flutter_background):** ⏳ Soporte para ejecución en segundo plano.
* **[provider](https://pub.dev/packages/provider):** 🔧 Manejo del estado.

### **🌐 Entorno de Desarrollo:**

* Flutter 3.22.0
* Dart 3
* 💻 Android Studio o VS Code
