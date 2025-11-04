// lib/viewmodel/user_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:location_automobiles/models/user.dart'; // Importe Utilisateur
import 'package:shared_preferences/shared_preferences.dart'; // Pour la persistance locale
import 'dart:convert'; // Pour encoder/décoder en JSON

class UserViewModel extends ChangeNotifier {
  static final UserViewModel _instance = UserViewModel._internal();
  factory UserViewModel() => _instance;

  UserViewModel._internal() {
    _loadUtilisateurActuel(); // Charger l'utilisateur au démarrage du ViewModel
  }

  String? getUserNameById(String userId) {
    // Dans une vraie application, vous feriez une recherche dans votre base de données.
    // Ici, nous simulons en vérifiant si l'ID correspond à l'utilisateur actuel.
    if (_utilisateurActuel != null && _utilisateurActuel!.id == userId) {
      return _utilisateurActuel!.nom;
    }
    return 'Propriétaire inconnu';
  }
  Utilisateur? _utilisateurActuel; // L'utilisateur actuellement connecté
  String? _roleSelectionne; // Propriété pour stocker le rôle sélectionné

  Utilisateur? get utilisateurActuel => _utilisateurActuel;
  String? get roleSelectionne => _roleSelectionne;

  void setRoleSelectionne(String role) {
    _roleSelectionne = role;
    print('Rôle sélectionné mis à jour : $_roleSelectionne');
    notifyListeners();
  }

  // Charge l'utilisateur depuis SharedPreferences
  Future<void> _loadUtilisateurActuel() async {
    final prefs = await SharedPreferences.getInstance();
    final utilisateurJsonString = prefs.getString('utilisateurActuel');
    if (utilisateurJsonString != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(utilisateurJsonString);
        _utilisateurActuel = Utilisateur.depuisMap(userMap); // Utilise depuisMap de votre modèle
      } catch (e) {
        print("Erreur lors du décodage de l'utilisateur depuis SharedPreferences: $e");
        _utilisateurActuel = null;
      }
    } else {
      _utilisateurActuel = null;
    }
    notifyListeners(); // Notifie les écouteurs après le chargement initial
  }

  // Persiste l'utilisateur actuel dans SharedPreferences
  Future<void> _saveUtilisateurActuel() async {
    final prefs = await SharedPreferences.getInstance();
    if (_utilisateurActuel != null) {
      final userJsonString = jsonEncode(_utilisateurActuel!.versMap()); // Utilise versMap de votre modèle
      await prefs.setString('utilisateurActuel', userJsonString);
    } else {
      await prefs.remove('utilisateurActuel');
    }
  }


  // Méthode de connexion
  Future<bool> connecter(String email, String motDePasse) async {
    await Future.delayed(const Duration(seconds: 1)); // Simule un délai réseau

    // Dans une vraie application, vous feriez une requête à votre backend
    // pour valider l'email et le mot de passe, et récupérer les données de l'utilisateur.
    // Pour cette démo, nous vérifions si l'utilisateur enregistré (s'il existe) correspond,
    // ou si on utilise les identifiants de test simulés.

    // Première vérification : est-ce l'utilisateur actuellement chargé/simulé par la persistance?
    if (_utilisateurActuel != null &&
        _utilisateurActuel!.email == email &&
        _utilisateurActuel!.verifierMotDePasse(motDePasse)) {
      print('Connexion réussie pour : $email (utilisateur actuel déjà en mémoire)');
      // L'utilisateur est déjà défini, juste notifier les listeners
      notifyListeners();
      return true;
    }

    // Deuxième vérification (simulation de BDD si l'utilisateur n'était pas déjà chargé)
    // C'est ici que vous feriez un appel API ou une recherche dans votre base de données.
    // Pour l'exemple, nous allons simuler un utilisateur "durcodé" pour le login.
    if (email == 'Demo@gmail.com' && motDePasse == 'Demo123') {
      _utilisateurActuel = Utilisateur(
        nom: 'Demo',
        email: 'Demo@gmail.com',
        numeroDeTelephone: '600000000',
        role: 'proprietaire', // Ou un rôle dynamique
        motDePasse: 'Demo123', // Ce sera haché par le constructeur Utilisateur
      );
      await _saveUtilisateurActuel(); // Sauvegarder l'utilisateur après une connexion simulée
      print('Connexion réussie (simulée avec identifiants test) pour : $email');
      notifyListeners();
      return true;
    }

    print('Échec de la connexion pour : $email (email/mot de passe incorrect ou utilisateur non trouvé).');
    return false;
  }

  // Méthode d'inscription
  Future<Utilisateur?> enregistrer({
    required String nom,
    required String email,
    required String numeroDeTelephone,
    required String role,
    required String motDePasse,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simule un délai réseau

    try {
      final nouvelUtilisateur = Utilisateur(
        nom: nom,
        email: email,
        numeroDeTelephone: numeroDeTelephone,
        role: role,
        motDePasse: motDePasse, // Passe le mot de passe en clair au constructeur Utilisateur
      );
      _utilisateurActuel = nouvelUtilisateur; // Définit le nouvel utilisateur comme l'utilisateur actuel
      await _saveUtilisateurActuel(); // Sauvegarde l'utilisateur après l'enregistrement
      print('Nouvel utilisateur enregistré et connecté : ${nouvelUtilisateur.email}');
      notifyListeners();
      return nouvelUtilisateur;
    } catch (e) {
      print('Erreur lors de l\'enregistrement de l\'utilisateur : $e');
      return null;
    }
  }

  // Méthode de déconnexion
  Future<void> deconnecter() async { // <--- Assurez-vous d'avoir 'Future<void>' et 'async' ici
    _utilisateurActuel = null;
    _roleSelectionne = null; // Assurez-vous de réinitialiser le rôle aussi
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('utilisateurActuel'); // Supprime les données de l'utilisateur
    notifyListeners();
  }

  // Récupère l'utilisateur actuellement connecté (le getter `utilisateurActuel` fait déjà cela)
  Utilisateur? recupererUtilisateurActuel() {
    return _utilisateurActuel;
  }

  // Vérifie si un utilisateur est connecté
  bool estUtilisateurConnecte() {
    return _utilisateurActuel != null;
  }

  // Met à jour les informations de l'utilisateur (inclut la gestion du nouveau mot de passe)
  Future<void> mettreAJourUtilisateurActuel({
    String? nom,
    String? email,
    String? numeroDeTelephone,
    String? nouveauMotDePasse, // Mot de passe en clair si on veut le changer
  }) async {
    if (_utilisateurActuel == null) {
      throw Exception('Aucun utilisateur connecté pour la mise à jour.');
    }
    await Future.delayed(const Duration(milliseconds: 300)); // Simule un délai

    // Utilise copyWith du modèle Utilisateur pour gérer la création de la nouvelle instance.
    // Le mot de passe sera haché par copyWith si `nouveauMotDePasse` est fourni.
    _utilisateurActuel = _utilisateurActuel!.copyWith(
      nom: nom,
      email: email,
      numeroDeTelephone: numeroDeTelephone,
      nouveauMotDePasse: nouveauMotDePasse,
    );
    await _saveUtilisateurActuel(); // Sauvegarde l'utilisateur mis à jour
    print('Profil utilisateur mis à jour : ${_utilisateurActuel!.email}');
    notifyListeners();
  }

  @override
  void dispose() {
    // Le singleton n'est généralement pas disposé car il est global.
    // Cependant, si vous aviez des ressources spécifiques qui nécessitaient une libération,
    // ce serait l'endroit. Pour un singleton, dispose() est rarement appelée.
    super.dispose();
  }
}