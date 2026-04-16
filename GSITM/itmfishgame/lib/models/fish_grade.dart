import 'package:flutter/material.dart';

enum FishGrade {
  normal,
  rare,
  superRare,
  ultraRare,
  epic,
}

extension FishGradeExtension on FishGrade {
  String get name {
    switch (this) {
      case FishGrade.normal:
        return '일반';
      case FishGrade.rare:
        return '희귀';
      case FishGrade.superRare:
        return '희귀+';
      case FishGrade.ultraRare:
        return '전설';
      case FishGrade.epic:
        return '신화';
    }
  }

  Color get color {
    switch (this) {
      case FishGrade.normal:
        return Colors.orange;
      case FishGrade.rare:
        return Colors.yellow;
      case FishGrade.superRare:
        return Colors.blue;
      case FishGrade.ultraRare:
        return Colors.purple;
      case FishGrade.epic:
        return Colors.red;
    }
  }

  int get coinValue {
    switch (this) {
      case FishGrade.normal:
        return 10;
      case FishGrade.rare:
        return 50;
      case FishGrade.superRare:
        return 200;
      case FishGrade.ultraRare:
        return 1000;
      case FishGrade.epic:
        return 5000;
    }
  }

  double get dropInterval {
    switch (this) {
      case FishGrade.normal:
        return 5.0;
      case FishGrade.rare:
        return 4.0;
      case FishGrade.superRare:
        return 3.5;
      case FishGrade.ultraRare:
        return 3.0;
      case FishGrade.epic:
        return 2.0;
    }
  }

  String get imagePath {
    switch (this) {
      case FishGrade.normal:
        return 'assets/images/fish1.png';
      case FishGrade.rare:
        return 'assets/images/fish2.png';
      case FishGrade.superRare:
        return 'assets/images/fish3.png';
      case FishGrade.ultraRare:
        return 'assets/images/fish4.png';
      case FishGrade.epic:
        return 'assets/images/fish5.png';
    }
  }

  double get aquariumBuff {
    switch (this) {
      case FishGrade.normal:
        return 0.0;
      case FishGrade.rare:
        return 0.05; // 5% bonus to all drops
      case FishGrade.superRare:
        return 0.10; // 10% bonus
      case FishGrade.ultraRare:
        return 0.25; // 25% bonus
      case FishGrade.epic:
        return 0.50; // 50% bonus
    }
  }

  int get sellPrice {
    switch (this) {
      case FishGrade.normal:
        return 100;
      case FishGrade.rare:
        return 250;
      case FishGrade.superRare:
        return 1000;
      case FishGrade.ultraRare:
        return 5000;
      case FishGrade.epic:
        return 25000;
    }
  }
}
