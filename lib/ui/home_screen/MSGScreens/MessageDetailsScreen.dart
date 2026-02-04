import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/model/msgsModels/BaseMessage.dart';
import '../../webView-attachmentopener/AttachmentViewerScreen.dart';

class MessageDetailsScreen extends StatelessWidget {
  static const routeName = '/message-details';

  final BaseMessage message;
  final bool isSent;

  const MessageDetailsScreen({super.key, required this.message,this.isSent = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final originalAttachments = getOriginalAttachments(message);
    final replyAttachments = getReplyAttachments(message);

    final hasReply =
        message.replyStatus == 1 && (message.noteBodyReply?.trim().isNotEmpty ?? false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : Colors.white,

      // ✅ RESTORED APPBAR ✅
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black54 : Colors.white.withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white70 : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Message Details',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.enDesc,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              SizedBox(height: 8.h),

              Text(
                message.empName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              SizedBox(height: 12.h),

              Text(
                "Date: ${message.actualEditdate}",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),

              Divider(height: 30.h, thickness: 1),

              Text(
                message.noteSubject,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              SizedBox(height: 12.h),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message.message, style: TextStyle(fontSize: 16.sp)),
                      SizedBox(height: 16.h),

                      if (originalAttachments.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showAttachmentsPopup(
                                context,
                                originalAttachments,
                                title: "Original Attachments",
                              );
                            },
                            icon: const Icon(Icons.attach_file),
                            label: const Text("View Attachments"),
                          ),
                        ),

                      SizedBox(height: 20.h),

                      // ✅ Inbox only: show waiting text
                      if (!isSent && message.replyStatus == 0)
                        Text(
                          "Waiting for your reply...",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      // ✅ Inbox & Sent: show reply ONLY if it exists
                      if (hasReply) ...[
                        SizedBox(height: 12.h),
                        Text(
                          "Reply:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          message.noteBodyReply ?? '',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        SizedBox(height: 10.h),

                        if (replyAttachments.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showAttachmentsPopup(
                                  context,
                                  replyAttachments,
                                  title: "Reply Attachments",
                                );
                              },
                              icon: const Icon(Icons.attach_file),
                              label: const Text("Reply Attachments"),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ✅ ✅ ORIGINAL ATTACHMENTS
  List<String> getOriginalAttachments(BaseMessage message) {
    final files = [
      message.noteFile,
      message.noteFile2,
      message.noteFile3,
      message.noteFile4,
      message.noteFile5,
    ];

    return files.whereType<String>().where((e) => e.isNotEmpty).toList();
  }

  // ✅ ✅ REPLY ATTACHMENTS
  List<String> getReplyAttachments(BaseMessage message) {
    final files = [
      message.noteFileReply,
      message.noteFile2Reply,
      message.noteFile3Reply,
      message.noteFile4Reply,
      message.noteFile5Reply,
    ];

    return files.whereType<String>().where((e) => e.isNotEmpty).toList();
  }

  // ✅ ✅ ATTACHMENTS POPUP
  // void _showAttachmentsPopup(
  //     BuildContext context,
  //     List<String> files, {
  //       required String title,
  //     }) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Padding(
  //           padding: EdgeInsets.all(16.w),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 18.sp,
  //                 ),
  //               ),
  //
  //               SizedBox(height: 12.h),
  //
  //               ...files.map((file) {
  //                 final fileName = file.split('/').last;
  //
  //                 return ListTile(
  //                   leading: const Icon(Icons.insert_drive_file),
  //                   title: Text(
  //                     fileName,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   onTap: () {
  //                     // ✅ TODO: Open PDF / Image / Download
  //                     Navigator.pop(context);
  //                   },
  //                 );
  //               }).toList(),
  //
  //               SizedBox(height: 10.h),
  //
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text("Close"),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showAttachmentsPopup(
    BuildContext context,
    List<String> files, {
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 12.h),

                ...files.map((file) {
                  final fileName = file.split('/').last;

                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(fileName, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttachmentViewerScreen(url: file),
                        ),
                      );
                      //_openAttachment(context, file);
                      print(file);
                    },
                  );
                }),

                SizedBox(height: 10.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// void _openAttachment(BuildContext context, String url) {
//   final lowerUrl = url.toLowerCase();
//
//   // ✅ If link → open WebView
//   if (lowerUrl.startsWith("http")) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => WebViewScreen(
//           url: url,
//           title: "Attachment",
//         ),
//       ),
//     );
//   }
//
//   // ✅ If file inside server (PDF / Image / DOC)
//   else {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => WebViewScreen(
//           url: url,
//           title: "Document",
//         ),
//       ),
//     );
//   }
// }

// Widget buildAttachmentButton(String title, String? fileUrl) {
//   if (fileUrl == null || fileUrl.isEmpty) return const SizedBox();
//
//   return InkWell(
//     onTap: () => openAttachment(context, fileUrl),
//     child: Container(
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.blue.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.attachment),
//           const SizedBox(width: 10),
//           Expanded(child: Text(title)),
//         ],
//       ),
//     ),
//   );
// }
