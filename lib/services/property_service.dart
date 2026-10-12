
import 'package:dio/dio.dart';
import '../models/property.dart';
import '../models/property_media.dart';
import 'api_client.dart';

class PropertyService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Property>> getAllProperties() async {
    final response = await _dio.get('/api/properties');
    return (response.data as List)
        .map((e) => Property.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<Property>> getMyProperties() async {
    final response = await _dio.get('/api/properties/my');
    return (response.data as List)
        .map((e) => Property.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<Property> getProperty(int id) async {
    final response = await _dio.get('/api/properties/$id');
    return Property.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<Property> createProperty(Property property) async {
    final response = await _dio.post(
      '/api/properties/create',
      data: property.toJson(),
    );

    return Property.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<Property> updateProperty(Property property) async {
    if (property.id == null) {
      throw ArgumentError('Property ID is required');
    }

    final response = await _dio.put(
      '/api/properties/${property.id}',
      data: property.toJson(),
    );

    return Property.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> deleteProperty(int id) async {
    await _dio.delete('/api/properties/$id');
  }

  Future<List<PropertyMedia>> getMedia(int propertyId) async {
    final response =
        await _dio.get('/api/properties/$propertyId/media');

    return (response.data as List)
        .map((e) => PropertyMedia.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<PropertyMedia> addMedia(
    int propertyId,
    PropertyMedia media,
  ) async {
    final response = await _dio.post(
      '/api/properties/$propertyId/media',
      data: media.toJson(),
    );

    return PropertyMedia.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> deleteMedia(int mediaId) async {
    await _dio.delete('/api/properties/media/$mediaId');
  }
}
