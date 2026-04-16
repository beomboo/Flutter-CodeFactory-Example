import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game/aquarium_game.dart';
import 'providers/game_state.dart';
import 'ui/hud.dart';
import 'ui/shop_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: const FishGameApp(),
    ),
  );
}

class FishGameApp extends StatelessWidget {
  const FishGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itm Fish Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late AquariumGame _game;

  @override
  void initState() {
    super.initState();
    // Initialize game with reference to state
    _game = AquariumGame(context.read<GameState>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const ShopDrawer(),
      body: Stack(
        children: [
          // The Game Layer
          GameWidget(game: _game),
          
          // UI Layer
          const GameHUD(),
        ],
      ),
    );
  }
}
