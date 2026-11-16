import 'package:hive/hive.dart';

import '../models/post_model.dart';

class FavoritesService {

  // Get the favorites box
  Box<Post> get _favoritesBox =>
      Hive.box<Post>('favoritesBox');

  // Check if a post is already a favorite
  bool isFavorite(int id) {

    return _favoritesBox.containsKey(id);

  }

  // Add or remove a favorite
  Future<void> toggleFavorite(Post post) async {

    if (isFavorite(post.id)) {

      // Remove from favorites
      await _favoritesBox.delete(post.id);

    } else {

      // Create a copy of the post
      Post copy = Post(
        id: post.id,
        title: post.title,
        body: post.body,
        userId: post.userId,
      );

      // Save using post id as the key
      await _favoritesBox.put(post.id, copy);

    }
  }

  // Get all favorite posts
  List<Post> getFavorites() {

    return _favoritesBox.values.toList();

  }
}