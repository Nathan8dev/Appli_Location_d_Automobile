import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:location_automobiles/models/reservation.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'dateil_automobile_client.dart';

// Liste factice de véhicules (utilisez votre propre source de données ici)
final List<Vehicule> _allVehicules = [
  Vehicule(
    id: '1', nom: 'Corolla', marque: 'Toyota', model: 'Corolla Sedan',
    typeCarburant: 'Essence', Kilometrage: 45000, nbr_place: 5,
    typeVehicule: TypeVehicule.voiture, typeTransmission: TypeTransmission.automatique,
    positionGeographique: 'Douala',
    avec_conducteur: Avec_conducteur.sansConducteur,
    avec_carburant: Avec_carburant.sansCarburant,
    etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
    prix_jour: 35.0, prix_semaine: 200.0, prix_mois: 750.0,
    image_vehicule: 'assets/images/corolla.jpeg', logo_image: 'assets/logos/logo_corolla.jpeg',
    matricule: 'CE-456-JK', annee_mise_circulation: 2020,
    publication_statut: Publication_statut.publie, description: 'Une berline fiable et économique.',
  ),
  Vehicule(
    id: '2', nom: 'MT-07', marque: 'Yamaha', model: 'MT-07',
    typeCarburant: 'Essence', Kilometrage: 10000, nbr_place: 2,
    typeVehicule: TypeVehicule.moto, typeTransmission: TypeTransmission.manuel,
    positionGeographique: 'Yaoundé',
    avec_conducteur: Avec_conducteur.sansConducteur,
    avec_carburant: Avec_carburant.sansCarburant,
    etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
    prix_jour: 20.0, prix_semaine: 120.0, prix_mois: 450.0,
    image_vehicule: 'assets/images/MT-07.jpeg', logo_image: 'assets/logos/logo_MT-07.jpeg',
    matricule: 'LM-789-OP', annee_mise_circulation: 2021,
    publication_statut: Publication_statut.publie, description: 'Moto sportive et maniable.',
  ),
  Vehicule(
    id: '3', nom: 'Tricycle Cargo', marque: 'Bajaj', model: 'RE 205',
    typeCarburant: 'Essence', Kilometrage: 8000, nbr_place: 3,
    typeVehicule: TypeVehicule.tricycle, typeTransmission: TypeTransmission.manuel,
    positionGeographique: 'Douala',
    avec_conducteur: Avec_conducteur.sansConducteur,
    avec_carburant: Avec_carburant.sansCarburant,
    etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
    prix_jour: 15.0, prix_semaine: 80.0, prix_mois: 300.0,
    image_vehicule: 'assets/images/bajaj.jpeg', logo_image: 'assets/logos/logo_bajaj.jpeg',
    matricule: 'XY-123-ZA', annee_mise_circulation: 2022,
    publication_statut: Publication_statut.publie, description: 'Tricycle utilitaire, idéal pour la ville.',
  ),
  Vehicule(
    id: '4', nom: 'F-Max', marque: 'Ford', model: 'F-Max 500',
    typeCarburant: 'Diesel', Kilometrage: 150000, nbr_place: 2,
    typeVehicule: TypeVehicule.camion, typeTransmission: TypeTransmission.manuel,
    positionGeographique: 'Bafoussam',
    avec_conducteur: Avec_conducteur.sansConducteur,
    avec_carburant: Avec_carburant.sansCarburant,
    etat_vehicule: Etat_vehicule.nonDisponible, proprietaire: 'fabrice',
    prix_jour: 150.0, prix_semaine: 800.0, prix_mois: 3000.0,
    image_vehicule: 'assets/images/ford.jpeg', logo_image: 'assets/logos/logo_ford.jpeg',
    matricule: 'TR-456-FE', annee_mise_circulation: 2020,
    publication_statut: Publication_statut.publie, description: 'Camion robuste et puissant.',
  ),
  Vehicule(
    id: '5', nom: 'T-Model', marque: 'Tesla', model: 'Model 3',
    typeCarburant: 'Électrique', Kilometrage: 150000, nbr_place: 2,
    typeVehicule: TypeVehicule.voiture, typeTransmission: TypeTransmission.manuel,
    positionGeographique: 'Douala',
    avec_conducteur: Avec_conducteur.sansConducteur,
    avec_carburant: Avec_carburant.sansCarburant,
    etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
    prix_jour: 120.0, prix_semaine: 600.0, prix_mois: 2500.0,
    image_vehicule: 'assets/images/tesla.jpeg', logo_image: 'assets/logos/logo_tesla.jpeg',
    matricule: 'TR-456-FE', annee_mise_circulation: 2020,
    publication_statut: Publication_statut.publie, description: 'Camion robuste et puissant.',
  ),
  Vehicule(
    id: '6', nom: 'Corolla', marque: 'Toyota', model: 'Corolla Sedan',
    typeCarburant: 'Essence', Kilometrage: 45000, nbr_place: 5,
    typeVehicule: TypeVehicule.voiture, typeTransmission: TypeTransmission.automatique,
    positionGeographique: 'Yaoundé',
    avec_conducteur: Avec_conducteur.sansConducteur,
    avec_carburant: Avec_carburant.sansCarburant,
    etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
    prix_jour: 35.0, prix_semaine: 200.0, prix_mois: 750.0,
    image_vehicule: 'assets/images/corolla2.jpeg', logo_image: 'assets/logos/logo_corolla.jpeg',
    matricule: 'CE-456-JK', annee_mise_circulation: 2020,
    publication_statut: Publication_statut.publie, description: 'Une berline fiable et économique.',
  ),
];

