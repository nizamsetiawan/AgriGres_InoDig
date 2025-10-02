import 'package:flutter/material.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class TForumPostsList extends StatelessWidget {
  const TForumPostsList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forum Tani',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Wide selection of doctor\'s specialties',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        
        // Forum Posts
        _buildForumPost(
          context,
          'Imam Farrhouk',
          '20 Agus 2022',
          'We are facing a serious business dilemma, with Facebook taking away a good chunk of traffic to news and content sites, and ad blockers eating into what\'s left of it while slashing ad revenues.',
          hasComment: false,
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        _buildForumPost(
          context,
          'Imam Farrhouk',
          '20 Agus 2022',
          'We are facing a serious business dilemma, with Facebook taking away a good chunk of traffic to news and content sites, and ad blockers eating into what\'s left of it while slashing ad revenues.',
          hasComment: true,
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        _buildForumPost(
          context,
          'Imam Farrhouk',
          '20 Agus 2022',
          'We are facing a serious business dilemma, with Facebook taking away a good chunk of traffic to news and content sites, and ad blockers eating into what\'s left of it while slashing ad revenues.',
          hasComment: true,
        ),
      ],
    );
  }

  Widget _buildForumPost(
    BuildContext context,
    String author,
    String date,
    String content,
    {bool hasComment = false}
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              Text(
                date,
                style: textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: textTheme.bodyMedium,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                color: Colors.red[400],
                size: 20,
              ),
              const SizedBox(width: 16),
              if (hasComment) ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Write a comment',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ] else
                Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.grey[400],
                  size: 20,
                ),
            ],
          ),
        ],
      ),
    );
  }
} 