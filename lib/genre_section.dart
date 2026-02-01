import 'package:flutter/material.dart';
import 'app_data.dart';
import 'category_details_page.dart';

class GenreSection extends StatelessWidget {
  const GenreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "ক্যাটাগরি প্রিভিউ",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 4,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 25,
            alignment: WrapAlignment.center,
            children: AppData.categories.map((cat) => _buildCard(context, cat)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> cat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsPage(category: cat),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cat['color'].withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: cat['color'].withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cat['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(cat['icon'], color: cat['color'], size: 32),
            ),
            const SizedBox(height: 20),
            Text(
                cat['title'] ?? "",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF34495E))
            ),
            const SizedBox(height: 12),
            Text(
              cat['preview'] ?? "",
              style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "${cat['title']} পড়ুন",
                  style: TextStyle(color: cat['color'], fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_right_alt_rounded, color: cat['color'], size: 22),
              ],
            )
          ],
        ),
      ),
    );
  }
}