import 'package:flutter/material.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/parametre_page.dart';
import 'package:provider/provider.dart';
import 'package:location_automobiles/viewmodel/compte_viewmodel.dart';
import 'connexion.dart'; // Assurez-vous que ce chemin est correct
import 'avis.dart'; // Le chemin vers votre page d'avis

class ComptePageProprietaire extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const ComptePageProprietaire({
    super.key,
    this.onTabSelected,
  });

  @override
  State<ComptePageProprietaire> createState() => _ComptePageProprietaireState();
}

class _ComptePageProprietaireState extends State<ComptePageProprietaire> {
  @override
  void initState() {
    super.initState();
    // Aucune logique de chargement ici car CompteViewModel gère déjà les écouteurs.
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation de Consumer pour écouter les changements dans CompteViewModel
    return Consumer<CompteViewModel>(
      builder: (context, compteViewModel, child) {
        if (compteViewModel.utilisateurActuel == null) {
          // Si aucun utilisateur n'est connecté, afficher le bouton de connexion
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Vous n\'êtes pas connecté.',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Naviguer vers la page de connexion et supprimer toutes les routes précédentes
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(selectedRole: ''),
                      ),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B132C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          );
        }

        // Si un utilisateur est connecté, afficher les informations du compte et les options
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF0B132C),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                compteViewModel.utilisateurActuel!.nom,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B132C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                compteViewModel.utilisateurActuel!.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              if (compteViewModel.utilisateurActuel!.numeroDeTelephone.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    compteViewModel.utilisateurActuel!.numeroDeTelephone,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 40),

              // Option pour l'historique des véhicules publiés
              ListTile(
                leading: const Icon(Icons.history, color: Color(0xFF0B132C)),
                title: const Text(
                  'Historique des véhicules publiés',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  // Appelle la fonction de changement d'onglet si elle est disponible
                  if (widget.onTabSelected != null) {
                    widget.onTabSelected!(1); // L'index 1 est la page des véhicules
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonction de navigation non disponible.'),
                      ),
                    );
                  }
                },
              ),
              const Divider(),

              // Option pour les paramètres du compte
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF0B132C)),
                title: const Text(
                  'Paramètres du compte',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ParametrePage(
                        utilisateur: compteViewModel.utilisateurActuel!,
                      ),
                    ),
                  );
                },
              ),
              const Divider(),

              // Option pour laisser un avis
              ListTile(
                leading: const Icon(Icons.star, color: Color(0xFF0B132C)),
                title: const Text(
                  'Laisser un avis',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AvisPage(),
                    ),
                  );
                },
              ),
              const Divider(),

              // Option de déconnexion
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Déconnexion',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                onTap: ()  {
                  // Appeler la méthode de déconnexion du ViewModel
                  compteViewModel.deconnecter();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vous avez été déconnecté.')),
                  );
                  // Naviguer vers la page de connexion et supprimer les autres routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(selectedRole: ''),
                    ),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}