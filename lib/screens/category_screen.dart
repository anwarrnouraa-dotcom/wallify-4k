import 'package:flutter/material.dart';
import 'wallpaper_view.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  final String category;
  final String title;
  const CategoryScreen({super.key, required this.category, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final filtered = manifestMap.keys.where((k) => k.startsWith('assets/${widget.category}/')).toList();
    setState(() => images = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: images.isEmpty ? const Center(child: CircularProgressIndicator()) :
      GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.6),
        itemCount: images.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WallpaperView(imagePath: images[i]))),
          child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset(images[i], fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
