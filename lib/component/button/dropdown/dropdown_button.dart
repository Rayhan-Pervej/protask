import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/theme/my_color.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final FormFieldValidator<T>? validator;
  final String hint;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    required this.hint,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isFocused = false;

  Color _getBorderColor(bool hasError) {
    if (hasError) return Colors.red.shade500;
    if (_isFocused) return Colors.blue.shade500;
    return Colors.grey.shade300;
  }

  IconData _getIconData() {
    return widget.label.toLowerCase() == 'select project'
        ? FontAwesomeIcons.folderOpen
        : FontAwesomeIcons.tableCells;
  }

  void _setFocused(bool focused) {
    if (mounted) {
      setState(() {
        _isFocused = focused;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.value,
      validator: widget.validator,
      builder: (field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _isFocused ? Colors.blue.shade600 : Colors.grey.shade800,
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
              child: DropdownButtonFormField<T>(
                isExpanded: true,
                isDense: false,
                value: widget.value,
                validator: widget.validator,
                icon: Icon(
                  FontAwesomeIcons.chevronDown,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
                dropdownColor: Colors.white,
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  filled: true,
                  fillColor: MyColor.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _getBorderColor(hasError),
                      width: 1.4,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade500,
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red.shade500,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: widget.items,
                onChanged: (value) {
                  if (mounted) {
                    widget.onChanged(value);
                    field.didChange(value);
                    _setFocused(false); // Reset focus after selection
                  }
                },
                onTap: () {
                  _setFocused(true);
                },
                hint: Row(
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
                        _getIconData(),
                        color:
                            _isFocused
                                ? Colors.blue.shade600
                                : Colors.grey.shade600,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.hint,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                selectedItemBuilder: (_) {
                  return widget.items.map((item) {
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color:
                                _isFocused
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            _getIconData(),
                            color:
                                _isFocused
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade600,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                            child: item.child,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 5),
              Text(
                field.errorText ?? '',
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

  @override
  void dispose() {
    // Don't call setState in dispose, just clean up
    super.dispose();
  }
}
