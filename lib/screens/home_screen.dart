import 'package:flutter/material.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"name": "طبيعة", "en": "nature", "count": "9", "icon": "🌿", "color": 0xFF2E7D32},
    {"name": "حيوانات", "en": "animals", "count": "17", "icon": "🦁", "color": 0xFFFF6F00},
    {"name": "أشخاص", "en": "persons", "count": "14", "icon": "🔥", "color": 0xFFC62828},
    {"name": "سيارات", "en": "cars", "count": "5", "icon": "🏎️", "color": 0xFF1565C0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallify 4K - 45 Wallpaper', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: cat['en'], title: cat['name']))),
            child: Container(
              decoration: BoxDecoration(color: Color(cat['color']).withOpacity(0.3), borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(cat['color']), width: 1.5)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(cat['icon'], style: const TextStyle(fontSize: 50)),
                const SizedBox(height: 10),
                Text(cat['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${cat['count']} صور', style: const TextStyle(color: Colors.white70)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
