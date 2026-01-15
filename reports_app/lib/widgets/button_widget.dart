import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Text buttonText;
  final Icon? icon;
  final VoidCallback? handlePressed;
  final bool disabled;
  final double fontSize;
  final double buttonHeight;
  final double? buttonWidth;
  final double borderRadius;
  final bool fullWidth;
  final List<Color> gradientColors;
  final List<Color> disabledGradientColors;
  final Color iconColor;
  final Color iconDisabledColor;
  final Color textColor;
  final Color textDisabledColor;

  const ButtonWidget({
    required this.buttonText,
    this.handlePressed,
    this.icon,
    this.disabled = false,
    this.fontSize = 14.0,
    this.buttonHeight = 70,
    this.buttonWidth,
    this.borderRadius = 6.0,
    this.fullWidth = false,
    this.gradientColors = const [Color(0xFFF2994A), Color(0xFFF2C94C)],
    this.disabledGradientColors = const [Color(0xFF3A3B3C), Color(0xFF3A3B3C)],
    this.iconColor = const Color(0xFF2f2f2f),
    this.iconDisabledColor = const Color(0xFFB0B3B8),
    this.textColor = const Color(0xFF2f2f2f),
    this.textDisabledColor = const Color(0xFFB0B3B8),
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: buttonHeight,
        width: fullWidth ? double.infinity : buttonWidth,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: disabled ? disabledGradientColors : gradientColors,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: disabled ? null : handlePressed,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon!.icon,
                        size: icon!.size ?? fontSize,
                        color: disabled ? iconDisabledColor : iconColor,
                      ),
                      const SizedBox(width: 8),
                    ],
                    DefaultTextStyle(
                      style: TextStyle(
                        color: disabled ? textDisabledColor : textColor,
                        fontSize: buttonText.style?.fontSize ?? fontSize,
                        fontWeight:
                            buttonText.style?.fontWeight ?? FontWeight.normal,
                      ),
                      child: buttonText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

ButtonStyle successDisabledStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(const Color(0xFF3A3B3C)),
  foregroundColor: WidgetStateProperty.all(const Color(0xFFB0B3B8)),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
  ),
);
