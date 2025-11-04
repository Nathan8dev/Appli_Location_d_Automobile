// lib/screens/Inscription_page2.dart
import 'package:flutter/material.dart';
import 'inscription_page3.dart'; // Importe la page suivante

class InscriptionPage2 extends StatefulWidget {
  final String phoneNumber;
  final String userRole;
  final String verificationCode; // Le code généré et passé depuis Inscription_page1

  const InscriptionPage2({
    Key? key,
    required this.phoneNumber,
    required this.userRole,
    required this.verificationCode,
  }) : super(key: key);

  @override
  State<InscriptionPage2> createState() => _InscriptionPage2State();
}

class _InscriptionPage2State extends State<InscriptionPage2> {
  late List<TextEditingController> _codeControllers;
  late List<FocusNode> _focusNodes;
  String _errorMessage = ''; // Pour afficher un message d'erreur si le code est incorrect

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(5, (index) => TextEditingController());
    _focusNodes = List.generate(5, (index) => FocusNode());

    // Affiche le message à l'utilisateur avec le code de vérification simulé au démarrage de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afficherMessageCodeVerification();
    });

    // Configure les écouteurs pour la saisie automatique et le déplacement du focus
    for (int i = 0; i < _codeControllers.length; i++) {
      _codeControllers[i].addListener(() {
        if (_codeControllers[i].text.length == 1) {
          if (i < _codeControllers.length - 1) {
            _focusNodes[i + 1].requestFocus(); // Déplace le focus au champ suivant
          } else {
            FocusScope.of(context).unfocus(); // Masque le clavier si c'est le dernier champ
            _verifierCode(); // Tente de vérifier le code
          }
        } else if (_codeControllers[i].text.isEmpty && i > 0) {
          _focusNodes[i - 1].requestFocus(); // Déplace le focus au champ précédent si le champ est vidé
        }
      });
    }
  }

  /// Affiche un dialogue pour informer l'utilisateur du code de vérification (pour la démo).
  void _afficherMessageCodeVerification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Code de Vérification Envoyé ✉️'),
          content: Text(
            'Un code de vérification à 5 chiffres a été "envoyé" à votre numéro : ${widget.phoneNumber}.\n\nPour la démonstration, le code est : **${widget.verificationCode}**.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
                _focusNodes[0].requestFocus(); // Met le focus sur le premier champ de saisie
              },
              child: const Text('Compris'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Libère les ressources des contrôleurs et des nœuds de focus
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Vérifie le code entré par l'utilisateur.
  void _verifierCode() {
    String enteredCode = _codeControllers.map((controller) => controller.text).join();

    if (enteredCode.length == 5) {
      if (enteredCode == widget.verificationCode) {
        setState(() {
          _errorMessage = ''; // Efface tout message d'erreur
        });
        print('Numéro de téléphone: ${widget.phoneNumber}');
        print('Code entré (vérifié): $enteredCode');
        print('Rôle de l\'utilisateur: ${widget.userRole}');

        // Navigue vers InscriptionPage3 si le code est correct
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InscriptionPage3(
              phoneNumber: widget.phoneNumber,
              verificationCode: enteredCode, // <--- C'EST LA LIGNE CLÉ MODIFIÉE ICI
              userRole: widget.userRole,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Code incorrect. Veuillez réessayer.';
        });
        _codeControllers.forEach((controller) => controller.clear()); // Efface les champs
        _focusNodes[0].requestFocus(); // Remet le focus sur le premier champ
      }
    } else {
      setState(() {
        _errorMessage = 'Veuillez entrer le code à 5 chiffres.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification du code'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Un code à 5 chiffres a été envoyé à votre numéro de téléphone. Veuillez l\'entrer ci-dessous.',
                style: TextStyle(fontSize: 18, color: Color(0xFF0B132C)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0B132C), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0B132C), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  );
                }),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Simule le renvoi du code en affichant le dialogue à nouveau
                  _afficherMessageCodeVerification();
                  _codeControllers.forEach((controller) => controller.clear());
                  _focusNodes[0].requestFocus();
                },
                child: const Text(
                  'Renvoyer le code',
                  style: TextStyle(color: Color(0xFF0B132C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}