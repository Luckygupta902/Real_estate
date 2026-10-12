import 'package:dio/dio.dart';
import '../models/lead.dart';
import '../models/lead_activity.dart';
import 'api_client.dart';

class LeadService {
  final Dio _dio = ApiClient.instance.dio;

  List<Lead> _leads(dynamic data) {
    return (data as List)
        .map((e) => Lead.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Lead _lead(dynamic data) {
    return Lead.fromJson(Map<String, dynamic>.from(data as Map));
  }

  // The backend returns {"error": "..."} for bad requests / not found.
  Future<T> _call<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['error'] != null) {
        throw Exception(data['error'].toString());
      }

      rethrow;
    }
  }

  // POST /api/leads
  Future<Lead> createLead(Lead lead) {
    return _call(() async {
      final response = await _dio.post('/api/leads', data: lead.toJson());
      return _lead(response.data);
    });
  }

  // GET /api/leads
  Future<List<Lead>> getAllLeads() async {
    final response = await _dio.get('/api/leads');
    return _leads(response.data);
  }

  // GET /api/leads/{id}
  Future<Lead> getLeadById(int id) {
    return _call(() async {
      final response = await _dio.get('/api/leads/$id');
      return _lead(response.data);
    });
  }

  // GET /api/leads/customer/{customerId}
  Future<List<Lead>> getLeadsByCustomer(int customerId) async {
    final response = await _dio.get('/api/leads/customer/$customerId');
    return _leads(response.data);
  }

  // GET /api/leads/property/{propertyId}
  Future<List<Lead>> getLeadsByProperty(int propertyId) async {
    final response = await _dio.get('/api/leads/property/$propertyId');
    return _leads(response.data);
  }

  // GET /api/leads/employee/{employeeId}
  Future<List<Lead>> getLeadsByEmployee(int employeeId) async {
    final response = await _dio.get('/api/leads/employee/$employeeId');
    return _leads(response.data);
  }

  // PUT /api/leads/{id}
  Future<Lead> updateLead(int id, Lead lead) {
    return _call(() async {
      final response = await _dio.put(
        '/api/leads/$id',
        data: lead.toJson(),
      );
      return _lead(response.data);
    });
  }

  // PATCH /api/leads/{id}/assign
  Future<Lead> assignLead(
    int id,
    int employeeId, {
    int? actingUserId,
  }) {
    return _call(() async {
      final response = await _dio.patch(
        '/api/leads/$id/assign',
        data: {
          'employeeId': employeeId,
          if (actingUserId != null) 'actingUserId': actingUserId,
        },
      );
      return _lead(response.data);
    });
  }

  // PATCH /api/leads/{id}/status
  // The backend reads this body as Map<String, String>.
  Future<Lead> updateLeadStatus(
    int id,
    String status, {
    int? actingUserId,
  }) {
    return _call(() async {
      final response = await _dio.patch(
        '/api/leads/$id/status',
        data: {
          'status': status,
          if (actingUserId != null) 'actingUserId': actingUserId.toString(),
        },
      );
      return _lead(response.data);
    });
  }

  // GET /api/leads/{id}/activities
  Future<List<LeadActivity>> getLeadActivities(int id) {
    return _call(() async {
      final response = await _dio.get('/api/leads/$id/activities');

      return (response.data as List)
          .map((e) => LeadActivity.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList();
    });
  }

  // GET /api/leads/activities/all
  Future<List<LeadActivity>> getAllActivities() async {
    final response = await _dio.get('/api/leads/activities/all');

    return (response.data as List)
        .map((e) => LeadActivity.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
