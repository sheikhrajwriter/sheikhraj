import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "গ্যালারি",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 10),
          Container(height: 3, width: 50, color: Colors.orange),
          const SizedBox(height: 40),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('gallery')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("গ্যালারিতে কোনো ছবি নেই");
              }

              final List<String> images = snapshot.data!.docs
                  .map((doc) => doc['url'] as String)
                  .toList();

              return GridView.builder(
                shrinkWrap: true, // স্ক্রল ভিউর ভেতরে ব্যবহারের জন্য জরুরি
                physics: const NeverScrollableScrollPhysics(),
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // ২ সারি (Row) এর জন্য এখানে ২ বা ৪ দিতে পারেন আপনার পছন্দমতো
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5, // ইমেজের অনুপাত
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _openFullScreenImage(context, images[index]),
                    child: Hero(
                      tag: images[index],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ফুল স্ক্রিন ইমেজ দেখার জন্য
  void _openFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Hero(
              tag: imageUrl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}