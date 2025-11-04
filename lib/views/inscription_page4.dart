// lib/screens/Inscription_page4.dart
import 'package:flutter/material.dart';
import 'package:location_automobiles/models/user.dart';        // Importez votre modèle User
import 'package:location_automobiles/viewmodel/user_viewmodel.dart'; // Importation corrigée pour UserViewModel
import 'package:location_automobiles/views/client/HomePage_client.dart';
import 'package:location_automobiles/views/proprietaire/HomePage_proprietaire.dart';      // Importez votre HomePageClient

class InscriptionPage4 extends StatefulWidget {
  final String phoneNumber;
  final String verificationCode; // Ce code n'est généralement pas stocké mais est ici pour le suivi du flux
  final String name;
  final String email;
  final String userRole; // Le rôle de l'utilisateur (client/proprietaire)

  const InscriptionPage4({
    Key? key,
    required this.phoneNumber,
    required this.verificationCode,
    required this.name,
    required this.email,
    required this.userRole,
  }) : super(key: key);

  @override
  State<InscriptionPage4> createState() => _InscriptionPage4State();
}

class _InscriptionPage4State extends State<InscriptionPage4> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true; // Pour basculer la visibilité du mot de passe (TRUE = HIDDEN)
  bool _obscureConfirmPassword = true; // Pour basculer la visibilité de la confirmation (TRUE = HIDDEN)
  bool _isLoading = false; // Indicateur pour l'état de chargement lors de l'enregistrement

  /// Soumet les mots de passe et tente d'enregistrer l'utilisateur.
  void _submitPasswords() async {
    // Valide le formulaire (vérifie les champs et les correspondances de mot de passe)
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Active l'indicateur de chargement
      });

      String password = _passwordController.text;

      try {
        // Accéder à l'instance unique de UserViewModel via son singleton
        final userViewModel = UserViewModel(); // <--- Accès au singleton

        // 🌟 ÉTAPE CLÉ : Enregistrer l'utilisateur via le UserViewModel
        // Nous appelons la méthode `enregistrer` de votre UserViewModel.
        final Utilisateur? registeredUser = await userViewModel.enregistrer( // <--- Appel à la méthode `enregistrer` du ViewModel
          nom: widget.name,
          email: widget.email,
          numeroDeTelephone: widget.phoneNumber,
          role: widget.userRole,
          motDePasse: password,
        );

        setState(() {
          _isLoading = false; // Désactive l'indicateur de chargement
        });

        if (registeredUser != null) {
          // L'enregistrement a réussi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Compte ${registeredUser.role} créé avec succès pour ${registeredUser.nom}!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // Navigue vers la page d'accueil appropriée en fonction du rôle
          // et supprime toutes les routes précédentes de la pile de navigation.
          Widget nextPage;
          if (registeredUser.role == 'client') {
            nextPage = const HomePageClient();
          } else { // Assumer que tout autre rôle est 'proprietaire' ou géré comme tel
            nextPage = const HomePageProprietaire();
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
                (Route<dynamic> route) => false, // Cette fonction renvoie toujours false, vidant la pile
          );
        } else {
          // L'enregistrement a échoué (par exemple, erreur serveur, email déjà utilisé, etc.)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Échec de l\'inscription. Cet email est peut-être déjà utilisé ou une erreur est survenue.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        // Gérer les erreurs inattendues lors de l'appel au service (ex: pas de connexion internet)
        setState(() {
          _isLoading = false; // Désactive l'indicateur de chargement même en cas d'erreur
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Une erreur est survenue: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
        print('Erreur lors de l\'enregistrement: $e');
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création de mot de passe'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Message de bienvenue avec le nom de l'utilisateur
                Text(
                  'Bienvenue, ${widget.name}! Veuillez créer un mot de passe sécurisé.',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Champ de saisie du mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword, // Cache/affiche le texte
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Minimum 6 caractères',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility, // <-- CORRECTION ICI
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit avoir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Champ de confirmation du mot de passe
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword, // Cache/affiche le texte
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    hintText: 'Confirmez votre mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, // <-- CORRECTION ICI
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                // Bouton d'inscription, affichant un indicateur de chargement si _isLoading est vrai
                _isLoading
                    ? const CircularProgressIndicator() // Indicateur de chargement
                    : ElevatedButton(
                  onPressed: _submitPasswords,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('S\'inscrire'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}