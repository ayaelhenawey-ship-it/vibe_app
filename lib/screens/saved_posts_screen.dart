import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/offline_provider.dart';
import 'post_detail_screen.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offlineProvider = Provider.of<OfflineProvider>(context);
    final savedPosts = offlineProvider.savedPosts;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SAVED POSTS',
          style: TextStyle(color: Color(0xFFC9A96E), letterSpacing: 2),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFC9A96E)),
        actions: [
          if (savedPosts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Color(0xFFC9A96E)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1A2A4E),
                    title: const Text(
                      'Clear All',
                      style: TextStyle(color: Color(0xFFE8D5A3)),
                    ),
                    content: const Text(
                      'Are you sure you want to delete all saved posts?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel',
                            style:
                                TextStyle(color: Color(0xFFC9A96E))),
                      ),
                      TextButton(
                        onPressed: () {
                          offlineProvider.clearAllSavedPosts();
                          Navigator.pop(context);
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: savedPosts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.white30,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved posts',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: savedPosts.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final post = savedPosts[index];
                return Card(
                  color: const Color(0xFF1A2A4E),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFE8D5A3),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    offlineProvider.removePost(post.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
