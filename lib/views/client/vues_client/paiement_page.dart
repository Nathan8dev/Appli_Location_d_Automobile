import 'package:flutter/material.dart';
import 'package:location_automobiles/models/vehicule.dart';
import 'package:location_automobiles/models/reservation.dart';
import 'package:intl/intl.dart';

class PaiementPage extends StatefulWidget {
  final Vehicule vehicule;
  final Function(Reservation) onReservationConfirmed;

  const PaiementPage({
    super.key,
    required this.vehicule,
    required this.onReservationConfirmed,
  });

  @override
  State<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedPaymentMethod = '';
  double _totalPrice = 0.0;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final Map<String, IconData> _paymentMethods = {
    'Mobile Money': Icons.phone_android,
    'Orange Money': Icons.account_balance_wallet,
    'Carte de crédit': Icons.credit_card,
    'Transfert bancaire': Icons.account_balance,
  };

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 1));
    _calculatePrice();
  }

  void _calculatePrice() {
    if (_startDate != null && _endDate != null && _endDate!.isAfter(_startDate!)) {
      final difference = _endDate!.difference(_startDate!).inDays;
      setState(() {
        _totalPrice = widget.vehicule.prix_jour * difference.toDouble();
      });
    } else {
      setState(() {
        _totalPrice = widget.vehicule.prix_jour;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _calculatePrice();
      });
    }
  }

  void _confirmPayment() {
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un mode de paiement.')),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner des dates de réservation.')),
      );
      return;
    }

    final newReservation = Reservation(
      vehicule: widget.vehicule,
      nomLocataire: 'John Doe',
      emailLocataire: 'john.doe@example.com',
      telephoneLocataire: '123456789',
      lieuLivraison: 'Douala, Cameroun',
      dateDebut: _startDate!,
      dateFin: _endDate!,
      prixTotal: _totalPrice,
      methodePaiementChoisie: _selectedPaymentMethod,
      statut: StatutReservation.aVenir,
    );

    widget.onReservationConfirmed(newReservation);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Réservation effectuée avec succès !'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement et réservation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Résumé de la réservation',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildReservationSummaryCard(),
              const SizedBox(height: 32),
              Text(
                'Sélectionnez le mode de paiement',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._paymentMethods.entries.map((entry) {
                return _buildPaymentMethodTile(entry.key, entry.value);
              }).toList(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _confirmPayment,
                  icon: const Icon(Icons.payments),
                  label: const Text('Payer et réserver'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationSummaryCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.vehicule.image_vehicule != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.vehicule.image_vehicule!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.vehicule.marque} ${widget.vehicule.nom}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prix par jour: ${widget.vehicule.prix_jour} F CFA',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Période de location',
              value: _startDate != null && _endDate != null
                  ? '${_dateFormat.format(_startDate!)} - ${_dateFormat.format(_endDate!)}'
                  : 'Dates non sélectionnées',
              onTap: () => _selectDateRange(context),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prix total',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_totalPrice F CFA',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(value, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.end),
            ),
            if (onTap != null) const Icon(Icons.edit, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(String method, IconData icon) {
    final isSelected = _selectedPaymentMethod == method;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected ? BorderSide(color: Theme.of(context).primaryColor, width: 2) : BorderSide.none,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 30, color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700]),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    method,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }
}