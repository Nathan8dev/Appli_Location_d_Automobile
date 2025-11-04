// lib/views/connexion.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';
import 'package:location_automobiles/views/proprietaire/HomePage_proprietaire.dart';
import 'package:location_automobiles/views/client/HomePage_client.dart'; // Importez votre page d'accueil client

import '../../inscription_page1.dart';

class LoginPage extends StatefulWidget {
  final String selectedRole;

  const LoginPage({super.key, required this.selectedRole});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _performLogin() async {
    setState(() {
      _isLoading = true;
    });

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    bool success = await userViewModel.connecter(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (success) {
      // Utilisez le rôle de l'utilisateur réellement connecté
      final connectedUserRole = userViewModel.utilisateurActuel!.role;
      userViewModel.setRoleSelectionne(connectedUserRole); // Mettre à jour le rôle dans le ViewModel

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie en tant que $connectedUserRole')),
      );

      // Redirection basée sur le rôle de l'utilisateur connecté
      if (connectedUserRole == 'proprietaire') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePageProprietaire()),
              (Route<dynamic> route) => false,
        );
      } else if (connectedUserRole == 'client') { // Assurez-vous que le rôle est bien 'client' ici
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePageClient()), // Redirige vers HomePageClient
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rôle inconnu : $connectedUserRole. Redirection par défaut.')),
        );
        // Fallback si le rôle n'est pas reconnu (par exemple, vers la page propriétaire par défaut)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePageProprietaire()),
              (Route<dynamic> route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de la connexion. Vérifiez vos identifiants.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B132C),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Ajout du message "Connectez-vous ici" ---
              const Text(
                'Connectez-vous ici',
                style: TextStyle(
                  fontSize: 24, // Taille de police pour le message
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B132C), // Couleur pour correspondre à la barre d'application
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32), // Espacement après le message
              // --- Fin de l'ajout ---

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Ex: jean.dupont@example.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF0B132C))
                  : ElevatedButton(
                onPressed: _performLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B132C),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Se Connecter',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Inscription(userRole: 'client'),
                    ),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Pas encore de compte ? ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'S\'inscrire',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}