import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_image.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/routes/app_routes.dart';
import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  String _statusMessage = 'Starting up...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack),
    );
    _animCtrl.forward();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Token is ALREADY loaded into memory by main() before runApp.
    // Check if it's still valid (exists AND not expired).
    _setStatus('Checking session...', 0.3);
    final loggedIn = await StorageService.hasValidToken();

    // If token is gone or expired, also clear the in-memory header
    // so stale Authorization isn't sent on the next API call.
    if (!loggedIn) {
      await ApiRequest.clearAuthToken();
    }

    // Wake up the backend while we're here
    _setStatus('Connecting to server...', 0.5);
    await _wakeUpBackend();

    _setStatus('Ready!', 1.0);
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Get.offAllNamed(loggedIn ? AppRoutes.home : AppRoutes.login);
    }
  }

  Future<void> _wakeUpBackend() async {
    bool ready = false;
    int attempts = 0;
    while (!ready && attempts < 10) {
      try {
        final res = await http
            .get(Uri.parse(
                'https://iu-auditor-admin-backend.onrender.com/'))
            .timeout(const Duration(seconds: 5));
        if (res.statusCode == 200) ready = true;
      } catch (_) {}
      attempts++;
      if (!ready) {
        _setStatus('Waking up server... ($attempts)',
            0.5 + attempts * 0.04);
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  void _setStatus(String message, double progress) {
    if (mounted) {
      setState(() {
        _statusMessage = message;
        _progress = progress.clamp(0.0, 1.0);
      });
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlueColor,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: AppAssetImage(
                    imagePath: logo,
                    height: 80,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'IU Auditor',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Admin Portal',
                  style: TextStyle(
                    color: whiteColor.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 260,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 4,
                          backgroundColor: whiteColor.withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryColor),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _statusMessage,
                          key: ValueKey(_statusMessage),
                          style: TextStyle(
                            color: whiteColor.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}