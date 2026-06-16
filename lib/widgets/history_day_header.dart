import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date separator row shown between day groups in history.
class HistoryDayHeader extends StatelessWidget {
  final DateTime date;
  final double? dailyTotalCarbs;
  final int? dailyMealCount;

  const HistoryDayHeader({
    super.key,
    required this.date,
    this.dailyTotalCarbs,
    this.dailyMealCount,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final dateStr = DateFormat('EEEE, d MMMM', locale).format(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              dateStr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.teal,
              ),
            ),
          ),
          if (dailyTotalCarbs != null) ...[
            Text(
              '${dailyTotalCarbs!.toStringAsFixed(0)}g HC',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          if (dailyMealCount != null) ...[
            const SizedBox(width: 8),
            Text(
              '$dailyMealCount comidas',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
