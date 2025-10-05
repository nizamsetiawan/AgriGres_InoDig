import 'package:flutter/material.dart';

class FeaturedContentWidget extends StatelessWidget {
  const FeaturedContentWidget({Key? key}) : super(key: key);

  // Featured content data
  static final List<Map<String, dynamic>> _featuredContent = [
    {
      'title': 'Kursus Pertanian Terlengkap',
      'subtitle': 'Pelajari semua aspek pertanian dari 10 channel terbaik',
      'thumbnail': 'https://i.ytimg.com/vi/sample/maxresdefault.jpg',
      'channel': 'Mitra Pertanian',
      'duration': '2 jam',
      'level': 'Pemula',
      'rating': 4.8,
      'students': '10K+',
      'color': Colors.green,
    },
    {
      'title': 'Teknologi Pertanian Modern',
      'subtitle': 'AI, IoT, dan teknologi terbaru untuk pertanian',
      'thumbnail': 'https://i.ytimg.com/vi/sample2/maxresdefault.jpg',
      'channel': 'AgriTech Indonesia',
      'duration': '1.5 jam',
      'level': 'Menengah',
      'rating': 4.9,
      'students': '5K+',
      'color': Colors.blue,
    },
    {
      'title': 'Hidroponik untuk Pemula',
      'subtitle': 'Panduan lengkap hidroponik dari nol',
      'thumbnail': 'https://i.ytimg.com/vi/sample3/maxresdefault.jpg',
      'channel': 'Hidroponik Pro',
      'duration': '3 jam',
      'level': 'Pemula',
      'rating': 4.7,
      'students': '8K+',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Konten Unggulan',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all featured content
                  print('Lihat semua konten unggulan');
                },
                child: Text(
                  'Lihat Semua',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _featuredContent.length,
              itemBuilder: (context, index) {
                final content = _featuredContent[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < _featuredContent.length - 1 ? 12 : 0,
                  ),
                  child: _buildFeaturedCard(context, content),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Map<String, dynamic> content) {
    final textTheme = Theme.of(context).textTheme;
    final color = content['color'] as Color;
    
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to content detail
        print('Featured content tapped: ${content['title']}');
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background image placeholder
              Container(
                width: double.infinity,
                height: double.infinity,
                color: color.withOpacity(0.1),
                child: Icon(
                  Icons.play_circle_outline,
                  size: 60,
                  color: color.withOpacity(0.3),
                ),
              ),
              
              // Gradient overlay
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content['title'],
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content['subtitle'],
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              content['level'],
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${content['rating']}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${content['students']}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Play button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
