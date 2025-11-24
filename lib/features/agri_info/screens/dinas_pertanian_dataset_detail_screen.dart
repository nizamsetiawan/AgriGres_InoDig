import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/agri_info/models/dinas_pertanian_dataset_model.dart';
import 'package:agrigres/features/agri_info/screens/dinas_pertanian_resource_screen.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class DinasPertanianDatasetDetailScreen extends StatelessWidget {
  final DinasPertanianDatasetModel dataset;

  const DinasPertanianDatasetDetailScreen({
    super.key,
    required this.dataset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.light,
      appBar: TAppBar(
        title: Text(
          dataset.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: TSizes.spaceBtwSections),
            Text(
              'Daftar Resource (${dataset.resources.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            ...dataset.resources.map((resource) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ResourceCard(
                  title: resource.title,
                  subtitle: resource.fieldsPreview.isEmpty
                      ? 'Preview data belum tersedia'
                      : '${resource.fieldsPreview.length} kolom contoh data',
                  onTap: () {
                    Get.to(
                      () => DinasPertanianResourceScreen(
                        dataset: dataset,
                        resource: resource,
                      ),
                    );
                  },
                ),
              );
            }),
            if (dataset.resources.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TColors.borderSecondary),
                ),
                child: const Text(
                  'Belum ada resource yang dapat ditampilkan.',
                  style: TextStyle(color: TColors.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataset.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TColors.textPrimary,
                ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.badge_outlined, size: 14, color: TColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  dataset.identity.isNotEmpty
                      ? dataset.identity
                      : 'dataset-${dataset.datasetId.substring(0, 6)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: TColors.textSecondary, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMiniDiagram(context),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.dataset_outlined, color: TColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dataset ini memiliki ${dataset.resources.length} resource '
                    'yang siap dipreview langsung di aplikasi.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: TColors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDiagram(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final shortId = dataset.datasetId.isNotEmpty
        ? dataset.datasetId.substring(
            0,
            dataset.datasetId.length > 4 ? 4 : dataset.datasetId.length,
          ).toUpperCase()
        : '-';

    return Row(
      children: [
        Expanded(
          child: _DiagramTile(
            icon: Icons.dataset_outlined,
            label: 'Resource',
            value: dataset.resources.length.toString().padLeft(2, '0'),
            color: TColors.primary.withOpacity(0.08),
            textColor: TColors.primary,
            textTheme: textTheme,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _DiagramTile(
            icon: Icons.fingerprint,
            label: 'Dataset ID',
            value: shortId,
            color: TColors.secondary.withOpacity(0.1),
            textColor: TColors.secondary,
            textTheme: textTheme,
          ),
        ),
      ],
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ResourceCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insert_drive_file_outlined,
                    color: TColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: TColors.textPrimary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: TColors.textSecondary.withOpacity(0.5),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.textSecondary,
                      fontSize: 11,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiagramTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color textColor;
  final TextTheme textTheme;

  const _DiagramTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(height: 6),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: textColor.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}


