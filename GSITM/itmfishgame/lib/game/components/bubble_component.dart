import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class BubbleComponent extends CircleComponent with HasGameReference {
  final Random _random = Random();
  late double _sinOffset;

  BubbleComponent({required Vector2 position, double radius = 5}) 
    : super(
        position: position,
        radius: radius,
        anchor: Anchor.center,
        paint: Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

  @override
  void onLoad() {
    _sinOffset = _random.nextDouble() * pi * 2;
    
    // Float upwards
    add(MoveEffect.by(
      Vector2(0, -600),
      EffectController(duration: 4 + _random.nextDouble() * 2),
      onComplete: () => removeFromParent(),
    ));

    // Slight fade out
    add(OpacityEffect.fadeOut(
      EffectController(duration: 4, startDelay: 1),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Horizontal swaying
    position.x += sin(game.currentTime() * 2 + _sinOffset) * 0.5;
  }
}
