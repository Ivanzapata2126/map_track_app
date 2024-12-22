import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_track_app/config/theme/app_theme.dart';
import 'package:map_track_app/domain/entities/accions.dart';
import 'package:map_track_app/domain/entities/zones.dart';
import 'package:map_track_app/presentation/providers/map_provider.dart';
import 'package:map_track_app/presentation/screens/history_screen.dart';
import 'package:map_track_app/presentation/widgets/color_picker.dart';
import 'package:map_track_app/presentation/widgets/custom_app_bar.dart';
import 'package:map_track_app/presentation/widgets/display_image.dart';
import 'package:map_track_app/services/camara_gallery_service_impl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en MapProvider
    final mapProvider = context.watch<MapProvider>();

    // Manejo de errores: mostrar un AlertDialog si hay un error
    if (mapProvider.error != null) {
      // Usar addPostFrameCallback para evitar llamar a setState durante la construcción
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error de ubicación'),
              content: Text(mapProvider.error!),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    mapProvider
                        .clearError(); // Limpiar el error después de mostrar el diálogo
                  },
                ),
              ],
            );
          },
        );
      });
    }

    return Scaffold(
      appBar: CustomAppBar(
        thirdWidget: GestureDetector(
          onTap: () => _showOptionsModal(context, mapProvider),
          child:const CircleAvatar(
  radius: 30,
  foregroundImage:AssetImage('assets/images/logo_person.jpg') as ImageProvider,
),
 ),
        height: 70,
        secondWidget: IconButton(
          icon: const Icon(Icons.history,color: Colors.white,size: 30,),
          onPressed:() {
            Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
          },
        ),
        firtsWidget: IconButton(
          onPressed: mapProvider.changeDarkMode,
          icon: Icon(
            mapProvider.isDarkMode ? Icons.dark_mode_outlined : Icons.sunny,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        markers: mapProvider.markers,
        circles: mapProvider.circles,
        initialCameraPosition: MapProvider.kGooglePlex,
        onMapCreated: (controller) => mapProvider.onMapCreated(controller),
        onTap: (LatLng position) {
          // Mostrar un diálogo para ingresar el radio del círculo
          _showRadiusDialog(context, position);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showActionDialog(context),
        label: Text('Registrar acción aquí',
            style: Theme.of(context).textTheme.titleSmall),
        icon: const Icon(
          Icons.location_on_sharp,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showOptionsModal(BuildContext context, MapProvider mapProvider) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opción para borrar todas las zonas
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Borrar todas las zonas'),
              onTap: () {
                mapProvider.clearCircles();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todas las zonas han sido borradas')),
                );
              },
            ),
            const Divider(),

            // Opción para borrar todas las acciones
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Borrar todas las acciones'),
              onTap: () {
                mapProvider.clearActions();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todas las acciones han sido borradas')),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}


  Future<void> _showActionDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final mapProvider = Provider.of<MapProvider>(context);
        return AlertDialog(
          title: Text(
            'Registrar Acción',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: const Color(0xff003366)),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo para el nombre
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(
                              fontSize: 15, color: const Color(0xff003366))),
                ),
                // Campo para la descripción
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 15, color: const Color(0xff003366)),
                  ),
                ),
                const SizedBox(height: 15),
                // Selector de icono
                Text(
                  'Seleccionar marcador:',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: const Color(0xff003366)),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  width: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppTheme.markerIcons.length,
                    itemBuilder: (context, index) {
                      final icon = AppTheme.markerIcons[index];
                      return GestureDetector(
                        onTap: () {
                          mapProvider.changeIconIndex(index);
                          
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: mapProvider.selectedMarker == index
                                  ? const Color(0xff003366)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Botón para subir una imagen
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subir foto:",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: const Color(0xff003366)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final imagePath =
                              await CameraGalleryServiceImpl().takePhoto();
                          if (imagePath == null) return;
                          mapProvider.addImagePath(imagePath);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Tomar foto",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      if (mapProvider.imagePath != null)
                        SizedBox(
                            height: 200,
                            width: 150,
                            child: DisplayImage(
                                imagePath: mapProvider.imagePath,
                                onPressed: mapProvider.deleteImagePath))
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                mapProvider.deleteImagePath();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final accionItem = Accions(
                  latitude: mapProvider.customLocation!.position.latitude,
                  longitude: mapProvider.customLocation!.position.longitude,
                  title: nameController.text,
                  description: descriptionController.text,
                  timestamp: DateTime.now(),
                  imagePath: mapProvider.imagePath,
                  markerIcon: mapProvider.selectedMarker,
                );
                  mapProvider.saveToHistoryAccion(accionItem);
                  mapProvider.createAndAddNewMarker(nameController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Acción registrada correctamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, completa todos los campos.'),
                    ),
                  );
                }
              },
              child: Text(
                'Registrar',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: const Color(0xff003366)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para mostrar un diálogo para ingresar el radio del círculo
  Future<void> _showRadiusDialog(BuildContext context, LatLng location) async {
    final TextEditingController radiusController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final mapProvider = Provider.of<MapProvider>(context, listen: false);
        return AlertDialog(
          scrollable: true,
          title: Text(
            'Añadir nueva zona',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: const Color(0xff003366)),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 15, color: const Color(0xff003366)),
                    hintText: 'Ingresa el nombre de la zona',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: radiusController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 15, color: const Color(0xff003366)),
                    hintText: 'Ingresa el radio en metros',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Elige un color para tu zona',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 15, color: const Color(0xff003366)),
                ),
                SizedBox(
                  height: 100,
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: AppTheme.colorList.length,
                    itemBuilder: (context, index) {
                      return const ColorPickerRow();
                    },
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Añadir',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: const Color(0xff003366)),
              ),
              onPressed: () {
                final radius = double.tryParse(radiusController.text);
                if (radius != null && radius > 0) {
                  final zones = Zones(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    name: nameController.text, radius: radius.toInt(), color: mapProvider.selectedColor);
                  mapProvider.saveToHistoryZone(zones);
                  mapProvider.addCircle(location, radius, nameController.text);
                  const SnackBar(content: Text('Zona registrada correctamente'));
                  Navigator.of(context).pop();
                } else {
                  // Mostrar un error o advertencia
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingresa un radio válido.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

// Método para mostrar un diálogo para eliminar un círculo
  Future<void> _showRemoveCircleDialog(
      BuildContext context, String circleId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Círculo'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este círculo?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Provider.of<MapProvider>(context, listen: false)
                    .removeCircle(circleId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Método para mostrar un menú de opciones al tocar un círculo
  void _onCircleTapped(BuildContext context, Circle circle) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Eliminar Círculo'),
              onTap: () {
                Navigator.of(context).pop();
                _showRemoveCircleDialog(context, circle.circleId.value);
              },
            ),
            // Puedes agregar más opciones aquí si lo deseas
          ],
        );
      },
    );
  }
}
