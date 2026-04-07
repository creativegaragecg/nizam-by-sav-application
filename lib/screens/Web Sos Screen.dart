import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:savvyions/Utils/Constants/utils.dart';
import '../../Utils/Constants/styles.dart';
import '../../Utils/Custom/custom_text.dart';
import '../Services/Sos Service.dart';
import '../Utils/Custom/navigationbar.dart';
import '../models/Web Sos.dart';

class WebSosScreen extends StatefulWidget {
  const WebSosScreen({super.key, required this.sosData});
     final Datum sosData;   // ← SosData → Datum


  @override
  State<WebSosScreen> createState() => _WebSosScreenState();
}

class _WebSosScreenState extends State<WebSosScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _acknowledging = false;

  @override
  void initState() {
    super.initState();
    _startAlarm();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startAlarm() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // Put your emergency audio file in assets/audio/sos_alarm.mp3
    await _audioPlayer.play(AssetSource('sounds/mixkit-classic-alarm-995.wav'));
  }

  Future<void> _acknowledge() async {
    setState(() => _acknowledging = true);
    await _audioPlayer.stop();
    await SosService().acknowledgesSos(widget.sosData.sosId!);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavigationBarScreen()),
            (route) => false,
      );
    }  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifData = widget.sosData.notifications?.isNotEmpty == true
        ? widget.sosData.notifications!.first.data
        : null;

    final reason  = notifData?.reason?.trim() ?? 'Emergency';
    final society = notifData?.societyName ?? '';
    final by      = notifData?.triggeredBy ?? '-';
    final time    = widget.sosData.createdAt != null
        ? formatDateTime(widget.sosData.createdAt.toString())
        : '-';

    return PopScope(
      // Prevent back button from dismissing
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              children: [
                // ── Top bar ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: society,
                      style: basicColor(15, Colors.white),
                    ),
                    CustomText(
                      text: time,
                      style: basicColor(15, Colors.white),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // ── Pulsing SOS Icon ──
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade700,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // ── SOS Title ──
                CustomText(
                  text: "⚠ SYSTEM EMERGENCY",
                  style: basicColorBold(22, Colors.white),
                ),
                SizedBox(height: 1.h),
                CustomText(
                  text: "Active SOS Alert",
                  style: basicColor(16, Colors.white70),
                ),

                SizedBox(height: 4.h),

                // ── Details card ──
                Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border:
                    Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      _detailRow(Icons.error_outline, "Reason", reason),
                      Divider(color: Colors.white24, height: 2.h),
                      _detailRow(Icons.person_outline, "Triggered By",
                          '$by${by.isNotEmpty ? ' ($by)' : ''}'),
                      Divider(color: Colors.white24, height: 2.h),
                      _detailRow(Icons.access_time, "Time", time),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Acknowledge button ──
                SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed: _acknowledging ? null : _acknowledge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _acknowledging
                        ? CircularProgressIndicator(
                        color: Colors.red.shade900, strokeWidth: 2)
                        : CustomText(
                      text: "✓  Acknowledge & Dismiss",
                      style: basicColorBold(16, Colors.red.shade900),
                    ),
                  ),
                ),

                SizedBox(height: 1.h),
                CustomText(
                  text: "You must acknowledge to continue using the app",
                  style: basicColor(14.5, Colors.white),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: label, style: basicColor(15, Colors.white)),
            SizedBox(height: 0.3.h),
            CustomText(
              text: value,
              style: basicColorBold(15, Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}