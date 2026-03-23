import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ---- Header ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.bgCardLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2A3060)),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // ---- Avatar & Info ----
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.4),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.accentGradient,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 52,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.bgDark, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Ranjith Kumar',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ranjith@example.com',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Premium Member',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // ---- Stats ----
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2A3060)),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: _ProfileStat(
                        value: '12',
                        label: 'Washes',
                        icon: Icons.water_drop_rounded,
                      ),
                    ),
                    _VertDivider(),
                    Expanded(
                      child: _ProfileStat(
                        value: '4.9',
                        label: 'Rating',
                        icon: Icons.star_rounded,
                      ),
                    ),
                    _VertDivider(),
                    Expanded(
                      child: _ProfileStat(
                        value: '₹2.4K',
                        label: 'Saved',
                        icon: Icons.savings_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // ---- Menu ----
              _MenuSection(
                title: 'Account',
                items: const [
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profile',
                  ),
                  _MenuItem(
                    icon: Icons.directions_car_outlined,
                    label: 'My Vehicles',
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'Saved Addresses',
                  ),
                  _MenuItem(
                    icon: Icons.payment_outlined,
                    label: 'Payment Methods',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _MenuSection(
                title: 'Preferences',
                items: const [
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                  ),
                  _MenuItem(icon: Icons.language_outlined, label: 'Language'),
                  _MenuItem(
                    icon: Icons.dark_mode_outlined,
                    label: 'Appearance',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _MenuSection(
                title: 'Support',
                items: const [
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & FAQ',
                  ),
                  _MenuItem(
                    icon: Icons.star_outline_rounded,
                    label: 'Rate the App',
                  ),
                  _MenuItem(
                    icon: Icons.share_outlined,
                    label: 'Refer a Friend',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sign out
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.statusCancelled.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.statusCancelled.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: AppColors.statusCancelled,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Sign Out',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.statusCancelled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _ProfileStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  const _VertDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 50, color: const Color(0xFF2A3060));
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A3060)),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              items[i].icon,
                              color: AppColors.accent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            items[i].label,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.textMuted,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < items.length - 1)
                    const Divider(
                      color: Color(0xFF1C2340),
                      height: 1,
                      indent: 66,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}
