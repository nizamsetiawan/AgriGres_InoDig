import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/utils/constraints/colors.dart';

import '../../../../utils/constraints/text_strings.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          "Panduan Penggunaan",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    TTexts.guidelinesTitle,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                _buildStepSection(
                  context,
                  textTheme,
                  "1",
                  TTexts.step1Title,
                  TTexts.step1Description,
                ),
                const SizedBox(height: 16),

                _buildStepSection(
                  context,
                  textTheme,
                  "2",
                  TTexts.step2Title,
                  TTexts.step2Description,
                ),
                const SizedBox(height: 16),

                _buildStepSection(
                  context,
                  textTheme,
                  "3",
                  TTexts.step3Title,
                  TTexts.step3Description,
                ),
                const SizedBox(height: 16),

                _buildStepSection(
                  context,
                  textTheme,
                  "4",
                  TTexts.step4Title,
                  TTexts.step4Description,
                ),
                const SizedBox(height: 16),

                _buildStepSection(
                  context,
                  textTheme,
                  "5",
                  TTexts.step5Title,
                  TTexts.step5Description,
                ),
                const SizedBox(height: 16),

                _buildStepSection(
                  context,
                  textTheme,
                  "ℹ️",
                  TTexts.additionalFeatureHistoryTitle,
                  TTexts.additionalFeatureHistoryDescription,
                ),
                const SizedBox(height: 16),

                _buildStepSection(
                  context,
                  textTheme,
                  "📚",
                  TTexts.additionalFeatureArticleTitle,
                  TTexts.additionalFeatureArticleDescription,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepSection(BuildContext context, TextTheme textTheme, String stepNumber, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Number/Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
