import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/painting.dart';
import 'package:flame/events.dart';
import '../providers/game_state.dart';
import 'components/fish_component.dart';

class AquariumGame extends FlameGame with TapCallbacks {
  final GameState gameState;
  late final SpriteComponent _background;

  AquariumGame(this.gameState);

  @override
  Future<void> onLoad() async {
    // Required to use full paths from FishGrade
    images.prefix = '';
    
    // Add background first
    final bgSprite = await loadSprite('assets/images/background.png');
    _background = SpriteComponent(
      sprite: bgSprite,
      size: size.clone(), // Use clone to avoid reference issues
    );
    add(_background);

    // Initial sync
    _syncFish();
  }

  void _syncFish() {
    // Remove existing fish components
    children.whereType<FishComponent>().forEach((f) => f.removeFromParent());
    
    // Add fish from state
    for (final fish in gameState.ownedFish) {
      add(FishComponent(fish));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Sync fish if needed (e.g., after gacha)
    if (children.whereType<FishComponent>().length != gameState.ownedFish.length) {
      _syncFish();
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Ensure background always matches the screen size
    if (isLoaded) {
      _background.size = size;
    }
  }
}


