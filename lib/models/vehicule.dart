import 'package:uuid/uuid.dart';

// Enum pour le type de véhicule
enum TypeVehicule {
  moto,
  voiture,
  bus,
  tricycle,
  semiRemorque,
  camion,
  jetPrive,
  helicoptere,
  none, // Valeur par défaut
}

// Enum pour le type de transmission
enum TypeTransmission {
  manuel,
  automatique,
  none, // Valeur par défaut
}

// Enum pour l'option conducteur
enum Avec_conducteur {
  avecConducteur,
  sansConducteur,
  avecOuSansConducteur,
  none, // Valeur par défaut
}

// Enum pour l'option carburant
enum Avec_carburant {
  avecCarburant,
  sansCarburant,
  none, avecOuSansCarburant, // Valeur par défaut
}

// Enum pour l'état du véhicule
enum Etat_vehicule {
  disponible,
  nonDisponible,
  none, // Valeur par défaut
}

// Enum pour l'état de publication
enum Publication_statut {
  publie,
  nonPublie,
  none, // Valeur par défaut
}

class Vehicule {
  String id; // ID unique
  String nom; // Nom du véhicule (nouveau champ)
  String marque; // Marque du véhicule
  String model; // Modèle du véhicule
  String typeCarburant; // Type de carburant (nouveau champ)
  int Kilometrage; // Kilométrage
  int nbr_place; // Nombre de places (nouveau champ)
  TypeVehicule typeVehicule; // Type de véhicule (moto, voiture, etc.)
  TypeTransmission typeTransmission; // Type de transmission (manuel, automatique)
  String? positionGeographique; // Position géographique (peut être null)
  Avec_conducteur avec_conducteur; // Avec conducteur, sans conducteur, avec ou sans
  Avec_carburant avec_carburant; // Avec carburant, sans carburant
  Etat_vehicule etat_vehicule; // État du véhicule (disponible ou non)
  String proprietaire; // ID du propriétaire
  double prix_jour;
  double prix_semaine;
  double prix_mois;
  String? image_vehicule; // MODIFICATION: Maintenant un String?
  String? logo_image; // URL de l'image du logo (nouveau champ, peut être null)
  String? visite_technique; // Image de la visite technique
  String? assurance; // Image de l'assurance
  String matricule; // Matricule
  String? carte_grise; // Image de la carte grise
  int annee_mise_circulation; // Année de mise en circulation
  Publication_statut publication_statut; // Publié ou non
  String? impot_liberatoire; // Image de l'impôt libératoire
  String description; // Description

  Vehicule({
    String? id, // Optionnel, sera généré si non fourni
    required this.nom,
    required this.marque,
    required this.model,
    this.typeCarburant = 'Essence', // Valeur par défaut
    required this.Kilometrage,
    required this.nbr_place,
    this.typeVehicule = TypeVehicule.none,
    this.typeTransmission = TypeTransmission.none,
    this.positionGeographique,
    this.avec_conducteur = Avec_conducteur.none,
    this.avec_carburant = Avec_carburant.none,
    this.etat_vehicule = Etat_vehicule.none,
    required this.proprietaire,
    required this.prix_jour,
    required this.prix_semaine,
    required this.prix_mois,
    this.image_vehicule, // MODIFICATION: type String?
    this.logo_image,
    this.visite_technique,
    this.assurance,
    required this.matricule,
    this.carte_grise,
    required this.annee_mise_circulation,
    this.publication_statut = Publication_statut.nonPublie,
    this.impot_liberatoire,
    this.description = '',
  }) : this.id = id ?? const Uuid().v4(); // Génère un ID si non fourni

  // Méthode pour créer un Vehicle à partir d'une Map (par exemple, depuis Firestore)
  factory Vehicule.fromMap(Map<String, dynamic> map) {
    return Vehicule(
      id: map['id'] as String,
      nom: map['nom'] as String? ?? '',
      marque: map['marque'] as String? ?? '',
      model: map['model'] as String? ?? '',
      typeCarburant: map['typeCarburant'] as String? ?? '',
      Kilometrage: (map['Kilometrage'] as num?)?.toInt() ?? 0,
      nbr_place: (map['nbr_place'] as num?)?.toInt() ?? 0,
      typeVehicule: TypeVehicule.values.firstWhere(
            (e) => e.toString().split('.').last == map['typeVehicule'],
        orElse: () => TypeVehicule.none,
      ),
      typeTransmission: TypeTransmission.values.firstWhere(
            (e) => e.toString().split('.').last == map['typeTransmission'],
        orElse: () => TypeTransmission.none,
      ),
      positionGeographique: map['positionGeographique'] as String?,
      avec_conducteur: Avec_conducteur.values.firstWhere(
            (e) => e.toString().split('.').last == map['avec_conducteur'],
        orElse: () => Avec_conducteur.none,
      ),
      avec_carburant: Avec_carburant.values.firstWhere(
            (e) => e.toString().split('.').last == map['avec_carburant'],
        orElse: () => Avec_carburant.none,
      ),
      etat_vehicule: Etat_vehicule.values.firstWhere(
            (e) => e.toString().split('.').last == map['etat_vehicule'],
        orElse: () => Etat_vehicule.none,
      ),
      proprietaire: map['proprietaire'] as String? ?? '',
      prix_jour: (map['prix_jour'] as num?)?.toDouble() ?? 0.0,
      prix_semaine: (map['prix_semaine'] as num?)?.toDouble() ?? 0.0,
      prix_mois: (map['prix_mois'] as num?)?.toDouble() ?? 0.0,
      image_vehicule: map['image_vehicule'] as String?, // MODIFICATION: type String?
      logo_image: map['logo_image'] as String?,
      visite_technique: map['visite_technique'] as String?,
      assurance: map['assurance'] as String?,
      matricule: map['matricule'] as String? ?? '',
      carte_grise: map['carte_grise'] as String?,
      annee_mise_circulation: (map['annee_mise_circulation'] as num?)?.toInt() ?? 2000,
      publication_statut: Publication_statut.values.firstWhere(
            (e) => e.toString().split('.').last == map['publication_statut'],
        orElse: () => Publication_statut.nonPublie,
      ),
      impot_liberatoire: map['impot_liberatoire'] as String?,
      description: map['description'] as String? ?? '',
    );
  }

