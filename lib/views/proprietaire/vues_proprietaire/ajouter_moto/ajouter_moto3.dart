import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'ajouter_moto4.dart';

class AjouterMoto3 extends StatefulWidget {
  final Vehicule vehicule;

  const AjouterMoto3({super.key, required this.vehicule});

  @override
  State<AjouterMoto3> createState() => _AjouterMoto3State();
}

class _AjouterMoto3State extends State<AjouterMoto3> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomController;
  String? selectedTypeCarburant;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.vehicule.nom);
    selectedTypeCarburant = widget.vehicule.typeCarburant.isNotEmpty ? widget.vehicule.typeCarburant : null;
  }

  @override
  void dispose() {
    nomController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedVehicule = widget.vehicule.copyWith(
        nom: nomController.text.trim(),
        typeCarburant: selectedTypeCarburant ?? 'Essence',
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AjouterMoto4(vehicule: updatedVehicule),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une ${widget.vehicule.typeVehicule.toString().split('.').last}'),
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
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom du véhicule', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer le nom du véhicule' : null,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedTypeCarburant,
                decoration: const InputDecoration(labelText: 'Type de carburant', border: OutlineInputBorder()),
                items: <String>['Essence', 'Diesel', 'Électrique', 'Hybride'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                onChanged: (String? newValue) => setState(() => selectedTypeCarburant = newValue),
                validator: (value) => value == null ? 'Veuillez sélectionner le type de carburant' : null,
              ),
              const SizedBox(height: 32.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text('Précédent', style: TextStyle(fontSize: 18)),
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