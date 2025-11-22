import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationInfo {
  LocationInfo({required this.position, required this.label});
  final Position position;
  final String label;
}

class LocationService {
  Future<LocationInfo?> getLocation() async {
    final pos = await _getCurrentPosition();
    if (pos == null) return null;

    String label =
        'Lat: ${pos.latitude.toStringAsFixed(3)}, Lng: ${pos.longitude.toStringAsFixed(3)}';
    try {
      final placemark = await _firstPlacemark(pos);
      if (placemark != null) {
        label = _formatPlacemark(placemark, pos);
      } else {
        label = await _reverseFromOsm(pos) ??
            'Lat: ${pos.latitude.toStringAsFixed(3)}, Lng: ${pos.longitude.toStringAsFixed(3)}';
      }
    } catch (_) {
      label = 'Lat: ${pos.latitude.toStringAsFixed(3)}, Lng: ${pos.longitude.toStringAsFixed(3)}';
    }

    return LocationInfo(position: pos, label: label);
  }

  Future<Placemark?> _firstPlacemark(Position pos) async {
    final locales = <String?>[null, 'es_MX', 'es', 'en'];
    for (final locale in locales) {
      try {
        final list = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
          localeIdentifier: locale,
        );
        if (list.isNotEmpty) return list.first;
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  String _formatPlacemark(Placemark p, Position pos) {
    final city = (p.locality?.isNotEmpty ?? false)
        ? p.locality
        : (p.subAdministrativeArea?.isNotEmpty ?? false)
            ? p.subAdministrativeArea
            : null;
    final area =
        (p.administrativeArea?.isNotEmpty ?? false) ? p.administrativeArea : null;
    final street = (p.thoroughfare?.isNotEmpty ?? false)
        ? [p.thoroughfare, p.subThoroughfare]
            .where((e) => e != null && e!.isNotEmpty)
            .join(' ')
        : null;

    final parts = [
      if (street != null && street.isNotEmpty) street,
      if (city != null && city.isNotEmpty) city,
      if (area != null && area.isNotEmpty) area,
      if (p.country?.isNotEmpty == true) p.country,
    ].whereType<String>().where((e) => e.isNotEmpty).toList();

    if (parts.isEmpty) {
      return 'Ubicación aproximada';
    }
    return parts.join(' · ');
  }

  Future<String?> _reverseFromOsm(Position pos) async {
    final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${pos.latitude}&lon=${pos.longitude}');
    final res = await http.get(uri, headers: {
      'User-Agent': 'marketplace-app/1.0',
    });
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final address = data['address'] as Map<String, dynamic>?;
    if (address == null) return data['display_name'] as String?;

    final streetParts = [
      address['road'],
      address['house_number'],
    ].whereType<String>().where((e) => e.isNotEmpty).join(' ');
    final city = address['city'] ??
        address['town'] ??
        address['village'] ??
        address['municipality'];
    final state = address['state'];
    final country = address['country'];

    final parts = [
      if (streetParts.isNotEmpty) streetParts,
      if (city != null) city,
      if (state != null) state,
      if (country != null) country,
    ].whereType<String>().where((e) => e.isNotEmpty).toList();

    if (parts.isEmpty) return data['display_name'] as String?;
    return parts.join(' · ');
  }

  Future<Position?> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }
}
