import 'dart:convert';
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
      // Try to get data from cache first
      final cachedData = await _getCachedData();
      if (cachedData != null) {
        print('Using cached data');
        return cachedData;
      }

      // If no cache or expired, fetch from network
      return await _fetchFromNetwork();
    } catch (e) {
      print('Exception during data fetch: $e');
      // Try to use cache even if it's expired in case of network failure
      final cachedData = await _getCachedData(ignoreExpiration: true);
      if (cachedData != null) {
        print('Using expired cached data due to network error');
        return cachedData;
      }
      // If all fails, return empty list
      return [];
    }
  }

  // Refresh data (force network fetch)
  Future<List<DataModel>> refreshPets() async {
    try {
      await _clearCache();
      return await _fetchFromNetwork();
    } catch (e) {
      print('Error refreshing data: $e');
      return [];
    }
  }

  // Private method to fetch from network
  Future<List<DataModel>> _fetchFromNetwork() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<DataModel> fetchedList = [];
      for (var item in data) {
        fetchedList.add(DataModel.fromJson(item));
      }

      // Cache the fetched data
      await _cacheData(fetchedList, response.body);
      return fetchedList;
    } else {
      throw Exception('Failed to load pets: ${response.statusCode}');
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
}
