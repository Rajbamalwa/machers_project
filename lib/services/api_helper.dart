import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class ApiHelper {
  Xml2Json xml2json = Xml2Json();

  //All Get type request will handle here
  Future<void> getTypeGet(BuildContext context, String url) async {
    var client = http.Client();
    var jsonMap;
    try {
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // xml2json.parse(response.body);
        // var jsonString = xml2json.toParker();
        jsonMap = json.decode(response.body);
        return jsonMap;
      } else {}
    } on SocketException {
      print("error");
      throw ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Check Internet'),
      ));
    } catch (Exception) {
      return jsonMap;
    }
  }
}
