import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/dto/ridePreference_Dto.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = 'ride_preferences';

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsList = prefs.getStringList(_preferencesKey) ?? [];
      print('Raw prefs from SharedPreferences: $prefsList');
      print('Raw prefs from SharedPreferences: $prefsList');
      return prefsList
          .map((json) {
            final decoded = jsonDecode(json);
            print('Decoded JSON: $decoded');
      return RidePreferenceDto.fromJson(decoded);
    })
    .map((dto) => dto.toRidePreference())
    .toList();
    } catch (e) {
      print('Error loading past preferences: $e'); // Debug
      throw Exception('Failed to load past preferences: $e');
    }
  }



  @override
  Future<void> addPreference(RidePreference preference) async {
    try {
      final prefs = await getPastPreferences();
      print('Prefs before adding: $prefs'); 
      if (!prefs.contains(preference)) {
        prefs.add(preference);
        print('Prefs after adding: $prefs'); 
      }

      final sharedPrefs = await SharedPreferences.getInstance();
      final prefsString = prefs
          .map((pref) => jsonEncode(RidePreferenceDto.fromRidePreference(pref).toJson()))
          .toList();
      print('Saving prefsString: $prefsString');
      final success = await sharedPrefs.setStringList(_preferencesKey, prefsString);
      print('Save success: $success');

      if (!success) {
        throw Exception('Failed to save preferences to SharedPreferences');
      }
    } catch (e) {
      print('Error adding preference: $e'); 
      throw Exception('Failed to add past preference: $e');
    }
  }


}