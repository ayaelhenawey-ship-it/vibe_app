import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';

class FeedProvider with ChangeNotifier {
  List<PostModel> _posts = [];
  List<PostModel> _filteredPosts = [];
  bool _isLoading = false;
  Map<int, List<CommentModel>> _comments = {};

  List<PostModel> get posts => _filteredPosts.isEmpty ? _posts : _filteredPosts;
  bool get isLoading => _isLoading;
  
  List<CommentModel> getComments(int postId) => _comments[postId] ?? [];

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<dynamic> data = await ApiService().getPosts();
      _posts = data.map((post) => PostModel.fromJson(post)).toList();
    } catch (e) {
      _posts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchComments(int postId) async {
    try {
      final List<dynamic> data = await ApiService().getComments(postId);
      _comments[postId] = data.map((comment) => CommentModel.fromJson(comment)).toList();
      notifyListeners();
    } catch (e) {
      _comments[postId] = [];
    }
  }

  void toggleLike(int postId) {
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

  Future<void> searchPosts(String query) async {
    if (query.isEmpty) {
      _filteredPosts = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    try {
      final List<dynamic> data = await ApiService().searchPosts(query);
      _filteredPosts = data.map((post) => PostModel.fromJson(post)).toList();
    } catch (e) {
      _filteredPosts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _filteredPosts = [];
    notifyListeners();
  }
}