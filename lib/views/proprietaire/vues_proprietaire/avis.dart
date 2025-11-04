// lib/views/proprietaire/vues_proprietaire/avis.dart
import 'package:flutter/material.dart';

class AvisPage extends StatelessWidget {
  const AvisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laisser un avis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Laissez-nous votre avis et votre note. Vos retours nous aident à nous améliorer !',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Saisissez votre avis...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implémenter la logique pour soumettre l'avis
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Votre avis a été soumis avec succès !'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Soumettre l\'avis'),
            ),
          ],
        ),
      ),
    );
  }
}