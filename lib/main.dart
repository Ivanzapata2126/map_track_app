import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:map_track_app/config/router/app_router.dart';
import 'package:map_track_app/config/theme/app_theme.dart';
import 'package:map_track_app/domain/entities/accions.dart';
import 'package:map_track_app/domain/entities/zones.dart';
import 'package:map_track_app/presentation/providers/map_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Se inicializa todo lo de Hive
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ZonesAdapter());
  Hive.registerAdapter(AccionsAdapter());
  await Hive.initFlutter();

  // Abrir cajas si no están abiertas
  if (!Hive.isBoxOpen('accions')) {
    await Hive.openBox<Accions>('accions');
  }
  if (!Hive.isBoxOpen('zones')) {
    await Hive.openBox<Zones>('zones');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MapProvider>(
          create: (_) => MapProvider()..loadDarkStyle(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<MapProvider>(context);
    final appTheme = AppTheme(isDarkmode: homeProvider.isDarkMode);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
    );
  }
}

