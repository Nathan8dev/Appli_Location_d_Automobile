// lib/viewmodels/connexion_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/user.dart'; // Import Utilisateur
import 'user_viewmodel.dart'; // Importe le UserViewModel central

class ConnexionViewModel extends ChangeNotifier {
  final UserViewModel _userViewModel; // Dépendance au UserViewModel

  ConnexionViewModel({UserViewModel? userViewModel})
      : _userViewModel = userViewModel ?? UserViewModel();

  bool _estEnChargement = false;
  String? _messageErreur;

  bool get estEnChargement => _estEnChargement;
  String? get messageErreur => _messageErreur;

  // Méthode de connexion simplifiée car UserViewModel gère la logique
  Future<bool> connecter(String email, String motDePasse) async {
    _estEnChargement = true;
    _messageErreur = null;
    notifyListeners();

    // Appelle la méthode de connexion du UserViewModel qui contient la logique
    final bool succes = await _userViewModel.connecter(email, motDePasse);

    if (succes) {
      _estEnChargement = false;
      notifyListeners();
      return true;
    } else {
      _messageErreur = "Échec de la connexion. Vérifiez vos identifiants ou votre rôle.";
      _estEnChargement = false;
      notifyListeners();
      return false;
    }
  }

  // Méthode d'inscription
  Future<Utilisateur?> enregistrer({
    required String nom,
    required String email,
    required String numeroDeTelephone,
    required String motDePasse,
  }) async {
    _estEnChargement = true;
    _messageErreur = null;
    notifyListeners();

    // Récupère le rôle sélectionné depuis le UserViewModel
    final String? role = _userViewModel.roleSelectionne;
    if (role == null) {
      _messageErreur = "Aucun rôle sélectionné. Veuillez sélectionner un rôle.";
      _estEnChargement = false;
      notifyListeners();
      return null;
    }

    // Appelle la méthode d'enregistrement du UserViewModel
    final Utilisateur? nouvelUtilisateur = await _userViewModel.enregistrer(
      nom: nom,
      email: email,
      numeroDeTelephone: numeroDeTelephone,
      role: role,
      motDePasse: motDePasse,
    );

    if (nouvelUtilisateur != null) {
      _estEnChargement = false;
      notifyListeners();
      return nouvelUtilisateur;
    } else {
      _messageErreur = "Échec de l'enregistrement de l'utilisateur.";
      _estEnChargement = false;
      notifyListeners();
      return null;
    }
  }


  void effacerMessageErreur() {
    _messageErreur = null;
    notifyListeners();
  }
}