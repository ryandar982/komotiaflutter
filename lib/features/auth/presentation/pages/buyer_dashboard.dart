import 'package:flutter/material.dart';

// Path disesuaikan mengarah ke sub-folder dashboard_widget
import 'package:komotia/shared/widget/dashboard_widget/dashboard_header.dart';
import 'package:komotia/shared/widget/dashboard_widget/balance_points_section.dart';
import 'package:komotia/shared/widget/dashboard_widget/order_status_section.dart';
import 'package:komotia/shared/widget/dashboard_widget/quick_links_section.dart';

class BuyerDashboardPage extends StatelessWidget {
  const BuyerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cukup gunakan SingleChildScrollView karena Scaffold-nya sudah ada di HomePage
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            SizedBox(height: 24),
            BalancePointsSection(),
            SizedBox(height: 24),
            OrderStatusSection(),
            SizedBox(height: 24),
            QuickLinksSection(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}