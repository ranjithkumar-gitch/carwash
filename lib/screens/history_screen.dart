import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final List<_OrderRecord> _orders = const [
    _OrderRecord(
      id: '#WD-4821',
      service: 'Full Wash',
      vendor: 'SparkleWash Pro',
      date: 'Today, 09:15 AM',
      price: '₹418',
      status: 'In Progress',
    ),
    _OrderRecord(
      id: '#WD-4793',
      service: 'Premium Detail',
      vendor: 'GlossyWheels',
      date: 'Mar 15, 2:30 PM',
      price: '₹599',
      status: 'Completed',
    ),
    _OrderRecord(
      id: '#WD-4756',
      service: 'Quick Rinse',
      vendor: 'AquaShine Express',
      date: 'Mar 12, 10:00 AM',
      price: '₹149',
      status: 'Completed',
    ),
    _OrderRecord(
      id: '#WD-4712',
      service: 'Interior Clean',
      vendor: 'SparkleWash Pro',
      date: 'Mar 8, 4:00 PM',
      price: '₹399',
      status: 'Completed',
    ),
    _OrderRecord(
      id: '#WD-4680',
      service: 'Full Wash',
      vendor: 'GlossyWheels',
      date: 'Mar 2, 11:30 AM',
      price: '₹299',
      status: 'Cancelled',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050914), Color(0xFF0A0E27)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Wash History',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                '${_orders.length} total orders',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _orders.length,
                itemBuilder: (_, i) => _OrderHistoryCard(order: _orders[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderRecord {
  final String id;
  final String service;
  final String vendor;
  final String date;
  final String price;
  final String status;

  const _OrderRecord({
    required this.id,
    required this.service,
    required this.vendor,
    required this.date,
    required this.price,
    required this.status,
  });
}

class _OrderHistoryCard extends StatelessWidget {
  final _OrderRecord order;
  const _OrderHistoryCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case 'In Progress':
        return AppColors.accentGreen;
      case 'Completed':
        return AppColors.accent;
      case 'Cancelled':
        return AppColors.statusCancelled;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: order.status == 'In Progress'
          ? () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
            )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: order.status == 'In Progress'
                ? AppColors.accentGreen.withOpacity(0.3)
                : const Color(0xFF2A3060),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.local_car_wash_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.service,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.vendor,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order.price,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.status,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.textMuted,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  order.date,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  order.id,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (order.status == 'Completed') ...[
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          'Rebook',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.accent,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
