// Fichier : lib/screens/ajouter_moto/ajouter_moto6.dart (VERSION CORRIGÉE)

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:convert';

import 'package:location_automobiles/models/vehicule.dart';
import 'package:location_automobiles/viewmodel/automobile_viewmodel.dart';
import 'package:location_automobiles/views/proprietaire/HomePage_proprietaire.dart';
import 'package:provider/provider.dart';

class AjouterMoto6 extends StatefulWidget {
  final Vehicule vehicule;

  const AjouterMoto6({super.key, required this.vehicule});

  @override
  State<AjouterMoto6> createState() => _AjouterMoto6State();
}

class _AjouterMoto6State extends State<AjouterMoto6> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String? _logoImagePath;
  Uint8List? _logoImageBytes;

  String? _visiteTechniqueImagePath;
  Uint8List? _visiteTechniqueImageBytes;

  String? _assuranceImagePath;
  Uint8List? _assuranceImageBytes;

  String? _impotLiberatoireImagePath;
  Uint8List? _impotLiberatoireImageBytes;

  String? _carteGriseImagePath;
  Uint8List? _carteGriseImageBytes;


  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _logoImagePath = widget.vehicule.logo_image;
    _visiteTechniqueImagePath = widget.vehicule.visite_technique;
    _assuranceImagePath = widget.vehicule.assurance;
    _impotLiberatoireImagePath = widget.vehicule.impot_liberatoire;
    _carteGriseImagePath = widget.vehicule.carte_grise;

    _initializeImageBytes(widget.vehicule.logo_image, (bytes) => _logoImageBytes = bytes);
    _initializeImageBytes(widget.vehicule.visite_technique, (bytes) => _visiteTechniqueImageBytes = bytes);
    _initializeImageBytes(widget.vehicule.assurance, (bytes) => _assuranceImageBytes = bytes);
    _initializeImageBytes(widget.vehicule.impot_liberatoire, (bytes) => _impotLiberatoireImageBytes = bytes);
    _initializeImageBytes(widget.vehicule.carte_grise, (bytes) => _carteGriseImageBytes = bytes);
  }

  void _initializeImageBytes(String? imageData, Function(Uint8List?) setter) {
    if (kIsWeb && imageData != null && imageData.startsWith('data:image')) {
      try {
        final bytes = base64Decode(imageData.split(',').last);
        setter(bytes);
      } catch (e) {
        debugPrint('Erreur lors du décodage Base64 pour l\'initialisation des bytes: $e');
        setter(null);
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectImage(Function(String?, Uint8List?) setter) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => setter(null, bytes));
      } else {
        final bytes = await pickedFile.readAsBytes();
        final String base64String = 'data:image/${pickedFile.name.split('.').last.toLowerCase()};base64,${base64Encode(bytes)}';
        setState(() => setter(base64String, null));
      }
    }
  }

  Widget _buildImagePickerField({
    required String labelText,
    String? imagePath,
    Uint8List? imageBytes,
    required Function(String?, Uint8List?) setter,
  }) {
    Widget imageWidget;
    if (imageBytes != null && kIsWeb) {
      imageWidget = Image.memory(imageBytes, fit: BoxFit.cover);
    } else if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('data:image')) {
        try {
          final bytes = base64Decode(imagePath.split(',').last);
          imageWidget = Image.memory(bytes, fit: BoxFit.cover);
        } catch (e) {
          debugPrint('Erreur de décodage Base64 pour $labelText: $e');
          imageWidget = const Icon(Icons.error, size: 40, color: Colors.red);
        }
      } else if (!kIsWeb) {
        final File file = File(imagePath);
        if (file.existsSync()) {
          imageWidget = Image.file(file, fit: BoxFit.cover);
        } else {
          debugPrint('Fichier non trouvé pour $labelText: $imagePath');
          imageWidget = const Icon(Icons.broken_image, size: 40, color: Colors.grey);
        }
      } else {
        debugPrint('Chemin non-Base64 sur le web pour $labelText: $imagePath');
        imageWidget = const Icon(Icons.help_outline, size: 40, color: Colors.grey);
      }
    } else {
      imageWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 40, color: Colors.grey[600]),
          const SizedBox(height: 5),
          Text('Appuyez pour ajouter une photo', style: TextStyle(color: Colors.grey[600], fontSize: 12))
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectImage(setter),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey)),
            child: imageWidget,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String? _getFinalImagePath(String? path, Uint8List? bytes) {
    if (path != null && path.isNotEmpty && path.startsWith('data:image')) {
      return path;
    }
    else if (bytes != null) {
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    }
    return path;
  }


  Future<void> _submitVehicle({required bool publish}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final automobileViewModel = Provider.of<AutomobileViewModel>(context, listen: false);

      Vehicule newVehicule = widget.vehicule.copyWith(
        logo_image: _getFinalImagePath(_logoImagePath, _logoImageBytes),
        visite_technique: _getFinalImagePath(_visiteTechniqueImagePath, _visiteTechniqueImageBytes),
        assurance: _getFinalImagePath(_assuranceImagePath, _assuranceImageBytes),
        impot_liberatoire: _getFinalImagePath(_impotLiberatoireImagePath, _impotLiberatoireImageBytes),
        carte_grise: _getFinalImagePath(_carteGriseImagePath, _carteGriseImageBytes),
        publication_statut: publish ? Publication_statut.publie : Publication_statut.nonPublie,
      );

      if (publish) {
        newVehicule = newVehicule.copyWith(
          etat_vehicule: Etat_vehicule.disponible,
        );
        debugPrint('Tentative de publication d\'un véhicule avec l\'ID du propriétaire : ${newVehicule.proprietaire}');

      } else {
        newVehicule = newVehicule.copyWith(
          etat_vehicule: Etat_vehicule.nonDisponible,
        );
      }

      try {
        await automobileViewModel.addAutomobile(newVehicule);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Automobile ${publish ? 'publiée' : 'enregistrée'} avec succès!')),
          );
          Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == '/HomePageProprietaire');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
            children: <Widget>[
              const Text('Documents du Véhicule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildImagePickerField(
                labelText: "Photo de la Carte Grise",
                imagePath: _carteGriseImagePath,
                imageBytes: _carteGriseImageBytes,
                setter: (path, bytes) => setState(() {
                  _carteGriseImagePath = path;
                  _carteGriseImageBytes = bytes;
                }),
              ),
              const SizedBox(height: 16),
              _buildImagePickerField(
                labelText: "Logo du Véhicule",
                imagePath: _logoImagePath,
                imageBytes: _logoImageBytes,
                setter: (path, bytes) => setState(() {
                  _logoImagePath = path;
                  _logoImageBytes = bytes;
                }),
              ),
              const SizedBox(height: 16),
              _buildImagePickerField(
                labelText: "Photo de la Visite Technique",
                imagePath: _visiteTechniqueImagePath,
                imageBytes: _visiteTechniqueImageBytes,
                setter: (path, bytes) => setState(() {
                  _visiteTechniqueImagePath = path;
                  _visiteTechniqueImageBytes = bytes;
                }),
              ),
              const SizedBox(height: 16),
              _buildImagePickerField(
                labelText: "Photo de l'Assurance",
                imagePath: _assuranceImagePath,
                imageBytes: _assuranceImageBytes,
                setter: (path, bytes) => setState(() {
                  _assuranceImagePath = path;
                  _assuranceImageBytes = bytes;
                }),
              ),
              const SizedBox(height: 16),
              _buildImagePickerField(
                labelText: "Photo de l'Impôt Libératoire",
                imagePath: _impotLiberatoireImagePath,
                imageBytes: _impotLiberatoireImageBytes,
                setter: (path, bytes) => setState(() {
                  _impotLiberatoireImagePath = path;
                  _impotLiberatoireImageBytes = bytes;
                }),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _submitVehicle(publish: true),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Publier'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _submitVehicle(publish: false),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Enregistrer sans publier'),
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