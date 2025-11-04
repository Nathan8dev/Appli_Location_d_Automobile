import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location_automobiles/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'inscription_page1.dart';


class LandingPage extends StatefulWidget {
  final String selectedRole;

  const LandingPage({super.key, required this.selectedRole});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<String> _imagePaths = [
    'assets/images/img1.png',
    'assets/images/accueil_client.png',
    'assets/images/accueil_proprio.png',
    'assets/images/gerer_auto.png',
    'assets/images/reserver.png',
  ];

  final PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Cela garantit que le rôle est globalement accessible pour les pages de connexion/inscription.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Accéder à l'instance de UserViewModel fournie par Provider
      Provider.of<UserViewModel>(context, listen: false)
          .setRoleSelectionne(widget.selectedRole);
    });
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue sur LockNat!'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          // 1. Le carrousel d'images en arrière-plan
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  _imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          ),

          // Optionnel: Un dégradé sombre par-dessus les images pour améliorer la lisibilité du texte
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Indicateurs de page (les petits points)
          Positioned(
            bottom: 150, // Ajustez cette valeur pour positionner les points au-dessus du texte et du bouton unique
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_imagePaths.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: _currentPage == index ? 24.0 : 8.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),
          ),

          // 2. Le contenu textuel superposé au centre
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Bienvenue cher ${widget.selectedRole == 'client' ? 'client' : 'propriétaire'} !',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Découvrez nos services de location d\'automobile et de gestion.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Le bouton "Commencer" tout en bas de la page
          Positioned(
            bottom: 30, // Distance du bas de l'écran
            left: 24, // Marge latérale
            right: 24, // Marge latérale
            child: ElevatedButton(
              onPressed: () {
                // Naviguer vers la page d'inscription avec le rôle sélectionné
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Inscription(userRole: widget.selectedRole),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Fond blanc
                foregroundColor: Colors.black, // Texte noir
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Commencer'), // Le texte reste "Commencer"
            ),
          ),
        ],
      ),
    );
  }
}