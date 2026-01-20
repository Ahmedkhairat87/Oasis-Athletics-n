// lib/core/reusable_components/text_field.dart
import 'package:flutter/material.dart';
import '../colors_Manager.dart';

class CustomTextField extends StatefulWidget {
  final IconData hintIcon;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  // new optional params (non-breaking)
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.hintIcon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.obscureText = false,
    this.focusNode,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool passToggle = true;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    // listen to focus changes if a focusNode was passed
    widget.focusNode?.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      widget.focusNode?.addListener(_handleFocusChange);
    }
  }

  void _handleFocusChange() {
    final hasFocus = widget.focusNode?.hasFocus ?? false;
    // ignore: avoid_print
    print('CustomTextField("${widget.hint}") focus changed: $hasFocus');
    setState(() {
      _hasFocus = hasFocus;
    });
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;

    final Color borderIdle = scheme.onSurface.withOpacity(0.30);
    final Color borderFocused = primaryBlue;
    final Color fillColor = scheme.surface.withOpacity(0.96);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.97, end: 1.0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow:
                  _hasFocus
                      ? [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.22),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                      : [],
            ),
            child: child,
          ),
        );
      },
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText && passToggle,
        onTap: widget.onTap, // optional onTap to force focus if needed
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderIdle, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: borderFocused, width: 1.6),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: scheme.error, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: scheme.error, width: 1.2),
          ),
          hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: scheme.onSurface.withOpacity(0.45),
          ),
          // 🎨 joyful multicolor prefix chip
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8, right: 6),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    primaryBlue,
                    accentSky,
                    accentMint,
                    accentSun,
                    primaryBlue,
                  ],
                ),
              ),
              child: Center(
                child: Icon(widget.hintIcon, size: 18, color: Colors.white),
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          // password visibility toggle
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    onPressed: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    icon: Icon(
                      passToggle
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color:
                          _hasFocus
                              ? primaryBlue
                              : scheme.onSurface.withOpacity(0.6),
                      size: 22,
                    ),
                  )
                  : null,
          hintText: widget.hint,
        ),
      ),
    );
  }
}
