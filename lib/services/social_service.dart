import 'package:dio/dio.dart';
import '../models/comment.dart';
import '../models/like.dart';
import 'api_client.dart';

class SocialService {
  final Dio _dio = ApiClient.instance.dio;

  // ---------------- LIKES ----------------

  // POST /api/properties/{propertyId}/likes
  Future<Like> likeProperty(int propertyId) async {
    final response = await _dio.post(
      '/api/properties/$propertyId/likes',
    );

    return Like.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  // DELETE /api/properties/{propertyId}/likes
  Future<void> unlikeProperty(int propertyId) async {
    await _dio.delete('/api/properties/$propertyId/likes');
  }

  // GET /api/likes/my
  Future<List<Like>> getMyLikes() async {
    final response = await _dio.get('/api/likes/my');

    return (response.data as List)
        .map((e) => Like.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // GET /api/properties/{propertyId}/likes
  Future<List<Like>> getPropertyLikes(int propertyId) async {
    final response = await _dio.get(
      '/api/properties/$propertyId/likes',
    );

    return (response.data as List)
        .map((e) => Like.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // GET /api/properties/{propertyId}/likes/count
  Future<int> getLikeCount(int propertyId) async {
    final response = await _dio.get(
      '/api/properties/$propertyId/likes/count',
    );

    return (response.data as num).toInt();
  }

  // Whether the logged-in user has liked this property.
  Future<bool> isLikedByMe(int propertyId) async {
    final likes = await getMyLikes();

    return likes.any((l) => l.propertyId == propertyId);
  }

  // ---------------- COMMENTS ----------------

  // GET /api/properties/{propertyId}/comments
  Future<List<Comment>> getComments(int propertyId) async {
    final response = await _dio.get(
      '/api/properties/$propertyId/comments',
    );

    return (response.data as List)
        .map((e) => Comment.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // GET /api/comments/my
  Future<List<Comment>> getMyComments() async {
    final response = await _dio.get('/api/comments/my');

    return (response.data as List)
        .map((e) => Comment.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // POST /api/properties/{propertyId}/comments
  Future<Comment> addComment(
    int propertyId,
    String commentText,
  ) async {
    final response = await _dio.post(
      '/api/properties/$propertyId/comments',
      data: {'commentText': commentText},
    );

    return Comment.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  // PUT /api/comments/{commentId}
  Future<Comment> updateComment(
    int commentId,
    String commentText,
  ) async {
    final response = await _dio.put(
      '/api/comments/$commentId',
      data: {'commentText': commentText},
    );

    return Comment.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  // DELETE /api/comments/{commentId}
  Future<void> deleteComment(int commentId) async {
    await _dio.delete('/api/comments/$commentId');
  }
}
