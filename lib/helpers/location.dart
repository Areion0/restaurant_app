import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/helpers/http_helper.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class LocationHelper {
  static Future<String> getCurrentAddress({required String token}) async {
    try {
      final position = await determinePosition();


      final String address = await _determineAddress(position, token: token);

      Logger().i("Current address: $address");

      return address;
    } catch (e) {
      return "";
    }
  }

  static Future<String> _determineAddress(Position position, {required String token}) async {
    try {
      String lat = position.latitude.toString();
      String lng = position.longitude.toString();

      String query = "?lat=$lat&lng=$lng";

      return await HttpHelper.get("/reverse-geocode$query", token: token).then((response) => response["results"]);
    } catch (e) {
      Logger().e("Failed to get address: $e");
      return "";
    }
  }
}
