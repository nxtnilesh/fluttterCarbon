import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/carbon_credit.dart';
import '../../providers/carbon_credit_provider.dart';
import '../../config/theme.dart';

class CarbonCreditsScreen extends StatefulWidget {
  const CarbonCreditsScreen({super.key});

  @override
  State<CarbonCreditsScreen> createState() => _CarbonCreditsScreenState();
}

class _CarbonCreditsScreenState extends State<CarbonCreditsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarbonCreditProvider>().fetchCarbonCredits();
    });
  }

  Future<void> _buyCredits(CarbonCredit credit) async {
    final creditsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buy Carbon Credits'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: creditsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of Credits',
              prefixIcon: Icon(Icons.numbers_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter number of credits';
              }
              final credits = int.tryParse(value);
              if (credits == null) {
                return 'Please enter a valid number';
              }
              if (credits > credit.credits) {
                return 'Not enough credits available';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                print(credit.id);
                await context
                    .read<CarbonCreditProvider>()
                    .buyCarbonCredit(credit.id, int.parse(creditsController.text));
              }
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final creditProvider = context.watch<CarbonCreditProvider>();
    print("Credit Provider: ${creditProvider.credits}");
    if (creditProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (creditProvider.error != null) {
      return Center(
        child: Text(
          creditProvider.error!,
          style: const TextStyle(color: AppTheme.errorColor),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (creditProvider.credits.isEmpty) {
      return const Center(
        child: Text('No carbon credits available'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => creditProvider.fetchCarbonCredits(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: creditProvider.credits.length,
        itemBuilder: (context, index) {
          final credit = creditProvider.credits[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        credit.companyName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: credit.status == 'available'
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          credit.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    credit.companySector,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credits Available',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            credit.credits.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Price per Credit',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            NumberFormat.currency(
                              symbol: '\$',
                              decimalDigits: 2,
                            ).format(credit.pricePerCredit),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    credit.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  if (credit.status == 'available')
                    ElevatedButton(
                      onPressed: () => _buyCredits(credit),
                      child: const Text('Buy Credits'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 