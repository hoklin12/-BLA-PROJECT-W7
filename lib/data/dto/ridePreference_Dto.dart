import 'package:week_3_blabla_project/data/dto/location_dto.dart';
import 'package:week_3_blabla_project/model/location/locations.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class RidePreferenceDto {
  final Location departure;
  final DateTime departureDate;
  final Location arrival;
  final int requestedSeats;

  RidePreferenceDto({
    required this.departure,
    required this.departureDate,
    required this.arrival,
    required this.requestedSeats,
  });

  factory RidePreferenceDto.fromJson(Map<String, dynamic> json) {
    return RidePreferenceDto(
      departure: LocationDto.fromJson(json['departure'] as Map<String, dynamic>),
      departureDate: DateTime.parse(json['departureDate'] as String),
      arrival: LocationDto.fromJson(json['arrival'] as Map<String, dynamic>),
      requestedSeats: json['requestedSeats'] as int,
    );
  }

  RidePreference toRidePreference() {
    return RidePreference(
      departure: departure,
      departureDate: departureDate,
      arrival: arrival,
      requestedSeats: requestedSeats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departure': LocationDto.toJson(departure),
      'departureDate': departureDate.toIso8601String(),
      'arrival': LocationDto.toJson(arrival),
      'requestedSeats': requestedSeats,
    };
  }

  static RidePreferenceDto fromRidePreference(RidePreference pref) {
    return RidePreferenceDto(
      departure: pref.departure,
      departureDate: pref.departureDate,
      arrival: pref.arrival,
      requestedSeats: pref.requestedSeats,
    );
  }
}