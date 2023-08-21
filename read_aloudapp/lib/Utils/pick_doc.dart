import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';

Future<String?> pickDocument() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    allowCompression: true,
  );

  if (result != null) {
    final String? filePath = result.files.single.path;
    return filePath;
  } else {
    return '';
  }
}
