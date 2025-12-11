import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date formatter utility for localized date formatting
/// Automatically uses the current locale from context
class DateFormatter {
  /// Format date with full date and time
  /// Example: "Jan 15, 2024 • 14:30" (EN) or "15 Oca 2024 • 14:30" (TR)
  static String formatDateTime(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString()).add_Hm();
    return dateFormat.format(date);
  }

  /// Format date with short format (date only)
  /// Example: "Jan 15" (EN) or "15 Oca" (TR)
  static String formatDateShort(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.MMMd(locale.toString());
    return dateFormat.format(date);
  }

  /// Format date with medium format (date only, no time)
  /// Example: "Jan 15, 2024" (EN) or "15 Oca 2024" (TR)
  static String formatDateMedium(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toString());
    return dateFormat.format(date);
  }

  /// Format time only
  /// Example: "14:30" (both EN and TR)
  static String formatTime(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    final timeFormat = DateFormat.Hm(locale.toString());
    return timeFormat.format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "yesterday")
  /// Note: For full localization, add these strings to ARB files
  static String formatRelative(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final locale = Localizations.localeOf(context);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return locale.languageCode == 'tr' ? 'Az önce' : 'Just now';
        }
        return locale.languageCode == 'tr'
            ? '${difference.inMinutes} dk önce'
            : '${difference.inMinutes} min ago';
      }
      return locale.languageCode == 'tr'
          ? '${difference.inHours} saat önce'
          : '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return locale.languageCode == 'tr' ? 'Dün' : 'Yesterday';
    } else if (difference.inDays < 7) {
      return locale.languageCode == 'tr'
          ? '${difference.inDays} gün önce'
          : '${difference.inDays} days ago';
    } else {
      return formatDateMedium(context, date);
    }
  }
}
