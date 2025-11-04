// Fichier : lib/views/details_reservation.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/reservation.dart';
import '../../proprietaire/vues_proprietaire/detail_automobile.dart';

class DetailsReservationsPage extends StatelessWidget {
  final Reservation reservation;

  const DetailsReservationsPage({super.key, required this.reservation});

  // Widget pour construire une ligne de détail avec un libellé et une valeur
  Widget _buildDetailRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150, // Largeur fixe pour aligner les libellés
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black87,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder pour le nom de l'utilisateur actuel.
    // Dans une application réelle, cette donnée serait obtenue via un service d'authentification.
    const String dummyCurrentUserDisplayName = 'Utilisateur Actuel';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la réservation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section Véhicule Réservé ---
            Text(
              'Véhicule Réservé',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: AutomobileDetailPage.buildVehicleImage(
                    reservation.vehicule.image_vehicule,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Affichage du logo et du nom du véhicule
            Row(
              children: [
                if (reservation.vehicule.logo_image != null && reservation.vehicule.logo_image!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: AutomobileDetailPage.buildVehicleImage(
                        reservation.vehicule.logo_image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    '${reservation.vehicule.marque} ${reservation.vehicule.nom} ${reservation.vehicule.model}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            _buildDetailRow('Année', reservation.vehicule.annee_mise_circulation.toString()),
            _buildDetailRow('Matricule', reservation.vehicule.matricule),
            _buildDetailRow('Type de carburant', reservation.vehicule.typeCarburant),
            _buildDetailRow('Transmission', reservation.vehicule.typeTransmission.toString().split('.').last),
            _buildDetailRow('Prix par jour', '${reservation.vehicule.prix_jour.toStringAsFixed(2)} FCFA'),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AutomobileDetailPage(
                        vehicule: reservation.vehicule,
                        currentUserDisplayName: dummyCurrentUserDisplayName,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.directions_car),
                label: const Text('Voir les détails du véhicule'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const Divider(height: 30),

            // --- Section Détails de la Réservation ---
            Text(
              'Détails de la Réservation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
              'Statut',
              reservation.statut.displayValue,
              isBold: true,
              color: reservation.statut == StatutReservation.enCours
                  ? Colors.blue
                  : (reservation.statut == StatutReservation.termine ? Colors.green : Colors.orange),
            ),
            _buildDetailRow('Dates', reservation.datesFormatees),
            _buildDetailRow('Lieu de livraison', reservation.lieuLivraison),
            _buildDetailRow('Prix Total', '${reservation.prixTotal.toStringAsFixed(2)} FCFA', isBold: true),
            _buildDetailRow('Méthode de Paiement', reservation.methodePaiementChoisie),
            if (reservation.referenceTransaction != null && reservation.referenceTransaction!.isNotEmpty)
              _buildDetailRow('Référence Transaction', reservation.referenceTransaction!),
            if (reservation.motifReservation != null && reservation.motifReservation!.isNotEmpty)
              _buildDetailRow('Motif', reservation.motifReservation!),
            if (reservation.commentaire.isNotEmpty)
              _buildDetailRow('Commentaire', reservation.commentaire),
            const Divider(height: 30),

            // --- Section Informations du Locataire ---
            Text(
              'Informations du Locataire',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Nom', reservation.nomLocataire),
            _buildDetailRow('Email', reservation.emailLocataire),
            _buildDetailRow('Téléphone', reservation.telephoneLocataire),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}