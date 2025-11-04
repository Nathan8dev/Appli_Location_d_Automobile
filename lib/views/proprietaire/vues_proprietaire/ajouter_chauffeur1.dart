// lib/screens/chauffeur/ajouter_chauffeur.dart
import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart'; // Pour TypeVehicule
// Assurez-vous d'avoir un modèle pour Chauffeur, par exemple:
// import 'package:location_automobiles/models/chauffeur.dart';

class AjouterChauffeurPage extends StatefulWidget {
  final TypeVehicule typeVehicule; // Pour adapter les champs

  const AjouterChauffeurPage({super.key, required this.typeVehicule});

  @override
  State<AjouterChauffeurPage> createState() => _AjouterChauffeurPageState();
}

class _AjouterChauffeurPageState extends State<AjouterChauffeurPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _permisController = TextEditingController(); // Pour tous les chauffeurs

  // Champs spécifiques au type de véhicule
  final TextEditingController _certificatPilotageController = TextEditingController(); // Pour jetPrive, helicoptere
  final TextEditingController _licenceMaritimeController = TextEditingController(); // Si vous aviez des bateaux
  final TextEditingController _certificatPoidsLourdsController = TextEditingController(); // Pour camion, semiRemorque
  // Ajoutez d'autres contrôleurs si nécessaire pour d'autres types de chauffeurs

  @override
  void initState() {
    super.initState();
    // Vous pourriez pré-remplir si vous avez un chauffeur existant à modifier
  }

  @override
  void dispose() {
    _nomController.dispose();
    _contactController.dispose();
    _experienceController.dispose();
    _permisController.dispose();
    _certificatPilotageController.dispose();
    _licenceMaritimeController.dispose();
    _certificatPoidsLourdsController.dispose();
    super.dispose();
  }

  void _saveChauffeur() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ici, vous devriez créer un objet Chauffeur
      // et l'envoyer à un ViewModel ou service pour le sauvegarder
      // Exemple très simplifié :
      /*
      final Chauffeur newChauffeur = Chauffeur(
        id: 'new_id', // Générer un ID unique
        nom: _nomController.text.trim(),
        contact: _contactController.text.trim(),
        experience: _experienceController.text.trim(),
        permis: _permisController.text.trim(),
        typeVehiculeAssocie: widget.typeVehicule,
        certificatPilotage: (widget.typeVehicule == TypeVehicule.jetPrive || widget.typeVehicule == TypeVehicule.helicoptere)
            ? _certificatPilotageController.text.trim()
            : null,
        // ... autres champs spécifiques
      );
      // Ensuite, appeler votre ChauffeurViewModel pour ajouter/sauvegarder
      // Provider.of<ChauffeurViewModel>(context, listen: false).addChauffeur(newChauffeur);
      */

      // Afficher un message de succès et revenir en arrière
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chauffeur ajouté avec succès!')),
      );
      Navigator.pop(context); // Retourne à AjouterMoto5
    }
  }

  @override
  Widget build(BuildContext context) {
    // Déterminer les champs spécifiques à afficher en fonction du type de véhicule
    bool showPilotCertField = (widget.typeVehicule == TypeVehicule.jetPrive ||
        widget.typeVehicule == TypeVehicule.helicoptere);
    bool showHeavyVehicleCertField = (widget.typeVehicule == TypeVehicule.camion ||
        widget.typeVehicule == TypeVehicule.semiRemorque);
    // Ajoutez d'autres booléens pour d'autres types si nécessaire

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un chauffeur pour ${widget.typeVehicule.toString().split('.').last}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom Complet', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le nom du chauffeur' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Numéro de Contact', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un numéro de contact' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Années d\'Expérience', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Veuillez entrer les années d\'expérience' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _permisController,
                decoration: const InputDecoration(labelText: 'Numéro de Permis de Conduire', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le numéro de permis' : null,
              ),
              const SizedBox(height: 16.0),

              if (showPilotCertField)
                TextFormField(
                  controller: _certificatPilotageController,
                  decoration: const InputDecoration(labelText: 'Numéro de Certificat de Pilotage', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer le certificat de pilotage' : null,
                ),
              if (showPilotCertField) const SizedBox(height: 16.0),

              if (showHeavyVehicleCertField)
                TextFormField(
                  controller: _certificatPoidsLourdsController,
                  decoration: const InputDecoration(labelText: 'Numéro de Certificat Poids Lourds', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer le certificat poids lourds' : null,
                ),
              if (showHeavyVehicleCertField) const SizedBox(height: 16.0),

              // ... Ajoutez ici d'autres champs conditionnels pour d'autres types de chauffeurs

              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveChauffeur,
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0)),
                child: const Text('Sauvegarder Chauffeur', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}