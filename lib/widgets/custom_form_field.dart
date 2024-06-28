import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final bool? enabled;
  final Icon? suffixIcon;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;

  CustomFormField({
    required this.labelText,
    this.hintText,
    this.enabled,
    this.suffixIcon,
    this.initialValue,
    this.isPassword = false,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: GoogleFonts.lexend(
          color: Theme.of(context).focusColor,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.lexend(
            color: Theme.of(context).unselectedWidgetColor,
            fontSize: 14,
          ),
          errorStyle: GoogleFonts.lexend(
            color: Theme.of(context).focusColor,
            fontSize: 12,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).dialogBackgroundColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).dialogBackgroundColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).focusColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          suffixIcon: widget.suffixIcon ??
              (widget.isPassword
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).focusColor,
                      ),
                    )
                  : null),
        ),
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType:widget.isPassword
                ? TextInputType.visiblePassword
                : TextInputType.name,
        textInputAction: TextInputAction.next,
        enabled: widget.enabled,
        initialValue: widget.initialValue,
        validator: widget.validator,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
      ),
    );
  }
}
