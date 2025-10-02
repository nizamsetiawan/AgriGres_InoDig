import 'package:flutter/material.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/features/calculator/screens/widgets/calculator_form.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Kalkulator Pertanian'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            
            // Calculator Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Calculator Form
                    const TCalculatorForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 