import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:location_automobiles/models/vehicule.dart';

class AutomobileDetailPage extends StatelessWidget {
  final Vehicule vehicule;
  final String currentUserDisplayName;

  const AutomobileDetailPage({
    super.key,
    required this.vehicule,
    required this.currentUserDisplayName,
  });

  // Méthode statique pour gérer le chargement des images depuis plusieurs sources
  static Widget buildVehicleImage(String? imagePathOrUrlOrBase64, {double? height, double? width, BoxFit? fit}) {
    if (imagePathOrUrlOrBase64 == null || imagePathOrUrlOrBase64.isEmpty) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey[300],
        child: Icon(Icons.no_photography, color: Colors.grey[600], size: (height ?? 50) / 2),
      );
    }

    if (imagePathOrUrlOrBase64.startsWith('data:image')) {
      try {
        final String base64String = imagePathOrUrlOrBase64.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Erreur de décodage Base64: $error');
            return Container(
              height: height,
              width: width,
              color: Colors.grey[300],
              child: Icon(Icons.error, color: Colors.red, size: (height ?? 50) / 2),
            );
          },
        );
      } catch (e) {
        debugPrint('Erreur lors du décodage de l\'image Base64: $e');
        return Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, color: Colors.grey[600], size: (height ?? 50) / 2),
        );
      }
    }
    else if (imagePathOrUrlOrBase64.startsWith('assets/')) {
      return Image.asset(
        imagePathOrUrlOrBase64,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported,
                color: Colors.grey[600], size: (height ?? 50) / 2),
          );
        },
      );
    }
    else if (imagePathOrUrlOrBase64.startsWith('http://') || imagePathOrUrlOrBase64.startsWith('https://')) {
      return Image.network(
        imagePathOrUrlOrBase64,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey[300],
            child: Icon(Icons.cloud_off,
                color: Colors.grey[600], size: (height ?? 50) / 2),
          );
        },
      );
    }
    else if (!kIsWeb) {
      final File imageFile = File(imagePathOrUrlOrBase64);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Erreur de chargement de fichier local: $error');
            return Container(
              height: height,
              width: width,
              color: Colors.grey[300],
              child: Icon(Icons.broken_image, color: Colors.grey[600], size: (height ?? 50) / 2),
            );
          },
        );
      } else {
        debugPrint('Fichier image non trouvé: $imagePathOrUrlOrBase64');
        return Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: Icon(Icons.image_not_supported,
              color: Colors.grey[600], size: (height ?? 50) / 2),
        );
      }
    }
    else {
      debugPrint('Type d\'image non supporté ou chemin invalide sur cette plateforme: $imagePathOrUrlOrBase64');
      return Container(
        height: height,
        width: width,
        color: Colors.grey[300],
        child: Icon(Icons.help_outline, color: Colors.grey[600], size: (height ?? 50) / 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicule.marque} ${vehicule.model}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 250,
                  child: Hero(
                    tag: 'carImage-${vehicule.id}',
                    child: AutomobileDetailPage.buildVehicleImage(
                      vehicule.image_vehicule,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: vehicule.etat_vehicule == Etat_vehicule.disponible ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      vehicule.etat_vehicule == Etat_vehicule.disponible ? 'Disponible' : 'Non disponible',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (vehicule.logo_image != null && vehicule.logo_image!.isNotEmpty)
                        AutomobileDetailPage.buildVehicleImage(
                          vehicule.logo_image,
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${vehicule.nom} (${vehicule.model})',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDetailRow('Marque:', vehicule.marque),
                  _buildDetailRow('Modèle:', vehicule.model),
                  _buildDetailRow('Immatriculation:', vehicule.matricule),
                  _buildDetailRow('Année de mise en circulation:', "depuis ${vehicule.annee_mise_circulation.toString()}"),
                  _buildDetailRow('Type de carburant:', vehicule.typeCarburant),
                  _buildDetailRow('Kilométrage:', '${vehicule.Kilometrage} km'),
                  _buildDetailRow('Nombre de places:', vehicule.nbr_place.toString()),
                  _buildDetailRow('Type de véhicule:', vehicule.typeVehicule.toString().split('.').last),
                  _buildDetailRow('Boîte de vitesse:', vehicule.typeTransmission.toString().split('.').last),
                  _buildDetailRow('Position géographique:', vehicule.positionGeographique ?? 'Non spécifié'),
                  _buildDetailRow('Avec chauffeur:',
                      vehicule.avec_conducteur == Avec_conducteur.avecConducteur ||
                          vehicule.avec_conducteur == Avec_conducteur.avecOuSansConducteur
                          ? 'Oui'
                          : 'Non'),
                  _buildDetailRow('Carburant inclus:',
                      vehicule.avec_carburant == Avec_carburant.avecCarburant ? 'Oui' : 'Non'),
                  _buildDetailRow('État du véhicule:', vehicule.etat_vehicule.toString().split('.').last),
                  _buildDetailRow('Statut de publication:', vehicule.publication_statut.toString().split('.').last),

                  const SizedBox(height: 20),
                  Text(
                    'Informations du Propriétaire:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildDetailRow('Nom du Propriétaire:', currentUserDisplayName),

                  const SizedBox(height: 20),
                  Text(
                    'Description:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    vehicule.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'Prix:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildDetailRow('Par jour:', '${vehicule.prix_jour.toStringAsFixed(2)} FCFA'),
                  _buildDetailRow('Par semaine:', '${vehicule.prix_semaine.toStringAsFixed(2)} FCFA'),
                  _buildDetailRow('Par mois:', '${vehicule.prix_mois.toStringAsFixed(2)} FCFA'),

                  const SizedBox(height: 30),
                  Text(
                    'Documents:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double screenWidth = constraints.maxWidth;
                      const double padding = 8.0;
                      const int itemCount = 4;
                      final double totalPadding = padding * (itemCount - 1);
                      final double itemWidth = (screenWidth - totalPadding) / itemCount;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDocumentThumbnail(
                              context, 'Carte Grise', vehicule.carte_grise, itemWidth),
                          _buildDocumentThumbnail(
                              context, 'Attestation Assurance', vehicule.assurance, itemWidth),
                          _buildDocumentThumbnail(
                              context, 'Visite Technique', vehicule.visite_technique, itemWidth),
                          _buildDocumentThumbnail(
                              context, 'Impôt Libératoire', vehicule.impot_liberatoire, itemWidth),
                        ].whereType<Widget>().toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: color ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentThumbnail(BuildContext context, String title, String? imageUrl, double itemWidth) {
    final String safeImageUrl = imageUrl ?? '';
    const double thumbnailHeight = 100;
    debugPrint('Vérification de $title: $safeImageUrl');

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (safeImageUrl.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return Scaffold(
                      appBar: AppBar(title: Text(title)),
                      body: Center(
                        child: AutomobileDetailPage.buildVehicleImage(safeImageUrl, fit: BoxFit.contain),
                      ),
                    );
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('L\'image de $title n\'est pas disponible.')),
                  );
                }
              },
              child: Container(
                width: itemWidth,
                height: thumbnailHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: safeImageUrl.isEmpty
                    ? const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AutomobileDetailPage.buildVehicleImage(safeImageUrl, height: thumbnailHeight, width: itemWidth, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}