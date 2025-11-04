// lib/views/proprietaire/HomePageProprietaire.dart
import 'package:flutter/material.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/Accueil.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/Reservations_page.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/compte_page.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/vehicules_publies.dart'; // NOUVEAU

class HomePageProprietaire extends StatefulWidget {
  const HomePageProprietaire({super.key});

  @override
  State<HomePageProprietaire> createState() => _HomePageProprietaireState();
}

class _HomePageProprietaireState extends State<HomePageProprietaire> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const Accueil(),
      const vehicules_publies(), // Index 1: La page pour les véhicules publiés
      const ReservationPage(),
      ComptePageProprietaire(onTabSelected: _onItemTapped),
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
      appBar: AppBar(
        title: const Text('LockNat - Propriétaire'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil', // Index 0
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Véhicules', // Index 1
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Réservations', // Index 2
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Compte', // Index 3
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}