class FormFieldModel {
  final String type;
  final String label;
  final bool required;
  final String? placeholder;
  final List<String>? options;
  final String? selected;
  final String? value;
  final String? errorMessage;

  FormFieldModel({
    required this.type,
    required this.label,
    required this.required,
    this.placeholder,
    this.options,
    this.selected,
    this.value,
    this.errorMessage,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      type: json['type'] as String,
      label: json['title'] as String,
      required: true, // Default to true since it's not in the JSON
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': label,
      'options': options,
    };
  }
}

enum FieldType {
  text,
  radio,
  dropdown,
  checkbox,
  textfield,
}

extension FieldTypeExtension on String {
  FieldType toFieldType() {
    switch (toLowerCase()) {
      case 'radio':
        return FieldType.radio;
      case 'dropdown':
        return FieldType.dropdown;
      case 'checkbox':
        return FieldType.checkbox;
      case 'textfield':
        return FieldType.textfield;
      default:
        return FieldType.text;
    }
  }
}
