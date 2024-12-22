// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:map_track_app/config/theme/app_theme.dart';
import 'package:map_track_app/domain/entities/accions.dart';
import 'package:map_track_app/domain/entities/zones.dart';
import 'package:map_track_app/presentation/providers/map_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 pestañas
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Box<Accions> actionsBox = Hive.box('accions');
    final Box<Zones> zonesBox = Hive.box('zones');
    final mapProvider = Provider.of<MapProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text('Historial', style: Theme.of(context).textTheme.titleMedium,),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.location_on), text: 'Acciones'),
            Tab(icon: Icon(Icons.circle_outlined), text: 'Zonas'),
          ],
        ),
      ),
      body: Container(
        color: mapProvider.isDarkMode ? Colors.black : AppTheme.secondaryColor,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildActionList(actionsBox),
            _buildZoneList(zonesBox),
          ],
        ),
      ),
    );
  }

  Widget _buildActionList(Box<Accions> actionsBox) {
    if (actionsBox.isEmpty) {
      return const Center(child: Text('No hay acciones registradas.'));
    }

    return ListView.separated(
      itemCount: actionsBox.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final action = actionsBox.getAt(index);
        return ListTile(
          leading: action?.imagePath != null
              ? Image.file(File(action!.imagePath!),
                  width: 50, height: 50, fit: BoxFit.cover)
              : Icon(AppTheme.markerIcons[action!.markerIcon!], color: AppTheme.primaryColor,),
          title: Text('Nombre de la acción: ${action.title}',style: Theme.of(context).textTheme.titleSmall,),
          subtitle: Text(
            'Descripción: ${action.description}\nFecha y hora: ${action.timestamp}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          isThreeLine: true,
        );
      },
    );
  }

  Widget _buildZoneList(Box<Zones> zonesBox) {
    if (zonesBox.isEmpty) {
      return const Center(child: Text('No hay zonas registradas.'));
    }

    return ListView.separated(
      itemCount: zonesBox.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final zone = zonesBox.getAt(index);
        return ListTile(
          leading: Icon(Icons.circle_outlined, color: AppTheme.colorList[zone!.color],),
          title: Text('Nombre: ${zone.name}', style: Theme.of(context).textTheme.titleSmall,),
          subtitle: Text(
            'Radio: ${zone.radius} metros',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          isThreeLine: true,
        );
      },
    );
  }
}
