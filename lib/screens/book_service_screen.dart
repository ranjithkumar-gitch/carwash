import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  int _selectedService = 1;
  int _selectedVehicle = 0;
  String _selectedTime = 'Now';
  bool _loading = false;

  final List<_ServiceOption> _services = const [
    _ServiceOption(
      icon: Icons.water_drop_rounded,
      name: 'Quick Rinse',
      desc: 'Exterior rinse & dry',
      price: 149,
      duration: '20 min',
      color: Color(0xFF00D4FF),
    ),
    _ServiceOption(
      icon: Icons.local_car_wash_rounded,
      name: 'Full Wash',
      desc: 'Exterior + basic interior',
      price: 299,
      duration: '45 min',
      color: Color(0xFFFFD700),
    ),
    _ServiceOption(
      icon: Icons.auto_awesome_rounded,
      name: 'Premium Detail',
      desc: 'Full detail + wax + polish',
      price: 599,
      duration: '90 min',
      color: Color(0xFF8B5CF6),
    ),
    _ServiceOption(
      icon: Icons.clean_hands_rounded,
      name: 'Interior Clean',
      desc: 'Vacuum + dashboard + seats',
      price: 399,
      duration: '60 min',
      color: Color(0xFF00E676),
    ),
  ];

  final List<String> _vehicles = ['Sedan', 'SUV', 'Hatchback', 'Luxury'];
  final List<String> _times = [
    'Now',
    '10:00 AM',
    '12:00 PM',
    '3:00 PM',
    '6:00 PM',
  ];

  void _confirmBooking() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OrderTrackingScreen(),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _services[_selectedService];
    return Scaffold(
      backgroundColor: AppColors.bgDark,
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
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    _BackButton(),
                    const SizedBox(width: 16),
                    Text(
                      'Book a Wash',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Location ----
                      _SectionTitle('Wash Location'),
                      const SizedBox(height: 12),
                      _LocationCard(),
                      const SizedBox(height: 24),
                      // ---- Vehicle type ----
                      _SectionTitle('Vehicle Type'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _vehicles.length,
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => setState(() => _selectedVehicle = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedVehicle == i
                                    ? AppColors.accent
                                    : AppColors.bgCardLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedVehicle == i
                                      ? AppColors.accent
                                      : const Color(0xFF2A3060),
                                ),
                                boxShadow: _selectedVehicle == i
                                    ? [
                                        BoxShadow(
                                          color: AppColors.accent.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                _vehicles[i],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedVehicle == i
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // ---- Service options ----
                      _SectionTitle('Select Service'),
                      const SizedBox(height: 12),
                      ...List.generate(_services.length, (i) {
                        final s = _services[i];
                        final isSelected = i == _selectedService;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedService = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? s.color.withOpacity(0.08)
                                  : AppColors.bgCard,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? s.color.withOpacity(0.5)
                                    : const Color(0xFF2A3060),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: s.color.withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(s.icon, color: s.color, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        s.desc,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 12,
                                            color: AppColors.textMuted,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            s.duration,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${s.price}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: s.color,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (isSelected)
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: s.color,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      // ---- Schedule ----
                      _SectionTitle('Schedule Time'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 42,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _times.length,
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () =>
                                setState(() => _selectedTime = _times[i]),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedTime == _times[i]
                                    ? AppColors.accentGold
                                    : AppColors.bgCardLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedTime == _times[i]
                                      ? AppColors.accentGold
                                      : const Color(0xFF2A3060),
                                ),
                              ),
                              child: Text(
                                _times[i],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedTime == _times[i]
                                      ? Colors.black
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // ---- Add-ons ----
                      _SectionTitle('Add-ons'),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Expanded(
                            child: _AddOnTile(
                              icon: Icons.format_paint_rounded,
                              label: 'Wax Coat',
                              price: '₹99',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _AddOnTile(
                              icon: Icons.air_rounded,
                              label: 'Tyre Shine',
                              price: '₹49',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _AddOnTile(
                              icon: Icons.clean_hands_rounded,
                              label: 'Perfume',
                              price: '₹39',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              // ---- Bottom confirm ----
              _BookingFooter(
                serviceName: selected.name,
                price: selected.price,
                time: _selectedTime,
                loading: _loading,
                onConfirm: _confirmBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────── helpers ───────────────────
class _ServiceOption {
  final IconData icon;
  final String name;
  final String desc;
  final int price;
  final String duration;
  final Color color;

  const _ServiceOption({
    required this.icon,
    required this.name,
    required this.desc,
    required this.price,
    required this.duration,
    required this.color,
  });
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
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

class _LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A3060)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '12, MG Road, Hyderabad 500001',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Change',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddOnTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String price;

  const _AddOnTile({
    required this.icon,
    required this.label,
    required this.price,
  });

  @override
  State<_AddOnTile> createState() => _AddOnTileState();
}

class _AddOnTileState extends State<_AddOnTile> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _selected
              ? AppColors.accent.withOpacity(0.1)
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _selected ? AppColors.accent : const Color(0xFF2A3060),
          ),
        ),
        child: Column(
          children: [
            Icon(
              widget.icon,
              color: _selected ? AppColors.accent : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.price,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _selected ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingFooter extends StatelessWidget {
  final String serviceName;
  final int price;
  final String time;
  final bool loading;
  final VoidCallback onConfirm;

  const _BookingFooter({
    required this.serviceName,
    required this.price,
    required this.time,
    required this.loading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: const Border(
          top: BorderSide(color: Color(0xFF1C2340), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (b) =>
                            AppColors.goldGradient.createShader(b),
                        child: Text(
                          '₹$price',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• $time',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              loading
                  ? const CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 2.5,
                    )
                  : GestureDetector(
                      onTap: onConfirm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          'Confirm Booking',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
