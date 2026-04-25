import 'package:flutter/material.dart';

class BalancePointsSection extends StatelessWidget {
  const BalancePointsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Kartu Saldo Komotia
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.account_balance_wallet, size: 18, color: Color(0xFF4B5320)),
                    SizedBox(width: 8),
                    Text(
                      'Saldo\nKomotía',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4A4A4A)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Rp\n1.250.000',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Kartu Komotia Points
        
      ],
    );
  }
}