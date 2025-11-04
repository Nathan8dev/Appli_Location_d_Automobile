import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/reservation.dart';
import '../../../models/vehicule.dart';
import 'detail_automobile.dart';
import 'details_reservations.dart'; // Pour naviguer vers la page de détails de la réservation

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  // Données factices de réservations pour simuler des données de backend
  final List<Reservation> dummyReservations = [
    Reservation(
      vehicule: Vehicule(
        id: 'v001',
        nom: 'Chiron',
        marque: 'Bugatti',
        model: '2022',
        annee_mise_circulation: 2022,
        typeCarburant: 'Essence',
        Kilometrage: 15000,
        nbr_place: 2,
        typeVehicule: TypeVehicule.voiture,
        typeTransmission: TypeTransmission.automatique,
        positionGeographique: 'Douala, Cameroun',
        avec_conducteur: Avec_conducteur.avecOuSansConducteur,
        avec_carburant: Avec_carburant.sansCarburant,
        etat_vehicule: Etat_vehicule.disponible,
        proprietaire: 'Proprio001',
        prix_jour: 100000.0,
        prix_semaine: 600000.0,
        prix_mois: 2000000.0,
        description: 'Supercar de luxe, expérience de conduite incomparable.',
        image_vehicule: 'assets/images/bugatti_chiron.jpeg',
        matricule: 'CE123BG',
        publication_statut: Publication_statut.publie,
      ),
      nomLocataire: 'Annick',
      emailLocataire: 'Annick@example.com',
      telephoneLocataire: '+237 6 00 00 00 01',
      lieuLivraison: 'Aéroport International de Douala',
      dateDebut: DateTime.now().add(const Duration(days: 5)),
      dateFin: DateTime.now().add(const Duration(days: 10)),
      prixTotal: 500000.0,
      methodePaiementChoisie: 'Mobile Money',
      statut: StatutReservation.aVenir,
      motifReservation: 'Vacances en famille',
    ),
    Reservation(
      vehicule: Vehicule(
        id: 'v002',
        nom: 'Camry',
        marque: 'Toyota',
        model: '2020',
        annee_mise_circulation: 2020,
        typeCarburant: 'Essence',
        Kilometrage: 45000,
        nbr_place: 5,
        typeVehicule: TypeVehicule.voiture,
        typeTransmission: TypeTransmission.automatique,
        positionGeographique: 'Yaoundé, Cameroun',
        avec_conducteur: Avec_conducteur.sansConducteur,
        avec_carburant: Avec_carburant.avecCarburant,
        etat_vehicule: Etat_vehicule.disponible,
        proprietaire: 'Proprio002',
        prix_jour: 25000.0,
        prix_semaine: 150000.0,
        prix_mois: 500000.0,
        description: 'Berline confortable et économique pour vos trajets quotidiens.',
        image_vehicule: 'assets/images/toyota_camry.jpeg', // URL d'image factice
        matricule: 'CE456TY',
        publication_statut: Publication_statut.publie,
      ),
      nomLocataire: 'Sophie de Sion',
      emailLocataire: 'sophie@example.com',
      telephoneLocataire: '+237 6 00 00 00 02',
      lieuLivraison: 'Hôtel Hilton Yaoundé',
      dateDebut: DateTime.now().subtract(const Duration(days: 10)),
      dateFin: DateTime.now().subtract(const Duration(days: 5)),
      prixTotal: 125000.0,
      methodePaiementChoisie: 'Carte de Crédit',
      statut: StatutReservation.termine,
      commentaire: 'Excellent service et voiture en parfait état.',
    ),
    Reservation(
      vehicule: Vehicule(
        id: 'v003',
        nom: 'CRF250L',
        marque: 'Honda',
        model: '2019',
        annee_mise_circulation: 2019,
        typeCarburant: 'Essence',
        Kilometrage: 20000,
        nbr_place: 1,
        typeVehicule: TypeVehicule.moto,
        typeTransmission: TypeTransmission.manuel,
        positionGeographique: 'Kribi, Cameroun',
        avec_conducteur: Avec_conducteur.avecConducteur,
        avec_carburant: Avec_carburant.sansCarburant,
        etat_vehicule: Etat_vehicule.disponible,
        proprietaire: 'Proprio003',
        prix_jour: 15000.0,
        prix_semaine: 90000.0,
        prix_mois: 300000.0,
        description: 'Moto enduro idéale pour l\'exploration des pistes.',
        image_vehicule: 'assets/images/honda_CRF250L.jpeg', // URL d'image factice
        matricule: 'MT789HD',
        publication_statut: Publication_statut.publie,
      ),
      nomLocataire: 'Ludovic',
      emailLocataire: 'Ludovic@gmail.com',
      telephoneLocataire: '+237 6 00 00 00 03',
      lieuLivraison: 'Centre-ville Kribi',
      dateDebut: DateTime.now().subtract(const Duration(days: 2)),
      dateFin: DateTime.now().add(const Duration(days: 3)),
      prixTotal: 75000.0,
      methodePaiementChoisie: 'Virement Bancaire',
      statut: StatutReservation.enCours,
      commentaire: 'c\'était bien',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
      ),
      body: dummyReservations.isEmpty
          ? const Center(
        child: Text('Aucune réservation pour le moment.', style: TextStyle(fontSize: 18, color: Colors.grey)),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyReservations.length,
        itemBuilder: (context, index) {
          final reservation = dummyReservations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsReservationsPage(reservation: reservation),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image du véhicule
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AutomobileDetailPage.buildVehicleImage( // Appel corrigé
                          reservation.vehicule.image_vehicule,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Nom du véhicule
                    Text(
                      '${reservation.vehicule.marque} ${reservation.vehicule.nom} (${reservation.vehicule.model})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Dates de réservation
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          reservation.datesFormatees,
                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Statut de la réservation
                    Row(
                      children: [
                        Icon(
                          _getStatutIcon(reservation.statut),
                          size: 18,
                          color: _getStatutColor(reservation.statut),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Statut: ${reservation.statut.displayValue}',
                          style: TextStyle(
                            fontSize: 15,
                            color: _getStatutColor(reservation.statut),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Nom du locataire
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          'Locataire: ${reservation.nomLocataire}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Prix total
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 18, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          'Prix Total: ${reservation.prixTotal.toStringAsFixed(2)} FCFA',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getStatutIcon(StatutReservation statut) {
    switch (statut) {
      case StatutReservation.aVenir:
        return Icons.event_note;
      case StatutReservation.enCours:
        return Icons.play_circle_fill;
      case StatutReservation.termine:
        return Icons.check_circle;
    }
  }

  Color _getStatutColor(StatutReservation statut) {
    switch (statut) {
      case StatutReservation.aVenir:
        return Colors.orange;
      case StatutReservation.enCours:
        return Colors.blue;
      case StatutReservation.termine:
        return Colors.green;
    }
  }
}