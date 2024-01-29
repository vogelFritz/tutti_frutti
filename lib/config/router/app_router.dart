import 'package:go_router/go_router.dart';
import 'package:tutti_frutti/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
      name: HomeScreen.name,
      path: '/',
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      name: GameStartScreen.name,
      path: '/game_start',
      builder: (context, state) => const GameStartScreen()),
  GoRoute(
      name: GameScreen.name,
      path: '/game',
      builder: (context, state) => const GameScreen()),
  GoRoute(
      name: GameOptionsScreen.name,
      path: '/game_options',
      builder: (context, state) => const GameOptionsScreen()),
  GoRoute(
      name: WaitingScreen.name,
      path: '/waiting_screen',
      builder: (context, state) => const WaitingScreen()),
]);
