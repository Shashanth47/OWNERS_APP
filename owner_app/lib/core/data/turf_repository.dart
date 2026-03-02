import 'package:flutter/foundation.dart';
import '../models/turf_model.dart';

class TurfRepository extends ChangeNotifier {
  static final TurfRepository _instance = TurfRepository._internal();
  
  factory TurfRepository() {
    return _instance;
  }

  TurfRepository._internal();

  final List<TurfModel> _turfs = [
    TurfModel(
      id: '1',
      name: 'Koramangala Arena',
      location: 'Koramangala, Bangalore',
      revenue: '₹12,450',
    ),
    TurfModel(
      id: '2',
      name: 'Indiranagar Sports Hub',
      location: 'Indiranagar, Bangalore',
      revenue: '₹8,200',
    ),
  ];

  List<TurfModel> get turfs => List.unmodifiable(_turfs);

  void addTurf(TurfModel turf) {
    _turfs.add(turf);
    notifyListeners();
  }

  void removeTurf(String id) {
    _turfs.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
