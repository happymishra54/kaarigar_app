import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _goToRoleSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
    );
  }

void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.handyman_rounded, color: AppColors.primary),
        title: const Text('About Kaarigar'),
        content: const Text(
          'Kaarigar is India\'s trusted home service platform connecting '
          'customers with verified electricians, plumbers, carpenters, '
          'painters, cleaners and hundreds of other skilled professionals.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.support_agent, color: AppColors.primary),
        title: const Text('Contact Us'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ContactRow(icon: Icons.email_outlined, text: 'info@kaarigar.net'),
            SizedBox(height: 10),
            _ContactRow(icon: Icons.phone_outlined, text: '+91 85580-08825'),
            SizedBox(height: 10),
            _ContactRow(icon: Icons.location_on_outlined, text: 'India'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.info_outline, color: AppColors.primary),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Feature highlights (mirrors kaarigar.net "Why Choose Kaarigar")
  static const List<({IconData icon, String title, String desc})> _features = [
    (
      icon: Icons.verified_user_outlined,
      title: 'Verified Workers',
      desc:
          'Every professional is identity verified before joining Kaarigar.',
    ),
    (
      icon: Icons.event_available_outlined,
      title: 'Easy Booking',
      desc:
          'Search, compare and book skilled workers in just a few clicks.',
    ),
    (
      icon: Icons.workspace_premium_outlined,
      title: 'Quality Service',
      desc:
          'Skilled professionals committed to delivering excellent work.',
    ),
    (
      icon: Icons.support_agent_outlined,
      title: 'Dedicated Support',
      desc:
          'Our support team is here whenever you need assistance.',
    ),
  ];

  // Popular categories (mirrors kaarigar.net)
  static const _categories = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'Cleaner',
    'RO Repair',
    'Brick Mason',
    'Fabricator',
  ];

  // How it works steps (mirrors kaarigar.net)
  static const _steps = [
    {
      'step': '01',
      'title': 'Search',
      'desc':
          'Search verified electricians, plumbers, carpenters and more near your location.',
    },
    {
      'step': '02',
      'title': 'Book',
      'desc':
          'Compare profiles, ratings and prices, then confirm your booking within minutes.',
    },
    {
      'step': '03',
      'title': 'Relax',
      'desc':
          'Your chosen professional arrives on time and completes the work efficiently.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top bar: brand on left, Login/Register on right
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    // Brand
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.handyman_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Kaarigar',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
// Login
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RoleSelectionScreen(),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                    // Register
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RoleSelectionScreen(
                              mode: "register",
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Hero section
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 34),
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .18),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.handyman_rounded,
                        size: 46,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "India's Trusted Home Service Platform",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Book verified plumbers, electricians, carpenters, '
                      'painters, cleaners and hundreds of skilled '
                      'professionals for your home and office.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .88),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 26),
                    // Search-like CTA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Search for a professional...',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.brandGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Why Choose Kaarigar
                    const Text(
                      'WHY CHOOSE KAARIGAR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Trusted Home Services, Delivered Right',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hire verified professionals with confidence. Fast booking, '
                      'transparent service and reliable support — all in one place.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Feature cards
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _features.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemBuilder: (context, index) {
                        final f = _features[index];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: .10),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  f.icon,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                f.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                f.desc,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Our Impact
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'OUR IMPACT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Trusted by Thousands Across India',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: const [
                              _ImpactItem(value: '500+', label: 'Workers'),
                              _ImpactItem(value: '500+', label: 'Bookings'),
                              _ImpactItem(value: '10+', label: 'Cities'),
                              _ImpactItem(value: '4.8', label: 'Rating'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Popular Categories
                    const Text(
                      'POPULAR CATEGORIES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Find Skilled Professionals For Every Service',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _categories.map((c) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border:
                                Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.home_repair_service,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                c,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    // How It Works
                    const Text(
                      'HOW IT WORKS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Get Your Work Done In 3 Simple Steps',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Search, book and relax while experienced workers '
                      'complete your job.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),

                    ..._steps.map((s) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: AppColors.brandGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                s['step']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s['desc']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Get started CTA
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const RoleSelectionScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text(
                          'Find Workers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

// Footer (mirrors kaarigar.net footer)
              const SizedBox(height: 40),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 28),
                    decoration: const BoxDecoration(
                      color: Color(0xff0F172A),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff0F172A), Color(0xff111827)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BRAND
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xffF59E0B),
                                    Color(0xffFBBF24),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xffF59E0B)
                                        .withValues(alpha: .25),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.handyman_rounded,
                                color: Color(0xff111827),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Kaarigar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Your trusted platform for finding skilled and '
                          'verified professionals. From plumbing and '
                          'electrical work to cleaning, painting and repairs '
                          '— we\'ve got you covered.',
                          style: TextStyle(
                            color: const Color(0xffCBD5E1),
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // SOCIALS
                        Row(
                          children: [
_SocialIcon(
                              icon: Icons.facebook,
                              backgroundColor: const Color(0xff1877F2),
                              onTap: () => _showSimpleDialog(
                                context,
                                'Facebook',
                                'Follow Kaarigar on Facebook for updates '
                                'and offers.',
                              ),
                            ),
                            const SizedBox(width: 10),
                            _SocialIcon(
                              icon: Icons.camera_alt_outlined,
                              backgroundColor: const Color(0xffD6249F),
                              onTap: () => _showSimpleDialog(
                                context,
                                'Instagram',
                                'Follow Kaarigar on Instagram for new '
                                'services and deals.',
                              ),
                            ),
                            const SizedBox(width: 10),
                            _SocialIcon(
                              icon: Icons.alternate_email,
                              backgroundColor: Colors.black,
                              onTap: () => _showSimpleDialog(
                                context,
                                'Twitter',
                                'Follow Kaarigar on Twitter/X for news.',
                              ),
                            ),
                            const SizedBox(width: 10),
                            _SocialIcon(
                              icon: Icons.work_outline,
                              backgroundColor: const Color(0xff0A66C2),
                              onTap: () => _showSimpleDialog(
                                context,
                                'LinkedIn',
                                'Connect with Kaarigar on LinkedIn.',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        // NEWSLETTER
                        const _FooterTitle(
                          icon: Icons.send_rounded,
                          title: 'Newsletter',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Stay updated with new services and exclusive offers.',
                          style: TextStyle(
                            color: const Color(0xff94A3B8),
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                constraints: const BoxConstraints(
                                  maxWidth: 320,
                                  minHeight: 42,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff1E293B),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: .08),
                                  ),
                                ),
                                child: const TextField(
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(
                                      color: Color(0xff64748B),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Subscribed! Stay tuned for updates and offers.',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xffF59E0B),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Color(0xff111827),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // Row: Company | Popular Services | Contact
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // COMPANY
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
const _FooterTitle(title: 'Company'),
                                  const SizedBox(height: 16),
                                  _FooterLink(
                                    title: 'Home',
                                    icon: Icons.chevron_right,
                                    onTap: () => _goToRoleSelection(context),
                                  ),
                                  _FooterLink(
                                    title: 'Categories',
                                    icon: Icons.chevron_right,
                                    onTap: () =>
                                        _showSimpleDialog(
                                          context,
                                          'Categories',
                                          'Electrician, Plumber, Carpenter, '
                                          'Painter, Cleaner, RO Repair, '
                                          'Brick Mason, Fabricator and more.',
                                        ),
                                  ),
                                  _FooterLink(
                                    title: 'Services',
                                    icon: Icons.chevron_right,
                                    onTap: () =>
                                        _showSimpleDialog(
                                          context,
                                          'Services',
                                          'Search and book verified '
                                          'professionals for home and office '
                                          'services near you.',
                                        ),
                                  ),
                                  _FooterLink(
                                    title: 'About Us',
                                    icon: Icons.chevron_right,
                                    onTap: () => _showAbout(context),
                                  ),
                                  _FooterLink(
                                    title: 'Contact Us',
                                    icon: Icons.chevron_right,
                                    onTap: () => _showContact(context),
                                  ),
                                ],
                              ),
                            ),
                            // POPULAR SERVICES
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
const _FooterTitle(
                                      title: 'Popular Services'),
                                  const SizedBox(height: 16),
                                  _FooterLink(
                                    title: 'Electrician',
                                    icon: Icons.bolt_outlined,
                                    onTap: () =>
                                        _showSimpleDialog(
                                          context,
                                          'Electrician',
                                          'Certified electricians for wiring, '
                                          'repairs, installations and more. '
                                          'Login to book instant service.',
                                        ),
                                  ),
                                  _FooterLink(
                                    title: 'Plumber',
                                    icon: Icons.water_drop_outlined,
                                    onTap: () =>
                                        _showSimpleDialog(
                                          context,
                                          'Plumber',
                                          'Expert plumbers for leaks, '
                                          'installations, drainage and more. '
                                          'Login to book instant service.',
                                        ),
                                  ),
                                  _FooterLink(
                                    title: 'Carpenter',
                                    icon: Icons.handyman_outlined,
                                    onTap: () =>
                                        _showSimpleDialog(
                                          context,
                                          'Carpenter',
                                          'Skilled carpenters for furniture, '
                                          'repairs, fittings and custom work.',
                                        ),
                                  ),
                                  _FooterLink(
                                    title: 'Painter',
                                    icon: Icons.format_paint_outlined,
                                    onTap: () =>
                                        _showSimpleDialog(
                                          context,
                                          'Painter',
                                          'Professional painters for homes '
                                          'and offices with quality finishes.',
                                        ),
                                  ),
                                  _FooterLink(
                                    title: 'Cleaning',
                                    icon: Icons.cleaning_services_outlined,
                                    onTap: () =>
                                        _showSimpleDialog(
                                          context,
                                          'Cleaning',
                                          'Full home and office cleaning '
                                          'services by verified staff.',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 34),

// CONTACT
                        const _FooterTitle(title: 'Get In Touch'),
                        const SizedBox(height: 16),
                        const _ContactItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: 'info@kaarigar.net',
                        ),
                        const SizedBox(height: 14),
                        const _ContactItem(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: '+91 85580-08825',
                        ),
                        const SizedBox(height: 14),
                        const _ContactItem(
                          icon: Icons.location_on_outlined,
                          label: 'Location',
                          value: 'India',
                        ),

                        const SizedBox(height: 36),

                        // DIVIDER
                        Container(
                          height: 1,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xff273244),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

// BOTTOM
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '© ${DateTime.now().year} ',
                                style: TextStyle(
                                  color: const Color(0xff94A3B8),
                                  fontSize: 13,
                                ),
                              ),
                              const TextSpan(
                                text: 'Kaarigar',
                                style: TextStyle(
                                  color: Color(0xffF59E0B),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              const TextSpan(
                                text: '. All rights reserved.',
                                style: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const _BottomLink(
                              icon: Icons.shield_outlined,
                              title: 'Privacy Policy',
                            ),
                            const _BottomLink(
                              icon: Icons.description_outlined,
                              title: 'Terms & Conditions',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Decorative top accent
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffF59E0B),
                            Color(0xffFBBF24),
                            Color(0xffF59E0B),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactItem extends StatelessWidget {
  final String value;
  final String label;

  const _ImpactItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ============ FOOTER HELPERS ============

class _FooterTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const _FooterTitle({required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: const Color(0xffF59E0B),
                size: 16,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: 30,
          height: 2,
          decoration: BoxDecoration(
            color: const Color(0xffF59E0B),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xff1E293B),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white.withValues(alpha: .06)),
        ),
        child: Icon(
          icon,
          color: backgroundColor,
          size: 18,
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FooterLink({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xffF59E0B),
              size: 11,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xffCBD5E1),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
  });

@override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: const Color(0xffF59E0B),
            size: 18,
          ),
        ),
        const SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff94A3B8),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xffE2E8F0),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _BottomLink extends StatelessWidget {
  final IconData icon;
  final String title;

  const _BottomLink({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xff94A3B8),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff94A3B8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
