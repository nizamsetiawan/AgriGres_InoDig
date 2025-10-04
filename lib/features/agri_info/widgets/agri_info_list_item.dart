import 'package:flutter/material.dart';
import 'package:agrigres/features/agri_info/models/agri_info_model.dart';

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
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[200]!,
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
                        color: Colors.grey[800],
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 2),
                    
                    // Source
                    Text(
                      agriInfo.source,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.green[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.grey[400],
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
        return Colors.blue[50]!;
      case AgriInfoIconType.landUse:
        return Colors.orange[50]!;
    }
  }

  Color _getIconBorderColor() {
    switch (agriInfo.iconType) {
      case AgriInfoIconType.foodPrice:
        return Colors.blue[200]!;
      case AgriInfoIconType.landUse:
        return Colors.orange[200]!;
    }
  }

  Widget _buildIconContent() {
    switch (agriInfo.iconType) {
      case AgriInfoIconType.foodPrice:
        return Icon(
          Icons.analytics_outlined,
          color: Colors.blue[600],
          size: 20,
        );
      case AgriInfoIconType.landUse:
        return Icon(
          Icons.terrain_outlined,
          color: Colors.orange[600],
          size: 20,
        );
    }
  }
}
