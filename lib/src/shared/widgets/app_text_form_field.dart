import 'package:flutter/material.dart';
    
class AppTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final TextInputType?  keyboardType;
  final String? label;
  final String? hint;
  final bool? obscureText;
  final InputBorder? border;
  final bool outline;

  const AppTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.onSaved,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.keyboardType,
    this.label,
    this.hint,
    this.obscureText,
    this.border,
    this.outline = false,
  });

  @override
  _AppTextFormFieldState createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = !(widget.obscureText ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: widget.label,
        border: !widget.outline ? null : const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        filled: widget.outline,
        // enabledBorder: widget.border,
        // focusedErrorBorder: border.copyWith(borderSide: const BorderSide(color: Colors.red)),
        // focusedBorder: border.copyWith(borderSide: BorderSide(color: (AppColors.textColor).withOpacity(0.5))),
        hintText: widget.hint,
        // errorBorder: border.copyWith(borderSide: const BorderSide(color: Colors.red)),
        // errorText: errorText,
        suffixIcon: widget.obscureText == null ? null : IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible
              ? Icons.visibility
              : Icons.visibility_off,
            // color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      // This optional block of code can be used to run
      // code when the user saves the form.
      onSaved: widget.onSaved,
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    widget.controller.dispose();
    super.dispose();
  }
}