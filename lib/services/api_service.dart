import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final Dio _authDio = Dio();

  ApiService() {
    _dio.options = BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
    _authDio.options = BaseOptions(
      baseUrl: "https://dummyjson.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _authDio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': response.data['accessToken'] ??
              response.data['token'] ??
              'dummy_token',
          'userId': response.data['id'] ?? response.data['userId'] ?? 1,
          'user': response.data,
        };
      }

      return {
        'success': false,
        'error': 'Invalid status code: ${response.statusCode}',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.message ?? e.toString(),
        'statusCode': e.response?.statusCode,
        'responseData': e.response?.data,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<List<dynamic>> getPosts() async {
    try {
      final response = await _dio.get('/posts?_limit=10');
      if (response.statusCode == 200) {
        return response.data ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getComments(int postId) async {
    try {
      final response = await _dio.get('/posts/$postId/comments');
      if (response.statusCode == 200) {
        return response.data ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getUser(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      if (response.statusCode == 200) {
        return response.data ?? {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<List<dynamic>> getUserPosts(int userId) async {
    try {
      final response = await _dio.get('/posts?userId=$userId');
      if (response.statusCode == 200) {
        return response.data ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> searchPosts(String query) async {
    try {
      final allPosts = await getPosts();
      final filtered = allPosts.where((post) {
        final title = post['title']?.toString().toLowerCase() ?? '';
        final body = post['body']?.toString().toLowerCase() ?? '';
        return title.contains(query.toLowerCase()) ||
            body.contains(query.toLowerCase());
      }).toList();
      return filtered;
    } catch (e) {
      return [];
    }
  }
}
