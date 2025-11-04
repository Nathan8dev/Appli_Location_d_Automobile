import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart'; // Utilisation du modèle existant

import 'ajouter_moto6.dart'; // La prochaine étape de l'ajout de moto

class AjouterMoto5 extends StatefulWidget {
  final Vehicule vehicule;

  const AjouterMoto5({super.key, required this.vehicule});

  @override
  State<AjouterMoto5> createState() => _AjouterMoto5State();
}

class _AjouterMoto5State extends State<AjouterMoto5> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController positionGeographiqueController;

  // Variables pour stocker la seule option sélectionnée, en utilisant les enums du modèle
  Avec_conducteur _selectedConducteurOption = Avec_conducteur.none;
  Avec_carburant _selectedCarburantOption = Avec_carburant.none;

  // Variable pour suivre si le formulaire a été soumis
  bool _formSubmitted = false;

  @override
  void initState() {
    super.initState();
    positionGeographiqueController = TextEditingController(text: widget.vehicule.positionGeographique ?? '');

    // Initialiser les options en fonction des données existantes du véhicule
    _selectedConducteurOption = widget.vehicule.avec_conducteur;
    _selectedCarburantOption = widget.vehicule.avec_carburant;
  }

  @override
  void dispose() {
    positionGeographiqueController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    setState(() {
      _formSubmitted = true; // Indique qu'une soumission a été tentée
    });

    final isPositionValid = _formKey.currentState!.validate();
    final isConducteurSelected = _selectedConducteurOption != Avec_conducteur.none;
    final isCarburantSelected = _selectedCarburantOption != Avec_carburant.none;

    if (isPositionValid && isConducteurSelected && isCarburantSelected) {
      _formKey.currentState!.save();

      final updatedVehicule = widget.vehicule.copyWith(
        positionGeographique: positionGeographiqueController.text.trim(),
        avec_conducteur: _selectedConducteurOption,
        avec_carburant: _selectedCarburantOption,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AjouterMoto6(vehicule: updatedVehicule),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs et sélectionner une option pour le conducteur et le carburant.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une ${widget.vehicule.typeVehicule.toString().split('.').last}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: positionGeographiqueController,
                decoration: const InputDecoration(labelText: 'Position du véhicule', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer la position géographique' : null,
              ),
              const SizedBox(height: 16.0),

              // Section Options Conducteur
              Text(
                'Option Conducteur:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RadioListTile<Avec_conducteur>(
                title: const Text('Avec Conducteur'),
                value: Avec_conducteur.avecConducteur,
                groupValue: _selectedConducteurOption,
                onChanged: (Avec_conducteur? newValue) {
                  setState(() {
                    _selectedConducteurOption = newValue!;
                  });
                },
              ),
              RadioListTile<Avec_conducteur>(
                title: const Text('Sans Conducteur'),
                value: Avec_conducteur.sansConducteur,
                groupValue: _selectedConducteurOption,
                onChanged: (Avec_conducteur? newValue) {
                  setState(() {
                    _selectedConducteurOption = newValue!;
                  });
                },
              ),
              RadioListTile<Avec_conducteur>(
                title: const Text('Avec ou Sans Conducteur'),
                value: Avec_conducteur.avecOuSansConducteur,
                groupValue: _selectedConducteurOption,
                onChanged: (Avec_conducteur? newValue) {
                  setState(() {
                    _selectedConducteurOption = newValue!;
                  });
                },
              ),
              // Le message d'erreur s'affiche seulement si une soumission a été tentée
              if (_formSubmitted && _selectedConducteurOption == Avec_conducteur.none)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    'Veuillez sélectionner une option de conducteur',
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16.0),

              // Section Options Carburant
              Text(
                'Option Carburant:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RadioListTile<Avec_carburant>(
                title: const Text('Avec Carburant'),
                value: Avec_carburant.avecCarburant,
                groupValue: _selectedCarburantOption,
                onChanged: (Avec_carburant? newValue) {
                  setState(() {
                    _selectedCarburantOption = newValue!;
                  });
                },
              ),
              RadioListTile<Avec_carburant>(
                title: const Text('Sans Carburant'),
                value: Avec_carburant.sansCarburant,
                groupValue: _selectedCarburantOption,
                onChanged: (Avec_carburant? newValue) {
                  setState(() {
                    _selectedCarburantOption = newValue!;
                  });
                },
              ),
              RadioListTile<Avec_carburant>(
                title: const Text('Avec ou Sans Carburant'),
                value: Avec_carburant.avecOuSansCarburant,
                groupValue: _selectedCarburantOption,
                onChanged: (Avec_carburant? newValue) {
                  setState(() {
                    _selectedCarburantOption = newValue!;
                  });
                },
              ),
              // Le message d'erreur s'affiche seulement si une soumission a été tentée
              if (_formSubmitted && _selectedCarburantOption == Avec_carburant.none)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    'Veuillez sélectionner une option de carburant',
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 32.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text('Précédent', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToNextStep,
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text('Suivant', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}