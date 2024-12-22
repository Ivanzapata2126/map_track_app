import 'package:go_router/go_router.dart';
import 'package:map_track_app/presentation/screens/home_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
