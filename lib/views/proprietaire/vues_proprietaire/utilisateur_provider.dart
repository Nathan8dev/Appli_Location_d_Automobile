// lib/providers/user_provider.dart
import 'package:flutter/material.dart';

import '../../../models/user.dart'; // Importez votre modèle Utilisateur

class UserProvider extends ChangeNotifier {
  Utilisateur? _currentUser; // Utilise votre modèle Utilisateur

  Utilisateur? get currentUser => _currentUser;

  // Méthode pour définir l'utilisateur lorsqu'il se connecte
  void setUser(Utilisateur user) { // Accepte un objet Utilisateur
    _currentUser = user;
    notifyListeners();
  }

  // Méthode pour effacer l'utilisateur lorsqu'il se déconnecte
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

// Si vous avez besoin de charger l'utilisateur depuis une source de données
// (par exemple, après une connexion réussie ou au démarrage de l'app si l'utilisateur est persistant)
// Future<void> loadUserFromDataSource() async {
//   // Exemple : Si vous stockez l'utilisateur dans SharedPreferences ou une base de données locale
//   // ou si vous le récupérez via une API après authentification.
//   // Ceci est un exemple, la logique exacte dépend de votre backend.

//   // Exemple avec un utilisateur factice pour le test
//   _currentUser = Utilisateur(
//     id: 'some_unique_id',
//     nom: 'John Doe',
//     email: 'john.doe@example.com',
//     numeroDeTelephone: '123456789',
//     role: 'proprietaire', // Ou 'client'
//     motDePasse: 'motdepasseenclair', // Ceci ne serait pas fait en production ici
//   );
//   // Si l'utilisateur vient d'une map (par ex. DB), utilisez Utilisateur.depuisMap
//   // _currentUser = Utilisateur.depuisMap(yourUserDataMap);

//   notifyListeners();
// }
}