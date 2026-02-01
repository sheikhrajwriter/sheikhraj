import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'story_view_page.dart';

class CategoryDetailsPage extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryDetailsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final Color themeColor = category['color'] ?? Colors.blue;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(category['title'] ?? "বিস্তারিত"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: FirebaseService().getStoriesByCategory(category['title']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("এরর: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final List<Map<String, String>> storyList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: storyList.length,
            itemBuilder: (context, index) {
              return _buildStoryCard(context, storyList, index, themeColor);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "এই বিভাগে কোনো লেখা যোগ করা হয়নি",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // প্রতিটি গল্পের লিস্ট কার্ড (ইমেজসহ আপডেট করা হয়েছে)
  Widget _buildStoryCard(BuildContext context, List<Map<String, String>> storyList, int index, Color themeColor) {
    final String? imgPath = storyList[index]['img'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        // --- ইমেজ থাম্বনেইল সেকশন ---
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 60,
            height: 60,
            color: themeColor.withOpacity(0.1),
            child: _buildThumbnail(imgPath, themeColor),
          ),
        ),
        title: Text(
          storyList[index]['title'] ?? "শিরোনামহীন",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            storyList[index]['desc'] ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: themeColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryViewPage(
                storyList: storyList,
                initialIndex: index,
              ),
            ),
          );
        },
      ),
    );
  }

  // ইমেজ রেন্ডারিং হেল্পার মেথড
  Widget _buildThumbnail(String? imgPath, Color themeColor) {
    if (imgPath == null || imgPath.isEmpty) {
      return Icon(Icons.book, color: themeColor.withOpacity(0.5), size: 30);
    }

    if (imgPath.startsWith('http')) {
      return Image.network(
        imgPath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)));
        },
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, color: themeColor.withOpacity(0.5), size: 25),
      );
    } else {
      return Image.asset(
        imgPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.book, color: themeColor.withOpacity(0.5), size: 30),
      );
    }
  }
}