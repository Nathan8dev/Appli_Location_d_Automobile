// Fichier : lib/views/client/vues_client/compte_client.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';
import 'package:location_automobiles/views/role_selection.dart'; // Pour la déconnexion
import 'package:location_automobiles/views/client/vues_client/modifier_profil_client.dart'; // Importez le nouveau widget

class compte_client extends StatelessWidget {
  const compte_client({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation d'un Consumer pour écouter les changements du UserViewModel
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        final user = userViewModel.utilisateurActuel;

        // Gère le cas où l'utilisateur n'est pas connecté
        if (user == null) {
          return const Center(child: Text('Veuillez vous connecter pour voir votre profil.'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mon Profil'),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/user_avatar.png'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.nom, // Données dynamiques du ViewModel
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email, // Données dynamiques du ViewModel
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: const Text('Modifier le profil'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigue vers la page de modification du profil
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ModifierProfilClient(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.green),
                    title: const Text('Méthodes de paiement'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Page de gestion des paiements...')));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: Colors.orange),
                    title: const Text('Aide et support'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Page d\'aide et support...')));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Déconnexion'),
                    onTap: () async {
                      // Appel de la méthode de déconnexion du ViewModel
                      await userViewModel.deconnecter();
                      // Navigue vers la page de sélection de rôle et supprime toutes les routes précédentes
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}