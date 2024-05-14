import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Api {
  // fetchRandomDogImage sends get request to server
  // server returns message and status
  // we check if status code is success that is 200
  // and decode response body and stored it in data var which is of type Map
  // and then we return message from that stored data

  Future<String> fetchRandomDogImage() async {
    try {
      final response =
          await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log(data['message']);
        return data['message'];
      } else {
        log('could not fetch image');
        return '';
      }
    } catch (error) {
      log(error.toString());
      return '';
    }
  }
}
