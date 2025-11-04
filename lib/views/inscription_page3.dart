// lib/screens/Inscription_page3.dart
import 'package:flutter/material.dart';

import 'inscription_page4.dart';

class InscriptionPage3 extends StatefulWidget {
  final String phoneNumber;
  final String verificationCode;
  final String userRole; // <-- NOUVEAU: Accepte le rôle de InscriptionPage2

  const InscriptionPage3({
    Key? key,
    required this.phoneNumber,
    required this.verificationCode,
    required this.userRole, // <-- NOUVEAU: Constructeur mis à jour
  }) : super(key: key);

  @override
  State<InscriptionPage3> createState() => _InscriptionPage3State();
}

class _InscriptionPage3State extends State<InscriptionPage3> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitProfileInfo() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;

      print('Nom entré: $name');
      print('Email entré: $email');
      print('Numéro de téléphone (reçu): ${widget.phoneNumber}');
      print('Code de vérification (reçu): ${widget.verificationCode}');
      print('Rôle de l\'utilisateur: ${widget.userRole}'); // Debug

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InscriptionPage4(
            phoneNumber: widget.phoneNumber,
            verificationCode: widget.verificationCode,
            name: name,
            email: email,
            userRole: widget.userRole, // <-- NOUVEAU: Passe le rôle à InscriptionPage4
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations Personnelles'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Veuillez entrer votre nom et votre adresse email.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF0B132C)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Entrez votre nom...',
                    hintText: 'Ex: Jean Dupont',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Entrez votre Email..',
                    hintText: 'Ex: jean.dupont@exemple.com',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitProfileInfo,
                  child: const Text('Suivant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}