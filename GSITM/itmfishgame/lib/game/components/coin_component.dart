import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../aquarium_game.dart';

class CoinComponent extends SpriteComponent with HasGameReference<AquariumGame>, TapCallbacks {
  final int value;
  bool _isCollected = false;

  CoinComponent({required Vector2 position, required this.value}) {
    this.position = position;
  }

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('assets/images/coin.png');
    size = Vector2.all(40);
    anchor = Anchor.center;

    // Falling effect
    add(MoveEffect.by(
      Vector2(0, 300),
      EffectController(duration: 3, curve: Curves.bounceOut),
    ));

    // Visual Polish: 3D spinning effect
    add(ScaleEffect.to(
      Vector2(0.1, 1.0),
      EffectController(
        duration: 0.5,
        reverseDuration: 0.5,
        infinite: true,
        curve: Curves.easeInOutSine,
      ),
    ));

    // Subtle glow/shadow
    add(CircleComponent(
      radius: 20,
      anchor: Anchor.center,
      position: size / 2,
      paint: Paint()..color = Colors.yellow.withOpacity(0.2)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      priority: -1,
    ));
    
    // Auto-remove after some time if not collected
    add(RemoveEffect(delay: 10));
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_isCollected) return;
    _isCollected = true;
    
    game.gameState.addCoins(value);
    
    // Collection animation
    add(ScaleEffect.by(
      Vector2.all(1.5),
      EffectController(duration: 0.1),
      onComplete: () {
        add(OpacityEffect.fadeOut(
          EffectController(duration: 0.2),
          onComplete: () => removeFromParent(),
        ));
      },
    ));
  }
}
