import 'package:flutter/foundation.dart';
import '../models/form_field_model.dart';
import '../services/api_service.dart';

class FormProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<FormFieldModel>? _formFields;
  Map<String, dynamic> _formState = {};
  String? _error;

  List<FormFieldModel>? get formFields => _formFields;
  Map<String, dynamic> get formState => _formState;
  String? get error => _error;
  bool get isLoading => _formFields == null && _error == null;

  Future<void> loadFormFields() async {
    try {
      _formFields = await _apiService.getFormFields();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void updateField(String fieldName, dynamic value) {
    _formState = {..._formState, fieldName: value};
    notifyListeners();
  }

  bool validateField(FormFieldModel field) {
    if (field.required &&
        (_formState[field.label] == null ||
            _formState[field.label].toString().isEmpty)) {
      return false;
    }
    return true;
  }

  bool validateForm() {
    if (_formFields == null) return false;
    return _formFields!.every((field) => validateField(field));
  }

  void clearForm() {
    _formState = {};
    notifyListeners();
  }
}
