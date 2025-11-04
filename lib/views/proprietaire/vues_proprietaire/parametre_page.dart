// lib/views/proprietaire/parametre_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location_automobiles/models/user.dart'; // Importe Utilisateur
import 'package:location_automobiles/viewmodel/compte_viewmodel.dart';

class ParametrePage extends StatefulWidget {
  final Utilisateur utilisateur; // Reçoit l'objet Utilisateur

  const ParametrePage({super.key, required this.utilisateur});

  @override
  State<ParametrePage> createState() => _ParametrePageState();
}

class _ParametrePageState extends State<ParametrePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final TextEditingController _newPasswordController = TextEditingController(); // Pour le nouveau mot de passe

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.utilisateur.nom);
    _emailController = TextEditingController(text: widget.utilisateur.email);
    _phoneController = TextEditingController(text: widget.utilisateur.numeroDeTelephone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _sauvegarderChangements() async {
    final compteViewModel = Provider.of<CompteViewModel>(context, listen: false);

    // Vérification basique si l'email ou le téléphone sont vides
    if (_emailController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L\'email et le numéro de téléphone ne peuvent pas être vides.')),
      );
      return;
    }

    await compteViewModel.mettreAJourUtilisateur(
      nom: _nameController.text,
      email: _emailController.text,
      numeroDeTelephone: _phoneController.text,
      nouveauMotDePasse: _newPasswordController.text.isNotEmpty
          ? _newPasswordController.text
          : null, // Passe le nouveau mot de passe s'il est non vide
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour avec succès!')),
    );
    Navigator.of(context).pop(); // Retour à la page précédente après la mise à jour
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres du Compte', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B132C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rôle: ${widget.utilisateur.role.toUpperCase()}',
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              const Divider(height: 30),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),

              // Champ pour changer le mot de passe
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe (laisser vide pour ne pas changer)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _sauvegarderChangements,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B132C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sauvegarder les changements',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}