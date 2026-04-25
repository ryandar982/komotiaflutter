import 'package:flutter/material.dart';

class QuickLinksSection extends StatelessWidget {
  const QuickLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickLink(Icons.favorite, 'My\nWishlist'),
        _buildQuickLink(Icons.support_agent, 'Help\nCenter'),
        _buildQuickLink(Icons.local_offer, 'Promo\nCodes'),
        _buildQuickLink(Icons.menu_book, "Farmer's\nJournal"),
      ],
    );
  }

  Widget _buildQuickLink(IconData icon, String label) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F0D3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF4B5320), size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}