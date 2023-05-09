import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../MapsModel/auto_complete_result.dart';

class MapServices {
  final String key = 'APIKEY';
  final String types = 'geocode';

  Future<List<AutoCompleteResult>> searchPlaces(String searchInput) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['predictions'] as List;

    return results.map((e) => AutoCompleteResult.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getPlace(String? input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points'])
    };

    return results;
  }

  Future<dynamic> getPlaceDetails(LatLng coords, int radius) async {
    var lat = coords.latitude;
    var lng = coords.longitude;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=$lat,$lng&radius=$radius&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);
    return json;
  }

  Future<dynamic> getMorePlaceDetails(String token) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&pagetoken=$token&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }

  Future<Map<String, dynamic>> getDirectionsFromLatLng(
      LatLng origin, LatLng destination, String apiKey) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': LatLng(json['routes'][0]['bounds']['northeast']['lat'],
          json['routes'][0]['bounds']['northeast']['lng']),
      'bounds_sw': LatLng(json['routes'][0]['bounds']['southwest']['lat'],
          json['routes'][0]['bounds']['southwest']['lng']),
      'start_location': LatLng(
          json['routes'][0]['legs'][0]['start_location']['lat'],
          json['routes'][0]['legs'][0]['start_location']['lng']),
      'end_location': LatLng(
          json['routes'][0]['legs'][0]['end_location']['lat'],
          json['routes'][0]['legs'][0]['end_location']['lng']),
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': decodeEncodedPolyline(
          json['routes'][0]['overview_polyline']['points'])
    };

    return results;
  }
}

List<LatLng> decodeEncodedPolyline(String encodedString) {
  List<PointLatLng> decoded = PolylinePoints().decodePolyline(encodedString);
  return decoded
      .map((point) => LatLng(point.latitude, point.longitude))
      .toList();
}

Future<dynamic> getNearbyPlaces(
    double lat, double lng, int radius, String type, String apiKey) async {
  final String url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=$type&key=$apiKey';

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var results = jsonResponse['results'];
    return results;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return null;
  }
}

Future<Map<String, dynamic>> getDirectionsFromLatLng(
    LatLng origin, LatLng destination, String apiKey) async {
  final String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

  var response = await http.get(Uri.parse(url));

  var json = convert.jsonDecode(response.body);

  var results = {
    'bounds_ne': LatLng(json['routes'][0]['bounds']['northeast']['lat'],
        json['routes'][0]['bounds']['northeast']['lng']),
    'bounds_sw': LatLng(json['routes'][0]['bounds']['southwest']['lat'],
        json['routes'][0]['bounds']['southwest']['lng']),
    'start_location': LatLng(
        json['routes'][0]['legs'][0]['start_location']['lat'],
        json['routes'][0]['legs'][0]['start_location']['lng']),
    'end_location': LatLng(json['routes'][0]['legs'][0]['end_location']['lat'],
        json['routes'][0]['legs'][0]['end_location']['lng']),
    'polyline': json['routes'][0]['overview_polyline']['points'],
    'polyline_decoded':
        decodeEncodedPolyline(json['routes'][0]['overview_polyline']['points'])
  };

  return results;
}

List<LatLng> decodeEncodedPolyline(String encodedString) {
  List<PointLatLng> decoded = PolylinePoints().decodePolyline(encodedString);
  return decoded
      .map((point) => LatLng(point.latitude, point.longitude))
      .toList();
}

Future<dynamic> getNearbyPlaces(
    double lat, double lng, int radius, String type, String apiKey) async {
  final String url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=$type&key=$apiKey';

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var results = jsonResponse['results'];
    return results;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return null;
  }
}
