import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/fish_instance.dart';
import '../models/fish_grade.dart';

class GachaResultOverlay extends StatelessWidget {
  final FishInstance fish;
  final VoidCallback onDismiss;

  const GachaResultOverlay({
    super.key,
    required this.fish,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '새로운 물고기 획득!',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 30),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: fish.grade.color.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      fish.grade.imagePath, 
                      width: 200, 
                      height: 200,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Text(
              fish.grade.name.toUpperCase(),
              style: GoogleFonts.outfit(
                color: fish.grade.color,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                shadows: [
                  const Shadow(color: Colors.white, blurRadius: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              fish.name,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: fish.grade.color,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                '확인',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
