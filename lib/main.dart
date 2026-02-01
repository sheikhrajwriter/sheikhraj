import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'app_data.dart';
import 'contact_footer.dart';
import 'published_books.dart';
import 'gallery_section.dart';
import 'genre_section.dart';
import 'bio_section.dart';
import 'story_view_page.dart';
import 'firebase_service.dart';
import 'admin_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WriterPortfolioApp());
}

class WriterPortfolioApp extends StatelessWidget {
  const WriterPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'শেখ রাজ - পোর্টফোলিও',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Hind Siliguri',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String defaultProfile = 'assets/images/profile.jpg';
  final String defaultCover = 'assets/images/cover.jpg';
  int _adminTapCount = 0;

  // প্রতিটি সেকশনের জন্য GlobalKey তৈরি
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _novelKey = GlobalKey();
  final GlobalKey _poemKey = GlobalKey();
  final GlobalKey _shortStoryKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _bioKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _syncInitialDataToFirebase();
  }

  Future<void> _syncInitialDataToFirebase() async {
    final service = FirebaseService();
    await service.syncLocalData(AppData.novels, "উপন্যাস");
    await service.syncLocalData(AppData.poems, "কবিতা");
  }

  // স্ক্রল করার লজিক
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Navigator.pop(this.context); // ড্রয়ার বন্ধ করা
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showAdminPasswordDialog() {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("অ্যাডমিন ভেরিফিকেশন", textAlign: TextAlign.center),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "পাসওয়ার্ড দিন",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == "210730") {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanel()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("ভুল পাসওয়ার্ড!"), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("প্রবেশ করুন"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true, // অ্যাপবার পেছনের কন্টেন্টের উপর থাকবে
      drawer: _buildSideDrawer(),
      appBar: AppBar(
        // ৩০% স্বচ্ছ অ্যাপবার (০.৩ অপাসিটি)
        backgroundColor: Colors.blueGrey[900]!.withValues(alpha: 0.3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("শেখ রাজ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(key: _headerKey, child: _buildModernHeader()),
            const SizedBox(height: 30),
            const PublishedBookSection(),
            const SizedBox(height: 30),

            // সেকশনগুলোতে Key বসানো হয়েছে
            Container(key: _novelKey, child: _buildHybridContentSection("উপন্যাস", Colors.orange, AppData.novels)),
            Container(key: _poemKey, child: _buildHybridContentSection("কবিতা", Colors.blue, AppData.poems)),
            Container(key: _shortStoryKey, child: _buildHybridContentSection("ছোটগল্প", Colors.green, [])),

            _buildHybridContentSection("প্রহসন", Colors.redAccent, []),
            _buildHybridContentSection("দোঁহা", Colors.purple, []),

            const GenreSection(),
            Container(key: _galleryKey, child: const GallerySection()),
            Container(key: _bioKey, child: const BioSection()),
            const ContactFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSideDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey[900]),
            accountName: const Text("শেখ রাজ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            accountEmail: const Text("কবি ও কথাসাহিত্যিক"),
            currentAccountPicture: CircleAvatar(backgroundImage: AssetImage(defaultProfile)),
          ),
          // বাটনগুলোতে ক্লিক ফাংশন অ্যাড করা হয়েছে
          _drawerItem(Icons.home, "হোম", () => _scrollToSection(_headerKey)),
          _drawerItem(Icons.book, "উপন্যাস", () => _scrollToSection(_novelKey)),
          _drawerItem(Icons.edit_note, "কবিতা", () => _scrollToSection(_poemKey)),
          _drawerItem(Icons.auto_stories, "ছোটগল্প", () => _scrollToSection(_shortStoryKey)),
          _drawerItem(Icons.collections, "গ্যালারি", () => _scrollToSection(_galleryKey)),
          _drawerItem(Icons.person, "বায়োগ্রাফি", () => _scrollToSection(_bioKey)),
          const Spacer(),
          const Divider(),
          _drawerItem(Icons.admin_panel_settings, "অ্যাডমিন লগইন", () {
            Navigator.pop(context);
            _showAdminPasswordDialog();
          }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // মেনু আইটেমের জন্য সলিড বক্স ডিজাইন
  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(color: Colors.blueGrey, width: 5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blueGrey, size: 22),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseService().getProfileSettings(),
      builder: (context, snapshot) {
        String currentProfile = defaultProfile;
        String currentCover = defaultCover;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          currentProfile = data['profileImg'] ?? defaultProfile;
          currentCover = data['coverImg'] ?? defaultCover;
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: currentCover.startsWith('http') ? NetworkImage(currentCover) : AssetImage(currentCover) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    setState(() => _adminTapCount++);
                    if (_adminTapCount == 3) {
                      _adminTapCount = 0;
                      _showAdminPasswordDialog();
                    }
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: currentProfile.startsWith('http') ? NetworkImage(currentProfile) : AssetImage(currentProfile) as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text("শেখ রাজ", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                const Text("কবি ও কথাসাহিত্যিক", style: TextStyle(fontSize: 18, color: Colors.white70, fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHybridContentSection(String categoryName, Color color, List<Map<String, String>> localItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Container(width: 5, height: 25, color: color),
              const SizedBox(width: 10),
              Text(categoryName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(onPressed: () {}, child: Text("সব দেখুন", style: TextStyle(color: color))),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: StreamBuilder<List<Map<String, String>>>(
            stream: FirebaseService().getStoriesByCategory(categoryName),
            builder: (context, snapshot) {
              List<Map<String, String>> displayItems = snapshot.hasData ? [...snapshot.data!, ...localItems] : localItems;
              if (displayItems.isEmpty) return const Center(child: Text("কোনো তথ্য পাওয়া যায়নি"));
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: displayItems.length,
                itemBuilder: (context, index) => _buildItemCard(context, displayItems[index], color, displayItems, index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, Map<String, String> item, Color color, List<Map<String, String>> allItems, int index) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoryViewPage(storyList: allItems, initialIndex: index))),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              child: Container(width: 90, height: 220, color: color.withValues(alpha: 0.05), child: _buildThumbnail(item['img'], color)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] ?? "শিরোনাম", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1),
                    const SizedBox(height: 5),
                    Text(item['desc'] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? imgPath, Color color) {
    if (imgPath == null || imgPath.isEmpty) return Icon(Icons.book, color: color.withValues(alpha: 0.5), size: 40);
    return imgPath.startsWith('http')
        ? Image.network(imgPath, width: 90, height: 220, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.broken_image))
        : Image.asset(imgPath, width: 90, height: 220, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.book));
  }
}