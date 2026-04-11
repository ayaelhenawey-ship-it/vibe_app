import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/offline_provider.dart';
import 'post_detail_screen.dart';
import 'saved_posts_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<FeedProvider>(context, listen: false).fetchPosts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshFeed() async {
    await Provider.of<FeedProvider>(context, listen: false).fetchPosts();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feed Updated', style: TextStyle(color: Color(0xFFE8D5A3))),
        backgroundColor: Color(0xFF1A2A4E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSearch(String query) {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    if (query.isEmpty) {
      feedProvider.clearSearch();
      setState(() => _isSearching = false);
    } else {
      feedProvider.searchPosts(query);
      setState(() => _isSearching = true);
    }
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final offlineProvider = Provider.of<OfflineProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search posts...',
                  hintStyle: TextStyle(color: const Color(0xFFC9A96E).withValues(alpha: 0.5)),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFC9A96E)),
                    onPressed: () {
                      _searchController.clear();
                      _handleSearch('');
                      setState(() => _isSearching = false);
                    },
                  ),
                ),
                onChanged: _handleSearch,
              )
            : const Text(
                'VIBE FEED',
                style: TextStyle(color: Color(0xFFC9A96E), letterSpacing: 2),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFFC9A96E)),
              onPressed: () => setState(() => _isSearching = true),
            ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Color(0xFFC9A96E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedPostsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFC9A96E)),
            onPressed: _refreshFeed,
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFC9A96E)),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFC9A96E)),
            onPressed: _logout,
          ),
        ],
      ),
      body: feedProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFC9A96E)),
            )
          : RefreshIndicator(
              onRefresh: _refreshFeed,
              color: const Color(0xFFC9A96E),
              backgroundColor: const Color(0xFF1A2A4E),
              child: feedProvider.posts.isEmpty
                  ? Center(
                      child: Text(
                        _isSearching ? 'No posts found' : 'No posts available',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: feedProvider.posts.length,
                      itemBuilder: (context, index) {
                        final post = feedProvider.posts[index];
                        final isSaved = offlineProvider.isPostSaved(post.id);

                        return Card(
                          color: const Color(0xFF1A2A4E),
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              post.isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: post.isLiked
                                                  ? Colors.red
                                                  : const Color(0xFFC9A96E),
                                            ),
                                            onPressed: () =>
                                                feedProvider.toggleLike(post.id),
                                          ),
                                          Text(
                                            post.likeCount.toString(),
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              isSaved
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              color: isSaved
                                                  ? const Color(0xFFC9A96E)
                                                  : Colors.white54,
                                            ),
                                            onPressed: () {
                                              if (isSaved) {
                                                offlineProvider.removePost(post.id);
                                              } else {
                                                offlineProvider.savePost(post);
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.comment_outlined,
                                              color: Color(0xFFC9A96E),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostDetailScreen(post: post),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
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
            ),
    );
  }
}