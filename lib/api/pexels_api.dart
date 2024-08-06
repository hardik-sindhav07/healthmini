// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:healthmini/models/pexels_model.dart';

class PexelsApi {

  Future searchPhotos(String searchQuery) async {
    var apiKey = dotenv.env['PEXELS_API_KEY'];

    final response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$searchQuery&per_page=5"),
        headers: {"Authorization": apiKey??""});
    var resData = json.decode(response.body);
    print(resData);
    try {
      if (resData != '') {
        return PexelsModel.fromJson(resData);
      } else {
        throw Exception(resData['message']);
      }
    } catch (e) {
      throw Exception(resData['message']);
    }
  }

}