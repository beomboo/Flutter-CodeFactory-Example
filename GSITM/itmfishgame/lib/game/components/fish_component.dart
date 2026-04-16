import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../../models/fish_grade.dart';
import '../../models/fish_instance.dart';
import '../aquarium_game.dart';
import 'coin_component.dart';

class FishComponent extends SpriteComponent with HasGameReference<AquariumGame> {
  final FishInstance fishData;
  late Vector2 _targetPosition;
  final Random _random = Random();
  double _dropTimer = 0;
  
  // Movement & Animation state
  double _wobbleTime = 0;
  double _speed = 0;
  double _maxSpeed = 60;
  bool _isTurning = false;
  double _turningProgress = 1.0; // 0.0 to 1.0
  double _directionX = 1.0; // 1.0 for right, -1.0 for left

  FishComponent(this.fishData);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(fishData.grade.imagePath);
    // Visual Polish: High-quality filtering
    sprite!.paint.filterQuality = FilterQuality.high;
    
    size = Vector2.all(80);
    anchor = Anchor.center;
    
    // Initial random position
    final startX = _random.nextDouble() * (game.size.x > 0 ? game.size.x : 400);
    final startY = _random.nextDouble() * (game.size.y > 0 ? game.size.y : 600);
    position = Vector2(startX, startY);
    
    _maxSpeed = 40 + _random.nextDouble() * 30;
    _directionX = _random.nextBool() ? 1.0 : -1.0;
    scale.x = _directionX;

    // Add a subtle shadow child to ground it visually
    add(CircleComponent(
      radius: 20,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 + 10),
      paint: Paint()..color = Colors.black.withOpacity(0.15)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      priority: -1,
    ));

    // Tail wagging effect (Scale only Y for breathing feel)
    add(ScaleEffect.by(
      Vector2(1.0, 1.08),
      EffectController(
        duration: 0.8 + _random.nextDouble() * 0.4,
        reverseDuration: 0.8 + _random.nextDouble() * 0.4,
        infinite: true,
        curve: Curves.easeInOutSine,
      ),
    ));

    _setNewTarget();
  }

  void _setNewTarget() {
    final gameWidth = game.size.x > 0 ? game.size.x : 400;
    final gameHeight = game.size.y > 0 ? game.size.y : 600;

    _targetPosition = Vector2(
      100 + _random.nextDouble() * (max(0, gameWidth - 200)),
      100 + _random.nextDouble() * (max(0, gameHeight - 250)),
    );

    // Check if we need to turn
    final newDirectionX = _targetPosition.x > position.x ? 1.0 : -1.0;
    if (newDirectionX != _directionX) {
      _isTurning = true;
      _turningProgress = 0.0;
      _directionX = newDirectionX;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 1. Handle Turning Animation (Natural horizontal turn)
    if (_isTurning) {
      _turningProgress += dt * 3.0; // Turn takes ~0.33s
      if (_turningProgress >= 1.0) {
        _turningProgress = 1.0;
        _isTurning = false;
      }
      
      // Interpolate scale.x from old direction to new direction
      // We use a sine curve to make it look like a 3D rotation
      final currentScale = _directionX * -1.0 + (_directionX - (_directionX * -1.0)) * _turningProgress;
      scale.x = currentScale;
      
      // Slow down significantly while turning
      _speed *= 0.9; 
    } else {
      // 2. Movement Logic (Forward only)
      final vectorToTarget = _targetPosition - position;
      final distance = vectorToTarget.length;

      if (distance > 10) {
        // Accelerate
        _speed = (_speed + dt * 40).clamp(0, _maxSpeed);
        
        // Move towards target
        final moveDir = vectorToTarget.normalized();
        position += moveDir * _speed * dt;

        // Subtle tilting towards target
        final targetAngle = (moveDir.y * 0.2).clamp(-0.2, 0.2);
        angle += (targetAngle - angle) * 2 * dt;
      } else {
        // Arrived at target
        _speed *= 0.8;
        if (_speed < 5) {
          _speed = 0;
          // Set new target after a short idle delay
          if (!_isTurning) {
             _setNewTarget();
          }
        }
      }
    }

    // Natural vertical float (sinusoidal)
    _wobbleTime += dt;
    final floatOffset = sin(_wobbleTime * 1.5) * 8 * dt; // Adjusting magnitude
    position.y += floatOffset;

    // Coin dropping logic
    _dropTimer += dt;
    if (_dropTimer >= fishData.grade.dropInterval) {
      _dropTimer = 0;
      _dropCoin();
    }
  }

  void _dropCoin() {
    final coin = CoinComponent(
      position: position.clone(),
      value: (fishData.grade.coinValue * game.gameState.totalBuffMultiplier).toInt(),
    );
    game.add(coin);
  }
}
