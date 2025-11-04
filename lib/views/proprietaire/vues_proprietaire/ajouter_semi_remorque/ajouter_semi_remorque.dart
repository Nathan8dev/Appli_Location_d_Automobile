// lib/screens/ajouter_moto1.dart
import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';

class AjouterSemiremorque1 extends StatefulWidget {
  final Vehicule vehicule; // La voiture en cours d'ajout

  const AjouterSemiremorque1({super.key, required this.vehicule});

  @override
  State<AjouterSemiremorque1> createState() => _AjouterSemiremorque1State();
}

class _AjouterSemiremorque1State extends State<AjouterSemiremorque1> {
  // ... Le code pour l'étape 2 ici
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Nouveau Véhicule'),
      ),
      body: Center(
        child: Text('Le véhicule de type ${widget.vehicule.typeVehicule.toString().split('.').last} a été sélectionné.'),
      ),
    );
  }
}