class Accueil_client extends StatefulWidget {
  final Function(Reservation) onReservationConfirmed;

  const Accueil_client({super.key, required this.onReservationConfirmed});

  @override
  State<Accueil_client> createState() => _Accueil_clientState();
}

class _Accueil_clientState extends State<Accueil_client> {
  final List<String> _carouselImages = [
    'assets/images/img1.png',
    'assets/images/accueil_client.png',
    'assets/images/accueil_proprio.png',
    'assets/images/gerer_auto.png',
    'assets/images/reserver.png',
  ];

  final Map<String, List<TypeVehicule>> _categoryMappings = {
    'Voitures': [TypeVehicule.voiture],
    'Motos & Tricycles': [TypeVehicule.moto, TypeVehicule.tricycle],
    'Camion & semi Remorque': [TypeVehicule.camion, TypeVehicule.semiRemorque],
    'Jets Privés': [TypeVehicule.jetPrive],
  };

  String _searchQuery = '';
  String? _selectedLocation;
  TypeVehicule? _selectedType;
  late RangeValues _priceRange;

  // Liste des véhicules filtrés
  List<Vehicule> _filteredVehicules = [];

  // Liste de toutes les positions géographiques uniques pour le filtre
  List<String> get _allLocations =>
      _allVehicules.map((v) => v.positionGeographique).where((v) => v != null).toSet().toList() as List<String>;

  @override
  void initState() {
    super.initState();
    // Définit la plage de prix initiale en fonction des données existantes
    _priceRange = RangeValues(
      _allVehicules.map((v) => v.prix_jour).reduce((a, b) => a < b ? a : b),
      _allVehicules.map((v) => v.prix_jour).reduce((a, b) => a > b ? a : b),
    );
    // Appelle la fonction de filtrage pour initialiser la liste
    _filterVehicles();
  }

  // Nouvelle méthode pour vérifier si un filtre est actif
  bool _isFilterActive() {
    // Vérifie si la recherche textuelle est active
    final bool isSearchQueryActive = _searchQuery.isNotEmpty;
    // Vérifie si un lieu est sélectionné
    final bool isLocationActive = _selectedLocation != null && _selectedLocation!.isNotEmpty;
    // Vérifie si un type est sélectionné
    final bool isTypeActive = _selectedType != null;
    // Vérifie si la plage de prix a été modifiée
    final double minPrice = _allVehicules.map((v) => v.prix_jour).reduce((a, b) => a < b ? a : b);
    final double maxPrice = _allVehicules.map((v) => v.prix_jour).reduce((a, b) => a > b ? a : b);
    final bool isPriceRangeActive = _priceRange.start > minPrice || _priceRange.end < maxPrice;

    return isSearchQueryActive || isLocationActive || isTypeActive || isPriceRangeActive;
  }

