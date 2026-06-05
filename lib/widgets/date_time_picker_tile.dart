import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_dimens.dart';

/// Tile reutilizable para seleccionar fecha u hora.
/// Reutilizado en calculator_page y history_page (edit dialog).
enum PickerMode { date, time }

class DateTimePickerTile extends StatelessWidget {
  final DateTime selectedTime;
  final ValueChanged<DateTime> onChanged;
  final PickerMode mode;
  final String label;

  const DateTimePickerTile({
    super.key,
    required this.selectedTime,
    required this.onChanged,
    required this.mode,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: () => _pick(context),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  mode == PickerMode.date ? Icons.calendar_today : Icons.access_time,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Text(
                mode == PickerMode.date
                    ? DateFormat.yMMMd().format(selectedTime)
                    : DateFormat.Hm().format(selectedTime),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 4),
              const ExcludeSemantics(
                child: Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    if (mode == PickerMode.date) {
      final date = await showDatePicker(
        context: context,
        initialDate: selectedTime,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context),
          child: child!,
        ),
      );
      if (date != null) {
        onChanged(DateTime(
          date.year, date.month, date.day,
          selectedTime.hour, selectedTime.minute,
        ));
      }
    } else {
      final now = DateTime.now();
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: selectedTime.hour,
          minute: selectedTime.minute,
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context),
          child: child!,
        ),
      );
      if (time != null) {
        final chosen = DateTime(
          selectedTime.year, selectedTime.month, selectedTime.day,
          time.hour, time.minute,
        );
        onChanged(chosen.isAfter(now) ? now : chosen);
      }
    }
  }
}
