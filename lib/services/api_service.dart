import 'package:dio/dio.dart';
import '../models/form_field_model.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl =
      'http://team.dev.helpabode.com:54292/api/wempro/flutter-dev/coding-test-2025';

  ApiService() : _dio = Dio();

  Future<List<FormFieldModel>> getFormFields() async {
    try {
      final response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('json_response') &&
            jsonResponse['json_response'] is Map<String, dynamic> &&
            jsonResponse['json_response'].containsKey('attributes')) {
          final List<dynamic> attributes =
              jsonResponse['json_response']['attributes'];
          return attributes
              .map((json) => FormFieldModel(
                    type: json['type'] as String,
                    label: json['title'] as String,
                    required:
                        true, // Since it's not specified in JSON, we'll default to true
                    options:
                        (json['options'] as List<dynamic>?)?.cast<String>(),
                  ))
              .toList();
        }
        throw Exception('Invalid response format');
      }
      throw Exception('Failed to load form fields');
    } catch (e) {
      throw Exception('Error fetching form fields: $e');
    }
  }
}
