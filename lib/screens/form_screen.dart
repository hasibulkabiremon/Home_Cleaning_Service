import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/form_field_model.dart';
import '../providers/form_provider.dart';
import 'summary_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  void initState() {
    super.initState();
    // Load form fields when the screen is initialized
    Future.microtask(
      () => context.read<FormProvider>().loadFormFields(),
    );
  }

  Widget _buildFieldTitle(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        if (value == null || value.isEmpty)
          const Text(
            'This field is required',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        const SizedBox(height: 8),
      ],
    );
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
        title: const Text('Input Types', style: TextStyle(color: Colors.white)),
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...fields
                    .map((field) => _buildFormField(context, field))
                    .toList(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFA3),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      if (formProvider.validateForm()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SummaryScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Submit',
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

  Widget _buildFormField(BuildContext context, FormFieldModel field) {
    final formProvider = context.watch<FormProvider>();
    final formState = formProvider.formState;

    switch (field.type.toFieldType()) {
      case FieldType.radio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle(field.label, formState[field.label]),
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

      case FieldType.dropdown:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle(field.label, formState[field.label]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton<String>(
                value: formState[field.label] ?? field.selected,
                items: field.options?.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  formProvider.updateField(field.label, value);
                },
                isExpanded: true,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );

      case FieldType.checkbox:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle(field.label, formState[field.label]),
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

      case FieldType.textfield:
      case FieldType.text:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle(field.label, formState[field.label]),
            TextField(
              decoration: InputDecoration(
                hintText: field.placeholder,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00FFA3)),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                formProvider.updateField(field.label, value);
              },
            ),
            const SizedBox(height: 16),
          ],
        );
    }
  }
}
