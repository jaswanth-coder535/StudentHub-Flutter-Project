import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.success(String label, {IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppTheme.successLight,
      textColor: const Color(0xFF065F46),
      icon: icon ?? Icons.check_circle_outline,
    );
  }

  factory StatusBadge.warning(String label, {IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppTheme.warningLight,
      textColor: const Color(0xFF92400E),
      icon: icon ?? Icons.warning_amber_rounded,
    );
  }

  factory StatusBadge.danger(String label, {IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppTheme.dangerLight,
      textColor: const Color(0xFF991B1B),
      icon: icon ?? Icons.error_outline,
    );
  }

  factory StatusBadge.info(String label, {IconData? icon}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppTheme.primaryLightBlue,
      textColor: AppTheme.primaryDarkBlue,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
