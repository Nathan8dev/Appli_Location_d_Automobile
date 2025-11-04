// Fichier : lib/views/proprietaire/vues_proprietaire/vehicules_publies.dart (VERSION AJUSTÉE)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location_automobiles/viewmodel/automobile_viewmodel.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';
import 'package:location_automobiles/widgets/vehicule_card.dart'; // Assurez-vous que ce widget existe
import 'package:location_automobiles/models/vehicule.dart';

class vehicules_publies extends StatefulWidget {
  const vehicules_publies({super.key});

  @override
  State<vehicules_publies> createState() => _vehicules_publiesState();
}

class _vehicules_publiesState extends State<vehicules_publies> {
  String? _proprietaireId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVehicles();
    });
  }

  Future<void> _loadVehicles() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final automobileViewModel = Provider.of<AutomobileViewModel>(context, listen: false);

    if (userViewModel.utilisateurActuel != null) {
      setState(() {
        _proprietaireId = userViewModel.utilisateurActuel!.id;
      });
      // CORRECTION : Appel de la méthode de rafraîchissement globale
      await automobileViewModel.fetchAllVehicles();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_proprietaireId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Véhicules publiés'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AutomobileViewModel>(
        builder: (context, automobileViewModel, child) {
          if (automobileViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (automobileViewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      automobileViewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      // CORRECTION : Appeler la méthode de rafraîchissement globale
                      onPressed: () => automobileViewModel.fetchAllVehicles(),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Filtrer les véhicules publiés pour le propriétaire actuel
          final vehiculesPublies = automobileViewModel.allVehicules
              .where((v) => v.proprietaire == _proprietaireId && v.publication_statut == Publication_statut.publie)
              .toList();

          if (vehiculesPublies.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => automobileViewModel.fetchAllVehicles(),
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 300,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Aucun automobile publié pour le moment.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            // CORRECTION : Utiliser la méthode de rafraîchissement globale
            onRefresh: () async => automobileViewModel.fetchAllVehicles(),
            child: ListView.builder(
              itemCount: vehiculesPublies.length,
              itemBuilder: (context, index) {
                final vehicule = vehiculesPublies[index];
                // Assurez-vous que votre widget VehiculeCard est correctement implémenté
                // et accepte un objet Vehicule.
                return VehiculeCard(vehicule: vehicule);
              },
            ),
          );
        },
      ),
    );
  }
}