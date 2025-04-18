import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (value == null || value.isEmpty)
          Text(
            'This field is required',
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
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
        title: Text(
          'Input Types',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
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
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
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
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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
    final fieldIndex = formProvider.formFields!.indexOf(field) + 1;

    Widget buildFieldContent() {
      switch (field.type.toFieldType()) {
        case FieldType.radio:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldTitle(
                  '$fieldIndex. ${field.label}', formState[field.label]),
              ...?field.options?.map(
                (option) => RadioListTile<String>(
                  title: Text(
                    option,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: option,
                  groupValue: formState[field.label],
                  onChanged: (value) {
                    formProvider.updateField(field.label, value);
                  },
                  activeColor: const Color(0xFF00FFA3),
                ),
              ),
            ],
          );

        case FieldType.dropdown:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldTitle(
                  '$fieldIndex. ${field.label}', formState[field.label]),
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
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    formProvider.updateField(field.label, value);
                  },
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  underline: const SizedBox(),
                ),
              ),
            ],
          );

        case FieldType.checkbox:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldTitle(
                  '$fieldIndex. ${field.label}', formState[field.label]),
              ...?field.options?.map(
                (option) => RadioListTile<String>(
                  title: Text(
                    option,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: option,
                  groupValue: formState[field.label],
                  onChanged: (value) {
                    formProvider.updateField(field.label, value);
                  },
                  activeColor: const Color(0xFF00FFA3),
                ),
              ),
            ],
          );

        case FieldType.textfield:
        case FieldType.text:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldTitle(
                  '$fieldIndex. ${field.label}', formState[field.label]),
              TextField(
                decoration: InputDecoration(
                  hintText: field.placeholder,
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00FFA3)),
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                onChanged: (value) {
                  formProvider.updateField(field.label, value);
                },
              ),
            ],
          );
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: buildFieldContent(),
    );
  }
}
