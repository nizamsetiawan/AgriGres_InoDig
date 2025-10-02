import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class TCalculatorForm extends StatelessWidget {
  const TCalculatorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kalkulator Usaha Pertanian',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Masukkan Data Aktual Sesuai dengan Lahan Anda.',
          style: textTheme.bodyMedium,
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        // Form Fields
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.category),
            labelText: 'Jenis Tanaman',
            hintText: 'Contoh: Padi, Jagung, Cabai',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.map),
            labelText: 'Luas Lahan (hektar)',
            hintText: 'Contoh: 2',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.money),
            labelText: 'Biaya Pengolahan Lahan per ha (Rp)',
            hintText: 'Contoh: 1.500.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.safe_home),
            labelText: 'Biaya Bibit per ha (Rp)',
            hintText: 'Contoh: 800.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.health),
            labelText: 'Biaya Pupuk dan Obat per ha (Rp)',
            hintText: 'Contoh: 1.200.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.people),
            labelText: 'Biaya Tenaga Kerja per ha (Rp)',
            hintText: 'Contoh: 2.000.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.weight),
            labelText: 'Hasil Panen per ha (kg)',
            hintText: 'Contoh: 6.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.money_recive),
            labelText: 'Harga Jual per kg (Rp)',
            hintText: 'Contoh: 5.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.calendar),
            labelText: 'Siklus Tanam (hari)',
            hintText: 'Contoh: 100',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        // Calculate Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Hitung',
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 