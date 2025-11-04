import 'package:flutter/material.dart'; // Nécessaire pour debugPrint et UniqueKey
import 'package:intl/intl.dart';
import 'package:location_automobiles/models/vehicule.dart'; // Assurez-vous que ce chemin est correct

// Définition de l'énumération pour les statuts de réservation
enum StatutReservation {
  aVenir('À venir'),
  enCours('En cours'),
  termine('Terminé');

  final String displayValue; // Valeur textuelle à afficher ou stocker
  const StatutReservation(this.displayValue);

  // Méthode statique pour convertir une chaîne en une valeur de l'énumération
  static StatutReservation fromString(String statusString) {
    switch (statusString) {
      case 'À venir':
        return StatutReservation.aVenir;
      case 'En cours':
        return StatutReservation.enCours;
      case 'Terminé':
        return StatutReservation.termine;
      default:
      // Gérer les cas où la chaîne n'est pas reconnue (par ex. anciennes données)
        debugPrint('Chaîne de statut de réservation invalide: "$statusString". Retour à "À venir" par défaut.');
        return StatutReservation.aVenir; // Retourne une valeur par défaut sécurisée
    }
  }
}

class Reservation {
  final String id;
  final Vehicule vehicule; // 'car' est devenu 'vehicule'
  final String nomLocataire; // 'renterName'
  final String emailLocataire; // 'renterEmail'
  final String telephoneLocataire; // 'renterPhoneNumber'
  final String lieuLivraison; // 'deliveryLocation'
  final DateTime dateDebut; // 'pickupDate'
  final DateTime dateFin; // 'returnDate'
  final double prixTotal; // 'totalPrice'
  final String methodePaiementChoisie; // 'selectedPaymentMethod'
  StatutReservation statut; // Type changé pour utiliser l'énumération
  String commentaire; // 'review'
  final String? motifReservation; // 'reservationReason'
  final String? referenceTransaction; // 'transactionReference'

  Reservation({
    String? id,
    required this.vehicule,
    required this.nomLocataire,
    required this.emailLocataire,
    required this.telephoneLocataire,
    required this.lieuLivraison,
    required this.dateDebut,
    required this.dateFin,
    required this.prixTotal,
    required this.methodePaiementChoisie,
    this.statut = StatutReservation.aVenir, // Valeur par défaut de type enum
    this.commentaire = '',
    this.motifReservation,
    this.referenceTransaction,
  }) : id = id ?? UniqueKey().toString();

  String get datesFormatees {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(dateDebut)} - ${formatter.format(dateFin)}';
  }

  // Constructeur factory pour créer une instance de Reservation à partir d'une Map
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as String,
      // Assurez-vous que 'Vehicule' a une méthode fromMap()
      vehicule: Vehicule.fromMap(map['vehicule']),
      nomLocataire: map['nomLocataire'] as String? ?? '',
      emailLocataire: map['emailLocataire'] as String? ?? '',
      telephoneLocataire: map['telephoneLocataire'] as String? ?? '',
      lieuLivraison: map['lieuLivraison'] as String? ?? '',
      dateDebut: DateTime.parse(map['dateDebut'] as String),
      dateFin: DateTime.parse(map['dateFin'] as String),
      prixTotal: (map['prixTotal'] as num?)?.toDouble() ?? 0.0,
      methodePaiementChoisie: map['methodePaiementChoisie'] as String? ?? '',
      // Conversion de la chaîne du statut en valeur d'énumération
      statut: StatutReservation.fromString(map['statut'] as String? ?? 'À venir'),
      commentaire: map['commentaire'] as String? ?? '',
      motifReservation: map['motifReservation'] as String?,
      referenceTransaction: map['referenceTransaction'] as String?,
    );
  }

  // Méthode copyWith pour créer une nouvelle instance avec des propriétés modifiées
  Reservation copyWith({
    String? id,
    Vehicule? vehicule,
    String? nomLocataire,
    String? emailLocataire,
    String? telephoneLocataire,
    String? lieuLivraison,
    String? motifReservation,
    DateTime? dateDebut,
    DateTime? dateFin,
    double? prixTotal,
    String? methodePaiementChoisie,
    String? referenceTransaction,
    StatutReservation? statut, // Type du paramètre mis à jour
    String? commentaire,
  }) {
    return Reservation(
      id: id ?? this.id,
      vehicule: vehicule ?? this.vehicule,
      nomLocataire: nomLocataire ?? this.nomLocataire,
      emailLocataire: emailLocataire ?? this.emailLocataire,
      telephoneLocataire: telephoneLocataire ?? this.telephoneLocataire,
      lieuLivraison: lieuLivraison ?? this.lieuLivraison,
      motifReservation: motifReservation ?? this.motifReservation,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      prixTotal: prixTotal ?? this.prixTotal,
      methodePaiementChoisie: methodePaiementChoisie ?? this.methodePaiementChoisie,
      referenceTransaction: referenceTransaction ?? this.referenceTransaction,
      statut: statut ?? this.statut,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  // Méthode pour convertir l'instance de Reservation en une Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // Assurez-vous que 'Vehicule' a une méthode toMap()
      'vehicule': vehicule.toMap(),
      'nomLocataire': nomLocataire,
      'emailLocataire': emailLocataire,
      'telephoneLocataire': telephoneLocataire,
      'lieuLivraison': lieuLivraison,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'prixTotal': prixTotal,
      'methodePaiementChoisie': methodePaiementChoisie,
      'statut': statut.displayValue, // Stocke la valeur textuelle de l'énumération
      'commentaire': commentaire,
      'motifReservation': motifReservation,
      'referenceTransaction': referenceTransaction,
    };
  }
}