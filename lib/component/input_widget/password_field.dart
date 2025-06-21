import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/services/validators.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController password;
  final String fieldLabel;
  final String hintText;
  final Color? backgroundColor;
  final TextInputAction? textInputAction;
  final bool? needTitle;
  final TextStyle? titleStyle;
  final FormFieldValidator<String>? validatorClass;

  const PasswordField({
    super.key,
    required this.password,
    required this.fieldLabel,
    required this.hintText,
    this.textInputAction,
    this.backgroundColor,
    this.needTitle,
    this.titleStyle,
    this.validatorClass,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool hidePassword = true;
  bool hasSomePassword = false;

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
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _togglePasswordVisibility() {
    if (mounted) {
      setState(() {
        hidePassword = !hidePassword;
      });
    }
  }

  void _updatePasswordState(String value) {
    if (mounted) {
      setState(() {
        hasSomePassword = value.isNotEmpty;
      });
    }
  }

  Color _getBorderColor() {
    if (_isFocused) return Colors.blue.shade500;
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
            controller: widget.password,
            focusNode: _focusNode,
            obscureText: hidePassword,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: Colors.white,

              // Suffix icon for password visibility toggle
              suffixIcon:
                  hasSomePassword
                      ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          onPressed: _togglePasswordVisibility,
                          icon: Icon(
                            hidePassword
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            size: 18,
                            color:
                                _isFocused
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade600,
                          ),
                        ),
                      )
                      : null,

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
                widget.validatorClass ?? ValidatorsClass().validatePassword,
            textInputAction: widget.textInputAction ?? TextInputAction.done,
            onFieldSubmitted: (value) {
              if (mounted) {
                widget.password.text = value;
              }
            },
            onChanged: _updatePasswordState,
          ),
        ),
      ],
    );
  }
}
