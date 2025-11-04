// lib/screens/ajouter_moto/ajouter_moto2.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:location_automobiles/viewmodel/automobile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'ajouter_moto3.dart';


class AjouterMoto2 extends StatefulWidget {
  final Vehicule vehicule;

  const AjouterMoto2({super.key, required this.vehicule});

  @override
  State<AjouterMoto2> createState() => _AjouterMoto2State();
}

class _AjouterMoto2State extends State<AjouterMoto2> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController kilometrageController;
  late TextEditingController anneeCirculationController;
  late TextEditingController prixJourController;
  late TextEditingController prixSemaineController;
  late TextEditingController prixMoisController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    kilometrageController = TextEditingController(text: widget.vehicule.Kilometrage?.toString() ?? '');
    anneeCirculationController = TextEditingController(text: widget.vehicule.annee_mise_circulation?.toString() ?? '');
    prixJourController = TextEditingController(text: widget.vehicule.prix_jour?.toStringAsFixed(0) ?? '');
    prixSemaineController = TextEditingController(text: widget.vehicule.prix_semaine?.toStringAsFixed(0) ?? '');
    prixMoisController = TextEditingController(text: widget.vehicule.prix_mois?.toStringAsFixed(0) ?? '');
    descriptionController = TextEditingController(text: widget.vehicule.description ?? '');
  }

  @override
  void dispose() {
    kilometrageController.dispose();
    anneeCirculationController.dispose();
    prixJourController.dispose();
    prixSemaineController.dispose();
    prixMoisController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveAndExit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final automobileViewModel = Provider.of<AutomobileViewModel>(context, listen: false);
      final addVehicule = widget.vehicule.copyWith(
        Kilometrage: int.tryParse(kilometrageController.text) ?? 0,
        annee_mise_circulation: int.tryParse(anneeCirculationController.text) ?? 2000,
        prix_jour: double.tryParse(prixJourController.text) ?? 0.0,
        prix_semaine: double.tryParse(prixSemaineController.text) ?? 0.0,
        prix_mois: double.tryParse(prixMoisController.text) ?? 0.0,
        description: descriptionController.text.trim(),
        publication_statut: Publication_statut.nonPublie,
      );

      await automobileViewModel.addAutomobile(addVehicule);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Véhicule enregistré en tant que brouillon.')),
      );
      Navigator.pop(context, true);
    }
  }

  void _goToNextStep() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedVehicule = widget.vehicule.copyWith(
        Kilometrage: int.tryParse(kilometrageController.text) ?? 0,
        annee_mise_circulation: int.tryParse(anneeCirculationController.text) ?? 2000,
        prix_jour: double.tryParse(prixJourController.text) ?? 0.0,
        prix_semaine: double.tryParse(prixSemaineController.text) ?? 0.0,
        prix_mois: double.tryParse(prixMoisController.text) ?? 0.0,
        description: descriptionController.text.trim(),
        publication_statut: Publication_statut.nonPublie,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AjouterMoto3(vehicule: updatedVehicule),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une ${widget.vehicule.typeVehicule.toString().split('.').last} '),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: kilometrageController,
                decoration: const InputDecoration(
                  labelText: 'Kilométrage (km)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le kilométrage' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: anneeCirculationController,
                decoration: const InputDecoration(
                  labelText: 'Année de mise en circulation',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                validator: (value) => value!.isEmpty ? 'Veuillez entrer l\'année' : null,
              ),
              const SizedBox(height: 24.0),
              Text('Prix de location (FCFA)', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: prixJourController,
                decoration: const InputDecoration(labelText: 'Par jour', border: OutlineInputBorder(), prefixText: 'FCFA '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le prix par jour' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: prixSemaineController,
                decoration: const InputDecoration(labelText: 'Par semaine', border: OutlineInputBorder(), prefixText: 'FCFA '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le prix par semaine' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: prixMoisController,
                decoration: const InputDecoration(labelText: 'Par mois', border: OutlineInputBorder(), prefixText: 'FCFA '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le prix par mois' : null,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description du véhicule', alignLabelWithHint: true, border: OutlineInputBorder()),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (value) => value!.isEmpty ? 'Veuillez entrer une description' : null,
              ),
              const SizedBox(height: 32.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveAndExit,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text('Enregistrer et Quitter', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToNextStep,
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text('Suivant', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}