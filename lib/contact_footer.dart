import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFooter extends StatelessWidget {
  const ContactFooter({super.key});

  // লিঙ্ক ওপেন করার ফাংশন
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A252F), // ডার্ক থিম
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "শেখ রাজ একজন কবি ও সাহিত্যিক কণ্ঠস্বর, যার রচনায় ধরা পড়ে মানুষের বাস্তব জীবনের অভিজ্ঞতা এবং মানব আত্মার সৌন্দর্য বিকাশ। দর্শন ও সুফি শাস্ত্রে তার অসাধারণ দখল তার লেখনীকে আরও গভীরতা প্রদান করেছে। একই সঙ্গে উর্দু ও ফারসি ভাষার তার অনন্য সংমিশ্রণ তার কবিতায় সৃষ্টি করেছে এক বিশেষ সুরেলা রূপ। দেশপ্রেম, গণ আন্দোলন, মানবতাবাদ ও প্রেম তার সৃষ্টিশীলতার কেন্দ্রবিন্দু। বাংলাদেশের কুষ্টিয়া জেলার সমৃদ্ধ সাহিত্য-সংস্কৃতির পরিবেশে জন্ম নেওয়া শেখ রাজ পৃথিবীতে আসেন ২১ জুলাই ১৯৯৮ সালে (৬ শ্রাবণ ১৪০৫ বঙ্গাব্দ)।",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.8,
                fontFamily: 'Hind Siliguri',
              ),
            ),
          ),
          const SizedBox(height: 40),

          // সোশ্যাল আইকন রো
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _socialIconButton(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () => _launchURL("https://www.facebook.com/share/1GDiNfv3Cy/"),
              ),
              _socialIconButton(
                icon: Icons.camera_alt_rounded,
                color: const Color(0xFFE4405F),
                onTap: () => _launchURL("https://www.instagram.com/sheikhrajofficial?igsh=MWNud20xMGVxMWJpdA=="),
              ),
              _socialIconButton(
                icon: Icons.chat_bubble_outline,
                color: const Color(0xFF25D366),
                onTap: () => _launchURL("https://wa.me/8801977857619"),
              ),
              _socialIconButton(
                icon: Icons.phone_in_talk,
                color: Colors.blueAccent,
                onTap: () => _launchURL("tel:+8801977857619"),
              ),
              _socialIconButton(
                icon: Icons.email_rounded,
                color: Colors.redAccent,
                onTap: () => _launchURL("mailto:erosbangla@gmail.com"),
              ),
            ],
          ),

          const SizedBox(height: 30),
          const Text(
            "Email: erosbangla@gmail.com  |  Phone: 01977857619",
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white10, thickness: 1),
          const SizedBox(height: 20),
          const Text(
            "© 2026 Sheikh Raj. All Rights Reserved.",
            style: TextStyle(color: Colors.white24, fontSize: 13, letterSpacing: 1),
          ),
          const SizedBox(height: 8),

          // ক্রেডিট অংশ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Developed by ", style: TextStyle(color: Colors.white10, fontSize: 12)),
              Text(
                "Ashik Hossain",
                style: TextStyle(color: Colors.blueGrey[700], fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // সোশ্যাল আইকন বাটন উইজেট
  Widget _socialIconButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}