// lib/views/proprietaire/vues_proprietaire/accueil.dart
import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/gerer_automobile.dart';
import 'package:location_automobiles/viewmodel/automobile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/detail_automobile.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'ajouter_automobile.dart';
import 'package:location_automobiles/widgets/revenus_location_proprietaire.dart'; // Import du nouveau widget de graphique

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  final List<String> _carouselImages = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img3.jpeg',
    'assets/images/img4.jpeg',
    'assets/images/img5.jpeg',
  ];

  final List<String> _vehiculeTypesToDisplay = [
    'voiture',
    'moto',
    'jetPrive',
    'camion',
    'semiRemorque',
    'tricycle',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AutomobileViewModel>(context, listen: false).fetchAllVehicles();
    });
  }

  // Méthode statique pour gérer le chargement d'image
  static Widget _buildVehicleImage(String? imagePath, {
    double? height,
    double? width,
    BoxFit? fit,
  }) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey[300],
        child: const Icon(Icons.no_photography, color: Colors.grey),
      );
    }
    if (imagePath.startsWith('data:image')) {
      try {
        final String base64String = imagePath.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.red),
            );
          },
        );
      } catch (e) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.red),
        );
      }
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
      );
    }
    final File imageFile = File(imagePath);
    if (imageFile.existsSync()) {
      return Image.file(
        imageFile,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
      );
    }
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _buildTypeSection(
      BuildContext context,
      String vehiculeType,
      List<Vehicule> vehicules) {
    final List<Vehicule> filteredVehicules = vehicules.where((vehicule) {
      final bool isPublished = vehicule.publication_statut == Publication_statut.publie;
      final String vehiculeTypeString = vehicule.typeVehicule.toString().split('.').last.toLowerCase();
      final bool isMatchingType = vehiculeTypeString == vehiculeType.toLowerCase();

      return isPublished && isMatchingType;
    }).toList();

    if (filteredVehicules.isEmpty) {
      return const SizedBox.shrink();
    }

    String formattedTitle = vehiculeType.substring(0, 1).toUpperCase() + vehiculeType.substring(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            formattedTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredVehicules.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              final vehicule = filteredVehicules[index];
              return _buildVehicleCard(context, vehicule);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCounterCard(
      BuildContext context, String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                '$count',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Vehicule vehicule) {
    final isAvailable = vehicule.etat_vehicule == Etat_vehicule.disponible;
    String transmission = vehicule.typeTransmission.toString().split('.').last.toUpperCase();

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final String ownerName = userViewModel.getUserNameById(vehicule.proprietaire) ?? 'Propriétaire inconnu';

    return Card(
      margin: const EdgeInsets.only(right: 15.0, bottom: 5.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AutomobileDetailPage(
                vehicule: vehicule,
                currentUserDisplayName: ownerName,
              ),
            ),
          );
        },
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: _buildVehicleImage(
                      vehicule.image_vehicule,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        isAvailable ? 'Disponible' : 'Non disponible',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (vehicule.logo_image != null && vehicule.logo_image!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: _buildVehicleImage(
                                  vehicule.logo_image,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            vehicule.nom,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B132C),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$transmission | ${vehicule.typeCarburant}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AutomobileDetailPage(
                                vehicule: vehicule,
                                currentUserDisplayName: ownerName,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'En savoir plus',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        final String? proprietaireId = userViewModel.utilisateurActuel?.id;
        debugPrint('ID du propriétaire sur la page d\'accueil : $proprietaireId');

        return Scaffold(
          body: Consumer<AutomobileViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<Vehicule> currentOwnerVehicles;
              final List<Vehicule> allPublishedVehicles;

              // La logique de filtrage utilise `proprietaireId` qui est maintenant réactif.
              if (proprietaireId != null) {
                currentOwnerVehicles = viewModel.allVehicules
                    .where((v) => v.proprietaire == proprietaireId)
                    .toList();
              } else {
                currentOwnerVehicles = [];
              }

              // On filtre tous les véhicules publiés pour les sections
              allPublishedVehicles = viewModel.allVehicules
                  .where((v) => v.publication_statut == Publication_statut.publie)
                  .toList();

              final int publishedCount = currentOwnerVehicles.where((v) => v.publication_statut == Publication_statut.publie).length;
              final int unpublishedCount = currentOwnerVehicles.where((v) => v.publication_statut == Publication_statut.nonPublie).length;


              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Affichage conditionnel du graphique ou du carrousel
                    if (proprietaireId != null)
                      RevenusLocationProprietaire()
                    else
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          autoPlayInterval: const Duration(seconds: 4),
                        ),
                        items: _carouselImages.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                decoration: const BoxDecoration(color: Colors.grey),
                                child: Image.asset(
                                  i,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(child: Icon(Icons.image_not_supported, color: Colors.white.withOpacity(0.7), size: 50));
                                  },
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 20),

                    // Affichage conditionnel des boutons et compteurs pour les propriétaires
                    if (proprietaireId != null)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AjouterAutomobile(
                                        proprietaireId: proprietaireId,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_circle_outline),
                                label: const Text('Ajouter un automobile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildCounterCard(
                                  context,
                                  'Enregistrés',
                                  currentOwnerVehicles.length,
                                  Icons.directions_car,
                                  Colors.blueAccent,
                                ),
                                _buildCounterCard(
                                  context,
                                  'Publiés',
                                  publishedCount,
                                  Icons.check_circle_outline,
                                  Colors.green,
                                ),
                                _buildCounterCard(
                                  context,
                                  'Non publiés',
                                  unpublishedCount,
                                  Icons.unpublished,
                                  Colors.orange,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const gerer_automobile(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.settings),
                                label: const Text('Gérer les automobiles'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Theme.of(context).primaryColor,
                                  side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      )
                    else
                      const SizedBox.shrink(), // Cache les widgets si l'utilisateur n'est pas connecté

                    if (allPublishedVehicles.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline, color: Colors.grey, size: 80),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun automobile n\'est publié pour le moment.',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var vehiculeType in _vehiculeTypesToDisplay)
                            _buildTypeSection(
                              context,
                              vehiculeType,
                              allPublishedVehicles,
                            ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}