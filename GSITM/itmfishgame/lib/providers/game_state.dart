import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fish_grade.dart';
import '../models/fish_instance.dart';

class GameState extends ChangeNotifier {
  int _coins = 1000; // Starting coins
  final List<FishInstance> _ownedFish = [];
  
  int get coins => _coins;
  List<FishInstance> get ownedFish => _ownedFish;

  GameState() {
    // Start with one normal fish
    _ownedFish.add(FishInstance.generate(FishGrade.normal));
  }

  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  double get totalBuffMultiplier {
    double multiplier = 1.0;
    for (final fish in _ownedFish) {
      multiplier += fish.grade.aquariumBuff;
    }
    return multiplier;
  }

  FishInstance? performGacha() {
    const int cost = 500;
    if (!spendCoins(cost)) return null;

    final random = Random().nextDouble() * 100;
    FishGrade grade;

    if (random < 1) {
      grade = FishGrade.epic;
    } else if (random < 5) {
      grade = FishGrade.ultraRare;
    } else if (random < 15) {
      grade = FishGrade.superRare;
    } else if (random < 40) {
      grade = FishGrade.rare;
    } else {
      grade = FishGrade.normal;
    }

    final newFish = FishInstance.generate(grade);
    _ownedFish.add(newFish);
    notifyListeners();
    return newFish;
  }

  void sellFish(FishInstance fish) {
    if (_ownedFish.contains(fish)) {
      _ownedFish.remove(fish);
      addCoins(fish.grade.sellPrice);
      // notifyListeners() is called inside addCoins
    }
  }
}
