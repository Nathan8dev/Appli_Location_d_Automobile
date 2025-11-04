// Fichier : lib/views/proprietaire/vues_proprietaire/ajouter_moto/ajouter_automobile.dart

import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:uuid/uuid.dart';

// Imports pour chaque type de véhicule
import 'ajouter_jet_prive/ajouter_jet_prive1.dart';
import 'ajouter_moto/ajouter_moto1.dart';
import 'ajouter_semi_remorque/ajouter_semi_remorque.dart';
import 'ajouter_voiture/ajouter_voiture1.dart';
import 'ajouter_bus/ajouter_bus1.dart';
import 'ajouter_tricycle/ajouter_tricycle1.dart';
import 'ajouter_camion/ajouter_camion1.dart';
import 'ajouter_helicoptere/ajouter_helicoptere1.dart';

class AjouterAutomobile extends StatefulWidget {
  final String proprietaireId; // <-- Ajout du paramètre

  const AjouterAutomobile({super.key, required this.proprietaireId}); // <-- Mis à jour du constructeur

  @override
  State<AjouterAutomobile> createState() => _AjouterAutomobileState();
}

class _AjouterAutomobileState extends State<AjouterAutomobile> {
  static const Color _primaryBlue = Color(0xFF4F77B0);
  static const Color _darkText = Color(0xFF0B132C);

  TypeVehicule _selectedVehicleType = TypeVehicule.voiture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Nouveau Véhicule'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Quel type de véhicule souhaitez-vous ajouter à louer ?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildVehicleTypeRadio(TypeVehicule.moto, 'Moto'),
            _buildVehicleTypeRadio(TypeVehicule.voiture, 'Voiture'),
            _buildVehicleTypeRadio(TypeVehicule.bus, 'Bus'),
            _buildVehicleTypeRadio(TypeVehicule.tricycle, 'Tricycle'),
            _buildVehicleTypeRadio(TypeVehicule.semiRemorque, 'Semi-remorque'),
            _buildVehicleTypeRadio(TypeVehicule.camion, 'Camion'),
            _buildVehicleTypeRadio(TypeVehicule.jetPrive, 'Jet privé'),
            _buildVehicleTypeRadio(TypeVehicule.helicoptere, 'Hélicoptère'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectedVehicleType != TypeVehicule.none
                  ? () async {
                final Vehicule newVehicle = Vehicule(
                  id: const Uuid().v4(),
                  proprietaire: widget.proprietaireId, // <-- Utilise l'ID du propriétaire passé
                  typeVehicule: _selectedVehicleType,

                  // Initialisation des autres champs avec des valeurs par défaut/vides
                  nom: '',
                  description: '',
                  prix_jour: 0.0,
                  prix_semaine: 0.0,
                  prix_mois: 0.0,
                  typeTransmission: TypeTransmission.none,
                  nbr_place: 0,
                  etat_vehicule: Etat_vehicule.nonDisponible, // L'état par défaut est non disponible
                  publication_statut: Publication_statut.nonPublie, // Le statut par défaut est non publié

                  // Champs optionnels ou qui seront remplis plus tard
                  image_vehicule: null,
                  logo_image: null,
                  positionGeographique: '',
                  marque: '',
                  model: '',
                  Kilometrage: 0,
                  matricule: '',
                  annee_mise_circulation: 0,
                );

                final result;

                switch (_selectedVehicleType) {
                  case TypeVehicule.moto:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterMoto1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.voiture:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterVoiture1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.bus:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterBus1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.tricycle:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterTricycle1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.semiRemorque:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterSemiremorque1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.camion:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterCamion1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.jetPrive:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterJetPrive1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.helicoptere:
                    result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterHelicoptere1(vehicule: newVehicle)));
                    break;
                  case TypeVehicule.none:
                    return;
                }

                if (!mounted) return;
                if (result == true) {
                  Navigator.pop(context, true);
                }
              }
                  : null,
              child: const Text('Suivant'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypeRadio(TypeVehicule type, String label) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: _selectedVehicleType == type ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: _selectedVehicleType == type ? _primaryBlue : Colors.transparent,
          width: _selectedVehicleType == type ? 2.0 : 1.0,
        ),
      ),
      child: RadioListTile<TypeVehicule>(
        title: Text(
          label,
          style: TextStyle(
            fontWeight: _selectedVehicleType == type ? FontWeight.bold : FontWeight.normal,
            color: _selectedVehicleType == type ? _darkText : Colors.black87,
          ),
        ),
        value: type,
        groupValue: _selectedVehicleType,
        onChanged: (TypeVehicule? value) {
          setState(() {
            _selectedVehicleType = value!;
          });
        },
        activeColor: _primaryBlue,
      ),
    );
  }
}