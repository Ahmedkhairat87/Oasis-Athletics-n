import 'package:flutter/material.dart';
import '../../../../core/reusable_components/app_background.dart';
import 'photo_preview.dart';

class AlbumPhotos extends StatelessWidget {
  final String albumName;
  const AlbumPhotos({super.key, required this.albumName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(albumName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 3,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder:
              (_, i) => GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => PhotoPreview(
                              photoId: '$albumName-$i',
                              album: albumName,
                            ),
                      ),
                    ),
                child: Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
        ),
      ),
    );
  }
}
