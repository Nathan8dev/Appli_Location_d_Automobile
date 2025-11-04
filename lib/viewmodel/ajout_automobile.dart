import 'package:flutter/foundation.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:uuid/uuid.dart';

class ajouterAutomobileViewModel extends ChangeNotifier {
  Vehicule? _newVehicule;

  Vehicule? get newVehicule => _newVehicule;

  // Initialise un nouveau véhicule pour l'étape 1
  void startNewVehiculeAddition(TypeVehicule type) {
    _newVehicule = Vehicule(
      id: const Uuid().v4(),
      typeVehicule: type,
      // Initialise les autres champs avec des valeurs par défaut/nulles
      nom: '',
      description: '',
      prix_jour: 0.0,
      prix_semaine: 0.0,
      prix_mois: 0.0,
      typeTransmission: TypeTransmission.automatique,
      nbr_place: 0,
      etat_vehicule: Etat_vehicule.nonDisponible,
      image_vehicule: null,
      logo_image: null,
      positionGeographique: '',
      // Si votre modèle a des champs obligatoires, donnez-leur des valeurs par défaut ici
      marque: '',
      model: '',
      annee_mise_circulation: 0,
      matricule: '',
      Kilometrage: 0,
      carte_grise: '',
      proprietaire: 'placeholder_owner_id',
    );
    notifyListeners();
  }

  // Met à jour les propriétés du véhicule à partir de l'étape 2
  void updateVehiculeDetails({
    required String marque,
    required String model,
    required int annee_mise_circulation,
    String? matricule,
    double? kilometrage,
    String? carte_grise,
    double? chargeUtile,
    int? capacite,
  }) {
    if (_newVehicule == null) return;

    _newVehicule = _newVehicule!.copyWith(
      marque: marque,
      model: model,
      annee_mise_circulation: annee_mise_circulation,
      matricule: matricule,
      Kilometrage: 0,
      carte_grise: carte_grise,
      // Vous pouvez ajouter d'autres champs de mise à jour ici
      // ...
    );
    notifyListeners();
  }

  // Exemple d'une méthode de validation
  bool validateStep2() {
    if (_newVehicule == null) return false;
    // Ajoute une logique de validation
    return _newVehicule!.marque.isNotEmpty && _newVehicule!.model.isNotEmpty;
  }

  // Méthode pour soumettre l'objet final
  Future<bool> submitVehicule() async {
    // Ici, vous ajouteriez la logique d'API pour envoyer l'objet `_newVehicule`
    // à votre backend ou à votre base de données.
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      print('Véhicule soumis avec succès: ${_newVehicule!.nom}');
      // Réinitialise le ViewModel après la soumission
      _newVehicule = null;
      notifyListeners();
      return true;
    } catch (e) {
      print('Erreur lors de la soumission: $e');
      return false;
    }
  }
}