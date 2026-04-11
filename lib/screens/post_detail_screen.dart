import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/feed_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FeedProvider>(context, listen: false).fetchComments(widget.post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final comments = feedProvider.getComments(widget.post.id);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFC9A96E)),
        title: const Text('POST DETAILS', style: TextStyle(color: Color(0xFFC9A96E))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post #${widget.post.id}',
              style: const TextStyle(
                color: Color(0xFFE8D5A3),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.post.title,
              style: const TextStyle(
                color: Color(0xFFE8D5A3),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.post.body,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Consumer<FeedProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.post.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.isLiked
                                ? Colors.red
                                : const Color(0xFFC9A96E),
                          ),
                          onPressed: () =>
                              provider.toggleLike(widget.post.id),
                        ),
                        Text(
                          widget.post.likeCount.toString(),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'COMMENTS',
              style: TextStyle(
                color: Color(0xFFC9A96E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            if (comments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No comments yet',
                  style: TextStyle(color: Colors.white70),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2A4E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.name,
                          style: const TextStyle(
                            color: Color(0xFFE8D5A3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.email,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          comment.body,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}