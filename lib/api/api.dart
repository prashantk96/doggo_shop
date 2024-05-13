import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Api {
  Future<String> fetchRandomDogImage() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      log(data['message']);
      return data['message'];
    } else {
      log('could not reach');
      return '';
    }
  }
}
