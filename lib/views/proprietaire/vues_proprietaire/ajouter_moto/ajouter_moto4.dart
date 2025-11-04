// lib/screens/ajouter_moto/ajouter_moto4.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Suppression des imports ImagePicker, dart:io, dart:typed_data, dart:convert
// import 'package:image_picker/image_picker.dart'; // Commenté ou supprimé
// import 'dart:io'; // Commenté ou supprimé
// import 'dart:convert'; // Commenté ou supprimé
// import 'dart:typed_data'; // Commenté ou supprimé

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:location_automobiles/models/vehicule.dart';


import 'ajouter_moto5.dart';

class AjouterMoto4 extends StatefulWidget {
  final Vehicule vehicule;

  const AjouterMoto4({super.key, required this.vehicule});

  @override
  State<AjouterMoto4> createState() => _AjouterMoto4State();
}

class _AjouterMoto4State extends State<AjouterMoto4> {
  final _formKey = GlobalKey<FormState>();
  // final ImagePicker _picker = ImagePicker(); // Supprimé

  late TextEditingController nbrPlaceController;
  TypeTransmission? selectedTypeTransmission;

  // Suppression des variables d'état liées à la carte grise
  // String? _carteGriseImagePath;
  // Uint8List? _carteGriseImageBytes;


  @override
  void initState() {
    super.initState();
    nbrPlaceController = TextEditingController(text: widget.vehicule.nbr_place?.toString() ?? '');
    selectedTypeTransmission = widget.vehicule.typeTransmission != TypeTransmission.none ? widget.vehicule.typeTransmission : null;

    // Suppression de la logique d'initialisation de la carte grise
    /*
    final carteGriseData = widget.vehicule.carte_grise;
    if (carteGriseData != null && carteGriseData.isNotEmpty) {
      if (kIsWeb) {
        // Logique simplifiée pour le web : si le chemin est une URL ou un base64, on ne peut pas le recharger facilement ici.
        // On suppose que le flux est linéaire et que la photo sera re-sélectionnée si nécessaire.
        // Pour une application plus robuste, il faudrait une logique de chargement d'image depuis une URL.
      } else {
        _carteGriseImagePath = carteGriseData;
      }
    }
    */
  }

  @override
  void dispose() {
    nbrPlaceController.dispose();
    super.dispose();
  }

  // Suppression de la fonction _pickImage
  /*
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _carteGriseImageBytes = bytes;
          _carteGriseImagePath = null;
        });
      } else {
        setState(() {
          _carteGriseImagePath = image.path;
          _carteGriseImageBytes = null;
        });
      }
    }
  }
  */

  void _goToNextStep() {
    if (_formKey.currentState!.validate()) {
      // Suppression de la vérification de l'image de carte grise ici
      /*
      if (_carteGriseImagePath == null && _carteGriseImageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez ajouter une photo de la carte grise.')),
        );
        return;
      }
      */

      _formKey.currentState!.save();

      final updatedVehicule = widget.vehicule.copyWith(
        nbr_place: int.tryParse(nbrPlaceController.text) ?? 0,
        typeTransmission: selectedTypeTransmission ?? TypeTransmission.none,
        // Suppression du champ `carte_grise` ici, il sera géré dans AjouterMoto6
        // carte_grise: _carteGriseImagePath,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AjouterMoto5(vehicule: updatedVehicule),
        ),
      );
    }
  }

  // Suppression de la fonction _buildImageDisplay
  /*
  Widget _buildImageDisplay() {
    if (kIsWeb && _carteGriseImageBytes != null) {
      return Image.memory(_carteGriseImageBytes!, height: 200, fit: BoxFit.cover);
    } else if (_carteGriseImagePath != null) {
      return Image.file(File(_carteGriseImagePath!), height: 200, fit: BoxFit.cover);
    } else {
      return const Icon(Icons.upload_file, size: 50, color: Colors.grey);
    }
  }
  */

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
                controller: nbrPlaceController,
                decoration: const InputDecoration(labelText: 'Nombre de places', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le nombre de places' : null,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<TypeTransmission>(
                value: selectedTypeTransmission,
                decoration: const InputDecoration(labelText: 'Type de transmission', border: OutlineInputBorder()),
                items: TypeTransmission.values.where((e) => e != TypeTransmission.none).map((transmission) => DropdownMenuItem(value: transmission, child: Text(transmission.toString().split('.').last))).toList(),
                onChanged: (newValue) => setState(() => selectedTypeTransmission = newValue),
                validator: (value) => value == null ? 'Veuillez sélectionner le type de transmission' : null,
              ),
              const SizedBox(height: 24.0),

              // Suppression de la section pour l'image de la carte grise
              /*
              const Text('Photo de la carte grise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _carteGriseImagePath != null || _carteGriseImageBytes != null
                      ? _buildImageDisplay()
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Appuyez pour ajouter une photo de la carte grise', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              */

              const SizedBox(height: 32.0), // Ajuster l'espacement si la section carte grise est supprimée
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