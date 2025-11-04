// lib/screens/ajouter_moto1.dart
import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';

class AjouterHelicoptere1 extends StatefulWidget {
  final Vehicule vehicule; // La voiture en cours d'ajout

  const AjouterHelicoptere1({super.key, required this.vehicule});

  @override
  State<AjouterHelicoptere1> createState() => _AjouterHelicoptere1State();
}

class _AjouterHelicoptere1State extends State<AjouterHelicoptere1> {
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