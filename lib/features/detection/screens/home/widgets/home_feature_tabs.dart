import 'package:flutter/material.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_menu_grid.dart';
import 'package:agrigres/features/detection/screens/home/widgets/home_categories.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class THomeFeatureTabs extends StatefulWidget {
  const THomeFeatureTabs({super.key});

  @override
  State<THomeFeatureTabs> createState() => _THomeFeatureTabsState();
}

class _THomeFeatureTabsState extends State<THomeFeatureTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const primary = TColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TColors.borderSecondary),
        boxShadow: [
          BoxShadow(
            color: TColors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eksplorasi Cepat',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: TColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Menu dan artikel favorit dalam satu tempat',
            style: textTheme.bodySmall?.copyWith(color: TColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              2,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 8 : 0, left: index == 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? primary
                            : TColors.softGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        index == 0 ? 'Menu Utama' : 'Kategori Artikel',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              _currentIndex == index ? TColors.white : TColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _currentIndex == 0
                ? const THomeMenuGrid(
                    key: ValueKey('menu_grid'),
                    showHeader: false,
                  )
                : const THomeCategories(
                    key: ValueKey('categories'),
                    showHeader: false,
                  ),
          ),
        ],
      ),
    );
  }
}

