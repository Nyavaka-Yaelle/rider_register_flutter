import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_register/utility/endpoints.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  Dio _dio = Dio();

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio();
    _dio.options.headers["Content-Type"] = "application/json";
  }

  Future<Response<dynamic>?> getData() async {
    try {
      Response response = await _dio.get(Endpoints.post);
      return response;
    } on DioError catch (e) {
      return handleError(e);
    }
  }

  String getMarkerName(List<Map<String, dynamic>> items) {
    final Map<String, dynamic> marker = items.firstWhere(
        (item) => item['types'].contains('establishment') ?? false,
        orElse: () => items.firstWhere(
            (item) => item['types'].contains('neighborhood') ?? false,
            orElse: () => items.firstWhere(
                (item) => item['types'].contains('locality') ?? false,
                orElse: () => items.firstWhere(
                      (item) => item['types'].contains('routes') ?? false,
                    ))));
    return marker != null ? marker['name'] : null;
  }

  //get name of city pinged on map
  Future<String> getFormattedAddresses(LatLng position) async {
    double latitude = position.latitude;
    double longitude = position.longitude;
    Dio dio = Dio();
    Response response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=10&rankby&key=AIzaSyDy2Or3OuVND8ITBX5R_BEHAvkfl1z9sog');
    print("we are");
    if (response.statusCode == 200) {
      //get one formated adress

      List<dynamic> results = response.data['results'];
      String markerName =
          getMarkerName(List<Map<String, dynamic>>.from(results));

      // extract the formatted address of the first result
      return markerName;
    } else {
      throw Exception('Error getting formatted addresses');
    }
  }

  Response<dynamic>? handleError(DioError e) {
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 400:
          return e.response;
        case 401:
        case 403:
          debugPrint("// handle unauthorized or forbidden error");
          break;
        default:
          return e.response;
      }
    } else {
      debugPrint("// handle network error");
    }
    return null;
  }
}
