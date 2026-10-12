
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../models/property.dart';
import '../services/property_service.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PropertyService();

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _area = TextEditingController();
  final _bedrooms = TextEditingController();
  final _bathrooms = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();

  String _propertyType = 'Apartment';
  String _listingType = 'Sale';
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _area.dispose();
    _bedrooms.dispose();
    _bathrooms.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _pincode.dispose();
    super.dispose();
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }

          return null;
        },
      ),
    );
  }

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_price.text.trim());
    final area = double.tryParse(_area.text.trim());

    if (price == null || price < 0 || area == null || area < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid price and area'),
        ),
      );
      return;
    }

    final bedrooms = int.tryParse(_bedrooms.text.trim());
    final bathrooms = int.tryParse(_bathrooms.text.trim());

    if ((_bedrooms.text.trim().isNotEmpty &&
            (bedrooms == null || bedrooms < 0)) ||
        (_bathrooms.text.trim().isNotEmpty &&
            (bathrooms == null || bathrooms < 0))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid bedroom and bathroom counts'),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final property = Property(
        title: _title.text.trim(),
        description: _description.text.trim(),
        propertyType: _propertyType,
        listingType: _listingType,
        price: price,
        area: area,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        address: _address.text.trim(),
        city: _city.text.trim(),
        state: _state.text.trim(),
        pincode: _pincode.text.trim(),
        status: 'AVAILABLE',
      );

      await _service.createProperty(property);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Property added successfully'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add property: ${ApiClient.errorMessage(e)}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field('Property title', _title),
              _field('Description', _description),
              DropdownButtonFormField<String>(
                initialValue: _propertyType,
                decoration: const InputDecoration(
                  labelText: 'Property type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  'Apartment',
                  'House',
                  'Villa',
                  'Plot',
                  'Commercial',
                ].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _propertyType = value);
                  }
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _listingType,
                decoration: const InputDecoration(
                  labelText: 'Listing type',
                  border: OutlineInputBorder(),
                ),
                items: const ['Sale', 'Rent'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _listingType = value);
                  }
                },
              ),
              const SizedBox(height: 14),
              _field(
                'Price',
                _price,
                keyboardType: TextInputType.number,
              ),
              _field(
                'Area',
                _area,
                keyboardType: TextInputType.number,
              ),
              _field(
                'Bedrooms',
                _bedrooms,
                keyboardType: TextInputType.number,
                required: false,
              ),
              _field(
                'Bathrooms',
                _bathrooms,
                keyboardType: TextInputType.number,
                required: false,
              ),
              _field('Address', _address),
              _field('City', _city),
              _field('State', _state),
              _field('Pincode', _pincode),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _loading ? null : _saveProperty,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('SAVE PROPERTY'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
