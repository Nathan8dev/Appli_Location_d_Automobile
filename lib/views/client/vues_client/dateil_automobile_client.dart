// Fichier : lib/views/client/vues_client/detail_automobile_client.dart

import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:location_automobiles/models/reservation.dart';
import 'package:location_automobiles/views/client/vues_client/paiement_page.dart';

class AutomobileDetailClientPage extends StatelessWidget {
  final Vehicule vehicule;
  final Function(Reservation) onReservationConfirmed;

  const AutomobileDetailClientPage({
    super.key,
    required this.vehicule,
    required this.onReservationConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicule.marque} ${vehicule.nom}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vehicule.image_vehicule != null
                ? Image.asset(
              vehicule.image_vehicule!,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicule.marque} ${vehicule.nom}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicule.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  _buildDetailRow(
                    context,
                    icon: Icons.speed,
                    label: 'Kilométrage',
                    value: '${vehicule.Kilometrage} km',
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.event,
                    label: 'Année',
                    value: vehicule.annee_mise_circulation.toString(),
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.people,
                    label: 'Nombre de places',
                    value: vehicule.nbr_place.toString(),
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.local_gas_station,
                    label: 'Carburant',
                    value: vehicule.typeCarburant,
                  ),
                  _buildDetailRow(
                    context,
                    icon: Icons.settings,
                    label: 'Transmission',
                    value: vehicule.typeTransmission.toString().split('.').last.toUpperCase(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaiementPage(
                vehicule: vehicule,
                onReservationConfirmed: onReservationConfirmed,
              ),
            ),
          );
        },
        label: const Text('Réserver ce véhicule'),
        icon: const Icon(Icons.payment),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}