// Fichier : lib/views/reservation_view.dart

import 'package:flutter/material.dart';
import 'package:location_automobiles/models/reservation.dart';
import 'package:location_automobiles/models/vehicule.dart';
import '../../proprietaire/vues_proprietaire/details_reservations.dart'; // Assurez-vous que le chemin est correct

class Reservations_client extends StatelessWidget {
  final List<Reservation> reservations;
  const Reservations_client({super.key, required this.reservations});

  final String currentClientName = 'John Doe'; // Nom du client actuel

  // Liste factice de réservations pour le client actuel
  static final List<Reservation> _clientReservations = [
    Reservation(
      id: 'res_1',
      vehicule: Vehicule(
        id: '1', nom: 'Corolla', marque: 'Toyota', model: 'Corolla Sedan',
        typeCarburant: 'Essence', Kilometrage: 45000, nbr_place: 5,
        typeVehicule: TypeVehicule.voiture, typeTransmission: TypeTransmission.automatique,
        etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
        prix_jour: 35.0, prix_semaine: 200.0, prix_mois: 750.0,
        image_vehicule: 'assets/images/corolla.jpeg', logo_image: 'assets/logos/logo_corolla.jpeg',
        matricule: 'CE-456-JK', annee_mise_circulation: 2020, publication_statut: Publication_statut.publie,
        description: 'Une berline fiable et économique.',
      ),
      nomLocataire: 'John Doe',
      emailLocataire: 'john.doe@example.com',
      telephoneLocataire: '123456789',
      lieuLivraison: 'Douala, Cameroun',
      dateDebut: DateTime(2025, 8, 10),
      dateFin: DateTime(2025, 8, 15),
      prixTotal: 175.0,
      methodePaiementChoisie: 'Mobile Money',
      statut: StatutReservation.aVenir,
    ),
    Reservation(
      id: 'res_2',
      vehicule: Vehicule(
        id: '2', nom: 'MT-07', marque: 'Yamaha', model: 'MT-07',
        typeCarburant: 'Essence', Kilometrage: 10000, nbr_place: 2,
        typeVehicule: TypeVehicule.moto, typeTransmission: TypeTransmission.manuel,
        etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
        prix_jour: 20.0, prix_semaine: 120.0, prix_mois: 450.0,
        image_vehicule: 'assets/images/MT-07.jpeg', logo_image: 'assets/logos/logo_MT-07.jpeg',
        matricule: 'LM-789-OP', annee_mise_circulation: 2021, publication_statut: Publication_statut.publie,
        description: 'Moto sportive et maniable.',
      ),
      nomLocataire: 'John Doe',
      emailLocataire: 'john.doe@example.com',
      telephoneLocataire: '123456789',
      lieuLivraison: 'Yaoundé, Cameroun',
      dateDebut: DateTime(2025, 7, 20),
      dateFin: DateTime(2025, 7, 22),
      prixTotal: 60.0,
      methodePaiementChoisie: 'Carte de crédit',
      statut: StatutReservation.termine,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _clientReservations.isEmpty
          ? const Center(child: Text('Vous n\'avez aucune réservation.', style: TextStyle(color: Colors.grey, fontSize: 16)))
          : ListView.builder(
        itemCount: _clientReservations.length,
        itemBuilder: (context, index) {
          final reservation = _clientReservations[index];
          final vehicule = reservation.vehicule;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: vehicule.image_vehicule != null
                  ? Image.asset(vehicule.image_vehicule!, width: 80, height: 80, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported, size: 80),
              title: Text('${vehicule.marque} ${vehicule.nom}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Réservation du ${reservation.datesFormatees}'),
                  Text('Statut : ${reservation.statut.displayValue}'),
                  Text('Prix total : ${reservation.prixTotal} F CFA'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigue vers la page des détails en passant l'objet de réservation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsReservationsPage(reservation: reservation),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}