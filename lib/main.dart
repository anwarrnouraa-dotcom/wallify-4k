import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallify 4K',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"name": "Nature", "count": 9, "color": Colors.green, "icon": Icons.eco, "folder": "nature"},
    {"name": "Animals", "count": 17, "color": Colors.orange, "icon": Icons.pets, "folder": "animals"},
    {"name": "Persons", "count": 14, "color": Colors.red, "icon": Icons.person, "folder": "persons"},
    {"name": "Cars", "count": 5, "color": Colors.blue, "icon": Icons.directions_car, "folder": "cars"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallify 4K'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: cat))),
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFF1E1E2F), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: cat['color'], borderRadius: BorderRadius.circular(16)), child: Icon(cat['icon'], size: 40, color: Colors.white)),
                    const SizedBox(height: 12),
                    Text(cat['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${cat['count']} images', style: const TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final Map<String, dynamic> category;
  const CategoryScreen({super.key, required this.category});

  List<String> getImages() {
    int count = category['count'];
    String folder = category['folder'];
    return List.generate(count, (i) => 'assets/$folder/${i+1}.jpg');
  }

  @override
  Widget build(BuildContext context) {
    final images = getImages();
    return Scaffold(
      appBar: AppBar(title: Text(category['name'])),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.7),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewScreen(imagePath: images[index]))),
            child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset(images[index], fit: BoxFit.cover)),
          );
        },
      ),
    );
  }
}

class ViewScreen extends StatefulWidget {
  final String imagePath;
  const ViewScreen({super.key, required this.imagePath});
  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  bool isLoading = false;

  Future<void> setWallpaper() async {
    setState(() => isLoading = true);
    try {
      final byteData = await rootBundle.load(widget.imagePath);
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/temp_wallpaper.jpg').create();
      await file.writeAsBytes(byteData.buffer.asUint8List());

      final result = await AsyncWallpaper.setWallpaper(
        request: WallpaperRequest(
          target: WallpaperTarget.home,
          sourceType: WallpaperSourceType.file,
          source: file.path,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.toString())));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset(widget.imagePath, fit: BoxFit.cover)),
          Positioned(top: 40, left: 10, child: CircleAvatar(backgroundColor: Colors.black54, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)))),
          Positioned(bottom: 30, left: 20, right: 20, child: ElevatedButton(onPressed: isLoading ? null : setWallpaper, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue), child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Set as Wallpaper', style: TextStyle(fontSize: 18)))),
        ],
      ),
    );
  }
}