  void _filterVehicles() {
    setState(() {
      _filteredVehicules = _allVehicules.where((vehicule) {
        // Filtre par statut de publication
        if (vehicule.publication_statut != Publication_statut.publie) {
          return false;
        }

        // Filtre par texte de recherche (nom, marque, modèle, etc.)
        final searchQueryMatch = _searchQuery.isEmpty ||
            vehicule.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            vehicule.marque.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            vehicule.model.toLowerCase().contains(_searchQuery.toLowerCase());

        // Filtre par lieu
        final locationMatch = _selectedLocation == null ||
            _selectedLocation!.isEmpty ||
            vehicule.positionGeographique == _selectedLocation;

        // Filtre par type de véhicule
        final typeMatch = _selectedType == null ||
            vehicule.typeVehicule == _selectedType;

        // Filtre par prix
        final priceMatch =
            vehicule.prix_jour >= _priceRange.start && vehicule.prix_jour <= _priceRange.end;

        return searchQueryMatch && locationMatch && typeMatch && priceMatch;
      }).toList();
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            final double minPrice = _allVehicules.map((v) => v.prix_jour).reduce((a, b) => a < b ? a : b);
            final double maxPrice = _allVehicules.map((v) => v.prix_jour).reduce((a, b) => a > b ? a : b);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Filtres avancés', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Text('Type de véhicule', style: Theme.of(context).textTheme.titleMedium),
                    DropdownButton<TypeVehicule>(
                      isExpanded: true,
                      value: _selectedType,
                      hint: const Text('Sélectionner un type'),
                      items: TypeVehicule.values
                          .where((type) => type != TypeVehicule.none)
                          .map((TypeVehicule type) {
                        return DropdownMenuItem<TypeVehicule>(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (TypeVehicule? newValue) {
                        setStateModal(() {
                          _selectedType = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Lieu', style: Theme.of(context).textTheme.titleMedium),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLocation,
                      hint: const Text('Sélectionner un lieu'),
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('Tous les lieux')),
                        ..._allLocations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        setStateModal(() {
                          _selectedLocation = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Prix par jour', style: Theme.of(context).textTheme.titleMedium),
                    RangeSlider(
                      values: _priceRange,
                      min: minPrice,
                      max: maxPrice,
                      divisions: 10,
                      labels: RangeLabels(
                        '${_priceRange.start.round()} FCFA',
                        '${_priceRange.end.round()} FCFA',
                      ),
                      onChanged: (RangeValues newValues) {
                        setStateModal(() {
                          _priceRange = newValues;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedLocation = null;
                              _selectedType = null;
                              _priceRange = RangeValues(minPrice, maxPrice);
                              _filterVehicles();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Réinitialiser'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            _filterVehicles();
                            Navigator.pop(context);
                          },
                          child: const Text('Appliquer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildVehicleImage(String? imagePath, {double? height, double? width, BoxFit? fit}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(height: height, width: width, color: Colors.grey[300], child: const Icon(Icons.no_photography, color: Colors.grey));
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, height: height, width: width, fit: fit, errorBuilder: (context, error, stackTrace) {
        return Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported, color: Colors.grey));
      });
    }
    // Gérer les images à partir d'une source locale ou d'une chaîne encodée en base64 si nécessaire
    return Container(height: height, width: width, color: Colors.grey[300], child: const Icon(Icons.broken_image, color: Colors.grey));
  }

  Widget _buildVehicleCard(BuildContext context, Vehicule vehicule) {
    final isAvailable = vehicule.etat_vehicule == Etat_vehicule.disponible;
    String transmission = vehicule.typeTransmission.toString().split('.').last.toUpperCase();

    return Card(
      margin: const EdgeInsets.only(right: 15.0, bottom: 5.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AutomobileDetailClientPage(
                vehicule: vehicule,
                onReservationConfirmed: widget.onReservationConfirmed,
              ),
            ),
          );
        },
        child: Container(
          width: 250,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: _buildVehicleImage(vehicule.image_vehicule, height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        isAvailable ? 'Disponible' : 'Non disponible',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                          Image.asset(vehicule.logo_image!, height: 24, width: 24, errorBuilder: (context, error, stackTrace) => const SizedBox.shrink()),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(vehicule.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B132C)), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text('$transmission | ${vehicule.typeCarburant}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AutomobileDetailClientPage(
                                vehicule: vehicule,
                                onReservationConfirmed: widget.onReservationConfirmed,
                              ),
                            ),
                          );
                        },
                        child: Text('En savoir plus', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
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

  Widget _buildTypeSection(BuildContext context, String categoryTitle, List<TypeVehicule> vehiculeTypes) {
    // Utilise la liste _filteredVehicules au lieu de _allVehicules
    final List<Vehicule> filteredVehicules = _filteredVehicules.where((vehicule) {
      return vehiculeTypes.contains(vehicule.typeVehicule);
    }).toList();

    if (filteredVehicules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            categoryTitle,
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
              return _buildVehicleCard(context, filteredVehicules[index]);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Vérifie si un filtre est actif pour déterminer l'affichage
    final bool isFilterActive = _isFilterActive();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher une automobile...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _filterVehicles();
                        });
                      },
                    ),
                  ),
                  //
                ],
              ),
            ),

            CarouselSlider(
              options: CarouselOptions(height: 200.0, autoPlay: true, enlargeCenterPage: true, viewportFraction: 1.0, autoPlayInterval: const Duration(seconds: 4)),
              items: _carouselImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 0.0),
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: Image.asset(i, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.image_not_supported, color: Colors.white.withOpacity(0.7), size: 50))),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Afficher les catégories ou une liste de résultats de recherche
            if (isFilterActive)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Résultats de la recherche (${_filteredVehicules.length})',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_filteredVehicules.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'Aucun véhicule ne correspond à votre recherche.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filteredVehicules.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemBuilder: (context, index) {
                          return _buildVehicleCard(context, _filteredVehicules[index]);
                        },
                      ),
                    ),
                ],
              )
            else
            // Sinon, on affiche les catégories par défaut
              ..._categoryMappings.entries.map((entry) {
                return _buildTypeSection(context, entry.key, entry.value);
              }).toList(),
          ],
        ),
      ),
    );
  }
}