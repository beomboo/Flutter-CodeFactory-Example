import 'dart:math';
import 'fish_grade.dart';

class FishInstance {
  final String id;
  final FishGrade grade;
  final String name;

  FishInstance({
    required this.id,
    required this.grade,
    required this.name,
  });

  factory FishInstance.generate(FishGrade grade) {
    final random = Random();
    return FishInstance(
      id: DateTime.now().millisecondsSinceEpoch.toString() + random.nextInt(1000).toString(),
      grade: grade,
      name: '${grade.name} 물고기 #${random.nextInt(100)}',
    );
  }
}
