import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      icon: Icons.location_on_rounded,
      iconColor: Color(0xFF00D4FF),
      title: 'Book in 30 Seconds',
      subtitle:
          'Simply enter your address and raise a wash request. No waiting in queues, no driving around.',
      bgColor1: Color(0xFF050914),
      bgColor2: Color(0xFF0A1228),
    ),
    _OnboardData(
      icon: Icons.directions_car_filled_rounded,
      iconColor: Color(0xFFFFD700),
      title: 'Nearest Vendor Arrives',
      subtitle:
          'Certified washers near you get notified instantly and race to accept your request.',
      bgColor1: Color(0xFF050914),
      bgColor2: Color(0xFF13100A),
    ),
    _OnboardData(
      icon: Icons.verified_rounded,
      iconColor: Color(0xFF00E676),
      title: 'Sparkling Clean — Done',
      subtitle:
          'Your car gets a premium wash at your doorstep. Track in real-time and pay securely.',
      bgColor1: Color(0xFF050914),
      bgColor2: Color(0xFF0A1410),
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // pages
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return _OnboardPage(data: _pages[index]);
            },
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: TextButton(
              onPressed: _goToLogin,
              child: Text(
                'Skip',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 48,
            left: 32,
            right: 32,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.accent,
                    dotColor: AppColors.bgCardLight,
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 3.5,
                    spacing: 6,
                  ),
                ),
                const SizedBox(height: 32),
                _GradientButton(
                  label: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onTap: _next,
                  gradient: _currentPage == _pages.length - 1
                      ? AppColors.goldGradient
                      : AppColors.accentGradient,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color bgColor1;
  final Color bgColor2;

  const _OnboardData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.bgColor1,
    required this.bgColor2,
  });
}

class _OnboardPage extends StatelessWidget {
  final _OnboardData data;
  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.bgColor1, data.bgColor2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // background glow
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.iconColor.withOpacity(0.06),
                ),
              ),
            ),
          ),
          // content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.14),
                // icon illustration
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.iconColor.withOpacity(0.12),
                    border: Border.all(
                      color: data.iconColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(data.icon, size: 72, color: data.iconColor),
                ),
                SizedBox(height: size.height * 0.07),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final LinearGradient gradient;

  const _GradientButton({
    required this.label,
    required this.onTap,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
