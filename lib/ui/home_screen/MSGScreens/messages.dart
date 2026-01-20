import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/MSGScreens/sendMessagesScreen.dart';
import 'package:oasisathletic/ui/home_screen/MSGScreens/widgets/messages_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/model/msgsModels/BaseMessage.dart';
import '../../../core/model/msgsModels/Inbox.dart';
import '../../../core/model/msgsModels/Sent.dart';
import '../../../core/model/msgsModels/message-mapper.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/services/sideMenu/messagesServices/getMessagesInboxService.dart';
import 'MessageDetailsScreen.dart';

class Messages extends StatefulWidget {
  static const routeName = '/messages';
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String selectedFilter = "All";
  String selectedTab = "Inbox";

  List<Inbox> inboxMessages = [];
  List<Sent> sentMessages = [];
  Set<String> students = {};

  List<BaseMessage> inboxUI = [];
  List<BaseMessage> sentUI = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return;
      }

      final result = await GetMessagesInboxService.getMsgsInbox(token: token);

      setState(() {
        inboxMessages = result.inbox!;
        sentMessages = result.sent!;

        inboxUI = inboxMessages.map((m) => MessageMapper.fromInbox(m)).toList();
        sentUI = sentMessages.map((m) => MessageMapper.fromSent(m)).toList();

        students = {
          ...inboxUI.map((m) => m.studentNom),
          ...sentUI.map((m) => m.studentNom),
        };
        selectedFilter = "All";
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, isDark),
      body: AppBackground(
        useAppBarBlur: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              _buildTopTabs(isDark),
              SizedBox(height: 12.h),
              _buildFilterChips(isDark),
              SizedBox(height: 16.h),
              _buildMessagesList(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 AppBar
  // -------------------------------
  AppBar _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor:
          (isDark ? Colors.black54 : Colors.white.withOpacity(0.2)),
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
        'Messages',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            bottom: 10,
            right: 30,
            top: 10,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                sendMessagesScreen.routeName,
              );
            },
            child: Image.asset(
              "assets/images/compose.png",
              width: 30.w,
              height: 30.h,
            ),
          ),
        ),
      ],
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 Top Tabs (Inbox / Sent)
  // -------------------------------
  Widget _buildTopTabs(bool isDark) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.white10.withOpacity(0.2)
                : Colors.grey.shade200.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [_buildTopTab("Inbox", isDark), _buildTopTab("Sent", isDark)],
      ),
    );
  }

  Widget _buildTopTab(String title, bool isDark) {
    final bool isSelected = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = title),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isSelected
                    ? (isDark
                        ? Colors.blueAccent.withOpacity(0.3)
                        : Colors.white)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow:
                isSelected && !isDark
                    ? [BoxShadow(color: Colors.black12, blurRadius: 2)]
                    : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              color:
                  isSelected
                      ? (isDark ? Colors.white : Colors.black)
                      : (isDark ? Colors.white60 : Colors.grey),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 Filter Chips (All / Student 1 / Student 2)
  // -------------------------------
  Widget _buildFilterChips(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(label: "All", isDark: isDark, value: "All"),
          SizedBox(width: 8.w),

          ...students.map(
            (std) => Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _buildFilterChip(
                label: getFirstName(std),
                isDark: isDark,
                value: std,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isDark,
    required String value,
  }) {
    final bool selected = selectedFilter == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              selected
                  ? Colors.blue
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    List<BaseMessage> messagesToShow =
        selectedTab == "Inbox" ? inboxUI : sentUI;

    if (selectedFilter != "All") {
      messagesToShow =
          messagesToShow
              .where((msg) => msg.studentNom == selectedFilter)
              .toList();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: messagesToShow.length,
        itemBuilder: (context, index) {
          final msg = messagesToShow[index];
          final firstName = getFirstName(msg.studentNom); // ← هنا اقتطع الاسم

          return MessagesWidget(
            msg: msg,
            studentFirstName: firstName,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageDetailsScreen(message: msg),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getFirstName(String fullName) {
    if (fullName.trim().isEmpty) return "";
    return fullName.trim().split(" ").first;
  }
}
