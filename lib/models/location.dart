import 'package:uuid/uuid.dart';

// Enum pour le statut de la location
enum StatutLocation {
  aVenir,
  enCours,
  terminee,
  annulee,
}

class Location {
  String id;
  String idVehicule; // L'ID du véhicule loué
  String idLocataire; // L'ID de l'utilisateur qui loue
  DateTime dateDebut; // Date et heure de début de la location
  DateTime dateFin; // Date et heure de fin de la location
  double prixTotal; // Prix total de la location
  StatutLocation statut; // Statut de la location

  // Informations sur le locataire (pour affichage dans l'historique propriétaire)
  String nomLocataire; // Ancien 'renterName'
  String telephoneLocataire; // Ancien 'renterPhoneNumber'
  String emailLocataire; // Ancien 'renterEmail'
  String? lieuLivraison; // Lieu de livraison du véhicule (optionnel) (ancien 'deliveryLocation')

  String? avis; // Avis laissé après la location (optionnel) (ancien 'review')
  DateTime? dateRetourReelle; // Date réelle de retour si différente (ancien 'actualReturnDate')

  Location({
    String? id,
    required this.idVehicule,
    required this.idLocataire,
    required this.dateDebut,
    required this.dateFin,
    required this.prixTotal,
    this.statut = StatutLocation.aVenir, // Statut par défaut
    required this.nomLocataire,
    required this.telephoneLocataire,
    required this.emailLocataire,
    this.lieuLivraison,
    this.avis,
    this.dateRetourReelle,
  }) : this.id = id ?? const Uuid().v4();

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String,
      idVehicule: map['idVehicule'] as String? ?? '',
      idLocataire: map['idLocataire'] as String? ?? '',
      dateDebut: DateTime.parse(map['dateDebut'] as String),
      dateFin: DateTime.parse(map['dateFin'] as String),
      prixTotal: (map['prixTotal'] as num?)?.toDouble() ?? 0.0,
      statut: StatutLocation.values.firstWhere(
            (e) => e.toString().split('.').last == map['statut'],
        orElse: () => StatutLocation.aVenir,
      ),
      nomLocataire: map['nomLocataire'] as String? ?? '',
      telephoneLocataire: map['telephoneLocataire'] as String? ?? '',
      emailLocataire: map['emailLocataire'] as String? ?? '',
      lieuLivraison: map['lieuLivraison'] as String?,
      avis: map['avis'] as String?,
      dateRetourReelle: map['dateRetourReelle'] != null
          ? DateTime.parse(map['dateRetourReelle'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idVehicule': idVehicule,
      'idLocataire': idLocataire,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'prixTotal': prixTotal,
      'statut': statut.toString().split('.').last,
      'nomLocataire': nomLocataire,
      'telephoneLocataire': telephoneLocataire,
      'emailLocataire': emailLocataire,
      'lieuLivraison': lieuLivraison,
      'avis': avis,
      'dateRetourReelle': dateRetourReelle?.toIso8601String(),
    };
  }

  Location copyWith({
    String? id,
    String? idVehicule,
    String? idLocataire,
    DateTime? dateDebut,
    DateTime? dateFin,
    double? prixTotal,
    StatutLocation? statut,
    String? nomLocataire,
    String? telephoneLocataire,
    String? emailLocataire,
    String? lieuLivraison,
    String? avis,
    DateTime? dateRetourReelle,
  }) {
    return Location(
      id: id ?? this.id,
      idVehicule: idVehicule ?? this.idVehicule,
      idLocataire: idLocataire ?? this.idLocataire,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      prixTotal: prixTotal ?? this.prixTotal,
      statut: statut ?? this.statut,
      nomLocataire: nomLocataire ?? this.nomLocataire,
      telephoneLocataire: telephoneLocataire ?? this.telephoneLocataire,
      emailLocataire: emailLocataire ?? this.emailLocataire,
      lieuLivraison: lieuLivraison ?? this.lieuLivraison,
      avis: avis ?? this.avis,
      dateRetourReelle: dateRetourReelle ?? this.dateRetourReelle,
    );
  }
}