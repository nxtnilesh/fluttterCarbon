import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/carbon_credit.dart';
import '../../providers/carbon_credit_provider.dart';
import '../../config/theme.dart';

class CreateCreditScreen extends StatefulWidget {
  const CreateCreditScreen({super.key});

  @override
  State<CreateCreditScreen> createState() => _CreateCreditScreenState();
}

class _CreateCreditScreenState extends State<CreateCreditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companySectorController = TextEditingController();
  final _creditsController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _verificationDocuments = [];

  @override
  void dispose() {
    _companyNameController.dispose();
    _companySectorController.dispose();
    _creditsController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createCredit() async {
    if (_formKey.currentState!.validate()) {
      final credit = CarbonCredit(
        id: '',
        companyName: _companyNameController.text.trim(),
        companySector: _companySectorController.text.trim(),
        credits: int.parse(_creditsController.text),
        pricePerCredit: double.parse(_priceController.text),
        description: _descriptionController.text.trim(),
        status: 'available',
        verificationStatus: 'pending',
        verificationDocuments: _verificationDocuments,
        sellerId: '',
      );

      await context.read<CarbonCreditProvider>().createCarbonCredit(credit);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final creditProvider = context.watch<CarbonCreditProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Carbon Credit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companySectorController,
                decoration: const InputDecoration(
                  labelText: 'Company Sector',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company sector';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Credits',
                  prefixIcon: Icon(Icons.numbers_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of credits';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per Credit',
                  prefixIcon: Icon(Icons.attach_money_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price per credit';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (creditProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    creditProvider.error!,
                    style: const TextStyle(color: AppTheme.errorColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                onPressed: creditProvider.isLoading ? null : _createCredit,
                child: creditProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Create Carbon Credit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 