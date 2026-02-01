import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_data.dart';
import 'firebase_service.dart';

// ১. হোমপেজে দেখানোর সেকশন
class PublishedBookSection extends StatelessWidget {
  const PublishedBookSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            "প্রকাশিত বইসমূহ",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          height: 360, // উচ্চতা কিছুটা বাড়ানো হয়েছে টেক্সট ফিট করার জন্য
          child: StreamBuilder<List<Map<String, String>>>(
            stream: FirebaseService().getStoriesByCategory("প্রকাশিত উপন্যাস"),
            builder: (context, snapshot) {
              List<Map<String, dynamic>> displayBooks = AppData.publishedBooks;

              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Map<String, dynamic>> firebaseBooks = snapshot.data!
                    .map((e) => Map<String, dynamic>.from(e))
                    .toList();
                displayBooks = [...firebaseBooks, ...AppData.publishedBooks];
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: displayBooks.length,
                itemBuilder: (context, index) {
                  final book = displayBooks[index];
                  final String? imgPath = book['img'];

                  return Container(
                    width: 170,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetailsPage(book: book))),
                            child: Hero(
                              tag: book['title'] ?? 'book_$index',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: _buildBookImage(imgPath),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(book['title'] ?? "শিরোনামহীন",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailsPage(book: book))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C3E50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("বইটি পড়ুন",
                              style: TextStyle(color: Colors.white, fontSize: 13)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // উন্নত ইমেজ হ্যান্ডলার
  Widget _buildBookImage(String? imgPath) {
    if (imgPath == null || imgPath.isEmpty) {
      return Container(
          width: double.infinity,
          color: Colors.grey[200],
          child: const Icon(Icons.book, color: Colors.grey, size: 50));
    }

    if (imgPath.startsWith('http')) {
      return Image.network(
        imgPath,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (context, error, stackTrace) =>
            Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 40)),
      );
    }

    return Image.asset(
      imgPath,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) =>
          Container(color: Colors.grey[200], child: const Icon(Icons.book, size: 40)),
    );
  }
}

// ২. বইয়ের বিস্তারিত পেজ
class BookDetailsPage extends StatefulWidget {
  final Map<String, dynamic> book;
  const BookDetailsPage({super.key, required this.book});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  bool isSubscribed = false;

  Future<void> _launchOrderLink(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("লিঙ্কটি ওপেন করা যাচ্ছে না")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String bookTitle = widget.book['title'] ?? "বইয়ের নাম";
    final String? bookImg = widget.book['img'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.48,
            pinned: true,
            backgroundColor: const Color(0xFF2C3E50),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildHeaderBackground(bookImg),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                      ),
                    ),
                  ),
                  // ছোট সাইড থাম্বনেইল
                  Positioned(
                    bottom: 30,
                    right: 25,
                    child: Container(
                      height: 120,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 15, offset: Offset(0, 5))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildHeaderBackground(bookImg),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(bookTitle,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text(widget.book['price'] ?? "৳২০০",
                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(" 4.9 (120 reviews)", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Color(0xFFEEEEEE)),
                  ),
                  const Text("গল্প সংক্ষেপে", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Text(widget.book['desc'] ?? "কোনো বর্ণনা পাওয়া যায়নি।",
                      style: TextStyle(fontSize: 16, height: 1.8, color: Colors.black.withOpacity(0.7)),
                      textAlign: TextAlign.justify),
                  const SizedBox(height: 40),
                  // অর্ডার বাটন
                  InkWell(
                    onTap: () => _launchOrderLink(widget.book['orderUrl']),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE65100), Color(0xFFFF8F00)]),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Text("হার্ডকভার অর্ডার করুন",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomReadingBar(),
    );
  }

  // ডিটেইলস পেজের ইমেজের জন্য
  Widget _buildHeaderBackground(String? img) {
    if (img == null || img.isEmpty) {
      return Container(color: Colors.blueGrey, child: const Icon(Icons.book, color: Colors.white, size: 80));
    }
    if (img.startsWith('http')) {
      return Image.network(img, fit: BoxFit.cover);
    }
    return Image.asset(img, fit: BoxFit.cover);
  }

  Widget _buildBottomReadingBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => _openReader(context, isPreview: true),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("ফ্রি পড়ুন",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () => isSubscribed
                  ? _openReader(context, isPreview: false)
                  : _showSubscriptionDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("সম্পূর্ণ পড়ুন",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _openReader(BuildContext context, {required bool isPreview}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFReaderPage(
              url: widget.book['pdfUrl'] ?? "https://www.africau.edu/images/default/sample.pdf",
              isPreview: isPreview,
              title: widget.book['title'] ?? "বই"),
        ));
  }

  void _showSubscriptionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 30),
            const Text("বইটি কিনতে চান?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text("সম্পূর্ণ পিডিএফটি পেতে মাত্র ৫০ টাকা পেমেন্ট করুন।",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD81B60),
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("বিকাশ দিয়ে পেমেন্ট করুন",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ৩. PDF Viewer উইজেট (SfPdfViewer)
class PDFReaderPage extends StatefulWidget {
  final String url;
  final bool isPreview;
  final String title;
  const PDFReaderPage({super.key, required this.url, required this.isPreview, required this.title});

  @override
  State<PDFReaderPage> createState() => _PDFReaderPageState();
}

class _PDFReaderPageState extends State<PDFReaderPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPreview ? "ফ্রি প্রিভিউ: ${widget.title}" : widget.title),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
      ),
      body: widget.url.isEmpty
          ? const Center(child: Text("পিডিএফ লিঙ্ক পাওয়া যায়নি"))
          : SfPdfViewer.network(
        widget.url,
        controller: _pdfViewerController,
        onPageChanged: (PdfPageChangedDetails details) {
          if (widget.isPreview && details.newPageNumber > 5) {
            _pdfViewerController.jumpToPage(5);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("বাকি অংশ পড়তে সাবস্ক্রাইব করুন।")));
          }
        },
      ),
    );
  }
}