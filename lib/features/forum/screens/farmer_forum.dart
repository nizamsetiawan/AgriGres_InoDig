import 'package:flutter/material.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/features/forum/screens/widgets/forum_header.dart';
import 'package:agrigres/features/forum/screens/widgets/forum_search_bar.dart';
import 'package:agrigres/features/forum/screens/widgets/forum_posts_list.dart';
import 'package:new_ui_kit/new_ui_kit.dart';

import '../../../common/widgets/appbar/appbar.dart';

class FarmerForum extends StatelessWidget {
  const FarmerForum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Forum Petani'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            
            // Sticky Search Bar
            SliverAppBar(
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TForumSearchBar(),
              ),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
            ),

            
            // Forum Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Forum Posts List
                    const TForumPostsList(),

                    const SizedBox(height: TSizes.spaceBtwSections),


                    // Add Question Button
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
                          'Ajukan Pertanyaan',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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