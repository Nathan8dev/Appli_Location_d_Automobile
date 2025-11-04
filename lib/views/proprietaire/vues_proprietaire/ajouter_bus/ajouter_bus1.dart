import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';

class AjouterBus1 extends StatefulWidget {
  final Vehicule vehicule; // La voiture en cours d'ajout

  const AjouterBus1({super.key, required this.vehicule});

  @override
  State<AjouterBus1> createState() => _AjouterBus1State();
}

class _AjouterBus1State extends State<AjouterBus1> {
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