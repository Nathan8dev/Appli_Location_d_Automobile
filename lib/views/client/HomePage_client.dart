// Fichier : lib/views/client/HomePage_client.dart

import 'package:flutter/material.dart';
import 'package:location_automobiles/models/reservation.dart';
import 'package:location_automobiles/views/client/vues_client/Reservations_client.dart';
import 'package:location_automobiles/views/client/vues_client/accueil_client.dart';
import 'package:location_automobiles/views/client/vues_client/compte_client.dart';
import '../../models/vehicule.dart';

class HomePageClient extends StatefulWidget {
  const HomePageClient({super.key});

  @override
  State<HomePageClient> createState() => _HomePageClientState();
}

class _HomePageClientState extends State<HomePageClient> {
  int _selectedIndex = 0;

  // C'est ici que nous stockons et gérons la liste des réservations.
  // Elle est initialisée avec vos données factices.
  final List<Reservation> _reservations = [
    Reservation(
      id: 'res_1',
      vehicule: Vehicule(
        id: '1', nom: 'Corolla', marque: 'Toyota', model: 'Corolla Sedan',
        typeCarburant: 'Essence', Kilometrage: 45000, nbr_place: 5,
        typeVehicule: TypeVehicule.voiture, typeTransmission: TypeTransmission.automatique,
        etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
        prix_jour: 35.0, prix_semaine: 200.0, prix_mois: 750.0,
        image_vehicule: 'assets/images/voiture1.jpeg', logo_image: 'assets/logos/logo1.jpg',
        matricule: 'CE-456-JK', annee_mise_circulation: 2020, publication_statut: Publication_statut.publie,
        description: 'Une berline fiable et économique.',
      ),
      nomLocataire: 'John Doe',
      emailLocataire: 'john.doe@example.com',
      telephoneLocataire: '123456789',
      lieuLivraison: 'Douala, Cameroun',
      dateDebut: DateTime(2025, 8, 10),
      dateFin: DateTime(2025, 8, 15),
      prixTotal: 175.0,
      methodePaiementChoisie: 'Mobile Money',
      statut: StatutReservation.aVenir,
    ),
    Reservation(
      id: 'res_2',
      vehicule: Vehicule(
        id: '2', nom: 'MT-07', marque: 'Yamaha', model: 'MT-07',
        typeCarburant: 'Essence', Kilometrage: 10000, nbr_place: 2,
        typeVehicule: TypeVehicule.moto, typeTransmission: TypeTransmission.manuel,
        etat_vehicule: Etat_vehicule.disponible, proprietaire: 'fabrice',
        prix_jour: 20.0, prix_semaine: 120.0, prix_mois: 450.0,
        image_vehicule: 'assets/images/voiture1.jpeg', logo_image: 'assets/logos/logo1.jpg',
        matricule: 'LM-789-OP', annee_mise_circulation: 2021, publication_statut: Publication_statut.publie,
        description: 'Moto sportive et maniable.',
      ),
      nomLocataire: 'John Doe',
      emailLocataire: 'john.doe@example.com',
      telephoneLocataire: '123456789',
      lieuLivraison: 'Yaoundé, Cameroun',
      dateDebut: DateTime(2025, 7, 20),
      dateFin: DateTime(2025, 7, 22),
      prixTotal: 60.0,
      methodePaiementChoisie: 'Carte de crédit',
      statut: StatutReservation.termine,
    ),
  ];

  // La fonction pour ajouter une nouvelle réservation.
  void addReservation(Reservation newReservation) {
    setState(() {
      _reservations.add(newReservation);
    });
  }

  // La liste des widgets qui correspondent à chaque onglet de la barre de navigation.
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Initialise la liste des widgets APRES que _reservations ait été défini.
    _widgetOptions = <Widget>[
      Accueil_client(onReservationConfirmed: addReservation),
      // Passe la liste de réservations au widget Reservations_client
      Reservations_client(reservations: _reservations),
      compte_client(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Compte',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ... Les autres classes (AccueilClient, CompteClient, etc.) restent inchangées.