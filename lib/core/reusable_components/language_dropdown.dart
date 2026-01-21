import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final bool isDarkMode;

  const LanguageDropdown({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      underline: const SizedBox(),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      items: const [
        DropdownMenuItem(value: Locale('en'), child: Text('English')),
        DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
      ],
      onChanged: (locale) async {
        if (locale == null) return;

        // 🔥 THIS IS THE KEY LINE
        await context.setLocale(locale);
      },
    );
  }
}
