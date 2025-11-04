// lib/viewmodel/compte_viewmodel.dart

import 'package:flutter/foundation.dart'; // Pour ChangeNotifier
import 'package:location_automobiles/models/user.dart'; // Importe Utilisateur
import 'package:location_automobiles/viewmodel/user_viewmodel.dart'; // Importe le UserViewModel central

class CompteViewModel extends ChangeNotifier {
  final UserViewModel _userViewModel; // Dépendance au UserViewModel global

  CompteViewModel({required UserViewModel userViewModel})
      : _userViewModel = userViewModel {
    _userViewModel.addListener(_onUserViewModelChanged);
    _utilisateurActuel = _userViewModel.utilisateurActuel; // Utilise 'utilisateurActuel'
  }

  Utilisateur? _utilisateurActuel;

  Utilisateur? get utilisateurActuel => _utilisateurActuel;

  void _onUserViewModelChanged() {
    _utilisateurActuel = _userViewModel.utilisateurActuel; // Utilise 'utilisateurActuel'
    notifyListeners();
  }

  void deconnecter() {
    _userViewModel.deconnecter(); // Appel à la méthode 'deconnecter' du UserViewModel
  }

  Future<void> mettreAJourUtilisateur({
    String? nom,
    String? email,
    String? numeroDeTelephone,
    String? nouveauMotDePasse,
  }) async {
    await _userViewModel.mettreAJourUtilisateurActuel(
      nom: nom,
      email: email,
      numeroDeTelephone: numeroDeTelephone,
      nouveauMotDePasse: nouveauMotDePasse,
    );
  }

  @override
  void dispose() {
    _userViewModel.removeListener(_onUserViewModelChanged);
    super.dispose();
  }
}