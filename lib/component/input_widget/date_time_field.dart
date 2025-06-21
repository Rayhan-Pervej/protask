import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/theme/my_color.dart';

class DateTimeFormField extends StatefulWidget {
  final String? initialValue;
  final String label;
  final DateTimePickerType type;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const DateTimeFormField({
    super.key,
    required this.label,
    required this.type,
    required this.initialValue,
    required this.onChanged,
    this.validator,
  });

  @override
  State<DateTimeFormField> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends State<DateTimeFormField> {
  bool _isFocused = false;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  Color _getBorderColor(bool hasError) {
    if (hasError) return Colors.red.shade500;
    if (_isFocused) return Colors.blue.shade500;
    return Colors.grey.shade300;
  }

  Color _getLabelColor() {
    if (_isFocused) return Colors.blue.shade600;
    return Colors.grey.shade700;
  }

  IconData _getIcon() {
    switch (widget.type) {
      case DateTimePickerType.date:
        return FontAwesomeIcons.calendar;
      case DateTimePickerType.time:
        return FontAwesomeIcons.clock;
      case DateTimePickerType.datetime:
        return FontAwesomeIcons.calendarDays;
    }
  }

  String _getDisplayText() {
    if (_selectedValue == null || _selectedValue!.isEmpty) {
      switch (widget.type) {
        case DateTimePickerType.date:
          return "Select Date";
        case DateTimePickerType.time:
          return "Select Time";
        case DateTimePickerType.datetime:
          return "Select Date & Time";
      }
    }
    return _selectedValue!;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _selectedValue,
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getLabelColor(),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow:
                    _isFocused
                        ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    setState(() {
                      _isFocused = true;
                    });

                    final result = await showBoardDateTimePicker(
                      context: context,
                      pickerType: widget.type,
                      options: BoardDateTimeOptions(
                        languages: BoardPickerLanguages(
                          today: "Today",
                          tomorrow: "Tomorrow",
                          now: 'Now',
                        ),
                        startDayOfWeek: DateTime.sunday,
                        pickerFormat: PickerFormat.dmy,
                        activeColor: Colors.blue.shade600,
                        backgroundDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );

                    setState(() {
                      _isFocused = false;
                    });

                    if (result != null) {
                      String formattedDateTime;
                      if (widget.type == DateTimePickerType.date) {
                        // Format only the date
                        formattedDateTime =
                            "${result.year}-${result.month.toString().padLeft(2, '0')}-${result.day.toString().padLeft(2, '0')}";
                      } else if (widget.type == DateTimePickerType.time) {
                        // Format only the time
                        formattedDateTime =
                            "${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}";
                      } else {
                        // Format date and time
                        formattedDateTime =
                            "${result.year}-${result.month.toString().padLeft(2, '0')}-${result.day.toString().padLeft(2, '0')} "
                            "${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}";
                      }

                      setState(() {
                        _selectedValue = formattedDateTime;
                      });

                      widget.onChanged(formattedDateTime);
                      field.didChange(formattedDateTime);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MyColor.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getBorderColor(hasError),
                        width: hasError ? 1.5 : (_isFocused ? 2 : 1.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _isFocused
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIcon(),
                            color:
                                _isFocused
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade600,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getDisplayText(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  (_selectedValue == null ||
                                          _selectedValue!.isEmpty)
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade800,
                            ),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.chevronDown,
                          color: Colors.grey.shade500,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (hasError) ...[
              const SizedBox(height: 6),
              Text(
                field.errorText ?? "",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
