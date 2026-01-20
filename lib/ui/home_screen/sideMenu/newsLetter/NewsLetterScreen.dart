import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/model/sideMenu/newsLetter/NewsLetterItem.dart';
import '../../../../core/reusable_components/app_background.dart';
import '../../../../core/services/sideMenu/StdNewsLetterService.dart';
import '../../../webView-attachmentopener/openAttachment.dart';

class NewsLetterScreen extends StatefulWidget {
  const NewsLetterScreen({super.key});
  static const routeName = '/Newsletter';

  @override
  State<NewsLetterScreen> createState() => _NewsLetterScreenState();
}

class _NewsLetterScreenState extends State<NewsLetterScreen> {
  bool loading = true;
  List<NewsLetterItem> _items = [];

  @override
  void initState() {
    super.initState();
    loadNewsLetter();
  }

  Future<void> loadNewsLetter() async {
    setState(() => loading = true);

    final data = await StdNewsLetterService.getNewsLetter();
    if (!mounted) return;

    if (data == null || data.data.isEmpty) {
      setState(() {
        loading = false;
        _items = [];
      });
      return;
    }
    print('SERVICE NewsLetter type: ${data.runtimeType}');
    print('SERVICE data length: ${data.data.length}');
    setState(() {
      loading = false;
      _items =
          data.data.map((e) {
            return NewsLetterItem(
              date: e.newsDate,
              url: e.fullPathE.isNotEmpty ? e.fullPathE : e.fullPathF,
            );
          }).toList();
    });

    // 🔍 DEBUG
    print("📰 Newsletters rendered: ${_items.length}");
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;

    final Color accentSky = ColorsManager.accentSky;
    final Color accentMint = ColorsManager.accentMint;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Newsletters'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                /// HEADER
                Text(
                  'School Newsletters',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),

                SizedBox(height: 14.h),

                /// CONTENT
                Expanded(
                  child:
                      loading
                          ? const Center(child: CircularProgressIndicator())
                          : _items.isEmpty
                          ? _emptyState(context)
                          : ListView.builder(
                            padding: EdgeInsets.only(bottom: 20.h),
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14.h),
                                child: _newsletterCard(
                                  context: context,
                                  item: item,
                                  primaryBlue: primaryBlue,
                                  accentSky: accentSky,
                                  accentMint: accentMint,
                                ),
                              );
                            },
                          ),
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// === NEWSLETTER CARD (Gamma-style) ===
  Widget _newsletterCard({
    required BuildContext context,
    required NewsLetterItem item,
    required Color primaryBlue,
    required Color accentSky,
    required Color accentMint,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => openAttachment(context, item.url),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryBlue.withOpacity(0.95),
                accentSky.withOpacity(0.85),
                accentMint.withOpacity(0.75),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.20),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          child: Row(
            children: [
              /// ICON BUBBLE
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.16),
                ),
                child: const Icon(
                  Icons.newspaper,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              SizedBox(width: 14.w),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Tap to open newsletter',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.9),
                size: 28.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// === EMPTY STATE ===
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.newspaper_outlined,
              size: 48.sp,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
            ),
            SizedBox(height: 12.h),
            Text(
              'No newsletters available',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
