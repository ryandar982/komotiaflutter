import 'package:flutter/material.dart';

class OrderStatusSection extends StatelessWidget {
  final int countDikemas;
  final int countDikirim;
  final int countSelesai;

  const OrderStatusSection({
    super.key,
    this.countDikemas = 0,
    this.countDikirim = 0,
    this.countSelesai = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatusItem(icon: Icons.inventory_2, label: 'Dikemas', badgeCount: countDikemas, isActive: countDikemas > 0),
              _buildLine(isActive: countDikirim > 0 || countSelesai > 0),
              _buildStatusItem(icon: Icons.local_shipping, label: 'Dikirim', badgeCount: countDikirim, isActive: countDikirim > 0),
              _buildLine(isActive: countSelesai > 0),
              _buildStatusItem(icon: Icons.check_circle, label: 'Selesai', badgeCount: countSelesai, isActive: countSelesai > 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required int badgeCount,
    required bool isActive,
  }) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF4B5320) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isActive ? Colors.white : Colors.grey.shade600, size: 24),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD32F2F),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.grey.shade400 : Colors.grey.shade300,
        margin: const EdgeInsets.only(bottom: 24), // Offset to align with icons, not text
      ),
    );
  }
}