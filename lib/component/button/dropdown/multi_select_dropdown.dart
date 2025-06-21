import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/theme/my_color.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final List<String> selectedValues;
  final Function(List<String>) onChanged;
  final FormFieldValidator<List<String>>? validator;

  const MultiSelectDropdown({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.validator,
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List<String> selectedItems = [];
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.selectedValues);
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

  String _getDisplayText() {
    if (selectedItems.isEmpty) {
      return "Select team members";
    }
    if (selectedItems.length == 1) {
      return selectedItems.first;
    }
    return "${selectedItems.length} members selected";
  }

  void _setFocused(bool focused) {
    if (mounted) {
      setState(() {
        _isFocused = focused;
      });
    }
  }

  void _updateSelection(String item, FormFieldState<List<String>> field) {
    if (mounted) {
      setState(() {
        if (selectedItems.contains(item)) {
          selectedItems.remove(item);
        } else {
          selectedItems.add(item);
        }
        widget.onChanged(selectedItems);
        field.didChange(selectedItems);
      });
    }
  }

  void _removeItem(String item, FormFieldState<List<String>> field) {
    if (mounted) {
      setState(() {
        selectedItems.remove(item);
        widget.onChanged(selectedItems);
        field.didChange(selectedItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: selectedItems,
      validator: widget.validator,
      builder: (FormFieldState<List<String>> field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Assign to",
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
              child: DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getBorderColor(hasError),
                      width: hasError ? 1.5 : (_isFocused ? 2 : 1.5),
                    ),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    isDense: false,
                    icon: Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey.shade500,
                      size: 14,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                    dropdownColor: Colors.white,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    onChanged: (String? value) {
                      // This is required but we handle selection in the items
                    },
                    onTap: () {
                      _setFocused(true);
                    },
                    items:
                        widget.options.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: StatefulBuilder(
                              builder: (context, setMenuState) {
                                final isSelected = selectedItems.contains(item);
                                return InkWell(
                                  onTap: () {
                                    _updateSelection(item, field);
                                    if (mounted) {
                                      setMenuState(() {});
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? Colors.blue.shade600
                                                    : Colors.transparent,
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? Colors.blue.shade600
                                                      : Colors.grey.shade400,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child:
                                              isSelected
                                                  ? Icon(
                                                    FontAwesomeIcons.check,
                                                    color: Colors.white,
                                                    size: 12,
                                                  )
                                                  : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  isSelected
                                                      ? Colors.blue.shade700
                                                      : Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),

                    value: null, // Don't set a value for multi-select
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
                            FluentIcons.people_community_48_filled,
                            color:
                                _isFocused
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade600,
                            size: 20,
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
                                  selectedItems.isEmpty
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Selected items chips
            if (selectedItems.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    selectedItems.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                _removeItem(item, field);
                              },
                              child: Icon(
                                FontAwesomeIcons.xmark,
                                size: 10,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],

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

  @override
  void dispose() {
    // Don't call setState in dispose, just clean up
    super.dispose();
  }
}
