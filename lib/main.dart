import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/post_model.dart';
import 'screens/posts_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Register Post adapter
  Hive.registerAdapter(PostAdapter());

  // 3. Open posts box
  await Hive.openBox<Post>('postsBox');

  // 4. Open favorites box
  await Hive.openBox<Post>('favoritesBox');

  // 5. Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostsScreen(),
    );
  }
}