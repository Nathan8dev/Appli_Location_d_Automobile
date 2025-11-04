// Fichier : lib/views/client/vues_client/modifier_profil_client.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';

class ModifierProfilClient extends StatefulWidget {
  const ModifierProfilClient({super.key});

  @override
  State<ModifierProfilClient> createState() => _ModifierProfilClientState();
}

class _ModifierProfilClientState extends State<ModifierProfilClient> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _emailController;
  late final TextEditingController _telephoneController;

  @override
  void initState() {
    super.initState();
    // Récupère l'utilisateur actuel pour pré-remplir les champs
    final user = Provider.of<UserViewModel>(context, listen: false).utilisateurActuel;

    // Initialise les contrôleurs avec les données de l'utilisateur
    _nomController = TextEditingController(text: user?.nom);
    _emailController = TextEditingController(text: user?.email);
    _telephoneController = TextEditingController(text: user?.numeroDeTelephone);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  void _submitUpdate() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      try {
        await userViewModel.mettreAJourUtilisateurActuel(
          nom: _nomController.text,
          email: _emailController.text,
          numeroDeTelephone: _telephoneController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès !')),
        );
        Navigator.of(context).pop(); // Revient à la page précédente
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro de téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitUpdate,
                child: const Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}