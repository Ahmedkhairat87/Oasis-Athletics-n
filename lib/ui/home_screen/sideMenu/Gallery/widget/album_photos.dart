import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oasisathletic/core/model/sideMenu/gallary/extensions/photo_preview_extensions.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/Gallery/widget/photo_preview.dart';

import '../../../../../core/model/sideMenu/gallary/albumPhotos/PhotoData.dart';
import '../../../../../core/reusable_components/app_background.dart';
import '../../../../../core/services/sideMenu/galleryServices/galleryServices.dart';

class AlbumPhotos extends StatefulWidget {
  final String albumName;
  final num eventSer;

  const AlbumPhotos({
    super.key,
    required this.albumName,
    required this.eventSer,
  });

  @override
  State<AlbumPhotos> createState() => _AlbumPhotosState();
}

class _AlbumPhotosState extends State<AlbumPhotos> {
  bool loading = true;
  List<PhotoData> photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    setState(() => loading = true);

    final result = await GalleryService.getAlbumPhotos(widget.eventSer.toInt());

    if (!mounted) return;

    setState(() {
      photos = result; // 🔥 backend truth
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.albumName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child:
            loading
                ? const Center(child: CircularProgressIndicator())
                : photos.isEmpty
                ? const Center(child: Text('No photos available'))
                : MasonryGridView.count(
                  padding: const EdgeInsets.all(12),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: photos.length,
                  itemBuilder: (_, index) {
                    final photo = photos[index];
                    return GestureDetector(
                      onTap: () async {
                        final updated = await showPhotoPreview(
                          context,
                          photo.previewVM,
                          fromCart: false,
                        );

                        if (updated == true) {
                          setState(() {
                            photos[index].markRequested(); // 🔥 local only
                          });
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          photo.sphoto ?? '',
                          headers: const {'Cache-Control': 'no-cache'},
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stack) {
                            return const Icon(Icons.broken_image, size: 40);
                          },
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
