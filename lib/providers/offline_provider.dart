import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/post_model.dart';

class OfflineProvider with ChangeNotifier {
  List<PostModel> _savedPosts = [];

  List<PostModel> get savedPosts => _savedPosts;

  OfflineProvider() {
    _loadSavedPosts();
  }

  Future<void> _loadSavedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_posts') ?? [];
    _savedPosts = saved
        .map((post) => PostModel.fromJson(jsonDecode(post)))
        .toList();
    notifyListeners();
  }

  Future<void> savePost(PostModel post) async {
    if (!_savedPosts.any((p) => p.id == post.id)) {
      _savedPosts.add(post);
      await _persistSavedPosts();
      notifyListeners();
    }
  }

  Future<void> removePost(int postId) async {
    _savedPosts.removeWhere((p) => p.id == postId);
    await _persistSavedPosts();
    notifyListeners();
  }

  Future<void> _persistSavedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = _savedPosts
        .map((post) => jsonEncode({
          'id': post.id,
          'title': post.title,
          'body': post.body,
          'userId': post.userId,
          'isLiked': post.isLiked,
          'likeCount': post.likeCount,
        }))
        .toList();
    await prefs.setStringList('saved_posts', saved);
  }

  bool isPostSaved(int postId) {
    return _savedPosts.any((p) => p.id == postId);
  }

  void clearAllSavedPosts() async {
    _savedPosts.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_posts');
    notifyListeners();
  }
}
