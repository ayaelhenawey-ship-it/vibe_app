import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class FeedProvider with ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<dynamic> data = await ApiService().getPosts();
      _posts = data.map((post) => PostModel.fromJson(post)).toList();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      if (_posts[index].isLiked) {
        _posts[index].likeCount++;
      } else {
        _posts[index].likeCount--;
      }
      notifyListeners();
    }
  }
}