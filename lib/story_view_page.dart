import 'dart:ui';
import 'package:flutter/material.dart';

class StoryViewPage extends StatefulWidget {
  final List<Map<String, String>> storyList;
  final int initialIndex;

  const StoryViewPage({
    super.key,
    required this.storyList,
    required this.initialIndex,
  });

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  late PageController _pageController;
  double _fontSize = 18.0;
  bool _isDarkMode = false;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color cardColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // ব্যাকগ্রাউন্ডে হালকা কিছু ব্লার ইফেক্ট (আধুনিক লুকের জন্য)
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 200,
              backgroundColor: Colors.blue.withValues(alpha: 0.05),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.storyList.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return _buildAnimatedStoryCard(index, cardColor);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // কাস্টম অ্যাপ বার
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: _isDarkMode ? Colors.white : Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isDarkMode ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${_currentPage + 1} / ${widget.storyList.length}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.format_size, color: _isDarkMode ? Colors.white : Colors.black87),
            onPressed: () => setState(() => _fontSize = (_fontSize < 28) ? _fontSize + 2 : 16),
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, color: _isDarkMode ? Colors.white : Colors.black87),
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
          ),
        ],
      ),
    );
  }

  // সেন্টার বক্সের এনিমেটেড স্টোরি কার্ড
  Widget _buildAnimatedStoryCard(int index, Color cardColor) {
    final story = widget.storyList[index];

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
        }

        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isDarkMode ? 0.3 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      // ছোট একটি ইনডিকেটর লাইন
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        story['title'] ?? "শিরোনামহীন",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _fontSize + 10,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (story['desc'] != null && story['desc']!.isNotEmpty)
                        Text(
                          story['desc']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _fontSize - 2,
                            color: Colors.orange[800],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Divider(thickness: 0.5),
                      ),
                      SelectableText(
                        story['content'] ?? "কোনো তথ্য পাওয়া যায়নি।",
                        style: TextStyle(
                          fontSize: _fontSize,
                          height: 1.8,
                          color: _isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        "•••",
                        style: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.5),
                          letterSpacing: 10,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}