import 'package:aws_demo/features/trip/service/trips_api_service.dart';
import 'package:aws_demo/models/Trip.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  final tripsAPIService = ref.read(tripsAPIServiceProvider);
  return TripsRepository(tripsAPIService);
});

class TripsRepository {
  TripsRepository(this.tripsAPIService);

  final TripsAPIService tripsAPIService;

  Future<List<Trip>> getTrips() {
    return tripsAPIService.getTrips();
  }

  Future<List<Trip>> getPastTrips() {
    return tripsAPIService.getPastTrips();
  }

  Future<void> add(Trip trip) async {
    return tripsAPIService.addTrip(trip);
  }

  Future<void> update(Trip updatedTrip) async {
    return tripsAPIService.updateTrip(updatedTrip);
  }

  Future<void> delete(Trip deletedTrip) async {
    return tripsAPIService.deleteTrip(deletedTrip);
  }

  Future<Trip> getTrip(String tripId) async {
    return tripsAPIService.getTrip(tripId);
  }
}