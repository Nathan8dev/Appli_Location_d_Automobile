// lib/screens/Inscription_page1.dart
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:location_automobiles/views/proprietaire/vues_proprietaire/connexion.dart';

import 'inscription_page2.dart'; // Importe la page de vérification

class Inscription extends StatefulWidget {
  final String userRole; // Le rôle de l'utilisateur (ex: "particulier", "professionnel")

  const Inscription({super.key, required this.userRole});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final TextEditingController _controleurTelephone = TextEditingController();
  final GlobalKey<FormState> _cleFormulaire = GlobalKey<FormState>();
  String _codePaysSelectionne = '+237'; // Code pays par défaut (Cameroun)

  /// Génère et simule l'envoi d'un code de vérification à 5 chiffres.
  ///
  /// Dans une application réelle, cette fonction appellerait un service
  /// backend (ex: Firebase, Twilio) pour envoyer un SMS.
  String _genererEtEnvoyerCode(String numeroTelephone) {
    // Ceci est une simulation. En production, le code serait généré
    // par le backend et non par l'application client pour des raisons de sécurité.
    final String code = (10000 + DateTime.now().microsecondsSinceEpoch % 90000).toString().substring(0, 5);
    print('Simulation d\'envoi de SMS au $numeroTelephone avec le code : $code');
    // Ici, vous ajouteriez la logique réelle pour interagir avec un service d'envoi de SMS.
    return code;
  }

  /// Traite la soumission du numéro de téléphone.
  void _soumettreNumeroTelephone() {
    if (_cleFormulaire.currentState != null && _cleFormulaire.currentState!.validate()) {
      // Nettoie le numéro (supprime les espaces) et le combine avec le code pays
      String numeroTelephoneComplet = '$_codePaysSelectionne${_controleurTelephone.text.replaceAll(' ', '')}';

      // Génère et "envoie" le code de vérification simulé
      String codeVerification = _genererEtEnvoyerCode(numeroTelephoneComplet);

      // Navigue vers InscriptionPage2 en passant les informations nécessaires
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InscriptionPage2(
            phoneNumber: numeroTelephoneComplet,
            userRole: widget.userRole,
            verificationCode: codeVerification, // PASSE LE CODE DE VÉRIFICATION À LA PAGE 2
          ),
        ),
      );

      print('Numéro de téléphone soumis : $numeroTelephoneComplet, Rôle : ${widget.userRole}');
    } else {
      print("Validation du formulaire échouée ou currentState est null.");
    }
  }

  @override
  void dispose() {
    _controleurTelephone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _cleFormulaire,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Veuillez entrer votre numéro de téléphone',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _controleurTelephone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Numéro de Téléphone',
                    hintText: 'Ex: 6 00 00 00 00',
                    prefixIcon: CountryCodePicker(
                      onChanged: (CountryCode countryCode) {
                        setState(() {
                          _codePaysSelectionne = countryCode.dialCode!;
                        });
                      },
                      initialSelection: 'CM', // Sélection initiale (Cameroun)
                      favorite: const ['+237', 'CM'], // Pays favoris
                      showCountryOnly: false,
                      showFlag: true,
                      showFlagDialog: true,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    // Vous pouvez ajouter des validations plus spécifiques au format du numéro de téléphone ici.
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _soumettreNumeroTelephone,
                  child: const Text('Suivant'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Logique pour naviguer vers la page de connexion si nécessaire
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(selectedRole: widget.userRole)));
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Déjà inscrit? ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Connectez-vous',
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
      ),
    );
  }
}