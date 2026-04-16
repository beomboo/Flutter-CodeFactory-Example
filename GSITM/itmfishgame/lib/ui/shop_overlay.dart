import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_state.dart';
import '../models/fish_grade.dart';
import 'gacha_overlay.dart';

class ShopDrawer extends StatelessWidget {
  const ShopDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              '아쿠아리움 상점',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            
            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('보유 물고기', gameState.ownedFish.length.toString()),
                    _buildStatCol('나의 행운', '+${((gameState.totalBuffMultiplier - 1) * 100).toInt()}%'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Gacha Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  final newFish = gameState.performGacha();
                  if (newFish != null) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => GachaResultOverlay(
                          fish: newFish,
                          onDismiss: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('코인이 부족합니다!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/coin.png', width: 24, height: 24),
                    const SizedBox(width: 10),
                    Text(
                      '물고기 소환 (500)',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(color: Colors.white24, indent: 20, endIndent: 20),
            
            // Fish List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: gameState.ownedFish.length,
                itemBuilder: (context, index) {
                  final fish = gameState.ownedFish[index];
                  return ListTile(
                    leading: Image.asset(
                      fish.grade.imagePath, 
                      width: 40,
                      filterQuality: FilterQuality.medium,
                    ),
                    title: Text(
                      fish.name,
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      fish.grade.name,
                      style: GoogleFonts.outfit(color: fish.grade.color, fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '+${fish.grade.coinValue}',
                              style: GoogleFonts.outfit(color: Colors.amber, fontSize: 14),
                            ),
                            Text(
                              '${fish.grade.sellPrice} 코인',
                              style: GoogleFonts.outfit(color: Colors.greenAccent.withOpacity(0.8), fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.sell_outlined, color: Colors.orangeAccent, size: 20),
                          onPressed: () {
                            _showSellDialog(context, gameState, fish);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellDialog(BuildContext context, GameState gameState, dynamic fish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900,
        title: Text('물고기 판매', style: GoogleFonts.outfit(color: Colors.white)),
        content: Text(
          '${fish.name}을(를) ${fish.grade.sellPrice} 코인에 판매하시겠습니까?',
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: GoogleFonts.outfit(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              gameState.sellFish(fish);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('판매하기', style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),
        Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
