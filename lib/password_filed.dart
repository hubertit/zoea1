import 'package:flutter/material.dart';
import 'constants/theme.dart';

class PasswordField extends StatefulWidget{
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final TextEditingController? controller;

  const PasswordField({super.key, this.validator, this.decoration, this.controller});
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool _obscure = true;

  Widget get icon=>InkWell(
    onTap: (){
      setState(() {
        _obscure = !_obscure;
      });
    },
    child: Icon(_obscure ? Icons.remove_red_eye : Icons.visibility_off),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF4D4D4D) : const Color(0xFFE0E0E0);
    
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
      ),
      cursorColor: Theme.of(context).primaryColor,
      decoration: (widget.decoration ?? const InputDecoration()).copyWith(
        suffixIcon: icon,
        filled: true,
        fillColor: isDark ? const Color(0xFF23242B) : Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? Theme.of(context).primaryColor : borderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}