import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> readJsonFile(String filePath) async {
  final file = File(filePath);
  final contents = await file.readAsString();
  final jsonData = jsonDecode(contents);
  return jsonData;
}
