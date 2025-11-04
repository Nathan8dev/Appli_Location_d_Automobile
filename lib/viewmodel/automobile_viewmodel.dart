// Fichier : automobile_viewmodel.dart (VERSION CORRIGÉE)

import 'package:flutter/foundation.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AutomobileViewModel extends ChangeNotifier {
  List<Vehicule> _allVehicules = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Vehicule> get allVehicules => _allVehicules;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Vehicule> get allPublishedVehicules => _allVehicules
      .where((vehicule) => vehicule.publication_statut == Publication_statut.publie)
      .toList();

  Future<void> _saveVehicules() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> vehiculesJson = _allVehicules.map((v) => jsonEncode(v.toMap())).toList();
    await prefs.setStringList('allVehicules', vehiculesJson);
  }

  // --- MÉTHODE UNIQUE ET GLOBALE DE RAFRAÎCHISSEMENT ---
  Future<void> fetchAllVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? vehiculesJson = prefs.getStringList('allVehicules');
      if (vehiculesJson != null) {
        _allVehicules = vehiculesJson.map((v) => Vehicule.fromMap(jsonDecode(v))).toList();
      } else {
        _allVehicules = [];
      }
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement des véhicules: ${e.toString()}';
      debugPrint('Erreur lors du chargement des véhicules: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAutomobile(Vehicule vehicule) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final existingVehiculeIndex = _allVehicules.indexWhere((v) => v.id == vehicule.id);

      if (existingVehiculeIndex != -1) {
        _allVehicules[existingVehiculeIndex] = vehicule;
      } else {
        _allVehicules.add(vehicule);
      }
      await _saveVehicules();
    } catch (e) {
      _errorMessage = 'Erreur lors de l\'ajout ou de la mise à jour du véhicule: ${e.toString()}';
      debugPrint('Erreur lors de l\'ajout ou de la mise à jour du véhicule: $e');
    } finally {
      _isLoading = false;
      await fetchAllVehicles(); // <-- RAFRAÎCHISSEMENT COMPLET
    }
  }

  Future<void> deleteAutomobile(String vehiculeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allVehicules.removeWhere((vehicule) => vehicule.id == vehiculeId);
      await _saveVehicules();
    } catch (e) {
      _errorMessage = 'Erreur lors de la suppression du véhicule: ${e.toString()}';
      debugPrint('Erreur lors de la suppression du véhicule: $e');
    } finally {
      _isLoading = false;
      await fetchAllVehicles(); // <-- RAFRAÎCHISSEMENT COMPLET
    }
  }

  Future<void> toggleAutomobilePublication(String vehiculeId, bool isPublishing) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final vehiculeIndex = _allVehicules.indexWhere((vehicule) => vehicule.id == vehiculeId);

      if (vehiculeIndex != -1) {
        final currentVehicule = _allVehicules[vehiculeIndex];

        final newPublicationStatut = isPublishing
            ? Publication_statut.publie
            : Publication_statut.nonPublie;

        final newEtatVehicule = isPublishing
            ? Etat_vehicule.disponible
            : Etat_vehicule.nonDisponible;

        _allVehicules[vehiculeIndex] = currentVehicule.copyWith(
          publication_statut: newPublicationStatut,
          etat_vehicule: newEtatVehicule,
        );

        await _saveVehicules();
      } else {
        _errorMessage = 'Véhicule non trouvé';
      }
    } catch (e) {
      _errorMessage = 'Erreur lors de la mise à jour du statut de publication: ${e.toString()}';
      debugPrint('Erreur lors de la mise à jour du statut de publication: $e');
    } finally {
      _isLoading = false;
      await fetchAllVehicles(); // <-- RAFRAÎCHISSEMENT COMPLET
    }
  }
}