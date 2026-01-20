import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/model/sideMenu/gallary/albumsModels/albumData.dart';
import '../../../../core/reusable_components/app_background.dart';
import '../../../../core/services/sideMenu/galleryServices/galleryServices.dart';
import 'widget/provider/cart_provider.dart';
import 'widget/album_photos.dart';

class GalleryAlbums extends StatefulWidget {
  static const routeName = '/gallery';

  const GalleryAlbums({super.key});

  @override
  State<GalleryAlbums> createState() => _GalleryAlbumsState();
}

class _GalleryAlbumsState extends State<GalleryAlbums> {
  bool loading = true;
  List<albumData> albums = [];

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    setState(() => loading = true);

    final response = await GalleryService.getAlbums();
    if (!mounted) return;

    setState(() {
      loading = false;
      albums = response?.data ?? [];
    });

    /// 🔥 THIS LINE WAS MISSING
    final count =
        int.tryParse(response?.requestedCount?.toString() ?? '0') ?? 0;

    context.read<CartProvider>().setRequestedCount(count);
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().requestedCount;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Photos Gallery'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        child: Stack(
          children: [
            const Center(child: Icon(Icons.shopping_cart)),
            if (cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
      body: AppBackground(
        child:
            loading
                ? const Center(child: CircularProgressIndicator())
                : albums.isEmpty
                ? const Center(child: Text('No albums available'))
                : GridView.builder(
                  padding: EdgeInsets.all(20.w),
                  itemCount: albums.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25.w,
                    mainAxisSpacing: 30.h,
                  ),
                  itemBuilder: (_, i) {
                    final album = albums[i];
                    return GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => AlbumPhotos(
                                    eventSer: album.eventSer!,
                                    albumName: album.eventName ?? '',
                                  ),
                            ),
                          ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_album,
                            size: 60.sp,
                            color: Colors.blue,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            album.eventName ?? '',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${album.count ?? 0} photos',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
