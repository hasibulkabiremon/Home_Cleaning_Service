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

  void _showEditBottomSheet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Edit Input Types',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            leading: const SizedBox(), // Empty leading to remove back button
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: Consumer<FormProvider>(
            builder: (context, formProvider, child) {
              final fields = formProvider.formFields!;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...fields.map((field) =>
                              _buildFormField(context, field, formProvider)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FFA3),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(
      BuildContext context, dynamic field, FormProvider formProvider) {
    final formState = formProvider.formState;

    switch (field.type.toLowerCase()) {
      case 'radio':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            ...?field.options?.map(
              (option) => RadioListTile<String>(
                title:
                    Text(option, style: const TextStyle(color: Colors.white)),
                value: option,
                groupValue: formState[field.label],
                onChanged: (value) {
                  formProvider.updateField(field.label, value);
                },
                activeColor: const Color(0xFF00FFA3),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );

      case 'checkbox':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            ...?field.options?.map(
              (option) => CheckboxListTile(
                title:
                    Text(option, style: const TextStyle(color: Colors.white)),
                value: formState['${field.label}_$option'] ?? false,
                onChanged: (value) {
                  formProvider.updateField('${field.label}_$option', value);
                },
                activeColor: const Color(0xFF00FFA3),
                checkColor: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
          ],
        );

      case 'dropdown':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonFormField<String>(
                value: formState[field.label] as String?,
                items: field.options
                    ?.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  formProvider.updateField(field.label, value);
                },
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );

      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: formState[field.label]),
              onChanged: (value) {
                formProvider.updateField(field.label, value);
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00FFA3)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...fields.map((field) {
                  if (field.type.toLowerCase() == 'checkbox') {
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => _showEditBottomSheet(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Edit Response',
                      style: TextStyle(
                        color: Color(0xFF00FFA3),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFA3),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      context.read<FormProvider>().clearForm();
                      Navigator.pop(context);
                    },
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
