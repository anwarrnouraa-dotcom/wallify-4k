import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

void main()=>runApp(const WallifyApp());

class WallifyApp extends StatelessWidget{
  const WallifyApp({super.key});
  @override Widget build(BuildContext c){
    return MaterialApp(debugShowCheckedModeBanner:false, theme:ThemeData.dark().copyWith(scaffoldBackgroundColor:const Color(0xFF0A0A0A)), home:const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  final categories=const[
    {"name":"طبيعة","en":"nature","count":9,"icon":"🌿","color":0xFF2E7D32},
    {"name":"حيوانات","en":"animals","count":17,"icon":"🦁","color":0xFFFF6F00},
    {"name":"أشخاص","en":"persons","count":14,"icon":"🔥","color":0xFFC62828},
    {"name":"سيارات","en":"cars","count":5,"icon":"🏎️","color":0xFF1565C0},
  ];
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:const Text('Wallify 4K - 45 صورة'),centerTitle:true),
      body:GridView.builder(
        padding:const EdgeInsets.all(16),
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:16,mainAxisSpacing:16,childAspectRatio:0.85),
        itemCount:categories.length,
        itemBuilder:(c,i){
          final cat=categories[i];
          return GestureDetector(
            onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CategoryScreen(category:cat['en'] as String,title:cat['name'] as String))),
            child:Container(decoration:BoxDecoration(color:Color(cat['color'] as int).withOpacity(0.3),borderRadius:BorderRadius.circular(20),border:Border.all(color:Color(cat['color'] as int))),
              child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(cat['icon'] as String,style:const TextStyle(fontSize:50)),Text(cat['name'] as String,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:18)),Text('${cat['count']} صور')]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget{
  final String category,title;
  const CategoryScreen({super.key,required this.category,required this.title});
  List<String> getImgs(){
    int n=0;
    if(category=='nature') n=9;
    if(category=='animals') n=17;
    if(category=='persons') n=14;
    if(category=='cars') n=5;
    return List.generate(n,(i)=>'assets/$category/${i+1}.jpg');
  }
  @override Widget build(BuildContext context){
    final imgs=getImgs();
    return Scaffold(
      appBar:AppBar(title:Text('$title - ${imgs.length}')),
      body:GridView.builder(
        padding:const EdgeInsets.all(10),
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:0.6),
        itemCount:imgs.length,
        itemBuilder:(c,i)=>GestureDetector(
          onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>ViewScreen(path:imgs[i]))),
          child:ClipRRect(borderRadius:BorderRadius.circular(15),child:Image.asset(imgs[i],fit:BoxFit.cover)),
        ),
      ),
    );
  }
}

class ViewScreen extends StatefulWidget{
  final String path;
  const ViewScreen({super.key,required this.path});
  @override State<ViewScreen> createState()=>_ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen>{
  bool load=false;
  Future<void> setWall(int type) async{
    setState(()=>load=true);
    try{
      final data=await rootBundle.load(widget.path);
      final dir=await getTemporaryDirectory();
      final file=File('${dir.path}/wall.jpg');
      await file.writeAsBytes(data.buffer.asUint8List());
      await WallpaperManagerFlutter().setwallpaperfromFile(file,type);
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم ✅')));
    }catch(e){ if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('$e'))); }
    setState(()=>load=false);
  }
  @override Widget build(BuildContext context){
    return Scaffold(
      body:Stack(children:[
        SizedBox.expand(child:Image.asset(widget.path,fit:BoxFit.cover)),
        Positioned(top:40,left:15,child:IconButton(icon:const Icon(Icons.arrow_back,size:30),onPressed:()=>Navigator.pop(context))),
        if(load) const Center(child:CircularProgressIndicator()),
        Positioned(bottom:30,left:15,right:15,child:Row(children:[
          Expanded(child:ElevatedButton(onPressed:()=>setWall(1),child:const Text('الرئيسية'))),
          const SizedBox(width:8),
          Expanded(child:ElevatedButton(onPressed:()=>setWall(2),child:const Text('القفل'))),
          const SizedBox(width:8),
          Expanded(child:ElevatedButton(onPressed:()=>setWall(3),child:const Text('الكل'))),
        ])),
      ]),
    );
  }
}
