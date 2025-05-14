import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/data.dart';
import 'pet_repository_interface.dart';

class PetRepository implements PetRepositoryInterface {
  static const String _apiUrl = 'https://testdataadoption.vercel.app/getdata';
  static const String _cacheKey = 'pet_data';
  static const String _cacheTimestampKey = 'pet_data_timestamp';
  static const int _cacheExpirationMinutes = 1800; // 30 hours

  // Fetch pets with cache strategy
  Future<List<DataModel>> fetchPets() async {
    try {
      // Always try to get cached data first
      final cachedData = await _getCachedData();

      // If we have valid non-expired cache, use it
      if (cachedData != null) {
        print('Using valid cached data');
        return cachedData;
      }

      // If no valid cache, try to get expired cache as backup
      final expiredCache = await _getCachedData(ignoreExpiration: true);

      // Try network request
      try {
        print('Attempting network request');
        final networkData = await _fetchFromNetwork();
        return networkData;
      } catch (networkError) {
        print('Network request failed: $networkError');

        // If network fails but we have expired cache, use it
        if (expiredCache != null) {
          print('Using expired cached data due to network error');
          return expiredCache;
        }

        // If no cache at all, use fallback data
        print('Using fallback data as last resort');
        return _getFallbackData();
      }
    } catch (e) {
      print('Exception during data fetch: $e');
      return _getFallbackData();
    }
  }

  // Refresh data (force network fetch)
  Future<List<DataModel>> refreshPets() async {
    try {
      final networkData = await _fetchFromNetwork();
      return networkData;
    } catch (e) {
      print('Error refreshing data: $e');
      // Try to get any cached data when refresh fails
      final cachedData = await _getCachedData(ignoreExpiration: true);
      if (cachedData != null) {
        return cachedData;
      }
      return _getFallbackData();
    }
  }

  // Private method to fetch from network
  Future<List<DataModel>> _fetchFromNetwork() async {
    try {
      print('Attempting to fetch data from: $_apiUrl');
      final response = await http.get(Uri.parse(_apiUrl));

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        print(
            'Response body: ${response.body.substring(0, min(200, response.body.length))}...');
        var data = json.decode(response.body);
        List<DataModel> fetchedList = [];
        for (var item in data) {
          fetchedList.add(DataModel.fromJson(item));
        }

        // Cache the fetched data
        await _cacheData(fetchedList, response.body);
        return fetchedList;
      } else {
        throw Exception(
            'Failed to load pets: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Detailed network error: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Network request failed: $e');
    }
  }

  // Private method to cache data
  Future<void> _cacheData(List<DataModel> data, String rawJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, rawJson);
      await prefs.setInt(
          _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
      print('Data cached successfully');
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  // Private method to get cached data
  Future<List<DataModel>?> _getCachedData(
      {bool ignoreExpiration = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedJson = prefs.getString(_cacheKey);
      final int? timestamp = prefs.getInt(_cacheTimestampKey);

      if (cachedJson == null || (timestamp == null && !ignoreExpiration)) {
        return null;
      }

      // Check if cache is expired (unless we're ignoring expiration)
      if (!ignoreExpiration && timestamp != null) {
        final DateTime cacheTime =
            DateTime.fromMillisecondsSinceEpoch(timestamp);
        final DateTime now = DateTime.now();
        final Duration difference = now.difference(cacheTime);

        if (difference.inMinutes > _cacheExpirationMinutes) {
          print('Cache expired');
          return null;
        }
      }

      // Parse the cached data
      var data = json.decode(cachedJson);
      List<DataModel> cachedList = [];
      for (var item in data) {
        cachedList.add(DataModel.fromJson(item));
      }
      return cachedList;
    } catch (e) {
      print('Error reading cache: $e');
      return null;
    }
  }

  // Private method to clear cache
  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimestampKey);
  }

  List<DataModel> _getFallbackData() {
    // Implementation of _getFallbackData method
    // This is a placeholder and should be replaced with the actual implementation
    return [];
  }
}
