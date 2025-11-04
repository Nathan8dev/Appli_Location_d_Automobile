import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class Utilisateur {
  final String id; // L'identifiant unique de l'utilisateur
  final String nom;
  final String email;
  final String numeroDeTelephone;
  final String role; // 'client' ou 'proprietaire'
  final String _motDePasseHache; // Le mot de passe haché (privé et final)

  // Constructeur principal pour créer un nouvel utilisateur.
  // Il reçoit un mot de passe en clair et le hache immédiatement.
  Utilisateur({
    String? id, // L'ID est optionnel lors de la création, il sera généré si non fourni
    required this.nom,
    required this.email,
    required this.numeroDeTelephone,
    required this.role,
    required String motDePasse, // Reçoit le mot de passe en clair ici
  })  : id = id ?? const Uuid().v4(), // Génère un ID unique si 'id' n'est pas spécifié
        _motDePasseHache = _hasherMotDePasse(motDePasse); // Hache le mot de passe dès la construction

  // Constructeur interne privé.
  // Utilisé principalement par le 'factory depuisMap' pour créer un objet Utilisateur
  // à partir de données où le mot de passe est déjà haché.
  // Cela évite de hacher deux fois un mot de passe déjà haché.
  Utilisateur._interne({
    required this.id, // L'ID est requis pour ce constructeur interne
    required this.nom,
    required this.email,
    required this.numeroDeTelephone,
    required this.role,
    required String motDePasseDejaHache, // Reçoit un mot de passe déjà haché
  }) : _motDePasseHache = motDePasseDejaHache;

  // Constructeur "factory" pour créer un objet Utilisateur à partir d'une Map
  // (ex: depuis Firestore, une base de données ou une API JSON).
  factory Utilisateur.depuisMap(Map<String, dynamic> map) {
    return Utilisateur._interne(
      id: map['id'] as String? ?? const Uuid().v4(), // Récupère l'ID ou en génère un si manquant
      nom: map['nom'] as String? ?? '', // Utilise l'opérateur ?? pour fournir une valeur par défaut si null
      email: map['email'] as String? ?? '',
      numeroDeTelephone: map['numeroDeTelephone'] as String? ?? '',
      role: map['role'] as String? ?? '',
      motDePasseDejaHache: map['motDePasseHache'] as String? ?? '', // Récupère le mot de passe déjà haché
    );
  }

  // Méthode statique pour hacher un mot de passe.
  static String _hasherMotDePasse(String motDePasse) {
    final octets = utf8.encode(motDePasse); // Convertit la chaîne en séquence d'octets
    return sha256.convert(octets).toString(); // Hache les octets et retourne la chaîne hexadécimale
  }

  // Méthode publique pour vérifier si un mot de passe en clair correspond
  // au mot de passe haché stocké dans l'objet Utilisateur.
  bool verifierMotDePasse(String motDePasse) {
    return _hasherMotDePasse(motDePasse) == _motDePasseHache;
  }

  // Méthode pour convertir l'objet Utilisateur en une Map<String, dynamic>.
  // Utile pour stocker l'objet dans une base de données ou l'envoyer via une API.
  Map<String, dynamic> versMap() {
    return {
      'id': id, // Inclut l'ID dans la Map
      'nom': nom,
      'email': email,
      'numeroDeTelephone': numeroDeTelephone,
      'role': role,
      'motDePasseHache': _motDePasseHache, // Stocke le mot de passe haché
    };
  }

  // Méthode copyWith pour créer une nouvelle instance d'Utilisateur basée sur l'actuelle,
  // mais avec certaines propriétés modifiées.
  Utilisateur copyWith({
    String? id,
    String? nom,
    String? email,
    String? numeroDeTelephone,
    String? role,
    String? nouveauMotDePasse, // Mot de passe en clair si on veut le changer
  }) {
    return Utilisateur._interne(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      numeroDeTelephone: numeroDeTelephone ?? this.numeroDeTelephone,
      role: role ?? this.role,
      motDePasseDejaHache: nouveauMotDePasse != null ? _hasherMotDePasse(nouveauMotDePasse) : _motDePasseHache,
    );
  }
}