  // Méthode pour convertir un Vehicle en Map (par exemple, pour l'envoyer à Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'marque': marque,
      'model': model,
      'typeCarburant': typeCarburant,
      'Kilometrage': Kilometrage,
      'nbr_place': nbr_place,
      'typeVehicule': typeVehicule.toString().split('.').last,
      'typeTransmission': typeTransmission.toString().split('.').last,
      'positionGeographique': positionGeographique,
      'avec_conducteur': avec_conducteur.toString().split('.').last,
      'avec_carburant': avec_carburant.toString().split('.').last,
      'etat_vehicule': etat_vehicule.toString().split('.').last,
      'proprietaire': proprietaire,
      'prix_jour': prix_jour,
      'prix_semaine': prix_semaine,
      'prix_mois': prix_mois,
      'image_vehicule': image_vehicule, // MODIFICATION: type String?
      'logo_image': logo_image,
      'visite_technique': visite_technique,
      'assurance': assurance,
      'matricule': matricule,
      'carte_grise': carte_grise,
      'annee_mise_circulation': annee_mise_circulation,
      'publication_statut': publication_statut.toString().split('.').last,
      'impot_liberatoire': impot_liberatoire,
      'description': description,
    };
  }

  // Permet de créer une copie du véhicule avec des propriétés modifiées
  Vehicule copyWith({
    String? id,
    String? nom,
    String? marque,
    String? model,
    String? typeCarburant,
    int? Kilometrage,
    int? nbr_place,
    TypeVehicule? typeVehicule,
    TypeTransmission? typeTransmission,
    String? positionGeographique,
    Avec_conducteur? avec_conducteur,
    Avec_carburant? avec_carburant,
    Etat_vehicule? etat_vehicule,
    String? proprietaire,
    double? prix_jour,
    double? prix_semaine,
    double? prix_mois,
    String? image_vehicule, // MODIFICATION: type String?
    String? logo_image,
    String? visite_technique,
    String? assurance,
    String? matricule,
    String? carte_grise,
    int? annee_mise_circulation,
    Publication_statut? publication_statut,
    String? impot_liberatoire,
    String? client,
    String? description,
  }) {
    return Vehicule(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      marque: marque ?? this.marque,
      model: model ?? this.model,
      typeCarburant: typeCarburant ?? this.typeCarburant,
      Kilometrage: Kilometrage ?? this.Kilometrage,
      nbr_place: nbr_place ?? this.nbr_place,
      typeVehicule: typeVehicule ?? this.typeVehicule,
      typeTransmission: typeTransmission ?? this.typeTransmission,
      positionGeographique: positionGeographique ?? this.positionGeographique,
      avec_conducteur: avec_conducteur ?? this.avec_conducteur,
      avec_carburant: avec_carburant ?? this.avec_carburant,
      etat_vehicule: etat_vehicule ?? this.etat_vehicule,
      proprietaire: proprietaire ?? this.proprietaire,
      prix_jour: prix_jour ?? this.prix_jour,
      prix_semaine: prix_semaine ?? this.prix_semaine,
      prix_mois: prix_mois ?? this.prix_mois,
      image_vehicule: image_vehicule ?? this.image_vehicule, // MODIFICATION: type String?
      logo_image: logo_image ?? this.logo_image,
      visite_technique: visite_technique ?? this.visite_technique,
      assurance: assurance ?? this.assurance,
      matricule: matricule ?? this.matricule,
      carte_grise: carte_grise ?? this.carte_grise,
      annee_mise_circulation: annee_mise_circulation ?? this.annee_mise_circulation,
      publication_statut: publication_statut ?? this.publication_statut,
      impot_liberatoire: impot_liberatoire ?? this.impot_liberatoire,
      description: description ?? this.description,
    );
  }
}