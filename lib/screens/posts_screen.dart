import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';
import '../services/favourites_service.dart';
import 'favourites_screen.dart';

class PostsScreen extends StatefulWidget {

  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {

  final PostService _service = PostService();

  final FavoritesService _favoritesService =
      FavoritesService();

  late Future<List<Post>> _postsFuture;

  @override
  void initState() {

    super.initState();

    _postsFuture = _service.getPosts();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('Posts'),

        actions: [

          IconButton(

            icon: const Icon(Icons.star),

            tooltip: 'Favorites',

            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FavoritesScreen(),
                ),
              );

            },
          ),

        ],
      ),

      body: FutureBuilder<List<Post>>(

        future: _postsFuture,

        builder: (context, snapshot) {

          // Loading state
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }

          // Error state
          else if (snapshot.hasError) {

            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );

          }

          // Data state
          else if (snapshot.hasData) {

            return RefreshIndicator(

              onRefresh: () async {

                setState(() {

                  _postsFuture = _service.getPosts();

                });

                await _postsFuture;

              },

              child: ValueListenableBuilder(

                valueListenable:
                    Hive.box<Post>('favoritesBox').listenable(),

                builder: (context, box, child) {

                  return ListView.builder(

                    physics:
                        const AlwaysScrollableScrollPhysics(),

                    itemCount: snapshot.data!.length,

                    itemBuilder: (context, index) {

                      Post post = snapshot.data![index];

                      bool isFavorite =
                          _favoritesService.isFavorite(post.id);

                      return Card(

                        margin: const EdgeInsets.all(8),

                        child: ListTile(

                          leading: CircleAvatar(
                            child: Text(
                              post.id.toString(),
                            ),
                          ),

                          title: Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            post.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          trailing: IconButton(

                            icon: Icon(
                              isFavorite
                                  ? Icons.star
                                  : Icons.star_border,

                              color: isFavorite
                                  ? Colors.amber
                                  : null,
                            ),

                            onPressed: () async {

                              await _favoritesService
                                  .toggleFavorite(post);

                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();

        },
      ),
    );
  }
}