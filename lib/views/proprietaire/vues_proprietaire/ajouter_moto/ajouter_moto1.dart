import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_automobiles/models/vehicule.dart'; // Assurez-vous que le chemin est correct
import 'dart:io'; // Pour File
import 'package:flutter/foundation.dart' show kIsWeb; // Pour détecter si on est sur le web
import 'dart:typed_data'; // Pour Uint8List pour le web
import 'dart:convert'; // Pour base64Encode

import 'package:path_provider/path_provider.dart'; // Pour obtenir le chemin des répertoires de l'application
import 'package:path/path.dart' as p; // Utile pour manipuler les chemins de fichiers

import 'ajouter_moto2.dart'; // La prochaine étape de l'ajout de moto

class AjouterMoto1 extends StatefulWidget {
  final Vehicule vehicule; // L'objet véhicule en cours de construction

  const AjouterMoto1({super.key, required this.vehicule});

  @override
  State<AjouterMoto1> createState() => _AjouterMoto1State();
}

class _AjouterMoto1State extends State<AjouterMoto1> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _marqueController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _immatriculationController = TextEditingController();

  String? _savedImagePath; // Nouveau: pour stocker le chemin permanent du fichier (mobile/desktop) ou Base64 (web)
  Uint8List? _imageBytesForWebDisplay; // Nouveau: pour l'affichage immédiat sur le web

  @override
  void initState() {
    super.initState();
    // Pré-remplir les contrôleurs si l'objet vehicule a déjà des données (ex: si l'utilisateur revient en arrière ou modifie)
    _marqueController.text = widget.vehicule.marque ?? '';
    _modelController.text = widget.vehicule.model ?? '';
    _immatriculationController.text = widget.vehicule.matricule ?? '';

    // Si un chemin d'image existe déjà dans le véhicule (vient d'un véhicule existant ou retour arrière)
    if (widget.vehicule.image_vehicule != null && widget.vehicule.image_vehicule!.isNotEmpty) {
      _savedImagePath = widget.vehicule.image_vehicule;
      // Pour les images Base64 (web), vous pourriez vouloir décoder les bytes pour l'affichage ici si nécessaire
      if (kIsWeb && _savedImagePath!.startsWith('data:image')) {
        try {
          final String base64String = _savedImagePath!.split(',').last;
          _imageBytesForWebDisplay = base64Decode(base64String);
        } catch (e) {
          debugPrint('Erreur de décodage Base64: $e');
          _imageBytesForWebDisplay = null;
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70); // Qualité réduite pour de meilleures performances

    if (image != null) {
      if (kIsWeb) {
        // Pour le web, lire l'image en bytes pour l'affichage immédiat et la sauvegarder en Base64
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBytesForWebDisplay = bytes;
          _savedImagePath = 'data:image/${image.name.split('.').last};base64,${base64Encode(bytes)}'; // Ex: image/jpeg, image/png
        });
      } else {
        // Pour mobile/desktop, copier l'image vers un emplacement persistant
        try {
          final appDocDir = await getApplicationDocumentsDirectory();
          final fileName = p.basename(image.path);
          final localImage = await File(image.path).copy('${appDocDir.path}/$fileName');

          setState(() {
            _savedImagePath = localImage.path;
            _imageBytesForWebDisplay = null; // S'assurer que les bytes sont nuls si on a le chemin de fichier
          });
        } catch (e) {
          debugPrint('Erreur lors de la copie de l\'image: $e');
          // Gérer l'erreur (afficher un message à l'utilisateur)
        }
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir de la galerie'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToNextStep() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Mettre à jour l'objet Vehicule avec les données de cette étape
      final updatedVehicule = widget.vehicule.copyWith(
        marque: _marqueController.text.trim(),
        model: _modelController.text.trim(),
        matricule: _immatriculationController.text.trim(),
        image_vehicule: _savedImagePath, // Le chemin sauvegardé (ou Base64) est stocké
      );

      // Naviguer vers la prochaine étape, en passant l'objet mis à jour
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AjouterMoto2(vehicule: updatedVehicule),
        ),
      );

      // Si la dernière étape de l'ajout (ex: AjoutMoto4) retourne 'true',
      // cela signifie que le processus complet a réussi et que nous devons
      // fermer toutes les pages de formulaire pour revenir à la page principale.
      if (!mounted) return;
      if (result == true) {
        Navigator.pop(context, true); // Ferme cette page et passe 'true' à la page précédente
      }
    }
  }

  @override
  void dispose() {
    _marqueController.dispose();
    _modelController.dispose();
    _immatriculationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une Moto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Informations de base de la moto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Champ Marque
              TextFormField(
                controller: _marqueController,
                decoration: const InputDecoration(
                  labelText: 'Marque',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.branding_watermark),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer la marque' : null,
              ),
              const SizedBox(height: 16),

              // Champ Modèle
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Modèle',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.model_training),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le modèle' : null,
              ),
              const SizedBox(height: 16),

              // Champ Immatriculation
              TextFormField(
                controller: _immatriculationController,
                decoration: const InputDecoration(
                  labelText: 'Immatriculation',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer l\'immatriculation' : null,
              ),
              const SizedBox(height: 20),

              // Section de sélection/affichage de l'image
              if (_savedImagePath != null || _imageBytesForWebDisplay != null)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: (kIsWeb && _imageBytesForWebDisplay != null) // Web: Afficher les bytes si disponibles
                          ? Image.memory(_imageBytesForWebDisplay!, height: 200, width: double.infinity, fit: BoxFit.cover)
                          : (_savedImagePath != null && _savedImagePath!.startsWith('assets/')) // Mobile/Desktop: Asset
                          ? Image.asset(_savedImagePath!, height: 200, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200, width: double.infinity, color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                          ))
                          : (_savedImagePath != null && !kIsWeb && File(_savedImagePath!).existsSync()) // Mobile/Desktop: Fichier local
                          ? Image.file(File(_savedImagePath!), height: 200, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200, width: double.infinity, color: Colors.grey[300],
                            child: Icon(Icons.broken_image, color: Colors.grey[600]),
                          ))
                          : Container( // Fallback (chemin invalide, fichier introuvable, etc.)
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.error_outline, color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => _showImageSourceActionSheet(context),
                      icon: const Icon(Icons.change_circle),
                      label: const Text('Changer l\'image'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: () => _showImageSourceActionSheet(context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Ajouter une photo de la moto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              const SizedBox(height: 30),

              // Boutons de navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Précédent'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _goToNextStep,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Suivant'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
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