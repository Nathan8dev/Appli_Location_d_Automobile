// Fichier : lib/views/proprietaire/vues_proprietaire/gerer_automobile.dart

import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:location_automobiles/viewmodel/automobile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/ajouter_moto/ajouter_moto1.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/detail_automobile.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';
import 'package:uuid/uuid.dart';

class gerer_automobile extends StatefulWidget {
  const gerer_automobile({super.key});

  @override
  State<gerer_automobile> createState() => _gerer_automobileState();
}

class _gerer_automobileState extends State<gerer_automobile> {
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
      await automobileViewModel.fetchAllVehicles();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_proprietaireId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer les Automobiles'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AutomobileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.fetchAllVehicles(),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final vehiculesDuProprietaire = viewModel.allVehicules
              .where((v) => v.proprietaire == _proprietaireId)
              .toList();

          if (vehiculesDuProprietaire.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.grey, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucun automobile enregistré pour le moment.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final bool? added = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AjouterMoto1(
                              vehicule: Vehicule(
                                id: const Uuid().v4(), proprietaire: _proprietaireId!,
                                typeVehicule: TypeVehicule.none, Kilometrage: 0, nbr_place: 0,
                                prix_jour: 0.0, prix_semaine: 0.0, prix_mois: 0.0,
                                annee_mise_circulation: 2000, matricule: '', nom: '',
                                marque: '', model: '', typeCarburant: '', description: '',
                                typeTransmission: TypeTransmission.none,
                                avec_conducteur: Avec_conducteur.none,
                                avec_carburant: Avec_carburant.none,
                                etat_vehicule: Etat_vehicule.none,
                                publication_statut: Publication_statut.nonPublie,
                              ),
                            ),
                          ),
                        );
                        if (added == true) {
                          await viewModel.fetchAllVehicles();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un véhicule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => viewModel.fetchAllVehicles(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: vehiculesDuProprietaire.length,
              itemBuilder: (context, index) {
                final vehicule = vehiculesDuProprietaire[index];
                return _buildVehicleManagementCard(context, vehicule, viewModel);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleManagementCard(
      BuildContext context, Vehicule vehicule, AutomobileViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: AutomobileDetailPage.buildVehicleImage(
                    vehicule.image_vehicule,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicule.nom,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Marque: ${vehicule.marque} - Modèle: ${vehicule.model}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Matricule: ${vehicule.matricule}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: vehicule.publication_statut == Publication_statut.publie
                              ? Colors.green.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          vehicule.publication_statut == Publication_statut.publie
                              ? 'Publié'
                              : 'Non publié',
                          style: TextStyle(
                            color: vehicule.publication_statut == Publication_statut.publie
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await viewModel.toggleAutomobilePublication(
                      vehicule.id,
                      vehicule.publication_statut == Publication_statut.nonPublie,
                    );
                  },
                  icon: Icon(
                    vehicule.publication_statut == Publication_statut.publie
                        ? Icons.visibility_off
                        : Icons.publish,
                  ),
                  label: Text(
                    vehicule.publication_statut == Publication_statut.publie
                        ? 'Dépublier'
                        : 'Publier',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vehicule.publication_statut == Publication_statut.publie
                        ? Colors.orangeAccent
                        : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final bool? updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AjouterMoto1(vehicule: vehicule),
                      ),
                    );
                    if (updated == true && _proprietaireId != null) {
                      await viewModel.fetchAllVehicles();
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Modifier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final bool? confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirmer la suppression'),
                          content: Text(
                              'Voulez-vous vraiment supprimer ${vehicule.nom} (${vehicule.matricule}) ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text('Supprimer',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      await viewModel.deleteAutomobile(vehicule.id);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Supprimer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}