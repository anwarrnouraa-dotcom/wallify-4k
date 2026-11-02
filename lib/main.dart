import 'package:flutter/material.dart';

void main() => runApp(const WallifyApp());

class WallifyApp extends StatelessWidget {
  const WallifyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallify 4K',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<String> cars = const [
    'assets/cars/1.jpg.jpeg',
    'assets/cars/2.jpg.jpeg',
    'assets/cars/3.jpg.jpeg',
    'assets/cars/4.jpg.jpeg',
    'assets/cars/5.jpg.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallify 4K'), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => FullScreen(image: cars[index])),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(cars[index], fit: BoxFit.cover,
                errorBuilder: (c,e,s) => Container(color: Colors.grey, child: Icon(Icons.error)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  final String image;
  const FullScreen({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.pop(context))),
      body: Center(
        child: InteractiveViewer(
          child: Image.asset(image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
