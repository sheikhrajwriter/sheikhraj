import 'package:flutter/material.dart';

class AppData {
  // ১. পাবলিশড বইয়ের ডাটা
  static final List<Map<String, dynamic>> publishedBooks = [
    {
      'title': 'চন্দ্রবতী',
      'img': 'assets/images/book/book_2.png',
      'price': '৳২৪০',
      'type': 'Hardcover',
      'orderUrl': 'https://www.rokomari.com/book/364445/chandrabati',
      'desc': 'চন্দ্রবতী বাংলা সাহিত্যের একটি অনন্য সৃষ্টি।',
      'content': 'এখানে আপনার বইয়ের বিস্তারিত বা প্রিভিউ কন্টেন্ট থাকবে...'
    },
    {
      'title': 'ত্রিমূর্তি',
      'img': 'assets/images/book/book_1.jpg',
      'price': '৳১৮০',
      'type': 'Paperback',
      'orderUrl': 'https://www.rokomari.com/book/252172/trimurti',
      'desc': 'তিনটি কাব্য সংকলনের এক অপূর্ব মিলনমেলা এই ত্রিমূর্তি।',
      'content': 'কবিতার লাইনগুলো এখানে শুরু হবে...'
    },
  ];

  // ২. ক্যাটাগরি অনুযায়ী বিস্তারিত ডাটা লিস্ট
  static final List<Map<String, String>> novels = [
    {
      'title': 'চন্দ্রবতী',
      'desc': 'ঐতিহাসিক উপন্যাস',
      'content': 'ষোড়শ শতাব্দীর প্রেক্ষাপটে রচিত এই উপন্যাসের শুরুটা হয় এক বর্ষণমুখর সন্ধ্যায়...'
    },
    {
      'title': 'নীল দর্পণ',
      'desc': 'সামাজিক উপন্যাস',
      'content': 'গ্রামের সাধারণ মানুষের দুঃখ-দুর্দশার কথা এখানে ফুটে উঠেছে। নীল চাষীদের আর্তনাদ আর শোষণের এক জীবন্ত দলিল এই আখ্যান...'
    },
    {
      'title': 'পথের পাঁচালী',
      'desc': 'বিভূতিভূষণ বন্দ্যোপাধ্যায়',
      'content': 'অপু আর দুর্গার সেই চঞ্চল শৈশব, কাশফুল আর রেলগাড়ি দেখার অদম্য কৌতূহল নিয়ে গড়ে ওঠা এক কালজয়ী গল্প...'
    },
  ];

  static final List<Map<String, String>> poems = [
    {
      'title': 'বিদ্রোহী',
      'desc': 'কাজী নজরুল ইসলাম',
      'content': 'বল বীর - বল উন্নত মম শির! শির নেহারি আমারি, নতশির ওই শিখর হিমাদ্রির!'
    },
    {
      'title': 'সোনার তরী',
      'desc': 'রবীন্দ্রনাথ ঠাকুর',
      'content': 'গগনে গরজে মেঘ, ঘন বরষা। কূলে একা বসি আছি, নাহি ভরসা। রাশি রাশি ভারা ভারা ধান কাটা হল সারা...'
    },
    {
      'title': 'বনলতা সেন',
      'desc': 'জীবনানন্দ দাশ',
      'content': 'হাজার বছর ধরে আমি পথ হাঁটিতেছি পৃথিবীর পথে, সিংহল সমুদ্র থেকে নিশীথের মালয় সাগরে অনেক ঘুরেছি আমি...'
    },
  ];

  static final List<Map<String, String>> shortStories = [
    {
      'title': 'পোস্টমাস্টার',
      'desc': 'রবীন্দ্রনাথ ঠাকুর',
      'content': 'গ্রামটি অতি সামান্য। নিকটেই একটি জঙ্গল আছে এবং একটি নদী। পোস্টমাস্টার আসিয়াছেন কলিকাতা হইতে...'
    },
    {
      'title': 'একুশের গল্প',
      'desc': 'জহির রায়হান',
      'content': 'তপুকে ওরা আজ নিয়ে যাবে। একুশে ফেব্রুয়ারির সেই উত্তাল দিনগুলোর কথা মনে পড়ে যায়...'
    },
  ];

  static final List<Map<String, String>> essays = [
    {
      'title': 'সভ্যতার সংকট',
      'desc': 'রবীন্দ্রনাথ ঠাকুর',
      'content': 'মানুষের প্রতি বিশ্বাস হারানো পাপ, সেই বিশ্বাস রক্ষা করাই আজ বড় চ্যালেঞ্জ...'
    },
    {
      'title': 'শিক্ষার হেরফের',
      'desc': 'প্রবন্ধ সংকলন',
      'content': 'আমাদের শিক্ষা ব্যবস্থার ত্রুটি এবং প্রকৃত মানুষ হওয়ার উপায় নিয়ে বিশেষ আলোচনা...'
    },
  ];

  // ৩. মূল ক্যাটাগরি লিস্ট (UI-তে লুপ চালানোর জন্য)
  static final List<Map<String, dynamic>> categories = [
    {
      'title': 'কবিতা',
      'icon': Icons.auto_stories,
      'color': Colors.blue,
      'preview': 'ছন্দ, অন্ত্যমিল ও আবেগের বহিঃপ্রকাশ...',
      'items': poems,
    },
    {
      'title': 'উপন্যাস',
      'icon': Icons.menu_book,
      'color': Colors.orange,
      'preview': 'দীর্ঘ আখ্যান ও জীবনবোধের গল্প...',
      'items': novels,
    },
    {
      'title': 'ছোটগল্প',
      'icon': Icons.import_contacts,
      'color': Colors.green,
      'preview': 'অল্প কথায় জীবনের বড় প্রতিচ্ছবি...',
      'items': shortStories,
    },
    {
      'title': 'প্রহসন',
      'icon': Icons.theater_comedy,
      'color': Colors.deepPurple,
      'preview': 'হাস্যরসের মাধ্যমে সমাজ সমালোচনা...',
      'items': [
        {
          'title': 'বুড়ো শালিকের ঘাড়ে রোঁ',
          'desc': 'মাইকেল মধুসূদন দত্ত',
          'content': 'তৎকালীন সমাজের ভণ্ডামি নিয়ে এক ধারালো প্রহসন...'
        }
      ],
    },
    {
      'title': 'দোঁহা',
      'icon': Icons.format_quote,
      'color': Colors.redAccent,
      'preview': 'দুই লাইনের গভীর জীবন দর্শন...',
      'items': [
        {
          'title': 'কবির দোঁহা',
          'desc': 'জীবন দর্শন',
          'content': 'মাটি কহে কুম্ভারকো, তু ক্যায়া কুঁদলে মোহি। এক দিন অ্যায়সা আয়েগা, ম্যায় কুঁদলেগি তোহি।'
        }
      ],
    },
    {
      'title': 'প্রবন্ধ',
      'icon': Icons.history_edu,
      'color': Colors.teal,
      'preview': 'যুক্তি ও তথ্যের সুসংগত বিশ্লেষণ...',
      'items': essays,
    },
  ];
}