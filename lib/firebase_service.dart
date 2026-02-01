import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ১. নতুন ডাটা যোগ করা (অ্যাডমিন প্যানেল থেকে)
  Future<void> addStory({
    required String category,
    required String title,
    required String desc,
    required String content,
    String? img,
    String? price,
    String? orderUrl,
    String? pdfUrl,
  }) async {
    await _db.collection('stories').add({
      'category': category,
      'title': title,
      'desc': desc,
      'content': content,
      'img': img ?? "",
      'price': price ?? "",
      'orderUrl': orderUrl ?? "",
      'pdfUrl': pdfUrl ?? "",
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ২. প্রোফাইল এবং কভার ফটো আপডেট করা (অ্যাডমিন প্যানেলের জন্য)
  Future<void> updateProfileImages({String? profileUrl, String? coverUrl}) async {
    try {
      Map<String, dynamic> data = {};
      if (profileUrl != null && profileUrl.isNotEmpty) data['profileImg'] = profileUrl;
      if (coverUrl != null && coverUrl.isNotEmpty) data['coverImg'] = coverUrl;

      if (data.isNotEmpty) {
        await _db.collection('settings').doc('profile').set(data, SetOptions(merge: true));
      }
    } catch (e) {
      print("Error updating profile images: $e");
      rethrow;
    }
  }

  // ৩. প্রোফাইল সেটিংসের লাইভ ডাটা পাওয়া (Home Page এর জন্য)
  Stream<DocumentSnapshot> getProfileSettings() {
    return _db.collection('settings').doc('profile').snapshots();
  }

  // ৪. নির্দিষ্ট ক্যাটাগরির ডাটা সরাসরি স্ট্রিম করা (অ্যাডমিন প্যানেলের জন্য)
  Stream<QuerySnapshot> getStoriesStream(String category) {
    return _db
        .collection('stories')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ৫. অ্যাপের ডিসপ্লে সেকশনের জন্য ডাটা স্ট্রিম করা (Home/Book Page এর জন্য)
  Stream<List<Map<String, String>>> getStoriesByCategory(String category) {
    return _db
        .collection('stories')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'title': data['title']?.toString() ?? "",
        'desc': data['desc']?.toString() ?? "",
        'content': data['content']?.toString() ?? "",
        'img': data['img']?.toString() ?? "",
        'price': data['price']?.toString() ?? "",
        'orderUrl': data['orderUrl']?.toString() ?? "",
        'pdfUrl': data['pdfUrl']?.toString() ?? "",
      };
    }).toList());
  }

  // ৬. ডাটা এডিট বা আপডেট করা
  Future<void> updateStory(String docId, Map<String, dynamic> updatedData) async {
    await _db.collection('stories').doc(docId).update(updatedData);
  }

  // ৭. ডাটা ডিলিট করা
  Future<void> deleteStory(String docId) async {
    await _db.collection('stories').doc(docId).delete();
  }

  // ৮. লোকাল ডাটা (AppData) ফায়ারবেসে অটো-সিঙ্ক করা
  Future<void> syncLocalData(List<Map<String, String>> localData, String category) async {
    try {
      final snapshot = await _db
          .collection('stories')
          .where('category', isEqualTo: category)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        for (var item in localData) {
          await addStory(
            category: category,
            title: item['title'] ?? "",
            desc: item['desc'] ?? "",
            content: item['content'] ?? "",
            img: item['img'] ?? "",
          );
        }
        print("$category ডাটা সফলভাবে সিঙ্ক হয়েছে।");
      }
    } catch (e) {
      print("সিঙ্ক এরর: $e");
    }
  }
}