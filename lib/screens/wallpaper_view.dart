import 'package:flutter/material.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperView extends StatelessWidget {
  final String imagePath;
  const WallpaperView({super.key, required this.imagePath});

  Future<void> setWallpaper(BuildContext context, int type) async {
    try {
      final byteData = await rootBundle.load(imagePath);
      final tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/temp_wallpaper.jpg');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      
      int location = AsyncWallpaper.HOME_SCREEN;
      if (type == 2) location = AsyncWallpaper.LOCK_SCREEN;
      if (type == 3) location = AsyncWallpaper.BOTH_SCREENS;

      await AsyncWallpaper.setWallpaperFromFile(
        filePath: file.path,
        wallpaperLocation: location,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تعيين الخلفية ✅')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset(imagePath, fit: BoxFit.cover)),
          Positioned(
            top: 40, left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => setWallpaper(context, 1), child: const Text('رئيسية')),
                ElevatedButton(onPressed: () => setWallpaper(context, 2), child: const Text('القفل')),
                ElevatedButton(onPressed: () => setWallpaper(context, 3), child: const Text('الكل')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
