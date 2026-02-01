import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseService _service = FirebaseService();
  String _selectedCategory = 'কবিতা';

  final List<String> _categories = [
    'কবিতা', 'উপন্যাস', 'ছোটগল্প', 'প্রহসন', 'দোঁহা', 'প্রবন্ধ', 'প্রকাশিত উপন্যাস', 'গ্যালারি'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("অ্যাডমিন ড্যাশবোর্ড", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest),
            onPressed: () => _showProfileEditDialog(context),
            tooltip: "প্রোফাইল ও কভার সেটিংস",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey[800],
        onPressed: () => _selectedCategory == 'গ্যালারি'
            ? _showGalleryUploadDialog(context)
            : _showFormDialog(context),
        label: Text(_selectedCategory == 'গ্যালারি' ? "ছবি যোগ করুন" : "নতুন লেখা"),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildCategoryHeader(),
          Expanded(
            child: _selectedCategory == 'গ্যালারি'
                ? _buildGalleryManager()
                : _buildStoryManager(),
          ),
        ],
      ),
    );
  }

  // --- ক্যাটাগরি চিপস ফিল্টার ---
  Widget _buildCategoryHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: _categories.map((cat) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(cat),
            selected: _selectedCategory == cat,
            onSelected: (val) => setState(() => _selectedCategory = cat),
            selectedColor: Colors.blueGrey[800],
            labelStyle: TextStyle(
                color: _selectedCategory == cat ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold
            ),
          ),
        )).toList(),
      ),
    );
  }

  // --- কন্টেন্ট (গল্প/কবিতা) ম্যানেজার ---
  Widget _buildStoryManager() {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.getStoriesStream(_selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _emptyState();

        final docs = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: _buildLeadingThumbnail(data['img']),
                title: Text(data['title'] ?? "শিরোনামহীন", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(data['desc'] ?? "কোনো বর্ণনা নেই", maxLines: 1),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showFormDialog(context, id: docId, currentData: data)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(context, 'stories', docId)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- গ্যালারি ম্যানেজার (Grid View) ---
  Widget _buildGalleryManager() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('gallery').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _emptyState();

        final docs = snapshot.data!.docs;
        return GridView.builder(
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(data['url'], fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                ),
                Positioned(
                  top: 0, right: 0,
                  child: CircleAvatar(
                    radius: 15, backgroundColor: Colors.red.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 15, color: Colors.white),
                      onPressed: () => _confirmDelete(context, 'gallery', docs[index].id),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLeadingThumbnail(String? imgUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 45, height: 60, color: Colors.grey[200],
        child: (imgUrl != null && imgUrl.startsWith('http'))
            ? Image.network(imgUrl, fit: BoxFit.cover)
            : const Icon(Icons.image, color: Colors.grey),
      ),
    );
  }

  Widget _emptyState() => const Center(child: Text("কোনো তথ্য খুঁজে পাওয়া যায়নি"));

  // --- ডাটা ডায়ালগসমূহ ---

  void _showGalleryUploadDialog(BuildContext context) {
    final urlC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("গ্যালারিতে ছবি যোগ"),
        content: TextField(controller: urlC, decoration: const InputDecoration(hintText: "ইমেজ ডাইরেক্ট লিঙ্ক (URL)")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () async {
              if (urlC.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('gallery').add({
                  'url': urlC.text, 'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            },
            child: const Text("যোগ করুন"),
          )
        ],
      ),
    );
  }

  void _showFormDialog(BuildContext context, {String? id, Map<String, dynamic>? currentData}) {
    final titleC = TextEditingController(text: currentData?['title']);
    final descC = TextEditingController(text: currentData?['desc']);
    final contentC = TextEditingController(text: currentData?['content']);
    final imgC = TextEditingController(text: currentData?['img']);
    final priceC = TextEditingController(text: currentData?['price']);
    final orderUrlC = TextEditingController(text: currentData?['orderUrl']);
    final pdfUrlC = TextEditingController(text: currentData?['pdfUrl']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? "নতুন যুক্ত করুন" : "এডিট করুন"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleC, decoration: const InputDecoration(labelText: "শিরোনাম *")),
              TextField(controller: descC, decoration: const InputDecoration(labelText: "ছোট বর্ণনা")),
              TextField(controller: imgC, decoration: const InputDecoration(labelText: "থাম্বনেইল/কভার URL")),
              if (_selectedCategory == 'প্রকাশিত উপন্যাস') ...[
                TextField(controller: priceC, decoration: const InputDecoration(labelText: "দাম")),
                TextField(controller: orderUrlC, decoration: const InputDecoration(labelText: "অর্ডার লিঙ্ক")),
                TextField(controller: pdfUrlC, decoration: const InputDecoration(labelText: "PDF লিঙ্ক")),
              ],
              TextField(controller: contentC, decoration: const InputDecoration(labelText: "মূল লেখা"), maxLines: 8),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'title': titleC.text, 'desc': descC.text, 'content': contentC.text,
                'img': imgC.text, 'category': _selectedCategory, 'price': priceC.text,
                'orderUrl': orderUrlC.text, 'pdfUrl': pdfUrlC.text, 'updatedAt': FieldValue.serverTimestamp(),
              };
              if (id == null) {
                data['createdAt'] = FieldValue.serverTimestamp();
                await FirebaseFirestore.instance.collection('stories').add(data);
              } else {
                await FirebaseFirestore.instance.collection('stories').doc(id).update(data);
              }
              Navigator.pop(context);
            },
            child: const Text("সেভ"),
          )
        ],
      ),
    );
  }

  void _showProfileEditDialog(BuildContext context) {
    final profileUrlC = TextEditingController();
    final coverUrlC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("প্রোফাইল সেটিংস"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: profileUrlC, decoration: const InputDecoration(labelText: "প্রোফাইল ছবি URL")),
            const SizedBox(height: 10),
            TextField(controller: coverUrlC, decoration: const InputDecoration(labelText: "কভার ছবি URL")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("বাতিল")),
          ElevatedButton(
            onPressed: () async {
              await _service.updateProfileImages(profileUrl: profileUrlC.text, coverUrl: coverUrlC.text);
              Navigator.pop(context);
            },
            child: const Text("আপডেট"),
          )
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String collection, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("মুছে ফেলতে চান?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("না")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection(collection).doc(id).delete();
              Navigator.pop(context);
            },
            child: const Text("হ্যাঁ, মুছুন", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}