import 'package:flutter/material.dart';

class BioSection extends StatelessWidget {
  const BioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: const [
                Text(
                  "আমার কথা",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    fontFamily: 'Hind Siliguri',
                  ),
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.format_quote,
                  color: Colors.blueGrey,
                  size: 40,
                ),
              ],
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}