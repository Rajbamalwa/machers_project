import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:machers_task/constants/api_constants.dart';

import 'api_helper.dart';

class ApiFunctions {
  getAllNews(
    BuildContext context,
  ) async {
    String url = base_api + api_key;
    var response = await ApiHelper().getTypeGet(context, url);
    log(response.toString());
    return response;
  }
}
