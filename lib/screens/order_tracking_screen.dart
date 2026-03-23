import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  int _currentStep = 1; // 0=Confirmed,1=EnRoute,2=Washing,3=Done

  final List<_TrackStep> _steps = const [
    _TrackStep(
      icon: Icons.check_circle_rounded,
      label: 'Booking Confirmed',
      sublabel: 'Your request was accepted',
      time: '09:02 AM',
    ),
    _TrackStep(
      icon: Icons.directions_car_filled_rounded,
      label: 'Vendor En Route',
      sublabel: 'SparkleWash Pro is heading to you',
      time: '09:05 AM',
    ),
    _TrackStep(
      icon: Icons.local_car_wash_rounded,
      label: 'Washing In Progress',
      sublabel: 'Your car is being washed',
      time: '—',
    ),
    _TrackStep(
      icon: Icons.verified_rounded,
      label: 'Work Order Closed',
      sublabel: 'Wash complete. Enjoy your ride!',
      time: '—',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _simulateNext() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050914), Color(0xFF0A0E27)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    _BackBtn(),
                    const SizedBox(width: 16),
                    Text(
                      'Track Your Wash',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    _OrderBadge(orderId: '#WD-4821'),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // ---- Map placeholder ----
                      _MapCard(pulseAnim: _pulseAnim),
                      const SizedBox(height: 24),
                      // ---- Vendor info ----
                      _VendorInfoCard(),
                      const SizedBox(height: 24),
                      // ---- Timeline ----
                      _TimelineCard(steps: _steps, currentStep: _currentStep),
                      const SizedBox(height: 24),
                      // ---- Order details ----
                      _OrderDetailsCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // ---- CTA Footer ----
              _TrackingFooter(
                step: _currentStep,
                totalSteps: _steps.length,
                onNext: _simulateNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// MAP CARD
// ─────────────────────────────────────────────────────────
class _MapCard extends StatelessWidget {
  final Animation<double> pulseAnim;
  const _MapCard({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.bgCard,
        border: Border.all(color: const Color(0xFF2A3060)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Grid lines (simulated map)
          CustomPaint(
            size: const Size(double.infinity, 200),
            painter: _MapGridPainter(),
          ),
          // Destination pin
          Positioned(
            top: 50,
            left: 100,
            child: _MapPin(
              color: AppColors.accentGold,
              icon: Icons.home_rounded,
            ),
          ),
          // Vendor pin
          Positioned(
            top: 90,
            left: 60,
            child: AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: pulseAnim.value,
                child: _MapPin(
                  color: AppColors.accent,
                  icon: Icons.local_car_wash_rounded,
                ),
              ),
            ),
          ),
          // Route line
          CustomPaint(
            size: const Size(double.infinity, 200),
            painter: _RoutePainter(),
          ),
          // ETA overlay
          Positioned(
            bottom: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgDark.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.accent,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'ETA 8 min',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _MapPin({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        CustomPaint(
          painter: _PinTailPainter(color: color),
          size: const Size(2, 8),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.05)
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(78, 108);
    path.cubicTo(90, 100, 100, 95, 118, 68);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────
// VENDOR INFO
// ─────────────────────────────────────────────────────────
class _VendorInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3060)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SparkleWash Pro',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.accentGold,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.9  •  312 reviews',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _RoundIconBtn(
                icon: Icons.call_rounded,
                color: AppColors.accentGreen,
              ),
              const SizedBox(width: 10),
              _RoundIconBtn(
                icon: Icons.chat_bubble_rounded,
                color: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _RoundIconBtn({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

// ─────────────────────────────────────────────────────────
// TIMELINE
// ─────────────────────────────────────────────────────────
class _TimelineCard extends StatelessWidget {
  final List<_TrackStep> steps;
  final int currentStep;

  const _TimelineCard({required this.steps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3060)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Timeline',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(steps.length, (i) {
            final isDone = i < currentStep;
            final isCurrent = i == currentStep;
            final isPending = i > currentStep;
            final color = isDone
                ? AppColors.accentGreen
                : isCurrent
                ? AppColors.accent
                : AppColors.textMuted;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline node
                Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(isPending ? 0.08 : 0.15),
                        border: Border.all(
                          color: color.withOpacity(isPending ? 0.2 : 1),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        steps[i].icon,
                        color: color.withOpacity(isPending ? 0.4 : 1),
                        size: 16,
                      ),
                    ),
                    if (i < steps.length - 1)
                      Container(
                        width: 2,
                        height: 40,
                        color: isDone
                            ? AppColors.accentGreen
                            : const Color(0xFF2A3060),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              steps[i].label,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: isCurrent
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isPending
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              steps[i].time,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          steps[i].sublabel,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        if (i < steps.length - 1) const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TrackStep {
  final IconData icon;
  final String label;
  final String sublabel;
  final String time;

  const _TrackStep({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.time,
  });
}

// ─────────────────────────────────────────────────────────
// ORDER DETAILS
// ─────────────────────────────────────────────────────────
class _OrderDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3060)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Service', value: 'Full Wash'),
          _DetailRow(label: 'Vehicle', value: 'Sedan'),
          _DetailRow(label: 'Schedule', value: 'Now'),
          _DetailRow(label: 'Location', value: 'MG Road, Hyderabad'),
          const Divider(color: Color(0xFF2A3060), height: 24),
          _DetailRow(label: 'Service Price', value: '₹299'),
          _DetailRow(label: 'Wax Coat Add-on', value: '₹99'),
          _DetailRow(label: 'Platform Fee', value: '₹20'),
          const Divider(color: Color(0xFF2A3060), height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              ShaderMask(
                shaderCallback: (b) => AppColors.goldGradient.createShader(b),
                child: Text(
                  '₹418',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────
class _TrackingFooter extends StatelessWidget {
  final int step;
  final int totalSteps;
  final VoidCallback onNext;

  const _TrackingFooter({
    required this.step,
    required this.totalSteps,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = step == totalSteps - 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: const Border(
          top: BorderSide(color: Color(0xFF1C2340), width: 1),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 16),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLast ? 'Wash Complete!' : 'In Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isLast ? 'Rate your experience' : 'Vendor is on the way',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNext,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              decoration: BoxDecoration(
                gradient: isLast
                    ? AppColors.goldGradient
                    : AppColors.accentGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: (isLast ? AppColors.accentGold : AppColors.accent)
                        .withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                isLast ? 'Rate & Review' : 'Simulate Next',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// MISC
// ─────────────────────────────────────────────────────────
class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A3060)),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
          size: 16,
        ),
      ),
    );
  }
}

class _OrderBadge extends StatelessWidget {
  final String orderId;
  const _OrderBadge({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgCardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A3060)),
      ),
      child: Text(
        orderId,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
