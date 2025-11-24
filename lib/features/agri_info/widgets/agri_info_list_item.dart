import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/agri_info_model.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class AgriInfoListItem extends StatelessWidget {
  final AgriInfoModel agriInfo;
  final VoidCallback onTap;

  const AgriInfoListItem({
    super.key,
    required this.agriInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tagMaxWidth = MediaQuery.of(context).size.width * 0.55;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: TColors.borderSecondary,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              // Icon
              _buildIcon(),
              
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      agriInfo.title,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 2),
                    
                    // Source
                    Text(
                      agriInfo.source,
                      style: textTheme.bodySmall?.copyWith(
                        color: TColors.primary,
                        fontSize: 11,
                      ),
                    ),

                    if (agriInfo.resourceCount > 0 || agriInfo.identity.isNotEmpty)
                      const SizedBox(height: 4),

                    if (agriInfo.resourceCount > 0 || agriInfo.identity.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (agriInfo.resourceCount > 0)
                            _buildTag(
                              icon: Icons.dataset_outlined,
                              label: '${agriInfo.resourceCount} data',
                              maxWidth: tagMaxWidth,
                            ),
                          if (agriInfo.identity.isNotEmpty)
                            _buildTag(
                              icon: Icons.local_offer_outlined,
                              label: agriInfo.identity,
                              maxWidth: tagMaxWidth,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: TColors.textSecondary.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getIconBorderColor(),
          width: 1,
        ),
      ),
      child: Center(
        child: _buildIconContent(),
      ),
    );
  }

  Color _getIconBackgroundColor() {
    switch (agriInfo.iconType) {
      case AgriInfoIconType.foodPrice:
        return TColors.secondary.withOpacity(0.12);
      case AgriInfoIconType.landUse:
        return TColors.primary.withOpacity(0.1);
      case AgriInfoIconType.plantation:
        return TColors.primary.withOpacity(0.06);
    }
  }

  Color _getIconBorderColor() {
    switch (agriInfo.iconType) {
      case AgriInfoIconType.foodPrice:
        return TColors.secondary.withOpacity(0.4);
      case AgriInfoIconType.landUse:
        return TColors.primary.withOpacity(0.35);
      case AgriInfoIconType.plantation:
        return TColors.primary.withOpacity(0.25);
    }
  }

  Widget _buildIconContent() {
    switch (agriInfo.iconType) {
      case AgriInfoIconType.foodPrice:
        return Icon(
          Icons.analytics_outlined,
          color: TColors.secondary,
          size: 20,
        );
      case AgriInfoIconType.landUse:
        return Icon(
          Icons.terrain_outlined,
          color: TColors.primary,
          size: 20,
        );
      case AgriInfoIconType.plantation:
        return Icon(
          Icons.grass,
          color: TColors.primary,
          size: 20,
        );
    }
  }

  Widget _buildTag({
    required IconData icon,
    required String label,
    double? maxWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: TColors.softGrey,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: TColors.borderPrimary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: TColors.textSecondary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: TColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
