import 'package:flutter/material.dart';
import 'package:protask/services/validators.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class MultilineInputField extends StatefulWidget {
  final TextEditingController controller;
  final String fieldLabel;
  final String hintText;
  final bool validation;
  final bool? needTitle;
  final String errorMessage;
  final TextInputAction? textInputAction;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final TextStyle? hintTextStyle;
  final TextStyle? inputTextStyle;
  final Key? itemkey;
  final TextStyle? titleStyle;
  final Widget? prefixWidget;
  final bool? viewOnly;
  final FormFieldValidator<String>? validatorClass;
  final TextInputType? inputType;
  final int numberOfLines;

  const MultilineInputField({
    super.key,
    required this.controller,
    required this.fieldLabel,
    required this.backgroundColor,
    required this.hintText,
    required this.validation,
    required this.errorMessage,
    this.needTitle,
    this.textInputAction,
    this.textAlign,
    this.hintTextStyle,
    this.itemkey,
    this.titleStyle,
    this.prefixWidget,
    this.viewOnly,
    this.validatorClass,
    this.inputTextStyle,
    this.inputType,
    required this.numberOfLines,
  });

  @override
  State<MultilineInputField> createState() => _MultilineInputFieldState();
}

class _MultilineInputFieldState extends State<MultilineInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Add mounted check to prevent setState on disposed widget
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  Color _getBorderColor() {
    if (_isFocused) return Colors.blue.shade500;
    if (widget.viewOnly == true) return Colors.grey.shade300;
    return Colors.grey.shade300;
  }

  Color _getLabelColor() {
    if (_isFocused) return Colors.blue.shade600;
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.needTitle ?? true) ...[
          Text(
            widget.fieldLabel,
            style:
                widget.titleStyle ??
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getLabelColor(),
                ),
          ),
          const SizedBox(height: 8),
        ],
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
          child: TextFormField(
            key: widget.itemkey,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.inputType ?? TextInputType.multiline,
            style:
                widget.inputTextStyle ??
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      widget.viewOnly == true
                          ? Colors.grey.shade600
                          : Colors.grey.shade800,
                  height: 1.4,
                ),
            readOnly: widget.viewOnly ?? false,
            maxLines: widget.numberOfLines,
            textAlign: widget.textAlign ?? TextAlign.start,
            textInputAction: widget.textInputAction ?? TextInputAction.newline,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              hintText: widget.hintText,
              hintStyle:
                  widget.hintTextStyle ??
                  TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
              filled: true,
              fillColor: MyColor.white,

              // Border styling
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _getBorderColor(), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade500, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade500, width: 2),
              ),

              // Error styling
              errorStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              errorMaxLines: 2,
            ),
            validator:
                widget.validatorClass ?? ValidatorsClass().noValidationRequired,
            onFieldSubmitted: (value) {
              // Add mounted check here too
              if (mounted) {
                widget.controller.text = value;
              }
            },
          ),
        ),
      ],
    );
  }
}
