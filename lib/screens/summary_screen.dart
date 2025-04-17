import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  IconData _getIconForField(String fieldType) {
    switch (fieldType.toLowerCase()) {
      case 'radio':
        return Icons.radio_button_checked;
      case 'dropdown':
        return Icons.arrow_drop_down_circle;
      case 'checkbox':
        return Icons.check_box;
      case 'textfield':
        return Icons.text_fields;
      default:
        return Icons.short_text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text('Selected Input', style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            Text(
                '${context.watch<FormProvider>().formFields?.length ?? 0} items',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
      body: Consumer<FormProvider>(
        builder: (context, formProvider, child) {
          if (formProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (formProvider.error != null) {
            return Center(
              child: Text(
                'Error: ${formProvider.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final fields = formProvider.formFields!;
          final formState = formProvider.formState;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...fields.map((field) {
                  if (field.type.toLowerCase() == 'checkbox') {
                    // Handle checkbox fields
                    final selectedOptions = field.options
                        ?.where((option) =>
                            formState['${field.label}_$option'] == true)
                        .toList();
                    if (selectedOptions == null || selectedOptions.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getIconForField(field.type),
                            color: const Color(0xFF00FFA3),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedOptions.join(', '),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Handle other field types
                    final value = formState[field.label];
                    if (value == null || value.toString().isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getIconForField(field.type),
                            color: const Color(0xFF00FFA3),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            field.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            value.toString(),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }).toList(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFA3),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
