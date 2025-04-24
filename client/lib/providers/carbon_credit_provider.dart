import 'package:flutter/material.dart';
import '../models/carbon_credit.dart';
import '../services/api_service.dart';

class CarbonCreditProvider with ChangeNotifier {
  List<CarbonCredit> _credits = [];
  bool _isLoading = false;
  String? _error;

  List<CarbonCredit> get credits => _credits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCarbonCredits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _credits = await ApiService.getCarbonCredits();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _credits = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCarbonCredit(CarbonCredit credit) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCredit = await ApiService.createCarbonCredit(credit);
      _credits.add(newCredit);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> buyCarbonCredit(String creditId, int credits) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.buyCarbonCredit(creditId, credits);
      await fetchCarbonCredits(); // Refresh the list
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 